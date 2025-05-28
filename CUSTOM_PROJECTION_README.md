# Camera3D 自定义投影矩阵功能

## 概述

现在 Camera3D 支持设置自定义投影矩阵，允许开发者完全控制相机的投影变换。这对于实现特殊的渲染效果、VR/AR 应用或自定义投影需求非常有用。

## 新增功能

### 新的投影类型
- `Camera3D.PROJECTION_CUSTOM` - 自定义投影矩阵模式

### 新的方法
- `set_projection_matrix(projection: Projection)` - 设置自定义投影矩阵，自动从矩阵中提取近远平面值
- `set_projection_matrix_with_planes(projection: Projection, z_near: float, z_far: float)` - 设置自定义投影矩阵并明确指定近远平面
- `get_projection_matrix() -> Projection` - 获取当前投影矩阵

## 使用示例

### 基本用法（推荐）
```gdscript
extends Node3D

func _ready():
    var camera = Camera3D.new()
    add_child(camera)
    
    # 创建自定义投影矩阵
    var custom_projection = Projection()
    custom_projection.set_perspective(75.0, 16.0/9.0, 0.1, 1000.0, false)
    
    # 设置自定义投影矩阵（自动提取 near/far 值）
    camera.set_projection_matrix(custom_projection)
    
    # 验证值
    print("投影模式: ", camera.get_projection()) # 输出: 3 (PROJECTION_CUSTOM)
    print("Near: ", camera.get_near())          # 输出: 0.1
    print("Far: ", camera.get_far())            # 输出: 1000.0
```

### 手动指定近远平面
```gdscript
func set_custom_projection_with_manual_planes():
    var camera = get_viewport().get_camera_3d()
    
    # 创建自定义投影矩阵
    var custom_projection = Projection()
    custom_projection.set_perspective(60.0, 16.0/9.0, 0.1, 2000.0, false)
    
    # 手动指定不同的近远平面值（覆盖矩阵中的值）
    camera.set_projection_matrix_with_planes(custom_projection, 0.05, 5000.0)
    
    print("Near: ", camera.get_near())  # 输出: 0.05 (手动指定的值)
    print("Far: ", camera.get_far())    # 输出: 5000.0 (手动指定的值)
```

### 正交投影示例
```gdscript
func create_orthographic_projection():
    var camera = get_viewport().get_camera_3d()
    
    # 创建正交投影矩阵
    var ortho_projection = Projection()
    ortho_projection.set_orthogonal(-10, 10, -10, 10, 1, 100)
    
    camera.set_projection_matrix(ortho_projection)
    print("Near: ", camera.get_near())  # 输出: 1.0
    print("Far: ", camera.get_far())    # 输出: 100.0
```

### 高级用法 - 非对称投影
```gdscript
func create_asymmetric_projection():
    var camera = get_viewport().get_camera_3d()
    
    # 创建非对称视锥体投影
    var custom_projection = Projection()
    custom_projection.set_frustum(2.0, Vector2(0.5, 0.2), 0.1, 100.0)
    
    camera.set_projection_matrix(custom_projection)
    print("Near: ", camera.get_near())  # 自动从矩阵提取
    print("Far: ", camera.get_far())    # 自动从矩阵提取
```

### VR/AR 用法示例
```gdscript
func setup_vr_projection(left_eye: bool):
    var camera = get_viewport().get_camera_3d()
    
    # VR 眼部投影矩阵示例
    var vr_projection = Projection()
    
    if left_eye:
        # 左眼投影设置
        vr_projection.set_frustum(2.0, Vector2(-0.1, 0.0), 0.01, 1000.0)
    else:
        # 右眼投影设置  
        vr_projection.set_frustum(2.0, Vector2(0.1, 0.0), 0.01, 1000.0)
    
    camera.set_projection_matrix(vr_projection)
    # near 和 far 值会自动从 VR 投影矩阵中提取
```

## 重要特性

### 自动近远平面提取
当使用 `set_projection_matrix(projection)` 时，系统会自动从投影矩阵中提取近平面和远平面的值：

```gdscript
var projection = Projection()
projection.set_perspective(60.0, 16.0/9.0, 0.1, 1000.0, false)

# 验证投影矩阵中的值
print("矩阵中的 near: ", projection.get_z_near())  # 0.1
print("矩阵中的 far: ", projection.get_z_far())    # 1000.0

# 设置后相机会自动使用这些值
camera.set_projection_matrix(projection)
print("相机的 near: ", camera.get_near())  # 0.1
print("相机的 far: ", camera.get_far())    # 1000.0
```

## 注意事项

1. **自动提取优先**：使用 `set_projection_matrix()` 时，近远平面值会自动从投影矩阵中提取
2. **手动覆盖**：使用 `set_projection_matrix_with_planes()` 可以手动指定不同的近远平面值
3. **坐标系**：Godot 使用右手坐标系，确保自定义投影矩阵与此一致
4. **属性面板**：在使用 `PROJECTION_CUSTOM` 模式时，编辑器中的 `near` 和 `far` 属性将变为只读

## API 参考

### set_projection_matrix(projection: Projection)
设置相机的自定义投影矩阵，并自动从矩阵中提取近远平面值。

**参数：**
- `projection`：要使用的投影矩阵

**行为：**
- 自动调用 `projection.get_z_near()` 和 `projection.get_z_far()` 来设置相机的近远平面
- 切换到 `PROJECTION_CUSTOM` 模式

### set_projection_matrix_with_planes(projection: Projection, z_near: float, z_far: float)
设置相机的自定义投影矩阵，并手动指定近远平面距离。

**参数：**
- `projection`：要使用的投影矩阵
- `z_near`：近平面距离（覆盖矩阵中的值）
- `z_far`：远平面距离（覆盖矩阵中的值）

**行为：**
- 使用手动指定的 near/far 值，不从矩阵中提取
- 切换到 `PROJECTION_CUSTOM` 模式

### get_projection_matrix() -> Projection
获取当前使用的投影矩阵。

**返回值：**
- `Projection`：当前的投影矩阵

## 故障排除

### 常见问题

1. **Near/Far 值不正确**：
   - 检查投影矩阵是否正确创建
   - 使用 `projection.get_z_near()` 和 `projection.get_z_far()` 验证矩阵中的值

2. **投影矩阵无效**：确保投影矩阵是有效的 4x4 矩阵
3. **渲染异常**：检查近远平面设置是否合理
4. **深度问题**：确保深度缓冲区设置与投影矩阵匹配

### 调试技巧

```gdscript
# 验证投影矩阵和相机设置
var camera = get_viewport().get_camera_3d()
if camera.get_projection() == Camera3D.PROJECTION_CUSTOM:
    var proj = camera.get_projection_matrix()
    print("当前投影矩阵:")
    for i in range(4):
        print(proj[i])
    
    print("矩阵中的 near: ", proj.get_z_near())
    print("矩阵中的 far: ", proj.get_z_far())
    print("相机的 near: ", camera.get_near())
    print("相机的 far: ", camera.get_far())
``` 
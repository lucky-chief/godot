# Camera3D 自定义投影矩阵功能

## 概述

现在 Camera3D 支持设置自定义投影矩阵，允许开发者完全控制相机的投影变换。这对于实现特殊的渲染效果、VR/AR 应用或自定义投影需求非常有用。

## 新增功能

### 新的投影类型
- `Camera3D.PROJECTION_CUSTOM` - 自定义投影矩阵模式

### 新的方法
- `set_projection_matrix(projection: Projection)` - 设置自定义投影矩阵
- `set_projection_matrix_with_planes(projection: Projection, z_near: float, z_far: float)` - 设置自定义投影矩阵并指定近远平面
- `get_projection_matrix() -> Projection` - 获取当前投影矩阵

## 使用示例

### 基本用法
```gdscript
extends Node3D

func _ready():
    var camera = Camera3D.new()
    add_child(camera)
    
    # 创建自定义投影矩阵
    var custom_projection = Projection()
    custom_projection.set_perspective(75.0, 16.0/9.0, 0.1, 1000.0, false)
    
    # 设置自定义投影矩阵
    camera.set_projection_matrix(custom_projection)
    
    # 检查投影模式
    print("投影模式: ", camera.get_projection()) # 输出: 3 (PROJECTION_CUSTOM)
```

### 带近远平面参数的用法
```gdscript
func set_custom_projection_with_planes():
    var camera = get_viewport().get_camera_3d()
    
    # 创建自定义投影矩阵
    var custom_projection = Projection()
    custom_projection.set_perspective(60.0, 16.0/9.0, 0.1, 2000.0, false)
    
    # 设置自定义投影矩阵并指定近远平面
    camera.set_projection_matrix_with_planes(custom_projection, 0.1, 2000.0)
```

### 高级用法 - 非对称投影
```gdscript
func create_asymmetric_projection():
    var camera = get_viewport().get_camera_3d()
    
    # 创建非对称视锥体投影
    var custom_projection = Projection()
    custom_projection.set_frustum(2.0, Vector2(0.5, 0.2), 0.1, 100.0)
    
    camera.set_projection_matrix(custom_projection)
```

### VR/AR 用法示例
```gdscript
func setup_vr_projection(left_eye: bool):
    var camera = get_viewport().get_camera_3d()
    
    # VR 眼部投影矩阵示例
    var custom_projection = Projection()
    
    if left_eye:
        # 左眼投影设置
        custom_projection.set_frustum(2.0, Vector2(-0.1, 0.0), 0.1, 1000.0)
    else:
        # 右眼投影设置  
        custom_projection.set_frustum(2.0, Vector2(0.1, 0.0), 0.1, 1000.0)
    
    camera.set_projection_matrix(custom_projection)
```

## 注意事项

1. **性能考虑**：设置自定义投影矩阵会绕过标准的投影计算，可能会影响某些优化
2. **近远平面**：确保自定义投影矩阵的近远平面设置合理，避免深度缓冲问题
3. **坐标系**：Godot 使用右手坐标系，确保自定义投影矩阵与此一致
4. **属性面板**：在使用 `PROJECTION_CUSTOM` 模式时，编辑器中的 `near` 和 `far` 属性将变为只读

## API 参考

### set_projection_matrix(projection: Projection)
设置相机的自定义投影矩阵。

**参数：**
- `projection`：要使用的投影矩阵

### set_projection_matrix_with_planes(projection: Projection, z_near: float, z_far: float)
设置相机的自定义投影矩阵，并同时设置近远平面距离。

**参数：**
- `projection`：要使用的投影矩阵
- `z_near`：近平面距离
- `z_far`：远平面距离

### get_projection_matrix() -> Projection
获取当前使用的投影矩阵。

**返回值：**
- `Projection`：当前的投影矩阵

## 故障排除

### 常见问题

1. **投影矩阵无效**：确保投影矩阵是有效的 4x4 矩阵
2. **渲染异常**：检查近远平面设置是否合理
3. **深度问题**：确保深度缓冲区设置与投影矩阵匹配

### 调试技巧

```gdscript
# 打印当前投影矩阵
var camera = get_viewport().get_camera_3d()
if camera.get_projection() == Camera3D.PROJECTION_CUSTOM:
    print("当前投影矩阵:")
    var proj = camera.get_projection_matrix()
    for i in range(4):
        print(proj[i])
``` 
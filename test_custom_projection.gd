extends Node3D

func _ready():
	# 获取相机
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		camera = Camera3D.new()
		add_child(camera)
	
	print("=== 测试 Camera3D 自定义投影矩阵功能 ===")
	
	# 测试1: 基本的 set_projection_matrix 方法
	print("\n1. 测试 set_projection_matrix(projection)")
	var custom_projection1 = Projection()
	custom_projection1.set_perspective(60.0, 16.0/9.0, 0.1, 1000.0, false)
	
	print("   原始投影矩阵的 near:", custom_projection1.get_z_near())
	print("   原始投影矩阵的 far:", custom_projection1.get_z_far())
	
	camera.set_projection_matrix(custom_projection1)
	print("   设置后相机投影模式:", camera.get_projection())
	print("   设置后相机 near:", camera.get_near())
	print("   设置后相机 far:", camera.get_far())
	print("   ✓ 验证: near 和 far 值应该匹配原始投影矩阵")
	
	# 测试2: set_projection_matrix_with_planes 方法
	print("\n2. 测试 set_projection_matrix_with_planes(projection, z_near, z_far)")
	var custom_projection2 = Projection()
	custom_projection2.set_perspective(75.0, 16.0/9.0, 0.05, 2000.0, false)
	
	camera.set_projection_matrix_with_planes(custom_projection2, 0.05, 2000.0)
	print("   投影模式:", camera.get_projection())
	print("   near:", camera.get_near())
	print("   far:", camera.get_far())
	print("   ✓ 验证: near=0.05, far=2000.0")
	
	# 测试3: 验证get_projection_matrix能返回正确的矩阵
	print("\n3. 测试 get_projection_matrix()")
	var retrieved_projection = camera.get_projection_matrix()
	print("   获取的投影矩阵第一行:", retrieved_projection[0])
	print("   从获取的矩阵提取 near:", retrieved_projection.get_z_near())
	print("   从获取的矩阵提取 far:", retrieved_projection.get_z_far())
	
	# 测试4: 切换回标准投影模式
	print("\n4. 测试切换回标准投影模式")
	camera.set_projection(Camera3D.PROJECTION_PERSPECTIVE)
	print("   投影模式:", camera.get_projection())
	
	# 测试5: 验证不同的投影矩阵类型
	print("\n5. 测试正交投影矩阵")
	var ortho_projection = Projection()
	ortho_projection.set_orthogonal(-10, 10, -10, 10, 1, 100)
	
	print("   正交投影矩阵 near:", ortho_projection.get_z_near())
	print("   正交投影矩阵 far:", ortho_projection.get_z_far())
	
	camera.set_projection_matrix(ortho_projection)
	print("   设置后相机 near:", camera.get_near())
	print("   设置后相机 far:", camera.get_far())
	
	print("\n=== 所有测试完成 ===")
	print("按 1 键测试非对称投影，按 2 键测试 VR 投影")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1:
			test_asymmetric_projection()
		elif event.keycode == KEY_2:
			test_vr_projection()

func test_asymmetric_projection():
	print("\n=== 非对称投影测试 ===")
	var camera = get_viewport().get_camera_3d()
	
	var custom_projection = Projection()
	custom_projection.set_frustum(2.0, Vector2(0.5, 0.2), 0.1, 100.0)
	
	print("非对称投影矩阵 near:", custom_projection.get_z_near())
	print("非对称投影矩阵 far:", custom_projection.get_z_far())
	
	camera.set_projection_matrix(custom_projection)
	print("设置后相机 near:", camera.get_near())
	print("设置后相机 far:", camera.get_far())

func test_vr_projection():
	print("\n=== VR投影测试 ===")
	var camera = get_viewport().get_camera_3d()
	
	# 模拟VR左眼投影
	var vr_projection = Projection()
	vr_projection.set_frustum(2.0, Vector2(-0.1, 0.0), 0.01, 1000.0)
	
	print("VR投影矩阵 near:", vr_projection.get_z_near())
	print("VR投影矩阵 far:", vr_projection.get_z_far())
	
	camera.set_projection_matrix(vr_projection)
	print("设置后相机 near:", camera.get_near())
	print("设置后相机 far:", camera.get_far()) 
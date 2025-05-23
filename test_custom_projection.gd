extends Node3D

func _ready():
	# 获取相机
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		camera = Camera3D.new()
		add_child(camera)
	
	# 创建一个自定义投影矩阵（透视投影）
	var custom_projection = Projection()
	custom_projection.set_perspective(60.0, 16.0/9.0, 0.1, 1000.0, false)
	
	# 设置自定义投影矩阵
	camera.set_projection_matrix(custom_projection)
	
	print("相机投影模式: ", camera.get_projection())
	print("自定义投影矩阵设置成功！")
	
	# 测试获取投影矩阵
	var retrieved_projection = camera.get_projection_matrix()
	print("获取的投影矩阵: ", retrieved_projection)
	
	# 测试带有近远平面参数的版本
	var custom_projection2 = Projection()
	custom_projection2.set_perspective(75.0, 16.0/9.0, 0.1, 2000.0, false)
	camera.set_projection_matrix_with_planes(custom_projection2, 0.1, 2000.0)
	print("使用带近远平面参数的方法设置成功！") 
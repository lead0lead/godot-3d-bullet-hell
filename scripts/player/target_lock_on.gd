extends Node

@export var detection_area_width_ratio := 0.5
@export var detection_area_height_ratio := 0.4
@onready var _camera: Node3D = %PlayerCamera

func _process(delta: float) -> void:
	pass

func find_lockon_targets() -> Array:
	var screen_size = get_viewport().size
	var detection_area_width = screen_size.x * detection_area_width_ratio
	var detection_area_height = screen_size.y * detection_area_height_ratio
	var detection_area_x_start = (screen_size.x - detection_area_width) / 2
	var detection_area_y_start = (screen_size.y - detection_area_height) / 2
	var detection_area_x_end = detection_area_x_start + detection_area_width
	var detection_area_y_end = detection_area_y_start + detection_area_height
	
	var possible_targets = get_tree().get_nodes_in_group("Enemy")
	
	var possible_targets_in_view = []
	for possible_target in possible_targets:
		if _camera.is_position_in_frustum(possible_target.global_position):
			possible_targets_in_view.append(possible_target)

	var possible_targets_in_detection_area = []
	for possible_target in possible_targets_in_view:
		var target_screen_pos = _camera.unproject_position(possible_target.global_position)
		if ((float(target_screen_pos.x) >= detection_area_x_start 
				and float(target_screen_pos.x) <= detection_area_x_end
				and float(target_screen_pos.y) >= detection_area_y_start
				and float(target_screen_pos.y) <= detection_area_y_end)):
			possible_targets_in_detection_area.append(possible_target)

	return possible_targets_in_detection_area

func find_nearest_lockon_target():
	var possible_targets := find_lockon_targets()
	if possible_targets:
		return possible_targets.reduce(func(smallest, current):
			if ((_camera.global_position 
					- current.global_position).angle_to(-_camera.global_basis.z) 
					> (_camera.global_position
					- smallest.global_position).angle_to(-_camera.global_basis.z)):
				return current
			else:
				return smallest)

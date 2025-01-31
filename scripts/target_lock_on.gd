extends Node

const DETECTION_AREA_WIDTH_RATIO := 0.5
const DETECTION_AREA_HEIGHT_RATIO := 0.4
@onready var _camera: Node3D = %PlayerCamera

func _process(delta: float) -> void:

	var screen_size = get_viewport().size
	var detection_area_width = screen_size.x * DETECTION_AREA_WIDTH_RATIO
	var detection_area_height = screen_size.x * DETECTION_AREA_HEIGHT_RATIO
	var detection_area_x_start = (screen_size.x - detection_area_width) / 2
	var detection_area_y_start = (screen_size.y - detection_area_width) / 2
	var detection_area_x_end = detection_area_x_start + detection_area_width
	var detection_area_y_end = detection_area_y_start + detection_area_height
	
	var possible_targets = get_tree().get_nodes_in_group("Enemy")
	possible_targets = possible_targets.map(func(possible_target):
		if possible_target is Node3D and _camera.is_position_in_frustum(possible_target.global_position):
			return possible_target)
	
	if possible_targets.size() > 0:
		possible_targets = possible_targets.map(func(possible_target):
			if not possible_target:
				return
			var target_screen_pos = _camera.unproject_position(possible_target.global_position)
			if possible_target != null and ((float(target_screen_pos.x) >= detection_area_x_start 
					and float(target_screen_pos.x) <= detection_area_x_end
					and float(target_screen_pos.y) >= detection_area_x_start
					and float(target_screen_pos.y) <= detection_area_y_end)):
				return possible_target)
				
	print(possible_targets)
	print(possible_targets.size())

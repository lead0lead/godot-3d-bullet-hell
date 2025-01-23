extends Camera3D

@export_range(0.0, 0.1) var camera_sensitivity := 0.0025

@export var max_cam_distance := 5.0

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _player := _camera_pivot.get_parent()

var _camera_input_direction := Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * camera_sensitivity
		
func _physics_process(delta: float) -> void:
	
	# handle camera rotation
	
	_camera_pivot.rotation.x += _camera_input_direction.y
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, 
		-PI / 2.0, PI / 2.0)
	_camera_pivot.rotation.y -= _camera_input_direction.x

	_camera_input_direction = Vector2.ZERO
	
	# handle camera positon
	
	var vector_to_player: Vector3 = (_player.global_position - 
		_camera_pivot.global_position)
	
	if vector_to_player.length() > max_cam_distance:
		_camera_pivot.position = (_player.position 
			- vector_to_player.normalized() 
			* max_cam_distance)
	else:
		_camera_pivot.position = lerp(_camera_pivot.position,
			 _player.position, 0.05)
	
	var vector_from_player: Vector3 = (_camera_pivot.position 
		- _player.position)
		
	var local_z_offset = (_camera_pivot.global_basis.z 
		* vector_from_player.dot(_camera_pivot.global_basis.z))
		
	if local_z_offset.length() > 0:
		_camera_pivot.position = _camera_pivot.position - local_z_offset

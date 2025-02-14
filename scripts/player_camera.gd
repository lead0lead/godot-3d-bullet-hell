extends Camera3D

@export_range(0.0, 0.1) var camera_sensitivity := 0.0025

@export var max_cam_x_distance := 12.0
@export var max_cam_y_distance := 3.0
@export var max_cam_z_distance := 1.0

@export var camera_speed := 0.02

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
	_handle_camera_position(delta)
	_handle_camera_rotation(delta)

func _handle_camera_rotation(delta):
	_camera_pivot.rotation.x += -_camera_input_direction.y
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, 
		-PI / 2.0, PI / 2.0)
	_camera_pivot.rotation.y -= _camera_input_direction.x

	_camera_input_direction = Vector2.ZERO
	
func _handle_camera_position(delta):
	var vector_from_player: Vector3 = (_camera_pivot.position 
		- _player.position)
	
	var local_x_offset = (_camera_pivot.global_basis.x 
		* vector_from_player.dot(_camera_pivot.global_basis.x))
		
	var local_y_offset = (_camera_pivot.global_basis.y 
		* vector_from_player.dot(_camera_pivot.global_basis.y))
		
	var local_z_offset = (_camera_pivot.global_basis.z 
		* vector_from_player.dot(_camera_pivot.global_basis.z))
		
	var x_offset_from_max = (local_x_offset.normalized() 
		* (local_x_offset.length() 
		- max_cam_x_distance))
		
	var y_offset_from_max = (local_y_offset.normalized() 
		* (local_y_offset.length() 
		- max_cam_y_distance))
		
	var z_offset_from_max = (local_z_offset.normalized() 
		* (local_z_offset.length() 
		- max_cam_z_distance))
		
	if local_x_offset.length() > max_cam_x_distance:
		_camera_pivot.position = (_camera_pivot.position - x_offset_from_max)
	else:
		_camera_pivot.position = lerp(_camera_pivot.position,
			 (_player.position + Vector3.UP), camera_speed)

	if local_y_offset.length() > max_cam_y_distance:
		_camera_pivot.position = (_camera_pivot.position - y_offset_from_max)
	else:
		_camera_pivot.position = lerp(_camera_pivot.position,
			 (_player.position + Vector3.UP), camera_speed)

	if local_z_offset.length() > max_cam_z_distance:
		_camera_pivot.position = (_camera_pivot.position - z_offset_from_max)
	else:
		_camera_pivot.position = lerp(_camera_pivot.position,
			 (_player.position + Vector3.UP), camera_speed)

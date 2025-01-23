extends Camera3D

@export_range(0.0, 0.1) var camera_sensitivity := 0.0025

@export var max_cam_distance := 3.0
@export var player: CharacterBody3D

@onready var _camera_pivot: Node3D = %PlayerCameraPivot

var _camera_input_direction := Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * camera_sensitivity
		
func _physics_process(delta: float) -> void:
	
	# handle camera positon
	
	var vector_to_player: Vector3 = (player.global_position 
		- _camera_pivot.global_position)
	var distance_to_player := vector_to_player.length()
	
	if distance_to_player > max_cam_distance:
		_camera_pivot.global_position = (player.global_position 
			- vector_to_player.normalized() 
			* max_cam_distance)
			
	
	# handle camera rotation
	
	_camera_pivot.rotation.x += _camera_input_direction.y
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, 
		-PI / 2.0, PI / 2.0)
	_camera_pivot.rotation.y -= _camera_input_direction.x

	_camera_input_direction = Vector2.ZERO

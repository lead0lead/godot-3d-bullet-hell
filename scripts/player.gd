extends CharacterBody3D
@export_group("Movement")
#@export var movement_speed := 8.0
@export var acceleration := 40.0
@export var rotation_speed := 8.0
@export var flight_impulse := 12.0
@export var friction := 5.0

@export_group("Skin")
@export var _skin: MeshInstance3D

@onready var _camera: Camera3D = %PlayerCamera
var _last_move_direction := Vector3.FORWARD
var _gravity := -50

func _physics_process(delta: float) -> void:
	
	var move_direction = Vector3.ZERO
	var player_input_direction = Input.get_vector("left", "right"
			, "forward", "back")
	
	var camera_forward = _camera.global_basis.z
	var camera_right = _camera.global_basis.x
	
	# handle player movement direction
	
	move_direction = camera_forward * player_input_direction.y + camera_right * player_input_direction.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var y_velocity := velocity.y
	velocity.y = 0.0
	
	# movement acceleration
	
	if move_direction.length() > 0:
		velocity += move_direction * acceleration * delta
	else:
		velocity = velocity.lerp(Vector3.ZERO, friction * delta)
	
	#velocity = velocity.move_toward(move_direction * movement_speed
			#, acceleration * delta)
	#
	velocity.y = y_velocity + _gravity * delta
	
	if Input.is_action_just_pressed("fly") and is_on_floor():
		velocity.y = flight_impulse
	
	move_and_slide()
	
	# handle visual rotation of character model
	
	if move_direction.length() > 0.0:
		_last_move_direction = move_direction

	var target_angle := Vector3.FORWARD.signed_angle_to(_last_move_direction
		, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y
		, target_angle, rotation_speed * delta)

extends CharacterBody3D
class_name Player

@export var _skin: MeshInstance3D

@export_group("Movement")
@export var movement_speed := 10.0
@export var acceleration := 80.0
@export var rotation_speed := 8.0
@export var jump_impulse := 14.0
@export var dash_impulse := 30.0
@export var flight_speed := 20.0
@export var flight_acceleration := 120.0
@export var glide_speed := 0.4

@export var air_movement_speed := 7.5

@onready var _camera: Camera3D = %PlayerCamera

var _move_direction = Vector3.ZERO
var _last_move_direction := Vector3.FORWARD
var gravity := -50
var boosting: bool = false
var flying: bool = false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		boosting = true
	else:
		boosting = false
		
	_rotate_player_model(delta)
	_handle_movement(delta)

func _handle_movement(delta):
	
	var player_input_direction = Input.get_vector("left", "right"
		, "forward", "back")
	
	var camera_forward = _camera.global_basis.z
	var camera_right = _camera.global_basis.x

	if not boosting:
		if Input.is_action_pressed("jump") and not is_on_floor() and velocity.y <= 0:
			velocity.y *= glide_speed
		_move_direction = camera_forward * player_input_direction.y + camera_right * player_input_direction.x
		_move_direction.y = 0.0
		_move_direction = _move_direction.normalized()

		var y_velocity := velocity.y
		velocity.y = 0.0
		
		velocity = velocity.move_toward(_move_direction * movement_speed
				, acceleration * delta)
		
		velocity.y = y_velocity + gravity * delta
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_impulse
		
		if Input.is_action_just_pressed("dash"):
			_dash()

	else:
		_move_direction = ( -camera_forward 
			+ camera_right * 
			player_input_direction.x)
		velocity = velocity.move_toward(_move_direction * flight_speed, flight_acceleration * delta)

	move_and_slide()

	print("current speed: ", velocity.length())

func _rotate_player_model(delta):
	if _move_direction.length() > 0.0:
		_last_move_direction = _move_direction

	var target_angle := Vector3.FORWARD.signed_angle_to(_last_move_direction
		, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y
		, target_angle, rotation_speed * delta)
		
func _dash():
	var y_velocity = velocity.y
	velocity = velocity.normalized() * (velocity.length() + dash_impulse)
	velocity.y = y_velocity
	

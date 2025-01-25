extends CharacterBody3D

@export var _skin: MeshInstance3D

@export_group("Movement")
@export var movement_speed := 10.0
@export var acceleration := 80.0
@export var deceleration := 40.0
@export var rotation_speed := 8.0
@export var jump_impulse := 14.0
@export var flight_impulse := 8.0
@export var dash_impulse := 40.0

@onready var _camera: Camera3D = %PlayerCamera

var _move_direction = Vector3.ZERO
var _last_move_direction := Vector3.FORWARD
var _gravity := -50

var flying: bool = false

var dashing: bool = false
var dash_velocity = Vector3.ZERO
var dash_timer := 0.0
var dash_duration := 0.2

func _physics_process(delta: float) -> void:
	_rotate_player_model(delta)
	_handle_movement(delta)

func _handle_movement(delta):
	var player_input_direction = Input.get_vector("left", "right"
			, "forward", "back")
	
	var camera_forward = _camera.global_basis.z
	var camera_right = _camera.global_basis.x

	_move_direction = camera_forward * player_input_direction.y + camera_right * player_input_direction.x
	_move_direction.y = 0.0
	_move_direction = _move_direction.normalized()

	var y_velocity := velocity.y
	velocity.y = 0.0
	
	velocity = velocity.move_toward(_move_direction * movement_speed
			, acceleration * delta)
	
	
	velocity.y = y_velocity + _gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_impulse
		velocity += dash_velocity
	
	if Input.is_action_just_pressed("dash"):
		_dash()
		
	if dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false
			dash_velocity = Vector3.ZERO

	move_and_slide()

	print("current speed: ", velocity.length())
	if Input.is_action_just_pressed("toggle_flight"):
		if not flying:
			flying = true
			print("flying on")
		else:
			flying = false
			print("flying off")

	_handle_flight()

func _rotate_player_model(delta):
	if _move_direction.length() > 0.0:
		_last_move_direction = _move_direction

	var target_angle := Vector3.FORWARD.signed_angle_to(_last_move_direction
		, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y
		, target_angle, rotation_speed * delta)

func _handle_flight():
	if flying == true:
		velocity.y = 0.0
		if Input.is_action_pressed("down"):
			velocity.y -= flight_impulse
		if Input.is_action_pressed("jump"):
			velocity.y += flight_impulse
	else:
		pass

func _dash():
	dashing = true
	dash_velocity = velocity.normalized() * (velocity.length() + dash_impulse)
	var y_velocity = velocity.y
	velocity = dash_velocity
	velocity.y = y_velocity
	dash_timer = dash_duration

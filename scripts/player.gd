extends CharacterBody3D
class_name Player

@export var _skin: Node3D
@export var _ranged_weapon: Node3D
@export var lock_on_target: Node3D

@export_group("Movement")
@export var movement_speed := 10.0
@export var acceleration := 80.0
@export var flight_speed := 7.5
@export var flight_acceleration := 60.0
@export var boost_speed := 30.0
@export var boost_acceleration := 120.0

@export var fligt_ascension_speed := flight_speed * 10
@export var flight_descension_speed := - flight_speed * 10

@export var rotation_speed := 8.0
@export var jump_impulse := 20.0
@export var dash_speed := 30.0
@export var glide_speed := 0.5

@export_group("Health and Stamina")
@export var max_health := 100.0
@export var max_stamina := 100.0

@onready var _camera: Camera3D = %PlayerCamera
@onready var initital_mount_pos = _skin.mount.position
@onready var initital_mount_rotation = _skin.mount.rotation
@onready var speedlines = $PlayerUI/Speedlines
@onready var starting_fov := _camera.fov
@onready var boost_fov := starting_fov + 5.0


enum States {IDLE, WALKING, JUMPING, GLIDING, BOOSTING, DASHING, FLYING_IDLE, FLYING, FALLING}
var state := States.IDLE
var previous_state := state

var _move_direction = Vector3.ZERO
var _last_move_direction := Vector3.FORWARD

var gravity := -110.0
var applied_gravity := gravity

var applied_movement_speed := movement_speed
var applied_acceleration := acceleration

var enter_state_time: float

var current_health := max_health
var current_stamina := max_stamina

const JUMP_TIMING := 0.0
const JUMP_TRANSITION_TIMING := 0.0

func _physics_process(delta: float) -> void:
	
	var player_input_direction = Input.get_vector("left", "right"
		, "forward", "back")
	
	var camera_forward = _camera.global_basis.z
	var camera_right = _camera.global_basis.x

	# Attacking
	
	if Input.is_action_pressed("fire"):
		_ranged_weapon.fire()
		
	#if Input.is_action_just_pressed("heavy-fire"):
		#_ranged_weapon.heavy_fire()
	#
	
	# State Machine

	if state == States.FALLING:
		if is_on_floor():
			set_state(States.IDLE)
	
	if velocity.length() == 0:
		if state not in [States.FLYING_IDLE, States.FLYING]:
			set_state(States.IDLE)
		else:
			set_state(States.FLYING_IDLE)

	if not is_on_floor() and state not in [States.JUMPING, States.BOOSTING, States.DASHING, States.FLYING_IDLE, States.FLYING]:
		set_state(States.FALLING)

	if state == States.GLIDING:
		if Input.is_action_just_released("jump"):
			set_state(States.FALLING)

	if state == States.IDLE and player_input_direction != Vector2.ZERO:
		set_state(States.WALKING)

	if state == States.FLYING_IDLE and player_input_direction != Vector2.ZERO:
		set_state(States.FLYING)

	if is_on_floor() and state in [States.IDLE, States.WALKING]:
		if Input.is_action_just_pressed("jump"):
			set_state(States.JUMPING)

	if state == States.FALLING and Input.is_action_pressed("jump"):
		set_state(States.GLIDING)
		
	if Input.is_action_pressed("boost"):
		set_state(States.BOOSTING)
		
	if state == States.BOOSTING:
		_move_direction = ( -camera_forward 
			+ camera_right * 
			player_input_direction.x)
			
		if Input.is_action_just_released("boost"):
			set_state(previous_state)
	
	if state not in [States.BOOSTING, States.DASHING] and Input.is_action_just_pressed("dash"):
		set_state(States.DASHING)

	if state not in [States.BOOSTING]:
		if Input.is_action_just_pressed("toggle-flight"):
			if state in [States.FLYING_IDLE, States.FLYING]:
				set_state(States.FALLING)
			else:
				set_state(States.FLYING_IDLE)
				
				
		_move_direction = camera_forward * player_input_direction.y + camera_right * player_input_direction.x
		_move_direction = _move_direction.normalized()
	
	if state not in [ States.BOOSTING, States.FLYING_IDLE, States.FLYING]:
		_move_direction.y = 0.0
		
	if state in [States.FLYING_IDLE, States.FLYING]:
		if Input.is_action_pressed("jump"):
			_move_direction.y = Vector3.UP.normalized().y
		if Input.is_action_pressed("down"):
			_move_direction.y = Vector3.DOWN.normalized().y

	if state in [States.DASHING] and _move_direction.length() == 0.0:
		_move_direction = -camera_forward
	
	velocity = velocity.move_toward(_move_direction * applied_movement_speed, applied_acceleration * delta)
	
	velocity.y = velocity.y + applied_gravity * delta
	
	if state == States.JUMPING:
		if works_longer_than(JUMP_TRANSITION_TIMING):
			set_state(States.FALLING)

	if state in [States.DASHING]:
		velocity = velocity.normalized() * (velocity.length() + dash_speed)
		velocity.y = 0
		set_state(previous_state)
		

	move_and_slide()
	_rotate_player_model(delta)

func _rotate_player_model(delta):
	if _move_direction.length() > 0.0:
		_last_move_direction = _move_direction

	# Replace Vector3.BACK with Vector3.FORWARD once animation issues have been 
	# fixed and new animation system is implemented
	
	var target_angle := Vector3.BACK.signed_angle_to(_last_move_direction
		, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y
		, target_angle, rotation_speed * delta)

func set_state(new_state: int) -> void:
	
	if state != new_state:
		previous_state = state
		state = new_state
		mark_enter_state()

	if previous_state in [States.BOOSTING]:
		speedlines.visible = false
		_camera.fov = starting_fov
		
	if previous_state in [States.GLIDING, States.BOOSTING, States.FLYING_IDLE, States.FLYING]:
		applied_gravity = gravity

	if previous_state in [States.FLYING_IDLE, States.FLYING, States.BOOSTING]:
		applied_movement_speed = movement_speed
		applied_acceleration = acceleration
		#_skin.mount.visible = false
		_skin.mount.position = initital_mount_pos
		_skin.mount.rotation = initital_mount_rotation

	if new_state == States.GLIDING:
		applied_gravity = gravity * glide_speed
		_skin.animation_player.play("Gliding")

	if new_state == States.FALLING:
		_skin.animation_player.play("Gliding")

	if new_state in [States.FLYING, States.FLYING_IDLE]:
		applied_gravity = 0.0
		applied_movement_speed = flight_speed
		applied_acceleration = flight_acceleration
		_skin.animation_player.play("Skating")
		#_skin.mount.visible = true
		_skin.mount.position = Vector3(0.0, 0.291, 0.0)
		_skin.mount.rotation = Vector3(0.0, -180.0, 0.0)
	
	if new_state in [States.BOOSTING]:
		applied_gravity = 0.0
		applied_movement_speed = boost_speed
		applied_acceleration = boost_acceleration
		_skin.animation_player.play("Skating")
		#_skin.mount.visible = true
		_skin.mount.position = Vector3(0.0, 0.291, 0.0)
		_skin.mount.rotation = Vector3(0.0, -180.0, 0.0)
		speedlines.visible = true
		_camera.fov = boost_fov
		

	if new_state in [States.WALKING]:
		_skin.animation_player.play("Running")

	if new_state in [States.IDLE]:
		_skin.animation_player.play("Idle")
	
	if new_state in [States.JUMPING]:
		velocity.y += jump_impulse
		_skin.animation_player.play("Gliding")
	
	# print(States.find_key(state))

func mark_enter_state():
	enter_state_time = Time.get_unix_time_from_system()

func get_state_progress() -> float:
	var now = Time.get_unix_time_from_system()
	return now - enter_state_time

func works_longer_than(time: float) -> bool:
	if get_state_progress() >= time:
		return true
	else:
		return false

func works_less_than(time: float) -> bool:
	if get_state_progress() < time:
		return true
	else:
		return false

func works_between(start: float, finish: float) -> bool:
	var progress = get_state_progress()
	if progress >= start and progress <= finish:
		return true
	else:
		return false

extends CharacterBody3D
@export_group("Ground Movement")
@export var movement_speed := 12.0
@export var ground_accel := 14.0
@export var ground_decel := 10.0
@export var rotation_speed := 8.0
@export var friction := 6.0

@export_group("Air Movement")
@export var flight_impulse := 12.0
@export var air_cap := 0.85
@export var air_accel := 800.0
@export var air_move_speed := 500.0

@export_group("Skin")
@export var _skin: MeshInstance3D

@onready var _camera: Camera3D = %PlayerCamera

var _move_direction = Vector3.ZERO
var _last_move_direction := Vector3.FORWARD
var _gravity := -50

func _physics_process(delta: float) -> void:
	
	var player_input_direction = Input.get_vector("left", "right"
			, "forward", "back")
	
	var camera_forward = _camera.global_basis.z
	var camera_right = _camera.global_basis.x
	
	# handle player movement direction
	
	_move_direction = camera_forward * player_input_direction.y + camera_right * player_input_direction.x
	_move_direction.y = 0.0
	_move_direction = _move_direction.normalized()
	
	if is_on_floor():
		_handle_ground_physics(delta)
		if Input.is_action_just_pressed("fly"):
			velocity.y = flight_impulse
	
	else: 
		_handle_air_physics(delta)
	
	#var y_velocity := velocity.y
	#velocity.y = 0.0
	#
	# movement acceleration
	#var scaled_accel = acceleration / (1.0 + velocity.length())
	#
	#if move_direction.length() > 0:
		#velocity += move_direction * scaled_accel * delta
	#else:
		#velocity = velocity.lerp(Vector3.ZERO, friction * delta)
	#
	#velocity = velocity.move_toward(move_direction * movement_speed
			#, acceleration * delta)
	#
	#velocity.y = y_velocity + _gravity * delta
	
	move_and_slide()
	
	# handle visual rotation of character model
	
	if _move_direction.length() > 0.0:
		_last_move_direction = _move_direction

	var target_angle := Vector3.FORWARD.signed_angle_to(_last_move_direction
		, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y
		, target_angle, rotation_speed * delta)

func is_surface_too_steep(normal: Vector3) -> bool:
	var max_slope_ang_dot = Vector3(0.0, 1.0, 0.0).rotated(Vector3(1.0, 0.0, 0.0), floor_max_angle).dot(Vector3(0.0, 1.0, 0.0))
	if normal.dot(Vector3(0.0, 1.0, 0.0)) < max_slope_ang_dot:
		return true
	return false
	
func _handle_air_physics(delta):
	velocity.y = velocity.y + _gravity * delta
	
	# Quake Style Air Physics
	
	var current_speed_in_move_dir = velocity.dot(_move_direction)
	var capped_speed = min((air_move_speed * _move_direction).length(), air_cap)
	var add_speed_till_cap = capped_speed - current_speed_in_move_dir
	
	if add_speed_till_cap > 0:
		var accel_speed = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * _move_direction
	
	if is_on_wall():
		if is_surface_too_steep(get_wall_normal()):
			motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
		else:
			motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
			
		clip_velocity(get_wall_normal(), 1, delta)
	
func _handle_ground_physics(delta):
	var current_speed_in_move_dir = velocity.dot(_move_direction)
	var add_speed_till_cap = movement_speed - current_speed_in_move_dir
	if add_speed_till_cap > 0:
		var accel_speed = ground_accel * delta * movement_speed
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * _move_direction
		
	# handle friction
	
	var control = max(velocity.length(), ground_decel)
	var drop = control * friction * delta
	var new_speed = max(velocity.length() - drop, 0.0)
	if velocity.length() > 0:
		new_speed /= velocity.length()
	velocity *= new_speed

func clip_velocity(normal: Vector3, overbounce: float, delta: float) -> void:
	var backoff := velocity.dot(normal) * overbounce
	if backoff >= 0: return
	var change := normal * backoff
	velocity -= change
	var adjust = velocity.dot(normal)
	if adjust < 0.0:
		velocity -= normal * adjust

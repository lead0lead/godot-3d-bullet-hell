extends Enemy
class_name FlyingEnemy

enum States {STATIONARY, PERSUING, PATROLLING, ROAMING, ATTACKING, EXPLODING}
var state := States.STATIONARY
var previous_state := state
@export var max_fire_distance := 10
@export var move_speed := 7.5
@export var roam_speed := 5.0
@export var exploding_speed := 3.0
@export var accel := 80.0
@export var explosion_range := 4.0
@export var explosion_tick_speed := 0.0
@export var explosion_tick_increase := 25.0
@export var explosion_damage := 40.0

var direction := Vector3.ZERO
var roaming_distance := 10.0
var current_roaming_target_pos: Vector3
var player_in_explosion_range: bool = false

@onready var roaming_pos_ray := $RoamingPosRay
@onready var explosion_timer := $ExplosionTimer
@onready var applied_move_speed := move_speed

func _ready() -> void:
	current_roaming_target_pos = find_roaming_position()
	set_state(States.ROAMING)
	roaming_pos_ray.target_position = Vector3(0, 0, roaming_distance)

	health_bar.init_health(health)

func _physics_process(delta: float) -> void:
	
	if not current_roaming_target_pos:
		current_roaming_target_pos = find_roaming_position()
	
	if state == States.STATIONARY:
		if is_player_in_line_of_sight(): 
			set_state(States.PERSUING)
		direction = Vector3.ZERO

	if state == States.ATTACKING:
		pass

	if state == States.PERSUING:
		if not is_player_in_line_of_sight():
			set_state(States.ROAMING)
		direction = global_position.direction_to(player.global_position)
		
		if global_position.distance_to(player.global_position) < explosion_range:
			set_state(States.EXPLODING)

	if state == States.ROAMING:
		if is_player_in_line_of_sight(): 
			set_state(States.PERSUING)

		direction = (current_roaming_target_pos - global_position).normalized()
		if global_position.distance_to(current_roaming_target_pos) < 1.0 or velocity.length() < 0.5:
			current_roaming_target_pos = find_roaming_position()
	
	if state == States.EXPLODING:
		for mesh in $Skin/Skin.meshes:
			mesh.set_instance_shader_parameter("color_change_speed", explosion_tick_speed)
		#$Skin/Skin.exploding_material.set_shader_parameter("color_change_speed", explosion_tick_speed)
		explosion_tick_speed += explosion_tick_increase * delta
		explosion_tick_increase += explosion_tick_speed
		direction = global_position.direction_to(player.global_position)
		applied_move_speed = exploding_speed

	skin.look_at(global_position + direction)
	velocity = velocity.move_toward(direction.normalized() * applied_move_speed, accel * delta)
	move_and_slide()

func set_state(new_state: int) -> void:
	if state != new_state:
			previous_state = state
			state = new_state
			
	if new_state == States.ROAMING:
		applied_move_speed = roam_speed
		current_roaming_target_pos = find_roaming_position()
	
	if new_state == States.EXPLODING:
		explosion_timer.start()


	if previous_state in [States.ROAMING, States.EXPLODING]:
		applied_move_speed = move_speed

func find_roaming_position():
	var random_angle = randf_range(0, TAU)
	var offset = Vector3(cos(random_angle), 0, sin(random_angle)) * roaming_distance
	var potential_target = global_transform.origin + offset
	
	roaming_pos_ray.look_at(potential_target, Vector3.UP)
	if not roaming_pos_ray.is_colliding():
		return potential_target
	else:
		return current_roaming_target_pos


func _on_explosion_timer_timeout() -> void:
	if player_in_explosion_range:
		player.take_damage(explosion_damage)
		print("hit by explosion")
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_explosion_range = true
		print("player in range")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_explosion_range = false
		print("player no longer in range")

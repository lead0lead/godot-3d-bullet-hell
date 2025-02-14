extends Enemy
class_name FlyingEnemy

enum States {STATIONARY, PERSUING, PATROLLING, ROAMING, ATTACKING, EXPLODING}
enum Type {BOMB, SHOOTER}
var state := States.STATIONARY
var previous_state := state

@export var type: Type
@export var max_fire_distance := 10
@export var move_speed := 7.5
@export var roam_speed := 5.0
@export var exploding_speed := 3.0
@export var attacking_move_speed := 5.0
@export var accel := 80.0
@export var explosion_range := 4.0
@export var shooting_range := 20.0
@export var shooting_max_range := 30
@export var shooting_min_range := 7.5
@export var explosion_tick_speed := 0.0
@export var explosion_tick_increase := 25.0
@export var explosion_damage := 40.0
@export var bullet_speed := 2.0

var direction := Vector3.ZERO
var roaming_distance := 10.0
var current_roaming_target_pos: Vector3
var player_in_explosion_range: bool = false
var attack_range := explosion_range

@onready var roaming_pos_ray := $RoamingPosRay
@onready var explosion_timer := $ExplosionTimer
@onready var applied_move_speed := move_speed
@onready var explosion := preload("res://scenes/exposion_particle.tscn")
@onready var bullet = preload("res://scenes/enemy_bullet.tscn")

@onready var bomb_skin = preload("res://scenes/flying_bomb_enemy_visuals.tscn")
@onready var shooter_skin = preload("res://scenes/flying_shooter_enemy_visuals.tscn")

func _ready() -> void:
	current_roaming_target_pos = find_roaming_position()
	set_state(States.ROAMING)
	roaming_pos_ray.target_position = Vector3(0, 0, roaming_distance)

	health_bar.init_health(health)

	#if type == Type.BOMB:
		#attack_range = explosion_range
		#var current_skin = bomb_skin.instantiate()
		#skin.add_child(current_skin)
		#current_skin.transform.basis = transform.basis.rotated(Vector3.UP, deg_to_rad(90))
	#
	if type == Type.SHOOTER:
		skin.get_child(0).queue_free()
		attack_range = shooting_range
		var current_skin = shooter_skin.instantiate()
		skin.add_child(current_skin)
		current_skin.position.y = 1.0

func _physics_process(delta: float) -> void:
	
	if not current_roaming_target_pos:
		current_roaming_target_pos = find_roaming_position()
	
	if state == States.STATIONARY:
		if is_player_in_line_of_sight(): 
			set_state(States.PERSUING)
		direction = Vector3.ZERO

	if state == States.ATTACKING:

		look_at(Vector3(player.global_position.x, self.global_position.y
			, player.global_position.z))
		gun.look_at(player.lock_on_target.global_position)
		fire()
	
		direction = global_position.direction_to(player.global_position)
		
		if global_position.distance_to(player.global_position) > shooting_min_range:
			applied_move_speed = attacking_move_speed

		if global_position.distance_to(player.global_position) < shooting_min_range:
			applied_move_speed = 0.0


		if global_position.distance_to(player.global_position) > shooting_max_range:
			set_state(States.PERSUING)

	if state == States.PERSUING:
		if not is_player_in_line_of_sight():
			set_state(States.ROAMING)
		direction = global_position.direction_to(player.global_position)


		if global_position.distance_to(player.global_position) < attack_range:
			if type == Type.BOMB:
				set_state(States.EXPLODING)

			if type == Type.SHOOTER:
				set_state(States.ATTACKING)

	if state == States.ROAMING:
		if is_player_in_line_of_sight(): 
			set_state(States.PERSUING)

		direction = (current_roaming_target_pos - global_position).normalized()
		if global_position.distance_to(current_roaming_target_pos) < 1.0 or velocity.length() < 0.5:
			current_roaming_target_pos = find_roaming_position()
	
	if state == States.EXPLODING:
		for mesh in skin.get_child(0).meshes:
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
	var e = explosion.instantiate()
	get_parent().add_child(e)
	e.global_position = global_position
	e.play_explosion()
	
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

func fire():
	if can_fire:
		can_fire = false
		var b = bullet.instantiate()
		b.speed = bullet_speed
		b.target_group = "Player"
		gun.add_child(b)
		b.shoot = true
		await get_tree().create_timer(rate_of_fire).timeout
		can_fire = true

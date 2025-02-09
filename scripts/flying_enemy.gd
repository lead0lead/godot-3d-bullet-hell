extends Enemy
class_name FlyingEnemy

enum States {STATIONARY, PERSUING, PATROLLING, ROAMING, ATTACKING}
var state := States.STATIONARY
var previous_state := state
@export var max_fire_distance := 10
@export var move_speed := 7.5
@export var accel := 80.0

func _ready() -> void:
	state = States.PERSUING
	
func _physics_process(delta: float) -> void:
	#if is_player_in_line_of_sight(): 
		#print("this work")
		#if (global_position.distance_to(player.global_position) 
				#<= max_fire_distance):
			#print("Attacking!")
			#set_state(States.ATTACKING)
		#if (global_position.distance_to(player.global_position) 
				#> max_fire_distance):
			#print("Persuing!")
			#set_state(States.PERSUING)
	#else: 
		#print("stationary")
		#set_state(States.STATIONARY)
	#
	if state == States.STATIONARY:
		velocity = Vector3.ZERO
		
	if state == States.ATTACKING:
		pass
		
	if state == States.PERSUING:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction.normalized() * move_speed, accel * delta)
		look_at(player.global_position)
		move_and_slide()

func set_state(new_state: int) -> void:
	pass

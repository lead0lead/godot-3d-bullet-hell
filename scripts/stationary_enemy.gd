extends Enemy
class_name StationaryEnemy

enum States {STATIONARY, ATTACKING}
var state := States.STATIONARY
var previous_state := state

@onready var bullet = preload("res://scenes/bullet.tscn")

func _physics_process(delta: float) -> void:
	if is_player_in_line_of_sight():
		set_state(States.ATTACKING)
	else: set_state(States.STATIONARY)
	
	if state == States.ATTACKING:
		look_at(Vector3(player.global_position.x, self.global_position.y
			, player.global_position.z))
		gun.look_at(player.lock_on_target.global_position)
		fire()
	
	if state == States.STATIONARY:
		pass

func set_state(new_state: int) -> void:
	if state != new_state:
			previous_state = state
			state = new_state

func fire():
	if can_fire:
		can_fire = false
		var b = bullet.instantiate()
		b.speed = 1.2
		b.target_group = "Player"
		gun.add_child(b)
		b.shoot = true
		await get_tree().create_timer(rate_of_fire).timeout
		can_fire = true

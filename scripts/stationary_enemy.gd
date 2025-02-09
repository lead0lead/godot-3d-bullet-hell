extends Enemy
class_name StationaryEnemy

enum States {STATIONARY, ATTACKING}
var state := States.STATIONARY
var previous_state := state

func _physics_process(delta: float) -> void:
	if is_player_in_line_of_sight():
		look_at(Vector3(player.global_position.x, self.global_position.y, player.global_position.z))

func set_state(new_state: int) -> void:
	pass

extends Enemy
class_name FlyingEnemy

enum States {STATIONARY, PERSUING, PATROLLING, ROAMING, ATTACKING}
var state := States.STATIONARY
var previous_state := state

func set_state(new_state: int) -> void:
	pass

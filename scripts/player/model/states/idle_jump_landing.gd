extends State
class_name IdleJumpLanding

const TRANSITION_TIMING = 0.9

func _ready() -> void:
	animation = "idle_jump_landing"
	state_name = "idle_jump_landing"


func check_relevance(input: InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		input.actions.sort_custom(state_priority_sort)
		return input.actions[0]
	else:
		return "okay"


func update(input: InputPackage, delta: float):
	player.velocity.y -= player.gravity * delta
	player.move_and_slide()

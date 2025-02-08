extends State
class_name RunningJumpLanding

const TRANSITION_TIMING = 0.9

func _ready() -> void:
	animation = "running_jump_landing"
	state_name = "running_jump_landing"


func check_relevance(input: InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		input.actions.sort_custom(state_priority_sort)
		return input.actions[0]
	else:
		input.actions.sort_custom(state_priority_sort)
		if (input.actions[0] == "boosting" 
				or input.actions[0] == "jump_pressed_midair"):
			print("option 2")
			return input.actions[0]
		else:
			print("option 3")
			return "okay"



func update(input: InputPackage, delta: float):
	player.velocity.y -= player.gravity * delta
	player.move_and_slide()

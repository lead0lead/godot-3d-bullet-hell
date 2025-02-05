extends State
class_name RunningJumpLanding

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const TRANSITION_TIMING = 0.9

func _ready() -> void:
	animation = "running_jump_landing"
	state_name = "running_jump_landing"


func check_relevance(input: InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		input.actions.sort_custom(state_priority_sort)
		return input.actions[0]
	else:
		return "okay"


func update(input: InputPackage, delta: float):
	player.velocity.y -= gravity * delta
	player.move_and_slide()

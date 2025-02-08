extends State
class_name RunningJumpStart

const TRANSITION_TIMING = 3.75
const JUMP_TIMING = 0.2

var jumped: bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	animation = "running_jump_start"
	state_name = "running_jump_start"
	
func check_relevance(input: InputPackage):
	input.actions.sort_custom(state_priority_sort)
	if input.actions[0] == "running_jump_start":
		if works_longer_than(TRANSITION_TIMING):
			jumped = false
			return "running_jump_midair"
		else:
			return "okay"
	if (input.actions[0] == "boosting" 
			or input.actions[0] == "jump_pressed_midair"):
		return input.actions[0]

func update(input, delta):
	if works_longer_than(JUMP_TIMING):
		if not jumped:
			player.velocity.y += player.jump_strength
			jumped = true
	player.move_and_slide()

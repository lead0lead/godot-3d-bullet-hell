extends State
class_name RunningJumpStart

const VERTICAL_SPEED_ADDED: float = 2.5

const TRANSITION_TIMING = 3.75
const JUMP_TIMING = 0.2

var jumped: bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	animation = "running_jump_start"
	state_name = "running_jump_start"
	
func check_relevance(input: InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		jumped = false
		return "running_jump_midair"
	else:
		return "okay"

func update(input, delta):
	if works_longer_than(JUMP_TIMING):
		if not jumped:
			player.velocity.y += VERTICAL_SPEED_ADDED
			jumped = true
	player.move_and_slide()

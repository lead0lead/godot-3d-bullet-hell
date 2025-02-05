extends State
class_name IdleJumpStart

const VERTICAL_SPEED_ADDED: float = 2.5

const TRANSITION_TIMING = 1.3
const JUMP_TIMING = 0.8

var jumped: bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	animation = "idle_jump_start"
	state_name = "idle_jump_start"
	
func check_relevance(input: InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		jumped = false
		return "idle_jump_midair"
	else:
		return "okay"

func update(input, delta):
	if works_longer_than(JUMP_TIMING):
		if not jumped:
			player.velocity.y += VERTICAL_SPEED_ADDED
			jumped = true
	player.move_and_slide()

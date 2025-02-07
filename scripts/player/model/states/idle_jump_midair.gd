extends State
class_name IdleJumpMidair

@onready var downcast = $"../../Downcast"
@onready var root_attachement = get_owner()

var landing_height: float = 0.5

func _ready() -> void:
	animation = "idle_jump_midair"
	state_name = "idle_jump_midair"

func check_relevance(input: InputPackage):
	var floor_point = downcast.get_collision_point()
	if (root_attachement.global_position.distance_to(floor_point) 
			< landing_height):
		return "idle_jump_landing"
	else:
		input.actions.sort_custom(state_priority_sort)
		if input.actions[0] == "boosting":
			return "boosting"
		else:
			return "okay"


func update(input, delta: float):
	player.velocity.y -= player.gravity * delta
	player.move_and_slide()

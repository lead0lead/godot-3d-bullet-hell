extends State
class_name Idle

func _ready() -> void:
	animation = "idle"
	state_name = "idle"

func check_relevance(input) -> String:
	if not player.is_on_floor():
		return "idle_jump_midair"
		
	input.actions.sort_custom(state_priority_sort)
	return input.actions[0]

func update(input: InputPackage, delta: float):
	if not player.is_on_floor():
		player.velocity.y -= player.gravity * delta
		player.move_and_slide()

extends State
class_name Gliding
# Remember to redefine class_name

func _ready() -> void:
	animation = "flying"
	state_name = "gliding"


func check_relevance(input: InputPackage):
	input.actions.sort_custom(state_priority_sort)
	return input.actions[0]


func update(input, delta: float):
	player.velocity.y -= (player.gravity * player.glide_factor) * delta
	player.move_and_slide()

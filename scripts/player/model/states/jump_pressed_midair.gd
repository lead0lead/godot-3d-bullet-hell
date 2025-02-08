extends State
class_name JumpPressedMidair
# Remember to redefine class_name

func _ready() -> void:
	animation = "idle_jump_midair"
	state_name = "jump_pressed_midair"


func check_relevance(input: InputPackage):
	if player.double_jump_ready:
		player.double_jump_ready = false
		print("double_jumped")
		return "idle_jump_start"
	else:
		return "gliding"

func update(input, delta: float):
	pass

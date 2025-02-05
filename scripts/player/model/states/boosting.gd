extends State
class_name Boosting

var boost_speed = 20.0
var boost_accel = 120.0

func _ready() -> void:
	animation = "flying" #rename to boosting later...
	state_name = "boosting"

func check_relevance(input: InputPackage):
	input.actions.sort_custom(state_priority_sort)
	return input.actions[0]

func update(input, delta: float):
	player.direction = (-player.camera.global_basis.z 
	+ player.camera.global_basis.x 
	* input.input_direction.x)
	
	player.velocity = player.velocity.move_toward(player.direction * boost_speed
		, boost_accel * delta)
		
	player.move_and_slide()

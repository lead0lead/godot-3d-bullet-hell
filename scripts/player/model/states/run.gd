extends State
class_name Run

const SPEED = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	animation = "running"
	state_name = "running"
	
	
func check_relevance(input: InputPackage):
	if not player.is_on_floor():
		return "running_jump_midair"

	input.actions.sort_custom(state_priority_sort)
	if input.actions[0] == "run":
		return "okay"
	return input.actions[0]
	
func update(input: InputPackage, delta: float):
	player.velocity = velocity_by_input(input, delta)
	player.move_and_slide()

func velocity_by_input(input: InputPackage, delta: float) -> Vector3:
	var new_velocity = player.velocity
	
	player.direction = (player.camera.global_basis.z * input.input_direction.y + player.camera.global_basis.x * input.input_direction.x).normalized()
	new_velocity.x = player.direction.x * SPEED
	new_velocity.z = player.direction.z * SPEED
	
	if not player.is_on_floor():
		new_velocity.y -= gravity * delta
	
	return new_velocity
	
	#player.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)
	
	#_move_direction = camera_forward * player_input_direction.y + camera_right * player_input_direction.x
		#_move_direction = _move_direction.normalized()
	#velocity = velocity.move_toward(_move_direction * applied_movement_speed, applied_acceleration * delta)

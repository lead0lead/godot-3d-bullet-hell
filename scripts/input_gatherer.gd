extends Node
class_name InputGatherer

func gather_input() -> InputPackage:
	var new_input = InputPackage.new()
	
	new_input.actions.append("idle")
	
	new_input.input_direction = Input.get_vector("left", "right", "forward", "back")
	if new_input.input_direction != Vector2.ZERO:
		new_input.actions.append("walk")
		
	if Input.is_action_pressed("jump"):
		new_input.actions.append("jump")
	
	if Input.is_action_pressed("dash"):
		new_input.actions.append("dash")
	
	if Input.is_action_pressed("boost"):
		new_input.actions.append("boost")
	
	if Input.is_action_pressed("toggle-flight"):
		new_input.actions.append("toggle-flight")
	
	if Input.is_action_pressed("fire"):
		new_input.actions.append("fire")

	if Input.is_action_pressed("heavy_fire"):
		new_input.actions.append("heavy_fire")
	
	if Input.is_action_pressed("melee_attack"):
		new_input.actions.append("melee_attack")
	
	
	return new_input

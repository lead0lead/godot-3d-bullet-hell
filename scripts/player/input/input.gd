extends Node
class_name InputGatherer

func gather_input() -> InputPackage:
	var new_input = InputPackage.new()

	if Input.is_action_just_pressed("dash"):
		new_input.actions.append("dash")
	
	new_input.input_direction = Input.get_vector(
		"left", 
		"right", 
		"forward", 
		"back")
		
	if new_input.input_direction != Vector2.ZERO:
		new_input.actions.append("run")

	if Input.is_action_pressed("jump"):
		if new_input.actions.has("run"):
			new_input.actions.append("running_jump_start")
		else:
			new_input.actions.append("idle_jump_start")

	if Input.is_action_pressed("boost"):
		new_input.actions.append("boosting")



	if new_input.actions.is_empty():
		new_input.actions.append("idle")

	return new_input

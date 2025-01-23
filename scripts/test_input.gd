extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left-click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

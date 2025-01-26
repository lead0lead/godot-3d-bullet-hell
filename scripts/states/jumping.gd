extends PlayerState

func enter():
	pass

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(delta: float):
	
	# Change State to idle
	
	if player.is_on_floor():
		transitioned.emit(self, "idle")

	# Change State on Input
	
	if Input.is_action_pressed("jump") and not player.is_on_floor():
		transitioned.emit(self, "gliding")
	
	if Input.is_action_pressed("boost"):
		transitioned.emit(self, "boosting")
		
	if Input.is_action_just_pressed("toggle-flight"):
		transitioned.emit(self, "flying")
	
	if Input.is_action_just_pressed("dash"):
		transitioned.emit(self, "dashing")
	
	# Change State to falling
	
	if player.velocity.y < 0:
		transitioned.emit(self, "falling")
	

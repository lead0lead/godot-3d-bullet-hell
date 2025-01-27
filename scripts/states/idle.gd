extends PlayerState

func enter():
	pass

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(delta: float):
	
	# Apply gravity
	
	player.velocity.y += (player.gravity * delta)
	
	# Change State to idle
	
	if Input.is_action_pressed("jump") and not player.is_on_floor():
		transitioned.emit(self, "gliding")
	
	# Change State on Input
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transitioned.emit(self, "jumping")
		
	if Input.is_action_pressed("jump") and not player.is_on_floor():
		transitioned.emit(self, "gliding")

	if Input.is_action_pressed("boost"):
		transitioned.emit(self, "boosting")
		
	if (Input.is_action_pressed("left")
			or Input.is_action_pressed("right")
			or Input.is_action_pressed("forward")
			or Input.is_action_pressed("back")):
		transitioned.emit(self, "walking")
		
	if Input.is_action_just_pressed("toggle-flight"):
		transitioned.emit(self, "flyingidle")
	
	if Input.is_action_just_pressed("dash"):
		transitioned.emit(self, "dashing")
	
	# Change State to falling
	
	if player.velocity.y < 0:
		transitioned.emit(self, "falling")

extends PlayerState


func enter():
	pass

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(delta: float):
	
	# Apply limited gravity
	
	player.velocity.y = ((player.velocity.y 
		+ (player.gravity * delta)) 
		* player.glide_speed)
	
	# Change State on Input
	
	

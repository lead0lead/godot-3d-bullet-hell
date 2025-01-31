extends CharacterBody3D
class_name npc

@export var health := 200.0

func _ready() -> void:
	pass
	
func _process(delta):
	if health <= 0:
		queue_free()
		print("Enemy destroyed!", self)

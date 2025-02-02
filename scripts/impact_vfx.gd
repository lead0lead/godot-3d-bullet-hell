extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var particles = get_children()
	for particle in particles:
		particle.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sparks_finished() -> void:
	queue_free()

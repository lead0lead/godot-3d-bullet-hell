extends Node3D

@onready var explosion_particles = $ExplosionParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_gpu_particles_3d_finished() -> void:
	queue_free()

func play_explosion():
	explosion_particles.emitting = true

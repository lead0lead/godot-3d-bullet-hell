extends Node3D

@onready var heavy_fire_beam: GPUParticles3D = $HeavyFireBeam
@onready var heavy_fire_inner_beam: GPUParticles3D = $HeavyFireInnerBeam
@onready var heavy_fire_wave: GPUParticles3D = $HeavyFireWave
@onready var heavy_fire_sparks: GPUParticles3D = $HeavyFireSparks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func animate_particles():
	heavy_fire_beam.emitting = true
	heavy_fire_inner_beam.emitting = true
	heavy_fire_wave.emitting = true
	heavy_fire_sparks.emitting = true
	

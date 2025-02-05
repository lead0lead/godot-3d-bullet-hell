extends RayCast3D

@onready var root_attachement = get_parent()
@onready var target_sphere = $TargetSphere


func _process(delta: float) -> void:
	global_position = root_attachement.global_position
	target_sphere.global_position = get_collision_point()

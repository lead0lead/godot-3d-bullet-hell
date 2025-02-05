extends Node3D
class_name PlayerVisuals

@onready var body = $Body
@onready var eyes = $Eyes

func accept_skeleton(skeleton: Skeleton3D):
	body.skeleton = skeleton.get_path()
	eyes.skeleton = skeleton.get_path()

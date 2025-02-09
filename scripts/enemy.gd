extends npc
class_name Enemy

@export var lock_on_target: Node3D
@export var line_of_sigth: RayCast3D

@onready var player_in_line_of_sight: bool = false

@onready var starting_pos = position
@onready var player = $"../Player"
var breadcrumbs: Array[Vector3] = [starting_pos]

func is_player_in_line_of_sight() -> bool:
	line_of_sigth.look_at(player.lock_on_target.global_position)
	if line_of_sigth.is_colliding():
		if line_of_sigth.get_collider().is_in_group("Player"):
			return true
	return false

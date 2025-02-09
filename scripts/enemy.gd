extends npc
class_name Enemy

@export var lock_on_target: Node3D

@onready var player_in_line_of_sight: bool = false

@onready var starting_pos = position

extends npc
class_name Enemy

@export var rate_of_fire: float = 0.4

@onready var player_in_line_of_sight: bool = false

@onready var starting_pos = position
@onready var player = $"../Player"
@onready var lock_on_target: Node3D = $LockOnTarget
@onready var line_of_sight: RayCast3D = $LOS
@onready var gun: Node3D = $Gun
@onready var skin = $Skin
@onready var health_bar = $HealthBarViewport/HealthBar

var can_fire := true
var breadcrumbs: Array[Vector3] = [starting_pos]

func is_player_in_line_of_sight() -> bool:
	line_of_sight.look_at(player.lock_on_target.global_position)
	if line_of_sight.is_colliding():
		if line_of_sight.get_collider():
			if line_of_sight.get_collider().is_in_group("Player"):
				return true
	return false

func take_damage(damage):
	health -= damage
	health_bar.health = health

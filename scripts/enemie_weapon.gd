extends Node3D
class_name EnemyWeapon

@export var rate_of_fire: float = 0.4
var can_fire := true
@onready var enemy = get_parent()
@onready var player = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire():
	pass

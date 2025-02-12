extends Node3D

@export var animation_player: AnimationPlayer
@export var mount: Node3D
@export var health_potion: Node3D

@onready var healing_effect = preload("res://scenes/healing_effect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_healing_effect():
	var e = healing_effect.instantiate()
	add_child(e)
	#e.global_position = get_parent().global_position

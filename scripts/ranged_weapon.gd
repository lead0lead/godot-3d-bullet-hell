extends Node3D

@export var max_weapon_x_distance := 2.0
@export var max_weapon_y_distance := 3.0
@export var max_weapon_z_distance := 0.5

@export var weapon_speed := 0.02

@onready var _ranged_weapon_pivot: Node3D = %RangedWeaponPivot
@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _player := _ranged_weapon_pivot.get_parent()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	_handle_weapon_pivot_rotation(delta)

func _handle_weapon_pivot_rotation(delta):
	
	_ranged_weapon_pivot.look_at(_player.position - _camera_pivot.global_basis.x - _camera_pivot.global_basis.y)

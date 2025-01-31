extends Node3D

@export var _muzzle: Node3D

@export var max_weapon_x_distance := 2.0
@export var max_weapon_y_distance := 3.0
@export var max_weapon_z_distance := 0.5
@export var _rate_of_fire := 0.2

@export var weapon_speed := 0.02

@onready var _ranged_weapon_pivot: Node3D = %RangedWeaponPivot
@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _player := _ranged_weapon_pivot.get_parent()

@onready var bullet = preload("res://scenes/bullet.tscn")
@onready var _aimcast: RayCast3D = %Aimcast
@onready var _camera: Camera3D = %PlayerCamera

var _enemies_in_view := []

var _can_fire: bool = true

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	_handle_weapon_pivot_rotation(delta)
	if _aimcast.is_colliding():
		self.look_at(_aimcast.get_collision_point(), _camera.global_basis.y)
	else:
		self.look_at(_camera.global_transform * (Vector3.FORWARD * 1000.0))
		
func _handle_weapon_pivot_rotation(delta):
	_ranged_weapon_pivot.look_at(_player.position - _camera_pivot.global_basis.x - _camera_pivot.global_basis.y)
		
func fire():
	if _can_fire:
		_can_fire = false
		var b = bullet.instantiate()
		_muzzle.add_child(b)
		#b.look_at(_aimcast.get_collision_point(), Vector3.UP)
		b.shoot = true
		await get_tree().create_timer(_rate_of_fire).timeout
		_can_fire = true
		

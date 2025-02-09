extends Node3D

@export var _muzzle: Node3D

@export var max_weapon_x_distance := 2.0
@export var max_weapon_y_distance := 3.0
@export var max_weapon_z_distance := 0.5
@export var _rate_of_fire := 0.2

@export var weapon_speed := 0.02

@export var _target_lock_on: Node

@export var heavy_fire_damage := 50

@onready var _ranged_weapon_pivot: Node3D = %RangedWeaponPivot
@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _player := _ranged_weapon_pivot.get_parent()

@onready var bullet = preload("res://scenes/bullet2.tscn")
@onready var heavy_fire_beam = preload("res://scenes/heavy_fire_beam.tscn")
@onready var impact = preload("res://scenes/impact_vfx.tscn")

@onready var _aimcast: RayCast3D = %Aimcast
@onready var _camera: Camera3D = %PlayerCamera
@onready var _player_ui: CanvasLayer = %PlayerUI
@onready var _heavy_fire_cooldown_timer: Timer = $HeavyFireCooldownTimer

var _can_fire: bool = true
var _can_heavy_fire: bool = true

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	_handle_weapon_pivot_rotation(delta)
	var lock_on_target = _target_lock_on.find_nearest_lockon_target()
	if lock_on_target:
		self.look_at(lock_on_target.lock_on_target.global_position, _camera.global_basis.y)
		_player_ui.update_target_marker(lock_on_target)
		_player_ui.target_marker.visible = true
	else:
		if _aimcast.is_colliding():
			self.look_at(_aimcast.get_collision_point(), _camera.global_basis.y)
		else:
			self.look_at(_camera.global_transform * (Vector3.FORWARD * 1000.0))
		_player_ui.target_marker.visible = false

func _handle_weapon_pivot_rotation(delta):
	_ranged_weapon_pivot.look_at(_player.position - _camera_pivot.global_basis.x - _camera_pivot.global_basis.y)

func fire():
	if _can_fire:
		$RangedWeaponMesh/AnimationPlayer.play("fire")
		_can_fire = false
		var b = bullet.instantiate()
		_muzzle.add_child(b)
		#b.look_at(_aimcast.get_collision_point(), Vector3.UP)
		b.shoot = true
		await get_tree().create_timer(_rate_of_fire).timeout
		_can_fire = true

func heavy_fire():
	if _can_heavy_fire:
		print("heavy fire pressed")
		if _aimcast.is_colliding():
			var i = impact.instantiate()
			get_tree().root.add_child(i)
			i.global_position = _aimcast.get_collision_point()
			var target = _aimcast.get_collider()
			if target.is_in_group("Enemy"):
				target.health -= heavy_fire_damage
		_can_heavy_fire = false
		_heavy_fire_cooldown_timer.start()
		var heavy_fire_visuals = heavy_fire_beam.instantiate()
		_muzzle.add_child(heavy_fire_visuals)
		heavy_fire_visuals.animate_particles()
	else:
		print("heavy fire on cooldown")


func _on_heavy_fire_cooldown_timer_timeout() -> void:
	_can_heavy_fire = true

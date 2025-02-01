extends CanvasLayer

@export var crosshair_width = 0.5
@export var crosshair_height = 0.5
@export var target_marker: Sprite2D

@onready var _crosshair: TextureRect = %Crosshair
@onready var _camera: Camera3D = %PlayerCamera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_crosshair()
	show_target_marker(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_crosshair():
	var screen_size = get_viewport().size
	var detection_area_width = screen_size.x * crosshair_width
	var detection_area_height = screen_size.y * crosshair_height
	_crosshair.size = Vector2(detection_area_width, detection_area_height)
	_crosshair.position.x = (screen_size.x - detection_area_width) / 2
	_crosshair.position.y = (screen_size.y - detection_area_height) / 2

func update_target_marker(target):
	target_marker.position = _camera.unproject_position(
		target.lock_on_target.global_position)
		
func show_target_marker(visibile: bool):
	if visible:
		target_marker.visible = true
	else:
		target_marker.visible = false

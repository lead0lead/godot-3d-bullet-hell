extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	configure_blend_times()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func configure_blend_times():
	set_blend_time("Idle", "Running", 0.2)
	set_blend_time("Idle", "Jumping", 0.5)
	set_blend_time("Idle", "Gliding", 0.5)
	set_blend_time("Idle", "Skating", 0.5)
	set_blend_time("Idle", "Flying", 0.5)

	set_blend_time("Running", "Jumping", 0.5)
	set_blend_time("Running", "Gliding", 0.5)
	set_blend_time("Running", "Skating", 0.5)
	set_blend_time("Running", "Flying", 0.5)

	set_blend_time("Skating", "Falling", 0.5)
	set_blend_time("Skating", "Flying", 0.5)

	set_blend_time("Gliding", "Skating", 0.5)
	set_blend_time("Gliding", "Flying", 0.5)

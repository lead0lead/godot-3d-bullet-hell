extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	configure_blend_times()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func configure_blend_times():
	set_blend_time("idle", "running", 0.2)
	set_blend_time("idle", "jumping", 0.2)
	set_blend_time("idle", "sitting", 0.2)
	
	set_blend_time("running", "jumping", 0.2)
	set_blend_time("running", "sitting", 0.2)

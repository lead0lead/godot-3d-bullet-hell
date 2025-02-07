extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	configure_blending_times()


func configure_blending_times():
	set_blend_time("idle", "running", 0.2)
	set_blend_time("idle", "idle_jump_start", 0.3)
	set_blend_time("idle_jump_start", "idle_jump_midair", 0.5)
	set_blend_time("idle_jump_midair", "idle_jump_landing", 0.5)
	set_blend_time("idle_jump_landing", "idle", 0.5)
	set_blend_time("idle_jump_landing", "running", 0.5)
	
	set_blend_time("idle", "idle_jump_midair", 0.3)
	
	set_blend_time("running", "running_jump_start", 0.3)
	set_blend_time("running_jump_start", "running_jump_midair", 0.5)
	set_blend_time("running_jump_midair", "running_jump_landing", 0.5)
	set_blend_time("running_jump_landing", "idle", 0.5)
	set_blend_time("running_jump_landing", "running", 0.5)
	
	set_blend_time("running", "running_jump_midair", 0.5)
	
	

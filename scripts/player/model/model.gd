extends Node
class_name PlayerModel

@onready var player = $".."
@onready var skeleton = $GeneralSkeleton
@onready var animator = $SkeletonAnimator

var current_state: State

var last_move_direction = Vector3.FORWARD
var visuals_rotation_speed := 8.0

@onready var states = {
		"idle": $States/Idle,
		"run": $States/Run,
		"running_jump_start": $States/RunningJumpStart,
		"running_jump_midair": $States/RunningJumpMidair,
		"running_jump_landing": $States/RunningJumpLanding,
		"idle_jump_start": $States/IdleJumpStart,
		"idle_jump_midair": $States/IdleJumpMidair,
		"idle_jump_landing": $States/IdleJumpLanding,
		"boosting": $States/Boosting,
		"jump_pressed_midair": $States/JumpPressedMidair,
		"gliding": $States/Gliding,
}

func _ready() -> void:
	current_state = states["idle"]
	for state in states.values():
		state.player = player

func _physics_process(delta: float) -> void:
	rotate_player_visuals(delta)
	
func update(input: InputPackage, delta: float):
	var relevance = current_state.check_relevance(input)
	if relevance != "okay":
		switch_to(relevance)
	current_state.update(input, delta)

func switch_to(state: String):
	current_state.on_exit_state()
	current_state = states[state]
	current_state.on_enter_state()
	animator.play(current_state.animation)
	
func rotate_player_visuals(delta):
	var direction = player.direction
	
	if direction.length() > 0.0:
		last_move_direction = direction
	var target_angle := Vector3.BACK.signed_angle_to(last_move_direction
		, Vector3.UP)
		
	player.skeleton.global_rotation.y = lerp_angle(player.skeleton.rotation.y
		, target_angle, visuals_rotation_speed * delta)

	player.visuals.global_rotation.y = player.skeleton.global_rotation.y

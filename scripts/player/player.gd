extends CharacterBody3D

@onready var input_gatherer = $Input as InputGatherer
@onready var model = $Model as PlayerModel
@onready var visuals = $PlayerVisuals as PlayerVisuals
@onready var skeleton:  Skeleton3D = %GeneralSkeleton
@onready var camera = %PlayerCamera

@export var run_speed := 10.0
@export var ranged_weapon: Node3D
@export var jump_strength := 2.5
@export var boost_speed := 20.0
@export var boost_accel := 120.0
@export var glide_factor := 0.5

var double_jump_ready: bool = true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var direction = Vector3.FORWARD

func _ready():
	visuals.accept_skeleton(model.skeleton)

func _physics_process(delta: float) -> void:
	
	var input = input_gatherer.gather_input()
	model.update(input, delta)

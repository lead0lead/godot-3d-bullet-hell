extends CharacterBody3D

@onready var input_gatherer = $Input as InputGatherer
@onready var model = $Model as PlayerModel
@onready var visuals = $PlayerVisuals as PlayerVisuals
@onready var skeleton:  Skeleton3D = %GeneralSkeleton
@onready var camera = %PlayerCamera

var direction = Vector3.FORWARD

func _ready():
	visuals.accept_skeleton(model.skeleton)

func _physics_process(delta: float) -> void:
	var input = input_gatherer.gather_input()
	model.update(input, delta)

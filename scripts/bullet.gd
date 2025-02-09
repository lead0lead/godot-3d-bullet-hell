extends RigidBody3D
class_name Bullet

var damage = 20.0
var speed = 3.0
var target_group = "Enemy"

@onready var impact = preload("res://scenes/impact_vfx.tscn")
var shoot = false

func _ready():
	set_as_top_level(true)
	
func _physics_process(delta: float) -> void:
	if shoot:
		apply_impulse(transform.basis.z - transform.basis.z * speed)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(target_group):
		body.health -= damage
	animate_impact()
	queue_free()

func animate_impact():
	var i = impact.instantiate()
	get_parent().add_child(i)
	i.global_position = self.global_position

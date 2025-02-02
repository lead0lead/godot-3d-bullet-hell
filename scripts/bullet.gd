extends RigidBody3D

const DAMAGE = 20.0
const SPEED = 3.0

@onready var impact = preload("res://scenes/impact_vfx.tscn")
var shoot = false

func _ready():
	set_as_top_level(true)
	
func _physics_process(delta: float) -> void:
	if shoot:
		apply_impulse(transform.basis.z - transform.basis.z * SPEED)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
	animate_impact()
	queue_free()

func animate_impact():
	var i = impact.instantiate()
	get_parent().add_child(i)
	i.global_position = self.global_position

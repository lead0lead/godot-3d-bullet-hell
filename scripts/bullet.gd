extends RigidBody3D
class_name Bullet

const DAMAGE = 50.0
const SPEED = 10.0

var shoot = false

func _ready():
	set_as_top_level(true)
	
func _physics_process(delta: float) -> void:
	if shoot:
		apply_impulse(transform.basis.z - transform.basis.z * SPEED)


func _on_body_entered(body: Node) -> void:
	#if body.is_in_group("Enemy"):
		#body.health -= DAMAGE
		#queue_free()
	#else:
		#queue_free()
	queue_free()
	print("bullet deleted")

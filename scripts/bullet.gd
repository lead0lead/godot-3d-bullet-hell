extends RigidBody3D

const DAMAGE = 50.0
const SPEED = 5.0

var shoot = false

func _ready():
	set_as_top_level(true)
	
func _physics_process(delta: float) -> void:
	if shoot:
		apply_impulse(transform.basis.z - transform.basis.z * SPEED)


func _on_body_entered(body: Node) -> void:
	queue_free()
	print("Bullet Collided")

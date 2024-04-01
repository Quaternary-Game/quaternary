class_name EntitySpider extends EntityEnemy

var starting_velocity : Vector2 = Vector2.ZERO

var angular_velocity : float

func rotate_node(node: Node, delta: float) -> float:
	var old_rotation: float = node.rotation
	node.rotation = rotate_toward(node.rotation, velocity.angle() + PI/2, delta*2)
	node.position = node.position.rotated(node.rotation-old_rotation)
	return (old_rotation - node.rotation)/(delta*2)
func _process(delta: float) -> void:
	rotate_node($AnimatedSprite2D, delta)
	rotate_node($CollisionShape2D, delta)
	angular_velocity = rotate_node($Area, delta)
	$AnimatedSprite2D.speed_scale = (abs(angular_velocity) + round(velocity.length()))/120
	
func _ready() -> void:
	super._ready()
	velocity = starting_velocity


class_name PlayerEntity extends EntityGD

@export var body_color : Color = Color.WHITE:
	set(value):
		body_color = value
		queue_redraw() 
		
@export var border_color : Color = Color.BLACK:
	set(value):
		border_color = value
		queue_redraw()

@export var body_radius : float:
	set(value):
		body_radius = value
		var collision_shape : Node
		if has_node("CollisionShape2D"):
			collision_shape= get_node("CollisionShape2D")
		if collision_shape:
			collision_shape.shape.radius = value
		queue_redraw()

func _ready() -> void:
	super._ready()
	self.traits_changed.connect(is_vision)

func is_vision() -> void:
	if "vision" in traits:
		$Eyes.visible = true
	else:
		$Eyes.visible = false

func _draw() -> void:
	draw_arc(Vector2.ZERO,body_radius/2, 0, 2 * PI, 100,body_color, body_radius, true)
	draw_arc(Vector2.ZERO, body_radius, 0, 2 * PI, 100, border_color, 1, true)


func _process(delta: float) -> void:
	var node: Node2D = $Eyes/Look
	var old_rotation: float = node.rotation
	node.rotation = rotate_toward(node.rotation, velocity.angle() , delta*2)
	node.position = node.position.rotated(node.rotation-old_rotation)

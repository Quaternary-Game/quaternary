extends AnimatedSprite2D

var previous_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_position = global_position
	play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent() is EntityGD:
		return
	var next_rotation: float = previous_position.direction_to(global_position).angle() + PI/2
	rotation = rotate_toward(rotation, next_rotation, delta*2)
	previous_position = global_position

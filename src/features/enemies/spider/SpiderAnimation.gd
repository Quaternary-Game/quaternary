extends AnimatedSprite2D

var previous_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_position = global_position
	play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation = previous_position.direction_to(global_position).angle()

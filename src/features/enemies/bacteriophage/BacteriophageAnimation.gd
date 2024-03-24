extends AnimatedSprite2D


var previous_position: Vector2
var direction: Vector2:
	get:
		return direction
	set(value):
		direction = value.normalized()
		var directions : = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
		for i in range(len(directions)):
			directions[i] = acos(directions[i].dot(direction))
		var index := directions.find(directions.min())
		var animations : = ["Up", "Down", "Left", "Right"]
		play(animations[index])
		

func _ready() -> void:
	previous_position = global_position
	


func _process(delta: float) -> void:
	direction = previous_position - global_position

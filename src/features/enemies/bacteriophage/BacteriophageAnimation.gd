extends AnimatedSprite2D


var previous_position: Vector2
var direction: Vector2:
	get:
		return direction
	set(value):
		direction = value.normalized()
		var directions : Array= [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
		for i : int in range(len(directions)):
			directions[i] = acos(directions[i].dot(direction))
		var index : float = directions.find(directions.min())
		var animations : Array[StringName] = ["Up", "Down", "Left", "Right"]
		play(animations[index])
		

func _ready() -> void:
	previous_position = global_position
	


func _process(_delta: float) -> void:
	direction = previous_position - global_position

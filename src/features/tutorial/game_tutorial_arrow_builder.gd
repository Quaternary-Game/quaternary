class_name GameTutorialArrowBuilder extends Object

const ARROW_SCENE: Resource = preload("res://features/tutorial/game_tutorial_arrow.tscn")

var _target: Node
var _direction: GameTutorialSlideBuilder.Direction

func _init(target: Node, direction: GameTutorialSlideBuilder.Direction) -> void:
	self._target = target
	self._direction = direction
	
func build() -> Node2D:
	var arrow: Node2D = ARROW_SCENE.instantiate()
	arrow._target = self._target
	arrow._direction = self._direction
	return arrow

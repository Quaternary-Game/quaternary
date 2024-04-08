class_name GameTutorialSlideBuilder extends Object

const GameTutorialSlideScene = preload("res://features/tutorial/game_tutorial_slide.tscn")

enum Direction {
	ABOVE_LEFT,
	ABOVE_RIGHT,
	BELOW_LEFT,
	BELOW_RIGHT,
	BELOW,
	ABOVE,
	LEFT_OF,
	RIGHT_OF,
}

var _tutorial: GameTutorial
var _previous_slide: GameTutorialSlideBuilder
var _next_slide: GameTutorialSlideBuilder
var _title: String
var _description: String
var _arrows: Array[GameTutorialArrowBuilder] = []
var _position_absolute: Vector2
var _position_target: Node
var _position_target_offset: Direction
var _on_open: Callable
var _on_close: Callable
var _on_process: Callable

func _init(tutorial: GameTutorial, previous_slide: GameTutorialSlideBuilder = null) -> void:
	self._tutorial = tutorial
	self._previous_slide = previous_slide

func set_title(name: String) -> GameTutorialSlideBuilder:
	self._title = name
	return self

func set_description(text: String) -> GameTutorialSlideBuilder:
	self._description = text
	return self
	
func add_arrow_relative_to(target: Node, arrow_direction: Direction) -> GameTutorialSlideBuilder:
	self._arrows.append(GameTutorialArrowBuilder.new(target, arrow_direction))
	return self

## Absolute position takes precedence to relative position
func position_at(position: Vector2) -> GameTutorialSlideBuilder:
	self._position_absolute = position
	return self

## Absolute position takes precedence to relative position
func position_relative_to(target: Node, direction: Direction) -> GameTutorialSlideBuilder:
	self._position_target = target
	self._position_target_offset = direction
	return self
	
func on_open(f: Callable) -> GameTutorialSlideBuilder:
	self._on_open = f
	return self
	
func on_close(f: Callable) -> GameTutorialSlideBuilder:
	self._on_close = f
	return self
	
func on_process(f: Callable) -> GameTutorialSlideBuilder:
	self._on_process = f
	return self
	
func next_slide() -> GameTutorialSlideBuilder:
	var next_slide: GameTutorialSlideBuilder = GameTutorialSlideBuilder.new(self._tutorial, self)
	self._next_slide = next_slide
	return next_slide

func build() -> GameTutorialSlide:
	var scene: GameTutorialSlide = GameTutorialSlideScene.instantiate()
	scene._builder = self
	return scene

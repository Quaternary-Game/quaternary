class_name GameTutorial extends Control

const GAME_TUTORIAL_SCENE = preload("res://features/tutorial/game_tutorial.tscn")

var _current_slide: GameTutorialSlide

signal closed(tutorial: GameTutorial)
signal slide_changed(tutorial: GameTutorial, previous_slide: GameTutorialSlide, next_slide: GameTutorialSlide)

static func create() -> GameTutorial:
	return GAME_TUTORIAL_SCENE.instantiate()

func create_head_slide() -> GameTutorialSlideBuilder:
	return GameTutorialSlideBuilder.new(self)

func set_slide(slide: GameTutorialSlide) -> void:
	self.slide_changed.emit(self, self._current_slide, slide)
	if self._current_slide:
		self._current_slide.queue_free()
		self.remove_child(self._current_slide)
	self._current_slide = slide
	self.add_child(self._current_slide)

func close() -> void:
	self.closed.emit(self)
	self.get_parent().remove_child(self)

class_name GameTutorialSlide extends Control

const TARGET_OFFSET_AMOUNT = 100

var _drag_position: Variant

var _builder: GameTutorialSlideBuilder
var _tutorial: GameTutorial

var title_label: Label
var description_label: Label
var prev_slide_button: Button
var next_slide_button: Button

func _ready() -> void:
	self.title_label = $InformationWindow/Content/Header/HeaderContent/TitleLabel
	self.description_label = $InformationWindow/Content/Body/BodyContent/DescriptionLabel
	self.prev_slide_button = $InformationWindow/Content/Footer/FooterContent/PreviousSlideButton
	self.next_slide_button = $InformationWindow/Content/Footer/FooterContent/NextSlideButton
	
	if self._builder:
		# Setup metadata
		self._tutorial = self._builder._tutorial
		
		# Setup Main Content
		self.title_label.text = self._builder._title
		self.description_label.text = self._builder._description
		
		# Setup Previous/Next Buttons
		if not self._builder._previous_slide and not self._builder._next_slide:
			$InformationWindow/Content/Footer.visible = false
		elif not self._builder._previous_slide:
			self.prev_slide_button.visible = false
		elif not self._builder._next_slide:
			self.next_slide_button.visible = false
		
		# Setup Arrows
		for arrow: GameTutorialArrowBuilder in self._builder._arrows:
			$Arrows.add_child(arrow.build())
		
		# Setup Default Window Position
		if self._builder._position_absolute:
			$InformationWindow.global_position = self._builder._position_absolute
		elif self._builder._position_target and self._builder._position_target_offset != null:
			self.call_deferred("_update_relative_position")
			
		# Perform "on open" behavior
		self.call_deferred("_on_open")
		
func _exit_tree() -> void:
	# Perform "on close" behavior
	if self._builder and self._builder._on_close:
		self._builder._on_close.call()

func _on_open() -> void:
	if self._builder and self._builder._on_open:
		self._builder._on_open.call(self)
		
func _process(_delta: float) -> void:
	if self._builder and self._builder._on_process:
		self._builder._on_process.call(self)
		
func _update_relative_position() -> void:
	# Get target position
	var target_position: Vector2
	if self._builder._position_target is Control:
		var control: Control = self._builder._position_target
		var size_offset: Vector2 = control.size
		target_position = control.global_position
		if self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.BELOW:
			target_position += Vector2(size_offset.x / 2, size_offset.y)
		elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.ABOVE:
			target_position += Vector2(size_offset.x / 2, 0)
		elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.LEFT_OF:
			target_position += Vector2(0, size_offset.y / 2)
		elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.RIGHT_OF:
			target_position += Vector2(size_offset.x, size_offset.y / 2)
		elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.BELOW_LEFT:
			target_position += Vector2(0, size_offset.y)
		elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.BELOW_RIGHT:
			target_position += Vector2(size_offset.x, size_offset.y)
		elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.ABOVE_RIGHT:
			target_position += Vector2(size_offset.x, 0)
		
	else:
		target_position = self._builder._position_target.global_position
	
	# Apply offset
	var size_offset: Vector2 = $InformationWindow.size
	if self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.BELOW:
		target_position += Vector2(-size_offset.x / 2, TARGET_OFFSET_AMOUNT)
	elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.ABOVE:
		target_position += Vector2(-size_offset.x / 2, -TARGET_OFFSET_AMOUNT - size_offset.y)
	elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.LEFT_OF:
		target_position += Vector2(-TARGET_OFFSET_AMOUNT - size_offset.x, -size_offset.y / 2)
	elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.RIGHT_OF:
		target_position += Vector2(TARGET_OFFSET_AMOUNT, -size_offset.y / 2)
	elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.BELOW_LEFT:
		target_position += Vector2(-TARGET_OFFSET_AMOUNT - size_offset.x, TARGET_OFFSET_AMOUNT)
	elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.BELOW_RIGHT:
		target_position += Vector2(TARGET_OFFSET_AMOUNT, TARGET_OFFSET_AMOUNT)
	elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.ABOVE_LEFT:
		target_position += Vector2(-TARGET_OFFSET_AMOUNT - size_offset.x, -TARGET_OFFSET_AMOUNT - size_offset.y)
	elif self._builder._position_target_offset == GameTutorialSlideBuilder.Direction.ABOVE_RIGHT:
		target_position += Vector2(TARGET_OFFSET_AMOUNT, -TARGET_OFFSET_AMOUNT - size_offset.y)
	$InformationWindow.global_position = target_position

func _on_header_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			self._drag_position = get_global_mouse_position() - $InformationWindow.global_position
		else:
			self._drag_position = null

	if event is InputEventMouseMotion and _drag_position:
		$InformationWindow.global_position = get_global_mouse_position() - self._drag_position

func _on_close_button_pressed() -> void:
	if self._tutorial:
		self._tutorial.close()
	else:
		self.queue_free()
		self.get_parent().remove_child(self)

func _on_previous_slide_button_pressed() -> void:
	if self._tutorial and self._builder and self._builder._previous_slide:
		self._tutorial.set_slide(self._builder._previous_slide.build())

func _on_next_slide_button_pressed() -> void:
	if self._tutorial:
		if self._builder and self._builder._next_slide:
			self._tutorial.set_slide(self._builder._next_slide.build())
		else:
			self._tutorial.close()

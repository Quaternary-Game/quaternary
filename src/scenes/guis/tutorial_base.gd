class_name TutorialBase extends Button

func _ready() -> void:
	pass

func pause_callable(primary_targets: Array = [], secondary_targets: Array = []) -> void:
	get_tree().paused = true
	for target: Object in primary_targets:
		target.process_mode = Node.PROCESS_MODE_ALWAYS
	for target: Object in secondary_targets:
		target.process_mode = Node.PROCESS_MODE_ALWAYS

func play_callable(primary_targets: Array = [], secondary_targets: Array = []) -> void:
	get_tree().paused = false
	for target: Object in primary_targets:
		target.process_mode = Node.PROCESS_MODE_INHERIT
	for target: Object in secondary_targets:
		target.process_mode = Node.PROCESS_MODE_INHERIT
	
### Takes text to display and creates a formatted label
func label_creator(text: String) -> Label:
	var label: Label = Label.new() # Create a new Label
	label.text = text
	label.name = "TutorialPanel"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 32)
	label.set_offsets_preset(Control.PRESET_TOP_LEFT)
	label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	label.size = Vector2(500, 100)
	var sbox := StyleBoxFlat.new()
	sbox.set_border_width_all(13)
	sbox.border_blend = true
	sbox.bg_color = Color(0, 0, 0, .4)
	sbox.set_corner_radius_all(7)	
	sbox.border_color = Color("8fbcbb")
	label.add_theme_stylebox_override("normal", sbox)
	return label
	
### Highlights and formats all primary targets	
func target_formatter(primary_targets: Array) -> void:
	var i: int = 0
	for target: Object in primary_targets:
		if target:
			var tsBox: = StyleBoxFlat.new()
			tsBox.set_border_width_all(8)
			tsBox.border_blend = true
			tsBox.bg_color = Color("4c566a")
			tsBox.border_color = Color(1, .9, .07, 1)
			tsBox.set_corner_radius_all(13)
			target.add_theme_stylebox_override("normal", tsBox)
			i = i + 1
		else:
			primary_targets.remove_at(i)

### Reverts primary targets back to original theme
func target_reverter(primary_targets: Array) -> void:
	for target: Object in primary_targets:
		var tsBox: = StyleBoxFlat.new()
		tsBox.set_border_width_all(2)
		tsBox.border_blend = false
		tsBox.draw_center = false
		tsBox.border_color = Color("0000003e")
		tsBox.set_corner_radius_all(13)
		target.add_theme_stylebox_override("normal", tsBox)
	
### Used on all slides except first
func new_slide(text: String, start_signal: Signal, end_signal: Signal, primary_targets: Array = [], secondary_targets: Array = [], label_location: Vector2 = Vector2(-200,-200), pause_callable: Callable  = pause_callable, play_callable: Callable = play_callable) -> void:
	start_signal.connect(play_slide.bind(start_signal, end_signal, text, primary_targets, secondary_targets, label_location, pause_callable))
	
###Used on only first tutorial scene
func play_first(text: String, end_signal: Signal, primary_targets: Array = [], secondary_targets: Array = [], label_location: Vector2 = Vector2(-200,-200), pause_callable: Callable  = pause_callable, play_callable: Callable = play_callable) -> void:
	var label: Label = label_creator(text)
	if primary_targets.size() > 0:
		self.add_child(label)
		target_formatter(primary_targets)
		label.global_position = primary_targets[0].global_position + label_location
	else:
		label.position = Vector2(500, 500)
	pause_callable(primary_targets, secondary_targets)
	end_signal.connect(close_slide.bind(label, end_signal, primary_targets, secondary_targets, play_callable))
	
func play_slide(start_signal: Signal,end_signal: Signal, text: String, primary_targets: Array, secondary_targets: Array, label_location: Vector2, pause_callable: Callable) -> void:
	var label: Label = label_creator(text)
	if primary_targets.size() > 0:
		self.add_child(label)
		target_formatter(primary_targets)
		label.global_position = primary_targets[0].global_position + label_location
	else:
		label.position = Vector2(500, 500)
	pause_callable(primary_targets, secondary_targets)
	start_signal.disconnect(play_slide)
	end_signal.connect(close_slide.bind(label, end_signal, primary_targets, secondary_targets, play_callable))

func close_slide(label: Label, end_signal: Signal, primary_targets: Array = [], secondary_targets: Array = [], play_callable: Callable = play_callable) -> void:
	if label:
		label.queue_free()
	target_reverter(primary_targets)
	play_callable(primary_targets, secondary_targets)
	end_signal.disconnect(close_slide)

var Arrow_Scene: Resource = preload("res://scenes/guis/tutorial/arrow.tscn")

func new_arrow(start_signal: Signal, end_signal: Signal, arrow_position_offset: Vector2, arrow_target: Node) -> void:
	start_signal.connect(play_arrow.bind(start_signal, end_signal, arrow_position_offset, arrow_target))
	

func play_first_arrow(end_signal: Signal, arrow_position_offset: Vector2, arrow_target: Node) -> void:
	var arrow: Node2D = Arrow_Scene.instantiate()
	self.add_child(arrow)
	arrow.global_position = arrow_target.global_position + arrow_position_offset
	arrow.rotation = arrow.global_position.direction_to(arrow_target.global_position).angle() + PI/2
	var c : Callable = func(c: Callable) -> void:
		self.close_arrow(arrow, end_signal, c)
	end_signal.connect(
		c.bind(c)
	)
	
func play_arrow(start_signal: Signal, end_signal: Signal, arrow_position_offset: Vector2, arrow_target: Node) -> void:
	play_first_arrow(end_signal, arrow_position_offset, arrow_target)
	start_signal.disconnect(play_slide)

func close_arrow(arrow_obj: Node2D, end_signal: Signal, c: Callable) -> void:
	arrow_obj.queue_free()
	end_signal.disconnect(c)
	
	
	

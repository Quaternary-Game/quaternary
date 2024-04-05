class_name TutorialBase extends Button
var has_started: bool
var has_finished: bool

func _ready() -> void:
	has_started = false
	has_finished = false

func pause_callable(primary_targets: Array = [], secondary_targets: Array = []) -> void:
	print("I am the pause callable!")

func play_callable(primary_targets: Array = [], secondary_targets: Array = []) -> void:
	print("I am the play callable!")
	
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
	label.size = Vector2(400, 100)
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
			target
			var tsBox: = StyleBoxFlat.new()
			tsBox.set_border_width_all(13)
			tsBox.border_blend = true
			tsBox.bg_color = Color("4c566a")
			tsBox.border_color = Color(1, .9, .07, 1)
			tsBox.set_corner_radius_all(7)
			target.add_theme_stylebox_override("normal", tsBox)
			i = i + 1
		else:
			primary_targets.remove_at(i)
	
func new_slide(text: String, start_signal: Signal, end_signal: Signal, primary_targets: Array = [], secondary_targets: Array = [], label_location: Vector2 = Vector2(-200,-200), pause_callable: Callable  = pause_callable, play_callable: Callable = play_callable) -> void:
	start_signal.connect(play_slide.bind(text, primary_targets, secondary_targets, label_location, pause_callable))
	end_signal.connect(close_slide.bind(primary_targets, secondary_targets, play_callable))

func play_slide(text: String, primary_targets: Array, secondary_targets: Array, label_location: Vector2, pause_callable: Callable) -> void:
	if not has_started:
		has_started = true
		var label: Label = label_creator(text)
		if primary_targets.size() > 0:
			primary_targets[0].add_child(label)
			target_formatter(primary_targets)
		label.position = label.position + label_location
		pause_callable(primary_targets, secondary_targets)

func close_slide(primary_targets: Array = [], secondary_targets: Array = [], play_callable: Callable = play_callable) -> void:
	if has_started and not has_finished:
		var path: String = primary_targets[0].get_path()
		print(path)
		print(get_node(path + "/TutorialPanel"))
		get_node(path + "/TutorialPanel").queue_free()
		print("CLosing Slides")
		play_callable(primary_targets, secondary_targets)
		has_finished = true

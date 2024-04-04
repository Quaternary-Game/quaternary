extends Control

var tut: bool = false
var lbl: Label = Label.new() # Create a new Sprite2D
func _ready() -> void:
	pass # Replace with function body.

#func _process(delta: float) -> void:
	#if tut:
		#lbl.position = get_global_mouse_position()


func _on_pressed() -> void:
	lbl.text = "To start with construct the Codons, please click the highlighted start button!"
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var sbox := StyleBoxFlat.new()
	lbl.add_theme_font_size_override("font_size", 32)
	lbl.set_offsets_preset(Control.PRESET_TOP_LEFT)
	lbl.set_anchors_preset(Control.PRESET_CENTER_TOP)
	sbox.set_border_width_all(13)
	sbox.border_blend = true
	sbox.bg_color = Color(0, 0, 0, .4)
	sbox.set_corner_radius_all(7)

	

	sbox.border_color = Color("8fbcbb")
	lbl.add_theme_stylebox_override("normal", sbox)
	var path: String = get_parent().get_path()
	var target: Object = get_node(path + "/StartButton")
	lbl.size = Vector2(400, 100)
	target.add_child(lbl) # Add it as a child of this node.
	lbl.position = lbl.position + Vector2(-400, -400)
	
	var tsBox: = StyleBoxFlat.new()
	tsBox.set_border_width_all(13)
	tsBox.border_blend = true
	tsBox.bg_color = Color("4c566a")
	tsBox.border_color = Color(1, .9, .07, 1)
	tsBox.set_corner_radius_all(7)
	target.add_theme_stylebox_override("normal", tsBox)
	#get_tree().paused = true

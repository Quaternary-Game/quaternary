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
	tut = true
	var sbox := StyleBoxFlat.new()
	lbl.add_theme_font_size_override("font_size", 32)
	lbl.set_offsets_preset(Control.PRESET_TOP_LEFT)
	lbl.set_anchors_preset(Control.PRESET_CENTER_TOP)
	sbox.border_width_left = 10
	sbox.border_width_bottom = 10
	sbox.border_width_right = 10
	sbox.border_width_top = 10
	sbox.border_blend = true
	sbox.set_corner_radius_all(7)
	#sbox.shadow_size = 5
	

	#sbox.set_border_width_all(200)
	sbox.border_color = Color("8fbcbb")
	sbox.draw_center = false
	lbl.add_theme_stylebox_override("normal", sbox)
	var path: String = get_parent().get_path()
	var pos: Object = get_node(path + "/StartButton")
	lbl.size = Vector2(400, 100)
	#lbl.position = Vector2(0, 0)
	get_parent().add_child(lbl) # Add it as a child of this node.
	#print(get_parent())
	#lbl.position = ((get_global_mouse_position() / 2) + Vector2(25, 50))
	#get_tree().paused = true

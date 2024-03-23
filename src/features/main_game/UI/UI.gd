extends Control
var toggle: Button
var trait_menu: Control
var trait_menu_panel: Control
var ogmodulate: Color = self.modulate
const TraitDragButton = preload("res://features/main_game/UI/traits/trait.gd")
signal play(value: bool)
signal trait_drag_start(t: TraitDragButton)
signal trait_drag_end


func _ready() -> void:
	toggle = get_node("VBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer2/ToggleTraitMenu")
	trait_menu_panel = get_node("VBoxContainer/HBoxContainer/MarginContainer/PanelContainer")
	trait_menu = get_node("VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/TraitMenu")
	toggle.toggle_mode = true
	for i : Control in trait_menu.traits():
		i.begin_drag.connect(start_drag_button_handler)
		i.end_drag.connect(end_drag_button_handler)
		
	
func _on_toggle_trait_menu_toggled(toggled_on: bool) -> void:
	print("toggled %s" % toggled_on)
	var tween : Tween = create_tween()

	if toggled_on:
		tween.parallel().tween_property(trait_menu_panel, "modulate", ogmodulate, 0.5)
		tween.parallel().tween_property(trait_menu_panel, "scale", Vector2(1,1), 0.5)
	else:
		trait_menu.pivot_offset = trait_menu.get_rect().size
		tween.parallel().tween_property(trait_menu_panel, "modulate", Color(0,0,0,0), 0.5)
		tween.parallel().tween_property(trait_menu_panel, "scale", Vector2(0, 1), 0.5)
	
		
func start_drag_button_handler(data: Variant) -> void:
	trait_drag_start.emit(data)
func end_drag_button_handler(success: bool) -> void:
	trait_drag_end.emit()



func _on_start_pause_toggled(toggled_on:bool) -> void:
	play.emit(toggled_on)

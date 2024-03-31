extends Control
var toggle: Button
var trait_menu: Control
var trait_menu_panel: Control
var entity_trait_list: Control
var entity_trait_list_item_scene : Resource = preload("res://features/main_game/UI/trait_list/trait_list_item.tscn")
var ogmodulate: Color = self.modulate
const TraitDragButton : Resource = preload("res://features/main_game/UI/traits/trait.gd")
signal play(value: bool)
signal trait_drag_start(t: TraitDragButton)
signal trait_drag_end


func _ready() -> void:
	toggle = get_node("VBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer2/ToggleTraitMenu")
	trait_menu_panel = get_node("VBoxContainer/HBoxContainer/MarginContainer/PanelContainer")
	trait_menu = get_node("VBoxContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/TraitMenu")
	entity_trait_list = get_node("VBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer2/Traitlist")
	toggle.toggle_mode = true
	for i : Control in trait_menu.traits():
		i.begin_drag.connect(start_drag_button_handler)
		i.end_drag.connect(end_drag_button_handler)
		
	
func _on_toggle_trait_menu_toggled(toggled_on: bool) -> void:
	var tween : Tween = create_tween()

	if toggled_on:
		tween.parallel().tween_property(trait_menu_panel, "modulate", ogmodulate, 0.5)
		tween.parallel().tween_property(trait_menu_panel, "scale", Vector2(1,1), 0.5)
	else:
		trait_menu_panel.pivot_offset = trait_menu.get_rect().size
		tween.parallel().tween_property(trait_menu_panel, "modulate", Color(0,0,0,0), 0.5)
		tween.parallel().tween_property(trait_menu_panel, "scale", Vector2(0, 1), 0.5)
	
		
func start_drag_button_handler(data: Variant) -> void:
	trait_drag_start.emit(data)
func end_drag_button_handler(_data: Variant, _success: bool) -> void:
	trait_drag_end.emit()



func _on_start_pause_toggled(toggled_on:bool) -> void:
	play.emit(toggled_on)


func _on_entitymanager_show_traits(entity: EntityGD) -> void:
	for i: Array in entity.genotype.values():
		var l :Control = entity_trait_list_item_scene.instantiate()
		var image_size : int = 30
		# this handles a bug that I have only seen once and have been unable to reproduce
		if not is_instance_valid(i[0]) or not is_instance_valid(i[1]):
			return
		l.append_text("[center]%s\n" % i[0].loci.capitalize())
		l.add_image(i[0].icon, image_size, image_size)
		l.append_text(":")
		l.add_image(i[1].icon, image_size, image_size)

		entity_trait_list.add_child(l)


func _on_entitymanager_end_show_traits() -> void:
	for i: Node in entity_trait_list.get_children():
		if i is RichTextLabel:
			i.queue_free()

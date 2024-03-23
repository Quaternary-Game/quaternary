
extends "res://features/main_game/entitiy_manager/trait_circle.gd"

signal show_traits(entity: EntityGD)
signal end_traits

func _ready() -> void:
	color = Control.new().get_theme_color("entity_selector", "entity_manager" )

func _on_mouse_entered() -> void:
	# this should probably tie into the drag signal somehow
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		animate_circle()
		show_traits.emit(entity)



func _on_mouse_exited() -> void:
	clear_circle()
	end_traits.emit()

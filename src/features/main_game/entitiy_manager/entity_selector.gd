
extends SelectionCircle

signal show_traits(entity: EntityGD)
signal end_traits

var entity: EntityGD

func _ready() -> void:
	color = Control.new().get_theme_color("entity_selector", "entity_manager" )
	self.entity.traits_changed.connect(on_traits_change)

var check_for_trait_changes : bool = false
func _on_mouse_entered() -> void:
	# this should probably tie into the drag signal somehow
	#if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
	animate_circle()
	show_traits.emit(entity)
	check_for_trait_changes = true



func _on_mouse_exited() -> void:
	clear_circle()
	end_traits.emit()
	check_for_trait_changes = false
	

func on_traits_change() -> void:
	if check_for_trait_changes:
		end_traits.emit()
		show_traits.emit(entity)

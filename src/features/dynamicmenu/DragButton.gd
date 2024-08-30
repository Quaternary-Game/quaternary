class_name DragButton extends Button
## Button that can be dragged.
##
## Meant to be used in combination with Dynamic Menu, or any class that implements
## [method DynamicMenu.hide_slide_child] and [method DyanamicMenu.reveal_slide_child]

## set this in child classes to control the drop data of the button, can be anything
## Set to placeholder so drag button works by itself (for testing)
var drop_data: Variant = "placeholder"
# Dragging data is emitted by begin_drag signal
var dragging_data: Variant = "placeholder"

signal begin_drag(data: Variant)
signal end_drag(successful: bool)

var _dragging: bool = false

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview: Control = Control.new()
	var me: DragButton = self.duplicate()
	preview.add_child(me)
	me.position = Vector2(0,0)
	
	get_parent().hide_slide_child(self)
	set_drag_preview(preview)
	_dragging = true
	begin_drag.emit(dragging_data)
	return drop_data

var done: bool = false

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_END:
			if _dragging and !is_drag_successful() and not done:
				SoundPlayer.play_incompatible()
				get_parent().reveal_slide_child(self)
				_dragging = false
				end_drag.emit(false)
			if is_drag_successful() and not self.visible:
				SoundPlayer.play_confirm()
				done = true
				end_drag.emit(true)

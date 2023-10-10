extends Button


var drop_data: Variant = self
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
var dragging: bool = false
func _get_drag_data(at_position):
	var preview = Control.new()
	var me = self.duplicate()
	preview.add_child(me)
	me.position = Vector2(0,0)
	
	get_parent().hide_slide_child(self)
	set_drag_preview(preview)
	dragging = true
	return drop_data
var done: bool = false
func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			if dragging and !is_drag_successful() and not done:
				get_parent().reveal_slide_child(self)
				dragging = false
			if is_drag_successful() and not self.visible:
				done = true

		


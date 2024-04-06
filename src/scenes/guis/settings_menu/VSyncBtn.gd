extends CheckButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
		toggle_mode = true
	else:
		toggle_mode = false

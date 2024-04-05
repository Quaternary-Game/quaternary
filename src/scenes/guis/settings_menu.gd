extends Control

# video settings
#@onready var 

# audio busses
var master_bus:int = AudioServer.get_bus_index("Master")
var music_bus:int = AudioServer.get_bus_index("Music")
var sfx_bus:int = AudioServer.get_bus_index("SFX")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_hc_btn_toggled(toggled_on:bool) -> void:
	pass # Replace with function body.

func _on_cb_btn_toggled(toggled_on:bool) -> void:
	pass # Replace with function body.

func _on_v_sync_btn_toggled(toggled_on:bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

### Update volume

func _on_master_vol_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func _on_music_vol_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

func _on_fx_vol_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))


func _on_exit_pressed() -> void:
	self.visible = false

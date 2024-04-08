extends Control

# audio settings
@onready var master_vol:HSlider = $TabContainer/Audio/MarginContainer/GridContainer/MasterVolSlider
@onready var music_vol:HSlider = $TabContainer/Audio/MarginContainer/GridContainer/MusicVolSlider
@onready var sfx_vol:HSlider = $TabContainer/Audio/MarginContainer/GridContainer/FxVolSlider

# video settings
@onready var vsync:CheckButton = $TabContainer/Video/MarginContainer/GridContainer/VSyncBtn

# audio busses
@onready var master_bus:int = AudioServer.get_bus_index("Master")
@onready var music_bus:int = AudioServer.get_bus_index("Music")
@onready var sfx_bus:int = AudioServer.get_bus_index("SFX")

# Initialize option values
#func _ready() -> void:
	#await vsync.ready
	#
	#master_vol.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	#music_vol.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	#sfx_vol.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
	#
	#var vsync_mode:DisplayServer.VSyncMode = DisplayServer.window_get_vsync_mode()
	#if vsync_mode == DisplayServer.VSYNC_ENABLED:
		#vsync.toggle_mode = true
	#else:
		#vsync.toggle_mode = false


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

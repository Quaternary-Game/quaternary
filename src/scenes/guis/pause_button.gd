extends Control
## controls pausing funcion
##
## Orchestrates pausing function and shows pause menu
## by button press or pause key press

var menu_scene:PackedScene = preload("res://scenes/guis/pause_menu.tscn")
var pause_screen:CanvasLayer
var paused:bool = false
## Grabs the current scenes path, used for restarting scene
@onready var paused_scene:String = SceneSwitching.current_scene.scene_file_path

#func _ready() -> void:
	#paused_scene = get_tree().current_scene.scene_file_path
	
## listens for pause key (esc)
func _process(_delta:float) -> void:
	if not paused:
		if Input.is_action_just_released('pause'):
			show_pause_screen()
			paused = true

## Shows pause screen scene
func show_pause_screen() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pause_screen = menu_scene.instantiate()
	pause_screen.pause = self
	pause_screen.current_scene = self.paused_scene
	$Button.hide()
	get_tree().paused = true
	add_child(pause_screen)

## Pause game and show pause screen on button press
func _on_button_pressed() -> void:
	if not paused:
		show_pause_screen()
		MusicPlayer.pause()
		paused = true

func resume_game() -> void:
	get_tree().paused = false
	$Button.show()
	paused = false
	MusicPlayer.resume()
	pause_screen.queue_free()

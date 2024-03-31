extends CanvasLayer
## pause menu functionality

var pause:Control
var current_scene:String

## listens for escape key to resume game
func _process(_delta:float) -> void:
	if Input.is_action_just_released('pause'):
		pause.resume_game()

func _on_resume_pressed() -> void:
	pause.resume_game()

func _on_exit_pressed() -> void:
	## unpauses system before going to main menu
	get_tree().paused = false
	SceneSwitching.goto_mainmenu()
	MusicPlayer.resume()
	MusicPlayer.play_track2()

func _on_settings_pressed() -> void:
	# add logic to bring up settings screen
	pass 

## go to the current scene, essentially restarting scene
func _on_restart_pressed() -> void:
	get_tree().paused = false
	SceneSwitching.goto_scene(current_scene)
	MusicPlayer.resume()

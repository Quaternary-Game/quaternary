extends CanvasLayer
## pause menu functionality

var pause:Control

func _on_resume_pressed() -> void:
	pause.resume_game()

func _on_exit_pressed() -> void:
	## unpauses system before going to main menu
	get_tree().paused = false
	SceneSwitching.goto_mainmenu()

func _on_settings_pressed() -> void:
	# add logic to bring up settings screen
	pass 

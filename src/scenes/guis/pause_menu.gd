extends Control
## pause menu functionality

var pause:Control

func _on_resume_pressed() -> void:
	get_parent().resume_game()

func _on_exit_pressed() -> void:
	## add logic to reuturn to main menu
	pass

func _on_settings_pressed() -> void:
	# add logic to bring up settings screen
	pass 

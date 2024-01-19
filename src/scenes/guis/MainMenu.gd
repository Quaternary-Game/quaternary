extends Control

func _on_mini_game_button_pressed() -> void:
	SceneSwitching.goto_scene("res://scenes/guis/mini_game_menu.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

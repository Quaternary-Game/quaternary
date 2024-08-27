extends Control

func _ready() -> void:
	MusicPlayer.play_menu()

func _on_mini_game_button_pressed() -> void:
	SceneSwitching.goto_scene("res://scenes/guis/mini_game_menu.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	$SettingsMenu.visible = true

func _on_play_button_pressed() -> void:
	# placeholder, ideally should have level select menu
	# or some more complicated behavior
	SceneSwitching.goto_scene("res://features/main_game/levels/level_1/level_1.tscn")

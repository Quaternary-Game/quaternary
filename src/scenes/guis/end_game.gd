extends Control

func _on_main_menu_button_pressed() -> void:
	SceneSwitching.goto_mainmenu()

func _on_restart_button_pressed() -> void:
	SceneSwitching.goto_scene(SceneSwitching.current_scene.scene_file_path)

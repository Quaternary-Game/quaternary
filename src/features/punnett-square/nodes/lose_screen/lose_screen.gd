extends Control

var minigame:bool

## Return to main menu on menu button pressed
func _on_button_pressed() -> void:
		SceneSwitching.goto_mainmenu()


func _on_next_pressed() -> void:
	if minigame:
		SceneSwitching.restart_scene()

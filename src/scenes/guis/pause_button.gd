extends Control
## controls pausing funcion
##
## Orchestrates pausing function and shows pause menu
## by button press or pause key press

var menu_scene:PackedScene = preload("res://scenes/guis/pause_menu.tscn")
var pause_screen:CanvasLayer
var paused:bool = false

## listens for pause key (esc)
func _process(_delta:float) -> void:
	if not paused:
		if Input.is_action_pressed('pause'):
			show_pause_screen()
			paused = true

## Shows pause screen scene
func show_pause_screen() -> void:
	pause_screen = menu_scene.instantiate()
	pause_screen.pause = self
	$Button.hide()
	get_tree().paused = true
	add_child(pause_screen)

## Show pause screen on button press
func _on_button_pressed() -> void:
	if not paused:
		show_pause_screen()
		paused = true

func resume_game() -> void:
	get_tree().paused = false
	$Button.show()
	paused = false
	pause_screen.queue_free()

extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed('pause'):
		show_pause_screen()

func show_pause_screen():
	pass

func _on_button_pressed():
	show_pause_screen()

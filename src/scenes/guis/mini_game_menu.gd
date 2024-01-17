extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$play_button.disabled = true


func _on_pressed() -> void:
	$play_button.disabled = false

func _on_play_button_pressed() -> void:
	var mini_game: String = $mini_game_scroller/mini_game_box/build_the_codons.button_group.get_pressed_button().text
	print(mini_game)
	#Add scene switch to appropriate mini game

func _on_main_menu_button_pressed() -> void:
	pass # Replace with scene switch to main

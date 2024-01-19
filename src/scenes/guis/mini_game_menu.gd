extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$play_button.disabled = true


func _on_pressed() -> void:
	$play_button.disabled = false

func _on_play_button_pressed() -> void:
	if $mini_game_scroller/mini_game_box/build_the_codons.button_pressed:
		SceneSwitching.goto_scene('res://features/codon_minigame/main.tscn')
	elif $mini_game_scroller/mini_game_box/punnet_square.button_pressed:
		SceneSwitching.goto_scene('res://features/punnett-square/nodes/main/main.tscn')
	elif $mini_game_scroller/mini_game_box/mutation_minigame.button_pressed:
		SceneSwitching.goto_scene('res://features/mutation_minigame/nodes/main/main.tscn')
		
func _on_main_menu_button_pressed() -> void:
	SceneSwitching.goto_mainmenu()

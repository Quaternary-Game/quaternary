extends TutorialBase
var click: Object
var start: Object
var active: bool
# Called when the node enters the scene tree for the first time.

func _on_pressed() -> void:
	#get_tree().call_group("mobs", "queue_free")
	active = true
	click = self.get_parent().get_node("ContinueButton")
	start = self.get_parent().get_node("HUD/StartButton")
	click.show()
	play_first("Welcome to Construct The Codons! Click the 'Continue' button to start the tutorial.", click.pressed, [click], [], Vector2(-900, -500))
	new_slide("Move your mouse and collect the floating nucleotides that correspond to the mRNA at the top of the screen. Press 'Start' to begin!", click.pressed, start.pressed, [start], [], Vector2(-125, -500))
	#new_slide("Be sure to avoid catching nucleotides in the wrong order! Press the 'Start' button to begin!", click.pressed, start.pressed, [start], [], Vector2(-900, -500))

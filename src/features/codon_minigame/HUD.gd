extends CanvasLayer
signal start_game
signal next_level

func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_acid(text: String) -> void:
	$GoalAcid.text = "Goal: " + text
	$GoalAcid.show()

func show_game_over(highScore: String) -> void:
	$GoalAcid.hide()
	show_message("Incorrect! Game Over!\nHigh Score: %s" %highScore)
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	
	$Message.show()
	$StartButton.show()

func show_next_level(_score: int) -> void:
	show_message("Correct! Speeding Up!")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	$Message.show()
	next_level.emit()

func update_score(score: int) -> void:
	$ScoreLabel.text = "Score: " + str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	get_parent().get_node("TutorialButton").hide()
	get_parent().get_node("MouseClickButton").hide()
	start_game.emit()
	print($StartButton.get_path())

func _on_message_timer_timeout() -> void:
	$Message.hide()
	

extends CanvasLayer
signal start_game
signal next_level

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_acid(text):
	$GoalAcid.text = "Goal: " + text
	$GoalAcid.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func show_game_over(highScore):
	$GoalAcid.hide()
	show_message("Incorrect! Game Over!")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	
	$Message.show()
	$StartButton.show()
	
func show_next_level(score):
	show_message("Correct! Speeding Up!")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	$Message.show()
	next_level.emit()
	
func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

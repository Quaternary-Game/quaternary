extends Control
## Main script running Punnett square game

@export var time:int = 6 ## total time for the level
## genotypes of the parents
@export var parent1_genotype:String
@export var parent2_genotype:String

var countdown:int ## current time left
## scenes
var game_over_sound:AudioStream = preload("res://features/sound-effects/assets/game_over.wav")
var punnett_square_scene:PackedScene = preload('res://features/punnett-square/nodes/punnet_square/punnett_square.tscn')
var select_scene:PackedScene = preload("res://features/punnett-square/nodes/select_screen/select_screen.tscn")

var flashes:int ## number of times to flash timer

## set up start screen
func _ready() -> void:
	countdown = time
	$StartScreen/Label.text = "You have %s second to fill\nthe Punnett Square" % str(self.time)
	$Countdown.text = str(countdown)

## runs each second
## restarts timer and updates HUD timer
func _on_timer_timeout() -> void:
	# update countdown and label
	countdown -= 1
	$Countdown.text = str(countdown)
	
	# trigger game end if time is up
	if countdown == 0:
		game_over()
		$Timer.stop()
		return
		
  
	if countdown == 1:
		flashes = 5
	elif countdown <= 3:
		flashes = 3
	elif countdown <= 5:
		flashes = 2
	elif countdown <= 10:
		flashes = 1

	for i in flashes: 
		$Countdown.visible = false
		await get_tree().create_timer(0.1).timeout
		$Countdown.visible = true	
		await get_tree().create_timer(0.1).timeout

## Show game over screen
func game_over() -> void:
	get_node("PunnettSquare").queue_free()
	$EndGame.text = "Time's Up!"
	$AudioStreamPlayer2D.stream = game_over_sound
	$AudioStreamPlayer2D.play()

## set up main game screen and punnett square and start game
func start_game() -> void:
	# initiate and build punnett square
	var punnett_square:GridContainer = punnett_square_scene.instantiate()
	punnett_square.build_square(self.parent1_genotype, self.parent2_genotype)
	self.add_child(punnett_square)
	punnett_square.game_won.connect(_on_punnett_square_game_won)
	$Timer.start(1)
	$StartScreen.queue_free()

## Set up post game screen for selecting offspring
func show_select_screen(offspring_set:Dictionary) -> void:
	$EndGame.visible = false
	$Countdown.visible = false
	
	var select_screen:Control = select_scene.instantiate()
	select_screen.set_choices(offspring_set)
	self.add_child(select_screen)

## Show win screen and transition to select screen
func _on_punnett_square_game_won() -> void:
	var offspring_set:Dictionary = get_node("PunnettSquare").get_offspring_set()
	$PunnettSquare.queue_free()
	$Timer.stop()
	$EndGame.text = "You Won!"
	# play winning sound
	
	# wait a few seconds before switching to select screen
	await get_tree().create_timer(3).timeout
	show_select_screen(offspring_set)

## start game when ready button is clicked
func _on_button_pressed() -> void:
	start_game()
	

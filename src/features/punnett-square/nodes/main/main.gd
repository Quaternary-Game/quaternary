extends Control
## Main script running Punnett square game

var time:int = 10 ## total time for the level
## genotypes of the parents
var parent1_genotype:String
var parent2_genotype:String

var countdown:int ## current time left
## scenes
var punnett_square_scene:PackedScene = preload('res://features/punnett-square/nodes/punnet_square/punnett_square.tscn')
var select_scene:PackedScene = preload("res://features/punnett-square/nodes/select_screen/select_screen.tscn")
var lose_scene:PackedScene = preload("res://features/punnett-square/nodes/lose_screen/lose_screen.tscn")

var flashes:int ## number of times to flash timer
var minigame:bool = true ## flag indicated whether launched as standalone minigame

var genotypes:Array = [
	['Aa', 'aa'],
	['bb', 'BB'],
	['AAbb', 'AaBB'],
	['aaBB','AaBb']
	#['AaBbCc', 'aabbcc']
]
var rng:RandomNumberGenerator

## set up start screen
func _ready() -> void:
	# choose random genotypes if standalone minigame
	if minigame:
		rng=RandomNumberGenerator.new()
		var choice:int = rng.randf_range(0, genotypes.size())
		parent1_genotype = genotypes[choice][0]
		parent2_genotype = genotypes[choice][1]
	
	time = 10 * 4**(parent1_genotype.length()/2 - 1)
	
	MusicPlayer.play_new_beginnings()
	
	countdown = time
	$StartScreen/Label.text = "You have %s seconds to fill\nthe Punnett Square" % str(self.time)
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


	for i : int in flashes:
		SoundPlayer.play_tick()
		$Countdown.visible = false
		await get_tree().create_timer(0.1).timeout
		$Countdown.visible = true	
		await get_tree().create_timer(0.1).timeout

## Show game over screen
func game_over() -> void:
	get_node("PunnettSquare").queue_free()
	$TutorialButton.visible = false
	SoundPlayer.play_game_over()
	show_lose_screen()

## set up main game screen and punnett square and start game
func start_game() -> void:
	$PauseButton.visible = true
	# initiate and build punnett square
	var punnett_square:GridContainer = punnett_square_scene.instantiate()
	punnett_square.build_square(self.parent1_genotype, self.parent2_genotype)
	punnett_square.create_tutorial($TutorialButton)
	self.add_child(punnett_square)
	punnett_square.game_won.connect(_on_punnett_square_game_won)
	$Timer.start(1)
	$StartScreen.queue_free()
	$TutorialButton.visible = true

## Set up post game screen for selecting offspring
func show_select_screen(offspring_set:Dictionary) -> void:
	$PauseButton.visible = false
	$EndGame.visible = false
	$Countdown.visible = false
	
	var select_screen:Control = select_scene.instantiate()
	select_screen.set_choices(offspring_set)
	select_screen.minigame = self.minigame
	self.add_child(select_screen)

## Set up post game screen when player loses
func show_lose_screen() -> void:
	$PauseButton.visible = false
	$EndGame.visible = false
	$Countdown.visible = false
	
	var lose_screen:Control = lose_scene.instantiate()
	lose_screen.minigame = self.minigame
	self.add_child(lose_screen)

## Show win screen and transition to select screen
func _on_punnett_square_game_won() -> void:
	# could add victory sound here
	var offspring_set:Dictionary = get_node("PunnettSquare").get_offspring_set()
	$PunnettSquare.queue_free()
	$Timer.stop()
	$EndGame.text = "You Won!"
	$TutorialButton.visible = false
	# play winning sound
	SoundPlayer.play_complete()
	# wait a few seconds before switching to select screen
	await get_tree().create_timer(3).timeout
	show_select_screen(offspring_set)

## start game when ready button is clicked
func _on_button_pressed() -> void:
	start_game()
	

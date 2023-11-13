extends Control

@export var time:int = 6
@export var parent1_genotype:String
@export var parent2_genotype:String

var countdown:int
var game_over_sound:AudioStream = preload("res://features/sound-effects/assets/game_over.wav")
var punnett_square_scene:PackedScene = preload('res://features/punnett-square/nodes/punnet_square/punnett_square.tscn')
var select_scene:PackedScene = preload("res://features/punnett-square/nodes/select_screen/select_screen.tscn")

var flashes:int

# Called when the node enters the scene tree for the first time.
func _ready():
	countdown = time
	$StartScreen/Label.text = "You have %s second to fill\nthe Punnett Square" % str(self.time)
	$Countdown.text = str(countdown)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	# update countdown and label
	countdown -= 1
	$Countdown.text = str(countdown)
	
	# trigger game end if time is up
	if countdown == 0:
		game_over()
		$Timer.stop()
		return
		
	if countdown <= 10:
		flashes = 1
		if countdown <= 5:
			flashes = 2
			if countdown <= 3:
				flashes = 3
				if countdown == 1:
					flashes = 5

	for i in flashes: 
		$Countdown.visible = false
		await get_tree().create_timer(0.1).timeout
		$Countdown.visible = true	
		await get_tree().create_timer(0.1).timeout

func game_over():
	get_node("PunnettSquare").queue_free()
	$EndGame.text = "Time's Up!"
	$AudioStreamPlayer2D.stream = game_over_sound
	$AudioStreamPlayer2D.play()

func start_game():
	# initiate and build punnett square
	var punnett_square:GridContainer = punnett_square_scene.instantiate()
	punnett_square.build_square(self.parent1_genotype, self.parent2_genotype)
	self.add_child(punnett_square)
	punnett_square.game_won.connect(_on_punnett_square_game_won)
	$Timer.start(1)
	$StartScreen.queue_free()

func show_select_screen(offspring_set:Dictionary):
	$EndGame.visible = false
	$Countdown.visible = false
	
	var select_screen:Control = select_scene.instantiate()
	select_screen.set_choices(offspring_set)
	self.add_child(select_screen)

func _on_punnett_square_game_won():
	var offspring_set:Dictionary = get_node("PunnettSquare").get_offspring_set()
	$PunnettSquare.queue_free()
	$Timer.stop()
	$EndGame.text = "You Won!"
	# play winning sound
	
	# wait a few seconds before switching to select screen
	await get_tree().create_timer(3).timeout
	show_select_screen(offspring_set)

func _on_button_pressed():
	start_game()
	

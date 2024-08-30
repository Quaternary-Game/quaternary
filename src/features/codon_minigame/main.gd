extends Node

@export var mob_scene: PackedScene

# file path for game save
const save_path:String = "user://gamesave.save"

var score : int = 0
var highScore : int
# consider an enum here to enforce better typing
var acids :Dictionary= {"Phenylalanine": ["UUU", "UUC"], "Leucine": ["UUA", "UUG"], "Serine": ["UCU", "UCC", "UCA", "UCG"], "Tyrosine": ["UAU", "UAC"], "Cysteine": ["UGU", "UGC"], "Tryptophan": ["UGG"] }
var goalAcid: String
var codons :String = ""

func _ready() -> void:
	MusicPlayer.play_track4()
	#self.get_parent().get_node("ContinueButton").hide()
	load_game()

func win() -> void:
	$MobTimer.stop()
	$Player/CollisionShape2D.set_deferred("disabled", true)
	get_tree().call_group("mobs", "queue_free")
	score += 1
	SoundPlayer.play_complete()
	$HUD.show_next_level(score)

func lose() -> void:
	SoundPlayer.play_game_over()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Player/CollisionShape2D.set_deferred("disabled", true)
	if int(score) > int(highScore):
		highScore = score
		save_game()
	score = 0
	$Player.set_deferred("started", false)
	$HUD.show_game_over(str(highScore))


func new_game() -> void:
	$Player.start($StartPosition.position)
	next_level()

func next_level() -> void:
	goalAcid = acids.keys()[(randi() % acids.size())]
	codons = ""
	$Player/Codons.set_deferred("text", "")
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_acid(goalAcid + '\n' + "mRNA: " + str(to_anti_codon(acids[goalAcid])).substr(1, str(acids[goalAcid]).length() - 2))
	$HUD.show_message("Good Luck!")
	get_tree().call_group("mobs", "queue_free")
	$Player/CollisionShape2D.set_deferred("disabled", false)


func to_anti_codon(_codons: Array) -> Array[String]:
	var antiCodons: Array[String] = []
	for  codon : String in _codons:
		var antiCodon : String = ""
		for c : String in codon:
			if (c == 'U'):
				antiCodon += 'A'
			elif (c == 'A'):
				antiCodon += 'U'
			elif (c == 'C'):
				antiCodon += 'G'
			else:
				antiCodon += 'C'
		antiCodons.append(antiCodon)
	return antiCodons
		
func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob : Node = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location :Node = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction : float = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = 0

	# Choose the velocity for the mob.
	var velocity: Vector2 = Vector2(randf_range(150.0 + score * score * 20, 250.0 + score * 40), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_score_timer_timeout() -> void:
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func node_hit(body: Node2D) -> void:

	SoundPlayer.play_grab()

	var _temp :Node = body.get_node("AnimatedSprite2D")

	codons += body.get_node("AnimatedSprite2D/Letter").text
	print(codons)
	if codons.length() >= 3:
		if acids[goalAcid].has(codons):
			win()
		else:
			lose()
	body.queue_free()

# saves scene data to a save file
func save_game() -> void:
	var file:FileAccess = FileAccess.open(self.save_path, FileAccess.WRITE)
	var json:String = JSON.stringify(save())
	file.store_line(json)

# returns dictionary of data to be saved from this scene
func save() -> Dictionary:
	var save_data:Dictionary = {
		'filename':self.get_scene_file_path(),
		'high_score':self.highScore
	}
	
	return save_data

# loads scene variables from save file
func load_game() -> void:
	# access variables from file if it exists
	if FileAccess.file_exists(self.save_path):
		# open file 
		var file:FileAccess = FileAccess.open(self.save_path, FileAccess.READ)
		# create a json object to use for parsing
		var json:JSON = JSON.new()
		# parse data into json object
		json.parse(file.get_line())
		# retreive data into dictionary variable
		var data:Variant = json.data
		
		# set scene variables
		self.highScore = data['high_score']
		
	# otherwise set to default values
	else:
		self.highScore = 0

extends Node

@export var mob_scene: PackedScene
var score : int = 0
var highScore : int = 0
# consider an enum here to enforce better typing
var acids := {"Phenylalanine": ["UUU", "UUC"], "Leucine": ["UUA", "UUG"], "Serine": ["UCU", "UCC", "UCA", "UCG"], "Tyrosine": ["UAU", "UAC"], "Cysteine": ["UGU", "UGC"], "Tryptophan": ["UGG"] }
var goalAcid: String
var codons := ""

var arrow : Resource = preload("res://features/codon_minigame/art/arrow.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(arrow, 0, Vector2(12, 12))

func win() -> void:
	$MobTimer.stop()
	$Player/CollisionShape2D.set_deferred("disabled", true)
	get_tree().call_group("mobs", "queue_free")
	score += 1
	$HUD.show_next_level(score)

func lose() -> void:
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Player/CollisionShape2D.set_deferred("disabled", true)
	if int(score) > int(highScore):
		highScore = score
	score = 0
	$Player.set_deferred("started", false)
	$HUD.show_game_over(str(highScore))
	$Music.stop()


func new_game() -> void:
	$Music.play()
	$Player.start($StartPosition.position)
	next_level()

func next_level() -> void:
	goalAcid = acids.keys()[(randi() % acids.size())]
	codons = ""
	$Player/Codons.set_deferred("text", "")
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_acid(goalAcid + '\n' + "mRNA: " + str(to_anti_codon(acids[goalAcid])).substr(1, str(acids[goalAcid]).length() - 2))
	$HUD.show_message("Create the amino acid by matching the mRNA to codons!")
	get_tree().call_group("mobs", "queue_free")
	$Player/CollisionShape2D.set_deferred("disabled", false)


func to_anti_codon(codons: Array) -> Array[String]:
	var antiCodons: Array[String] = []
	for  codon : String in codons:
		var antiCodon := ""
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
	var mob := mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location := get_node("MobPath/MobSpawnLocation")
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
	var temp := body.get_node("AnimatedSprite2D")
	codons += body.get_node("AnimatedSprite2D/Letter").text
	print(codons)
	if codons.length() >= 3:
		if acids[goalAcid].has(codons):
			win()
		else:
			lose()
	body.queue_free()

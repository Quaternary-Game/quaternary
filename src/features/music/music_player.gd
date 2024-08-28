extends Node

var player:AudioStreamPlayer
var paused_player:AudioStreamPlayer

var track1: AudioStream = preload("res://features/music/assets/Mutation Master Gameplay.wav")
var track2: AudioStream = preload("res://features/music/assets/Main Game Gameplay.wav")
var track3: AudioStream = preload("res://features/music/assets/Punnett Square Solver Gameplay.wav")
var track4: AudioStream = preload("res://features/music/assets/Construct the Codons Gameplay.wav")

var pause1: AudioStream = preload("res://features/music/assets/Mutation Master Pause.wav")
var pause2: AudioStream = preload("res://features/music/assets/Main Game Pause.wav")
var pause3: AudioStream = preload("res://features/music/assets/Punnett Square Solver Pause.wav")
var pause4: AudioStream = preload("res://features/music/assets/Construct the Codons Pause.wav")

var menu: AudioStream = preload("res://features/music/assets/Menu Track.wav")

var MPT1: AudioStream = preload("res://features/music/assets/MPT1.mp3")
var MPT2: AudioStream = preload("res://features/music/assets/MPT2.mp3")
var sketching:AudioStream = preload("res://features/music/assets/Sketching.mp3")
var new_beginnings:AudioStream = preload("res://features/music/assets/New_Beginnings.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = AudioStreamPlayer.new()
	player.bus = "Music"
	player.stream = menu
	player.autoplay = true
	add_child(player)
	paused_player = AudioStreamPlayer.new()
	paused_player.stream = menu
	paused_player.bus = "Music"
	add_child(paused_player)

func play_track1() -> void:
	play_track(track1, pause1)

func play_track2() -> void:
	play_track(track2, pause2)
	
func play_track3() -> void:
	play_track(track3, pause3)

func play_track4() -> void:
	play_track(track4, pause4)
	
func play_menu() -> void:
	play_track(menu)

func play_sketching() -> void:
	play_track(sketching)

func play_new_beginnings() -> void:
	play_track(new_beginnings)

func play_MPT() -> void:
	play_track(MPT1, MPT2)
var player_tween: Tween
func pause() -> void:
	paused_player.volume_db = -80
	paused_player.play(player.get_playback_position())
	if player_tween:
		player_tween.kill()
	player_tween = create_tween().set_parallel(true)
	player_tween.set_ease(Tween.EASE_OUT)
	player_tween.parallel().tween_property(paused_player, "volume_db", 0, 3)
	player_tween.parallel().tween_property(player, "volume_db", -80, 10)
	await player_tween.finished
	print("Player Stopped")
	player.stop()
	
func resume() -> void:
	player.play(paused_player.get_playback_position())
	if player_tween:
		player_tween.kill()
	player_tween = create_tween().set_parallel(true)
	player_tween.set_ease(Tween.EASE_OUT)
	player_tween.parallel().tween_property(player, "volume_db", 0, 3)
	player_tween.parallel().tween_property(paused_player, "volume_db", -80, 10)
	await player_tween.finished
	paused_player.stop()
	
	
func play_track(play_track:AudioStream, pause_track:AudioStream = track2) -> void:
	if player.stream != play_track:
		if player_tween:
			player_tween.kill()
		player_tween = create_tween().set_parallel(true)
		player_tween.set_ease(Tween.EASE_OUT)
		player_tween.parallel().tween_property(paused_player, "volume_db", -80, 1)
		player_tween.parallel().tween_property(player, "volume_db", -80, 1)
		await player_tween.finished
		paused_player.stop()
		player.stop()
		
		player.stream = play_track
		paused_player.stream = pause_track
		
		player_tween.kill()
		player_tween = create_tween().set_parallel(true)
		player_tween.set_ease(Tween.EASE_OUT)
		player_tween.parallel().tween_property(player, "volume_db", 0, 1)
		player.play()
		

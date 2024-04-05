extends Node

var player:AudioStreamPlayer
var paused_player:AudioStreamPlayer

var track2:AudioStream = preload("res://features/music/assets/Track_2.mp3")
var sketching:AudioStream = preload("res://features/music/assets/Sketching.mp3")
var new_beginnings:AudioStream = preload("res://features/music/assets/New_Beginnings.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = AudioStreamPlayer.new()
	player.bus = "Music"
	add_child(player)
	paused_player = AudioStreamPlayer.new()
	paused_player.stream = track2
	add_child(paused_player)

func play_track2() -> void:
	play_track(track2)

func play_sketching() -> void:
	play_track(sketching)

func play_new_beginnings() -> void:
	play_track(new_beginnings)

func pause() -> void:
	player.stream_paused = true
	paused_player.play()
	
func resume() -> void:
	paused_player.stop()
	player.stream_paused = false
	
func play_track(track:AudioStream) -> void:
	if player.stream != track:
		player.stop()
		player.stream = track
		player.play()

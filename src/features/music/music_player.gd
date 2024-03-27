extends Node

var player:AudioStreamPlayer

var track2:AudioStream = preload("res://features/music/assets/Track_2.mp3")
var sketching:AudioStream = preload("res://features/music/assets/Sketching.mp3")
var new_beginnings:AudioStream = preload("res://features/music/assets/New_Beginnings.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)

func play_track2() -> void:
	if player.stream != track2:
		player.stream = track2
		player.play()

func play_sketching() -> void:
	if player.stream != sketching:
		player.stream = sketching
		player.play()

func play_new_beginnings() -> void:
	if player.stream != new_beginnings:
		player.stream = new_beginnings
		player.play()

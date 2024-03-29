extends Node
## Singleton for handling/playing sound effects

## AudioStream object for all sound effects
var streams:Dictionary = {
	'select': preload("res://features/sound-effects/assets/select.mp3")
}

#@onready var player:AudioStreamPlayback

## All AudioStreamPlayers, one for each stream
var players:Dictionary

func _ready() -> void:	
	# add all AudioStreamPlayers to the scene tree
	# and set the correct stream
	for sound:String in streams:
		players[sound] = AudioStreamPlayer.new()
		add_child(players[sound])
		players[sound].stream = streams[sound]
		
	# this makes sure we connect buttons that 
	# in the main menu
	connect_buttons(get_tree().root)
	
	# connect signal for nodes added
	get_tree().node_added.connect(_on_node_added)

func connect_buttons(root:Node) -> void:
	for child in root.get_children():
		if child is Button:
			child.pressed.connect(play_select)
		connect_buttons(child)
		
func _on_node_added(node:Node) -> void:
	if node is Button:
		node.pressed.connect(play_select)

func play_select() -> void:
	players.select.play(0.25)

extends Node
## Singleton for handling/playing sound effects

## AudioStream object for all sound effects
var streams:Dictionary = {
	'select': preload("res://features/sound-effects/assets/select.mp3"),
	'hover': preload("res://features/sound-effects/assets/hover.mp3")
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
	
	players.select.volume_db = -12
	players.hover.volume_db = -12
	
	# this makes sure we connect buttons that 
	# in the main menu
	connect_buttons(get_tree().root)
	
	# connect signal for nodes added
	get_tree().node_added.connect(_on_node_added)
	
	

# recursive function for initial signal connection
func connect_buttons(root:Node) -> void:
	for child in root.get_children():
		if child is Button:
			child.pressed.connect(play_select)
			child.mouse_entered.connect(play_hover)
		connect_buttons(child)

# connect button press signal when node added to tree
func _on_node_added(node:Node) -> void:
	if node is Button:
		node.pressed.connect(play_select)
		node.mouse_entered.connect(play_hover)

# play sound functions
func play_select() -> void:
	players.select.play(0.25)

func play_hover() -> void:
	players.hover.play(0.15)

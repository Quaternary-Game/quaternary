extends Node
## Singleton for handling/playing sound effects

## AudioStream object for all sound effects
var streams:Dictionary = {
	'select': preload("res://features/sound-effects/assets/select.mp3"),
	'hover': preload("res://features/sound-effects/assets/hover.mp3"),
	'crunch': preload("res://features/sound-effects/assets/crunch.wav"),
	'incompatible': preload("res://features/sound-effects/assets/incompatible.ogg"),
	'confirm': preload("res://features/sound-effects/assets/confirm.ogg"),
	'game_over': preload("res://features/sound-effects/assets/game_over.wav"),
	'complete': preload('res://features/sound-effects/assets/complete.wav'),
	'grab': preload('res://features/sound-effects/assets/grab.ogg'),
	'tick': preload('res://features/sound-effects/assets/tick.ogg'),
	'bite': preload('res://features/sound-effects/assets/bite.wav')
}

## All AudioStreamPlayers, one for each stream
var players:Dictionary

func _ready() -> void:	
	# add all AudioStreamPlayers to the scene tree
	# and set the correct stream
	for sound:String in streams:
		players[sound] = AudioStreamPlayer.new()
		add_child(players[sound])
		players[sound].stream = streams[sound]
		players[sound].bus = "SFX"
		players[sound].volume_db = -12
	
	
	#players.select.volume_db = -12
	#players.hover.volume_db = -12
	#players.confirm.volume_db = -12
	#players.grab.volume_db = -12
	#players.incompatible.volume_db = -12
	#players.bite.volume_db = -12
	#players.complete.volume_db = -12
	players.game_over.volume_db = -6
	
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

func play_crunch() -> void:
	players.crunch.play()
	
func play_incompatible() -> void:
	players.incompatible.play()
	
func play_confirm() -> void:
	players.confirm.play()

func play_game_over() -> void:
	players.game_over.play()
	
func play_complete() -> void:
	players.complete.play()

func play_grab() -> void:
	players.grab.play()

func play_tick() -> void:
	players.tick.play()
	
func play_bite() -> void:
	players.bite.play()

func play_all() -> void:
	for player:String in players:
		players[player].play()
		await get_tree().create_timer(1).timeout

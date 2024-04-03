extends Label

@export var time_until_game_over: float = 120
var timer : Timer = Timer.new()
var paused: bool:
	get:
		return timer.paused
	set(value):
		timer.paused = value
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_game_over)
	add_child(timer)
	timer.start(time_until_game_over)
	paused = true
		
signal game_over

func _game_over() -> void:
	game_over.emit()
func _process(delta: float) -> void:
	text = "%.2f" % timer.time_left

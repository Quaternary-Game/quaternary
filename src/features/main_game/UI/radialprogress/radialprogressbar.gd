extends TextureProgressBar

@export var high_percent : float = 90:
	set(v):
		high_percent = v
		high_value = max_value * v
@export var low_percent : float = 10:
	set(v):
		low_percent = v
		low_value = max_value * v
		
var high_value: float
var low_value : float

@onready var high_color: Color = get_theme_color("green", "pallete")
@onready var medium_color: Color = get_theme_color("yellow", "pallete")
@onready var low_color : Color = get_theme_color("red", "pallete")

func _init() -> void:
	self.value_changed.connect(on_value_change)
func _ready() -> void:
	value = value-1
	value = value+1
func on_value_change(v: float) -> void:
	if v >= high_value:
		tint_progress = high_color
	elif v <= low_value:
		tint_progress = low_color
	else:
		tint_progress = medium_color
	$Label.text = str(v)

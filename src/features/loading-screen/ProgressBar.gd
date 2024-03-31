@tool
extends Control

var start : Vector2 = Vector2(-400, 0)
var end: Vector2 = Vector2(400, 0)
var speed :int = 200
var start_color : Color = Control.new().get_theme_color("green", "pallete")
var end_color : Color = Control.new().get_theme_color("red", "pallete")

var progress_position: Vector2
signal done
var tween : Tween
@export var value: float = 0:
	set(v):
		if v > value:
			value = v
			
		if round(progress) >= 101:
			progress = 0
			done.emit()
			

@export_range(0, 100) var progress: float:
	set(v):
		progress = v
		progress_position = start.lerp(end, progress/100)
		queue_redraw()

func _ready() -> void:
	$Spider.speed_scale = speed/100

func _draw() -> void:
	$Spider.position = progress_position
	draw_line(start, progress_position, start_color, 1, true)
	draw_line(progress_position, end, end_color, 1, true)

func _process(delta: float) -> void:
	if value > progress:
		progress = progress + delta * speed

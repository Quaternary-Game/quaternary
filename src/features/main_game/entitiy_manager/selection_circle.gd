class_name SelectionCircle extends Node2D


@export var initial_size : int = 0
@export var final_size : int = 100



var color := Control.new().get_theme_color("circle", "trait")
var circle_size : int = initial_size:
	get:
		return circle_size
	set(value):
	
		circle_size = value
		queue_redraw()


func animate_circle() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self, "circle_size", final_size, 0.2)
	
func clear_circle() -> void:
	# can't use same tween for both, not sure why
	var tween : Tween = create_tween()
	tween.tween_property(self, "circle_size", initial_size, 0.2)
	await tween.finished

func _draw() -> void:
	draw_arc(self.position, circle_size, 0, 2*PI, 100, color)

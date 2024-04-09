@tool
class_name LightDirected extends Area2D

@export var color : Color = Color.YELLOW
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

@export_range(0, 1) var intensity : float :
	get:
		return color.a
	set(value):
		color.a = value
		queue_redraw()

@export var radius : float :
	get:
		var shape: Shape2D = collision_shape.shape
		if shape is CircleShape2D:
			return shape.radius
		return 200
	set(value):
		if collision_shape:
			var shape: Shape2D = collision_shape.shape
			if shape is CircleShape2D:
				shape.radius = value
		else:
			self._deferred_radius = value
		queue_redraw()

var _deferred_intensity: float
var _deferred_radius: float



func _draw() -> void:
	var background_color: Color = color
	var border_color: Color = color
	background_color.a = color.a/8
	border_color.a = 1
	#draw_circle(Vector2.ZERO, radius, background_color)
	draw_arc(Vector2.ZERO, int(radius), 0, 2 * PI, 100, border_color, 1, true)

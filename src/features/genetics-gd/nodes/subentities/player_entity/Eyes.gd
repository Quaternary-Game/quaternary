@tool
extends Node2D

@export var eye_radius: float = 10:
	set(value):
		eye_radius = value
		queue_redraw()
		
@export var eyeball_radius: float = 5:
	set(value):
		eyeball_radius = value
		queue_redraw()

var eye_color : Color = Color.WHITE:
	set(value):
		eye_color = value
		queue_redraw()
		
var eyeball_color : Color = Color.BLACK:
	set(value):
		eyeball_color = value
		queue_redraw()

var eyelid_color : Color = Color.BLACK:
	set(value):
		eyelid_color = value
		queue_redraw()

func draw_eye(node: Node2D) -> void:
	# Eye
	draw_arc(node.position, eye_radius/2, 0, 2 * PI,50,eye_color,eye_radius,true)
	# Eye lid
	draw_arc(node.position, eye_radius,0, 2*PI, 50, eyelid_color, 1, true)
	# eye ball
	var eye_ball_position : Vector2 = node.position + (eye_radius -eyeball_radius) * node.position.direction_to($Look.position)
	draw_arc(eye_ball_position, eyeball_radius/2,0, 2 * PI,50, eyeball_color, eyeball_radius, true)


@onready var old_position : Array[Vector2]= [$Look.position, $Left.position, $Right.position] 
func _process(delta: float) -> void:
	var positions : Array[Vector2] = [$Look.position, $Left.position, $Right.position] 
	if positions != old_position:
		old_position = positions
		queue_redraw()

func _draw() -> void:
	# Left eye
	draw_eye($Left)
	draw_eye($Right)

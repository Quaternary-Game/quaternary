extends Area2D

var color : Color = Control.new().get_theme_color("10", "pallete")

var spokes : int = 10
var tiers: int

var points : Array[Vector2] = []
var center: Vector2 = Vector2.ZERO
@onready var radius : float = $CollisionShape2D.shape.radius

func _ready() -> void:
	for i: int in range(spokes):
		var step : float = i * 2 * PI / spokes
		var point : Vector2 = Vector2(sin(step )*radius, cos(step)*radius)
		points.append(point)
	print_debug(points)
func _draw() -> void:
	
	
	tiers = int(radius/50)
	
	for point : Vector2 in points:
		draw_line(Vector2.ZERO, point, color, -1, true)
	
	for t: int in range(tiers):
		var step :float = (tiers-t)/float(tiers)
		for p: int in range(len(points)):
		
			var p1 : Vector2 = points[p-1] * step
			var p2 : Vector2 = points[p] * step
			var middle : Vector2 = (p1 + p2)/2
			var angle : Array[float]
			var origin :Vector2 =  2 * middle
			angle =  fix_angles(p1.angle(), p2.angle())
			draw_arc(origin, radius * step, angle[0], angle[1], 100, color, 1, true)

func fix_angles(angle1: float, angle2: float) -> Array[float]:
	angle1 = angle1 + PI
	angle2 = angle2 + PI
	return [angle1, rotate_toward(angle1, angle2, 2 * PI)]

extends VBoxContainer

var top: Line2D = AntialiasedLine2D.new()
var bottom: Line2D = AntialiasedLine2D.new()
var bonds: Array[Line2D]
var linewidth: int = 10
var resolution: int = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top.antialiased = true
	bottom.antialiased = true
	top.width = linewidth
	bottom.width = linewidth

	for i: int in range(resolution):
		top.add_point(Vector2(0,0))
		bottom.add_point(Vector2(0,0))
	self.add_child(top)
	self.add_child(bottom)
	#top.joint_mode = Line2D.LINE_JOINT_ROUND
	#top.round_precision = 30
	#print(get_viewport_rect().size - (global_position + self.size))
	for i: int in range(resolution):
		top.add_point(Vector2(0,0))
		bottom.add_point(Vector2(0,0))
	for i: int in range(100):
		bonds.append(Line2D.new())
		bonds[-1].width = 10
		self.add_child(bonds[-1])


func draw_helix(start: int, end: int, direction: int, line: Line2D, f: Callable, x:int, y:int, _sign:int) -> void:
	var step:Vector2 = (get_viewport_rect().size - global_position + self.size)/(abs(start-end))
	for index: int in range(start, end, direction):
		var point: int = index-start
		line.set_point_position(index, Vector2(point*step.x + x, (f.call(point*step.x, _sign)+y)))

var helix_func_right : Callable = func(x:int, _sign: int) -> float:
	var periods : float = 2
	var z : Vector2 = (get_viewport_rect().size - (global_position + self.size))/(2 * PI * periods)
	var X : float = float(x)
	return (_sign* -cos((X/z.x) ) + 1) * self.size.y/2
var helix_func_left : Callable = func(x:int, _sign: int) -> float:
	var periods : float = 2
	var z : Vector2 = (get_viewport_rect().size - (global_position + self.size))/(2 * PI * periods)
	var X : float = float(x)
	return (_sign* -cos((X/z.x) ) + 1) * self.size.y/2

func draw_bonds(l1:Line2D, l2:Line2D) -> void:
	var sep:int = len(l1.points)/len(bonds)
	for i: int in range(0, len(l1.points), sep):
		if i/sep < len(bonds):
			bonds[i/sep].clear_points()
			bonds[i/sep].add_point(l1.get_point_position(i))
			bonds[i/sep].add_point(l2.get_point_position(i))



func _process(_delta: float) -> void:
	#var screen_size: Vector2 = get_viewport_rect().size
	draw_helix(resolution-1, -1,-1, top, helix_func_left, -10, -linewidth, 1)
	draw_helix(resolution-1, -1,-1, bottom, helix_func_left, -10, linewidth, -1)
	draw_helix(resolution, resolution*2,1, top, helix_func_right, int(self.size.x) + 10, -linewidth, 1)
	draw_helix(resolution, resolution*2,1, bottom, helix_func_right, int(self.size.x) + 10, linewidth, -1)
	draw_bonds(top, bottom)

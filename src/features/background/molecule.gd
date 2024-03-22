extends Control
var default_font : Font = ThemeDB.fallback_font








# should be list of draw Callables
var draw_queue : Array[Callable] = []
var current_pos : Vector2 = Vector2.ZERO
var current_direction : Vector2 = Vector2(1,-1).normalized()
var bond_magnitude: float = 100
var bond_color : Color = get_theme_color("bond", "Background")
var bond_width : int = 5
var is_elem: bool = false
var text_size: Vector2 = Vector2.ZERO

enum bond_type {SINGLE, DOUBLE, TRIPLE, QUAD}

func draw_bond(element: String, bond_type: int, bond_angle: float = 90) -> Callable:
	var callable : Callable = func() -> void:
		
		var next_pos : Vector2 = (current_direction * bond_magnitude) + current_pos
		var next_direction: Vector2 = current_direction.rotated(deg_to_rad(bond_angle))

		var begin_line : Vector2 = current_pos
		var end_line : Vector2 = next_pos
		var begin_circle : bool = true
		var end_circle : bool = true
		
		if is_elem:
			begin_line = current_pos+ (current_direction * max(text_size.x, text_size.y))
			begin_circle = false
			is_elem = false
		text_size = default_font.get_string_size(element, HORIZONTAL_ALIGNMENT_CENTER)
		if element != "":
			is_elem = true
			end_circle = false
			end_line = next_pos - (current_direction * (max(text_size.x, text_size.y)))
			var text_offset : Vector2 = Vector2(text_size.x/2, -text_size.y/3)
			draw_string(default_font, next_pos-text_offset, element, HORIZONTAL_ALIGNMENT_CENTER)
		draw_line(begin_line, end_line, bond_color, bond_width * 2)
		if begin_circle:
			draw_circle(current_pos, bond_width, bond_color)
		if end_circle:
			draw_circle(next_pos, bond_width, bond_color)

		current_direction = next_direction
		current_pos = next_pos

	return callable




func _ready() -> void:
	draw_queue.append(draw_bond("", bond_type.SINGLE))
	draw_queue.append(draw_bond("", bond_type.SINGLE, -90))
	draw_queue.append(draw_bond("Mg", bond_type.SINGLE, 90))
	draw_queue.append(draw_bond("", bond_type.SINGLE, 90))
	queue_redraw()

func _draw() -> void:
	for i in draw_queue:
		i.call()

extends SelectionCircle
var entity : EntityGD
const trait_drag_item = preload("res://features/main_game/UI/traits/trait_drag_item.gd")
var loci_selected : Array[bool]
var loci_coords: Array[Vector2]
var selecting_loci: bool = false: 
	set(value):
		selecting_loci = value
		if not value:
			init_loci_selected()

var angle_step :float: 
	set(value):
		angle_step = value
		angle_offset = (PI/2) + (angle_step/2)
		
var angle_offset: float
var entered_area: Area2D

func _ready() -> void:
	angle_step = 2*PI/self.entity.ploidy
	for i in range(self.entity.ploidy):
		loci_selected.append(false)
		var x : float = final_size * cos(i * angle_step + angle_offset)
		var y : float = final_size * sin(i * angle_step + angle_offset)
		loci_coords.append(Vector2(x, y))
		
func init_loci_selected() -> void:
	for i in range(self.entity.ploidy):
		loci_selected[i] = 0

func _draw() -> void:

	for i in range(self.entity.ploidy):
		draw_arc(Vector2(0,0), circle_size + 15 * float(loci_selected[i]), i*angle_step + PI/2, (i+1) * angle_step + PI/2, 100, color)
	init_loci_selected()

func _on_area_entered(area: Area2D) -> void:
	if area is trait_drag_item:
		selecting_loci = true
		entered_area = area
		area.dropped.connect(drop_handler)

func _on_area_exited(area: Area2D) -> void:
	if entered_area == area:
		selecting_loci = false
		area.dropped.disconnect(drop_handler)
		init_loci_selected()
		queue_redraw()
	

func drop_handler(area: Area2D) -> void:
	entity.add_trait(area.TraitScene, closest_loci())

func closest_loci() -> int:
	var max :Vector2= loci_coords.reduce(func (max: Vector2, value: Vector2) -> Vector2:
			var translated_max : Vector2= global_position + max
			var translated_value: Vector2 = global_position+value
			if translated_value.distance_to(entered_area.global_position) < translated_max.distance_to(entered_area.global_position):
				return	value
			else:
				return max
			)
	return loci_coords.find(max)

func _process(delta: float) -> void:
	if selecting_loci:
		var closest : int = closest_loci()
		loci_selected[closest] = true
		queue_redraw()

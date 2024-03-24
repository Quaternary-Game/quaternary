extends Area2D


@export var initial_size : int = 0
@export var final_size : int = 100

var entity : EntityGD

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


func _on_area_entered(area: Area2D) -> void:
	print("entered")
	area.dropped.connect(drop_handler)

func _on_area_exited(area: Area2D) -> void:
	print("exited")
	area.dropped.disconnect(drop_handler)

func drop_handler(area: Area2D) -> void:
	entity.add_trait(area.TraitScene)

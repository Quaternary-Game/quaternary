class_name TraitAge extends TraitBase


@export var max_age : float = 60

var timer : Timer = Timer.new()

var juvenile: bool = true
var juvenile_percent: float = 10
var juvenile_color: Color = Control.new().get_theme_color("green", "pallete")

var adult_color: Color = Control.new().get_theme_color("yellow", "pallete")

var circle_color: Color = Control.new().get_theme_color("yellow", "pallete")

var progress_bar : TextureProgressBar = preload("res://features/main_game/UI/radialprogress/radialprogressbar.tscn").instantiate()
var age_image : Resource = preload("res://features/main_game/UI/radialprogress/age.png")

var age : float:
	get:
		juvenile = percent_age <= juvenile_percent
		progress_bar.value = timer.time_left
		return max_age - timer.time_left

var percent_age : float:
	get:
		return 100 * (max_age - timer.time_left)/max_age
		
func _ready() -> void:
	self.visible = false
	self.initialize()
	self.add_child(timer)
	timer.timeout.connect(self.entity.death)
	timer.start(max_age)
	progress_bar.max_value = max_age
	progress_bar.value = timer.time_left
	progress_bar.texture_over = age_image

	
func _draw() -> void:
	var offset: float = global_rotation + PI/2
	#draw_arc(Vector2.ZERO, 100, 0-offset, (2 * PI * timer.time_left / max_age)-offset, 100, circle_color, 5, true )
	
func _process(delta: float) -> void:
	queue_redraw()
	var current_age : float= age
	
	if juvenile:
		self.entity.scale = Vector2(0.5, 0.5)
		self.circle_color = juvenile_color
		self.entity.modulate = Color.GRAY
	else:
		var tween : Tween = create_tween()
		tween.parallel().tween_property(self.entity, "scale", Vector2(1,1), 2)
		tween.parallel().tween_property(self, "circle_color", adult_color,  2)
		tween.parallel().tween_property(self.entity, "modulate", Color.WHITE, 2)

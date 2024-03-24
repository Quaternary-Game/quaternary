extends Path2D
@export var animation_scene : PackedScene
@export var animation_scale : float = 0.2
@export var duration: float = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		var animation := animation_scene.instantiate()
		animation.scale = animation.scale * animation_scale
		$PathFollow2D.add_child(animation)
		looper()

func looper() -> void:
	var tween := create_tween()
	tween.tween_property($PathFollow2D, "progress_ratio", 1, duration)
	tween.tween_property($PathFollow2D, "progress_ratio", 0, duration)
	tween.tween_callback(looper)

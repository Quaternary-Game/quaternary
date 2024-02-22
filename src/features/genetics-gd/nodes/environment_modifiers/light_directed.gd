class_name LightDirected extends StaticBody2D

@export_range(0, 1) var intensity : float :
	get:
		var overlay := $Overlay
		if overlay is TextureRect:
			return overlay.modulate.a
		return 1
	set(value):
		var overlay := $Overlay
		if overlay is TextureRect:
			overlay.modulate.a = value
		else:
			self._deferred_intensity = value

@export var radius : float :
	get:
		var shape: Shape2D = $CollisionShape2D.shape
		if shape is CircleShape2D:
			return shape.radius
		return 200
	set(value):
		if $Overlay:
			var overlay := $Overlay
			overlay.size = Vector2(2 * value, 2 * value)
			overlay.position = Vector2(-value, -value)
		if $CollisionShape2D:
			var shape: Shape2D = $CollisionShape2D.shape
			if shape is CircleShape2D:
				shape.radius = value
		else:
			self._deferred_radius = value

var _deferred_intensity: float
var _deferred_radius: float

func _ready() -> void:
	self.intensity = self._deferred_intensity
	self.radius = self._deferred_radius

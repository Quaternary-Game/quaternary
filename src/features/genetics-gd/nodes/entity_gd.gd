extends Node2D

@export var direction := Vector2(1, 0)
@export var speed := 40

var rng := RandomNumberGenerator.new()
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	rng.randomize()

func _physics_process(delta: float) -> void:
	var should_change: bool = rng.randi_range(0, 120) == 30
	
	if should_change:
		var new_direction := Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1))
		self.direction = new_direction.normalized()

	self.position += self.direction * self.speed * delta
	self.position = self.position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body: Node) -> void:
	print("Body entered!")

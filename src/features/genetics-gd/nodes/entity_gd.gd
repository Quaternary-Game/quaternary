class_name Entity extends Node2D

@export var direction := Vector2(1, 0)
@export var speed := 40
@export var stored_food := 2
@export var required_food_for_reproduction := 3

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
	
	if self.stored_food >= self.required_food_for_reproduction:
		self.asexually_reproduce()


func _on_body_entered(body: Node) -> void:
	if body is Food:
		if body.grab_food():
			self.stored_food += 1


func _on_food_decay_timer_timeout() -> void:
	if self.stored_food > 0:
		self.stored_food -= 1
	else:
		self.queue_free()

func asexually_reproduce() -> void:
	self.stored_food -= 1
	var new_child := self.duplicate()
	new_child.stored_food = 1
	self.get_parent().add_child(new_child)

class_name Entity extends Node2D

@export var direction := Vector2(1, 0)
@export var speed := 40
@export var food_stored := 2
@export var required_food_for_reproduction := 3
@export var initial_traits := []

var _traits := {}

# Miscellaneous processes
var rng := RandomNumberGenerator.new()
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	rng.randomize()
	
	for t: TraitBase in self.initial_traits:
		self.add_trait(t)

func _physics_process(delta: float) -> void:
	for t: TraitBase in _traits:
		t.pre_physics_process(self)
	
	var should_change: bool = rng.randi_range(0, 120) == 30
	
	if should_change:
		var new_direction := Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1))
		self.direction = new_direction.normalized()

	self.position += self.direction * self.speed * delta
	self.position = self.position.clamp(Vector2.ZERO, screen_size)
	
	if self.food_stored >= self.required_food_for_reproduction:
		self.asexually_reproduce()
	
	for t: TraitBase in _traits:
		t.post_physics_process(self)


func _on_body_entered(body: Node) -> void:
	if body is Food:
		if body.grab_food():
			self.food_stored += 1

func add_trait(new_trait: TraitBase) -> void:
	self._traits[new_trait.unique_trait_name] = new_trait
	new_trait.initialize(self)
	
func remove_trait(new_trait: TraitBase) -> void:
	self._traits.erase(new_trait.unique_trait_name)

func asexually_reproduce() -> void:
	self.food_stored -= 1
	var new_child := self.duplicate()
	new_child.food_stored = 1
	self.get_parent().add_child(new_child)

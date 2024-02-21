class_name EntityGD extends RigidBody2D

@export var direction := Vector2(1, 0)
@export var speed := 40
@export var initial_traits: Array[PackedScene] = []

var traits := {}

# Miscellaneous processes
var rng := RandomNumberGenerator.new()
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	rng.randomize()
	
	for t in self.initial_traits:
		self.add_trait(t)

func _physics_process(delta: float) -> void:
	var should_change: bool = rng.randi_range(0, 120) == 30
	
	if should_change:
		var new_direction := Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1))
		self.direction = new_direction.normalized()

	self.position += self.direction * self.speed * delta
	self.position = self.position.clamp(Vector2.ZERO, screen_size)

func add_trait(new_trait: PackedScene) -> void:
	var _new_trait := new_trait.instantiate()
	assert(_new_trait is TraitBase)
	self.traits[_new_trait.unique_trait_name] = _new_trait
	add_child(_new_trait)
	
func remove_trait(unique_trait_name: String) -> bool:
	var _trait: TraitBase = self.traits.get(unique_trait_name)
	if _trait != null:
		return false
		
	self.traits.erase(unique_trait_name)
	remove_child(_trait)
	
	return true

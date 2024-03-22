class_name EntityGD extends RigidBody2D


@export var initial_traits: Array[PackedScene] = []

var paused : bool = false:
	get:
		return paused
	set(value):
		if value:
			process_mode = Node.PROCESS_MODE_DISABLED
		else:
			process_mode = Node.PROCESS_MODE_INHERIT
		paused = value
		

var traits := {}
 
func _ready() -> void:
	for t in self.initial_traits:
		self.add_trait(t)


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

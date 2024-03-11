class_name TraitBase extends Node2D

@export var unique_trait_name: String

var entity: EntityGD

func initialize() -> void:
	assert(self.unique_trait_name != null)
	assert(self.unique_trait_name.length() > 0)
	
	self.entity = get_parent()
	assert(self.entity is EntityGD)
	assert(self.entity != null)

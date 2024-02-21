class_name TraitBase extends Node2D

@export var unique_trait_name: String

var entity: Entity

func initialize() -> void:
	assert(self.unique_trait_name != null)
	assert(self.unique_trait_name.length() > 0)
	
	self.entity = get_parent()
	assert(self.entity is Entity)
	assert(self.entity != null)

class_name TraitBase extends Node2D

@export var unique_trait_name: String
@export var display_name : String = tr(unique_trait_name)
@export var icon: Texture2D

var entity: EntityGD

func initialize() -> void:
	assert(self.unique_trait_name != null)
	assert(self.unique_trait_name.length() > 0)
	
	self.entity = get_parent()
	assert(self.entity is EntityGD)
	assert(self.entity != null)

class_name TraitBase extends Node2D

@export var unique_trait_name: String

func initialize(entity: Entity) -> void:
	pass

func pre_physics_process(entity: Entity) -> void:
	pass
	
func post_physics_process(entity: Entity) -> void:
	pass

func on_body_enter(entity: Entity, other: Node) -> void:
	pass

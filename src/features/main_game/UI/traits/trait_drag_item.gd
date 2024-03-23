extends Area2D

var Trait : TraitBase
var TraitScene: PackedScene
var button: Control

signal dropped(Self: Area2D)
func emit() -> void:
	dropped.emit(self)
func _ready() -> void:
	$Sprite2D.texture = Trait.icon


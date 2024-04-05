extends Area2D

var Trait : TraitBase
var TraitScene: PackedScene
var button: Control
var droppable  : bool = false
const TraitCircle : Resource= preload("res://features/main_game/entity_manager/trait_circle.gd")

signal dropped(Self: Area2D)
func emit() -> void:
	if droppable:
		dropped.emit(self)
		SoundPlayer.play_confirm()
	else:
		SoundPlayer.play_incompatible()

func _ready() -> void:
	area_entered.connect(area_entered_handler)
	area_exited.connect(area_exited_handler)
	$Sprite2D.texture = Trait.icon
	var size : Vector2= $Sprite2D.texture.get_size()
	var s : float = ($CollisionShape2D.shape.radius*2) /max(size.x, size.y)
	$Sprite2D.scale.x = s
	$Sprite2D.scale.y = s

var entered_area : Area2D
func area_entered_handler(area: Area2D) -> void:
	if area is TraitCircle:
		droppable = true

func area_exited_handler(area: Area2D) -> void:
	if area is TraitCircle:
		droppable = false
	

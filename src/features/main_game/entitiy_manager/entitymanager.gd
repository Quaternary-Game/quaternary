extends Node2D


@export var player_entity:= preload("res://features/genetics-gd/nodes/entity_gd.tscn")
@export var enable_tool: bool = false
var circlescene := preload("res://features/main_game/entitiy_manager/trait_circle.tscn")
const UiTrait = preload("res://features/main_game/UI/traits/trait.gd")

var marker_count: int = 0

var paused: bool:
	get:
		return paused
	set(value):
		if not value and paused != value:
			for e in entities():
				e.go()
		paused = value

func markers() -> Array[Marker2D]:
	var _markers : Array[Marker2D] = []
	for i : Node in get_children():
		if i is Marker2D:
			_markers.append(i)
	return _markers
func entities() -> Array[EntityGD]:
	var _entities : Array[EntityGD] = []
	for i: Node in get_children():
		if i is EntityGD:
			_entities.append(i)
	return _entities

func _ready() -> void:
	for marker in markers():
		var instance := player_entity.instantiate()
		instance.global_position = marker.global_position
		self.add_child(instance)
	self.paused = true


func _on_ui_start() -> void:
	self.paused = false
	


var circles : Array[Node2D]= []


func _on_ui_trait_drag_end() -> void:
	for i in circles:
		i.clear_circle()


func _on_ui_trait_drag_start(t: UiTrait) -> void:
	circles = []
	for i in entities():
		circles.append(circlescene.instantiate())
		i.add_child(circles[-1])
		circles[-1].animate_circle()
		circles[-1].entity = i

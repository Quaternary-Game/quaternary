extends Node2D


@export var player_entity:= preload("res://features/genetics-gd/nodes/entity_gd.tscn")
@export var enable_tool: bool = false
var circlescene := preload("res://features/main_game/entitiy_manager/trait_circle.tscn")
var entity_selector_scene := preload("res://features/main_game/entitiy_manager/entity_selector.tscn")
const UiTrait = preload("res://features/main_game/UI/traits/trait.gd")
var entity : EntityGD

var marker_count: int = 0

var paused : bool = false:
	get:
		return paused
	set(value):
		for i in entities():
			i.paused = value
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
	
func instance_entities() -> void:
	for marker in markers():
		var instance := player_entity.instantiate()
		instance.global_position = marker.global_position
		self.add_child(instance)

var entity_selectors : Array[Node2D] = []

func instance_entity_selectors() -> void:
	for entity in entities():
		entity_selectors.append(entity_selector_scene.instantiate())
		entity_selectors[-1].entity = entity
		entity.add_child(entity_selectors[-1])
		entity_selectors[-1].show_traits.connect(show_entity_traits)
		entity_selectors[-1].end_traits.connect(end_show_entity_traits)

signal show_traits(entity: EntityGD)
signal end_show_traits

func show_entity_traits(entity: EntityGD) -> void:
	show_traits.emit(entity)
func end_show_entity_traits() -> void:
	end_show_traits.emit()

func _ready() -> void:
	instance_entities()
	instance_entity_selectors()
	self.paused = true



var circles : Array[Node2D]= []


func _on_ui_trait_drag_end() -> void:
	for i in circles:
		i.clear_circle()
		i.queue_free()


func _on_ui_trait_drag_start(t: UiTrait) -> void:
	circles = []
	for i in entities():
		circles.append(circlescene.instantiate())
		circles[-1].entity = i
		i.add_child(circles[-1])
		circles[-1].animate_circle()
		


func _on_ui_play(value: bool) -> void:
	self.paused = !value

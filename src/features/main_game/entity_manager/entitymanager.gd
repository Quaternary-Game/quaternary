class_name EntityManager extends Node2D


@export var player_entity: Resource= preload("res://features/genetics-gd/nodes/subentities/player_entity/player_entity.tscn")
@export var enable_tool: bool = false
var circlescene : Resource= preload("res://features/main_game/entity_manager/trait_circle.tscn")
var entity_selector_scene : Resource= preload("res://features/main_game/entity_manager/entity_selector.tscn")
const UiTrait : Resource = preload("res://features/main_game/UI/traits/trait.gd")


var marker_count: int = 0

var paused : bool = false:
	get:
		return paused
	set(value):
		for i: EntityGD in entities():
			i.paused = value
		paused = value

func markers() -> Array[Marker2D]:
	var _markers : Array[Marker2D] = []
	for i : Node in get_children():
		if i is Marker2D:
			_markers.append(i)
	return _markers

func enemies() -> Array[EntityEnemy]:
	var _entities : Array[EntityEnemy] = []
	for i: Node in get_children():
		if i is EntityEnemy:
			_entities.append(i)
	return _entities

func entities() -> Array[EntityGD]:
	var _entities : Array[EntityGD] = []
	for i: Node in get_children():
		if i is EntityGD:
			_entities.append(i)
	return _entities
func players() -> Array[EntityGD]:
	var _entities : Array[EntityGD] = []
	for i: Node in get_children():
		if i is EntityGD and not i is EntityEnemy:
			_entities.append(i)
	return _entities

	
func instance_entities() -> void:
	for marker : Marker2D in markers():
		var instance :EntityGD= player_entity.instantiate()
		instance.global_position = marker.global_position
		self.add_child(instance)

var entity_selectors : Array[Node2D] = []

func instance_entity_selectors() -> void:
	for entity: EntityGD in entities():
		new_entity(entity)

signal show_traits(entity: EntityGD)
signal end_show_traits

func create_entity_selector(entity: EntityGD) -> void:
	entity_selectors.append(entity_selector_scene.instantiate())
	entity_selectors[-1].entity = entity
	entity.add_child(entity_selectors[-1])
	entity_selectors[-1].show_traits.connect(show_entity_traits)
	entity_selectors[-1].end_traits.connect(end_show_entity_traits)

func new_entity(entity: EntityGD) -> void:
	entity.manager = self
	create_entity_selector(entity)

func show_entity_traits(_entity: EntityGD) -> void:
	show_traits.emit(_entity)
func end_show_entity_traits() -> void:
	end_show_traits.emit()

func _ready() -> void:
	instance_entities()
	instance_entity_selectors()
	self.paused = true



var circles : Array[Node2D]= []


func _on_ui_trait_drag_end() -> void:
	for i : SelectionCircle in circles:
		circles.erase(i)
		i.clear_circle()
		i.queue_free()


func _on_ui_trait_drag_start(_t: UiTrait) -> void:
	circles = []
	for i: EntityGD in players():
		circles.append(circlescene.instantiate())
		circles[-1].entity = i
		i.add_child(circles[-1])
		circles[-1].animate_circle()
		


func _on_ui_play(value: bool) -> void:
	self.paused = !value

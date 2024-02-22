extends Node2D

@export var num_entities := 100
@export var num_food := 100
@export var num_light := 100
@export var entity_scene: PackedScene
@export var food_scene: PackedScene
@export var light_scene: PackedScene

var rng := RandomNumberGenerator.new()
var num_children := 0

func _ready() -> void:
	# Disable VSYNC for FPS testing
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	# Ensure the Entity Scene is valid
	if not entity_scene or not entity_scene.can_instantiate():
		printerr("Invalid Entity Scene on EntityGDStressTest")
		return
	
	# Spawn Food
	for i in num_food:
		var entity := food_scene.instantiate()
		var viewport_size := get_viewport_rect().size
		entity.position = Vector2(rng.randf_range(0, viewport_size.x), rng.randf_range(0, viewport_size.y))
		self.add_child(entity)
		
	# Spawn Light
	for i in num_light:
		var entity := light_scene.instantiate()
		var viewport_size := get_viewport_rect().size
		entity.position = Vector2(rng.randf_range(0, viewport_size.x), rng.randf_range(0, viewport_size.y))
		self.add_child(entity)
	
	# Spawn Entities
	for i in num_entities:
		var entity := entity_scene.instantiate()
		var viewport_size := get_viewport_rect().size
		entity.position = Vector2(rng.randf_range(0, viewport_size.x), rng.randf_range(0, viewport_size.y))
		self.add_child(entity)

func _process(_delta: float) -> void:
	var main_title := "Entity Stress Test"
	num_children = self.get_children().size()
	var children_title := str(num_children) + " children"
	var fps_title := str(Engine.get_frames_per_second()) + " fps"
	DisplayServer.window_set_title(main_title + " | " + children_title + " | " + fps_title)

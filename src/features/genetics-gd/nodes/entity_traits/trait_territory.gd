extends TraitBase

@export var territory_scene : PackedScene
var territory : Area2D

var speed : float = 60

var next_point : Vector2

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var patrolling: bool = false
var adult : bool = true

var angle : float 

func _ready() -> void:
	initialize()
	rng.randomize()
	angle = rng.randf_range(0, 2*PI)
	territory = territory_scene.instantiate()
	territory.visible = false
	
	get_tree().root.add_child(territory)
	print_debug(territory.points)
	if self.entity.has_trait("age"):
		adult = false
		self.entity.traits["age"].reached_adulthood.connect(place_territory)
	else:
		adult = true
		place_territory()
	
	
func place_territory() -> void:
	if not is_instance_valid(territory):
		return
	var s: Vector2 = Vector2(territory.radius+100, territory.radius+100)
	# clamping hack to spawn the territories in the right location.
	territory.global_position.x = clamp(self.entity.global_position.x, s.x, get_viewport_rect().size.x-s.x)
	territory.global_position.y = clamp(self.entity.global_position.y, 100+s.y, get_viewport_rect().size.y-s.y)
	next_point = territory.center
	territory.visible = true
	patrolling = true
	adult = true

func _exit_tree() -> void:
	territory.queue_free()



func patrol(delta: float) -> void:
	if round(global_position) == round(territory.global_position + next_point):
		if next_point == territory.center:
			next_point = territory.points[rng.randi_range(0, len(territory.points)-1)]
		else:
			next_point = territory.center
	else:
		var v: Vector2 = self.entity.global_position.direction_to(territory.global_position + next_point) * speed
		self.entity.velocity = lerp(self.entity.velocity, v, delta*5)



func _physics_process(delta: float) -> void:
	if patrolling and adult and territory.is_node_ready():
		patrol(delta)
	if territory not in self.entity.area.get_overlapping_areas() and adult:
		var direction: Vector2 = self.entity.global_position.direction_to(territory.global_position)
		self.entity.velocity += direction * speed * delta
	if not adult:
		self.entity.velocity += Vector2.UP.rotated(angle) * speed * delta
		self.entity.velocity = self.entity.velocity.limit_length(2 * speed)
	self.entity.collided = self.entity.move_and_slide()
	

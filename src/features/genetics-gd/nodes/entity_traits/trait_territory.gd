extends TraitBase

@export var territory_scene : PackedScene
var territory : Area2D

var speed : float = 60

var next_point : Vector2

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var patrolling: bool = true

func _ready() -> void:
	initialize()
	rng.randomize()
	territory = territory_scene.instantiate()
	get_tree().root.add_child(territory)
	territory.global_position = self.entity.global_position
	next_point = territory.center

func _exit_tree() -> void:
	territory.queue_free()



func patrol(delta: float) -> void:
	assert(territory.is_node_ready())
	if round(global_position) == round(territory.global_position + next_point):
		if next_point == territory.center:
			next_point = territory.points[rng.randi_range(0, len(territory.points)-1)]
		else:
			next_point = territory.center
	else:
		var v: Vector2 = self.entity.global_position.direction_to(territory.global_position + next_point) * speed
		self.entity.velocity = lerp(self.entity.velocity, v, delta*5)

func _physics_process(delta: float) -> void:
	if patrolling:
		patrol(delta)
	if territory not in self.entity.area.get_overlapping_areas():
		var direction: Vector2 = self.entity.global_position.direction_to(territory.global_position)
		self.entity.velocity += direction * speed * delta
	self.entity.collided = self.entity.move_and_slide()
	

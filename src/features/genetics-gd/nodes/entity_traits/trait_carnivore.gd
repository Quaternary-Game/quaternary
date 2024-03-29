class_name TraitCarnivore extends TraitBase

func _ready() -> void:
	initialize()
	self.entity.collision.connect(eat)

var calories_per_collision: int = 50

func eat(node: Node2D) -> void:
	if node is EntityGD and "calories" in node.traits:
		node.traits["calories"].calories -= calories_per_collision
		if "calories" in self.entity.traits:
			self.entity.traits["calories"].calories += calories_per_collision

var speed : float

func enable_normal_movement() -> void:
	if self.entity.has_trait("territory"):
		self.entity.traits["territory"].process_mode = PROCESS_MODE_INHERIT
	elif self.entity.has_trait("movement"):
		self.entity.traits["movement"].process_mode = PROCESS_MODE_INHERIT

func disable_normal_movement() -> void:
	if self.entity.has_trait("territory"):
		self.entity.traits["territory"].process_mode = PROCESS_MODE_DISABLED
		speed = self.entity.traits["territory"].speed
	elif self.entity.has_trait("movement"):
		self.entity.traits["movement"].process_mode = PROCESS_MODE_DISABLED
		speed = self.entity.traits["movement"].speed

func attack() -> void:
	var seen: Array[EntityGD] = self.entity.traits["vision"].seen_entities
	if len(seen) > 0:
		disable_normal_movement()
		var closest: EntityGD = seen.reduce(func(max: EntityGD, value: EntityGD) -> EntityGD:
			if self.entity.position.distance_to(value.position) < self.entity.position.distance_to(max.position):
				return value
			else:
				return max
			)
		
		self.entity.velocity = self.entity.position.direction_to(closest.position) * speed
		self.entity.collided = self.entity.move_and_slide()
	else:
		enable_normal_movement()

func _physics_process(delta: float) -> void:
	if "vision" in self.entity.traits:
		attack()


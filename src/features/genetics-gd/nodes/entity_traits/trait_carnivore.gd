class_name TraitCarnivore extends TraitBase

var blood: Resource = preload ("res://features/genetics-gd/nodes/VisualEffects/Blood.tscn")

func _ready() -> void:
	initialize()
	self.entity.area.area_entered.connect(eat)

var calories_per_collision: int = 500

func eat(node: Area2D) -> void:
	while is_instance_valid(node) and node.get_parent() is EntityGD and node.get_parent() != self.entity and "calories" in node.get_parent().traits and node in self.entity.area.get_overlapping_areas():
		var _entity: EntityGD = node.get_parent()
		_entity.traits["calories"].calories -= calories_per_collision
		if "calories" in self.entity.traits:
			self.entity.traits["calories"].calories += calories_per_collision
		SoundPlayer.play_bite()
		bitten = true
		$BiteDelay.start()
		var b: GPUParticles2D = blood.instantiate()
		b.one_shot = true
		node.add_child(b)
		await $BiteDelay.timeout
		bitten = false
		
var bitten: bool = false:
	set(value):
		bitten = value
		if bitten:
			self.entity.velocity = Vector2.ZERO
var speed: float

func enable_normal_movement() -> void:
	if self.entity.has_trait("territory"):
		self.entity.traits["territory"].patrolling = true
	elif self.entity.has_trait("movement"):
		self.entity.traits["movement"].process_mode = PROCESS_MODE_INHERIT

func disable_normal_movement() -> void:
	if self.entity.has_trait("territory"):
		#self.entity.traits["territory"].process_mode = PROCESS_MODE_DISABLED
		self.entity.traits["territory"].patrolling = false
		speed = self.entity.traits["territory"].speed
	elif self.entity.has_trait("movement"):
		self.entity.traits["movement"].process_mode = PROCESS_MODE_DISABLED
		speed = self.entity.traits["movement"].speed

func verify_instances(arr: Array) -> bool:
	for i in range(len(arr)):
		if not is_instance_valid(arr[i]):
			return false
	return true

func attack(delta: float) -> void:
	var seen: Array[EntityGD] = self.entity.traits["vision"].seen_entities
	if len(seen) > 0:
		disable_normal_movement()
		var closest: EntityGD = seen.reduce(func(_max: EntityGD, value: EntityGD) -> EntityGD:
			if self.entity.position.distance_to(value.position) < self.entity.position.distance_to(_max.position):
				return value
			else:
				return _max
			)
		if bitten:
			pass
		else:
			self.entity.velocity += self.entity.position.direction_to(closest.position) * speed
			self.entity.velocity = self.entity.velocity.limit_length(speed * 2)
			self.entity.collided = self.entity.move_and_slide()
	else:
		enable_normal_movement()

func _physics_process(delta: float) -> void:
	if "vision" in self.entity.traits:
		attack(delta)

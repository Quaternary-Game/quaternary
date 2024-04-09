class_name TraitReproduction extends TraitBase

enum ReproductiveSex { MALE, FEMALE, NEITHER }
@export var sex: ReproductiveSex = ReproductiveSex.NEITHER

## The percentage chance that the entity will update its mating status
## The intended range is 0 to 100. However, values > 100 count as 100,
## and values < 0 count as 0.
@export_range(0, 100) var is_mating_update_percent: int = 20

func reproduce(other_entity: EntityGD) -> void:
	var child: EntityGD = self.entity.clone()

	if self.sex != ReproductiveSex.NEITHER and other_entity:
		child.genotype = self.entity.genotype.mix(other_entity.genotype)
	else:
		child.genotype = self.entity.genotype.clone()

	self.entity.manager.new_entity(child)
	self.entity.manager.add_child(child)

	var screen_center: Vector2 = get_viewport().get_visible_rect().size / 2

	child.position = self.entity.position + ((get_canvas_transform().affine_inverse() * screen_center).normalized() * 10)
	if self.entity.has_trait("calories"):
		self.entity.traits["calories"].calories /=2
	self.is_mating = false

	# Re-enable the traits that were disabled during finding a mate
	self.entity.enable_trait("territory")
	self.entity.enable_trait("movement")

var love_particles : GPUParticles2D = preload("res://features/genetics-gd/nodes/VisualEffects/love.tscn").instantiate()

var is_mating: bool = false :
	set(value):
		is_mating = value
		if not value and desired_mate:
			desired_mate = null
		if value:
			self.entity.add_child(love_particles)
		else:
			self.entity.remove_child(love_particles)

var desired_mate: EntityGD = null :
	set(value):
		var previous_mate: EntityGD = desired_mate

		# if the desired mate is the same as the previous mate, do nothing
		if value == previous_mate:
			return

		# if there is a previous mate, remove the entities from each other's won't eat list
		if previous_mate:
			if self.entity.has_trait("carnivore"):
				self.entity.traits["carnivore"].wont_eat.erase(previous_mate)
			if previous_mate.has_trait("carnivore"):
				previous_mate.traits["carnivore"].wont_eat.erase(self.entity)

		# If there is a desired mate, check that all the criteria are met
		if value and self.sex != ReproductiveSex.NEITHER:
			assert(value is EntityGD, "desired_mate must be an EntityGD")

			# The current entity must be mating
			if not self.is_mating:
				return

			if not self.is_valid_mate(value):
				return
			
			desired_mate = value

			# Add the entities to the other's won't eat list
			if self.entity.has_trait("carnivore"):
				self.entity.traits["carnivore"].wont_eat.append(desired_mate)
			if desired_mate.has_trait("carnivore"):
				desired_mate.traits["carnivore"].wont_eat.append(self.entity)

var timer_update_is_mating: Timer

func _ready() -> void:
	initialize()

	self.entity.area.area_entered.connect(self._on_area_entered)

	# Make a mating decision timer for once per second
	timer_update_is_mating = Timer.new()
	timer_update_is_mating.one_shot = false
	timer_update_is_mating.wait_time = 1
	timer_update_is_mating.timeout.connect(self._update_is_mating)
	timer_update_is_mating.autostart = true
	self.add_child(timer_update_is_mating)

func _physics_process(_delta: float) -> void:
	if self.is_mating:
		if self.sex == ReproductiveSex.NEITHER:
			self.reproduce(null)
			return
			
		if self.entity.has_trait("vision"):
			if not is_instance_valid(self.desired_mate):
				# If there is not desired mate, find one
				self.entity.enable_trait.call("territory")
				self.entity.enable_trait.call("movement")
				self.find_a_desired_mate()
			else:
				# If there is a desired mate, go to it
				self.entity.disable_trait.call("territory")
				self.entity.disable_trait.call("movement")
				self.goto_mate()

func _update_is_mating() -> void:
	if self.is_mating:
		return

	var mating_percent: int = randi() % 100

	if mating_percent < self.is_mating_update_percent:
		if self.entity.has_trait("calories") and self.entity.traits["calories"].full and self.sex == ReproductiveSex.NEITHER:
			self.is_mating = true
		elif not self.entity.has_trait("calories") or self.sex != ReproductiveSex.NEITHER:
			# I love condition hell
			if self.entity.has_trait("age") and not self.entity.traits["age"].juvenile:
				self.is_mating = true
			elif not self.entity.has_trait("age"):
				self.is_mating = true

func is_valid_mate(other_entity: EntityGD) -> bool:
	# The entities must be the same class
	if not self.entity.is_the_same_class(other_entity):
		return false

	# The entities must both have the reproduction trait
	if not other_entity.has_trait("reproduction"):
		return false

	# For the purposes of the game, reproduction is heterosexual
	var value_reproduction: TraitReproduction = other_entity.traits["reproduction"]
	if (self.sex == ReproductiveSex.MALE and value_reproduction.sex != ReproductiveSex.FEMALE) \
		or (self.sex == ReproductiveSex.FEMALE and value_reproduction.sex != ReproductiveSex.MALE):
		return false
	
	return true

func _on_area_entered(node: Area2D) -> void:
	if not is_instance_valid(node):
		return
	
	var parent: Variant = node.get_parent()
	if not (parent is EntityGD):
		return
	
	if parent == desired_mate:
		self.reproduce(parent)
		
func find_a_desired_mate() -> void:
	var seen_entities: Array[EntityGD] = self.entity.traits["vision"].seen_entities
	for seen_entity: EntityGD in seen_entities:
		if not self.is_valid_mate(seen_entity):
			continue

		self.desired_mate = seen_entity
		return

func goto_mate() -> void:
	var speed : float = 60
	self.entity.velocity += self.entity.position.direction_to(desired_mate.position) * speed
	self.entity.velocity = self.entity.velocity.limit_length(speed * 2)
	self.entity.collided = self.entity.move_and_slide()
		

extends TraitBase

@export var time_to_mate: float = 10
var timer: Timer = Timer.new() 

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func reproduction(other_entity: EntityGD) -> EntityGD:
	# do some fancy genotype mixing here
	var child_genotype : Genotype = self.entity.genotype.clone()
	
	var child : EntityGD = self.entity.duplicate()
	#child.genotype = child_genotype
	return child


var mating: bool = false:
	set(value):
		mating = value
		if value:
			self.entity.disable_trait("territory")
			self.entity.disable_trait("movement")
		else:
			self.entity.enable_trait("territory")
			self.entity.enable_trait("movement")
			if mylove:
				mylove = null

var mylove: EntityGD:
	set(value):
		mylove = value
		if "carnivore" in self.entity.traits:
			self.entity.traits["carnivore"].wont_eat.append(value)
			self.entity.disable_trait("carnivore")
		self.entity.collision.connect(is_it_my_love)
		
func is_it_my_love(node: Node2D) -> void:
	if node == mylove and mating == true:
		var child : EntityGD = reproduction(mylove)
		self.entity.manager.new_entity(child)
		self.entity.manager.add_child(child)
		mating = false
		
func find_a_mate(delta: float) -> void:
	var seen: Array[EntityGD] = self.entity.traits["vision"].seen_entities
	for i in seen:
		if i.is_the_same_class(self.entity):
			mylove = i
			print_debug(mylove)

func goto_mate(delta: float) -> void:
	var speed : float = 60
	self.entity.velocity += self.entity.position.direction_to(mylove.position) * speed
	self.entity.velocity = self.entity.velocity.limit_length(speed * 2)
	self.entity.collided = self.entity.move_and_slide()
		
func _physics_process(delta: float) -> void:
	if mating and self.entity.has_trait("vision"):
		if not mylove:
			find_a_mate(delta)
		else:
			goto_mate(delta)
	
func _ready() -> void:
	initialize()
	mating = true

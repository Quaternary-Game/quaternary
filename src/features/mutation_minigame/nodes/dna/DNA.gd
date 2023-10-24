extends DynamicMenu

@export var droppable: bool = true

var base_scene = preload("res://features/mutation_minigame/nodes/dna/Nucleotide.tscn")
var globals = get_node
signal mutation(sequence)

func add_base(base_id: Globals.NitrogenousBase = Globals.NitrogenousBase.BLANK) -> Node:
	var base = base_scene.instantiate()
	base.base = base_id
	base.mutation.connect(mutation_handler)
	self.add_child(base)
	return base

var bases = [Globals.NitrogenousBase.A,
				 Globals.NitrogenousBase.G,
				 Globals.NitrogenousBase.T,
				 Globals.NitrogenousBase.C]
				
func random_dna(length: int):
	var rng = RandomNumberGenerator.new()
	
	var start = add_base()
	for i in range(length):
		var base = add_base(bases[rng.randi_range(0, bases.size()-1)])
		var spacer = add_base()
		
func mutate_random(number_of_mutations: int = 4):
	var rng = RandomNumberGenerator.new()
	
	var possible_mutations = [
		Globals.Mutation.INSERTION,
		Globals.Mutation.DELETION,
		Globals.Mutation.SUBSTITUTION
	]
	var mutations = []
	for i in range(number_of_mutations):
		var rand_base = bases[rng.randi_range(0, bases.size()-1)]
		var rand_mutation = possible_mutations[rng.randi_range(0, possible_mutations.size()-1)]
		var type: String
		var random_child: Node
		while true:
			random_child = get_children()[rng.randi_range(0, get_children().size()-1)]
			if  random_child.get("base") == Globals.NitrogenousBase.BLANK and rand_mutation == Globals.Mutation.INSERTION and random_child.visible:
				break
			elif random_child.get("base") != Globals.NitrogenousBase.BLANK and rand_mutation != Globals.Mutation.INSERTION and random_child.visible and random_child.get("base") != null:
				break
		var mutation = {
			"Type": rand_mutation,
			"Base": rand_base,
			"node": random_child
		}
		mutations.append(mutation)
		mutation_handler(random_child, mutation)
	return mutations
		
		
		
	

		
	
func mutation_handler(node: Control, data: Dictionary):
	print(data)
	if data["Type"] == Globals.Mutation.DELETION:
		await self.hide_slide_child(node)
		await self.hide_slide_child(self.get_child(node.get_index() + 1))
		node.is_deleted = true
	elif data["Type"] == Globals.Mutation.INSERTION:
		var blank = add_base()
		var base = add_base(data["Base"])
		base.visible = false
		blank.visible = false
		self.add_child(base)
		self.add_child(blank)
		self.move_child(blank, node.get_index()+1)
		self.move_child(base, node.get_index()+1)
		await self.reveal_slide_child(base)
		await self.reveal_slide_child(blank)
	elif data["Type"] == Globals.Mutation.SUBSTITUTION:
		node.base = data["Base"]
	
	
	mutation.emit(sequence())
	
func sequence():
	var children = get_children()
	
	var sequence = []
	for c in children:
		if c.get("base") != Globals.NitrogenousBase.BLANK  and c.get("base") != null and c.is_deleted == false:
			sequence.append(c.base)
	return sequence
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

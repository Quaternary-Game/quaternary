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
	
	var _start = add_base()
	for i in range(length):
		var _base = add_base(bases[rng.randi_range(0, bases.size()-1)])
		var _spacer = add_base()
		
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
		var random_child: Node
		var check_mutation = func():
			while true:
				random_child = get_children()[rng.randi_range(0, get_children().size()-1)]
				if random_child.get("base") == Globals.NitrogenousBase.BLANK:
					if rand_mutation == Globals.Mutation.INSERTION and random_child.visible:
						return random_child
				elif random_child.get("base") != null:
					if rand_mutation != Globals.Mutation.INSERTION and random_child.visible:
						return random_child
		random_child = check_mutation.call()
		var current_mutation = {
			"Type": rand_mutation,
			"Base": rand_base,
			"node": random_child
		}
		mutations.append(current_mutation)
		mutation_handler(random_child, current_mutation)
	return mutations

	
func mutation_handler(node: Control, data: Dictionary):
	if data["Type"] == Globals.Mutation.DELETION:
		self.hide_slide_child(node)
		self.hide_slide_child(self.get_child(node.get_index() + 1))
		node.is_deleted = true
	elif data["Type"] == Globals.Mutation.INSERTION:
		var blank = add_base()
		var base = add_base(data["Base"])
		base.visible = false
		blank.visible = false
		self.move_child(blank, node.get_index()+1)
		self.move_child(base, node.get_index()+1)
		self.reveal_slide_child(base)
		self.reveal_slide_child(blank)
	elif data["Type"] == Globals.Mutation.SUBSTITUTION:
		node.base = data["Base"]
		
		print(node.base)
		print(data)
	
	mutation.emit(sequence())

func make_reciprocal_strand():
	for n in sequence_nodes():
		n.base = Globals.NitrogenousBaseDetails[n.base].bond
	
func sequence_nodes():
	var children = get_children()
	
	var sequence_array = []
	for c in children:
		if c.get("base") != Globals.NitrogenousBase.BLANK  and c.get("base") != null and c.is_deleted == false:
			sequence_array.append(c)
	return sequence_array

func reciprocal_sequence():
	var sequence_array = []
	for n in sequence_nodes():
		sequence_array.append(Globals.NitrogenousBaseDetails[n.base].bond)
	return sequence_array

func sequence():
	var sequence_array = []
	for n in sequence_nodes():
		sequence_array.append(n.base)
	return sequence_array

func _ready():
	pass
	

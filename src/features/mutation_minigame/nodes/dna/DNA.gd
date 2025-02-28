extends DynamicMenu

@export var droppable: bool = true

var base_scene: Resource = preload("res://features/mutation_minigame/nodes/dna/Nucleotide.tscn")
const Nucleotide :Resource = preload("res://features/mutation_minigame/nodes/dna/Nucleotide.gd")

signal mutation(sequence: Array)
signal mutating

func add_base(base_id: Globals.NitrogenousBase = Globals.NitrogenousBase.BLANK) -> Nucleotide:
	var base: Nucleotide = base_scene.instantiate()
	base.base = base_id
	base.mutation.connect(mutation_handler)
	self.add_child(base)
	return base

var bases :Array= [Globals.NitrogenousBase.A,
				 Globals.NitrogenousBase.G,
				 Globals.NitrogenousBase.T,
				 Globals.NitrogenousBase.C]

func random_dna(length: int) -> void:
	var rng :RandomNumberGenerator= RandomNumberGenerator.new()

	var _start: Nucleotide = add_base()
	for i: int in range(length):
		var _base :Nucleotide = add_base(bases[rng.randi_range(0, bases.size()-1)])
		var _spacer :Nucleotide= add_base()

func mutate_random(number_of_mutations: int = 4) -> Array:
	var rng :RandomNumberGenerator= RandomNumberGenerator.new()

	var possible_mutations : Array= [
		Globals.Mutation.INSERTION,
		Globals.Mutation.DELETION,
		Globals.Mutation.SUBSTITUTION
	]
	var mutations :Array[Dictionary]= []
	for i: int in range(number_of_mutations):
		var rand_base: int = bases[rng.randi_range(0, bases.size()-1)]
		var rand_mutation: int = possible_mutations[rng.randi_range(0, possible_mutations.size()-1)]
		var random_child: Node
		var check_mutation: Callable = func() -> Nucleotide:
			# This is a potential hang point/bug
			# change to use sequence_nodes function
			while true:
				random_child = get_children()[rng.randi_range(0, get_children().size()-1)]
				if random_child.get("base") == Globals.NitrogenousBase.BLANK:
					if rand_mutation == Globals.Mutation.INSERTION and random_child.visible:
						return random_child
				elif random_child.get("base") != null:
					if rand_mutation != Globals.Mutation.INSERTION and random_child.visible:
						return random_child
			# needed to make all code paths return a value
			return random_child
		random_child = check_mutation.call()
		var current_mutation : Dictionary= {
			"Type": rand_mutation,
			"Base": rand_base,
			"node": random_child
		}
		mutations.append(current_mutation)
		await mutation_handler(random_child, current_mutation, true)
	return mutations


func mutation_handler(node: Control, data: Dictionary, fast: bool = false) -> void:
	mutating.emit()
	var _hide_slide_child:Callable = self.hide_slide_child
	if fast:
		_hide_slide_child = func(_node:Control) -> void:
			_node.visible=false
	var _reveal_slide_child:Callable = self.reveal_slide_child
	if fast:
		_reveal_slide_child = func(_node:Control) -> void:
			_node.visible=true
	if data["Type"] == Globals.Mutation.DELETION:
		await _hide_slide_child.call(node)
		await _hide_slide_child.call(self.get_child(node.get_index() + 1))
		node.is_deleted = true
	elif data["Type"] == Globals.Mutation.INSERTION:
		var blank: Nucleotide= add_base()
		var base: Nucleotide = add_base(data["Base"])
		base.visible = false
		blank.visible = false
		self.move_child(blank, node.get_index()+1)
		self.move_child(base, node.get_index()+1)
		await _reveal_slide_child.call(base)
		await _reveal_slide_child.call(blank)
	elif data["Type"] == Globals.Mutation.SUBSTITUTION:
		node.base = data["Base"]

	mutation.emit(sequence())

func make_reciprocal_strand() -> void:
	for n: Nucleotide in sequence_nodes():
		n.base = Globals.NitrogenousBaseDetails[n.base].bond

func sequence_nodes() -> Array[Nucleotide]:
	var children : Array[Node] = get_children()

	var sequence_array: Array[Nucleotide] = []
	for c: Node in children:
		if c.get("base") != Globals.NitrogenousBase.BLANK  and c.get("base") != null and c.is_deleted == false:
			sequence_array.append(c)
	return sequence_array

func reciprocal_sequence() -> Array:
	var sequence_array :Array = []
	for n: Nucleotide in sequence_nodes():
		sequence_array.append(Globals.NitrogenousBaseDetails[n.base].bond)
	return sequence_array

func sequence() -> Array:
	var sequence_array : Array = []
	for n: Nucleotide in sequence_nodes():
		sequence_array.append(n.base)
	return sequence_array

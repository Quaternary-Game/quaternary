extends DynamicMenu
var base_scene = load("res://features/mutation_minigame/nodes/dna/Nucleotide.tscn")
signal mutation(sequence)
@export var droppable: bool = true
func add_base(base_str: String ="BLANK") -> Node:
	var base = base_scene.instantiate()
	base.base = base_str
	base.mutation.connect(mutation_handler)
	self.add_child(base)
	return base


func random_dna(length: int):
	var rng = RandomNumberGenerator.new()
	var bases: Array = ["A","G","T","C"]
	
	var start = add_base()
	for i in range(length):
		var base = add_base(bases[rng.randi_range(0, bases.size()-1)])
		var spacer = add_base()
		
func mutate_random(number_of_mutations: int = 4):
	var rng = RandomNumberGenerator.new()
	var bases = ["A", "T", "G", "C"]
	var possible_mutations = ["Insertion", "Deletion"]
	var mutations = []
	for i in range(number_of_mutations):
		var rand_base = bases[rng.randi_range(0, bases.size()-1)]
		var rand_mutation = possible_mutations[rng.randi_range(0, possible_mutations.size()-1)]
		var type: String
		var random_child: Node
		while true:
			random_child = get_children()[rng.randi_range(0, get_children().size()-1)]
			if  random_child.get("base") == "BLANK" and rand_mutation == "Insertion" and random_child.visible:
				break
			elif random_child.get("base") != "BLANK" and rand_mutation != "Insertion" and random_child.visible and random_child.get("base")!= null:
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
	if data["Type"] == "Deletion":
		await self.hide_slide_child(node)
		await self.hide_slide_child(self.get_child(node.get_index() + 1))
		node.is_deleted = true
	elif data["Type"] == "Insertion":
		var blank = base_scene.instantiate()
		blank.mutation.connect(mutation_handler)
		var base = base_scene.instantiate()
		base.base = data["Base"]
		base.mutation.connect(mutation_handler)
		base.visible = false
		blank.visible = false
		self.add_child(base)
		self.add_child(blank)
		self.move_child(blank, node.get_index()+1)
		self.move_child(base, node.get_index()+1)
		await self.reveal_slide_child(base)
		await self.reveal_slide_child(blank)
	
	mutation.emit(sequence())
	
func sequence():
	var children = get_children()
	
	var sequence = []
	for c in children:
		if c.get("base") != "BLANK"  and c.get("base") != null and c.is_deleted == false:
			sequence.append(c.base)
	return sequence
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

extends "res://features/dynamicmenu/DynamicMenu.gd"
var base_scene = load("res://features/mutation_minigame/nodes/dna/Nucleotide.tscn")


func add_base(base_str="BLANK") -> void:
	var base = base_scene.instantiate()
	base.base = base_str
	base.mutation.connect(mutation_handler)


func random_dna(length: int):
	var rng = RandomNumberGenerator.new()
	var bases: Array = ["A","G","T","C"]
	
	var blank_start = base_scene.instantiate()
	blank_start.mutation.connect(mutation_handler)
	self.add_child(blank_start)
	for i in range(length):
		var base = base_scene.instantiate()
		base.base = bases[rng.randi_range(0, bases.size()-1)]
		base.mutation.connect(mutation_handler)
		self.add_child(base)
		var blank = base_scene.instantiate()
		blank.mutation.connect(mutation_handler)
		self.add_child(blank)
		
		
		
	
func mutation_handler(node: Control, data: Dictionary):
	if data["Type"] == "Deletion":
		self.hide_slide_child(node)
		self.hide_slide_child(self.get_child(node.get_index() + 1))
		node.visible=false
		self.get_child(node.get_index() + 1).visible = false
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
		self.reveal_slide_child(base)
		self.reveal_slide_child(blank)

# Called when the node enters the scene tree for the first time.
func _ready():
	random_dna(10)
	

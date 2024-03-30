extends Control
var counter: int = 0

var mutation_scene : Resource= preload("res://features/mutation_minigame/nodes/mutation/mutation.tscn")
var bond_scene : Resource= preload("res://features/mutation_minigame/nodes/bond/bond.tscn")
const Mutation : Resource = preload("res://features/mutation_minigame/nodes/mutation/mutation.gd")
const DNA : Resource = preload("res://features/mutation_minigame/nodes/dna/DNA.gd")
const Bond : Resource = preload("res://features/mutation_minigame/nodes/bond/bond.gd")

@export var DNA_length: int = 10
@export var number_of_mutations: int = 10
var dna_mutated: DNA

func draw_bonds(template_string: DNA, compliment_strand: DNA) -> void:
	var template_nodes : Array= template_string.sequence_nodes()
	var compliment_nodes : Array= compliment_strand.sequence_nodes()
	for i: int in range(template_nodes.size()):
		var bond :Bond = template_nodes[i].get_node("Bond")
		if i < compliment_nodes.size():
			bond.compliment = compliment_nodes[i]
			if Globals.NitrogenousBaseDetails[bond.compliment.base].bond != template_nodes[i].base:
				bond.compliment = null
		else:
			bond.compliment = null

func make_bonds(template_strand: DNA, compliment_strand: DNA) -> void:

	var template_nodes : Array= template_strand.sequence_nodes()
	for i  : Node in template_nodes:
		var bond: Bond = bond_scene.instantiate()
		bond.template = i
		bond.name = "Bond"
		$DNABOX/DNA.mutating.connect(bond.clear_points)
		i.add_child(bond)

	draw_bonds(template_strand, compliment_strand)

func on_win() -> void:
	$EndButtons.visible = true
	var l: Label = Label.new()
	l.text = "You win!"
	$DNABOX.add_child(l)
	
func on_lose() -> void:
	$EndButtons.visible = true
	var l: Label = Label.new()
	l.text = "You lose! Correct Sequence: %s" % sequence_to_string(dna_mutated.reciprocal_sequence())
	print(dna_mutated.reciprocal_sequence())
	$DNABOX.add_child(l)

# return string equivalent of a sequence of base ID's
func sequence_to_string(sequence:Array) -> String:
	var seq_str:String = ""
	for base:int in sequence:
		match base:
			0:
				seq_str += "A "
			1:
				seq_str += "G "
			2:
				seq_str += "T "
			3:
				seq_str += "C "
	return seq_str

func check_mutation(sequence: Array) -> void:
	draw_bonds(dna_mutated, $DNABOX/DNA)
	var win :bool = (sequence == dna_mutated.reciprocal_sequence())
	if win:
		on_win()
	# true if game is lost
	elif self.number_of_mutations - $DynamicMenu.hidden_children == 0:
		on_lose()

func _ready() -> void:
	$DNABOX/DNA.random_dna(DNA_length)
	dna_mutated = $DNABOX/DNA.duplicate()
	dna_mutated.droppable = false
	$DNABOX.add_child(dna_mutated)
	dna_mutated.visible = true
	var mutations :Array[Dictionary] = await dna_mutated.mutate_random(number_of_mutations)
	dna_mutated.visible = true
	dna_mutated.make_reciprocal_strand()
	$DNABOX/DNA.mutation.connect(check_mutation)

	for i: Dictionary in mutations:
		var mutation: Mutation = mutation_scene.instantiate()
		mutation.type = i["Type"]
		mutation.base = i["Base"]
		$DynamicMenu.add_child(mutation)

	make_bonds(dna_mutated, $DNABOX/DNA)

func _on_play_again_pressed() -> void:
	SceneSwitching.goto_scene(SceneSwitching.current_scene.scene_file_path)

func _on_exit_pressed() -> void:
	SceneSwitching.goto_mainmenu()

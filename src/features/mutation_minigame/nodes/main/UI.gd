extends Control
var counter: int = 0

var mutation_scene := preload("res://features/mutation_minigame/nodes/mutation/mutation.tscn")
var bond_scene := preload("res://features/mutation_minigame/nodes/bond/bond.tscn")
const Mutation = preload("res://features/mutation_minigame/nodes/mutation/mutation.gd")
const DNA = preload("res://features/mutation_minigame/nodes/dna/DNA.gd")
const Bond = preload("res://features/mutation_minigame/nodes/bond/bond.gd")

@export var DNA_length: int = 10
@export var number_of_mutations: int = 10
var dna_mutated: DNA

func draw_bonds(template_string: DNA, compliment_strand: DNA) -> void:
	var template_nodes := template_string.sequence_nodes()
	var compliment_nodes := compliment_strand.sequence_nodes()
	for i in range(template_nodes.size()):
		var bond :Bond = template_nodes[i].get_node("Bond")
		if i < compliment_nodes.size():
			bond.compliment = compliment_nodes[i]
			if Globals.NitrogenousBaseDetails[bond.compliment.base].bond != template_nodes[i].base:
				bond.compliment = null
		else:
			bond.compliment = null

func make_bonds(template_strand: DNA, compliment_strand: DNA) -> void:

	var template_nodes := template_strand.sequence_nodes()
	for i in template_nodes:
		var bond: Bond = bond_scene.instantiate()
		bond.template = i
		bond.name = "Bond"
		$DNABOX/DNA.mutating.connect(bond.clear_points)
		i.add_child(bond)

	draw_bonds(template_strand, compliment_strand)



func check_mutation(sequence: Array) -> void:
	draw_bonds(dna_mutated, $DNABOX/DNA)
	var win :bool = (sequence == dna_mutated.reciprocal_sequence())
	if win:
		var l: Label = Label.new()
		l.text = "You win!"
		$DNABOX.add_child(l)


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

	for i in mutations:
		var mutation: Mutation = mutation_scene.instantiate()
		mutation.type = i["Type"]
		mutation.base = i["Base"]
		$DynamicMenu.add_child(mutation)

	make_bonds(dna_mutated, $DNABOX/DNA)

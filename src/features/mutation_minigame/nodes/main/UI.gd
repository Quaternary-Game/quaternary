extends Control
var counter: int = 0

var mutation_scene := preload("res://features/mutation_minigame/nodes/mutation/mutation.tscn")
const Mutation = preload("res://features/mutation_minigame/nodes/mutation/mutation.gd")
const DNA = preload("res://features/mutation_minigame/nodes/dna/DNA.gd")
var dna_mutated: DNA



func check_mutation(sequence: Array) -> void:
	var win :bool = (sequence == dna_mutated.reciprocal_sequence())
	if win:
		var l: Label = Label.new()
		l.text = "You win!"
		$DNABOX.add_child(l)


func _ready() -> void:
	$DNABOX/DNA.random_dna(6)
	dna_mutated = $DNABOX/DNA.duplicate()
	dna_mutated.droppable = false
	$DNABOX.add_child(dna_mutated)
	var mutations :Array[Dictionary] = dna_mutated.mutate_random()
	dna_mutated.make_reciprocal_strand()
	$DNABOX/DNA.mutation.connect(check_mutation)
	#print(mutations.size())
	for i in mutations:
		var mutation: Mutation = mutation_scene.instantiate()
		mutation.type = i["Type"]
		mutation.base = i["Base"]
		$DynamicMenu.add_child(mutation)

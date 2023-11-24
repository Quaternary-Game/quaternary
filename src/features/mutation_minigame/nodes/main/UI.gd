extends Control
var counter = 0

var mutation_scene = load("res://features/mutation_minigame/nodes/mutation/mutation.tscn")
var dna_mutated



func check_mutation(sequence) -> void:
	var win = (sequence == dna_mutated.reciprocal_sequence())
	if win:
		var l = Label.new()
		l.text = "You win!"
		$DNABOX.add_child(l)


func _ready():
	$DNABOX/DNA.random_dna(6)
	dna_mutated = $DNABOX/DNA.duplicate()
	dna_mutated.droppable = false
	$DNABOX.add_child(dna_mutated)
	var mutations = dna_mutated.mutate_random()
	dna_mutated.make_reciprocal_strand()
	$DNABOX/DNA.mutation.connect(check_mutation)
	#print(mutations.size())
	for i in mutations:
		var mutation = mutation_scene.instantiate()
		mutation.type = i["Type"]
		mutation.base = i["Base"]
		$DynamicMenu.add_child(mutation)

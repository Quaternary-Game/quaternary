extends Control
var counter = 0

var mutation_scene = load("res://features/mutation_minigame/nodes/mutation/mutation.tscn")
var dna_mutated
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_mutation(sequence) -> void:
	var win = (sequence == dna_mutated.sequence())
	if win:
		var l = Label.new()
		l.text = "You win!"
		$DNABOX.add_child(l)


func _on_button_button_down():
	$DNABOX/DNA.random_dna(6)
	dna_mutated = $DNABOX/DNA.duplicate()
	dna_mutated.droppable = false
	$DNABOX.add_child(dna_mutated)
	var mutations = dna_mutated.mutate_random()
	$DNABOX/DNA.mutation.connect(check_mutation)
	#print(mutations.size())
	for i in mutations:
		var mutation = mutation_scene.instantiate()
		mutation.type = i["Type"]
		mutation.base = i["Base"]
		$DynamicMenu.add_child(mutation)

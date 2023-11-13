extends GridContainer

var parent1_genotype:String
var parent2_genotype:String

var header_scene:PackedScene = preload("res://features/punnett-square/nodes/header/header.tscn")
var offspring_scene:PackedScene = preload("res://features/punnett-square/nodes/offspring/offspring.tscn")

var n_correct:int
var n_needed:int
var offspring_set:Dictionary

signal game_won

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
			
func build_square(parent1:String, parent2:String):
	parent1_genotype = parent1
	parent2_genotype = parent2
	
	var genotype_length:int = 2**(len(parent1_genotype)/2)
	self.columns = genotype_length + 1
	
	n_correct = 0
	n_needed = genotype_length**2
	
	var parent1_allele_combos:Array[String] = get_allele_combos(parent1_genotype)
	var parent2_allele_combos:Array[String] = get_allele_combos(parent2_genotype)
	
	var new_header:PanelContainer
	var new_offspring:PanelContainer
	
	var alleles:String = ""
	# add top row of headers
	for i in genotype_length:
		new_header = header_scene.instantiate()
		
		# sets container sizing to fill and expand
		new_header.size_flags_horizontal = 3
		new_header.size_flags_vertical = 3
		
		new_header.set_allele(parent1_allele_combos[i])
		add_child(new_header)
		alleles = ""
	
	# add additional rows
	for i in genotype_length:
		new_header = header_scene.instantiate()
		# sets container sizing to fill and expand
		new_header.size_flags_horizontal = 3
		new_header.size_flags_vertical = 3

		new_header.set_allele(parent2_allele_combos[i])
		add_child(new_header)
		
		# add the offspring cells
		for j in genotype_length:
			new_offspring = offspring_scene.instantiate()
			# sets container sizing to fill and expand
			new_offspring.size_flags_horizontal = 3
			new_offspring.size_flags_vertical = 3
			new_offspring.get_child(0).max_length = genotype_length
			# this line sets the correct genotype in the offspring node
			# then adds it to the offspring set
			offspring_set[new_offspring.set_correct_genotype(parent1_allele_combos[j], parent2_allele_combos[i])] = null
			add_child(new_offspring)

func get_allele_combos(genotype:String):
	# seperate the genotype into a list of traits
	var traits:Array[String] = []
	for i in range(0,len(genotype),2):
		traits.append(genotype[i]+genotype[i+1])
	
	return generate_combos(traits)
	

func generate_combos(traits:Array[String]):
	var combos:Array[String] = []
	if len(traits) == 1:
		combos.append(traits[0][0])
		combos.append(traits[0][1])
		return combos
	if len(traits) == 2:
		for i in 2:
			for j in 2:
				combos.append(traits[0][i] + traits[1][j])
		return combos 
	else:
		var posterior_combos:Array[String] = generate_combos(traits.slice(1))
		for i in 2:
			for j in len(posterior_combos):
				combos.append(traits[0][i] + posterior_combos[j])
		return combos
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if n_correct == n_needed:
		game_won.emit()

func add_correct():
	n_correct += 1
	
func sub_correct():
	n_correct -= 1

func get_offspring_set():
	return self.offspring_set

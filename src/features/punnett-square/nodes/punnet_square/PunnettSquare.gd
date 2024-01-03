extends GridContainer
## Builds punnett square
##
## Orchestrates generation of all cells in the punnett square 

## genotypes of the two parents
var parent1_genotype:String
var parent2_genotype:String

## Scene for the header cells
var header_scene:PackedScene = preload("res://features/punnett-square/nodes/header/header.tscn")
## Scene for the offspring cells
var offspring_scene:PackedScene = preload("res://features/punnett-square/nodes/offspring/offspring.tscn")

var n_correct:int ## Current number of correct offspring cells
var n_needed:int ## Number of offspring cells 
var offspring_set:Dictionary ## set of all possible offspring

signal game_won ## triggered when all cells are correct

## function for building the square in instantialing all cells
func build_square(parent1:String, parent2:String) -> void:
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

## generates allele combinations for the header cells
func get_allele_combos(genotype:String) -> Array[String]:
	# seperate the genotype into a list of traits
	var traits:Array[String] = []
	for i in range(0,len(genotype),2):
		traits.append(genotype[i]+genotype[i+1])
	
	return generate_combos(traits)
	
## helper recursive funciton for generating the allele combination
func generate_combos(traits:Array[String]) -> Array[String]:
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
		
## check if full square is correct
func _process(delta: float) -> void:
	if n_correct == n_needed:
		game_won.emit()

## add to number correct
func add_correct() -> void:
	n_correct += 1
	
## subtract from number correct
func sub_correct() -> void:
	n_correct -= 1

## getter for the set of possible offspring
func get_offspring_set() -> Dictionary:
	return self.offspring_set

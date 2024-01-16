extends GutTest
const DNA := preload("res://features/mutation_minigame/nodes/dna/DNA.gd")
var DNA_script := load("res://features/mutation_minigame/nodes/dna/DNA.gd")


func test_random_DNA() -> void:
	var dna: DNA = DNA_script.new()

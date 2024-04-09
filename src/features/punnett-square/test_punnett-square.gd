extends GutTest

var punnett := preload('res://features/punnett-square/nodes/punnet_square/punnett_square.tscn')
var offspring := preload('res://features/punnett-square/nodes/offspring/offspring.tscn')

var parameters:Array = [
	['Aa', ['A','a']],
	['Aabb', ['Ab', 'Ab', 'ab', 'ab']],
	['AaBbcc', ['ABc', 'ABc', 'Abc', 'Abc', 'aBc', 'aBc', 'abc', 'abc']]
]

func test_PunnettSquare_get_allele_combos(p:Variant=use_parameters(parameters)) -> void:
	var scene := punnett.instantiate()
	var combos:Array[String] = scene.get_allele_combos(p[0])
	assert_eq(combos, p[1])

func test_offspring_check_genotype(p:Variant=use_parameters(parameters)) -> void:
	var scene := offspring.instantiate()
	scene.get_child(0).text = p[0]
	scene.correct_genotype = p[0]
	assert_true(scene.check_genotype())
	

var params:Array = [
	['A', 'a', 'Aa'],
	['Abc', 'ABC', 'AABbCc'],
	['a', 'A', 'Aa'],
	['abcd', 'abCD', 'aabbCcDd']
]

func test_offspring_set_correct_genotype(p:Variant=use_parameters(params)) -> void:
	var scene := offspring.instantiate()
	
	assert_eq(scene.set_correct_genotype(p[0],p[1]), p[2])

func test_PunnettSquare_game_won() -> void:
	var scene := punnett.instantiate()
	watch_signals(scene)
	scene.n_needed = 16
	scene.n_correct = 16
	scene._process(0)
	
	wait_for_signal(scene.game_won, 5)
	
	assert_signal_emitted(scene, 'game_won')

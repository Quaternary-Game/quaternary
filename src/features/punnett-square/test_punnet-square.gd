extends GutTest

var punnett := preload('res://features/punnett-square/nodes/punnet_square/punnett_square.tscn')

var parameters:Array = [
	['Aa', ['A','a']],
	['Aabb', ['Ab', 'Ab', 'ab', 'ab']],
	['AaBbcc', ['ABc', 'ABc', 'Abc', 'Abc', 'aBc', 'aBc', 'abc', 'abc']]
]

func test_PunnettSquare_get_allele_combos(p:Variant=use_parameters(parameters)) -> void:
	var scene := punnett.instantiate()
	var combos:Array[String] = scene.get_allele_combos(p[0])
	assert_eq(combos, p[1])

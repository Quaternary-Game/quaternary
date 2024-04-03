class_name Traits

const EMPTY_ALLELE: PackedScene = preload("res://features/genetics-gd/nodes/entity_traits/trait_none.tscn")

const ALL: Array[PackedScene] = [
	preload("res://features/genetics-gd/nodes/entity_traits/trait_age.tscn"),
	preload("res://features/genetics-gd/nodes/entity_traits/trait_calories.tscn"),
	preload("res://features/genetics-gd/nodes/entity_traits/trait_carnivore.tscn"),
	preload("res://features/genetics-gd/nodes/entity_traits/trait_herbivore.tscn"),
	preload("res://features/genetics-gd/nodes/entity_traits/trait_movement.tscn"),
	preload("res://features/genetics-gd/nodes/entity_traits/trait_photoautotroph.tscn"),
	preload("res://features/genetics-gd/nodes/entity_traits/trait_territory.tscn"),
	preload("res://features/genetics-gd/nodes/entity_traits/trait_vision.tscn"),
	preload("res://features/genetics-gd/nodes/entity_traits/trait_reproduction.tscn"),
]

var loaded_alleles: Dictionary = {}

func _init() -> void:
	for scene: PackedScene in ALL:
		var t: TraitBase = scene.instantiate()
		if t.locus_type in loaded_alleles:
			loaded_alleles[t.locus_type].append(Allele.new(scene, t.locus_type))
		else:
			loaded_alleles[t.locus_type] = [Allele.new(EMPTY_ALLELE, t.locus_type), Allele.new(scene, t.locus_type)]

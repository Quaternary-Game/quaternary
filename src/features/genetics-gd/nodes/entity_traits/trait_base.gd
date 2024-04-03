class_name TraitBase extends Node2D

@export var unique_trait_name: String
@export var display_name : String
@export var icon: Texture2D
## The type of the locus (traits on same loci will be dominant/recessive to each other)
@export var locus_type: GeneticConstants.LocusType
## dominance priority of trait
## traits with higher dominance are dominant to traits with lower dominance
## equal dominance gives codominant or incomplete dominant phenotype
@export var dominance: int = 0

var entity: EntityGD

func initialize() -> void:
	assert(self.unique_trait_name != null)
	assert(self.unique_trait_name.length() > 0)
	
	self.entity = get_parent()
	assert(self.entity is EntityGD)
	assert(self.entity != null)

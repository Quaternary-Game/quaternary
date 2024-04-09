class_name Allele extends Resource

@export var scene: PackedScene

var _instance: TraitBase
@export var _type: GeneticConstants.LocusType

func _init(packed_scene: PackedScene = null, type: GeneticConstants.LocusType = GeneticConstants.LocusType.UNSPECIFIED, instance: TraitBase = null) -> void:
	if packed_scene:
		self.scene = packed_scene
	else:
		self.scene = Traits.EMPTY_ALLELE
	self._type = type
	self._instance = instance

func get_trait_instance() -> TraitBase:
	if not self._instance:
		self._instance = scene.instantiate()
		assert(self._instance is TraitBase)
		self._instance.locus_type = self._type
	return self._instance

class_name EntityGD extends CharacterBody2D


@export_category("Traits")
@export var genotype: Genotype

var manager: EntityManager

## should be set with move_and_slide() calls  
var collided: bool = false:
	set(value):
		collided = value
		if value:
			collision.emit(get_last_slide_collision().get_collider())
		
signal collision(node: Node2D)

var paused : bool :
	get:
		return process_mode == Node.PROCESS_MODE_DISABLED
	set(value):
		if value:
			process_mode = Node.PROCESS_MODE_DISABLED
		else:
			process_mode = Node.PROCESS_MODE_INHERIT
		

var traits : Dictionary = {}

signal traits_changed

var area: Area2D:
	get:
		return get_node("Area")

var packed_entity: PackedScene
 
func _ready() -> void:
	# Pack up the entity before we make any alterations for it
	# This will be useful if we want to instantiate it later
	# Without worrying about additional runtime considerations
	self.packed_entity = PackedScene.new()
	var result: Error = self.packed_entity.pack(self)
	assert (result == OK)

	self.genotype = self.genotype.clone()
	self.genotype.dominance_changed.connect(self._dominance_changed)

	# Setup initial traits from dominate alleles
	for locus: Locus in self.genotype.get_loci():
		for allele: Allele in locus.get_dominate_alleles():
			var instance: TraitBase = allele.get_trait_instance()
			_add_to_traits(instance)
	traits_changed.emit()
	
func clone() -> EntityGD:
	return self.packed_entity.instantiate()

func add_trait(_new_trait: PackedScene, loci_index: int = 0) -> void:
	if not _new_trait.can_instantiate():
		return

	var new_trait: TraitBase = _new_trait.instantiate()
	assert(new_trait is TraitBase)

	var locus: Locus = self.genotype.add_or_get_locus(new_trait.locus_type)
	var allele: Allele = Allele.new(_new_trait, locus._type, new_trait)
	locus.set_allele(allele, loci_index)
		
func remove_trait(locus_type: GeneticConstants.LocusType, loci_index: int = 0) -> bool:
	if not self.genotype.has_locus(locus_type):
		return false
	
	var locus: Locus = self.genotype.add_or_get_locus(locus_type)
	locus.set_allele(Allele.new(Traits.EMPTY_ALLELE, locus._type), loci_index)
	return true

func has_trait(t: String) -> bool:
	return t in traits

func has_traits(_traits : Array[String]) -> bool:
	for i : String in _traits:
		if not i in traits:
			return false
	return true

func disable_trait(t: String) -> bool:
	if t in traits:
		traits[t].process_mode = PROCESS_MODE_DISABLED
		return true
	return false
	
func enable_trait(t: String) -> bool:
	if t in traits:
		traits[t].process_mode = PROCESS_MODE_INHERIT
		return true
	return false
func is_the_same_class(entity: EntityGD) -> bool:
	return entity.get_script() == self.get_script()
		
var dead: bool = false
func death() -> void:
	# might want to put a death animation here
	#https://godotshaders.com/shader/transparent-noise-border/
	if not dead:
		dead = true
		self.get_parent().remove_child(self)
		await tree_exited
		self.queue_free()

func _dominance_changed(locus: Locus, old_dominance: Array[Allele], new_dominance: Array[Allele]) -> void:
	var old_alleles: Array[Allele] = []
	var new_alleles: Array[Allele] = []

	for allele: Allele in old_dominance:
		old_alleles.append(allele)
	
	for allele: Allele in new_dominance:
		if allele in old_alleles:
			old_alleles.erase(allele)
		else:
			new_alleles.append(allele)

	# Clean up alleles that are no longer dominant
	for allele: Allele in old_alleles:
		var instance: TraitBase = allele.get_trait_instance()
		traits.erase(instance.unique_trait_name)
		self.remove_child(instance)
		if not locus.has_allele(allele):
			instance.queue_free()
	
	# Add alleles that are now dominant
	for allele: Allele in new_alleles:
		var instance: TraitBase = allele.get_trait_instance()
		_add_to_traits(instance)
	
	traits_changed.emit()


	
func _add_to_traits(instance: TraitBase) -> void:
	if instance.unique_trait_name in traits:
		self.remove_child(traits[instance.unique_trait_name])
	traits[instance.unique_trait_name] = instance
	self.add_child(instance)
		

class_name Genotype extends Resource
## Represents a [url=https://en.wikipedia.org/wiki/Genotype]genotype[/url] in genetics.
##
## This class exists to control genotype-related logic and data. This enables safer passing of genotypes
## between different sections in the code.

## The ploidy of the genotype.
@export var ploidy: int = 2 :
	get:
		return ploidy
	set(value):
		ploidy = value

		for locus: Locus in self.get_loci():
			locus.update_ploidy(value)

## A Dictionary[GeneticConstants.LocusType, Locus] where the key is the locus type and the value is the locus itself.
@export var _loci: Dictionary

## Emitted when a locus is added to the genotype.
signal locus_added(locus: Locus)

## Emitted when the dominate alleles for any locus changes.
signal dominance_changed(locus: Locus, old_dominance: Array[Allele], new_dominance: Array[Allele])

## Creates a new genotype with the given ploidy.
func _init() -> void:
	self._loci = {}
	call_deferred("ready")

func ready() -> void:
	for locus: Locus in self.get_loci():
		locus.dominance_changed.connect(
			func (old_dominance: Array[Allele], new_dominance: Array[Allele]) -> void:
				self.dominance_changed.emit(locus, old_dominance, new_dominance)
		)

## Returns a deep copy of the genotype.
func clone() -> Genotype:
	var cloned: Genotype = Genotype.new()
	cloned.ploidy = self.ploidy
	for locus: Locus in self.get_loci():
		var new_locus: Locus = cloned.add_or_get_locus(locus._type)
		new_locus.hidden = locus.hidden
		var alleles: Array[Allele] = locus.get_alleles()
		for allele_index: int in range(alleles.size()):
			new_locus.set_allele(
				Allele.new(
					alleles[allele_index].scene,
					new_locus._type
				),
				allele_index
			)
	return cloned

## Mixes this genotype with another genotype.
## If this genotype and the other genotype have different ploidy,
## the combination cannot continue and an assertion will fail.
func mix(other: Genotype) -> Genotype:
	assert(self.ploidy == other.ploidy, "Cannot mix genotypes with different ploidy.")

	## Get all the locus types from both genotypes.
	## NOTE: GDScript doesn't have the concept of a set...
	var all_loci_types: Dictionary = {}
	for locus_type: GeneticConstants.LocusType in self.get_loci_types():
		all_loci_types[locus_type] = true
	for locus_type: GeneticConstants.LocusType in other.get_loci_types():
		all_loci_types[locus_type] = true

	var combined: Genotype = Genotype.new()
	for locus_type: GeneticConstants.LocusType in all_loci_types.keys():
		var self_locus: Locus = self.get_locus(locus_type)
		var other_locus: Locus = other.get_locus(locus_type)

		var self_alleles: Array[Allele] = self_locus.get_alleles().duplicate() if self_locus else []
		var other_alleles: Array[Allele] = other_locus.get_alleles().duplicate() if other_locus else []

		var combined_locus: Locus = combined.add_or_get_locus(locus_type)
		
		# Carry over the hidden flag
		if self_locus and other_locus:
			combined_locus.hidden = self_locus.hidden and other_locus.hidden
		else:
			combined_locus.hidden = self_locus.hidden if self_locus else other_locus.hidden
		
		for allele_index: int in range(self.ploidy):
			# This is a *very* naive implementation.
			# Effectively, every other allele_index, we switch
			# which entity is being used and then we randomly pick
			# an allele from that entity (one that has not been chosen yet).
			var chosen_alleles: Array[Allele] = self_alleles if allele_index % 2 == 0 else other_alleles
			var chosen_allele: Allele = chosen_alleles.pop_at(randi() % chosen_alleles.size()) if chosen_alleles.size() > 0 else Allele.new(Traits.EMPTY_ALLELE, combined_locus._type)

			combined_locus.set_allele(Allele.new(chosen_allele.scene, combined_locus._type), allele_index)

	return combined

## Gets the locus with the given name.
func get_locus(locus_type: GeneticConstants.LocusType) -> Locus:
	return self._loci.get(locus_type)

## Gets all the loci in the genotype.
## Returns an array of loci.
func get_loci() -> Array[Locus]:
	var loci: Array[Locus] = []
	for locus: Locus in self._loci.values():
		loci.append(locus)
	return loci

## Gets all the locus types in the genotype.
func get_loci_types() -> Array[GeneticConstants.LocusType]:
	var loci_types: Array[GeneticConstants.LocusType] = []
	for locus: GeneticConstants.LocusType in self._loci.keys():
		loci_types.append(locus)
	return loci_types

## Checks if the genotype has a locus with the given type.
func has_locus(locus_type: GeneticConstants.LocusType) -> bool:
	return self._loci.has(locus_type)

## Adds a locus to the genotype if it doesn't already exist.
## The returned locus is the locus that was added or the locus that already existed.
func add_or_get_locus(locus_type: GeneticConstants.LocusType) -> Locus:
	if self.has_locus(locus_type):
		return self.get_locus(locus_type)
	
	var locus: Locus = Locus.new(locus_type, self)
	locus.dominance_changed.connect(
		func (old_dominance: Array[Allele], new_dominance: Array[Allele]) -> void:
			self.dominance_changed.emit(locus, old_dominance, new_dominance)
	)
	self._loci[locus_type] = locus

	locus_added.emit(locus)

	return locus

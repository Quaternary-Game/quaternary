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

## Gets the locus with the given name.
func get_locus(locus_type: GeneticConstants.LocusType) -> Locus:
	return self._loci[locus_type]

## Gets all the loci in the genotype.
## Returns an array of loci.
func get_loci() -> Array[Locus]:
	var loci: Array[Locus] = []
	for locus: Locus in self._loci.values():
		loci.append(locus)
	return loci

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

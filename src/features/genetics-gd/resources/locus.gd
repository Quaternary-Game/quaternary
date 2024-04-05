class_name Locus extends Resource
## Represents a [url=https://en.wikipedia.org/wiki/Locus_(genetics)]locus[/url] (plural: Loci) in genetics.
##
## This class exists to control Locus-related logic and data. This enables safer passing of loci between
## different sections of the code.

## Whether the locus should be visible to the player or not.
@export var hidden: bool = false

## The name of the locus.
@export var _type: GeneticConstants.LocusType

## The genotype that the locus belongs to
var _genotype: Genotype

## The alleles that the locus can have.
## NOTE: That "Traits" are the "Alleles".
@export var _alleles: Array[Allele]
 
## The (co-)dominate allele(s) for the locus.
## This is a cached value that is calculated when _alleles is updated.
var _dominate_alleles: Array[Allele] = []

## Emitted when the dominate alleles for the locus changes.
## NOTE: This is not called when the alleles change, only when the dominate alleles change.
signal dominance_changed(previous: Array[Allele], current: Array[Allele])

## Initializes a new Locus object.
func _init(type: GeneticConstants.LocusType = GeneticConstants.LocusType.UNSPECIFIED, genotype: Genotype = null) -> void:
	self._type = type
	self._genotype = genotype
	self._alleles = []

	# Setup empty alleles
	if genotype:
		for i: int in range(genotype.ploidy):
			self._alleles.append(Allele.new(Traits.EMPTY_ALLELE, type))

	call_deferred("_update_dominate_alleles")

## Returns the name of the locus.
func get_type() -> GeneticConstants.LocusType:
	return self._type

## Returns the genotype that the locus belongs to.
func get_genotype() -> Genotype:
	return self._genotype

## Returns all the alleles that the locus has.
func get_alleles() -> Array[Allele]:
	return self._alleles

## Returns the dominate alleles for the locus.
func get_dominate_alleles() -> Array[Allele]:
	return self._dominate_alleles

func has_allele(allele: Allele) -> bool:
	return allele in self._alleles

func set_allele(allele: Allele, index: int) -> void:
	assert(index >= 0 && index < self._alleles.size())
	self._alleles[index] = allele
	self._update_dominate_alleles()

func update_ploidy(new_ploidy: int) -> void:
	assert(new_ploidy >= 0)
	if new_ploidy < self._alleles.size():
		self._alleles.resize(new_ploidy)
		self._update_dominate_alleles()
	elif new_ploidy > self._alleles.size():
		for i: int in range(self._alleles.size(), new_ploidy):
			self._alleles.append(Allele.new(Traits.EMPTY_ALLELE, self._type))
		self._update_dominate_alleles()

## Updates the dominate alleles for the locus.
## This argmax function uses the "dominance" value of the alleles to determine which allele is dominate.
func _update_dominate_alleles() -> void:
	var new_dominance: Array[Allele] = []

	for allele: Allele in self._alleles:
		var dominance: int = allele.get_trait_instance().dominance
		if len(new_dominance) == 0:
			new_dominance.append(allele)
		elif new_dominance[0].get_trait_instance().dominance == dominance:
			new_dominance.append(allele)
		elif new_dominance[0].get_trait_instance().dominance < dominance:
			new_dominance = [allele]

	if new_dominance != self._dominate_alleles:
		var old_dominance: Array[Allele] = self._dominate_alleles
		self._dominate_alleles = new_dominance
		dominance_changed.emit(old_dominance, new_dominance)

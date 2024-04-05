extends EditorProperty

var spinbox := SpinBox.new()

func _init():
	spinbox.min_value = 0
	spinbox.rounded = true
	spinbox.value_changed.connect(self._value_changed)
	add_child(spinbox)

func _update_property() -> void:
	spinbox.value = get_edited_object()[get_edited_property()]

func _value_changed(value: float) -> void:
	var genotype: Genotype = get_edited_object()
	var new_ploidy := int(value)
	for locus in genotype._loci.values():
		if new_ploidy < locus._alleles.size():
			locus._alleles.resize(new_ploidy)
		elif new_ploidy > locus._alleles.size():
			for i: int in range(locus._alleles.size(), new_ploidy):
				locus._alleles.append(Allele.new(Traits.EMPTY_ALLELE, locus._type))

	self.emit_changed("ploidy", new_ploidy)
	self.emit_changed("_loci", genotype._loci)

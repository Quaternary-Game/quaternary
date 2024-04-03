extends EditorProperty

var container := VBoxContainer.new()
var add_locus_button := MenuButton.new()
var loci_container := GridContainer.new()
var _allele_state: Dictionary = {}

func _init():
	add_child(container)

	add_locus_button.text = "Add Locus ➕"
	var popup := add_locus_button.get_popup()
	var locus_type_names := GeneticConstants.LocusType.keys()
	var locus_type_values := GeneticConstants.LocusType.values()
	for i: int in range(locus_type_names.size()):
		popup.add_item(locus_type_names[i], locus_type_values[i])
	popup.id_pressed.connect(self._add_locus)
	container.add_child(add_locus_button)

	container.add_child(loci_container)

func _update_property() -> void:
	_allele_state.clear()

	var genotype := self._get_genotype()
	var loci := genotype._loci

	for child: Control in loci_container.get_children():
		loci_container.remove_child(child)
		child.queue_free()

	loci_container.columns = genotype.ploidy + 3

	var allele_state_counter := 0
	var traits := Traits.new()
	for locus in loci.values():
		var delete_button := Button.new()
		delete_button.text = "❌"
		delete_button.pressed.connect(func (): _delete_locus(locus._type))
		loci_container.add_child(delete_button)

		var hide_button := Button.new()
		if locus.hidden:
			hide_button.text = "🔒"
		else:
			hide_button.text = "🔓"
		hide_button.pressed.connect(func (): _toggle_hidden(locus))
		loci_container.add_child(hide_button)

		var row_label := Label.new()
		row_label.text = GeneticConstants.LocusType.find_key(locus._type) + ":"
		loci_container.add_child(row_label)

		for allele_index: int in range(locus._alleles.size()):
			var current_allele: Allele = locus._alleles[allele_index]
			var allele_menu := MenuButton.new()
			var popup := allele_menu.get_popup()
			popup.id_pressed.connect(self._update_allele)
			if locus._type in traits.loaded_alleles:
				for new_allele: Allele in traits.loaded_alleles[locus._type]:
					_allele_state[allele_state_counter] = func ():
						locus._alleles[allele_index] = new_allele
						self.emit_changed("_loci", loci)
					popup.add_item(new_allele.get_trait_instance().display_name, allele_state_counter)
					allele_state_counter += 1
			allele_menu.text = Allele.new(current_allele.scene, current_allele._type).get_trait_instance().display_name
			loci_container.add_child(allele_menu)

func _get_genotype() -> Genotype:
	return get_edited_object()

func _add_locus(locus_type: GeneticConstants.LocusType) -> void:
	var genotype := self._get_genotype()
	var loci := genotype._loci
	if locus_type in loci:
		return
	
	loci[locus_type] = Locus.new(locus_type, genotype)
	self.emit_changed("_loci", loci)

func _update_allele(state_id: int) -> void:
	_allele_state[state_id].call()

func _toggle_hidden(locus: Locus) -> void:
	locus.hidden = not locus.hidden
	self.emit_changed("_loci", self._get_genotype()._loci)

func _delete_locus(locus_type: GeneticConstants.LocusType) -> void:
	var genotype := self._get_genotype()
	var loci := genotype._loci
	if locus_type not in loci:
		return

	loci.erase(locus_type)
	self.emit_changed("_loci", loci)
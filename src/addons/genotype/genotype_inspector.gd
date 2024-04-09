@tool
extends EditorInspectorPlugin

const GenotypeLociEditor = preload("res://addons/genotype/genotype_loci_editor.gd")
const GenotypePloidyEditor = preload("res://addons/genotype/genotype_ploidy_editor.gd")

func _can_handle(object: Object) -> bool:
	return object is Genotype

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if name == "_loci" and type == TYPE_DICTIONARY:
		add_property_editor(name, GenotypeLociEditor.new())
		return true
	if name == "ploidy" and type == TYPE_INT:
		add_property_editor(name, GenotypePloidyEditor.new())
		return true
	return false

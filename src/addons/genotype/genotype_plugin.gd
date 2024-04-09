@tool
extends EditorPlugin

var genotype_inspector: EditorInspectorPlugin = preload("genotype_inspector.gd").new()
var genotype_loader: GenotypeLoader = preload("loaders/genotype_loader.gd").new()

func _enter_tree() -> void:
	ResourceLoader.add_resource_format_loader(genotype_loader)
	add_inspector_plugin(genotype_inspector)

func _exit_tree() -> void:
	ResourceLoader.remove_resource_format_loader(genotype_loader)
	remove_inspector_plugin(genotype_inspector)

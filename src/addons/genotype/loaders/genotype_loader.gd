class_name GenotypeLoader extends ResourceFormatLoader

func _get_resource_script_class(path: String) -> String:
    print(path)
    return "Genotype"

func _get_resource_type(path: String) -> String:
    print(path)
    return "Resource"

func _handles_type(type: StringName) -> bool:
    print(type)
    return false

func _recognize_path(path: String, type: StringName) -> bool:
    print(path, " ", type)
    return true
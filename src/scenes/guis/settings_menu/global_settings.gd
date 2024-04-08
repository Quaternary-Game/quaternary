extends Node

var cb_setting:int = 0
var shader_scene:PackedScene = preload("res://scenes/guis/settings_menu/colorblind_filter.tscn")
var filter:ColorRect

func _ready() -> void:
	filter = shader_scene.instantiate()
	add_child(filter)
	filter.z_index = RenderingServer.CANVAS_ITEM_Z_MAX

# to implement global setting saving
func set_colorblind_mode(type:int) -> void:
	cb_setting = type
	filter.material.set("shader_parameter/mode", type)

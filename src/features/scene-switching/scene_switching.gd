extends Node
## Global singleton script to orchastrate scene switching

## currently active scene
var current_scene:Node = null
const loading_path:String = "res://features/loading-screen/loading_screen.tscn"

## Sets current scene
func _ready() -> void:
	var root:Window = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

## Changes scene to main menu
func goto_mainmenu() -> void:
	goto_scene("res://scenes/guis/MainMenu.tscn")

## Changes scene to scene at given path
func goto_scene(path:String) -> void:
	call_deferred("_deferred_go_to_scene", path)

## completes a deffered scene switching
func _deferred_go_to_scene(path:String) -> void:
	current_scene.free()
	var next_scene:Resource = ResourceLoader.load(loading_path)
	current_scene = next_scene.instantiate()
	get_tree().root.add_child(current_scene)
	current_scene.load_scene(path)

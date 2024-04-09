extends Node
## Global singleton script to orchastrate scene switching

## currently active scene
var current_scene:Node = null
var loading_screen:Control = preload("res://features/loading-screen/loading_screen.tscn").instantiate()

## Sets current scene
func _ready() -> void:
	var root:Window = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	loading_screen.loaded.connect(loaded)
	#current_scene = root.get_child(1)

## Changes scene to main menu
func goto_mainmenu() -> void:
	goto_scene("res://scenes/guis/MainMenu.tscn")

## Changes scene to scene at given path
func goto_scene(path:String) -> void:
	#print(get_tree().change_scene_to_file(self.loading_path))
	#get_tree().current_scene.load_scene(path)
	
	call_deferred("_deferred_go_to_scene", path)

## completes a deffered scene switching
func _deferred_go_to_scene(path:String) -> void:
	current_scene.free()
	get_tree().root.add_child(loading_screen)
	var load_scene:Resource = loading_screen.load_scene(path)

func loaded(scene: Resource) -> void:
	get_tree().root.remove_child(loading_screen)
	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)

func restart_scene() -> void:
	goto_scene(current_scene.scene_file_path)

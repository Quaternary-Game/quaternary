extends Control

var progress:Array[float]
var load_status:int

func load_scene(scene_path:String) -> void:
	# start loading new scene
	ResourceLoader.load_threaded_request(scene_path)
	
	# Check load status continuously and update progress bar
	load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	while load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		$ProgressBar.value = progress[0] * 100
		load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_path))
	else:
		print("error loading")

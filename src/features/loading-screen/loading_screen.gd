extends Control

var progress:Array[float]
var load_status:int
var _scene_path: String
var loading: bool = false
signal loaded(loaded_scene: Resource)

func _ready() -> void:
	$ProgressBar.done.connect(_loaded)

func load_scene(scene_path:String) -> void:
	# start loading new scene
	ResourceLoader.load_threaded_request(scene_path)
	# Check load status continuously and update progress bar
	loading = true
	self._scene_path = scene_path
	load_status = ResourceLoader.load_threaded_get_status(_scene_path, progress)

func _process(delta: float) -> void:
	if load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS and loading:
		load_status = ResourceLoader.load_threaded_get_status(_scene_path, progress)
		$ProgressBar.value = progress[0] * 100
	elif load_status == ResourceLoader.THREAD_LOAD_LOADED and loading:
		$ProgressBar.value = 101
	elif loading:
		push_error("Could not load scene: %s" % load_status)
	
func _loaded() -> void:
	loading = false
	loaded.emit(ResourceLoader.load_threaded_get(_scene_path))

	

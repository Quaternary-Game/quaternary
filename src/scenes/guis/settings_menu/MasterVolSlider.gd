extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))

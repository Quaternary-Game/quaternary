extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_choices(offspring_set:Dictionary):
	for offspring in offspring_set.keys():
		$PanelContainer/OptionButton.add_item(offspring)
	
	$PanelContainer/OptionButton.selected = -1

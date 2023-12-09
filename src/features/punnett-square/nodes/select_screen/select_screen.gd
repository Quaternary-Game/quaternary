extends Control
## Sets offspring choices for the screen after winning

func set_choices(offspring_set:Dictionary):
	for offspring in offspring_set.keys():
		$PanelContainer/OptionButton.add_item(offspring)
	
	$PanelContainer/OptionButton.selected = -1

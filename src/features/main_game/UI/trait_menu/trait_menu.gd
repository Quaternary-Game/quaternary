extends VBoxContainer
const UiTrait : Resource = preload("res://features/main_game/UI/traits/trait.gd")
var UiTraitScene : Resource = preload("res://features/main_game/UI/traits/trait.tscn")
var disabled_color :Color = get_theme_color("11", "pallete")

var preview_value: int = 0:
	set(value):
		if value <= 0:
			preview_value = 0
			$Points.text = str(points)
		else:
			$Points.text = "%s - %s" % [str(points), str(value)]
			preview_value = 0

@export var points : int = 10:
	set(value):
		points = value
		for i: UiTrait in traits():
			if i.points > points:
				i.modulate = disabled_color
				i.process_mode = Node.PROCESS_MODE_DISABLED

@export var traitlist: Array[PackedScene] = []
@export var traitpoints: Array[int] = []

func _ready() ->void:
	$Points.text = str(points)
	for i: Node in $TraitGrid.get_children():
		$TraitGrid.remove_child(i)
	for t: int in range(len(traitlist)):
		var _trait :UiTrait = UiTraitScene.instantiate()
		_trait.entitytrait = traitlist[t]
		_trait.points = traitpoints[t]
		_trait.begin_drag.connect(trait_begin_drag_handler)
		_trait.end_drag.connect(trait_end_drag_handler)
		$TraitGrid.add_child(_trait)
		

func traits() -> Array[UiTrait]:
	var children : Array[Node] = $TraitGrid.get_children()
	var _traits : Array[UiTrait] = []
	for c:Node in children:
		if c is UiTrait:
			_traits.append(c)
	return _traits

func trait_begin_drag_handler(data: Variant) -> void:
	preview_value = data.points
func trait_end_drag_handler(data: Variant, success: bool) -> void:
	if success:
		points = points - data.points
	preview_value = 0

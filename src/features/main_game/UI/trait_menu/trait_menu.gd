extends DynamicMenu
const UiTrait = preload("res://features/main_game/UI/traits/trait.gd")

func traits() -> Array[UiTrait]:
	var children := get_children()
	var _traits : Array[UiTrait] = []
	for c:Node in children:
		if c is UiTrait:
			_traits.append(c)
	return _traits

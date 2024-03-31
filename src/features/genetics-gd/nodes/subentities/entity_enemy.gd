class_name EntityEnemy extends EntityGD

func _ready() -> void:
	super._ready()
	traits_changed.connect(make_traits_invisible)
	

func make_traits_invisible() -> void:
	for i: TraitBase in traits.values():
		i.visible = true
		

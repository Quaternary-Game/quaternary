extends Button
@export var entitytrait: PackedScene
var trait_instance : Node2D
var preview_node_scene: PackedScene = preload("res://features/main_game/UI/traits/trait_drag_item.tscn")
var preview_node : Node2D

var points : int:
	set(value):
		self.text = str(value)
		points = value

signal begin_drag(data: Variant)
signal end_drag(data: Variant, success: bool)


func _ready() -> void:
	trait_instance = entitytrait.instantiate()
	icon = trait_instance.icon
	tooltip_text = "%s\nDominance Level: %s\nLoci: %s" % [trait_instance.display_name, trait_instance.dominance, trait_instance.loci]
	self.button_down.connect(button_down_handler)
var _dragging: bool = false

func button_down_handler() -> void:
	_dragging = true
	preview_node = preview_node_scene.instantiate()
	preview_node.Trait = trait_instance
	preview_node.TraitScene = entitytrait
	preview_node.button = self
	get_tree().root.add_child(preview_node)
	begin_drag.emit(self)


func _process(_delta: float) -> void:
	if _dragging:
		preview_node.global_position = get_global_mouse_position()
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_dragging = false
			preview_node.emit()
			end_drag.emit(self, preview_node.droppable)
			preview_node.queue_free()
			
		

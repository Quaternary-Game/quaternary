extends DragButton
@export var entitytrait: PackedScene
var trait_instance : Node2D
var preview_node_scene: PackedScene = preload("res://features/main_game/UI/traits/trait_drag_item.tscn")
var preview_node : Node2D
var doit: bool = false
func _get_drag_data(at_position: Vector2) -> Variant:
	var data :Variant = super._get_drag_data(at_position)
	# clear drag preview
	set_drag_preview(Control.new())
	# set node preview node
	# couldn't add child in ready function for some reason
	preview_node = preview_node_scene.instantiate()
	preview_node.Trait = trait_instance
	preview_node.TraitScene = entitytrait
	preview_node.button = self
	get_tree().root.add_child(preview_node)
	return data
	

func _ready() -> void:
	trait_instance = entitytrait.instantiate()
	icon = trait_instance.icon
	text = trait_instance.display_name

	end_drag.connect(end_drag_handler)
	dragging_data = self

func _process(delta: float) -> void:
	if _dragging :
		
		preview_node.global_position = get_global_mouse_position()
		
func end_drag_handler(success: bool)-> void:
	preview_node.emit()
	print("emitted")
	preview_node.queue_free()	

		

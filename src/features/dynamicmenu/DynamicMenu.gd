class_name DynamicMenu extends Control

func reveal_slide_child(node: Control) -> void:
	var spacer = Control.new()
	# set this if you want a min size for the spacer
	#spacer.custom_minimum_size = Vector2(1,1)
	self.add_child(spacer)
	self.move_child(spacer, node.get_index())
	var tween = create_tween()
	
	var min_size: Vector2 = node.get_minimum_size()
	if node.custom_minimum_size != Vector2(0,0):
		min_size = node.custom_minimum_size
	tween.tween_property(spacer, "custom_minimum_size",min_size, 0.2)
	var spacer_finished = func(): 
		self.remove_child(spacer)
		node.visible = true
	tween.connect("finished", spacer_finished)


func hide_slide_child(node: Control, new_parent: Node = null) -> void:
	var spacer = Control.new()
	spacer.custom_minimum_size = node.size
	self.add_child(spacer)
	self.move_child(spacer, node.get_index())
	node.visible = false
	var tween = create_tween()
	tween.tween_property(spacer, "custom_minimum_size", Vector2(0,0), 0.2)
	var spacer_finished = func(): 
		self.remove_child(spacer)
	tween.connect("finished", spacer_finished)
	
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

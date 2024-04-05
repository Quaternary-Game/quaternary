extends TutorialBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	print(self.pressed)
	var target: Object = self.get_parent().get_node("TestButton")
	var target2: Object = self.get_parent().get_node("HUD/StartButton")
	#print(target.pressed)
	new_slide("First TEST this is the first test this is the first test this", self.pressed, target.pressed, [target, target2])



extends TutorialBase
var click: Object
var target2: Object
var active: bool
# Called when the node enters the scene tree for the first time.

func _on_pressed() -> void:
	#get_tree().call_group("mobs", "queue_free")
	active = true
	click = self.get_parent().get_node("MouseClickButton")
	target2 = self.get_parent().get_node("HUD/StartButton")
	self.get_parent().get_node("MouseClickButton").visible = true
	play_first("Welcome to Construct The Codons! THe Tutorial! Click anyhwere to continue.", click.pressed, [click], [], Vector2(-850, -500))
	new_slide("THis is the second slide of the nice little tutorial", click.pressed,click.pressed, [click])

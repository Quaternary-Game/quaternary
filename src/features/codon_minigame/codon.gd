extends RigidBody2D
var codons : Array= ["G", "U", "A", "C"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var codon : String = codons[(randi() % codons.size())]
	$AnimatedSprite2D/Letter.text = codon
	$AnimatedSprite2D.play(codon)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

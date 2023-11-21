extends RigidBody2D
var codons = ["G", "U", "A", "C"]
# Called when the node enters the scene tree for the first time.
func _ready():
	var codon = codons[(randi() % codons.size())]
	$AnimatedSprite2D/Letter.text = codon
	$AnimatedSprite2D.play(codon)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_body_entered(body):
	pass # Replace with function body.

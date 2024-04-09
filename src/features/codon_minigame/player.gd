extends Area2D

@export var speed: int = 800

# get custom codon type for body collisions
const Codon : Resource = preload("res://features/codon_minigame/codon.gd")

var screen_size: Vector2 
signal hit

var velocity :Vector2= Vector2()
var started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2(0, 0)
	var mouse_position: Vector2  = get_global_mouse_position()
	
	var direction: Vector2 = (mouse_position - position)
	if direction.length() > 10:
		velocity = (direction * speed).normalized()
		velocity = velocity * speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		if (started):
			if (direction.length() > 10):
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_body_entered(body: Node2D) -> void:
	if body is Codon:
		hit.emit(body)
		$Codons.text += body.get_node("AnimatedSprite2D/Letter").text
	
func start(pos: Vector2) -> void:
	$Codons.text = ""
	position = pos
	show()
	$CollisionShape2D.disabled = false
	started = true

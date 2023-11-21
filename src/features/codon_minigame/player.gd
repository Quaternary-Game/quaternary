extends Area2D
@export var speed = 800
var screen_size
signal hit

var mouse_position = null
var velocity = Vector2()
var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2(0, 0)
	mouse_position = get_global_mouse_position()
	
	var direction = (mouse_position - position)
	if direction.length() > 4:
		velocity = (direction * speed).normalized()
		velocity = velocity * speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		if (started):
			if (direction.length() > 10):
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_body_entered(body):
	hit.emit(body)
	$Codons.text += body.get_node("AnimatedSprite2D/Letter").text
	
func start(pos):
	$Codons.text = ""
	position = pos
	show()
	$CollisionShape2D.disabled = false
	started = true

class_name EntitySpider extends EntityEnemy

var starting_velocity : Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	rotation = rotate_toward(rotation, velocity.angle() + PI/2, delta*2)
	
		
	
func _ready() -> void:
	super._ready()
	print(traits)

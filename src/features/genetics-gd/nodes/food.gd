class_name Food extends StaticBody2D

@export var stages := [
	preload("res://features/genetics-gd/assets/food/food1.png"),
	preload("res://features/genetics-gd/assets/food/food2.png"),
	preload("res://features/genetics-gd/assets/food/food3.png"),
]

@export var food_available: int

func _ready() -> void:
	self.food_available = stages.size()
	
func _process(delta: float) -> void:
	if self.food_available > 0:
		$Sprite2D.texture = stages[self.get_food_available()]
	else:
		self.queue_free()

func get_food_available() -> int:
	return clamp(self.food_available - 1, 0, self.stages.size() - 1)

func grab_food() -> bool:
	if self.food_available > 0:
		self.food_available -= 1
		return true
	return false

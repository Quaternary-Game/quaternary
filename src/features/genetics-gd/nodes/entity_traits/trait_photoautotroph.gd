class_name TraitPhotoautotroph extends TraitBase
## Defines photoautotroph-like characteristics (the entity photosynthesizes).
## This trait has no effect it TraitCalories is not also present on the entity. 
##
## Depends on:
## - TraitCalories
## 
## Entity Properties:
## - None
##
## Customizations:
## - calorie_increment_amount: Integer value to increase the calorie amount by.
##   - This number is multiplied by the intensity of the light body
## - increment_rate_sec: Float number of seconds that defines the rate at which calories increase
@export var calorie_increment_amount : int = 300

## Float number of seconds that defines the rate at which calories decay


@onready var increment_timer : Timer = $IncrementTimer

@export var increment_rate_sec : float:
	get:
		return increment_timer.wait_time
	set(value):
		if increment_timer:
			increment_timer.wait_time = value
		else:
			self._deferred_increment_rate_sec = value

var _deferred_increment_rate_sec: float

var _light_bodies: Dictionary = {}

func _ready() -> void:
	self.initialize()
	self.increment_rate_sec = self._deferred_increment_rate_sec
	self.entity.area.area_entered.connect(self._on_body_entered)
	self.entity.area.area_exited.connect(self._on_body_exited)
	for i : Area2D in self.entity.area.get_overlapping_areas():
		_on_body_entered(i)

func _on_body_entered(area: Area2D) -> void:
	if not (area is LightDirected):
		return
	
	self._light_bodies[area.get_instance_id()] = area
	increment_timer.paused = false
	if increment_timer.is_stopped():
		increment_timer.autostart = true

func _on_body_exited(area: Area2D) -> void:
	if not (area is LightDirected):
		return
	
	self._light_bodies.erase(area.get_instance_id())
	
	if self._light_bodies.is_empty():
		$IncrementTimer.paused = true


func _on_increment_timer_timeout() -> void:
	var trait_calories: TraitCalories = self.entity.traits.get("calories")
	if trait_calories == null:
		return
	
	for body: LightDirected in self._light_bodies.values():
		trait_calories.calories += int(self.calorie_increment_amount * body.intensity)

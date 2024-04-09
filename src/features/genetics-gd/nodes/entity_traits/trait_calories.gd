class_name TraitCalories extends TraitBase
## Defines basic hunger characteristics
## 
## Entity Properties:
## - calories: An integer count that represents the number of calories the entity has
##
## Customizations:
## - decay_enabled: Boolean value to indicate if decay should occur
## - decay_rate_sec: Float number of seconds that defines the rate at which calories decay
## - calorie_decay_amount: Integer number that defines the quantity of calories to decay

var progress_bar : TextureProgressBar = preload("res://features/main_game/UI/radialprogress/radialprogressbar.tscn").instantiate()
var hungry: Resource = preload("res://features/main_game/UI/radialprogress/calories.png")
var gain_calories_particles : GPUParticles2D= preload("res://features/genetics-gd/nodes/VisualEffects/calories_gained.tscn").instantiate()
# ################### #
#  Entity Properties  #
# ################### #

## An integer count that represents the number of calories the entity has
@export var calories : int = 4000:
	set(value):
		value = clamp(value, -1,max_calories )
		if calories < value:
			if gain_calories_particles in self.get_children():
				self.remove_child(gain_calories_particles)
			gain_calories_particles.emitting = true
			gain_calories_particles.one_shot = true
			self.add_child(gain_calories_particles)
		
		calories = value
		progress_bar.value = value
		percent = (calories/float(max_calories)) * 100
		if value <= 0:
			self.entity.death()
			
var max_calories: int:
	set(v):
		max_calories = v
		progress_bar.max_value = v


var percent : float:
	get:
		return 100 * calories/float(max_calories)



var full : bool:
	get:
		return percent >= 90
var starving : bool:
	get:
		return percent <= 10

# ##################### #
#  Trait Customization  #
# ##################### #
@onready var decaytimer : Timer = $DecayTimer
## Boolean value to indicate if decay should occur

@export var decay_enabled : bool:
	get:
		return not decaytimer.paused
	set(value):
		var new_value : bool = not value
		
		if decaytimer:
			decaytimer.paused = new_value
		else:
			self._deferred_enabled = new_value

## Float number of seconds that defines the rate at which calories decay

@export var decay_rate_sec : float:
	get:
		return decaytimer.wait_time
	set(value):
		if decaytimer:
			decaytimer.wait_time = value
		else:
			self._deferred_decay_rate_sec = value

## Integer number that defines the quantity of calories to decay
@export var calorie_decay_amount : int = 25

var _deferred_enabled: bool
var _deferred_decay_rate_sec: float



# ###################### #
#  Trait Behavior Logic  #
# ###################### #

func _ready() -> void:
	self.initialize()
	max_calories = calories
	calories = calories
	progress_bar.texture_over = hungry

func _process(_delta: float) -> void:
	$DebugLabel.text = str(self.calories)

func _on_decay_timer_timeout() -> void:
	self.calories -= self.calorie_decay_amount

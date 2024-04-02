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

# ################### #
#  Entity Properties  #
# ################### #

## An integer count that represents the number of calories the entity has
@export var calories : int = 2000:
	set(value):
		if value <= max_calories:
			calories = value
			progress_bar.value = value
		else:
			calories = max_calories
			progress_bar.value = value
		percent = (calories/float(max_calories)) * 100
		if calories <= 0:
			self.entity.death()
			
var max_calories: int:
	set(v):
		max_calories = v
		progress_bar.max_value = v
		print("I set the progress maxvalue to %s" % progress_bar.max_value)


var percent : float:
	set(value):
		percent = value
		full = percent >= 90
		starving = percent <= 10

var full : bool
var starving : bool

# ##################### #
#  Trait Customization  #
# ##################### #

## Boolean value to indicate if decay should occur
@export var decay_enabled : bool

var _decay_enabled : bool:
	get:
		return not $DecayTimer.paused
	set(value):
		var new_value : bool = not value
		
		if $DecayTimer:
			$DecayTimer.paused = new_value
		else:
			self._deferred_enabled = new_value

## Float number of seconds that defines the rate at which calories decay
@export var decay_rate_sec : float

var _decay_rate_sec : float:
	get:
		return $DecayTimer.wait_time
	set(value):
		if $DecayTimer:
			$DecayTimer.wait_time = value
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
	self._decay_enabled = self.decay_enabled
	self._decay_rate_sec = self.decay_rate_sec
	max_calories = calories
	calories = calories

func _process(_delta: float) -> void:
	$DebugLabel.text = str(self.calories)

func _on_decay_timer_timeout() -> void:
	self.calories -= self.calorie_decay_amount

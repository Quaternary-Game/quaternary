extends Node2D

const TARGET_OFFSET_AMOUNT = 50

var _target: Node
var _direction: GameTutorialSlideBuilder.Direction

func _process(_delta: float) -> void:
	# Get target position
	var target_position: Vector2
	if self._target is Control:
		var control: Control = self._target
		var size_offset: Vector2 = control.size
		target_position = control.global_position
		if self._direction == GameTutorialSlideBuilder.Direction.BELOW:
			target_position += Vector2(size_offset.x / 2, size_offset.y)
		elif self._direction == GameTutorialSlideBuilder.Direction.ABOVE:
			target_position += Vector2(size_offset.x / 2, 0)
		elif self._direction == GameTutorialSlideBuilder.Direction.LEFT_OF:
			target_position += Vector2(0, size_offset.y / 2)
		elif self._direction == GameTutorialSlideBuilder.Direction.RIGHT_OF:
			target_position += Vector2(size_offset.x, size_offset.y / 2)
		elif self._direction == GameTutorialSlideBuilder.Direction.BELOW_LEFT:
			target_position += Vector2(0, size_offset.y)
		elif self._direction == GameTutorialSlideBuilder.Direction.BELOW_RIGHT:
			target_position += Vector2(size_offset.x, size_offset.y)
		elif self._direction == GameTutorialSlideBuilder.Direction.ABOVE_RIGHT:
			target_position += Vector2(size_offset.x, 0)
	else:
		target_position = self._target.global_position
	
	# Apply offset
	if self._direction == GameTutorialSlideBuilder.Direction.BELOW:
		self.global_position = target_position + Vector2(0, TARGET_OFFSET_AMOUNT)
	elif self._direction == GameTutorialSlideBuilder.Direction.ABOVE:
		self.global_position = target_position + Vector2(0, -TARGET_OFFSET_AMOUNT)
	elif self._direction == GameTutorialSlideBuilder.Direction.LEFT_OF:
		self.global_position = target_position + Vector2(-TARGET_OFFSET_AMOUNT, 0)
	elif self._direction == GameTutorialSlideBuilder.Direction.RIGHT_OF:
		self.global_position = target_position + Vector2(TARGET_OFFSET_AMOUNT, 0)
	elif self._direction == GameTutorialSlideBuilder.Direction.BELOW_LEFT:
		self.global_position = target_position + Vector2(-TARGET_OFFSET_AMOUNT, TARGET_OFFSET_AMOUNT)
	elif self._direction == GameTutorialSlideBuilder.Direction.BELOW_RIGHT:
		self.global_position = target_position + Vector2(TARGET_OFFSET_AMOUNT, TARGET_OFFSET_AMOUNT)
	elif self._direction == GameTutorialSlideBuilder.Direction.ABOVE_LEFT:
		self.global_position = target_position + Vector2(-TARGET_OFFSET_AMOUNT, -TARGET_OFFSET_AMOUNT)
	elif self._direction == GameTutorialSlideBuilder.Direction.ABOVE_RIGHT:
		self.global_position = target_position + Vector2(TARGET_OFFSET_AMOUNT, -TARGET_OFFSET_AMOUNT)
	
	self.rotation = self.global_position.direction_to(target_position).angle() + PI/2

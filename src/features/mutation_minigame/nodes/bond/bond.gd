extends Line2D
const Nucleotide :Resource = preload("res://features/mutation_minigame/nodes/dna/Nucleotide.gd")

@export var template:Nucleotide
@export var compliment:Nucleotide:
	set(value):
		compliment = value

		make_bond()

func make_bond() -> void:
	self.clear_points()
	if compliment:
		self.add_point( template.global_position - self.global_position + Vector2(template.get_minimum_size().x, 0))
		self.add_point( compliment.global_position - self.global_position + compliment.get_minimum_size())

func _process(_delta: float) -> void:
	if compliment and get_point_count() >1:
		set_point_position(0, template.global_position - self.global_position + Vector2(template.get_minimum_size().x, 0))
		set_point_position(1, compliment.global_position - self.global_position + compliment.get_minimum_size())


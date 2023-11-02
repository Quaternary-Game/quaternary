extends DragButton


@export var type: Globals.Mutation = Globals.Mutation.INSERTION
@export var base: Globals.NitrogenousBase =  Globals.NitrogenousBase.A:
	set(value): 
		text = Globals.NitrogenousBaseDetails[value].name
		base = value

var mutation: Dictionary = {
	Globals.Mutation.INSERTION:{
		"Icon": preload("res://features/mutation_minigame/nodes/mutation/insertion_icon.png"),
		"Tooltip_Text": "An insertion mutation adds a nucleotide, causing a frameshift."
	},
	Globals.Mutation.DELETION:{
		"Icon": preload("res://features/mutation_minigame/nodes/mutation/deletion_icon.png"),
		"Tooltip_Text": "A deletion mutation deletes a nucleotide, causing a frameshift."
	},
	Globals.Mutation.SUBSTITUTION:{
		"Icon": preload("res://features/mutation_minigame/nodes/mutation/substitution_icon.svg"),
		"Tooltip_Text": "A substitution mutation changes one nucleotide into another."
	},
}

func _ready():
	tooltip_text = mutation[type]["Tooltip_Text"]
	icon = mutation[type]["Icon"]
	if type == Globals.Mutation.DELETION:
		base = Globals.NitrogenousBase.BLANK
		vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	self.drop_data = {"Type": type, "Base":base, "node":self}

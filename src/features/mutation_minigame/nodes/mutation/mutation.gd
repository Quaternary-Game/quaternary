extends "res://features/dynamicmenu/DragButton.gd"


@export_enum("Insertion", "Deletion", "Substitution") var type: String = "Insertion"
@export_enum("A", "T", "G", "C") var base: String = "A":
	set(value): 
		text = value
	get: 
		return text

var mutation: Dictionary = {
	"Insertion":{
		"Icon": "insertion_icon.png",
		"Tooltip_Text": "An insertion mutation adds a nucleotide, causing a frameshift."
	},
	"Deletion":{
		"Icon": "deletion_icon.png",
		"Tooltip_Text": "A deletion mutation deletes a nucleotide, causing a frameshift."
	},
	"Substitution":{
		"Icon": "substitution_icon.png",
		"Tooltip_Text": "blah blah blah"
	},
}

func _ready():
	
	tooltip_text = mutation[type]["Tooltip_Text"]
	icon = load("res://features/mutation_minigame/nodes/mutation/%s" % mutation[type]["Icon"])
	if type == "Deletion":
		base = " "
		vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	self.drop_data = {"Type": type, "Base":base, "node":self}

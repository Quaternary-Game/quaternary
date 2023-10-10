extends PanelContainer

@export_enum("A", "G", "T", "C", "BLANK") var base: String = "BLANK"
signal mutation(node, mutation)
@export var bg_visible: bool = true:
	set = set_bg_visible
		
func set_bg_visible(value):
	if value:
		self.remove_theme_stylebox_override("Panel")
	else:
		self.add_theme_stylebox_override("Panel",StyleBoxEmpty.new())

var nitro_bases :Dictionary = {
	"A": {
		"Tooltip": "Adenine",
		"Color": Color.GREEN,
		"Text": "A"
	},
	"G": {
		"Tooltip": "Adenine",
		"Color": Color.BLUE,
		"Text": "G"
	},
	"T": {
		"Tooltip": "Adenine",
		"Color": Color.RED,
		"Text": "T"
	},
	"C": {
		"Tooltip": "Adenine",
		"Color": Color.ORANGE,
		"Text": "C"
	},
	
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var label = $Label
	if base == "BLANK":
		label.text = " "
		return
	var base_info: Dictionary = nitro_bases[base]
	label.text = base_info["Text"]
	label.add_theme_color_override("font_color", base_info["Color"])
	self.tooltip_text = base_info["Tooltip"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _can_drop_data(position, data):
	if data is Dictionary:
		if (data["Type"] == "Insertion" and base == "BLANK"):
			return true
		if (data["Type"] == "Deletion" or data["Type"] == "Substitution") and base != "BLANK":
			return true
	return false
	
func _drop_data(at_position, data):
	print(data)
	mutation.emit(self, data)
	

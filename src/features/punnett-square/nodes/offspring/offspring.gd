extends PanelContainer

@export var correct_genotype:String

var correct_color:Color
var incorrect_color:Color = Color("ff0000")
var correct:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	correct_color = self.modulate
	self.modulate = Color("ff0000")
	correct = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_correct_genotype(p1:String, p2:String):
	var genotype:String = ""
	var s:Array[String]
	for i in len(p1):
		s = [p1[i], p2[i]]
		s.sort()
		genotype += s[0] + s[1]
		
	self.correct_genotype = genotype
	return genotype

func check_genotype():
	var genotype:String = get_child(0).text
	return genotype == self.correct_genotype

func _on_genotype_text_changed(new_text):
	if check_genotype():
		self.modulate = correct_color
		if !correct:
			correct = true
			get_parent().add_correct()
	else:
		self.modulate = incorrect_color
		if correct:
			correct = false
			get_parent().sub_correct()

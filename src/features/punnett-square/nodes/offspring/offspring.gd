extends PanelContainer
## Offspring cells of the punnett square
##
## This script contains the functionality for the offspring cells in the
## punnett square where the user will input the genotypes.

@export var correct_genotype:String ## correct genotype for the cell

var correct_color:Color = get_theme_color("14", "pallete") ## Color when input is correct
var incorrect_color:Color = get_theme_color("11", "pallete") ## color when input is incorrect
var correct:bool ## boolean flag for input

## set color and flag to incorrect initially
func _ready() -> void:
	self.modulate = incorrect_color
	correct = false

## To be called by main scene when building punnett square
## defines the correct genotype for the cell
func set_correct_genotype(p1:String, p2:String) -> String:
	var genotype:String = ""
	var s:Array[String]
	for i : int in len(p1):
		s = [p1[i], p2[i]]
		s.sort()
		genotype += s[0] + s[1]
		
	self.correct_genotype = genotype
	return genotype

## Checks input to see if correct
func check_genotype() -> bool:
	var genotype:String = get_child(0).text
	return genotype == self.correct_genotype

## Called when input changes
## updates color based on input
func _on_genotype_text_changed(_new_text: String) -> void:
	if check_genotype():
		SoundPlayer.play_confirm()
		self.modulate = correct_color
		if !correct:
			correct = true
			get_parent().emit_end_tutorial()
			get_parent().add_correct()
	else:
		self.modulate = incorrect_color
		if correct:
			correct = false
			get_parent().sub_correct()

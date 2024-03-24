extends Theme
## A script to define and set up the global theme
##
## Theme related global constants are defined here, such as colors
## or 
@export_group("Pallete Colors")
@export var color00 : Color = Color("2E3440")
@export var color01 : Color = Color("3B4252")
@export var color02 : Color = Color("434C5E")
@export var color03 : Color = Color("4C566A")
@export var color04 : Color = Color("D8DEE9")
@export var color05 : Color = Color("E5E9F0")
@export var color06 : Color = Color("eceff4")
@export var color07 : Color = Color("8fbcbb")
@export var color08 : Color = Color("88C0D0")
@export var color09 : Color = Color("81A1C1")
@export var color10 : Color = Color("5E81AC")
@export var color11 : Color = Color("BF616A") ## RED
@export var color12 : Color = Color("D08770")
@export var color13 : Color = Color("EBCB8B")
@export var color14 : Color = Color("A3BE8C") ## GREEN
@export var color15 : Color = Color("B48EAD")

@export var bg: Color = Color("283618")
@export var border: Color = Color("dda15e")

@export var A: Color = color14
@export var G: Color = color07
@export var T: Color = color11
@export var C: Color = color13



## Sets up the global colors, get from any node with get_theme_color(colorname, typename)
func colors() -> void:
	set_color("00", "pallete", color00)
	set_color("01", "pallete", color01)
	set_color("02", "pallete", color02)
	set_color("03", "pallete", color03)
	set_color("04", "pallete", color04)
	set_color("05", "pallete", color05)
	set_color("06", "pallete", color06)
	set_color("07", "pallete", color07)
	set_color("08", "pallete", color08)
	set_color("09", "pallete", color09)
	set_color("10", "pallete", color10)
	set_color("11", "pallete", color11)
	set_color("12", "pallete", color12)
	set_color("13", "pallete", color13)
	set_color("14", "pallete", color14)
	set_color("15", "pallete", color15)
	
	set_color("A", "Nucleotide", A)
	set_color("G", "Nucleotide", G)
	set_color("T", "Nucleotide", T)
	set_color("C", "Nucleotide", C)
	
	set_color("bond", "Background", color06)
	set_color("circle", "trait", color06)
	set_color("entity_selector", "entity_manager", color11)

func modify_stylebox(name: StringName,theme_type: StringName, property: StringName, value: Variant ) -> void:
	# needed to avoid lengthy syntax for modification of stylebox properties
	var stylebox: StyleBox = get_stylebox(name, theme_type)
	stylebox.set(property, value)
	set_stylebox(name, theme_type, stylebox)
	

func styleboxes() -> void:
	#modify_stylebox("panel", "Panel", "bg_color", bg)
	#modify_stylebox("panel", "Panel", "border_color", border)
	pass
func debug() -> void:
	print(get_color_type_list())
	for i: String in get_color_type_list():
		print("color type %s:%s" % [i, get_color_list(i)])
	for i: String in get_stylebox_type_list():
		print("stylebox type %s: %s" % [i, get_stylebox_list(i)])
	
func _init() -> void:
	colors()
	styleboxes()
	#debug()
	
	
	

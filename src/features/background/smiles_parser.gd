extends Node

# we need to define the context free grammar for smiles so we can generate bonds
# from chains which can be represented regularly
# See: http://opensmiles.org/opensmiles.pdf

# smiles for ATP
#C1=NC(=C2C(=N1)N(C=N2)C3C(C(C(O3)COP(=O)(O)OP(=O)(O)OP(=O)(O)O)O)O)N

func consume(s: String, left: String, right: String, left_consume_rule: String="1", right_consume_rule: String="1") -> String:
	var new_str: String = ""
	var left_count: int = 0
	var right_count: int = 0
	var left_max: int = 1
	var right_max: int = 1
	if left_consume_rule not in ["*", "?"]:
		left_max = left_consume_rule.to_int()
	if right_consume_rule not in ["*", "?"]:
		right_max = left_consume_rule.to_int()

	for i: String in s:
		if i == left:
			if left_consume_rule not in ["*", "?"] and left_count > left_max:
				new_str = new_str + i
			else:
				left_count = left_count + 1
		elif i == right:
			if right_consume_rule not in ["*", "?"] and right_count > right_max:
				new_str = new_str + i
			else:
				right_count = right_count + 1
		else:
			new_str = new_str + i
	return new_str

func aliphatic_organic(s: String) -> bool:
	var l: Array = ["B", "C", "N", "O", "S", "P", "F", "Cl", "Br", "I"]
	return s in l

func aromatic_organic(s: String) -> bool:
	var l: Array = ["b", "c", "n", "o", "s", "p"]
	return s in l

func element_symbols(s: String) -> bool:
	var l: Array = ["H", "He", "Li", "Be", "B", "C", "N", "O", "F", "Ne", "Na",
					"Mg", "Al", "Si", "P", "S", "Cl", "Ar", "K", "Ca", "Sc", "Ti", "V", "Cr",
					"Mn", "Fe", "Co", "Ni", "Cu", "Zn", "Ga", "Ge", "As", "Se", "Br", "Kr",
					"Rb", "Sr", "Y", "Zr", "Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd",
					"In", "Sn", "Sb", "Te", "I", "Xe", "Cs", "Ba", "Hf", "Ta", "W", "Re",
					"Os", "Ir", "Pt", "Au", "Hg", "Tl", "Pb", "Bi", "Po", "At", "Rn", "Fr",
					"Ra", "Rf", "Db", "Sg", "Bh", "Hs", "Mt", "Ds", "Rg", "Cn", "Fl", "Lv",
					"La", "Ce", "Pr", "Nd", "Pm", "Sm", "Eu", "Gd", "Tb", "Dy", "Ho", "Er",
					"Tm", "Yb", "Lu", "Ac", "Th", "Pa", "U", "Np", "Pu", "Am", "Cm", "Bk",
					"Cf", "Es", "Fm", "Md", "No", "Lr"]
	return s in l

func number(s: String) -> bool:
	var regex: RegEx = RegEx.new()
	regex.compile("[0-9]+")
	if regex.search(s):
		return true
	else:
		return false
func digit(s: String) -> bool:
	var regex: RegEx = RegEx.new()
	regex.compile("[0-9]{1}")
	if regex.search(s):
		return true
	else:
		return false

func isotope(s: String) -> bool:
	return number(s)

func aromatic_symbols(s: String) -> bool:
	var l: Array = ["b", "c", "n", "o", "p", "s", "se", "as"]
	return s in l

func symbol(s: String) -> bool:
	return s == "*" or element_symbols(s) or aromatic_symbols(s)
func hcount(s: String) -> bool:
	if len(s) > 1:
		return s[0] == "H" and digit(s.substr(1))
	return s == "H"

func bracket_atom(s: String) -> bool:
	if s.begins_with("[") and s.ends_with("]"):
		s = s.substr(1, -2)
	else:
		return false
	return true

func atom(s: String) -> bool:
	return s == "*" or aromatic_organic(s) or aliphatic_organic(s)

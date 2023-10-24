class_name Globals

enum NitrogenousBase {
	A,
	G,
	T,
	C,
	BLANK
}

const NitrogenousBaseDetails: Dictionary =  {
	NitrogenousBase.A:{
		"name": "A",
		"long_name": "ADENINE"
	},
	NitrogenousBase.G:{
		"name": "G",
		"long_name": "GUANINE"
	},
	NitrogenousBase.C:{
		"name": "C",
		"long_name": "CYTOSINE"
	},
	NitrogenousBase.T:{
		"name": "T",
		"long_name": "THYMINE"
	},
	NitrogenousBase.BLANK:{
		"name": " ",
		"long_name": " "
	}
}
enum Mutation {
	INSERTION,
	DELETION,
	SUBSTITUTION
}
var MutationDetails: Dictionary = {
	Mutation.INSERTION: {
		"name":"Insertion",
	},
	Mutation.DELETION: {
		"name": "Deletion"
	},
	Mutation.SUBSTITUTION: {
		"name": "Substitution"
	}
}

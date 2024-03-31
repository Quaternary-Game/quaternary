class_name Globals

enum NitrogenousBase {
	A,
	G,
	T,
	C,
	BLANK,
	U
}

const NitrogenousBaseDetails: Dictionary =  {
	NitrogenousBase.A:{
		"name": "A",
		"long_name": "ADENINE",
		"bond": NitrogenousBase.T,
		"bondRNA": NitrogenousBase.U
	},
	NitrogenousBase.G:{
		"name": "G",
		"long_name": "GUANINE",
		"bond": NitrogenousBase.C,
		"bondRNA": NitrogenousBase.C
	},
	NitrogenousBase.C:{
		"name": "C",
		"long_name": "CYTOSINE",
		"bond": NitrogenousBase.G,
		"bondRNA": NitrogenousBase.G
	},
	NitrogenousBase.T:{
		"name": "T",
		"long_name": "THYMINE",
		"bond": NitrogenousBase.A,
		"bondRNA": NitrogenousBase.A
	},
	NitrogenousBase.U:{
		"name": "U",
		"long_name": "URACIL",
		"bond": NitrogenousBase.A,
		"bondRNA": NitrogenousBase.A
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


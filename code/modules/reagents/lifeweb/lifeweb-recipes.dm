//WHY DO YOU NIGGERS KEEP USING RELATIVE PATHING????
//IT LOOKS UGLY AND MAKES SHIT HARDER TO FIND
/datum/chemical_reaction/dentrine
	name = "Dentrine"
	id = "dentrine"
	result = "dentrine"
	required_reagents = list("inaprovaline" = 1, "californium" = 1, "selenium" = 1)
	result_amount = 3

/datum/chemical_reaction/dylovene
	name = "Dylovene"
	id = "dylovene"
	result = "dylovene"
	required_reagents = list("europium" = 1, "tantalum" = 1, "hassium" = 1)
	result_amount = 3

/datum/chemical_reaction/explosion_cagata
	name = "Explosion"
	id = "explosion_cagata"
	result = null
	required_reagents = list("californium" = 1, "gallium" = 1, "tantalum" = 1)
	result_amount = 2

/datum/chemical_reaction/explosion_cagata/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/simulated/T = get_turf(holder.my_atom)
	explosion(T,created_volume/15,0,created_volume/15,2)

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	id = "kelotane"
	result = "kelotane"
	required_reagents = list("europium" = 1, "lutetium" = 1)
	result_amount = 2

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	result = "bicaridine"
	required_reagents = list("inaprovaline" = 1, "lutetium" = 1)
	result_amount = 2

/datum/chemical_reaction/tricordazine
	name = "Tricordazine"
	id = "tricordazine"
	result = "tricordazine"
	required_reagents = list("inaprovaline" = 1, "dylovene" = 1)
	result_amount = 2

/datum/chemical_reaction/alkysine
	name = "Alkysine"
	id = "alkysine"
	result = "alkysine"
	required_reagents = list("hassium" = 1, "technetium" = 1, "dylovene" = 1)
	result_amount = 3

/datum/chemical_reaction/mentats
	name = "Mentats"
	id = "mentats"
	result = "mentats"
	required_reagents = list("alkysine" = 1, "iridium" = 1)
	result_amount = 2

/datum/chemical_reaction/dob
	name = "DOB"
	id = "dob"
	result = "dob"
	required_reagents = list("morphite" = 1, "rellurium" = 1, "europium" = 1)
	result_amount = 3

/datum/chemical_reaction/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	result = "oxycodone"
	required_reagents = list("thorium" = 1, "iridium" = 1, "lithium" = 1)
	result_amount = 3

/datum/chemical_reaction/raque
	name = "RAQUE"
	id = "raque"
	result = "raque"
	required_reagents = list("thorium" = 1, "europium" = 1, "lithium" = 1)
	result_amount = 3

/datum/chemical_reaction/vaccine
	name = "Vaccine"
	id = "vaccine"
	result = "vaccine"
	required_reagents = list("dylovene" = 1, "antibiotic" = 1)
	result_amount = 2

/datum/chemical_reaction/gelabine
	name = "Gelabine"
	id = "gelabine"
	result = "gelabine"
	required_reagents = list("selenium" = 1, "tantalum" = 1, "molybdenum" = 1)
	result_amount = 3

/datum/chemical_reaction/mdma
	name = "MDMA"
	id = "mdma"
	result = "mdma"
	result_amount = 3
	required_reagents = list("lutetium" = 1, "alkysine" = 1, "thorium" = 1)

/datum/chemical_reaction/changa
	name = "Changa"
	id = "changa"
	result = "changa"
	result_amount = 2 // poor yield because it's a very powerful and abusable drug
	required_reagents = list("buffout" = 2, "cesium" = 2, "inaprovaline" = 4)

/datum/chemical_reaction/antibiotic
	name = "Antibiotic"
	id = "antibiotic"
	result = "antibiotic"
	required_reagents = list("tantalum" = 1, "morphite" = 1, "iridium" = 1)
	result_amount = 3

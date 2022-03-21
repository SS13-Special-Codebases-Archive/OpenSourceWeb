/////////////////////////////////////////
////////////Medical Tools////////////////
/////////////////////////////////////////

/datum/design/mass_spectrometer
	name = "Mass-Spectrometer"
	desc = "A device for analyzing chemicals in the blood."
	id = "mass_spectrometer"
	req_tech = list("biotech" = 2, "magnets" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 30, "$glass" = 20)
	reliability_base = 76
	build_path = /obj/item/device/mass_spectrometer

/datum/design/adv_mass_spectrometer
	name = "Advanced Mass-Spectrometer"
	desc = "A device for analyzing chemicals in the blood and their quantities."
	id = "adv_mass_spectrometer"
	req_tech = list("biotech" = 2, "magnets" = 4)
	build_type = PROTOLATHE
	materials = list("$metal" = 30, "$glass" = 20)
	reliability_base = 74
	build_path = /obj/item/device/mass_spectrometer/adv


// Implants

/datum/design/implant_loyal
	name = "loyalty implant"
	desc = "Makes you loyal or such."
	id = "implant_loyal"
	req_tech = list("materials" = 2, "biotech" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 7000, "$glass" = 7000)
	build_path = /obj/item/weapon/implant/loyalty

/datum/design/implant_chem
	name = "chemical implant"
	desc = "Injects things."
	id = "implant_chem"
	req_tech = list("materials" = 2, "biotech" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/implant/chem

/datum/design/implant_free
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	id = "implant_free"
	req_tech = list("syndicate" = 2, "biotech" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/implant/freedom


/////////////////////////////////////////
////////////Chemical Tools///////////////
/////////////////////////////////////////

/datum/design/reagent_scanner
	name = "Reagent Scanner"
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	req_tech = list("biotech" = 2, "magnets" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 30, "$glass" = 20)
	reliability_base = 76
	build_path = /obj/item/device/reagent_scanner

/datum/design/adv_reagent_scanner
	name = "Advanced Reagent Scanner"
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	req_tech = list("biotech" = 2, "magnets" = 4)
	build_type = PROTOLATHE
	materials = list("$metal" = 30, "$glass" = 20)
	reliability_base = 74
	build_path = /obj/item/device/reagent_scanner/adv


// Beakers

/datum/design/bluespacebeaker
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bluespacebeaker"
	req_tech = list("bluespace" = 2, "materials" = 6)
	build_type = PROTOLATHE
	materials = list("$metal" = 3000, "$plasma" = 3000, "$diamond" = 500)
	reliability_base = 76
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bluespace

/datum/design/noreactbeaker
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list("materials" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 3000)
	reliability_base = 76
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/noreact
	category = "Misc"


// Delivery

/datum/design/chemsprayer
	name = "Chem Sprayer"
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list("materials" = 3, "engineering" = 3, "biotech" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 5000, "$glass" = 1000)
	reliability_base = 100
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer

/datum/design/rapidsyringe
	name = "Rapid Syringe Gun"
	desc = "A gun that fires many syringes."
	id = "rapidsyringe"
	req_tech = list("combat" = 3, "materials" = 3, "engineering" = 3, "biotech" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 5000, "$glass" = 1000)
	build_path = /obj/item/weapon/gun/syringe/rapidsyringe
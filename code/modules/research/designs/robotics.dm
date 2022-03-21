/////////////////////////////////////////
////////////Robotics Tools///////////////
/////////////////////////////////////////

/datum/design/mmi
	name = "Man-Machine Interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
	id = "mmi"
	req_tech = list("programming" = 2, "biotech" = 3)
	build_type = PROTOLATHE | MECHFAB
	materials = list("$metal" = 1000, "$glass" = 500)
	reliability_base = 76
	build_path = /obj/item/device/mmi
	category = "Misc"

/datum/design/mmi/radio
	name = "Radio-enabled Man-Machine Interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."
	id = "mmi_radio"
	req_tech = list("programming" = 2, "biotech" = 4)
	materials = list("$metal" = 1200, "$glass" = 500)
	reliability_base = 74
	build_path = /obj/item/device/mmi/radio_enabled

/datum/design/posibrain
	name = "Positronic Brain"
	desc = "Allows for the construction of a positronic brain"
	id = "posibrain"
	req_tech = list("engineering" = 4, "materials" = 6, "bluespace" = 2, "programming" = 4)
	build_type = PROTOLATHE
	materials = list("$metal" = 2000, "$glass" = 1000, "$silver" = 1000, "$gold" = 500, "$plasma" = 500, "$diamond" = 100)
	build_path = /obj/item/device/mmi/posibrain


/datum/design/synthetic_flash
	name = "Synthetic Flash"
	desc = "When a problem arises, SCIENCE is the solution."
	id = "sflash"
	req_tech = list("magnets" = 3, "combat" = 2)
	build_type = MECHFAB
	materials = list("$metal" = 750, "$glass" = 750)
	reliability_base = 76
	build_path = /obj/item/device/flash/synthetic
	category = "Misc"

/datum/design/nanopaste
	name = "nanopaste"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	req_tech = list("materials" = 4, "engineering" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 7000, "$glass" = 7000)
	build_path = /obj/item/stack/nanopaste


/datum/design/intellicard
	name = "Intellicard AI Transportation System"
	desc = "Allows for the construction of an intellicard."
	id = "intellicard"
	req_tech = list("programming" = 4, "materials" = 4)
	build_type = PROTOLATHE
	materials = list("$glass" = 1000, "$gold" = 200)
	build_path = /obj/item/device/aicard

/datum/design/paicard
	name = "Personal Artificial Intelligence Card"
	desc = "Allows for the construction of a pAI Card"
	id = "paicard"
	req_tech = list("programming" = 2)
	build_type = PROTOLATHE
	materials = list("$glass" = 500, "$metal" = 500)
	build_path = /obj/item/device/paicard
/////////////////////////////////////////
/////////////////Mining//////////////////
/////////////////////////////////////////

/datum/design/jackhammer
	name = "Sonic Jackhammer"
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	id = "jackhammer"
	req_tech = list("materials" = 3, "powerstorage" = 2, "engineering" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 2000, "$glass" = 500, "$silver" = 500)
	build_path = /obj/item/weapon/pickaxe/jackhammer

/datum/design/drill
	name = "Mining Drill"
	desc = "Yours is the drill that will pierce through the rock walls."
	id = "drill"
	req_tech = list("materials" = 2, "powerstorage" = 3, "engineering" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 6000, "$glass" = 1000) //expensive, but no need for miners.
	build_path = /obj/item/weapon/pickaxe/drill
/*
/datum/design/kinetic_accelerator
	name = "Proto-kinetic accelerator"
	desc = "According to Nanotrasen accounting, this is mining equipment. It's been modified for extreme power output to crush rocks, but often serves as a miner's first defense against hostile alien life; it's not very powerful unless used in a low pressure environment"
	id = "kineticgun"
	req_tech = list("materials" = 3, "powerstorage" = 2, "engineering" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 2000, "$glass" = 500, "$silver" = 500)
	build_path = /obj/item/weapon/gun/energy/kinetic_accelerator
*/
/datum/design/plasmacutter
	name = "Plasma Cutter"
	desc = "You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	id = "plasmacutter"
	req_tech = list("materials" = 4, "plasmatech" = 3, "engineering" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 1500, "$glass" = 500, "$gold" = 500, "$plasma" = 500)
	reliability_base = 79
	build_path = /obj/item/weapon/gun/energy/plasmacutter

/datum/design/pick_diamond
	name = "Diamond Pickaxe"
	desc = "A pickaxe with a diamond pick head, this is just like minecraft."
	id = "pick_diamond"
	req_tech = list("materials" = 6)
	build_type = PROTOLATHE
	materials = list("$metal" = 500, "$diamond" = 3000)
	build_path = /obj/item/weapon/pickaxe/diamond

/datum/design/drill_diamond
	name = "Diamond Mining Drill"
	desc = "Yours is the drill that will pierce the heavens!"
	id = "drill_diamond"
	req_tech = list("materials" = 6, "powerstorage" = 4, "engineering" = 4)
	build_type = PROTOLATHE
	materials = list("$metal" = 3000, "$glass" = 1000, "$diamond" = 3750) //Yes, a whole diamond is needed.
	reliability_base = 79
	build_path = /obj/item/weapon/pickaxe/diamonddrill




/datum/design/mesons
	name = "Optical Meson Scanners"
	desc = "Used for seeing walls, floors, and stuff through anything."
	id = "mesons"
	req_tech = list("magnets" = 2, "engineering" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/clothing/glasses/meson
/////////////////////////////////////////
///////////////////PDA///////////////////
/////////////////////////////////////////

/datum/design/pda
	name = "PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	id = "pda"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/device/pda


// Cartridges

/datum/design/cart_basic
	name = "Generic Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_basic"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge

/datum/design/cart_engineering
	name = "Power-ON Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_engineering"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/engineering

/datum/design/cart_atmos
	name = "BreatheDeep Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_atmos"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/atmos

/datum/design/cart_medical
	name = "Med-U Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_medical"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/medical

/datum/design/cart_chemistry
	name = "ChemWhiz Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_chemistry"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/chemistry

/datum/design/cart_security
	name = "R.O.B.U.S.T. Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_security"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/security
	locked = 0

/datum/design/cart_janitor
	name = "CustodiPRO Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_janitor"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/janitor

/*
/datum/design/cart_clown
	name = "Honkworks 5.0 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_clown"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/clown
/datum/design/cart_mime
	name = "Gestur-O 1000 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_mime"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/mime
*/

/datum/design/cart_toxins
	name = "Signal Ace 2 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_toxins"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/signal/toxins

/datum/design/cart_quartermaster
	name = "Space Parts & Space Vendors Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_quartermaster"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/quartermaster
	locked = 0

/datum/design/cart_hop
	name = "Human Resources 9001 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_hop"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/hop
	locked = 0

/datum/design/cart_hos
	name = "R.O.B.U.S.T. DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_hos"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/hos
	locked = 0

/datum/design/cart_ce
	name = "Power-On DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_ce"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/ce
	locked = 0

/datum/design/cart_cmo
	name = "Med-U DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_cmo"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/cmo
	locked = 0

/datum/design/cart_rd
	name = "Signal Ace DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_rd"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/rd
	locked = 0

/datum/design/cart_captain
	name = "Value-PAK Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_captain"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/cartridge/captain
	locked = 0
////////////////////////////////////////
/////////////Syndicate Tech/////////////
////////////////////////////////////////

/datum/design/borg_syndicate_module
	name = "Borg Illegal Weapons Upgrade"
	desc = "Allows for the construction of illegal upgrades for cyborgs"
	id = "borg_syndicate_module"
	build_type = MECHFAB
	req_tech = list("combat" = 4, "syndicate" = 3)
	build_path = /obj/item/borg/upgrade/syndicate
	category = "Cyborg Upgrade Modules"

/datum/design/chameleon
	name = "Chameleon Jumpsuit"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	id = "chameleon"
	req_tech = list("syndicate" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 500)
	build_path = /obj/item/clothing/under/chameleon

/datum/design/binaryencrypt
	name = "Binary Encrpytion Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	id = "binaryencrypt"
	req_tech = list("syndicate" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 300, "$glass" = 300)
	build_path = /obj/item/device/encryptionkey/binary

/datum/design/energysword
	name = "Energy Sword"
	desc = "May the force be within you."
	id = "energysword"
	req_tech = list("syndicate" = 6, "magnets" = 5, "materials" = 6, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$gold" = 5000, "$silver" = 2000, "$metal" = 4000, "$diamond" = 5000)
	build_path = /obj/item/weapon/melee/energy/sword
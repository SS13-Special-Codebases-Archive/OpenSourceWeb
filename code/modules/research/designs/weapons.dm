/////////////////////////////////////////
/////////////////Weapons/////////////////
/////////////////////////////////////////

// Energy Weapons

/datum/design/nuclear_gun
	name = "Advanced Energy Gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	id = "nuclear_gun"
	req_tech = list("combat" = 3, "materials" = 5, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 5000, "$glass" = 1000, "$uranium" = 500)
	reliability_base = 76
	build_path = /obj/item/weapon/gun/energy/gun/nuclear
	locked = 0

/datum/design/stunrevolver
	name = "Stun Revolver"
	desc = "The prize of the Head of Security."
	id = "stunrevolver"
	req_tech = list("combat" = 3, "materials" = 3, "powerstorage" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 4000)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	locked = 0

/datum/design/lasercannon
	name = "Laser Cannon"
	desc = "A heavy duty laser cannon."
	id = "lasercannon"
	req_tech = list("combat" = 4, "materials" = 3, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 10000, "$glass" = 1000, "$diamond" = 2000)
	build_path = /obj/item/weapon/gun/energy/lasercannon
	locked = 0

/datum/design/decloner
	name = "Decloner"
	desc = "Your opponent will bubble into a messy pile of goop."
	id = "decloner"
	req_tech = list("combat" = 8, "materials" = 7, "biotech" = 5, "powerstorage" = 6)
	build_type = PROTOLATHE
	materials = list("$gold" = 5000,"$uranium" = 10000, "mutagen" = 40)
	build_path = /obj/item/weapon/gun/energy/decloner
	locked = 0
/*
/datum/design/plasmapistol
	name = "plasma pistol"
	desc = "A specialized firearm designed to fire lethal bolts of toxins."
	id = "ppistol"
	req_tech = list("combat" = 5, "plasmatech" = 4)
	build_type = PROTOLATHE
	materials = list("$metal" = 5000, "$glass" = 1000, "$plasma" = 3000)
	build_path = /obj/item/weapon/gun/energy/toxgun
*/

datum/design/xray
	name = "Xray Laser Gun"
	desc = "Not quite as menacing as it sounds"
	id = "xray"
	req_tech = list("combat" = 6, "materials" = 5, "biotech" = 5, "powerstorage" = 4)
	build_type = PROTOLATHE
	materials = list("$gold" = 5000,"$uranium" = 10000, "$metal" = 4000)
	build_path = /obj/item/weapon/gun/energy/xray

/datum/design/largecrossbow
	name = "Energy Crossbow"
	desc = "A weapon favoured by syndicate infiltration teams."
	id = "largecrossbow"
	req_tech = list("combat" = 4, "materials" = 5, "engineering" = 5, "biotech" = 4, "syndicate" = 6)
	build_type = PROTOLATHE
	materials = list("$metal" = 5000, "$glass" = 1000, "$uranium" = 1000, "$silver" = 1000)
	build_path = /obj/item/weapon/gun/energy/crossbow/largecrossbow

/datum/design/temp_gun
	name = "Temperature Gun"
	desc = "A gun that shoots temperature bullet energythings to change temperature."//Change it if you want
	id = "temp_gun"
	req_tech = list("combat" = 3, "materials" = 4, "powerstorage" = 3, "magnets" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 5000, "$glass" = 500, "$silver" = 3000)
	build_path = /obj/item/weapon/gun/energy/temperature
	locked = 0

// Projectile Weapons

/datum/design/smg
	name = "Submachine Gun"
	desc = "A lightweight, fast firing gun."
	id = "smg"
	req_tech = list("combat" = 4, "materials" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 8000, "$silver" = 2000, "$diamond" = 1000)
	build_path = /obj/item/weapon/gun/projectile/automatic
	locked = 0


// Other Weapons

/datum/design/flora_gun
	name = "Floral Somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells. Harmless to other organic life."
	id = "flora_gun"
	req_tech = list("materials" = 2, "biotech" = 3, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 2000, "$glass" = 500, "$uranium" = 500)
	build_path = /obj/item/weapon/gun/energy/floragun


// Ammo

/datum/design/ammo_9mm
	name = "SMG Magazine (9mm)"
	desc = "A box of prototype 9mm ammunition."
	id = "ammo_9mm"
	req_tech = list("combat" = 4, "materials" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 3750, "$silver" = 100)
	build_path = /obj/item/ammo_magazine/external/msmg9mm

/datum/design/stunshell
	name = "Stun Shell"
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list("combat" = 3, "materials" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell

/datum/design/large_grenade
	name = "Large Grenade"
	desc = "A grenade that affects a larger area and use larger containers."
	id = "large_Grenade"
	req_tech = list("combat" = 3, "materials" = 2)
	build_type = PROTOLATHE
	materials = list("$metal" = 3000)
	reliability_base = 79
	build_path = /obj/item/weapon/grenade/chem_grenade/large
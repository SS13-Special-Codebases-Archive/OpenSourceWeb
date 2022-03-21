////////////////////////////////////////
//////////////////Power/////////////////
////////////////////////////////////////

/datum/design/basic_cell
	name = "Basic Power Cell"
	desc = "A basic power cell that holds 1000 units of energy"
	id = "basic_cell"
	req_tech = list("powerstorage" = 1)
	build_type = PROTOLATHE | AUTOLATHE |MECHFAB
	materials = list("$metal" = 700, "$glass" = 50)
	build_path = /obj/item/weapon/cell
	category = "Misc"

/datum/design/high_cell
	name = "High-Capacity Power Cell"
	desc = "A power cell that holds 10000 units of energy"
	id = "high_cell"
	req_tech = list("powerstorage" = 2)
	build_type = PROTOLATHE | AUTOLATHE | MECHFAB
	materials = list("$metal" = 700, "$glass" = 60)
	build_path = /obj/item/weapon/cell/high
	category = "Misc"

/datum/design/super_cell
	name = "Super-Capacity Power Cell"
	desc = "A power cell that holds 20000 units of energy"
	id = "super_cell"
	req_tech = list("powerstorage" = 3, "materials" = 2)
	reliability_base = 75
	build_type = PROTOLATHE | MECHFAB
	materials = list("$metal" = 700, "$glass" = 70)
	build_path = /obj/item/weapon/cell/super
	category = "Misc"

/datum/design/hyper_cell
	name = "Hyper-Capacity Power Cell"
	desc = "A power cell that holds 30000 units of energy"
	id = "hyper_cell"
	req_tech = list("powerstorage" = 5, "materials" = 4)
	reliability_base = 70
	build_type = PROTOLATHE | MECHFAB
	materials = list("$metal" = 400, "$gold" = 150, "$silver" = 150, "$glass" = 70)
	build_path = /obj/item/weapon/cell/hyper
	category = "Misc"

/datum/design/light_replacer
	name = "Light Replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list("magnets" = 3, "materials" = 4)
	build_type = PROTOLATHE
	materials = list("$metal" = 1500, "$silver" = 150, "$glass" = 3000)
	build_path = /obj/item/device/lightreplacer
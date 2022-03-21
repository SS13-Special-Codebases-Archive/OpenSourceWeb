/////////////////////////////////////////
//////////////Blue Space/////////////////
/////////////////////////////////////////

/datum/design/beacon
	name = "Tracking Beacon"
	desc = "A blue space tracking beacon."
	id = "beacon"
	req_tech = list("bluespace" = 1)
	build_type = PROTOLATHE
	materials = list ("$metal" = 20, "$glass" = 10)
	build_path = /obj/item/device/radio/beacon

/datum/design/bag_holding
	name = "Bag of Holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	id = "bag_holding"
	req_tech = list("bluespace" = 4, "materials" = 6)
	build_type = PROTOLATHE
	materials = list("$gold" = 3000, "$diamond" = 1500, "$uranium" = 250)
	reliability_base = 80
	build_path = /obj/item/weapon/storage/backpack/holding

/datum/design/bag_holding/belt
	name = "Belt of Holding"
	desc = "A belt that opens into a localized pocket of Blue Space."
	id = "belt_holding"
	materials = list("$gold" = 7500, "$diamond" = 3750, "$uranium" = 500, "$silver" = 3750)
	build_path = /obj/item/weapon/storage/backpack/holding/belt

/datum/design/bluespace_crystal
	name = "Artificial Bluespace Crystal"
	desc = "A small blue crystal with mystical properties."
	id = "bluespace_crystal"
	req_tech = list("bluespace" = 5, "materials" = 7)
	build_type = PROTOLATHE
	materials = list("$gold" = 1500, "$diamond" = 3000, "$plasma" = 1500)
	reliability_base = 100
	build_path = /obj/item/weapon/stock_parts/bluespace_crystal/artificial


/datum/design/telesci_gps
	name = "GPS Device"
	desc = "Little thingie that can track its position at all times."
	id = "telesci_gps"
	req_tech = list("materials" = 2, "magnets" = 3, "bluespace" = 3)
	build_type = PROTOLATHE
	materials = list("$metal" = 500, "$glass" = 1000)
	build_path = /obj/item/device/gps



/obj/item/clothing/shoes/lw
	name = "shoes"
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
////////////////////
/////// ARMOR //////
////////////////////

/obj/item/clothing/shoes/lw/swat
	name = "SWAT shoes"
	icon_state = "swat"
	armor = list(melee = 70, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	siemens_coefficient = 0.6
	armor_type = ARMOR_METAL

/obj/item/clothing/shoes/lw/combat
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat"
	icon_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	siemens_coefficient = 0.6
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	armor_type = ARMOR_METAL

/obj/item/clothing/shoes/lw/infantry
	name = "infantry boots"
	icon_state = "infantry"
	armor = list(melee = 10, bullet = 0)
	armor_type = ARMOR_LEATHER

/obj/item/clothing/shoes/lw/paladin
	name = "paladin boots"
	desc = "For treading upon the bones of heretics"
	icon_state = "paladin"
	armor = list(melee = 35, bullet = 0)
	item_worth = 60
	drop_sound = 'metalboots_drop.ogg'
	armor_type = ARMOR_METAL

/obj/item/clothing/shoes/lw/soulbreaker
	name = "soulbreaker boots"
	desc = "Boots worn by the followers of Allah."
	icon_state = "soulbreaker"
	armor = list(melee = 40, bullet = 40)
	item_worth = 100
	drop_sound = 'metalboots_drop.ogg'
	armor_type = ARMOR_METAL
	body_parts_covered = FEET

/obj/item/clothing/shoes/lw/iron
	name = "iron boots"
	desc = "For stomping on the defenseless"
	icon_state = "ironboots"
	armor = list(melee = 30, bullet = 0)
	item_worth = 16
	drop_sound = 'metalboots_drop.ogg'
	armor_type = ARMOR_METAL
	min_cold_protection_temperature = 1500

////////////////////
///////DEFAULT//////
////////////////////
/obj/item/clothing/shoes/lw/jester_shoes
	name = "jester shoes"
	icon_state = "jestershoes"
	item_state = "jestershoes"
	slowdown = 0
	species_restricted = list("Midget")

/obj/item/clothing/shoes/lw/jester_court
	name = "jester shoes"
	icon_state = "jester"
	item_state = "jester"
	slowdown = 0

/obj/item/clothing/shoes/lw/clown_shoes
	name = "clown shoes"
	icon_state = "clown" // SEM ICON
	item_state = "clown"

/obj/item/clothing/shoes/lw/jackboots
	name = "jackboots"
	icon_state = "jackboots"
	item_state = "jackboots"
	armor = list(melee = 15, bullet = 0)
	item_worth = 15
	siemens_coefficient = 0.7
	armor_type = ARMOR_LEATHER
	body_parts_covered = FEET

/obj/item/clothing/shoes/lw/hunter
	name = "hunter boots"
	icon_state = "hunterboots"
	item_state = "hunterboots"
	armor = list(melee = 15, bullet = 0)
	item_worth = 15
	siemens_coefficient = 0.7
	armor_type = ARMOR_LEATHER
	body_parts_covered = FEET

/obj/item/clothing/shoes/lw/boots
	name = "boots"
	icon_state = "boots"
//AMUSER//
/obj/item/clothing/shoes/lw/fetish
	name = "red latex boots"
	icon_state = "fetish"

/obj/item/clothing/shoes/lw/fetish/black
	name = "dominatrix latex boots"
	icon_state = "fetishblack"
//////////
/obj/item/clothing/shoes/lw/brown
	name = "brown shoes"
	icon_state = "brown"

/obj/item/clothing/shoes/lw/black
	name = "black shoes"
	icon_state = "black" // FALTA ICON NO CORPO


/obj/item/clothing/shoes/lw/meister
	name = "boots"
	icon_state = "meister"

/obj/item/clothing/shoes/lw/merc_boots
	name = "leather boots"
	icon_state = "merc_boots"
	armor = list(melee = 10)
	armor_type = ARMOR_LEATHER

/obj/item/clothing/shoes/lw/leatherboots
	name = "leather boots"
	icon_state = "leatherboots"
	armor = list(melee = 10)
	armor_type = ARMOR_LEATHER

/obj/item/clothing/shoes/lw/thief
	name = "boots"
	icon_state = "thief"
	armor = list(melee = 10)

/obj/item/clothing/shoes/lw/bastard
	name = "boots"
	icon_state = "bastard"
	item_state = "veteran_bum"
	armor = list(melee = 10)
	armor_type = ARMOR_LEATHER

/obj/item/clothing/shoes/lw/ravshoes
	name = "firethorner boots"
	icon_state = "ravshoes"

/obj/item/clothing/shoes/lw/inshoes
	name = "inspector shoes"
	icon_state = "inshoes"

/obj/item/clothing/shoes/lw/veteran_bum
	name = "dirty shoes"
	icon_state = "veteran_bum"
	item_state = "veteran_bum"

/obj/item/clothing/shoes/lw/stiletto_shoes
	name = "stiletto boots"
	icon_state = "stiletto_boots"
	armor = list(melee = 10)

//////////////////////
/////////MISC/////////
//////////////////////

/obj/item/clothing/shoes/lw/sandal
	name = "sandals"
	icon_state = "wizard" // FALTA ICON


//////////////////////
/////////KIDS/////////
//////////////////////

/obj/item/clothing/shoes/lw/child/shoes
	name = "black children's shoes"
	icon_state = "yblack"
	species_restricted = list("Child")

/obj/item/clothing/shoes/lw/child/miner
	name = "children's work shoes"
	icon_state = "yminer"
	species_restricted = list("Child")

/obj/item/clothing/shoes/lw/child/squire
	name = "squire's shoes"
	icon_state = "squire"
	species_restricted = list("Child")
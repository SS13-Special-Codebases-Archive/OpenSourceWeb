/obj/item/clothing/gloves/captain
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	name = "captain's gloves"
	icon_state = "captain"
	item_state = "egloves"
	item_color = "captain"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1.0

/obj/item/clothing/gloves/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "\improper SWAT Gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0.6
	permeability_coefficient = 0.05

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/combat //Combined effect of SWAT gloves and insulated gloves
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "combat gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	armor_type = ARMOR_METAL
	body_parts_covered = HANDS

/obj/item/clothing/gloves/combat/soulbreaker //Combined effect of SWAT gloves and insulated gloves
	desc = "Gloves worn by the followers of Allah"
	name = "soulbreaker gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	body_parts_covered = HANDS
	min_cold_protection_temperature = 1500
	heat_protection = HANDS
	max_heat_protection_temperature = 1500
	armor = list(melee = 40, bullet = 40, laser = 10, energy = 5, bomb = 25, bio = 0, rad = 0)
	item_worth = 100

/obj/item/clothing/gloves/combat/gauntlet/steel
	desc = "Sturdy gauntlets made of steel."
	name = "steel gauntlets"
	icon_state = "steel"
	item_state = "steel"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	body_parts_covered = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 30, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)
	weight = 5
	blocks_firing = TRUE

/obj/item/clothing/gloves/combat/gauntlet/hunter
	desc = ""
	name = "hunter gloves"
	icon_state = "huntergloves"
	item_state = "huntergloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	body_parts_covered = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 30, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)
	weight = 5

/obj/item/clothing/gloves/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 0.30
	permeability_coefficient = 0.01
	item_color="white"

	cmo
		item_color = "medical"		//Exists for washing machines. Is not different from latex gloves in any way.

/obj/item/clothing/gloves/botanic_leather
	desc = "Thick leather gloves."
	name = "leather gloves"
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.9
	siemens_coefficient = 0.9
	armor_type = ARMOR_LEATHER
	armor = list(melee = 12, bullet = 5, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/gloves/fingerless
	desc = "These gloves have the fingers cut off!"
	name = "fingerless gloves"
	icon_state = "fingerless"
	item_state = "fingerless"
	item_color = null	//So they don't wash.
	permeability_coefficient = 0.9
	siemens_coefficient = 0.9
	flags = FPRINT

/obj/item/clothing/gloves/evening
	desc = ""
	name = "evening gloves"
	icon_state = "evening"
	item_state = "evening"
	item_color = null	//So they don't wash.
	permeability_coefficient = 0.9
	siemens_coefficient = 0.9
	flags = FPRINT

/obj/item/clothing/gloves/meister
	desc = ""
	name = "master gloves"
	icon_state = "meister"
	item_state = "meister"
	item_color = null	//So they don't wash.
	permeability_coefficient = 0.9
	siemens_coefficient = 0.9
	flags = FPRINT


/obj/item/clothing/gloves/veteran_bum
	desc = "Dirty and tattered"
	name = "dirty fingerless gloves"
	icon_state = "veteran_bum"
	item_state = "veteran_bum"
	item_color = null	//So they don't wash.
	permeability_coefficient = 0.9
	siemens_coefficient = 0.9
	flags = FPRINT
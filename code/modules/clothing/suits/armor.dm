
/obj/item/clothing/suit/armor
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	flags = FPRINT | TABLEPASS
	armor = list(melee = 35, bullet = 20, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6
	var/footstep
	item_worth = 20
	weight = 50
	can_improv = TRUE

/obj/item/clothing/suit/storage/thanati
	var/hood_state
	var/hooded = FALSE

/obj/item/clothing/suit/storage/thanati/RightClick(mob/living/carbon/human/user as mob)
    if(hood_state)
        if(hooded)
            icon_state = initial(icon_state)
            hooded = FALSE
        else
            icon_state = hood_state
            hooded = TRUE
        user.update_inv_wear_suit(1)
        user.update_icons(1)
        user.update_hair(1)

/obj/item/clothing/suit/armor/vest
	name = "armor"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	armor_type = ARMOR_METAL
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/proc/handle_movement(var/turf/walking, var/state)
	if(footstep >= 1)
		footstep = 0
		if(state == "run")
			if(istype(src, /obj/item/clothing/suit/armor/vest/security/hauberk))
				playsound(src, pick('sound/effects/footsteps/body-hauberk-1.ogg','sound/effects/footsteps/body-hauberk-2.ogg','sound/effects/footsteps/body-hauberk-3.ogg','sound/effects/footsteps/body-hauberk-4.ogg', 'sound/effects/footsteps/body-hauberk-5.ogg'), 30, 1)
			else if(istype(src, /obj/item/clothing/suit/armor/vest/comissar) || istype(src, /obj/item/clothing/suit/armor/vest/security/chariot) || istype(src, /obj/item/clothing/suit/armor/vest/security/incarn) || istype(src, /obj/item/clothing/suit/armor/vest/security/leper))
				playsound(src, pick('sound/effects/footsteps/body-lobe-1.ogg','sound/effects/footsteps/body-lobe-2.ogg','sound/effects/footsteps/body-lobe-3.ogg','sound/effects/footsteps/body-lobe-4.ogg', 'sound/effects/footsteps/body-lobe-5.ogg'), 50, 1)
			else
				playsound(src, pick('sound/effects/footsteps/body-armor-1.ogg','sound/effects/footsteps/body-armor-2.ogg','sound/effects/footsteps/body-armor-3.ogg','sound/effects/footsteps/body-armor-4.ogg', 'sound/effects/footsteps/body-armor-5.ogg', 'sound/effects/footsteps/body-armor-6.ogg'), 30, 1)

		else
			if(istype(src, /obj/item/clothing/suit/armor/vest/security/hauberk))
				playsound(src, pick('sound/effects/footsteps/body-hauberk-b4.ogg','sound/effects/footsteps/body-hauberk-b5.ogg'), 20, 1)
			else if(istype(src, /obj/item/clothing/suit/armor/vest/comissar) || istype(src, /obj/item/clothing/suit/armor/vest/security/chariot) || istype(src, /obj/item/clothing/suit/armor/vest/security/incarn) || istype(src, /obj/item/clothing/suit/armor/vest/security/leper))
				playsound(src, pick('sound/effects/footsteps/body-lobe-1.ogg','sound/effects/footsteps/body-lobe-2.ogg','sound/effects/footsteps/body-lobe-3.ogg','sound/effects/footsteps/body-lobe-4.ogg', 'sound/effects/footsteps/body-lobe-5.ogg'), 15, 1)
			else
				playsound(src, pick('sound/effects/footsteps/body-armor-b4.ogg','sound/effects/footsteps/body-armor-b5.ogg'), 20, 1)

	else
		footstep++

/obj/item/clothing/suit/armor/vest/iron_breastplate
	name = "iron breastplate"
	icon_state = "ironbplate"
	slowdown = 0
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|GROIN
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	armor_type = ARMOR_METAL
	item_worth = 27
	weight = 35

/obj/item/clothing/suit/armor/vest/gold_breastplate
	name = "gold breastplate"
	icon_state = "golden_breastplate"
	slowdown = 0
	armor = list(melee = 25, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|GROIN
	item_worth = 63
	fatmaywear = 1
	armor_type = ARMOR_METAL
	weight = 28
	can_be_smelted_to = /obj/item/weapon/ore/refined/lw/goldlw

/obj/item/clothing/suit/armor/vest/iron_cuirass
	name = "iron cuirass"
	icon_state = "ironcuirass"
	slowdown = 0
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|GROIN
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	item_worth = 27
	armor_type = ARMOR_METAL
	weight = 35
	can_be_smelted_to = /obj/item/weapon/ore/refined/lw/ironlw

/obj/item/clothing/suit/armor/vest/leja
	name = "leja"
	desc = ""
	icon_state = "leja"
	slowdown = 0
	armor = list(melee = 20, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|GROIN
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	item_worth = 30
	armor_type = ARMOR_LEATHER
	weight = 2

/obj/item/clothing/suit/armor/vest/iron_plate
	name = "iron plate armor"
	icon_state = "ironplate"
	slowdown = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0)
	item_worth = 27
	armor_type = ARMOR_METAL
	weight = 55
	can_be_smelted_to = /obj/item/weapon/ore/refined/lw/ironlw


/obj/item/clothing/suit/armor/vest/iron_plate/countess
	name = "countess armor"
	desc = ""
	icon_state = "countess"
	slowdown = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 30, bullet = 0, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0)
	item_worth = 63
	armor_type = ARMOR_LEATHER
	weight = 30

/obj/item/clothing/suit/armor/vest/aplate
	name = "adamantium plate armor"
	icon_state = "aplate"
	slowdown = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 70, bullet = 80, laser = 20, energy = 0, bomb = 40, bio = 0, rad = 0)
	item_worth = 249
	armor_type = ARMOR_METAL
	weight = 1
	can_be_smelted_to = /obj/item/weapon/ore/refined/lw/adamantinelw

/obj/item/clothing/suit/armor/vest/iron_plate/crusader
	name = "crusader armor"
	desc = "Plate armor worn by Crusaders"
	icon_state = "knight"
	slowdown = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS|HANDS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS|THROAT|HANDS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS|THROAT|HANDS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 50, bullet = 0, laser = 0, energy = 0, bomb = 20, bio = 0, rad = 0)
	item_worth = 63
	armor_type = ARMOR_METAL
	weight = 55

/obj/item/clothing/suit/armor/vest/iron_plate/vandenberg
	name = "chevalier armor"
	desc = ""
	icon_state = "zealot"
	slowdown = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS|THROAT|HANDS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS|THROAT|HANDS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 50, bullet = 0, laser = 0, energy = 0, bomb = 20, bio = 0, rad = 0)
	item_worth = 63
	armor_type = ARMOR_METAL
	weight = 55

/obj/item/clothing/suit/storage/vest/sheriff
	name = "sheriff jacket"
	desc = "An armored vest that protects against some damage."
	icon_state = "sheriff"
	item_state = "sheriff"
	blood_overlay_type = "armor"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 10, bomb = 5, bio = 0, rad = 0)
	item_worth = 15
	armor_type = ARMOR_LEATHER
	weight = 2

/obj/item/clothing/suit/storage/vest/ravcoat
	name = "sheriff jacket"
	desc = "An armored vest that protects against some damage."
	icon_state = "ravcoat"
	item_state = "ravcoat"
	blood_overlay_type = "armor"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 10, bomb = 5, bio = 0, rad = 0)
	item_worth = 15
	weight = 2
	armor_type = ARMOR_LEATHER

/obj/item/clothing/suit/storage/vest/flakjacket
	name = "flak jacket"
	desc = "A jacket that excels in protecting the wearer against high-velocity solid projectiles."
	icon_state = "flakjacket"
	item_state = "opvest"
	blood_overlay_type = "armor"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	armor = list(melee = 10, bullet = 50, laser = 0, energy = 10, bomb = 50, bio = 0, rad = 0)
	weight = 5
	item_worth = 15
	storage_slots = 2
	armor_type = ARMOR_LEATHER

/obj/item/clothing/suit/storage/vest/flakjacket/old
	name = "old flak jacket"
	icon_state = "oldflakjacket"
	armor = list(melee = 4, bullet = 25, laser = 0, energy = 5, bomb = 35, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/flakjacket/old/coat
	name = "coat flak jacket"
	icon_state = "coatjacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/armor/vest/security
	name = "tiamat armor"
	desc = "An armored coat of armor worn by members of the Tiamathi Guard."
	icon_state = "secarmor"
	item_state = "cerbarmor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 31
	weight = 45
	armor_type = ARMOR_METAL
	var/name_tag = TRUE
/obj/item/clothing/suit/armor/vest/security/New()
	..()
	if(!name_tag)
		return
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		name = "[name] ([H.real_name])"
/obj/item/clothing/suit/armor/vest/security/villain
	icon_state = "secarmor_villain"
	item_state = "cerbarmor"

/obj/item/clothing/suit/armor/vest/security/comrade
	icon_state = "secarmor_comrade"
	item_state = "cerbarmor"

/obj/item/clothing/suit/armor/vest/security/pigplus
	icon_state = "tiamatarmor"
	item_state = "cerbarmor"
/*ARMADURAS ESPECIAIS*/
/obj/item/clothing/suit/armor/vest/security/trustworthy
	name = "trustworthy cerberus armor"
	icon_state = "TrustworthyCerberus"
	item_state = "cerbarmor"

/obj/item/clothing/suit/armor/vest/security/catcerb
	name = "trustworthy cerberus armor"
	icon_state = "catcerb"
	item_state = "cerbarmor"


/obj/item/clothing/suit/armor/vest/security/squireadult
	name = "larger squire armor"
	icon_state = "squire_a"
	item_state = "squire_a"
	weight = 20
	name_tag = FALSE
/obj/item/clothing/suit/armor/vest/security/cerberusold
	name = "cerberus armor"
	icon_state = "cerberusold"
	item_state = "cerbarmor"

/obj/item/clothing/suit/armor/vest/security/cerberusfake
	name = "cerberus armor"
	icon_state = "cerberusold"
	item_state = "cerbarmor"
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 10, bomb = 0, bio = 0, rad = 0)
	armor_type = ARMOR_LEATHER
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/francisco
	name = "francisco's armor"
	icon_state = "francisco"
	item_state = "cerbarmor"

/obj/item/clothing/suit/storage/thanati/thanatiblack
	name = "black thanati robes"
	desc = "Stylish."
	icon_state = "thanatiblack"
	item_state = "thanatiblack"
	hood_state = "thanatiblack_hood"
	storage_slots = 1
	flags = FPRINT | TABLEPASS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|GROIN
	allowed = list(/obj/item/clothing/mask/silvermask)
	armor = list(melee = 40, bullet = 35, laser = 0, energy = 10, bomb = 40, bio = 0, rad = 0)
	armor_type = ARMOR_LEATHER
	weight = 5

/obj/item/clothing/suit/storage/thanati/thanatiblack/maskincluded
	New()
		..()
		new /obj/item/clothing/mask/silvermask(src)

/obj/item/clothing/suit/storage/thanati/thanati
	name = "thanati robes"
	desc = ""
	icon_state = "thanati"
	item_state = "thanati"
	hood_state = "thanati_hood"
	storage_slots = 1
	flags = FPRINT | TABLEPASS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|GROIN
	allowed = list(/obj/item/clothing/mask/silvermask)
	New()
		..()
		new /obj/item/clothing/mask/silvermask(src)

/obj/item/clothing/suit/storage/thanati/thanatilateparty
	name = "thanati robes"
	desc = ""
	icon_state = "thanati"
	item_state = "thanati"
	hood_state = "thanati_hood"
	storage_slots = 1
	flags = FPRINT | TABLEPASS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|GROIN
	allowed = list(/obj/item/clothing/mask/silvermask)

/*FIM*/


/obj/item/clothing/suit/armor/vest/security/fake
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 10, bomb = 0, bio = 0, rad = 0)
	armor_type = ARMOR_LEATHER
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/bodyguard
	name = "bodyguard armor"
	icon_state = "bodyguard"
	item_state = "armor"
	item_worth = 31
	weight = 40
	armor_type = ARMOR_METAL
	fatmaywear = 1
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/leper
	name = "Ludruk guard armor"
	icon_state = "leper"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	armor = list(melee = 35, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 31
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor_type = ARMOR_LEATHER
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/censor
	name = "Marduk armor"
	desc = "Plate armor with a tabard representing Firethorn's colors."
	icon_state = "censor"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 60
	weight = 50
	armor_type = ARMOR_METAL
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/marduk
	name = "sophisticated armor"
	desc = "Plate armor with a tabard representing Firethorn's colors"
	icon_state = "marduk"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 60
	weight = 50
	armor_type = ARMOR_METAL
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/censor
	name = "sophisticated armor"
	desc = "Plate armor with a tabard representing Firethorn's colors"
	icon_state = "censor"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 60
	weight = 50
	armor_type = ARMOR_METAL
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/marduk_alt
	name = "sophisticated armor"
	desc = "Plate armor with a tabard representing Firethorn's colors"
	icon_state = "marduk_alt"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 60
	weight = 50
	armor_type = ARMOR_METAL
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/marduk_alt2
	name = "sophisticated armor"
	desc = "Plate armor with a tabard representing Firethorn's colors"
	icon_state = "marduk_alt2"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 60
	weight = 50
	armor_type = ARMOR_METAL
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/soulbreaker
	name = "soulbreaker armor"
	desc = "Armor worn by the followers of Allah"
	icon_state = "soulbreaker"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS|HANDS|THROAT
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 60, bullet = 80, laser = 20, energy = 10, bomb = 50, bio = 0, rad = 0)
	item_worth = 100
	weight = 60
	armor_type = ARMOR_METAL
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/lord
	name = "lord armor"
	desc = "A lordly coat of armor"
	icon_state = "bfather"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = 1500
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	max_heat_protection_temperature = 1500
	armor = list(melee = 30, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 60
	armor_type = ARMOR_CHAINMAIL
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/lord_hand
	name = "lord hand armor"
	desc = "A lordly coat of armor"
	icon_state = "lordhand"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 30, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 60
	armor_type = ARMOR_CHAINMAIL
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/hauberk
	name = "chainmail armor"
	desc = "A hauberk made of metal rings. It provides decent protection for it's weight."
	icon_state = "hauberk"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 30, bullet = 0, laser = 0, energy = 10, bomb = 5, bio = 0, rad = 0)
	item_worth = 31
	armor_type = ARMOR_CHAINMAIL
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/incarn
	name = "incarn robes"
	icon_state = "incarn"
	armor = list(melee = 20, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	armor_type = ARMOR_LEATHER
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/security/chariot
	name = "chariot robes"
	icon_state = "chariot"
	armor = list(melee = 20, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	armor_type = ARMOR_LEATHER
	name_tag = FALSE

/obj/item/clothing/suit/armor/vest/warden
	name = "Warden's jacket"
	desc = "An armoured jacket with silver rank pips and livery."
	icon_state = "warden_jacket"
	item_state = "armor"

/obj/item/clothing/suit/armor/vest/inquisition
	name = "Churchkeeper's coat"
	desc = "An leather coat wore by churchkeepers."
	icon_state = "chaplain_hoodie"
	item_state = "armor"
	armor = list(melee = 15, bullet = 0, laser = 0, energy = 10, bomb = 15, bio = 0, rad = 0)
	armor_type = ARMOR_LEATHER

/obj/item/clothing/suit/armor/vest/comissar
	name = "secret notorious's garment"
	desc = "A garment coat wore by church agents."
	icon_state = "comissar"
	item_state = "comissar"
	armor = list(melee = 15, bullet = 0, laser = 0, energy = 10, bomb = 15, bio = 0, rad = 0)
	armor_type = ARMOR_LEATHER

/obj/item/clothing/suit/armor/vest/sunshine
	name = "solar spiral coat"
	desc = "A coat worn by the fanatics of the Solar Spiral."
	icon_state = "sunshine"
	item_state = "sunshine"
	armor = list(melee = 15, bullet = 0, laser = 0, energy = 10, bomb = 15, bio = 0, rad = 0)
	armor_type = ARMOR_LEATHER
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS

/obj/item/clothing/suit/armor/vest/general_inquisitor
	name = "inquisitor's garment"
	desc = "A garment wore by general inquisitors."
	icon_state = "churchcoat"
	item_state = "armor"
	armor = list(melee = 15, bullet = 0, laser = 0, energy = 10, bomb = 15, bio = 0, rad = 0)
	armor_type = ARMOR_LEATHER
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS

/obj/item/clothing/suit/armor/vest/general_inquisitor/alt1
	icon_state = "churchcoatALT"

/obj/item/clothing/suit/armor/vest/general_inquisitor/alt2
	icon_state = "churchcoatALT2"

/obj/item/clothing/suit/armor/vest/old_inquisitor
	name = "inquisitor's garment"
	desc = "A garment wore by general inquisitors."
	icon_state = "inquisitor"
	item_state = "armor"
	armor = list(melee = 15, bullet = 0, laser = 0, energy = 10, bomb = 15, bio = 0, rad = 0)
	armor_type = ARMOR_LEATHER
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|GROIN|LEGS
	armor_type = ARMOR_METAL

/obj/item/clothing/suit/armor/leather
	name = "Leather Armor"
	desc = "A handcrafted leather armor, usually wore by bandits and mercenaries."
	icon_state = "leather"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|GROIN
	slowdown = 0
	armor = list(melee = 20, bullet = 0, laser = 0, energy = 10, bomb = 0, bio = 0, rad = 0)
	item_worth = 26
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0.5
	weight = 30
	armor_type = ARMOR_LEATHER

/obj/item/clothing/suit/armor/leather/seaspotter
	name = "Seaspotter Armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|GROIN
	icon_state = "bmerc"
	armor = list(melee = 20, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 31
	weight = 40

/obj/item/clothing/suit/armor/leather/reddawn
	name = "Red Dawn Armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|GROIN|THROAT
	icon_state = "rmerc"
	armor = list(melee = 20, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 0)
	item_worth = 31
	weight = 40

/obj/item/clothing/suit/armor/riot
	name = "Riot Suit"
	desc = "A suit of armor with heavy padding to protect against melee attacks. Looks like it might impair movement."
	icon_state = "riot"
	item_state = "swat_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 1
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0.5
	armor_type = ARMOR_METAL


/obj/item/clothing/suit/armor/bulletproof
	name = "Bulletproof Vest"
	desc = "A vest that excels in protecting the wearer against high-velocity solid projectiles."
	icon_state = "bulletproof"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(melee = 10, bullet = 80, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/laserproof
	name = "Ablative Armor Vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor = list(melee = 10, bullet = 10, laser = 80, energy = 50, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/swat
	name = "swat suit"
	desc = "A heavily armored suit that protects against moderate damage. Used in special operations."
	icon_state = "deathsquad"
	item_state = "swat_suit"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags = FPRINT | TABLEPASS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = 1
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 0, rad = 0)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5


/obj/item/clothing/suit/armor/swat/officer
	name = "officer jacket"
	desc = "An armored jacket used in special operations."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	flags_inv = 0


/obj/item/clothing/suit/armor/det_suit
	name = "armor"
	desc = "An armored vest with a detective's badge on it."
	icon_state = "detective-armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)


//Reactive armor
//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive
	name = "Reactive Teleport Armor"
	desc = "Someone seperated our Research Director from his own head!"
	var/active = 0.0
	icon_state = "reactiveoff"
	item_state = "reactiveoff"
	blood_overlay_type = "armor"
	slowdown = 1
	flags = FPRINT | TABLEPASS
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/reactive/IsShield()
	if(active)
		return 1
	return 0

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		user << "\blue The reactive armor is now active."
		src.icon_state = "reactive"
		src.item_state = "reactive"
	else
		user << "\blue The react armor is now inactive."
		src.icon_state = "reactiveoff"
		src.item_state = "reactiveoff"
		src.add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	active = 0
	src.icon_state = "reactiveoff"
	src.item_state = "reactiveoff"
	..()


//All of the armor below is mostly unused


/obj/item/clothing/suit/armor/centcomm
	name = "Cent. Com. armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	w_class = 4//bulky item
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 3
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)
	armor = list(melee = 200, bullet = 200, laser = 200,energy = 200, bomb = 200, bio = 200, rad = 200)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/armor/tdome/red
	name = "Thunderdome suit (red)"
	desc = "Reddish armor."
	icon_state = "tdred"
	item_state = "tdred"
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/tdome/green
	name = "Thunderdome suit (green)"
	desc = "Pukish armor."
	icon_state = "tdgreen"
	item_state = "tdgreen"
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/tactical
	name = "tactical armor"
	desc = "A suit of armor most often used by Special Weapons and Tactics squads. Includes padded vest with pockets along with shoulder and kneeguards."
	icon_state = "swatarmor"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	slowdown = 1
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 20, bio = 0, rad = 0)
	siemens_coefficient = 0.7

//New Vests
/obj/item/clothing/suit/storage/vest
	name = "armor vest"
	desc = "A simple kevlar plate carrier."
	icon_state = "kvest"
	item_state = "kvest"
	armor = list(melee = 50, bullet = 20, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	allowed = list(/obj/item/weapon/gun,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs)
	var/icon_badge
	var/icon_nobadge
	verb/toggle()
		set name ="Adjust Badge"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(icon_state == icon_badge)
			icon_state = icon_nobadge
			usr << "You unclip the badge from the vest."
		else if(icon_state == icon_nobadge)
			icon_state = icon_badge
			usr << "You clip the badge to the vest."
		else
			usr << "You can't find a badge for [src]."
			return
		update_icon()

/obj/item/clothing/suit/storage/vest/officer
	name = "officer armor vest"
	desc = "A simple kevlar plate carrier belonging to Nanotrasen. This one has a security holobadge clipped to the chest."
	icon_state = "officervest_nobadge"
	item_state = "officervest_nobadge"
	icon_badge = "officervest_badge"
	icon_nobadge = "officervest_nobadge"

/obj/item/clothing/suit/storage/vest/warden
	name = "warden armor vest"
	desc = "A simple kevlar plate carrier belonging to Nanotrasen. This one has a silver badge clipped to the chest."
	icon_state = "wardenvest_nobadge"
	item_state = "wardenvest_nobadge"
	icon_badge = "wardenvest_badge"
	icon_nobadge = "wardenvest_nobadge"
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/hos
	name = "commander armor vest"
	desc = "A simple kevlar plate carrier belonging to Nanotrasen. This one has a gold badge clipped to the chest."
	icon_state = "hosvest_nobadge"
	item_state = "hosvest_nobadge"
	icon_badge = "hosvest_badge"
	icon_nobadge = "hosvest_nobadge"
	armor = list(melee = 60, bullet = 45, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/pcrc
	name = "PCRC armor vest"
	desc = "A simple kevlar plate carrier belonging to Proxima Centauri Risk Control. This one has a PCRC crest clipped to the chest."
	icon_state = "pcrcvest_nobadge"
	item_state = "pcrcvest_nobadge"
	icon_badge = "pcrcvest_badge"
	icon_nobadge = "pcrcvest_nobadge"

/obj/item/clothing/suit/storage/vest/detective
	name = "detective armor vest"
	desc = "A simple kevlar plate carrier in a vintage brown, it has a badge clipped to the chest that reads, 'Private investigator'."
	icon_state = "detectivevest_nobadge"
	item_state = "detectivevest_nobadge"
	icon_badge = "detectivevest_badge"
	icon_nobadge = "detectivevest_nobadge"
	armor = list(melee = 50, bullet = 20, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/heavy
	name = "heavy armor vest"
	desc = "A heavy kevlar plate carrier with webbing attached."
	icon_state = "webvest"
	item_state = "webvest"
	armor = list(melee = 50, bullet = 40, laser = 50, energy = 25, bomb = 30, bio = 0, rad = 0)
	slowdown = 1
	storage_slots = 4

/obj/item/clothing/suit/storage/vest/heavy/officer
	name = "officer heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Nanotrasen with webbing attached. This one has a security holobadge clipped to the chest."
	icon_state = "officerwebvest_nobadge"
	item_state = "officerwebvest_nobadge"
	icon_badge = "officerwebvest_badge"
	icon_nobadge = "officerwebvest_nobadge"

/obj/item/clothing/suit/storage/vest/heavy/warden
	name = "warden heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Nanotrasen with webbing attached. This one has a silver badge clipped to the chest."
	icon_state = "wardenwebvest_nobadge"
	item_state = "wardenwebvest_nobadge"
	icon_badge = "wardenwebvest_badge"
	icon_nobadge = "wardenwebvest_nobadge"

/obj/item/clothing/suit/storage/vest/heavy/hos
	name = "commander heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Nanotrasen with webbing attached. This one has a gold badge clipped to the chest."
	icon_state = "hoswebvest_nobadge"
	item_state = "hoswebvest_nobadge"
	icon_badge = "hoswebvest_badge"
	icon_nobadge = "hoswebvest_nobadge"

/obj/item/clothing/suit/storage/vest/heavy/pcrc
	name = "PCRC heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Proxima Centauri Risk Control with webbing attached. This one has a PCRC crest clipped to the chest."
	icon_state = "pcrcwebvest_nobadge"
	item_state = "pcrcwebvest_nobadge"
	icon_badge = "pcrcwebvest_badge"
	icon_nobadge = "pcrcwebvest_nobadge"

/obj/item/clothing/suit/storage/vest/heavy/merc
	name = "heavy armor vest"
	desc = "A high-quality heavy kevlar plate carrier in a fetching tan. The vest is surprisingly flexible, and possibly made of an advanced material."
	icon_state = "mercwebvest"
	item_state = "mercwebvest"
	armor = list(melee = 65, bullet = 60, laser = 65, energy = 45, bomb = 50, bio = 0, rad = 0)
	slowdown = 0
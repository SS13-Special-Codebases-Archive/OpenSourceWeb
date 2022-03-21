/obj/item/clothing/wrist/bracer
	name = "bracer"
	desc = "Wearing it will make you look like a member of some wild brazilian tribe, so make sure to wear a gorget with it."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "brace_copper"
	item_state = "cbracer"
	item_worth = 30
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	body_parts_covered = ARM_RIGHT
	armor = list(melee = 15, bullet = 0,  bomb = 5)
	armor_type = ARMOR_METAL
	weight = 2
	wrist_use = TRUE

/obj/item/clothing/wrist/bracer/iron
	name = "iron bracer"
	icon_state = "brace_iron"
	item_state = "bracer"
	armor = list(melee = 20, bullet = 0,  bomb = 5)

/obj/item/clothing/wrist/bracer/gold
	name = "gold bracer"
	icon_state = "brace_gold"
	item_state = "gbracer"
	armor = list(melee = 20, bullet = 0,  bomb = 5)

/obj/item/clothing/wrist/bracer/proc/update_defense()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.wrist_r == src)
			body_parts_covered = ARM_RIGHT
		if(H.wrist_l == src)
			body_parts_covered = ARM_LEFT
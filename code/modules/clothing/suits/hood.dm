/obj/item/clothing/suit/hood
	var/hood_state
	var/hooded = FALSE

/obj/item/clothing/suit/hood/RightClick(mob/living/carbon/human/user as mob)
	if(hooded)
		icon_state = initial(icon_state)
		hooded = FALSE
	else
		icon_state = hood_state
		hooded = TRUE
	user.update_inv_wear_suit(1)
	user.update_icons(1)
	user.update_hair(1)

/obj/item/clothing/suit/hood/monk
	name = "Monk cloak"
	desc = "The cloak of devotion."
	icon_state = "monk"
	item_state = "monk"
	hood_state = "monk-hooded"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/hood/thief
	name = "Grave robber cloak"
	desc = "The cloak of silence."
	icon_state = "thief"
	item_state = "thief"
	hood_state = "thief-hooded"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/hood/donor/absenceofwords/blackcloak
	name = "Black cloak"
	desc = "The cloak of silence."
	icon_state = "donor_absenceofwords_blackcape"
	item_state = "donor_absenceofwords_blackcape"
	hood_state = "donor_absenceofwords_blackcapehood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/donor/sailorcloak
	name = "sailor cloak"
	desc = "The cloak of silence."
	icon_state = "sailorcoat"
	item_state = "sailorcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/sailorshirt
	name = "sailor shirt"
	desc = "A silk black shirt with a white tie and a matching gray vest and slacks. Feels proper."
	icon_state = "sailorshirt"
	item_state = "sailorshirt"
	item_color = "sailorshirt"

/obj/item/clothing/head/tricorn
	name = "tricorn"
	icon_state = "tricorn"
	item_color = "tricorn"
	flags = FPRINT | TABLEPASS
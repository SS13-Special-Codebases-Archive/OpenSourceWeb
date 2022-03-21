/obj/item/clothing/suit/storage/vest/goodhood
	var/hoodon = FALSE

/obj/item/clothing/suit/storage/vest/goodhood/morticiancloak
	name = "Mortician's Cloak"
	desc = "The cloak of death. Used by morticians to take bums to the web."
	icon_state = "mortus"
	item_state = "bumcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	weight = 5
	storage_slots = 2
	hoodon = 0

/obj/item/clothing/suit/storage/vest/goodhood/morticiancloak/attackhand_right(mob/living/carbon/human/H)
	spawn(0)
		if(hoodon)
			hoodon = 0
			H.remove_hood()
		else
			hoodon = 1
			H.add_hood()

/obj/item/clothing/suit/storage/vest/goodhood/morticiancloak/pickup(mob/user)
	hoodon = 0
/mob/living/carbon/human/proc/handle_drowning()
	if(istype(wear_mask, /obj/item/clothing/mask/breath) || istype(wear_mask, /obj/item/clothing/mask/gas))
		if(internal)
			return FALSE
	if(stat == DEAD)
		return FALSE
	if(isVampire)
		return FALSE
	if(holding_breath)
		return FALSE
	if(src.gender == "male")
		playsound(src.loc, 'sound/effects/drown.ogg', rand(35,50), 1)
	else
		playsound(src.loc, 'sound/effects/drown_female.ogg', rand(35,50), 1)
	visible_message("[src] drowns!")
	adjustOxyLoss(4)//If you are suiciding, you should die a little bit faster
	failed_last_breath = 1
	if(r_hand && istype(r_hand, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = r_hand
		F.lit = 0
		F.update_icon()
		F.set_light(0)
	if(l_hand && istype(r_hand, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = l_hand
		F.lit = 0
		F.update_icon()
		F.set_light(0)
	if(wear_mask && istype(wear_mask, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/C = wear_mask
		C.die()

	var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
	animation.pixel_y = 16
	animation.icon_state = "blank"
	animation.icon = 'reagents.dmi'
	animation.master = src
	flick(animation, "bubbles")
	spawn(25)
		qdel(animation)

	if(src?:loc?:liquid?:reagents?.total_volume)
		if(!(wear_mask && wear_mask.flags & MASKCOVERSMOUTH))
			src:loc:liquid:reagents?.reaction(src, INGEST)
			spawn(5)
				src:loc:liquid?:reagents?.trans_to(src, 5)
				src:loc:liquid?:depth -= 5


	return TRUE // Presumably chemical smoke can't be breathed while you're underwater.
/obj/item/medal
	name = "Firethorn Medal"
	desc = "A good looking medal."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "medala"
	item_state = "medala"
	w_class = 1
	item_worth = 50
	var/time_place = 3 SECONDS
	can_be_smelted_to = /obj/item/weapon/ore/refined/lw/goldlw

/obj/item/medal/attack(mob/living/carbon/human/H as mob, mob/living/carbon/human/user, var/target_zone)
	if(!target_zone)
		target_zone = user.zone_sel.selecting
	if(H == user)
		return
	if(istype(H) && user.a_intent == "help" && target_zone == "chest" && istype(H.w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/UN = H.w_uniform
		if(UN.medal_attached)
			to_chat(user, "<span class='combat'>[H.name]'s uniform already have a medal on it.</span>")
			return
		user.visible_message("<span class='passive'>[user.name] starts placing a medal on the [H.name]'s uniform.</span>")
		if(do_after(user, time_place) && UN == H.w_uniform)
			user.transfer_equiped_item_to(src, UN)
			UN.medal_attached = src
			UN.medal_overlay()
			H.update_inv_w_uniform()
			if(length(medal_nominated) && (H in medal_nominated) && user == medal_nominated[H])
				medal_nominated.Remove(H)
				H?.client?.ChromieWinorLoose(H, 1)
			return
		else
			return
	..()

/obj/item/medal/bronze
	name = "Medal"
	icon_state = "medalb"
	item_state = "medalb"

/obj/item/medal/patreon
	name = "Trading House Medal"
	desc = "This medal was given to merchant houses that helps God-King with their money."
	icon_state = "medal_hamjara"
	item_state = "medal_hamjara"
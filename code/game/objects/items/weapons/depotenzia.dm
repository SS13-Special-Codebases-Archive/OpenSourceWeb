var/list/depotenzia_types = list(
	/obj/item/weapon/wirecutters,
	/obj/item/weapon/kitchen/utensil/knife/flaying,
	/obj/item/weapon/surgery_tool/circular_saw)

/obj/item/proc/depotenzia_check()
	for (var/_type in depotenzia_types)
		if (istype(src, _type))
			return TRUE
	return FALSE

/obj/item/proc/depotenzia(mob/living/carbon/C as mob, mob/living/user as mob)
	if (depotenzia_check())
		if (ishuman(C) && ishuman(user))
			if (user.zone_sel.selecting == "groin")
				remove_penis(C, user)
				return TRUE
	return FALSE

/obj/item/proc/remove_penis(var/mob/living/carbon/human/H, var/mob/living/carbon/human/user)
	var/haspenis = ((H.has_penis() && H.potenzia > -1 && H.species.genitals && !H.mutilated_genitals))
	if(H.is_nude())//Gotta be naked.
		if(haspenis)//And have a dick.
			H.visible_message("<span class='danger'>[user] tries to cut off [H]'s penis with [src]!</span>",
								"<span class='danger'>[user] tries to cut off your penis with [src]!</span>")
			if(do_after(user, 50))
				H.visible_message("<span class='danger'>[user] cuts off [H]'s penis with [src]!</span>",
								"<span class='danger'>[user] cuts off your penis with [src]!</span>")
				H.custom_pain("[pick("OH [uppertext(H.god_text())] MY DICK!", "OH [uppertext(H.god_text())] WHY!", "OH [uppertext(H.god_text())] IT HURTS!")]", 100)//Pain.
				H.apply_damage(rand(30,45), BRUTE, BP_GROIN)
				playsound(H, 'sound/effects/gore/severed.ogg', 50, 1, -1)
				var/obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis/P = new /obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis(H.loc)
				P.set_potenzia(H.potenzia)
				H.mutilate_genitals()
				H.client.ChromieWinorLoose(H.client, -1)
			else
				to_chat(user, "<span class='notice'>You fail to cut off their penis...</span>")
				return
		else
			to_chat(user, "<span class='passive'>They have no penis!</span>")
	else
		to_chat(user, "They must be naked to perform the act.")
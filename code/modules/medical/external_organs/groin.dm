/datum/organ/external/groin
	name = "groin"
	icon_name = "groin"
	display_name = "groin"
	display_namebr = "virilha"
	max_damage = 90
	min_broken_damage = 65
	body_part = GROIN
	vital = 1
	iconsdamage = "chest"
	mask_color = "#ac151a"

//pinto penis
/datum/organ/external/groin/droplimb(var/override = 0,var/no_explode = 0, var/gibbed = 0)
	if(owner.has_penis())//Instead of bisecting them entirely just fucking drop their dick off.
		var/potenzia = owner.potenzia
		owner.visible_message("<span class='danger'><big>\The [owner]'s penis flies off in a bloody arc!</big></span>")
		playsound(owner, 'sound/effects/gore/severed.ogg', 50, 1, -1)
		if(gibbed || potenzia > 30)
			owner.mutilate_genitals()
		else
			var/obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis/P = new /obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis(owner.loc)
			P.set_potenzia(potenzia)
			owner.mutilate_genitals()
	..()


//There has to be a better way to define this shit. ~ Z
//can't equip anything
/mob/living/carbon/alien/attack_ui(slot_id)
	return

/mob/living/carbon/alien/meteorhit(O as obj)
	for(var/mob/M in viewers(src, null))
		if ((M.client && !( M.blinded )))
			M.show_message(text("\red [] has been hit by []", src, O), 1)
	if (health > 0)
		adjustBruteLoss(25)
		adjustFireLoss(30)
		updatehealth()
	return

/mob/living/carbon/alien/attack_animal(mob/living/M as mob)
	return

/mob/living/carbon/alien/attack_paw(mob/living/carbon/monkey/M as mob)
	return

/mob/living/carbon/alien/attack_hand(mob/living/carbon/human/M as mob)
	return
/mob/living/carbon/human/proc/can_hit(mob/living/carbon/human/M as mob)
	var/datum/unarmed_attack/attack = M.species.unarmed
	if(M.consyte)	return M.vomit()
	if(M.lifeweb_locked) return
	if(lifeweb_locked) return
	if(!attack.is_usable(M)) return
	return TRUE

/mob/living/carbon/human/proc/is_it_high(mob/living/carbon/human/M as mob)
	var/datum/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))
	if(M.lying && !src.lying)
		switch(affecting.display_name)
			if("mouth")
				return TRUE
			if("face")
				return TRUE
			if("head")
				return TRUE
			if("eyes")
				return TRUE
			if("throat")
				return TRUE
			if("right arm")
				return TRUE
			if("left arm")
				return TRUE
	return FALSE
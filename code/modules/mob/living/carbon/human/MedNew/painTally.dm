/mob/living/carbon/human/proc/painTally()
	var/tally = 0

	var/datum/organ/external/foot/r_foot = get_organ("r_foot")
	var/datum/organ/external/foot/l_foot = get_organ("l_foot")
	var/datum/organ/external/r_leg = get_organ("r_leg")
	var/datum/organ/external/l_leg = get_organ("l_leg")
	var/tallytogo = r_foot.painLW + l_foot.painLW + l_leg.painLW + r_leg.painLW

	tally += tallytogo/(5.5*src.my_stats.ht) //it it has 55 of pain tally += 1, if it has 110 of pain tally += 2 and it goes

	var/tally2 = Clamp(get_pain()/(10.5*src.my_stats.ht), 0, 4)
	if(tally2 >= 1)
		tally += tally2

	return tally
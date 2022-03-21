/mob/living/carbon/human/proc/pain_handler(){

	if(status_flags & STATUS_NO_PAIN)
		return
	if(species?.flags & NO_PAIN)
		return
	if(src.stat != CONSCIOUS)
		return

	var/pain = get_pain() //only do it once, lags less

	var/moan = Clamp(pain/(10.5*src.my_stats.ht), 0, 4)
	if(moan >= 1)
		if(prob(5))
			emote("agonymoan",1,null,0)
	if(moan == 3)
		if(prob(13))
			if(!lying)
				mob_rest()
			else
				Stun(2)
			emote("agonymoan",1,null,0)

	if(pain > 65+src.my_stats.ht*48){
		visible_message("<span class='hitbold'>[src]</span> <span class='hit'>gives in to pain!</span>", 1)
		emote("agonypain",1,null,0)
		Stun(5)
		adjustOxyLoss(6)
		flash_pain()
	}

	if(pain >= 120+src.my_stats.ht*50){
		var/datum/organ/internal/heart/HE = src.internal_organs_by_name["heart"]
		flash_pain()
		if(HE)
			HE.heart_attack()
	}

}
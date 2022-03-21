/mob/living/carbon/human/proc/create_kg()
	var/mob/living/carbon/human/H = src
	var/new_kg
	if(isChild(src))
		new_kg = round(8 + (H.my_stats.st + H.my_stats.ht)) * 2
		src.maxweight = new_kg
	else
		if(check_perk(/datum/perk/ref/strongback))
			new_kg = round(10 + (H.my_stats.st + H.my_stats.ht)) * 6
			src.maxweight = new_kg
		else
			new_kg	= round(16 + (H.my_stats.st + H.my_stats.ht)) * 2
			src.maxweight = new_kg

/mob/living/carbon/human/proc/check_kg()
	var/new_kg
	var/mob/living/carbon/human/H = src
	if(isChild(src))
		new_kg = round(8 + (H.my_stats.st + H.my_stats.ht)) * 2
		src.maxweight = new_kg
	else
		if(check_perk(/datum/perk/ref/strongback))
			new_kg = round(10 + (H.my_stats.st + H.my_stats.ht)) * 4
			src.maxweight = new_kg
		else
			new_kg	= round(16 + (H.my_stats.st + H.my_stats.ht)) * 2
			src.maxweight = new_kg

	var/half = maxweight*0.5
	var/medium = maxweight*0.75
	var/full = maxweight
	var/finalweight
	for(var/obj/item/O in src.contents)
		if(O.weight)
			finalweight += O.weight
	src.carryingweight = finalweight
	if(carryingweight)
		if(carryingweight < half)
			weight_state = WEIGHT_NONE
			return
		else
			if(carryingweight >= half && carryingweight < full)
				weight_state = WEIGHT_LIGHT
			if(carryingweight >= medium && carryingweight < full)
				weight_state = WEIGHT_MEDIUM
			if(carryingweight == full || carryingweight >= full)
				weight_state = WEIGHT_HEAVY

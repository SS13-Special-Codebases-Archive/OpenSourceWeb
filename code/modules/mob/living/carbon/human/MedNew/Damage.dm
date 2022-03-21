/mob/living/carbon/var
	morte_tempo = 0
	choque = 0

/mob/living/carbon/proc/updateshock()
	if(status_flags & STATUS_NO_PAIN)
		src.choque = 0
		return src.choque
	if(species?.flags & NO_PAIN)
		src.choque = 0
		return src.choque
	src.choque = 			\
	1	* src.getOxyLoss() + 		\
	0.7	* src.getToxLoss() + 		\
	1.5	* src.getFireLoss() + 		\
	1.2	* src.getBruteLoss() + 		\
	1.7	* src.getCloneLoss() + 		\
	2	* src.halloss

	if(reagents.has_reagent("mannitol"))
		src.choque -= 10
	if(reagents.has_reagent("epinephrine"))
		src.choque -= 25
	if(reagents.has_reagent("synaptizine"))
		src.choque -= 40
	if(reagents.has_reagent("paracetamol"))
		src.choque -= 50
	if(reagents.has_reagent("tramadol"))
		src.choque -= 80
	if(reagents.has_reagent("oxycodone"))
		src.choque -= 200
	if(reagents.has_reagent("dentrine"))
		src.choque -= 160
	if(src.slurring)
		src.choque -= 20
	if(src.analgesic)
		src.choque = 0

	// broken or ripped off organs will add quite a bit of pain
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = src
		for(var/datum/organ/external/organ in M.organs)
			if (!organ)
				continue
			if((organ.status & ORGAN_DESTROYED) && !organ.amputated)
				src.choque += 60
			else if(organ.status & ORGAN_BROKEN || organ.open)
				src.choque += 30
				if(organ.status & ORGAN_SPLINTED)
					src.choque -= 25

	if(src.choque < 0)
		src.choque = 0

	return src.choque

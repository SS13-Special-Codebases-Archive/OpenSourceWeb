/datum/event/organ_failure
	var/severity = 1

/datum/event/organ_failure/setup()
	announceWhen = rand(0, 300)
	endWhen = announceWhen + 1
	severity = rand(1, 3)

/datum/event/organ_failure/announce()
	command_alert("Confirmed outbreak of level [rand(3,7)] biohazard aboard [vessel_name()]. All personnel must contain the outbreak.", "Biohazard Alert")
	world << sound('sound/AI/outbreak5.ogg')

/datum/event/organ_failure/start()
	var/list/candidates = list()	//list of candidate keys
	for(var/mob/living/carbon/human/G in player_list)
		if(G.mind && G.mind.current && G.mind.current.stat != DEAD && G.health > 70)
			candidates += G
	if(!candidates.len)	return
	candidates = shuffle(candidates)//Incorporating Donkie's list shuffle

	while(severity > 0 && candidates.len)
		var/mob/living/carbon/human/C = candidates[1]

		// Bruise one of their organs
		var/O = pick(C.internal_organs)
		var/datum/organ/internal/I = C.internal_organs_by_name[O]
		if(I) // Organs can be removed surgically
			I.damage = I.min_bruised_damage - 1
			severity--
		candidates.Remove(C)
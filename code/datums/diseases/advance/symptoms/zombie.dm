/*
//////////////////////////////////////

Zombie

	Very Very Noticable.
	Decreases resistance.
	Decreases stage speed.
	Reduced Transmittable.
	Badmin level.

Bonus
	BRAAAINSSSSS!!!!

//////////////////////////////////////
*/

/datum/symptom/zombie

	name = "Tombstone Syndrome"
	stealth = -1
	resistance = -2
	stage_speed = -8
	transmittable = -3
	level = 101

/datum/symptom/zombie/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		if(A.stage == 5)
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(!iszombie(H))
					H.zombify()
		else
			M.toxloss++
	return


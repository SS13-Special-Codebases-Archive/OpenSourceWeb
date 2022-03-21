/datum/organ/internal/eyes/assisted
	min_bruised_damage = 15
	min_broken_damage = 35
	emplevel = list(20,7,3)
	desc = "Assisted"

/datum/organ/internal/eyes/mechassist()
	new /datum/organ/internal/eyes/assisted(owner)
	return

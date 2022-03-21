//cara que porra e essa
/datum/organ/internal/heart/assisted
	robotic = 1
	min_bruised_damage = 15
	min_broken_damage = 35
	emplevel = list(20,7,3)
	desc = "Assisted"

/datum/organ/internal/heart/mechassist()
	new /datum/organ/internal/heart/assisted(owner)
	return
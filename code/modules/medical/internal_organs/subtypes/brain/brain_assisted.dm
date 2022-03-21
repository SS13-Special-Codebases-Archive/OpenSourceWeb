//isso e tudo insanocode cara socorro
/datum/organ/internal/brain/assisted
	robotic = 1
	min_bruised_damage = 15
	min_broken_damage = 35
	emplevel = list(20,7,3)
	desc = "Assisted"

/datum/organ/internal/brain/mechassist()
	new /datum/organ/internal/brain/assisted(owner)
	return

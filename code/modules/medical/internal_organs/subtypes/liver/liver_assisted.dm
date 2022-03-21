//figado assistido
/datum/organ/internal/liver/assisted
	robotic = 1
	min_bruised_damage = 15
	min_broken_damage = 35
	emplevel = list(20,7,3)
	desc = "Assisted"

/datum/organ/internal/liver/mechassist()
	new /datum/organ/internal/liver/assisted(owner)
	return

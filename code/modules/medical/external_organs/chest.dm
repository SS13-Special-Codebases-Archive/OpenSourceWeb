/datum/organ/external/chest
	name = "chest"
	icon_name = "torso"
	display_name = "chest"
	display_namebr = "peito"
	max_damage = 75
	min_broken_damage = 100
	body_part = UPPER_TORSO
	vital = 1
	encased = "ribcage"
	iconsdamage = "chest"
	mask_color = "#000000"

/datum/organ/external/chest/droplimb(override, no_explode, gibbed)
	return
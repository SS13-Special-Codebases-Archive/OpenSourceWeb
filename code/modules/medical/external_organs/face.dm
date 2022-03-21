/datum/organ/external/face
	name = "face"
	icon_name = "face"
	display_name = "face"
	display_namebr = "rosto"
	max_damage = 100
	min_broken_damage = 60
	body_part = FACE
	var/disfigured = 0
	var/brained = 0
	vital = 0
	encased = "skull"
	iconsdamage = "head"
	head_icon_needed = 1
	mask_color = "#ffffff"

/datum/organ/external/face/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list(), armor, specialAttack)
	..(brute, burn, sharp, edge, used_weapon, forbidden_limbs, armor, specialAttack)
	if(specialAttack == "right eye")
		var/datum/organ/internal/right_eye/R = owner.internal_organs_by_name["right eye"]
		R.take_damage(brute)
	if(specialAttack == "left eye")
		var/datum/organ/internal/left_eye/R = owner.internal_organs_by_name["left eye"]
		R.take_damage(brute)
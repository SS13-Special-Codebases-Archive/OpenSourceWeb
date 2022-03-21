/datum/organ/external/hand/r_hand
	name = "r_hand"
	display_name = "right hand"
	display_namebr = "mão direita"
	icon_name = "r_hand"
	max_damage = 60
	canBeRemoved = 1
	min_broken_damage = 50
	delimb_min_damage = 55
	body_part = HAND_RIGHT
	iconsdamage = "r_hand"
	lfwblockedicon = 1
	artery_prob = 20
	tendon_prob = 20
	sprite_dependent_for_artery = 1
	has_tendons = 1
	has_finger = 1
	mask_color = "#a0b629"
	process()
		..()
		process_grasp(owner.r_hand, "right hand")



/datum/organ/external/hand/l_hand
	name = "l_hand"
	display_name = "left hand"
	display_namebr = "mão esquerda"
	icon_name = "l_hand"
	max_damage = 60
	canBeRemoved = 1
	min_broken_damage = 50
	delimb_min_damage = 55
	body_part = HAND_LEFT
	iconsdamage = "l_hand"
	lfwblockedicon = 1
	artery_prob = 20
	tendon_prob = 20
	sprite_dependent_for_artery = 1
	has_tendons = 1
	has_finger = 1
	mask_color = "#1187ce"
	process()
		..()
		process_grasp(owner.l_hand, "left hand")
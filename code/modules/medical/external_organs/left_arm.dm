/datum/organ/external/l_arm
	name = "l_arm"
	display_name = "left arm"
	display_namebr = "braço esquerdo"
	icon_name = "l_arm"
	max_damage = 90
	canBeRemoved = 1
	min_broken_damage = 69
	delimb_min_damage = 75
	body_part = ARM_LEFT
	iconsdamage = "l_arm"
	lfwblockedicon = 1
	artery_prob = 20
	tendon_prob = 20
	has_tendons = 1
	mask_color = "#ffe600"
	process()
		..()
		process_grasp(owner.l_hand, "left hand")
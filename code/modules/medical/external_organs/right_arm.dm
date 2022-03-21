/datum/organ/external/r_arm
	name = "r_arm"
	display_name = "right arm"
	display_namebr = "braço direito"
	icon_name = "r_arm"
	max_damage = 90
	canBeRemoved = 1
	min_broken_damage = 65
	delimb_min_damage = 70
	body_part = ARM_RIGHT
	iconsdamage = "r_arm"
	lfwblockedicon = 1
	artery_prob = 20
	tendon_prob = 20
	mask_color = "#0000ff"
	process()
		..()
		process_grasp(owner.r_hand, "right hand")
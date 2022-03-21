/datum/organ/internal/right_eye
	name = "right eye"
	parent_organ = "head"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/eyes
	min_broken_damage = 65

	process() //Eye damage replaces the old eye_stat var.
		..()
		if(is_bruised())
			owner.right_eye_fucked = TRUE
		if(is_broken())
			owner.right_eye_fucked = TRUE

/datum/organ/internal/left_eye
	name = "left eye"
	parent_organ = "head"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/eyes
	min_broken_damage = 65

	process() //Eye damage replaces the old eye_stat var.
		..()
		if(is_bruised())
			owner.left_eye_fucked = TRUE
		if(is_broken())
			owner.left_eye_fucked = TRUE


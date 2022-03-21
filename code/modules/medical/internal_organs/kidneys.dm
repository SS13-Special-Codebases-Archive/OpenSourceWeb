//criancaney
/datum/organ/internal/kidney
	name = "kidneys"
	parent_organ = "vitals"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/kidneys

	process()

		..()
		if(is_bruised())
			if(prob(50))
				owner.handle_piss()
		else if(is_broken())
			if(prob(50))
				owner.handle_piss()

		// Coffee is really bad for you with busted kidneys.
		// This should probably be expanded in some way, but fucked if I know
		// what else kidneys can process in our reagent list.
		var/datum/reagent/coffee = locate(/datum/reagent/drink/coffee) in owner.reagents.reagent_list
		if(coffee)
			if(is_bruised())
				owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
			else if(is_broken())
				owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)

/datum/organ/internal/kidney/mechanize()
	new /datum/organ/internal/kidney/robotic(owner)
	return

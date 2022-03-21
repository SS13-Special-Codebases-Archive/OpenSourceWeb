/datum/organ/internal/guts
	name = "guts"
	parent_organ = "vitals"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/guts
	var/list/stomach_contents = list()

/datum/organ/internal/guts/process()
	..()
	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(5))
			owner.emote("cough")		//respitory tract infection

	if(is_bruised())
		if(prob(2))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
			if(prob(35))
				owner.emote("vomit")
			if(prob(10))
				owner.handle_shit()

	if(is_broken())
		if(prob(10))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
			if(prob(35))
				owner.emote("vomit")
			if(prob(10))
				owner.handle_shit()
/datum/organ/internal/stomach
	name = "stomach"
	parent_organ = "vitals"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/stomach
	var/list/stomach_contents = list()

/datum/organ/internal/stomach/process()
	..()
	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(5))
			owner.emote("cough")		//respitory tract infection

	if(is_bruised())
		if(prob(10))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
			if(prob(60))
				owner.emote("vomit")

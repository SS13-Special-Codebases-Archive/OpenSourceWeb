//pumao
/datum/organ/internal/lungs
	name = "lungs"
	parent_organ = "chest"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/lungs

/datum/organ/internal/lungs/process()
	..()
	if(owner.species && (owner.species.flags & NO_BREATHE))
		return
	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(5))
			owner.emote("cough")		//respitory tract infection

	if(is_bruised())
		if(prob(2))
			owner.emote("coughwounded",1,null,0)
			owner.drip(10)
		if(prob(4))
			owner.emote("1shotbreath",1,null,0)
			owner.losebreath += 15

/datum/organ/internal/lungs/mechanize()
	new /datum/organ/internal/lungs/robotic(owner)
	return

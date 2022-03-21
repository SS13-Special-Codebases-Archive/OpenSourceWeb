//coracao1
/datum/organ/internal/heart // This is not set to vital because death immediately occurs in blood.dm if it is removed.
	name = "heart"
	parent_organ = "chest"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/heart
	vital = 1

/datum/organ/internal/heart/mechanize()
	new /datum/organ/internal/heart/robotic(owner)
	return

/datum/organ/internal/heart/process()
	..()
	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(5))
			owner.emote("cough")		//respitory tract infection

	if(owner.species && (owner.species.flags & NO_BREATHE))
		return
	if(is_bruised())
		if(prob(2))
			owner.drip(10)
			owner.adjustOxyLoss(2)
			owner.emote("coughwounded",1,null,0)
		if(prob(4))
			owner.emote("1shotbreath",1,null,0)
			owner.losebreath += 15
			owner.adjustOxyLoss(2)

/datum/organ/internal/var
	escritura = ""

/datum/organ/internal/heart/proc/heart_attack()
	if(!owner || iszombie(owner))
		return
	if(stopped_working == TRUE)
		return
	to_chat(owner, "<span class='bname'>I feel... WEIRD.</span>")
	spawn(20)
		if(!owner)
			return
		to_chat(owner, "You cannot breathe anymore.")
		spawn(5)
			owner.emote("gasp",1,null,0)
			spawn(5)
				owner.emote("gasp",1,null,0)
				spawn(50)
					owner.sleeping = max(owner.sleeping, 100)
					to_chat(owner, "<span class='bname'><h3>OOOOOH, MY HEART!</h3></span>")
					stopped_working = TRUE
					owner.emote("agonypain",1,null,0)
					if(prob(90))
						owner.handle_piss()
						owner.handle_shit()
#define AGE_PARENT 0
#define AGE_SAME 1
#define AGE_CHILD 2


var/static/list/family_blacklisted_jobs = list("Innkeeper", "Innkeeper Wife", "Bulter", "Sitzfrau", "Incarn", "Inquisitor", "Practicus", "Guest")
var/global/datum/matchmaker/matchmaker = new()
var/datum/family/baron_family = null
var/mob/living/carbon/human/pending_nobles = list()
var/mob/living/carbon/human/pending_family = list()
var/datum/set_spouse/list/pending_set_spouse = list() //holds pending set_spouses
var/client/list/set_spoused = list() //prevents set_spoused people from being shoved into other families

/datum/set_spouse
	var/client/sender
	var/client/target
	var/accepted = FALSE

/datum/set_spouse/proc/do_setspouse()
	if(!accepted)
		return
	if(!ishuman(src.sender.mob) || !ishuman(src.target.mob))
		to_chat(src.sender.mob,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span></span>")
		to_chat(src.target.mob,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span></span>")
		return

	var/mob/living/carbon/human/human_sender = sender.mob
	var/mob/living/carbon/human/human_target = target.mob

	if(ticker.eof.id == "ordinators" && (human_target.job == "Marduk" || human_target.job == "Tiamat" || human_sender.job == "Tiamat" || human_sender.job == "Marduk"))
		to_chat(human_sender,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span></span>")
		to_chat(human_target,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span></span>")
		return

	if(baronfamily.Find(human_sender.job) || baronfamily.Find(human_target.job))
		to_chat(human_sender,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span></span>")
		to_chat(human_target,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span></span>")
		return

	if(family_blacklisted_jobs.Find(human_sender.job) || family_blacklisted_jobs.Find(human_target.job))
		to_chat(human_sender,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span></span>")
		to_chat(human_target,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span></span>")
		return

	if(human_sender.age < 18 || human_target.age < 18)
		to_chat(human_sender,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span> </span>")
		to_chat(human_target,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span> </span>")
		return

	if(human_sender.has_penis() && human_target.has_penis())
		to_chat(human_sender,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span></span>")
		to_chat(human_target,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span> </span>")
		return


	if(!human_sender.has_penis() && !human_target.has_penis())
		to_chat(human_sender,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span></span>")
		to_chat(human_target,"<span class='combat'>Setspouse <span class='combatbold'>FAIL!</span> </span>")
		return


	var/mob/living/carbon/human/husband
	var/mob/living/carbon/human/wife
	if(human_target.has_penis())
		husband = human_target
		wife = human_sender
	else
		husband = human_sender
		wife = human_target
	var/datum/family/F = new /datum/family(husband)
	matchmaker.families |= F
	F.add_member(wife)
	return

/hook/roundstart/proc/matchmaking()
	return TRUE

/datum/matchmaker
	var/list/families = list()
	var/list/relation_types = list()
	var/list/relations = list()

/datum/matchmaker/New()
	..()
	for(var/T in subtypesof(/datum/relation/))
		var/datum/relation/R = T
		relation_types[initial(R.name)] = T


/datum/matchmaker/proc/update_family_icons(mob/living/carbon/human/H)
	if(H.mind?.relations.len)
		for(var/datum/relation/family/R in H.mind.relations)
			if(ishuman(R.relation_holder.current))
				var/mob/living/carbon/human/family = R.relation_holder.current
				var/icon_type = "rel"
				if(R.name == "Husband" || R.name == "Wife")
					icon_type = "love"
				var/I = image('icons/mob/mob.dmi', loc = family, icon_state = icon_type)
				if(H.client)
					H.client.images += I

/datum/matchmaker/proc/add_relations_to_notes()
	//Add families to notes
	for(var/mob/living/carbon/human/H in player_list)
		H.mind.store_memory("<big><b>Family:</b></big>\n")
		for(var/datum/relation/family/R in matchmaker.get_relationships(H.mind))
			//to_world("This person is our relative: [R.connected_relation.relation_holder.current.name] But this doesnt work [R.connected_relation.relation_holder.current.name]")
			H.mind.memory += "[R.connected_relation.relation_holder.current.name] is my [R.name].\n"

/datum/matchmaker/proc/do_matchmaking()
	var/list/to_warn = list()
	for(var/datum/relation/R in relations)
		if(!R.connected_relation && R.family_flag == 0)
			R.find_match()
		if(R.connected_relation && !R.finalized)
			to_warn |= R.relation_holder.current
	for(var/mob/M in to_warn)
		to_chat(M,"<span class='warning'>You have new connections. Use \"See Relationship Info\" to view and finalize them.</span>")


/datum/matchmaker/proc/do_migrant_matchmaking(var/list/mob/living/carbon/human/migrants)
	if(!migrants.len || migrants.len == 1)
		return
	var/list/mob/living/carbon/human/pending_family = list()
	var/datum/family/F
	for(var/mob/living/carbon/human/H in migrants)
		if(H.has_penis() && H.age >= 18)//Just going to give it to the first able man. Not much of a point in making this complex right now since families only go one generation deep.
			F = new /datum/family(H)
			families |= F
			migrants -= H
		else
			migrants -= H
			pending_family |= H
	if(F)
		for(var/mob/living/carbon/human/M in pending_family)
			F.add_member(M)

/datum/matchmaker/proc/do_migrant_setspouse()
	for(var/datum/set_spouse/D in pending_set_spouse)
		if(ishuman(D.sender.mob) && ishuman(D.target.mob) && D.sender.mob.job == "Migrant" && D.target.mob.job == "Migrant")
			D.do_setspouse()
		else
			qdel(D)

//This is where the families are made.  This is basically the big driver of everything.
/datum/matchmaker/proc/do_family_matchmaking()
	var/total_familes = round(player_list.len * 0.2) + 1  // How many families we want Makes around 1 family per 4 people, and always at least one family
	/*to_world("Trying to make families total_familes = [total_familes]")
	for(var/mob/living/carbon/human/H in player_list)
		to_world("player_list is [player_list]")
		to_world("Checking out: [H] or [H.name] or [H.mind]")*/

	for(var/mob/living/carbon/human/H in mob_list)
		if(ismonster(H)) continue
		if(H.bot) continue
		if(family_blacklisted_jobs.Find(H.job)) continue
		if(ticker.eof.id == "ordinators" && (H.job == "Marduk" || H.job == "Tiamat")) continue
		if(baronfamily.Find(H.job))
			if(!baron_family && H.job == "Baron")
				baron_family = new /datum/family(H)
				families |= baron_family
			else
				pending_nobles |= H

		else if(!set_spoused.Find(H?.client) && H?.client?.prefs?.family == TRUE)
			if(families.len < total_familes) // If we aren't at our limit yet, we make five suitable players head of house
				 //from memory lifeweb families always have a male head.
				if(H.has_penis() && H.age >= 18)//18 might produce some strange results though we're trying to generate as many families as we can
					var/datum/family/F = new /datum/family(H)
					families |= F
				else
					pending_family |= H
			else							 // If we are at our limit, start adding people to familes
				pending_family |= H

	for(var/mob/living/carbon/human/R in pending_nobles)
		var/mob/living/carbon/human/baron = baron_family.family_head
		if(baron_family)
			if(baron.age > 30)
				if(R.job == "Baroness")
					if(R.age > (baron.age + 18) || R.age < (baron.age - 18))
						R.adjust_age(baron.age,AGE_SAME)
				else if(R.job == "Heir" || R.job == "Successor")
					if(!R.isChild())
						R.adjust_age(baron.age,AGE_CHILD)
			baron_family.add_member(R)

	for(var/mob/living/carbon/human/M in pending_family)
		var/datum/family/list/families_list = families - baron_family //as funny as it is a random bum being in the baron's family is stupid
		var/datum/family/chosen_family
		if(families_list.len)
			chosen_family = pick(families_list)
		if(chosen_family)
			chosen_family.add_member(M)

	for(var/datum/set_spouse/D in pending_set_spouse)
		D.do_setspouse()
		qdel(D)
	//Prints familes
	/*
	for(var/datum/family/F in families)
		to_world("Families head: [F.family_head] Families last name = [F.name] Members are:")
		for(var/mob/living/carbon/human/M in F.members)
			to_world("Member: [M.real_name]")*/

	//Testing stuff
/*
	var/list/test_player_list = list("John Doe", "Jane Dane", "Harold buster", "Jame righter", "Matt James", "Tim Panda", "Stever Typing", "The doom", "Debbie Downer", "Frail Mike")
	total_familes = round(test_player_list.len * 0.2)  // How many families we want Makes around 1 family per 4 people
	for(var/H in test_player_list)
		if(families.len < total_familes) // If we aren't at our limit yet, we make five ned players head of house
			var/datum/family/F = new /datum/family/(pick(test_player_list))
			families |= F
		else							 // If we are at our limit, start adding people to familes
			var/datum/family/F = pick(families)
			F.add_member(H)
	//Prints familes
	for(var/datum/family/F in families)
		to_world("Families head: [F.family_head] Families last name = [F.name] Memebers are:")
		for(var/M in F.members)
			to_world("Member: [M]")
*/

/datum/matchmaker/proc/get_relationships(datum/mind/M)
	. = list()
	for(var/datum/relation/R in relations)
		if(R.relation_holder == M && R.connected_relation)
			. += R

//Currently this just builds a new family and places the two mobs in it.
//Make sure that they're actually eligible for marriage before you call it.
/datum/matchmaker/proc/setmarriage(var/mob/living/carbon/human/owner, var/mob/living/carbon/human/target)
	var/datum/family/F = new /datum/family(owner)
	families |= F
	F.add_member(target)

/datum/matchmaker/proc/setup_special_marriage()
	for(var/mob/living/carbon/human/H in player_list)
		switch(H.job)
			if("Innkeeper")
				for(var/mob/living/carbon/human/HH in player_list)
					if(HH.job == "Innkeeper Wife")
						setmarriage(H,HH)
			if("Butler")
				for(var/mob/living/carbon/human/HH in player_list)
					if(HH.job == "Sitzfrau")
						setmarriage(H,HH)

//Types of relations

/datum/relation
	var/name = "Acquaintance"
	var/desc = "You just know them."
	var/list/can_connect_to	//What relations (names) can matchmaking join us with? Defaults to own name.
	var/list/incompatible 	//If we have relation like this with the mob, we can't join
	var/datum/mind/relation_holder  //Whoever owns this relationship
	var/datum/relation/connected_relation  //Whatever relationship this is connected to
	var/info
	var/finalized
	var/open = 2			//If non-zero, allow connected_relation relations to form connections
	var/family_flag = 0 //So we don't show family relations in options

/datum/relation/New()
	..()
	if(!can_connect_to)
		can_connect_to = list(name)
	matchmaker.relations += src

/datum/relation/proc/get_candidates()
	.= list()
	for(var/datum/relation/R in matchmaker.relations)
		if(!valid_candidate(R.relation_holder) || !can_connect(R))
			continue
		. += R

/datum/relation/proc/valid_candidate(datum/mind/M)
	if(M == relation_holder)	//no, you NEED connected_relation people
		return FALSE

	if(!M.current)	//no extremely platonic relationships
		return FALSE

	return TRUE

/datum/relation/proc/can_connect(var/datum/relation/R)
	for(var/datum/relation/D in matchmaker.relations) //have to check all connections between us and them
		if(D.relation_holder == R.relation_holder && D.connected_relation && D.connected_relation.relation_holder == relation_holder)
			if(D.name in incompatible)
				return 0
	return (R.name in can_connect_to) && !(R.name in incompatible) && R.open

/datum/relation/proc/get_copy()
	var/datum/relation/R = new type
	R.relation_holder = relation_holder
	R.info = relation_holder.current && info
	R.open = 0
	return R

/datum/relation/proc/find_match()
	var/list/candidates = get_candidates()
	if(!candidates.len) //bwoop bwoop
		return 0
	var/datum/relation/R = pick(candidates)
	R.open--
	if(R.connected_relation)
		R = R.get_copy()
	connected_relation = R
	R.connected_relation = src
	return 1

/datum/relation/proc/get_desc_string()
	return "[relation_holder] and [connected_relation.relation_holder] know each connected_relation."

mob/living/carbon/human/proc/adjust_age(var/target_age, var/direction)
	switch(direction)
		if(AGE_SAME)
			src.age = target_age + rand(-17,17)
			return
		if(AGE_PARENT)
			src.age = target_age + 18 + rand(-17,17)
		if(AGE_CHILD)
			src.age = 18 + rand(0,17)

#undef AGE_PARENT
#undef AGE_SAME
#undef AGE_CHILD
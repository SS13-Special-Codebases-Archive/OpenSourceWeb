/datum/family/
	var/name
	var/list/members = list()
	var/mob/living/carbon/human/family_head
	var/mob/living/carbon/human/spouse

/datum/family/New(var/mob/living/carbon/human/head)
	var/regex/R = regex("(^\\S+) (.*$)") //Get all words (\w+) that have an end of line ($).  Should pick off last names
	R.Find(head.real_name)
	try
		name = R.group[2]
	catch
		name = capitalize(pick(last_names)) //they don't have a last name
		head.real_name = "[head.real_name] [name]"
	family_head = head

// Handles adding someone to the family datum "members"
// Also handles setting the player name correctly (TODO)
/datum/family/proc/add_member(var/mob/living/carbon/human/member)
	var/regex/R = regex("(^\\w+) (.*$)") //Get first name and last name
	var/first_name
	R.Find(member.real_name)
	try
		first_name = R.group[1]
	catch
		first_name = member.real_name //they don't have a last name.
	//var/last_name = R.group[2]
	//to_world("Setting real name of: [member.real_name]")
	member.real_name = "[first_name] [name]"
	//to_world("Setting real name is now: [member.real_name]")
	setup_relations(member)
	members |= member

//Where we create and link relations
/datum/family/proc/link_relatives(var/mob/living/carbon/human/owner, var/mob/living/carbon/human/target)
	if(owner == target) //Don't link the same person
		return
	var/family_type
	//Pick relationship to add between these two people
	family_type = pick_relation(owner,target)
	var/relation_1 = matchmaker.relation_types[family_type]
	var/relation_2 = matchmaker.relation_types[pick_inverse(family_type,target.gender)]
	if(isnull(relation_1))
		rtlog_path << "FAMILY ERROR: null relationship for relation_1! owner details: (AGE: [owner.age], GENDER: [owner.gender] JOB: [owner.job]) target details: (AGE: [target.age], GENDER: [target.gender] JOB: [target.job])"
		return
	if(isnull(relation_2))
		rtlog_path << "FAMILY ERROR: null relationship for relation_2! owner details: (AGE: [owner.age], GENDER: [owner.gender] JOB: [owner.job]) target details: (AGE: [target.age], GENDER: [target.gender] JOB: [target.job])"
		return
	var/datum/relation/owner_relation = new relation_1
	var/datum/relation/target_relation = new relation_2
	owner_relation.connected_relation = target_relation
	target_relation.connected_relation = owner_relation
	owner_relation.relation_holder = owner.mind
	target_relation.relation_holder = target.mind
	owner.mind.relations += target_relation
	target.mind.relations += owner_relation
	var/datum/job/target_job = job_master.GetJob(target.job)
	var/datum/job/owner_job = job_master.GetJob(owner.job)
	//Thanks BYOND
	var/owner_gender = owner.gender == MALE ? "He" : "She"
	var/target_gender = target.gender == MALE ? "He" : "She"
	if(target.job == "Migrant")
		to_chat(owner, "<span class='passivebold'>[target.real_name] ([target.age])</span><span class='passive'> is my [target_relation.name]. [target_gender] is traveling [owner.job == "Migrant" ? "with me" : ""] to the fortress.</span>")
	else
		to_chat(owner, "<span class='passivebold'>[target.real_name] ([target.age])</span><span class='passive'> is my [target_relation.name]. [target_gender] is [target_job.total_positions > 1 ? "\a [target.assignment]" : "the [target.assignment] of this fortress"].</span>")
	if(owner.job == "Migrant")
		to_chat(target, "<span class='passivebold'>[owner.real_name] ([owner.age])</span><span class='passive'> is my [owner_relation.name]. [owner_gender] is traveling [target.job == "Migrant" ? "with me " : ""]to the fortress.</span>")
	else
		to_chat(target, "<span class='passivebold'>[owner.real_name] ([owner.age])</span><span class='passive'> is my [owner_relation.name]. [owner_gender] is [owner_job.total_positions > 1 ? "\a [owner.assignment]": "the [owner.assignment] of this fortress"].</span>")
	var/icon_type = "rel"
	if(owner_relation.name == "Husband" || owner_relation.name == "Wife" || target_relation.name == "Husband" || target_relation.name == "Wife")
		icon_type = "love"
	var/I = image('icons/mob/mob.dmi', loc = owner, icon_state = icon_type)
	var/II = image('icons/mob/mob.dmi', loc = target, icon_state = icon_type)
	if(target.client)
		target.client.images += I
	if(owner.client)
		owner.client.images += II

//Setup relations between families
/datum/family/proc/setup_relations(var/mob/living/carbon/human/member)
	//Link head and member
	link_relatives(member,family_head)
	for(var/datum/relation/R in matchmaker.get_relationships(family_head.mind))
		var/mob/living/carbon/human/target = R.connected_relation.relation_holder.current
		link_relatives(member,target)

// Pick the correct relation for the position in the family
// If everything here works, it should spit out the correct relation type, for any two family members
// Given the current state of the family.
/datum/family/proc/pick_relation(var/mob/living/carbon/human/owner, var/mob/living/carbon/human/target)
	var/family_type
	var/gender = owner.gender
	switch(gender)
		if(MALE)
			switch((owner.age - target.age))
				if(-18 to 18) //Same generation
					family_type = "Brother"
				if(-INFINITY to 19) //Target is from the Older generation
					family_type = "Son"
				if(19 to INFINITY)  // Target is from the younger generation
					family_type = "Father"
		if(FEMALE)
			switch((owner.age - target.age))
				if(-18 to 18) //Same generation
					family_type = "Sister"
				if(-INFINITY to 19) //Older generation
					family_type = "Daughter"
				if(19 to INFINITY)
					family_type = "Mother"

	//Handle marriage
	if((family_type == "Brother" || family_type == "Sister") && !spouse && (owner.age >= 18 && target.age >= 18) && !(owner.has_penis() && target.has_penis())) //If we are the same age but different gender, but don't have a spouse, marry us!
		spouse = target
		if(owner.has_penis())
			family_type = "Husband"
		else
			family_type = "Wife"

	//Futa marriage. Can only occur through setspouse
	/*if((family_type == "Sister") && !spouse && (owner.has_penis() || target.has_penis()) && (owner.gender == target.gender))
		spouse = target
		if(owner.has_penis())
			family_type = "Husband"
		else
			family_type = "Wife"*/

	//Only heads of house can have children
	if((family_type == "Son" || family_type == "Daughter") && (target != family_head && target != spouse))
		switch(owner.gender)
			if(MALE)
				family_type = "Nephew"
			if(FEMALE)
				family_type = "Niece"
	//Only heads of house can be parents
	if((family_type == "Father" || family_type == "Mother") && (target != family_head && target != spouse))
		switch(owner.gender)
			if(MALE)
				family_type = "Uncle"
			if(FEMALE)
				family_type = "Aunt"

	if(!isnull(family_type))
		return family_type

// Picks the opposite of a relationship.  Son -> father uncle -> nephew etc.
/datum/family/proc/pick_inverse(var/relation_type,var/gender)
	switch(gender)
		if(MALE)
			switch(relation_type)
				if("Husband")  return "Wife"
				if("Wife")     return "Husband"
				if("Mother")   return "Son"
				if("Father")   return "Son"
				if("Son")      return "Father"
				if("Daughter") return "Father"
				if("Sister")   return "Brother"
				if("Brother")  return "Brother"
				if("Uncle")	   return "Nephew"
				if("Aunt")     return "Nephew"
				if("Nephew")   return "Uncle"
				if("Niece")    return "Uncle"
		if(FEMALE)
			switch(relation_type)
				if("Wife")     return "Husband"
				if("Husband")  return "Wife"
				if("Mother")   return "Daughter"
				if("Father")   return "Daughter"
				if("Son")      return "Mother"
				if("Daughter") return "Mother"
				if("Sister")   return "Sister"
				if("Brother")  return "Sister"
				if("Uncle")	   return "Niece"
				if("Aunt")     return "Niece"
				if("Nephew")   return "Aunt"
				if("Niece")    return "Aunt"


/datum/relation/family
	var/sex_restricted = null
	var/list/connected_relatives = list() //We use this so we can store multiple connected relations
	family_flag = 1
	finalized = 1

/datum/relation/family/get_desc_string()
	return "[connected_relation.relation_holder] is your [name]."

/datum/relation/family/mother
	name = "Mother"
	desc = "They gave birth to you"

/datum/relation/family/father
	name = "Father"
	desc = "They banged your mom."

/datum/relation/family/daughter
	name = "Daughter"
	desc = "They're your daughter"

/datum/relation/family/son
	name = "Son"
	desc = "They're your son"

/datum/relation/family/sister
	name = "Sister"
	desc = "They are your sister"

/datum/relation/family/brother
	name = "Brother"
	desc = "They are your brother"

/datum/relation/family/niece
	name = "Niece"
	desc = "They are your niece"

/datum/relation/family/nephew
	name = "Nephew"
	desc = "They are your Nephew"

/datum/relation/family/Uncle
	name = "Uncle"
	desc = "They are your Uncle"

/datum/relation/family/Aunt
	name = "Aunt"
	desc = "They are your Aunt"

/datum/relation/family/Husband
	name = "Husband"

/datum/relation/family/Wife
	name = "Wife"


/mob/living/carbon/human/verb/check_family()
	set hidden = 1
	var/message = "<big><b>Family:</b></big>\n"
	if(!mind)
		return
	for(var/datum/relation/family/R in mind.relations)
		message += "[R.relation_holder.current.real_name] is my [R.name].\n"
	to_chat(src, message)

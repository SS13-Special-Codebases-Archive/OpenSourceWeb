#define PROCESS_ACCURACY 10

/****************************************************
				BASE INTERNAL ORGANS
****************************************************/

/mob/living/carbon/var/list/internal_organs = list()

/datum/organ/internal
	var/damage = 0 // amount of damage to the organ
	var/min_bruised_damage = 10
	var/min_broken_damage = 30
	var/parent_organ = "chest"
	var/list/emplevel = list(0,0,0)  // [1] is the highest amount of emp damage, [3] is the least
	var/desc = ""
	var/robotic = 0 //For being a robot
	var/removed_type //When removed, forms this object.
	var/rejecting            // Is this organ already being rejected?
	var/obj/item/weapon/reagent_containers/food/snacks/organ/organ_holder // If not in a body, held in this item.
	var/list/transplant_data
	var/damagelevel = 1
	var/stopped_working = 0// for heart attacks and etc


/datum/organ/internal/proc/rejuvenate()
	damage=0

/datum/organ/internal/proc/is_bruised()
	return damage >= min_bruised_damage

/datum/organ/internal/proc/is_broken()
	return damage >= min_broken_damage || status & ORGAN_CUT_AWAY

/datum/organ/internal/New(mob/living/carbon/human/H)
	..()
	if(H && istype(H))
		var/datum/organ/external/E = H.organs_by_name[src.parent_organ]
		if(E.internal_organs == null)
			E.internal_organs = list()
		var/datum/organ/internal/check = E.internal_organs[name]
		if(check)
			delete(H)
		add(H)
		owner = H

/datum/organ/internal/proc/vital_check()
	if(src.vital && is_broken() || src.vital && stopped_working)
		owner.death_door()

/datum/organ/internal/process()

	//Process infections
	if (robotic >= 2 || (owner.species && owner.species.flags & IS_PLANT))	//TODO make robotic internal and external organs separate types of organ instead of a flag
		germ_level = 0
		return

	if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()

		//** Handle the effects of infections
		var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

		if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(30))
			germ_level--

		if (germ_level >= INFECTION_LEVEL_ONE/2)
			//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes
			if(antibiotics < 5 && prob(round(germ_level/6)))
				germ_level++

		if (germ_level >= INFECTION_LEVEL_TWO)
			var/datum/organ/external/parent = owner.get_organ(parent_organ)
			//spread germs
			if (antibiotics < 5 && parent.germ_level < germ_level && ( parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30) ))
				parent.germ_level++

			if (prob(3))	//about once every 30 seconds
				take_damage(1,silent=prob(30))

		// Process unsuitable transplants. TODO: consider some kind of
		// immunosuppressant that changes transplant data to make it match.
		if(transplant_data)
			if(!rejecting && prob(20) && owner.dna && blood_incompatible(transplant_data["blood_type"],owner.dna.b_type))//,owner.species,transplant_data["species"]))
				rejecting = 1
			else
				rejecting++ //Rejection severity increases over time.
				if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
					switch(rejecting)
						if(1 to 50)
							take_damage(1)
						if(51 to 200)
							owner.reagents.add_reagent("toxin", 1)
							take_damage(1)
						if(201 to 500)
							take_damage(rand(2,3))
							owner.reagents.add_reagent("toxin", 2)
						if(501 to INFINITY)
							take_damage(4)
							owner.reagents.add_reagent("toxin", rand(3,5))

/datum/organ/internal/proc/take_damage(amount, var/silent=0)
	damage += amount * damagelevel

	if(owner.my_stats.ht)
		damage = damage
	owner.custom_pain("<span class='bname'>OOOOH MY [capitalize(name)]!</span>", 1)
/*	if (!silent)
		owner.custom_pain("<span class='hugepain'>WHAT A PAIN!</span> <span class='combat'>My [name] hurts!</span>", 1)*/

/datum/organ/internal/proc/emp_act(severity)
	if(emplevel[1])
		take_damage(emplevel[severity])

/datum/organ/internal/proc/mechanize() //Being used to make robutt hearts, etc

/datum/organ/internal/proc/mechassist() //Used to add things like pacemakers, etc


/datum/organ/internal/proc/delete(var/mob/living/carbon/human/H)
	if(H)
		var/datum/organ/internal/toremove = H.internal_organs_by_name[name]
		if(toremove)
			var/datum/organ/external/E = H.organs_by_name[toremove.parent_organ]
			for (var/datum/organ/internal/I in E.internal_organs)
				if (I == toremove)
					I = null

	return

/datum/organ/internal/proc/add(var/mob/living/carbon/human/H)
	var/datum/organ/external/P = H.organs_by_name[parent_organ]
	if(P)
		if(P.internal_organs == null)
			P.internal_organs = list()
		P.internal_organs += src
	H.internal_organs.Add(src)
	H.internal_organs_by_name[name] = src
	owner = H
	return

/datum/organ/internal/proc/remove(var/mob/user)
	if(!removed_type)
		return 0
	var/obj/item/weapon/reagent_containers/food/snacks/organ/removed_organ = new removed_type(get_turf(user))
	if(istype(removed_organ))
		removed_organ.organ_data = src
		removed_organ.update()
		organ_holder = removed_organ

	return removed_organ

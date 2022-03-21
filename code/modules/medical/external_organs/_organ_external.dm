/****************************************************
				BASE EXTERNAL ORGAN
****************************************************/
/datum/organ/external
	name = "external"
	var/icon_name = null
	var/body_part = null
	var/icon_position = 0

	var/damage_state = "00"
	var/brute_dam = 0
	var/burn_dam = 0
	var/max_damage = 0
	var/max_size = 0
	var/last_dam = -1
	var/skin = 1

	var/display_name
	var/display_namebr
	var/list/wounds = list()
	var/number_wounds = 0 // cache the number of wounds, which is NOT wounds.len!

	var/tmp/perma_injury = 0
	var/tmp/destspawn = 0 //Has it spawned the broken limb?
	var/tmp/amputated = 0 //Whether this has been cleanly amputated, thus causing no pain
	var/whenstopartery = -1

	var/canBeRemoved = 0
	var/delimb_min_damage = null
	var/min_broken_damage = 80

	var/datum/organ/external/parent
	var/list/datum/organ/external/children

	// Internal organs of this body part
	var/list/datum/organ/internal/internal_organs

	var/damage_msg = "\red You feel an intense pain"
	var/broken_description

	var/open = 0
	var/dissected = 0
	var/stage = 0
	var/cavity = 0
	var/sabotaged = 0 // If a prosthetic limb is emagged, it will detonate when it fails.
	var/encased       // Needs to be opened with a saw to access the organs.
	var/lfwblockedicon = null
	var/artery_name = "artery"
	var/arterial_bleed_severity = 1    // Multiplier for bleeding in a limb.
	var/hasVocal = FALSE
	var/VocalTorn = FALSE
	var/mask_color = null

	//PAIN DO COMBATE NOVO//
						  //
						  // NAO E MAIS ISSO EU NAO LIGO PRA ESSA BOSTA??? MAS EU ACHO QUE ALGUMA HORA VAI TER UTILIDADE FODASE
	var/painLW = 0		  //
	var/debuff = 0		  //
						  //
						  //
	////////////////////////

	var/obj/item/hidden = null
	var/list/implants = list()
	var/iconsdamage = null
	// how often wounds should be updated, a higher number means less often
	var/wound_update_accuracy = 1                    // How much the limb hurts.
	var/pain_disability_threshold      // Point at which a limb becomes unusable due to pain.
	var/artery_prob = 0
	var/tmp/next_blood_squirt = 0
	var/head_icon_needed = 0
	var/sprite_dependent_for_artery = 0
	var/obj/item/bandaged = null
	var/has_tendons = 0
	var/has_finger = 0
	var/list/fingers = list()
	var/list/digit_check = list()
	var/cripple_left = 0 //if it's cripple left, it's crippled.
	var/tendon_prob = 0
	var/attackTXT = ""

/datum/organ/external/New(var/datum/organ/external/P)
	if(P)
		parent = P
		if(!parent.children)
			parent.children = list()
		parent.children.Add(src)
	return ..()

/****************************************************
			   DAMAGE PROCS
****************************************************/
/datum/organ/external/proc/create_pain_threshold()
	if(isnull(pain_disability_threshold) && owner?.my_stats?.ht)
		pain_disability_threshold = (owner.my_stats.ht*5)

/mob/living/carbon/human/proc/getNewDamage(var/brute = 1)
	var/ht = abs(my_stats.ht)
	var/newDamage = brute

	if(ht <= 0)
		return newDamage * 10
	if(ht == 10)
		return newDamage

	if(ht >= 11)
		for(var/x = 0; x< ht; x++)
			newDamage -= newDamage / (ht * 4.5)
	else
		for(var/x = ht; x < 10; x++)
			newDamage += 6

	return abs(newDamage)

//ESSA PROC SERVE PRA TU DAR STUN QUANDO O CARA TOMA DANO
//TIPO CHEGA CARA POR TRAS DO OUTRO DA UM TAPAO E ELE CAI
//COLOQUEI AQUI SEI LA POR QUE???

/datum/organ/external/proc/emp_act(severity)
	if(!(status & ORGAN_ROBOT))	//meatbags do not care about EMP
		return
	var/probability = 30
	var/damage = 15
	if(severity == 2)
		probability = 1
		damage = 3
	if(prob(probability))
		droplimb(1, 0, 1)
	else
		take_damage(damage, 0, 1, 1, used_weapon = "EMP")

/datum/organ/external/proc/take_damage(brute, burn, sharp, edge, var/used_weapon = null, list/forbidden_limbs = list(), delimbexplosion = 0, armor, specialAttack)
	if((brute <= 0) && (burn <= 0))
		return 0
	if(owner?.my_stats?.ht)
		var/HT = owner.my_stats.ht/10
		brute = owner.getNewDamage(brute)
		burn = burn/HT
	//IF HITS THE FACE HIT THE HEAD BY HALF
	if(istype(src, /datum/organ/external/face))
		var/datum/organ/external/EXE = owner.get_organ("head")
		brute = brute/2
		burn = burn/2
		EXE.take_damage(brute, burn, sharp, edge, used_weapon, forbidden_limbs, delimbexplosion)
	//IF HITS THE MOUTH HIT THE FACE BY HALF
	if(istype(src, /datum/organ/external/mouth))
		var/datum/organ/external/EXE = owner.get_organ("face")
		brute = brute/2
		burn = burn/2
		EXE.take_damage(brute, burn, sharp, edge, used_weapon, forbidden_limbs, delimbexplosion)

	var/amount = brute + burn
	if(ishuman(owner) && !(owner.species && owner.species.flags & NO_PAIN) && !(owner.status_flags & STATUS_NO_PAIN))
		if(brute){
			if(sharp && !edge){add_pain(brute*1.1)}
			if(!sharp && edge){add_pain(brute*1.5)}
			if(!sharp && !edge){add_pain(brute)}
			if(sharp && edge){add_pain(brute*1.7)}
		}
		if(burn){add_pain(burn*2)}

	if(brute_dam + brute >= max_damage + 15 && !sharp && !edge)
		if(body_part != UPPER_TORSO && body_part != LOWER_TORSO && body_part != GROIN && body_part != HEAD && body_part != THROAT) // you cant explode someone neck for fucks sake
			droplimb(1, 0, 1)
			update_damages()
	else if(brute_dam + brute >= max_damage + 15 && sharp && !edge)
		if(body_part != UPPER_TORSO && body_part != LOWER_TORSO && body_part != GROIN && body_part != HEAD) //you cant stab someone and their limb fall out of their body, only slash
			droplimb(1, 1, 0)
			update_damages()

	//TALVEZ DE MERDA?? TALVEZ FIQUE QUEBRADO??? NAO SEI VAMOS VER!!!

	if(!(owner.species && owner.species.flags & NO_PAIN) && !(owner.status_flags & STATUS_NO_PAIN))
		switch(amount)
			if(1 to 10)
				owner.flash_weakest_pain()
			if(10 to 15)
				owner.flash_weaker_pain()
			if(15 to 30)
				owner.flash_weak_pain()
			if(30 to 10000)
				owner.flash_pain()

	if(status & ORGAN_DESTROYED)
		return 0
	if(status & ORGAN_ROBOT )

		var/brmod = 0.66
		var/bumod = 0.66

		if(istype(owner,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = owner
			if(H.species && H.species.flags & IS_SYNTHETIC)
				brmod = H.species.brute_mod
				bumod = H.species.burn_mod

		brute *= brmod //~2/3 damage for ROBOLIMBS
		burn *= bumod //~2/3 damage for ROBOLIMBS

	if(!(status & ORGAN_DESTROYED) && brute > 32 && !iszombie(owner) && !(owner.status_flags & STATUS_NO_PAIN))
		owner?.emote("agonydeath")


	// High brute damage or sharp objects may damage internal organs
	if(internal_organs && ( (sharp && brute >= 5) || brute >= 10) && prob(15))
		// Damage an internal organ
		var/datum/organ/internal/I = pick(internal_organs)
		I.take_damage(brute / 2)
		brute -= brute / 2

	if(status & ORGAN_BROKEN && brute)
		if (!(owner.species && (owner.species.flags & NO_PAIN) && !(owner.status_flags & STATUS_NO_PAIN)))
			owner.emote("agonydeath")	//getting hit on broken hand hurts

	var/can_cut = (prob(brute-10) || sharp) && !(status & ORGAN_ROBOT)
	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	if((brute_dam + burn_dam + brute + burn) < max_damage || !config.limbs_can_break)
		if(brute)
			if(can_cut)
				createwound( CUT, brute )
				owner:loc:add_blood(owner)
			else
				createwound( BRUISE, brute )

		if(burn)
			createwound( BURN, burn )
	else
		//If we can't inflict the full amount of damage, spread the damage in other ways
		//How much damage can we actually cause?
		var/can_inflict = max_damage * config.organ_health_multiplier - (brute_dam + burn_dam)
		if(can_inflict)
			if (brute > 0)
				//Inflict all burte damage we can
				if(can_cut)
					createwound( CUT, min(brute,can_inflict) )
					owner:loc:add_blood(owner)
				else
					createwound( BRUISE, min(brute,can_inflict) )

				//How much mroe damage can we inflict
				can_inflict = max(0, can_inflict - brute)
				//How much brute damage is left to inflict

			if (burn > 0 && can_inflict)
				//Inflict all burn damage we can
				createwound(BURN, min(burn,can_inflict))
				//How much burn damage is left to inflict
				burn = max(0, burn - can_inflict)
		//If there are still hurties to dispense
		if (burn || brute)
			if (status & ORGAN_ROBOT)
				droplimb(1) //Robot limbs just kinda fail at full damage.
			else
				//List organs we can pass it to
				var/list/datum/organ/external/possible_points = list()
				if(parent)
					possible_points += parent
				if(children)
					possible_points += children
				if(forbidden_limbs.len)
					possible_points -= forbidden_limbs
				if(possible_points.len)
					//And pass the pain around
					possible_points.Cut()

	do_actions(brute, burn, sharp, edge, used_weapon, forbidden_limbs, delimbexplosion, armor)

	// sync the organ's damage with its wounds
	src.update_damages()

	//If limb took enough damage, try to cut or tear it off
	if(body_part != UPPER_TORSO && body_part != LOWER_TORSO && body_part != THROAT && body_part != GROIN && body_part != HEAD) //as hilarious as it is, getting hit on the chest too much shouldn't effectively gib you.
		if(config.limbs_can_break && brute_dam >= max_damage * config.organ_health_multiplier)
			if(sharp && !edge)
				if((brute > 25 && prob(2 * brute / 4)))
					droplimb(1,1,0)
			else if(!sharp && !edge)
				if(owner.stat == 2 && (brute > 20 && prob(2 * brute)))
					droplimb(1,0,1)

	owner?.updatehealth()
	owner?.UpdateDamageIcon(1)

	var/result = update_icon()
	return result

/datum/organ/external/proc/get_actions()
	var/dmgTXT = attackTXT

	attackTXT = null

	return dmgTXT

/datum/organ/external/proc/do_actions(brute, burn, sharp, edge, var/used_weapon = null, list/forbidden_limbs = list(), var/delimbexplosion = 0, var/armor)
	var/dmgTXT = null

	if(!istype(used_weapon, /obj/item/weapon))
		return

	var/obj/item/weapon/W = used_weapon

	if(brute && !sharp && !edge && !(status & ORGAN_BROKEN) && (brute >= src.min_broken_damage || src.brute_dam >= src.min_broken_damage))
		src.fracture()
		dmgTXT += "<span class='combatbold'>A bone was fractured!</span> "

	if(sharp && armor != ARMOR_SOFTEN || edge && armor != ARMOR_SOFTEN)
		if(prob(src.artery_prob / 2))
			if(src.sever_artery())
				if(src.artery_name == "carotid artery")
					dmgTXT +="<span class='combatbold'>The carotid artery has been dissected!</span>"
				else
					dmgTXT +="<span class='combatbold'>An artery has been torn!</span>"
		if(prob(35))
			if(src.hasVocal && !src.VocalTorn)
				if(src.artery_name == "carotid artery")
					dmgTXT +="<span class='combatbold'>Vocal chords were torn!</span>"
					src.VocalTorn = TRUE

	if(istype(src, /datum/organ/external/mouth))
		var/datum/organ/external/mouth/M = src
		if(M.knock_out_teeth(get_dir(pick(cardinal), src), round(rand(28, 38) * ((rand(0, 9)*2)/100))))
			owner.visible_message("<span class='crithit'>[owner]'s teeth sail off in an arc!</span>")
			owner.receive_damage()

	if(istype(src, /datum/organ/external/vitals) && edge)
		var/datum/organ/external/vitals/V = src
		var/modifier = 0
		if(W.penetrating)
			modifier = rand(25,40)
		if(prob(8+modifier))
			dmgTXT += "<span class='combatbold'>An internal organ was damaged!</span> "
			var/datum/organ/internal/damagedOrgan = pick(V.internal_organs)
			owner?.emote("agonydeath")
			damagedOrgan.take_damage(rand(10,20))
			owner.Stun(rand(1,3))
			if(prob(60-owner.my_stats.ht))
				owner.vomit()

	if(src.display_name == "mouth" ? prob(35) : src.display_name == "head" ? prob(50) : src.display_name == "face" ? prob(40) : prob(0))
		if(!owner.lying)
			if(prob(90) && owner.head)
				var/obj/item/HAT = owner.head
				if(!istype(HAT, /obj/item/clothing/head/helmet))
					owner.drop_from_inventory(HAT)

	if(istype(src, /datum/organ/external/head) && !edge && !sharp)
		var/datum/organ/external/head/E = src
		var/probSkull = E.brute_dam / 11
		if(!E.brained && E.brute_dam > rand(80, 90))
			if(prob(probSkull))
				E.breakskull()
				E.disfigure()
				owner.my_stats.it -= rand(3,5)
				dmgTXT += "<span class='combatbold'>The skull breaks with a sickening cracking sound!</span> "
				if(!iszombie(src) && !ismonster(src))
					for(var/mob/living/carbon/human/HHH in range(src,7))
						if(!HHH.terriblethings)
							HHH.add_event("terriblething", /datum/happiness_event/disgust/terriblethings)
						if(HHH.vice == "Sensitivity")
							if(prob(80))
								HHH.vomit()
								if(prob(80))
									HHH.emote(pick("scream","cry"))
				if(prob(55))
					owner.visible_message("<span class='hitbold'[name]</span> <span class='hit'>starts having a seizure!</span>")
					owner.Paralyse(10)
					owner.Jitter(1000)

	attackTXT = dmgTXT

	return

/datum/organ/external/proc/heal_damage(brute, burn, internal = 0, robo_repair = 0)
	if(status & ORGAN_ROBOT && !robo_repair)
		return

	//Heal damage on the individual wounds
	for(var/datum/wound/W in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if(W.damage_type == CUT || W.damage_type == BRUISE)
			brute = W.heal_damage(brute)
		else if(W.damage_type == BURN)
			burn = W.heal_damage(burn)

	if(internal)
		status &= ~ORGAN_BROKEN
		perma_injury = 0

	//Sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth()

	var/result = update_icon()
	return result

/*
This function completely restores a damaged organ to perfect condition.
*/
/datum/organ/external/proc/rejuvenate()
	damage_state = "00"
	if(status & 128)	//Robotic organs stay robotic.  Fix because right click rejuvinate makes IPC's organs organic.
		status = 128
	else
		status = 0
	perma_injury = 0
	brute_dam = 0
	burn_dam = 0
	germ_level = 0
	bandaged = 0
	painLW = 0
	wounds.Cut()
	number_wounds = 0

	// handle internal organs
	for(var/datum/organ/internal/current_organ in internal_organs)
		current_organ.rejuvenate()

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/weapon/implant))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.loc = owner.loc
			implants -= implanted_object

	owner.updatehealth()
	owner.UpdateBandageIcon()


/datum/organ/external/proc/createwound(var/type = CUT, var/damage)
	if(damage == 0) return

	//moved this before the open_wound check so that having many small wounds for example doesn't somehow protect you from taking internal damage (because of the return)
	//Possibly trigger an internal wound, too.

	// first check whether we can widen an existing wound
	if(wounds.len > 0 && prob(max(50+(number_wounds-1)*10,90)))
		if((type == CUT || type == BRUISE) && damage >= 5)
			//we need to make sure that the wound we are going to worsen is compatible with the type of damage...
			var/list/compatible_wounds = list()
			for (var/datum/wound/W in wounds)
				if (W.can_worsen(type, damage))
					compatible_wounds += W

			if(compatible_wounds.len)
				var/datum/wound/W = pick(compatible_wounds)
				W.open_wound(damage)
				if(prob(25))
					//maybe have a separate message for BRUISE type damage?
					owner.visible_message("<span class='combat'>The wound on</span> <span class='combatbold'>[owner.name]'s</span> <span class='combat'>[display_name] widens with a nasty ripping noise!</span>",\
					"<span class='combat'>The wound on your [display_name] widens with a nasty ripping noise.</span>",\
					"<span class='combat'>You hear a nasty ripping noise, as if flesh is being torn apart.</span>")
					playsound(owner, 'sound/effects/gore/flesh_born.ogg', 50, 0, -1)
				return

	//Creating wound
	var/wound_type = get_wound_type(type, damage)

	if(wound_type)
		var/datum/wound/W = new wound_type(damage)

		//Check whether we can add the wound to an existing wound
		for(var/datum/wound/other in wounds)
			if(other.can_merge(W))
				other.merge_wound(W)
				W = null // to signify that the wound was added
				break
		if(W)
			wounds += W

/****************************************************
			   PROCESSING & UPDATING
****************************************************/

//Determines if we even need to process this organ.

/datum/organ/external/proc/need_process()
	if(destspawn)	//Missing limb is missing
		return 0
	if(status && status != ORGAN_ROBOT) // If it's robotic, that's fine it will have a status.
		return 1
	if(brute_dam || burn_dam)
		return 1
	if(last_dam != brute_dam + burn_dam) // Process when we are fully healed up.
		last_dam = brute_dam + burn_dam
		return 1
	else
		last_dam = brute_dam + burn_dam
	if(germ_level)
		return 1
	return 0

/datum/organ/external/process()
	//Dismemberment
	if(istype(src, /datum/organ/external/hand/l_hand) && !is_usable())
		owner.drop_l_hand()
	else if(istype(src, /datum/organ/external/hand/r_hand) && !is_usable())
		owner.drop_r_hand()

	if(status & ORGAN_DESTROYED)
		if(!destspawn && config.limbs_can_break)
			droplimb()
		return
	if(parent)
		if(parent.status & ORGAN_DESTROYED)
			status |= ORGAN_DESTROYED
			owner.update_body(1)
			return

	// Process wounds, doing healing etc. Only do this every few ticks to save processing power
	if(owner.life_tick % wound_update_accuracy == 0)
		update_wounds()

	//Chem traces slowly vanish
	if(owner.life_tick % 10 == 0)
		for(var/chemID in trace_chemicals)
			trace_chemicals[chemID] = trace_chemicals[chemID] - 1
			if(trace_chemicals[chemID] <= 0)
				trace_chemicals.Remove(chemID)

	//Bone fracurtes
	if(!(status & ORGAN_BROKEN))
		perma_injury = 0

	//Infections
	update_germs()

//Updating germ levels. Handles organ germ levels and necrosis.
/*
The INFECTION_LEVEL values defined in setup.dm control the time it takes to reach the different
infection levels. Since infection growth is exponential, you can adjust the time it takes to get
from one germ_level to another using the rough formula:

desired_germ_level = initial_germ_level*e^(desired_time_in_seconds/1000)

So if I wanted it to take an average of 15 minutes to get from level one (100) to level two
I would set INFECTION_LEVEL_TWO to 100*e^(15*60/1000) = 245. Note that this is the average time,
the actual time is dependent on RNG.

INFECTION_LEVEL_ONE		below this germ level nothing happens, and the infection doesn't grow
INFECTION_LEVEL_TWO		above this germ level the infection will start to spread to internal and adjacent organs
INFECTION_LEVEL_THREE	above this germ level the player will take additional toxin damage per second, and will die in minutes without
						antitox. also, above this germ level you will need to overdose on spaceacillin to reduce the germ_level.

Note that amputating the affected organ does in fact remove the infection from the player's body.
*/
/datum/organ/external/proc/update_germs()

	if(status & (ORGAN_ROBOT|ORGAN_DESTROYED) || (owner.species && owner.species.flags & IS_PLANT)) //Robotic limbs shouldn't be infected, nor should nonexistant limbs.
		germ_level = 0
		return

	if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Syncing germ levels with external wounds
		handle_germ_sync()

		//** Handle antibiotics and curing infections
		handle_antibiotics()

		//** Handle the effects of infections
		handle_germ_effects()
	var/antibiotics = owner.reagents.get_reagent_amount("vaccine")
	if(antibiotics)
		for(var/datum/wound/W in wounds)
			if(W.germ_level < INFECTION_LEVEL_THREE)
				W.germ_level = 0

/datum/organ/external/proc/handle_germ_sync()
	var/antibiotics = owner.reagents.get_reagent_amount("vaccine")
	for(var/datum/wound/W in wounds)
		//Open wounds can become infected
		if (owner.germ_level > W.germ_level && W.infection_check())
			W.germ_level++

	if (antibiotics < 1)
		for(var/datum/wound/W in wounds)
			//Infected wounds raise the organ's germ level
			if (W.germ_level > germ_level)
				germ_level++
				break	//limit increase to a maximum of one per second

/datum/organ/external/proc/handle_germ_effects()
	var/antibiotics = owner.reagents.get_reagent_amount("vaccine")

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE && prob(60))	//this could be an else clause, but it looks cleaner this way
		germ_level--	//since germ_level increases at a rate of 1 per second with dirty wounds, prob(60) should give us about 5 minutes before level one.

	if(germ_level >= INFECTION_LEVEL_ONE)
		//having an infection raises your body temperature
		var/fever_temperature = (owner.species.heat_level_1 - owner.species.body_temperature - 5)* min(germ_level/INFECTION_LEVEL_TWO, 1) + owner.species.body_temperature
		//need to make sure we raise temperature fast enough to get around environmental cooling preventing us from reaching fever_temperature
		owner.bodytemperature += between(0, (fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, fever_temperature - owner.bodytemperature)

		if(prob(round(germ_level/10)))
			if (antibiotics < 1)
				germ_level++

			if (prob(10))	//adjust this to tweak how fast people take toxin damage from infections
				owner.adjustToxLoss(1)

	if(germ_level >= INFECTION_LEVEL_TWO && antibiotics < 1)
		//spread the infection to internal organs
		var/datum/organ/internal/target_organ = null	//make internal organs become infected one at a time instead of all at once
		for (var/datum/organ/internal/I in internal_organs)
			if (I.germ_level > 0 && I.germ_level < min(germ_level, INFECTION_LEVEL_TWO))	//once the organ reaches whatever we can give it, or level two, switch to a different one
				if (!target_organ || I.germ_level > target_organ.germ_level)	//choose the organ with the highest germ_level
					target_organ = I

		if (!target_organ)
			//figure out which organs we can spread germs to and pick one at random
			var/list/candidate_organs = list()
			for (var/datum/organ/internal/I in internal_organs)
				if (I.germ_level < germ_level)
					candidate_organs += I
			if (candidate_organs.len)
				target_organ = pick(candidate_organs)

		if (target_organ)
			target_organ.germ_level++

		//spread the infection to child and parent organs
		if (children)
			for (var/datum/organ/external/child in children)
				if (child.germ_level < germ_level && !(child.status & ORGAN_ROBOT))
					if (child.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
						child.germ_level++

		if (parent)
			if (parent.germ_level < germ_level && !(parent.status & ORGAN_ROBOT))
				if (parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
					parent.germ_level++

	if(germ_level >= INFECTION_LEVEL_THREE && antibiotics < 5)	//overdosing is necessary to stop severe infections
		if (!(status & ORGAN_DEAD))
			status |= ORGAN_DEAD
			owner << "<span class='notice'>You can't feel your [display_name] anymore...</span>"
			owner.update_body(1)

		germ_level++
		owner.adjustToxLoss(1)

//Updating wounds. Handles wound natural I had some free spachealing, internal bleedings and infections
/datum/organ/external/proc/update_wounds()

	if((status & ORGAN_ROBOT)) //Robotic limbs don't heal or get worse.
		return

	for(var/datum/wound/W in wounds)
		// wounds can disappear after 10 minutes at the earliest
		if(W.damage <= 0 && W.created + 10 * 10 * 60 <= world.time)
			wounds -= W
			continue
			// let the GC handle the deletion of the wound

		// Internal wounds get worse over time. Low temperatures (cryo) stop them.
		if(W.internal && owner.bodytemperature >= 170)
			var/bicardose = owner.reagents.get_reagent_amount("salglu_solution")
			var/epinephrine = owner.reagents.get_reagent_amount("epinephrine")
			if(!(W.can_autoheal() || (bicardose && epinephrine)))	//salglu_solution and epinephrine stop internal wounds from growing bigger with time, unless it is so small that it is already healing
				W.open_wound(0.1 * wound_update_accuracy)
			if(bicardose >= 30)	//overdose of salglu_solution begins healing IB
				W.damage = max(0, W.damage - 0.2)

			owner.vessel.remove_reagent("blood", wound_update_accuracy * W.damage/40) //line should possibly be moved to handle_blood, so all the bleeding stuff is in one place.
			if(prob(1 * wound_update_accuracy))
				owner.custom_pain("<span class='combat'>You feel a stabbing pain in your [display_name]!</span>",1)

		// slow healing
		var/heal_amt = 0

		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if (W.can_autoheal() && W.wound_damage() < 50)
			heal_amt += 0.5
			if(owner.sleeping && (owner.tryingtosleep || owner.death_door))
				heal_amt += 0.5

		//we only update wounds once in [wound_update_accuracy] ticks so have to emulate realtime
		heal_amt = heal_amt * wound_update_accuracy
		//configurable regen speed woo, no-regen hardcore or instaheal hugbox, choose your destiny
		if(mRegen in owner.mutations)
			heal_amt = heal_amt * 2
			if(config.organ_regeneration_multiplier > 1)
				heal_amt = heal_amt * config.organ_regeneration_multiplier
		else
			heal_amt = heal_amt * config.organ_regeneration_multiplier
		// amount of healing is spread over all the wounds
		heal_amt = heal_amt / (wounds.len + 1)
		// making it look prettier on scanners
		heal_amt = round(heal_amt,0.1)
		W.heal_damage(heal_amt)

		// Salving also helps against infection
		if(W.germ_level > 0 && W.salved && prob(2))
			W.disinfected = 1
			W.germ_level = 0

	// sync the organ's damage with its wounds
	src.update_damages()
	if (update_icon())
		owner.UpdateDamageIcon(1)

//Updates brute_damn and burn_damn from wound damages. Updates BLEEDING status.
/datum/organ/external/proc/update_damages()
	number_wounds = 0
	brute_dam = 0
	burn_dam = 0
	status &= ~ORGAN_BLEEDING
	var/clamped = 0

	var/mob/living/carbon/human/H
	if(istype(owner,/mob/living/carbon/human))
		H = owner

	for(var/datum/wound/W in wounds)
		if(W.damage_type == CUT || W.damage_type == BRUISE)
			brute_dam += W.damage
		else if(W.damage_type == BURN)
			burn_dam += W.damage

		if(!(status & ORGAN_ROBOT) && W.bleeding() && (H && !(H.species.flags & NO_BLOOD)))
			W.bleed_timer--
			status |= ORGAN_BLEEDING

		clamped |= W.clamped

		number_wounds += W.amount

	if (open && !clamped && (H && !(H.species.flags & NO_BLOOD)))	//things tend to bleed if they are CUT OPEN
		status |= ORGAN_BLEEDING


// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
/datum/organ/external/proc/update_icon()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	return 0

// new damage icon system
// returns just the brute/burn damage code
/datum/organ/external/proc/damage_state_text()
	if(status & ORGAN_DESTROYED)
		return "--"

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (burn_dam < (max_damage * 0.25 / 2))
		tburn = 1
	else if (burn_dam < (max_damage * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (brute_dam == 0)
		tbrute = 0
	else if (brute_dam < (max_damage * 0.10 / 2))
		tbrute = 1
	else if (brute_dam < (max_damage * 0.25 / 2))
		tbrute = 2
	else
		tbrute = 3

	return "[tbrute][tburn]"

/****************************************************
			   DISMEMBERMENT
****************************************************/

//Recursive setting of all child organs to amputated
/datum/organ/external/proc/setAmputatedTree()
	for(var/datum/organ/external/O in children)
		O.amputated=amputated
		O.setAmputatedTree()

//Handles dismemberment
/datum/organ/external/proc/droplimb(var/override = 0,var/no_explode = 0, var/gibbed = 0, var/no_organ_item = FALSE)
	if(destspawn) return
	if(override)
		status |= ORGAN_DESTROYED
	if(status & ORGAN_DESTROYED)
		if(body_part == UPPER_TORSO)
			return

		src.status &= ~ORGAN_BROKEN
		src.status &= ~ORGAN_BLEEDING//a
		src.status &= ~ORGAN_SPLINTED
		src.status &= ~ORGAN_DEAD
		for(var/implant in implants)
			qdel(implant)

		germ_level = 0

		//Replace all wounds on that arm with one wound on parent organ.
		for(var/W in wounds)
			wounds.Remove(W)
			qdel(W)
		//why is this on the parent?
		//if (parent)
		//	if(!(parent.status & ORGAN_DESTROYED))
		//I mean the check makes sense
		if(parent)
			var/datum/wound/W
			W = new/datum/wound/lost_limb(0, max_damage, 0, src)
			wounds += W
			update_damages()
		update_damages()
		if(!amputated)
			sever_artery()
			owner.UpdateArteryIcon()

		// If any organs are attached to this, destroy them
		for(var/datum/organ/external/O in children)
			if(O.children)
				for(var/datum/organ/external/OO in O.children)
					OO.droplimb(1)
			O.droplimb(1)

		var/obj/organ	//Dropped limb object
		destspawn = 1
		//Robotic limbs explode if sabotaged.
		if(status & ORGAN_ROBOT && !no_explode && sabotaged)
			owner.visible_message("\red \The [owner]'s [display_name] explodes violently!",\
			"\red <b>Your [display_name] explodes!</b>",\
			"You hear an explosion!")
			explosion(get_turf(owner),-1,-1,2,3)
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, owner)
			spark_system.attach(owner)
			spark_system.start()
			spawn(10)
				qdel(spark_system)

		if(!gibbed && !istype(owner, /mob/living/carbon/human/monster))
			switch(body_part)
				if(HEAD)
					if(!no_organ_item)
						organ= new/obj/item/weapon/organ/head(owner.loc, owner)
						//organ = H
					owner.u_equip(owner.glasses)
					owner.u_equip(owner.head)
					owner.u_equip(owner.l_ear)
					owner.u_equip(owner.r_ear)
					owner.u_equip(owner.wear_mask)
					owner.death(1)
				if(ARM_RIGHT)
					if(!no_organ_item)
						organ= new /obj/item/weapon/organ/r_arm(owner.loc, owner)
					owner.u_equip(owner.r_hand)
					owner.u_equip(owner.gloves)
				if(ARM_LEFT)
					if(!no_organ_item)
						organ= new /obj/item/weapon/organ/l_arm(owner.loc, owner)
					owner.u_equip(owner.l_hand)
					owner.u_equip(owner.gloves)
				if(LEG_RIGHT)
					if(!no_organ_item)
						organ= new /obj/item/weapon/organ/r_leg(owner.loc, owner)
				if(LEG_LEFT)
					if(!no_organ_item)
						organ= new /obj/item/weapon/organ/l_leg(owner.loc, owner)

				if(HAND_RIGHT)
					owner.u_equip(owner.gloves)
					owner.u_equip(owner.r_hand)
				if(HAND_LEFT)
					owner.u_equip(owner.gloves)
					owner.u_equip(owner.l_hand)
				if(FOOT_RIGHT)
					if(!no_organ_item)
						organ= new /obj/item/weapon/organ/r_foot(owner.loc, owner)
					owner.u_equip(owner.shoes)
				if(FOOT_LEFT)
					if(!no_organ_item)
						organ= new /obj/item/weapon/organ/l_foot(owner.loc, owner)
					owner.u_equip(owner.shoes)
				if(MOUTH)
					if(!no_organ_item)
						organ = new/obj/item/weapon/organ/jaw(owner.loc)
					owner.u_equip(owner.wear_mask)
				if(FACE)
					owner.u_equip(owner.glasses)

			if(!amputated)
				owner.visible_message("<span class='graytextbold'> [capitalize(owner.name)]'s [display_name] flies off in bloody arc!</span> ")
				playsound(owner, "chop", 50, 1, -1)

			if(organ)
				if(istype(owner, /mob/living/carbon/human/skinless))
					organ.icon = 'icons/monsters/subhuman.dmi'
				//Throw organs around
				var/lol = pick(cardinal)
				step(organ,lol)
			owner.update_body(1)

			// OK so maybe your limb just flew off, but if it was attached to a pair of cuffs then hooray! Freedom!
			release_restraints()

			if(vital)
				owner.death()

			var/turf/location = organ?.loc
			if (istype(location, /turf/simulated))
				location.add_blood(owner)
			return

		else if(!istype(owner, /mob/living/carbon/human/monster))//This is if their limb is gibbed.
			switch(body_part)
				if(HEAD)
					owner.u_equip(owner.glasses)
					owner.u_equip(owner.head)
					owner.u_equip(owner.l_ear)
					owner.u_equip(owner.r_ear)
					owner.u_equip(owner.wear_mask)
					owner.h_style = "Bald"
					owner.update_hair()
					owner.death(1)
					owner.ghostize(1)
				if(HAND_RIGHT)
					owner.u_equip(owner.gloves)
				if(HAND_LEFT)
					owner.u_equip(owner.gloves)
				if(FOOT_RIGHT)
					owner.u_equip(owner.shoes)
				if(FOOT_LEFT)
					owner.u_equip(owner.shoes)



			owner.visible_message("<span class='graytextbold'> [capitalize(owner.name)]'s [display_name] blasts into gore!</span> ")
			playsound(owner, 'sound/effects/gore/gore.ogg', 70, 1)
			PoolOrNew(/obj/effect/decal/cleanable/blood/gibs/normal, owner.loc)



			owner.update_body(1)
			owner.UpdateArteryIcon()

			// OK so maybe your limb just flew off, but if it was attached to a pair of cuffs then hooray! Freedom!
			release_restraints()

			if(vital)
				owner.death()

			var/turf/location = owner.loc
			if (istype(location, /turf/simulated))
				location.add_blood(owner)
				PoolOrNew(/obj/effect/decal/cleanable/blood/gibs, location)

/****************************************************
			   HELPERS
****************************************************/

/datum/organ/external/proc/release_restraints()
	if (owner.handcuffed && body_part in list(ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT))
		owner.visible_message(\
			"\The [owner.handcuffed.name] falls off of [owner.name].",\
			"\The [owner.handcuffed.name] falls off you.")

		owner.drop_from_inventory(owner.handcuffed)

	if (owner.legcuffed && body_part in list(FOOT_LEFT, FOOT_RIGHT, LEG_LEFT, LEG_RIGHT))
		owner.visible_message(\
			"\The [owner.legcuffed.name] falls off of [owner.name].",\
			"\The [owner.legcuffed.name] falls off you.")

		owner.drop_from_inventory(owner.legcuffed)

/datum/organ/external/proc/bandage()
	var/rval = 0
	src.status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.bandaged
		W.bandaged = 1
	return rval

/datum/organ/external/proc/disinfect()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.disinfected
		W.disinfected = 1
		W.germ_level = 0
	return rval

/datum/organ/external/proc/clampe()
	var/rval = 0
	src.status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.clamped
		W.clamped = 1
	return rval

/datum/organ/external/proc/salve()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.salved
		W.salved = 1
	return rval

/datum/organ/external/proc/mayhit()
	if(status & ORGAN_DESTROYED & ORGAN_BLEEDING & ORGAN_SPLINTED & ORGAN_DEAD)
		return
	return 1

/datum/organ/external/proc/fracture()

	if(status & ORGAN_BROKEN)
		return

	playsound(owner, "trauma", 75, 0)

	if(owner.species && !(owner.species.flags & NO_PAIN) && !(owner.status_flags & STATUS_NO_PAIN))
		owner.emote("agonypain")

	status |= ORGAN_BROKEN
	broken_description = pick("broken","fracture","hairline fracture")
	perma_injury = brute_dam

	// Fractures have a chance of getting you out of restraints
	if (prob(25))
		release_restraints()

	// This is mostly for the ninja suit to stop ninja being so crippled by breaks.
	// TODO: consider moving this to a suit proc or process() or something during
	// hardsuit rewrite.
	if(!(status & ORGAN_SPLINTED) && istype(owner,/mob/living/carbon/human))

		var/mob/living/carbon/human/H = owner

		if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))

			var/obj/item/clothing/suit/space/suit = H.wear_suit

			if(isnull(suit.supporting_limbs))
				return

			owner << "You feel \the [suit] constrict about your [display_name], supporting it."
			status |= ORGAN_SPLINTED
			suit.supporting_limbs |= src
	return 1

/datum/organ/external/proc/cripple_ize(var/amountInSeconds = 30)

	cripple_left += amountInSeconds

	return 1


/datum/organ/external/proc/tendon_ize()

	if(status & ORGAN_TENDON){return} //nao da pra quebrar algo quebrado


	status |= ORGAN_TENDON

	return 1

/datum/organ/external/proc/robotize()
	src.status &= ~ORGAN_BROKEN
	src.status &= ~ORGAN_BLEEDING
	src.status &= ~ORGAN_SPLINTED
	src.status &= ~ORGAN_CUT_AWAY
	src.status &= ~ORGAN_ATTACHABLE
	src.status &= ~ORGAN_DESTROYED
	src.status |= ORGAN_ROBOT
	src.destspawn = 0
	for (var/datum/organ/external/T in children)
		if(T)
			T.robotize()

/datum/organ/external/proc/mutate()
	src.status |= ORGAN_MUTATED
	owner.update_body()

/datum/organ/external/proc/unmutate()
	src.status &= ~ORGAN_MUTATED
	owner.update_body()

/datum/organ/external/proc/get_damage()	//returns total damage
	return max(brute_dam + burn_dam - perma_injury, perma_injury)	//could use health?

/datum/organ/external/proc/has_infected_wound()
	for(var/datum/wound/W in wounds)
		if(W.germ_level > INFECTION_LEVEL_ONE)
			return 1
	return 0

/datum/organ/external/get_icon(var/icon/race_icon, var/icon/deform_icon,gender="", var/fat, var/lfwblocked = 0)
	if(!(istype(owner.species, /datum/species/human)) && !(istype(owner.species, /datum/species/human/zombie)))
		gender=""
		fat = 0
/*
	if(!istype(src, /datum/organ/external/chest) && fat)
		fat = 0
		gender=""
*/
	if (status & ORGAN_ROBOT && !(owner.species && owner.species.flags & IS_SYNTHETIC))
		return new /icon('icons/mob/human_races/robotic.dmi', "[icon_name][gender ? "_[gender]" : ""]")

	if (status & ORGAN_MUTATED)
		return new /icon(deform_icon, "[icon_name][gender ? "_[gender]" : ""][fat ? "_fat" : ""]")

	if (lfwblocked)
		return new /icon(race_icon, "[icon_name][gender ? "_[gender]" : ""][fat ? "_fat" : ""][lfwblockedicon ? "_c" : ""]")

	return new /icon(race_icon, "[icon_name][gender ? "_[gender]" : ""][fat ? "_fat" : ""]")


/datum/organ/external/proc/is_usable()
	if(cripple_left > 0)
		return 0
	return !(status & (ORGAN_DESTROYED|ORGAN_MUTATED|ORGAN_DEAD|ORGAN_CUT_AWAY|ORGAN_TENDON) || !(painLW < pain_disability_threshold) || (fingers.len && get_fingers() < 2) || (fingers.len && get_broken_fingers() > 3))



/datum/organ/external/proc/is_broken()
	return ((status & ORGAN_BROKEN) && !(status & ORGAN_SPLINTED))

/datum/organ/external/proc/is_malfunctioning()
	return ((status & ORGAN_ROBOT) && prob(brute_dam + burn_dam))

//for arms and hands
/datum/organ/external/proc/process_grasp(var/obj/item/c_hand, var/hand_name)
	if (!c_hand)
		return

	if(is_broken())
		owner.u_equip(c_hand)
		var/emote_scream = pick("screams in pain and", "lets out a sharp cry and", "cries out and")
		owner.visible_message("<span class='combat'>[((owner.species && owner.species.flags & NO_PAIN) || (owner.status_flags & STATUS_NO_PAIN)) ? "" : emote_scream ] drops what they were holding in their [hand_name]!</span>")
	if(is_malfunctioning())
		owner.u_equip(c_hand)
		owner.emote("me", 1, "drops what they were holding, their [hand_name] malfunctioning!")
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, owner)
		spark_system.attach(owner)
		spark_system.start()
		spawn(10)
			qdel(spark_system)

/datum/organ/external/proc/sever_artery()
	if(!(status & ORGAN_ARTERY) && src.parent)
		status |= ORGAN_ARTERY
		if(src?.children?.status & ORGAN_ARTERY && src?.children?.status & ORGAN_DESTROYED)
			src.children.status &= ~ORGAN_ARTERY
		if(src.parent.status & ORGAN_DESTROYED)
			src.status &= ~ORGAN_ARTERY
		if(artery_name == "carotid artery")
			var/sound = list('sound/lfwbsounds/throat.ogg', 'sound/lfwbsounds/throat2.ogg', 'sound/lfwbsounds/throat3.ogg')
			playsound(owner.loc, 'sound/lfwbsounds/blood_splat.ogg', 100, 0)
			playsound(owner.loc, pick(sound), 50, 1, -1)
			owner.UpdateArteryIcon()
		else
			playsound(owner.loc, 'sound/lfwbsounds/blood_splat.ogg', 100, 0)
		return TRUE
	return FALSE

/datum/organ/external/proc/embed(var/obj/item/weapon/W, var/silent = 0)
	if(!silent)
		owner.visible_message("<span class='combatbold'>\The [W] sticks in the wound!</span>")
	implants += W
	owner.embedded_flag = 1
	owner.verbs += /mob/proc/yank_out_object
	owner.update_icons()
	owner.update_embedhit()
	W.add_blood(owner)
	if(ismob(W.loc))
		var/mob/living/H = W.loc
		H.drop_item()
	if(W) // Some items are destroyed when dropped
		W.loc = owner

/datum/organ/external/proc/get_fingers()
	var/amt = 0
	if(!fingers.len)
		return 0
	for(var/i = 0; i < fingers.len; i++)
		amt++

	return amt

/datum/organ/external/proc/get_broken_fingers()
	var/amt = 0
	if(!fingers.len)
		return 0
	for(var/obj/item/weapon/organ/finger/F in fingers)
		if(F.state == "BROKEN")
			amt++

	return amt

/datum/organ/external/proc/get_lost_fingers_number()
	var/amt = 0
	if(!fingers.len)
		return 5

	for(var/x in digit_check)
		var/test = 1
		for(var/obj/item/weapon/organ/finger/F in fingers)
			if(F.name != x)
				test = 0
				continue
			test = 1
			break
		if(!test)
			amt ++
	return amt

/datum/organ/external/proc/get_lost_fingers_text()
	var/list/amt = list()

	if(!fingers.len)
		return list("ALL FINGERS MISSING!")

	for(var/x in digit_check)
		var/test = 1
		for(var/obj/item/weapon/organ/finger/F in fingers)
			if(F.name != x)
				test = 0
				continue
			test = 1
			break
		if(!test)
			amt += x


	return amt

/datum/organ/external/proc/get_fucked_up()
	var/amt = list()

	if(!fingers.len)
		return list("<span class='missingnew'>ALL FINGERS MISSING!</span>")

	for(var/x in digit_check)
		var/test = 1
		for(var/obj/item/weapon/organ/finger/F in fingers)
			if(F.name != x)
				test = 0
				continue
			test = 1
			break

		if(!test)
			amt += "<span class='missingnew'><big>[uppertext(x)] MISSING</big></span>"

	for(var/obj/item/weapon/organ/finger/F in fingers)
		if(F.state == "BROKEN")
			amt += "<span class='missingnew'><big>[uppertext(F.name)] BROKEN</big></span>"

	return amt

/datum/organ/external/proc/ripout_fingers(throw_dir, num=32) //Won't support knocking teeth out of a dismembered head or anything like that yet.
	if(ismonster(owner))
		return
	num = Clamp(num, 1, 32)
	var/done = 0
	if(fingers && fingers.len) //We still have teeth
		var/lostfingers = rand(1,3)
		for(var/i, i <= lostfingers, i++) //Random amount of teeth stacks
			var/obj/item/weapon/organ/finger/F = pick(fingers)
			fingers -= F
			playsound(owner, "chop", 50, 1, -1)
			owner.visible_message("<span class='graytextbold'> [capitalize(owner.name)]'s [F] flies off in bloody arc!</span> ")
			F.loc = owner.loc
			var/turf/target = get_turf(owner.loc)
			var/range = rand(1, 3)
			for(var/j = 1; j < range; j++)
				var/turf/new_turf = get_step(target, throw_dir)
				target = new_turf
				if(new_turf.density)
					break
			F.throw_at(get_edge_target_turf(F,pick(alldirs)),rand(1,3),30)
			F.loc:add_blood(owner)
			done = 1
	return done

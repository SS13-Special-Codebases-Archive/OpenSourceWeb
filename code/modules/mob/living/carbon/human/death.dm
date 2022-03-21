//////////////////////////
////////HOLY WAR//////////
//////////////////////////
var/pc_casualties = 0
var/th_casualties = 0
var/holy_battle_end = FALSE
/mob/living/carbon/human/var/isbomber = FALSE
/mob/living/carbon/human/var/deathcounted = FALSE

/mob/living/carbon/human/gib()
	death(1)
	gibbed_people += "\n &#8226; [src.real_name] ([src.old_job]) : [src.old_key]\n"
	var/area/dunwell/AffectedArea = get_area(src)
	firstvictimCheck()
	if(AffectedArea == /area/dunwell/station)
		deathinfort += 1
	else
		deathincave += 1

	if(outsider)
		migrantsdied += 1
	var/atom/movable/overlay/animation = null
	monkeyizing = 1
	canmove = 0
	buried = TRUE
	icon = null
	invisibility = 101
	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	for(var/datum/organ/external/E in src.organs)
		if(istype(E, /datum/organ/external/chest))
			for(var/obj/item/weapon/reagent_containers/food/snacks/organ/O in organ_storage)
				if(prob(100 - (O.max_health - O.health)))
					organ_storage.remove_from_storage(O, src.loc)
			continue
		// Only make the limb drop if it's not too damaged
		if(prob(100 - E.get_damage()))
			// Override the current limb status and don't cause an explosion
			E.droplimb(1,1)
	src << 'death_sound.ogg'
	ghostize(1)
	if(!pain_dropped)
		new /obj/structure/wraith_pain(src.loc)
		pain_dropped = TRUE
	flick("gibbed-h", animation)
	if(species)
		hgibs(loc, viruses, dna, species.flesh_color, species.blood_color)
	else
		hgibs(loc, viruses, dna)

/*	if(virtual)
		usr << "\red <b>You died. Game over. Returning to the real world...</b>"
		sleep(80)
		return_VR()
*/
	spawn(15)
		if(organ_storage)
			qdel(organ_storage)
			organ_storage = null
		if(animation)	qdel(animation)
		if(src)			qdel(src)

/mob/living/carbon/human/proc/fakegib()
	death(1)
	var/area/dunwell/AffectedArea = get_area(src)
	firstvictimCheck()
	if(AffectedArea == /area/dunwell/station)
		deathinfort += 1
	else
		deathincave += 1

	if(outsider)
		migrantsdied += 1
	var/atom/movable/overlay/animation = null
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101
	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src
	src << 'death_sound.ogg'
	if(!pain_dropped)
		new /obj/structure/wraith_pain(src.loc)
		pain_dropped = TRUE
	flick("gibbed-h", animation)
	if(species)
		hgibs(loc, viruses, dna, species.flesh_color, species.blood_color)
	else
		hgibs(loc, viruses, dna)

/*	if(virtual)
		usr << "\red <b>You died. Game over. Returning to the real world...</b>"
		sleep(80)
		return_VR()
*/
	spawn(15)
		if(animation)	qdel(animation)
		if(src)			qdel(src)

/mob/living/carbon/human/dust()
	death(1)
	var/atom/movable/overlay/animation = null
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src
	sound_to(src, sound('death_sound.ogg', repeat = 0, wait = 0, volume = 50))
	flick("dust-h", animation)
	ghostize(1)
	if(!pain_dropped)
		new /obj/structure/wraith_pain(src.loc)
		pain_dropped = TRUE
	new /obj/effect/decal/remains/human(loc)

	spawn(15)
		if(animation)	qdel(animation)
		if(src)			qdel(src)


/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)	return
	if(healths)		healths.icon_state = "health5"

	stat = DEAD
	if(get_pain() >= 180 && prob(25))
		handle_shit()
		handle_piss()
	dizziness = 0
	if(!pain_dropped)
		new /obj/structure/wraith_pain(src.loc)
		pain_dropped = TRUE
	if(src.job == "Pusher")
		for(var/obj/machinery/information_terminal/INFO in vending_list)
			INFO.despusherize()
	jitteriness = 0
	src.combat_mode = 0
	var/datum/organ/external/missinghead = src:get_organ("head")
	src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 12)
	var/area/dunwell/AffectedArea = get_area(src)
	firstvictimCheck()
	if(AffectedArea?.fort && !deathcounted && !istype(src, /mob/living/carbon/human/bumbot))
		deathinfort += 1
	else
		if(!deathcounted && !istype(src, /mob/living/carbon/human/bumbot))
			deathincave += 1
	if(outsider)
		migrantsdied += 1
	if(master_mode != "holywar")
		deathcounted = TRUE

	var/list/deathAlarmList = list("Baron", "Successor", "Heir", "Baroness")

	if(src.job in deathAlarmList)
		var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)// BS12 EDIT Arrivals Announcement Computer, rather than the AI.
		a.autosay("Alert: An important noble person has died.", "Firethorn CTTU")
		for(var/obj/item/device/radio/intercom/I in intercoms)
			playsound(I, 'sound/lfwbsounds/death_alarm.ogg', 50)
	if(AffectedArea?.name == "Dungeon")
		var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)// BS12 EDIT Arrivals Announcement Computer, rather than the AI.
		for(var/obj/item/device/radio/intercom/I in intercoms)
			playsound(I, 'sound/lfwbsounds/death_alarm.ogg', 50)
		a.autosay("Alert: A prisoner has died in the dungeon.", "Firethorn CTTU")
		src.client.ChromieWinorLoose(src.client, -1)

	if(ticker?.eof?.id == "buryyourdead" && (!iszombie(src)|| AffectedArea?.name == "Surface") && !iszombie(src) && !istype(src:species, /datum/species/human/alien) && ticker.mode.config_tag != "miniwar")
		if(missinghead in src.organs)
			to_chat(src, "You're preparing to walk again.")
			src.zombie_infect()
		else
			to_chat(src, "You won't rise again.")
			death(1)
			ghostize(1)

	if(master_mode == "holywar")
		if(src.religion == "Gray Church")
			if(pc_casualties < 30 && !holy_battle_end && !deathcounted)
				pc_casualties++
				deathcounted = TRUE
				to_chat(world, "<font size=5>[pc_casualties]/30 P.C CASUALTIES</font>")
			else
				if(pc_casualties >= 30 && !holy_battle_end)
					to_chat(world, "<span class='dreamershitbutitsbigasfuck'>THANATI VICTORY</span>")
					holy_battle_end = TRUE
					roundendready = TRUE
					for(var/mob/living/carbon/human/H in mob_list)
						if(H.religion == "Thanati")
							H.client.ChromieWinorLoose(H.client, 3)
							H.unlock_medal("Tzchernobog Devotee", 0, "Fought for Tzchernobog in the Holy war and won.", "10")
						else
							H.client.ChromieWinorLoose(H.client, -1)
					world << 'war_banner.ogg'
					ticker.declare_completion()
		else
			if(!isbomber && th_casualties < 40 && !holy_battle_end && !deathcounted)
				th_casualties++
				deathcounted = TRUE
				to_chat(world, "<font size=5>[th_casualties]/40 THANATI CASUALTIES</font>")
			else
				if(th_casualties >= 40 && !holy_battle_end)
					to_chat(world, "<span class='dreamershitbutitsbigasfuck'>P.C VICTORY</span>")
					holy_battle_end = TRUE
					roundendready = TRUE
					for(var/mob/living/carbon/human/H in mob_list)
						if(H.religion == "Gray Church")
							H.client.ChromieWinorLoose(H.client, 3)
							H.unlock_medal("God's Martyr", 0, "Fought for the Comatic in the Holy war and won.", "9")
						else
							H.client.ChromieWinorLoose(H.client, -1)
					world << 'war_banner.ogg'
					ticker.declare_completion()

	if(src.job == "Baron")
		for(var/mob/living/carbon/human/H in mob_list)
			if(H?.outsider == FALSE && H?.mind?.special_role != "tiamatrait" && !H?.siegesoldier)
				H?.add_event("deadbaron", /datum/happiness_event/misc/barondead)
	if(april_fools)
		playsound(src.loc, pick('worm_death.ogg'), 60, 0, -1)

	for(var/mob/living/carbon/human/HHHH in mob_list)
		if(excomunicated)
			HHHH.clear_event("[uppertext(src.real_name)]excom")

	if(!ismonster(src) && !iszombie(src))
		for(var/mob/living/carbon/human/HHH in range(src,9))
			if(is_dreamer(HHH))
				continue
			if(src.religion != "Thanati" && HHH.religion == "Thanati")
				HHH.add_event("thanati", /datum/happiness_event/thanati)
				continue
			if(excomunicated && HHH.religion == "Gray Church")
				HHH.add_event("[uppertext(src.real_name)]excom", /datum/happiness_event/excomdead)
				continue
			if(!src.gender == FEMALE || !isChild(src))
				continue
			if(!HHH.terriblethings)
				HHH.add_event("die", /datum/happiness_event/disgust/death)
			if(HHH.vice == "Sensitivity")
				if(prob(80))
					HHH.vomit()
					if(prob(80))
						HHH.emote(pick("scream","cry"))
						HHH.stat = 1
	src << 'death_sound.ogg'
	if(src.client)
		blinded = 0
		client?.screen -= global_hud?.blind//blind.layer = 0
		reset_zoom()
		animate(client, color = NOIRLIST, time = 10)

	//Handle species-specific deaths.
	if(src.isVampire)
		var/atom/movable/overlay/animation = null
		monkeyizing = 1
		canmove = 0
		icon = null
		invisibility = 101

		animation = new(loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick("dust-h", animation)
		spawn(3)
			new /obj/effect/decal/remains/human(loc)
			qdel(src)

	if(species) species.handle_death(src)

	//Handle brain slugs.
	var/datum/organ/external/head = get_organ("head")
	var/mob/living/simple_animal/borer/B

	for(var/I in head.implants)
		if(istype(I,/mob/living/simple_animal/borer))
			B = I
	if(B)
		if(!B.ckey && ckey && B.controlling)
			B.ckey = ckey
			B.controlling = 0
		if(B.host_brain.ckey)
			ckey = B.host_brain.ckey
			B.host_brain.ckey = null
			B.host_brain.name = "host brain"
			B.host_brain.real_name = "host brain"

		verbs -= /mob/living/carbon/proc/release_control

	//Check for heist mode kill count.
	if(ticker.mode && ( istype( ticker.mode,/datum/game_mode/heist) ) )
		//Check for last assailant's mutantrace.
		/*if( LAssailant && ( istype( LAssailant,/mob/living/carbon/human ) ) )
			var/mob/living/carbon/human/V = LAssailant
			if (V.dna && (V.dna.mutantrace == "vox"))*/ //Not currently feasible due to terrible LAssailant tracking.
		//world << "Vox kills: [vox_kills]"
		vox_kills++ //Bad vox. Shouldn't be killing humans.

	if(is_dreamer(src))
		spawn(150)
			var/mob/living/carbon/human/H = pick(SeenWonder)
			H.Loucura()

	if(src.job == "Francisco's Advisor")
		roundendready = TRUE
		//ticker.declare_completion()
		to_chat(world, "<br>")
		to_chat(world, "<span class='ravenheartfortress'>Francisco's Notice</span>")
		to_chat(world, "<span class='excomm'>¤The Francisco's Advisor [src.real_name] is dead, His bodyguards must exterminate the remaining habitants of the Fortress!¤</span>")
		world << sound('sound/AI/bell_toll.ogg')
		to_chat(world, "<br>")
		to_chat(world, "<span class='decree'>New Viscount's decree!</span>")
		to_chat(world, "<br>")
		for(var/mob/living/carbon/human/H in player_list)
			if(H.religion == "Thanati")
				H.client.ChromieWinorLoose(H.client, 1)
			else if(H.outsider == 1)
				return
			else
				H.client.ChromieWinorLoose(H.client, -1)

		//update_canmove()
		//if(client)	blind.layer = 0
	if(ticker?.mode.config_tag == "siege")
		var/datum/game_mode/siege/S = ticker.mode
		if(job == "Count")
			roundendready = TRUE
			S.result = SIEGE_FAILED_COUNT
		switch(migclass)
			if("Blacksmith")
				S.blacksmithsiege -= 1
				if((S.maxblacksmithsiege > S.blacksmithsiege) && S.hasblacksmithsiege)
					S.hasblacksmithsiege = FALSE
			if("Alchemist")
				S.hasalchemistsiege = FALSE
		if(siegesoldier)
			S.losses++
			if(S.losses >= S.max_losses)
				S.result = SIEGE_FAILED_REINFORCEMENT
				roundendready = TRUE
	else if(ticker?.mode.config_tag == "miniwar")
		var/datum/game_mode/miniwar/M = ticker.mode
		if(src in M.south_team)
			if(M.south_count >= (M.max_count - 1))
				M.result = SOUTH_VICTORY
				roundendready = TRUE
			else
				M.south_team -= src
				M.south_count++
		else if(src in M.north_team)
			if(M.north_count >= (M.max_count - 1))
				M.result = NORTH_VICTORY
				roundendready = TRUE
			else
				M.north_team -= src
				M.north_count++

	sound_to(src, sound('death_sound.ogg', repeat = 0, wait = 0, volume = 50))

	//tod = worldtime2text()		//weasellos time of death patch
	//if(mind)	mind.store_memory("Time of death: [tod]", 0)
	if(ticker && ticker.mode)
//		world.log << "k"
		ticker.mode.check_win()		//Calls the rounds wincheck, mainly for wizard, malf, and changeling now

/*	if(virtual)
		usr << "\red <b>You died. Game over. Returning to the real world...</b>"
		sleep(80)
		return_VR()
*/
	if(special == "screamercurse" && !istype(species, /datum/species/human/zombie))
		becoming_zombie = TRUE
		zombify = 500

	return ..(gibbed)



/mob/living/carbon/human/proc/makeSkeleton()
	if("Skeleton" in src.species)	return
	if(iszombie(src)) return

	if(f_style)
		f_style = "Shaved"
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	src.set_species("Skeleton")
	mutations.Add(NOCLONE)
	status_flags |= DISFIGURED
	update_body(0)
	src.vessel.total_volume = 0
	var/datum/reagent/blood/B = pick(src.vessel.reagent_list)
	B.volume = 0

/*	for(var/obj/item/weapon/reagent_containers/food/snacks/organ/O in src.organ_storage)
		qdel(O)*/
	return

/mob/living/carbon/human/proc/ChangeToHusk()
	if(HUSK in mutations)	return

	if(f_style)
		f_style = "Shaved"		//we only change the icon_state of the hair datum, so it doesn't mess up their UI/UE
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	mutations.Add(HUSK)
	status_flags |= DISFIGURED	//makes them unknown without fucking up other stuff like admintools
	update_body(0)
	return

/mob/living/carbon/human/proc/Drain()
	ChangeToHusk()
	mutations |= NOCLONE
	return

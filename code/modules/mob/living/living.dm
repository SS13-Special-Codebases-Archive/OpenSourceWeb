/mob/living/verb/succumb()
	set hidden = 1
	if ((src.health < 0 && src.health > -95.0))
		src.adjustOxyLoss(src.health + 200)
		src.health = 100 - src.getOxyLoss() - src.getToxLoss() - src.getFireLoss() - src.getBruteLoss()
		to_chat(src, "<span class='passive'>You have given up life and succumbed to death.</span>")

/mob/living/Destroy()
	living_mob_list -= src
	..()

/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
	else
		health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss


//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(var/pressure)
	return 0


//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	if(istype(src, /mob/living/carbon/human))
		//world << "DEBUG: burn_skin(), mutations=[mutations]"
		if(mShock in src.mutations) //shockproof
			return 0
		if (COLD_RESISTANCE in src.mutations) //fireproof
			return 0
		var/mob/living/carbon/human/H = src	//make this damage method divide the damage to be done among all the body parts, then burn each body part for that much damage. will have better effect then just randomly picking a body part
		var/divided_damage = (burn_amount)/(H.organs.len)
		var/extradam = 0	//added to when organ is at max dam
		for(var/datum/organ/external/affecting in H.organs)
			if(!affecting)	continue
			if(affecting.take_damage(0, divided_damage+extradam))	//TODO: fix the extradam stuff. Or, ebtter yet...rewrite this entire proc ~Carn
				H.UpdateDamageIcon()
		H.updatehealth()
		return 1
	else if(istype(src, /mob/living/carbon/monkey))
		if (COLD_RESISTANCE in src.mutations) //fireproof
			return 0
		var/mob/living/carbon/monkey/M = src
		M.adjustFireLoss(burn_amount)
		M.updatehealth()
		return 1
	else if(istype(src, /mob/living/silicon/ai))
		return 0

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
//	if(istype(src, /mob/living/carbon/human))
//		world << "[src] ~ [src.bodytemperature] ~ [temperature]"
	return temperature


// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn
// I touched them without asking... I'm soooo edgy ~Erro (added nodamage checks)

/mob/living/proc/getBruteLoss()
	return bruteloss

/mob/living/proc/adjustBruteLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	bruteloss = min(max(bruteloss + amount, 0),(maxHealth*2))


/mob/living/proc/getStaminaLoss()//Stamina shit.
	return stamina_loss

/mob/living/proc/adjustStaminaLoss(var/amount)
	if(status_flags & GODMODE)	return 0
	stamina_loss = min(max(stamina_loss + amount, 0),(maxHealth*2))

/mob/living/carbon/human/adjustStaminaLoss(var/amount)
	if(status_flags & GODMODE)	return 0
	if(check_perk(/datum/perk/morestamina))
		if(amount > 5)
			amount -= rand(4,5)
	/*if(check_perk(/datum/perk/lessstamina))
		amount += rand(1,3)*/
	stamina_loss = min(max(stamina_loss + amount, 0),(maxHealth*2))

/mob/living/proc/setStaminaLoss(var/amount)
	if(status_flags & GODMODE)	return 0
	stamina_loss = amount

//stamina shit end
/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	oxyloss = min(max(oxyloss + amount, 0),(maxHealth*2))

/mob/living/proc/setOxyLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	oxyloss = amount

/mob/living/proc/getToxLoss()
	return toxloss



/mob/living/proc/adjustToxLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	toxloss = min(max(toxloss + amount, 0),(maxHealth*2))

/mob/living/proc/setToxLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	toxloss = amount

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/adjustFireLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	fireloss = min(max(fireloss + amount, 0),(maxHealth*2))

/mob/living/proc/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	cloneloss = min(max(cloneloss + amount, 0),(maxHealth*2))

/mob/living/proc/setCloneLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	cloneloss = amount

/mob/living/proc/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	brainloss = min(max(brainloss + amount, 0),(maxHealth*2))

/mob/living/proc/setBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	brainloss = amount

/mob/living/proc/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	halloss = min(max(halloss + amount, 0),(maxHealth*2))

/mob/living/proc/setHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	halloss = amount

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(var/newMaxHealth)
	maxHealth = newMaxHealth

// ++++ROCKDTBEN++++ MOB PROCS //END


/mob/proc/get_contents()


//Recursive function to find everything a mob is holding.
/mob/living/get_contents(var/obj/item/weapon/storage/Storage = null)
	var/list/L = list()

	if(Storage) //If it called itself
		L += Storage.return_inv()

		//Leave this commented out, it will cause storage items to exponentially add duplicate to the list
		//for(var/obj/item/weapon/storage/S in Storage.return_inv()) //Check for storage items
		//	L += get_contents(S)

		for(var/obj/item/weapon/gift/G in Storage.return_inv()) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/weapon/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in Storage.return_inv()) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/weapon/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

	else

		L += src.contents
		for(var/obj/item/weapon/storage/S in src.contents)	//Check for storage items
			L += get_contents(S)

		for(var/obj/item/weapon/gift/G in src.contents) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/weapon/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in src.contents) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/weapon/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0


/mob/living/proc/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	  return 0 //only carbon liveforms have this proc

/mob/living/emp_act(severity)
	var/list/L = src.get_contents()
	for(var/obj/O in L)
		O.emp_act(severity)
	..()

/mob/living/proc/get_organ_target()
	var/mob/shooter = src
	var/t = shooter:zone_sel.selecting
	if ((t in list( "eyes", "mouth" )))
		t = "head"
//	else if((t == "heart"))
//		t = "chest"
	var/datum/organ/external/def_zone = ran_zone(t)
	return def_zone


// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(var/brute, var/burn)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage MANY external organs, in random order
/mob/living/proc/take_overall_damage(var/brute, var/burn, var/used_weapon = null)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

/mob/living/proc/restore_all_organs()
	return



/mob/living/proc/revive()
	rejuvenate()
	buckled = initial(src.buckled)
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		C.handcuffed = initial(C.handcuffed)

/mob/living/proc/respark_revival()

	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	SetParalysis(0)
	SetStunned(0)
	SetWeakened(0)
	setStaminaLoss(0)

	// shut down ongoing problems
	radiation = 0
	nutrition = 400
	bodytemperature = T20C
	sdisabilities = 0
	disabilities = 0

	// fix blindness and deafness
	blinded = 0
	eye_blind = 0
	eye_blurry = 0
	ear_deaf = 0
	ear_damage = 0
	heal_overall_damage(getBruteLoss(), getFireLoss())
	ExtinguishMob()

	// restore all of a human's blood
	if(ishuman(src))
		var/mob/living/carbon/human/human_mob = src
		human_mob.restore_blood()
		human_mob.consyte = TRUE

	// fix all of our organs

	// remove the character from the list of the dead
	if(stat == 2)
		dead_mob_list -= src
		living_mob_list += src
		tod = null

	// restore us to conciousness
	stat = CONSCIOUS
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.death_door = 0
	// make the icons look correct
	regenerate_icons()

	return

/mob/living/proc/rejuvenate(var/no_blood = FALSE)
	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	SetParalysis(0)
	SetStunned(0)
	SetWeakened(0)
	setStaminaLoss(0)

	// shut down ongoing problems
	radiation = 0
	nutrition = 400
	bodytemperature = T20C
	sdisabilities = 0
	disabilities = 0

	// fix blindness and deafness
	blinded = 0
	eye_blind = 0
	eye_blurry = 0
	ear_deaf = 0
	ear_damage = 0
	heal_overall_damage(getBruteLoss(), getFireLoss())
	ExtinguishMob()

	// restore all of a human's blood
	if(!no_blood)
		if(ishuman(src))
			var/mob/living/carbon/human/human_mob = src
			human_mob.restore_blood()

	// fix all of our organs
	restore_all_organs()

	// remove the character from the list of the dead
	if(stat == 2)
		dead_mob_list -= src
		living_mob_list += src
		tod = null

	// restore us to conciousness
	stat = CONSCIOUS

	// make the icons look correct
	regenerate_icons()

	return

/mob/living/proc/UpdateDamageIcon()
	return

/mob/living/Move(a, b, flag)
	if (buckled && (!istype(buckled, /mob/living/carbon/human/monster/arellit)) && !istype(buckled, /obj/structure/stool/bed/chair/wheelchair))
		return

	if (buckled && istype(buckled, /obj/structure/stool/bed/chair/wheelchair))
		buckled.dir = src.dir
		buckled.forceMove(src.loc)
		playsound(buckled.loc, 'rollermove.ogg', 75, 1)

	if (restrained())
		stop_pulling()


	var/t7 = 1
	if (restrained())
		for(var/mob/living/M in range(src, 1))
			if ((M.pulling == src && M.stat == 0 && !( M.restrained() )))
				t7 = null
	if ((t7 && (pulling && ((get_dist(src, pulling) <= 1 || pulling.loc == loc) && (client && client.moving)))))
		var/turf/T = loc
		. = ..()

		if (pulling && pulling.loc)
			if(!( isturf(pulling.loc) ))
				stop_pulling()
				return
			else
				if(Debug)
					diary <<"pulling disappeared? at [__LINE__] in mob.dm - pulling = [pulling]"
					diary <<"REPORT THIS"

		/////
		if(pulling && pulling.anchored)
			stop_pulling()
			return

		if (!restrained())
			var/diag = get_dir(src, pulling)
			if ((diag - 1) & diag)
			else
				diag = null
			if ((get_dist(src, pulling) > 1 || diag))
				if (isliving(pulling))
					var/mob/living/M = pulling
					var/ok = 1
					if (locate(/obj/item/weapon/grab, M.grabbed_by))
						if (prob(75))
							var/obj/item/weapon/grab/G = pick(M.grabbed_by)
							if (istype(G, /obj/item/weapon/grab))
								for(var/mob/O in viewers(M, null))
									O.show_message(text("<span class='hitbold'>[]</span> <span class='hit'>has been pulled from</span> <span class='hitbold'>[]'s</span> <span class='hit'>grip by</span> <span class='hitbold'>[]</span><span class='hit>!</span>'", G.affecting, G.assailant, src), 1)
								//G = null
								qdel(G)
						else
							ok = 0
						if (locate(/obj/item/weapon/grab, M.grabbed_by.len))
							ok = 0
					if (ok)
						var/atom/movable/t = M.pulling
						M.stop_pulling()

						//this is the gay blood on floor shit -- Added back -- Skie
						if (M.lying && (prob(M.getBruteLoss() * 3)))
							var/blood_exists = 0
							var/trail_type = M.getTrail()
							for(var/obj/effect/decal/cleanable/trail_holder/C in M.loc) //checks for blood splatter already on the floor
								blood_exists = 1
							if (istype(M.loc, /turf/simulated) && trail_type != null)
								var/newdir = get_dir(T, M.loc)
								if(newdir != M.dir)
									newdir = newdir | M.dir
									if(newdir == 3) //N + S
										newdir = NORTH
									else if(newdir == 12) //E + W
										newdir = EAST
								if((newdir in list(1, 2, 4, 8)) && (prob(50)))
									newdir = turn(get_dir(T, M.loc), 180)
								if(!blood_exists)
									new /obj/effect/decal/cleanable/trail_holder(M.loc)
								for(var/obj/effect/decal/cleanable/trail_holder/H in M.loc)
									if((!(newdir in H.existing_dirs) || trail_type == "trails_1" || trail_type == "trails_2") && H.existing_dirs.len <= 16) //maximum amount of overlays is 16 (all light & heavy directions filled)
										H.existing_dirs += newdir
										H.overlays.Add(image('icons/effects/blood.dmi',trail_type,dir = newdir))
						step(pulling, get_dir(pulling.loc, T))
						M.start_pulling(t)
				else
					if (pulling)
						if (istype(pulling, /obj/structure/window))
							if(pulling:ini_dir == NORTHWEST || pulling:ini_dir == NORTHEAST || pulling:ini_dir == SOUTHWEST || pulling:ini_dir == SOUTHEAST)
								for(var/obj/structure/window/win in get_step(pulling,get_dir(pulling.loc, T)))
									stop_pulling()
					if (pulling)
						step(pulling, get_dir(pulling.loc, T))
	else
		stop_pulling()
		. = ..()
	if ((s_active && !( s_active in contents ) ))
		s_active.close(src)


	for(var/mob/living/carbon/human/H in oview(1, src))
		H.update_vision_cone()
	update_vision_cone()

/mob/living/carbon/proc/CheckStamina()
	if(stamina_loss <= 0)
		setStaminaLoss(0)
	if(stamina_loss && !combat_mode)//If we're not doing anything and we've lost stamina we can wait to gain it back.
		adjustStaminaLoss(-1)

	if(stamina_loss >= 120 && stat == 0)//Oh shit we've lost too much stamina and now we're tired!
		if(src.species.name != "Zombie")
			Exhaust()
			return
/mob/living/proc/Exhaust()//Called when you run out of stamina.
	Weaken(10)
	if(prob(50))
		if(ishuman(src))
			stamina_loss = 100
			var/mob/living/carbon/human/H = src
			var/list/ROLL = roll3d6(src, H.my_stats.ht,null,TRUE,TRUE)
			switch(ROLL[GP_RESULT])
				if(GP_CRITFAIL)
					var/datum/organ/internal/heart/HE = locate() in H.internal_organs
					HE.heart_attack()
			if (src.gender == MALE)
				if(H.isChild())
					playsound(src.loc, pick('sound/voice/boy_exhaust.ogg'), 90, 0, -1)
				else
					playsound(src.loc, pick('sound/voice/maletired1.ogg','sound/voice/maletired2.ogg','sound/voice/maletired3.ogg'), 90, 0, -1)
			else
				if(H.isChild())
					playsound(src.loc, pick('sound/voice/tired.ogg'), 90, 0, -1)
				else
					playsound(src.loc, pick('sound/voice/femtired1.ogg','sound/voice/femtired2.ogg','sound/voice/femtired3.ogg','sound/voice/femtired4.ogg'), 90, 0, -1)


/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!isliving(usr) || usr.next_move > world.time)
		return
	usr.next_move = world.time + 20

	var/mob/living/L = usr

	//Getting out of someone's inventory.
	if(istype(src.loc,/obj/item/mob_holder))
		var/obj/item/mob_holder/H = src.loc
		src.loc = get_turf(src.loc)
		qdel(H)
		return

	//Resisting control by an alien mind.
	if(istype(src.loc,/mob/living/simple_animal/borer))
		var/mob/living/simple_animal/borer/B = src.loc
		var/mob/living/captive_brain/H = src

		H << "\red <B>You begin doggedly resisting the parasite's control (this will take approximately sixty seconds).</B>"
		B.host << "\red <B>You feel the captive mind of [src] begin to resist your control.</B>"

		spawn(rand(350,450)+B.host.brainloss)

			if(!B || !B.controlling)
				return

			B.host.adjustBrainLoss(rand(5,10))
			H << "\red <B>With an immense exertion of will, you regain control of your body!</B>"
			B.host << "\red <B>You feel control of the host brain ripped from your grasp, and retract your probosci before the wild neural impulses can damage you.</b>"
			B.controlling = 0

			B.ckey = B.host.ckey
			B.host.ckey = H.ckey

			H.ckey = null
			H.name = "host brain"
			H.real_name = "host brain"

			verbs -= /mob/living/carbon/proc/release_control
			verbs -= /mob/living/carbon/proc/punish_host
			verbs -= /mob/living/carbon/proc/spawn_larvae

			return

	//resisting grabs (as if it helps anyone...)
	if ((!( L.stat ) && L.canmove && !( L.restrained() )))
		var/resisting = 0
		/*for(var/obj/O in L.requests)
			L.requests.Remove(O)
			qdel(O)
			resisting++*/
		for(var/obj/item/weapon/grab/G in usr.grabbed_by)
			resisting++
			if (G.state >= 2)
				if(!ishuman(G.affecting) && !ishuman(G.assailant))
					return

				var/mob/living/carbon/human/H = G.assailant
				var/mob/living/carbon/human/HH = G.affecting

				if(H.my_stats.st - HH.my_stats.st >= 3)
					to_chat(HH, "You can't!")
					return

				var/diff = (H.my_stats.st + H.my_skills.GET_SKILL(SKILL_MELEE)) - (HH.my_stats.st + HH.my_skills.GET_SKILL(SKILL_MELEE))

				var/modifier = 6
				if(HH.meanwhile_combat_intent == "defend")
					modifier += 15

				if(HH.combat_mode)
					modifier += 20
				else
					modifier -= 10

				if(diff < 0)
					var/parsedDiff = diff * -1
					for(var/x = 0; x < parsedDiff; x++)
						modifier += rand(9, 13)
				if(diff > 0)
					for(var/x = 0; x < diff; x++)
						modifier -= rand(13, 15)

				if(HH.isChild())
					modifier -= 15
				if(FAT in HH.mutations)
					modifier += 15

				if(modifier <= 5)
					modifier = 3
				if(modifier >= 95)
					modifier = 82.5

				if(prob(modifier))
					for(var/mob/O in viewers(L, null))
						O.show_message(text("<span class='hitbold'>[]</span> <span class='hit'>has broken free of</span> <span class='hitbold'>[]'s</span> <span class='hit'>grip!</span>", L, G.assailant), 1)
					qdel(G)
		if(resisting)
			for(var/mob/O in viewers(usr, null))
				O.show_message(text("<span class='hitbold'>[]</span> <span class='hit'>resists!</span>", L), 1)

	//unbuckling yourself
	if(L.buckled && (L.last_special <= world.time) )
		L.buckled.manual_unbuckle(L)

	//Breaking out of a locker?
	if( src.loc && (istype(src.loc, /obj/structure/closet)) )
		var/breakout_time = 2 //2 minutes by default

		var/obj/structure/closet/C = L.loc
		if(C.opened)
			return //Door's open... wait, why are you in it's contents then?
		if(istype(L.loc, /obj/structure/closet/secure_closet))
			var/obj/structure/closet/secure_closet/SC = L.loc
			if(!SC.locked && !SC.welded)
				return //It's a secure closet, but isn't locked. Easily escapable from, no need to 'resist'
		else
			if(!C.welded)
				return //closed but not welded...
		//	else Meh, lets just keep it at 2 minutes for now
		//		breakout_time++ //Harder to get out of welded lockers than locked lockers

		//okay, so the closet is either welded or locked... resist!!!
		usr.next_move = world.time + 100
		L.last_special = world.time + 100
		L << "\red You lean on the back of \the [C] and start pushing the door open. (this will take about [breakout_time] minutes)"
		for(var/mob/O in viewers(usr.loc))
			O.show_message("\red <B>The [L.loc] begins to shake violently!</B>", 1)


		spawn(0)
			if(do_after(usr,(breakout_time*60*10))) //minutes * 60seconds * 10deciseconds
				if(!C || !L || L.stat != CONSCIOUS || L.loc != C || C.opened) //closet/user destroyed OR user dead/unconcious OR user no longer in closet OR closet opened
					return

				//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
				if(istype(L.loc, /obj/structure/closet/secure_closet))
					var/obj/structure/closet/secure_closet/SC = L.loc
					if(!SC.locked && !SC.welded)
						return
				else
					if(!C.welded)
						return

				//Well then break it!
				if(istype(usr.loc, /obj/structure/closet/secure_closet))
					var/obj/structure/closet/secure_closet/SC = L.loc
					SC.desc = "It appears to be broken."
					SC.icon_state = SC.icon_off
					flick(SC.icon_broken, SC)
					sleep(10)
					flick(SC.icon_broken, SC)
					sleep(10)
					SC.broken = 1
					SC.locked = 0
					SC.update_icon()
					usr << "\red You successfully break out!"
					for(var/mob/O in viewers(L.loc))
						O.show_message("\red <B>\the [usr] successfully broke out of \the [SC]!</B>", 1)
					if(istype(SC.loc, /obj/structure/bigDelivery)) //Do this to prevent contents from being opened into nullspace (read: bluespace)
						var/obj/structure/bigDelivery/BD = SC.loc
						BD.attack_hand(usr)
					SC.open()
				else
					C.welded = 0
					C.update_icon()
					usr << "\red You successfully break out!"
					for(var/mob/O in viewers(L.loc))
						O.show_message("\red <B>\the [usr] successfully broke out of \the [C]!</B>", 1)
					if(istype(C.loc, /obj/structure/bigDelivery)) //nullspace ect.. read the comment above
						var/obj/structure/bigDelivery/BD = C.loc
						BD.attack_hand(usr)
					C.open()


	//Stop drop and roll & Handcuffs
	else if(iscarbon(L))
		var/mob/living/carbon/CM = L
		if(CM.on_fire && CM.canmove)
			CM.fire_stacks -= 1
			CM.Weaken(3,1)
			CM.spin(32,2)
			CM.visible_message("<span class='combatbold'>[CM]</span> <span class='combat'>rolls on the floor, trying to put themselves out!</span>", \
				"<span class='combat'>You stop, drop, and roll!</span>")
			sleep(30)
			if(fire_stacks <= 0)
				CM.visible_message("<span class='passivebold'>[CM]</span> <span class='passive'>has successfully extinguished themselves!</span>", \
					"<span class='passive'>You extinguish yourself.</span>")
				ExtinguishMob()
			return

		if(CM.handcuffed && !(CM.stat || CM.stunned || CM.weakened || CM.buckled || CM.paralysis || CM.sleeping || (CM.status_flags & FAKEDEATH)) && (CM.last_special <= world.time))
			CM.next_move = world.time + 100
			CM.last_special = world.time + 100

			var/can_break_cuffs
			if(HULK in usr.mutations)
				can_break_cuffs = TRUE
			else if(istype(CM,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = CM
				if(iszombie(H))
					can_break_cuffs = TRUE
				if(H.species.can_shred(H))
					can_break_cuffs = TRUE
				if(istype(H.species, /datum/species/human/alien))
					can_break_cuffs = TRUE
				if(H.my_stats.st >= 20)
					can_break_cuffs = TRUE

			if(can_break_cuffs) //Don't want to do a lot of logic gating here.
				to_chat(usr, "<span class='combat'>You attempt to break your handcuffs.</span>")
				for(var/mob/O in viewers(CM))
					O.show_message(text("<span class='combatbold'>[]</span> <span class='combat'>is trying to break the handcuffs!</span>", CM), 1)
				spawn(0)
					if(do_after(CM, 30))
						if(!CM.handcuffed)
							return
						for(var/mob/O in viewers(CM))
							O.show_message(text("<span class='combatbold'>[]</span> <span class='combat'>manages to break the handcuffs!</span>", CM), 1)
						to_chat(CM, "<span class='combat'> you successfully break your handcuffs.</span>")
						qdel(CM.handcuffed)
						CM.handcuffed = null
						CM.update_inv_handcuffed()
			else
				var/obj/item/weapon/handcuffs/HC = CM.handcuffed
				var/breakouttime = rand(400,800) //A default in case you are somehow handcuffed with something that isn't an obj/item/weapon/handcuffs type
				//var/displaytime = 2 //Minutes to display in the "this will take X minutes."
				if(istype(HC)) //If you are handcuffed with actual handcuffs... Well what do I know, maybe someone will want to handcuff you with toilet paper in the future...
					breakouttime = HC.breakouttime
					//displaytime = breakouttime / 600 //Minutes
				to_chat(CM, "<span class='combat'> You attempt to remove \the [HC].</span>")
				for(var/mob/O in viewers(CM))
					O.show_message( "<span class='combatbold'>[usr]</span> <span class='combat'>attempts to remove \the [HC]!</span>", 1)
				spawn(0)
					var/increment = 150
					for(var/i = 0, i < breakouttime, i += increment)
						if(!do_after(CM, increment))
							return
						else
							to_chat(CM, pick("You hear something click, but it doesn't open yet.",	// - Uristqwerty
										"The latch resists!",									// - IRC: BowlSoldier
										"The chain is starting to give!",						// - IRC: BowlSoldier
										"The chain bends a little.",							// - IRC: STALKER
										"Your wrist hurts.",									// - IRC: STALKER
										"Unnng"))												// - IRC: Doug_H_Nuts

					if(!CM:handcuffed) return
					for(var/mob/O in viewers(CM))//                                         lags so hard that 40s isn't lenient enough - Quarxink
						O.show_message("<span class='combatbold'>[CM]</span> <span class='combat'>manages to remove the handcuffs!</span>", 1)
					to_chat(CM, "<span class='passive'> You successfully remove \the [CM.handcuffed].</span>")
					CM.drop_from_inventory(CM.handcuffed)

		else if(CM.legcuffed && CM.canmove && (CM.last_special <= world.time))
			CM.next_move = world.time + 100
			CM.last_special = world.time + 100

			var/can_break_cuffs
			if(HULK in usr.mutations)
				can_break_cuffs = 1
			else if(istype(CM,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = CM
				if(H.species.can_shred(H))
					can_break_cuffs = 1

			if(can_break_cuffs) //Don't want to do a lot of logic gating here.
				to_chat(usr, "<span class='combat'>You attempt to break your legcuffs.</span>")
				for(var/mob/O in viewers(CM))
					O.show_message(text("<span class='combatbold'>[]</span> <span class='combat'>is trying to break the legcuffs!</span>", CM), 1)
				spawn(0)
					if(do_after(CM, 50))
						if(!CM.legcuffed)// || CM.buckled)
							return
						for(var/mob/O in viewers(CM))
							O.show_message(text("<span class='combatbold'>[]</span> <span class='combat'>manages to break the legcuffs!</span>", CM), 1)
						to_chat(CM, "<span class='passive'>You successfully break your legcuffs.")
						CM.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
						qdel(CM.legcuffed)
						CM.legcuffed = null
						CM.update_inv_legcuffed()
			else
				var/obj/item/weapon/legcuffs/HC = CM.legcuffed
				var/breakouttime = 1200 //A default in case you are somehow legcuffed with something that isn't an obj/item/weapon/legcuffs type
				//var/displaytime = 2 //Minutes to display in the "this will take X minutes."
				if(istype(HC)) //If you are legcuffed with actual legcuffs... Well what do I know, maybe someone will want to legcuff you with toilet paper in the future...
					breakouttime = HC.breakouttime
					//displaytime = breakouttime / 600 //Minutes
				to_chat(CM,"<span class='combat'> You attempt to remove \the [HC].</span>")
				for(var/mob/O in viewers(CM))
					O.show_message( "<span class='combatbold'>[usr]</span> <span class='combat'>attempts to remove \the [HC]!</span>", 1)
				spawn(0)
					if(do_after(CM, breakouttime))
						if(!CM.legcuffed || CM.buckled)
							return // time leniency for lag which also might make this whole thing pointless but the server
						for(var/mob/O in viewers(CM))//                                         lags so hard that 40s isn't lenient enough - Quarxink
							O.show_message("<span class='combatbold'>[CM]</span> <span class='combat'>manages to remove the legcuffs!</span>", 1)
						to_chat(CM, "<span class='passive'> You successfully remove \the [CM.legcuffed].</span>")
						CM.drop_from_inventory(CM.legcuffed)
						CM.legcuffed = null
						CM.update_inv_legcuffed()

/mob/living/carbon/proc/spin(spintime, speed)
	spawn()
		var/D = dir
		while(spintime >= speed)
			sleep(speed)
			switch(D)
				if(NORTH)
					D = EAST
				if(SOUTH)
					D = WEST
				if(EAST)
					D = SOUTH
				if(WEST)
					D = NORTH
			dir = D
			spintime -= speed
	return

/mob/living/proc/getTrail() //silicon and simple_animals don't get blood trails
    return null

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"
	mob_rest()

/mob/living/proc/handle_ventcrawl(var/obj/machinery/atmospherics/unary/vent_pump/vent_found = null, var/ignore_items = 0) // -- TLE -- Merged by Carn
	if(stat)
		src << "You must be conscious to do this!"
		return
	if(lying)
		src << "You can't vent crawl while you're stunned!"
		return

	var/special_fail_msg = can_use_vents()
	if(special_fail_msg)
		src << "\red [special_fail_msg]"
		return

	if(vent_found) // one was passed in, probably from vent/AltClick()
		if(vent_found.welded)
			src << "That vent is welded shut."
			return
		if(!vent_found.Adjacent(src))
			return // don't even acknowledge that
	else
		for(var/obj/machinery/atmospherics/unary/vent_pump/v in range(1,src))
			if(!v.welded)
				if(v.Adjacent(src))
					vent_found = v
	if(!vent_found)
		src << "You'll need a non-welded vent to crawl into!"
		return

	if(!vent_found.network || !vent_found.network.normal_members.len)
		src << "This vent is not connected to anything."
		return

	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in vent_found.network.normal_members)
		if(temp_vent.welded)
			continue
		if(temp_vent in loc)
			continue
		var/turf/T = get_turf(temp_vent)

		if(!T || !(T.z in vessel_z))
			continue

		var/i = 1
		var/index = "[T.loc.name]\[[i]\]"
		while(index in vents)
			i++
			index = "[T.loc.name]\[[i]\]"
		vents[index] = temp_vent
	if(!vents.len)
		src << "\red There are no available vents to travel to, they could be welded."
		return

	var/obj/selection = input("Select a destination.", "Duct System") as null|anything in sortAssoc(vents)
	if(!selection)	return

	if(!vent_found.Adjacent(src))
		src << "Never mind, you left."
		return

	if(!ignore_items)
		for(var/obj/item/carried_item in contents)//If the monkey got on objects.
			if( !istype(carried_item, /obj/item/weapon/implant) && !istype(carried_item, /obj/item/clothing/mask/facehugger) )//If it's not an implant or a facehugger
				src << "\red You can't be carrying items or have items equipped when vent crawling!"
				return

	var/obj/machinery/atmospherics/unary/vent_pump/target_vent = vents[selection]
	if(!target_vent)
		return

	for(var/mob/O in viewers(src, null))
		O.show_message(text("<B>[src] scrambles into the ventillation ducts!</B>"), 1)
	loc = target_vent

	var/travel_time = round(get_dist(loc, target_vent.loc) / 2)

	spawn(travel_time)

		if(!target_vent)	return
		for(var/mob/O in hearers(target_vent,null))
			O.show_message("You hear something squeezing through the ventilation ducts.",2)

		sleep(travel_time)

		if(!target_vent)	return
		if(target_vent.welded)			//the vent can be welded while alien scrolled through the list or travelled.
			target_vent = vent_found 	//travel back. No additional time required.
			src << "\red The vent you were heading to appears to be welded."
		loc = target_vent.loc
		var/area/new_area = get_area(loc)
		if(new_area)
			new_area.Entered(src)

/mob/living/proc/can_use_vents()
	return "You can't fit into that vent."

/mob/living/proc/has_brain()
	return 1

/mob/living/proc/has_eyes()
	return 1


/mob/living/update_gravity(has_gravity)
	if(!ticker)
		return
	float(!has_gravity)

/mob/living/proc/float(on)
	if(on && !floating)
		animate(src, pixel_y = 2, time = 10, loop = -1)
		floating = 1
	else if(!on && floating)
		animate(src, pixel_y = initial(pixel_y), time = 10)
		floating = 0

/mob/living/set_dir()
	..()
	update_vision_cone()

/atom/movable/proc/receive_damage(atom/A)
	var/pixel_x_diff = rand(-3,3)
	var/pixel_y_diff = rand(-3,3)
	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)

/mob/living/receive_damage(atom/A)
	..()

/mob/living/Move(NewLoc, direct)
	. = ..()
	if(.)
		for(var/client/C in in_vision_cones)
			if(src in C.mob.hidden_mobs)
				var/turf/T = get_turf(src)
				var/image/I = image('icons/life/sound2.dmi', loc = T, icon_state = "2", layer = 18)
				C.images += I
				spawn(4)
					if(C)
						C.images -= I
			else
				in_vision_cones.Remove(C)

/atom/proc/sound2()
	var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
	animation.layer = 16
	animation.plane = 15
	animation.icon_state = "blank"
	animation.icon = 'icons/life/sound2.dmi'
	animation.master = src
	flick("2", animation)
	spawn(6)
		qdel(animation)

/mob/living/Crossed(mob/living/M as mob)
	..()
	if(istype(M, /mob/living))
		if(!ismonster(M))
			if(src.lying && !M.lying)
				var/randomized = rand(1,5)
				if(prob(randomized))
					M.stumble(0,src)
	else
		return

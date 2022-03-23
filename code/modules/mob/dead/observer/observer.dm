var/list/NOIRLIST = list(0.3,0.3,0.3,0,\
			 			 0.3,0.3,0.3,0,\
						 0.3,0.3,0.3,0,\
						 0.0,0.0,0.0,1,)

var/siegereinforcements = 0
var/list/siegelist = list()

/mob/dead/observer
	name = "wraith"
	desc = "A lost shadow on the limbo." //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	layer = 4

	stat = DEAD
	density = 0
	canmove = 0
	blinded = 0
	anchored = 1	//  don't get pushed around
	invisibility = INVISIBILITY_OBSERVER
	var/can_reenter_corpse
	var/datum/hud/living/carbon/hud = null // hud
	var/bootime = 0
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghsot - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/has_enabled_antagHUD = 0
	var/medHUD = 0
	var/antagHUD = 0
	var/latepartied = FALSE
	universal_speak = 1
	var/wraith_pain = 0
	var/in_hell = FALSE
	var/atom/movable/following = null
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE

/mob/dead/observer/proc/Sendtohell()
	if(in_hell)
		return
	for(var/obj/effect/landmark/L in landmarks_list)
		if (L.name == "Hell")
			src.forceMove(L.loc)
	wraith_pain = 0
	in_hell = TRUE
	src?.client?.color = "#ed7a72"
	src << sound('ghostloop.ogg', repeat = 1, wait = 0, volume = src?.client?.prefs?.music_volume, channel = 12)

/mob/dead/observer/New(mob/body)
	//sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 100
	//verbs += /mob/dead/observer/proc/dead_tele
	src.add_filter_effects()
	stat = DEAD
	var/turf/T
	if(ismob(body))
		T = get_turf(body)				//Where is the body located?
		attack_log = body.attack_log	//preserve our attack logs by copying them to our ghost

		if (ishuman(body))
			var/mob/living/carbon/human/H = body
			icon = H.stand_icon
			overlays = H.overlays_standing
		else
			icon = body.icon
			icon_state = body.icon_state
			overlays = body.overlays

		alpha = 127

		gender = body.gender
		if(body.mind && body.mind.name)
			name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				if(gender == MALE)
					name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
				else
					name = capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.

	if(!T)	T = pick(latejoin)			//Safety in case we cannot find the body's position
	loc = T

	if(!name)							//To prevent nameless ghosts
		name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	real_name = name
	..()

/mob/dead/observer/Topic(href, href_list)
	if (href_list["track"])
		var/mob/target = locate(href_list["track"]) in mob_list
		if(target)
			ManualFollow(target)

/mob/proc/add_overlay_wraith()
	clear_fullscreen("dob")
	overlay_fullscreen("ghost", /obj/screen/fullscreen/wraithoverlay, 1)

/mob/proc/add_overlay_dreamer()
	overlay_fullscreen("dreamer", /obj/screen/fullscreen/dreamer, rand(1,8))

/mob/dead/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/weapon/tome))
		var/mob/dead/M = src
		if(src.invisibility != 0)
			M.invisibility = 0
			user.visible_message( \
				"\red [user] drags ghost, [M], to our plan of reality!", \
				"\red You drag [M] to our plan of reality!" \
			)
		else
			user.visible_message ( \
				"\red [user] just tried to smash his book into that ghost!  It's not very effective", \
				"\red You get the feeling that the ghost can't become any more visible." \
			)


/mob/dead/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 1
/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/
/obj/structure/wraith_pain
	name = "pain"
	density = 0
	opacity = 0
	icon = 'icons/mob/mob.dmi'
	icon_state = "pain"
	anchored = 1
	layer = 4
	appearance_flags = NO_CLIENT_COLOR
	invisibility = INVISIBILITY_OBSERVER

/obj/structure/Destroy()
	loc = null
	qdel(reagents)
	reagents = null

/obj/structure/wraith_pain/Crossed(mob/dead/observer/O)
	if(istype(O, /mob/dead/observer))
		var/multiplier = 1
		if(ticker?.eof?.id == "ghostpower")
			multiplier = 3
		O.wraith_pain += 5 * multiplier
		to_chat(O, "<spanclass='jogtowalk'>5 Pain collected.</span>")
		O << sound('w_consume.ogg', repeat = 0, wait = 0, volume = 70, channel = 25)
		qdel(src)
		return

/mob/dead/observer/Life()
	..()
	if(!loc) return
	if(!client) return 0


	if(client.images.len)
		for(var/image/hud in client.images)
			if(copytext(hud.icon_state,1,4) == "hud")
				client.images.Remove(hud)
	if(antagHUD)
		var/list/target_list = list()
		for(var/mob/living/target in oview(src))
			if( target.mind&&(target.mind.special_role||issilicon(target)) )
				target_list += target
		if(target_list.len)
			assess_targets(target_list, src)
	if(medHUD)
		process_medHUD(src)


// Direct copied from medical HUD glasses proc, used to determine what health bar to put over the targets head.
/mob/dead/proc/RoundHealth(var/health)
	switch(health)
		if(100 to INFINITY)
			return "health100"
		if(70 to 100)
			return "health80"
		if(50 to 70)
			return "health60"
		if(30 to 50)
			return "health40"
		if(18 to 30)
			return "health25"
		if(5 to 18)
			return "health10"
		if(1 to 5)
			return "health1"
		if(-99 to 0)
			return "health0"
		else
			return "health-100"
	return "0"


// Pretty much a direct copy of Medical HUD stuff, except will show ill if they are ill instead of also checking for known illnesses.

/mob/dead/proc/process_medHUD(var/mob/M)
	var/client/C = M.client
	var/image/holder
	for(var/mob/living/carbon/human/patient in oview(M))
		var/foundVirus = 0
		if(patient.virus2.len)
			foundVirus = 1
		if(!C) return
		holder = patient.hud_list[HEALTH_HUD]
		if(patient.stat == 2)
			holder.icon_state = "hudhealth-100"
		else
			holder.icon_state = "hud[RoundHealth(patient.health)]"
		C.images += holder

		holder = patient.hud_list[STATUS_HUD]
		if(patient.stat == 2)
			holder.icon_state = "huddead"
		else if(patient.status_flags & XENO_HOST)
			holder.icon_state = "hudxeno"
		else if(foundVirus)
			holder.icon_state = "hudill"
		else if(patient.has_brain_worms())
			var/mob/living/simple_animal/borer/B = patient.has_brain_worms()
			if(B.controlling)
				holder.icon_state = "hudbrainworm"
			else
				holder.icon_state = "hudhealthy"
		else
			holder.icon_state = "hudhealthy"

		C.images += holder


/mob/dead/proc/assess_targets(list/target_list, mob/dead/observer/U)
	var/icon/tempHud = 'icons/mob/hud.dmi'
	for(var/mob/living/target in target_list)
		if(iscarbon(target))
			switch(target.mind.special_role)
				if("traitor","Syndicate")
					U.client.images += image(tempHud,target,"hudsyndicate")
				if("Revolutionary")
					U.client.images += image(tempHud,target,"hudrevolutionary")
				if("Head Revolutionary")
					U.client.images += image(tempHud,target,"hudheadrevolutionary")
				if("Cultist")
					U.client.images += image(tempHud,target,"hudcultist")
				if("Changeling")
					U.client.images += image(tempHud,target,"hudchangeling")
				if("Wizard","Fake Wizard")
					U.client.images += image(tempHud,target,"hudwizard")
				if("Hunter","Sentinel","Drone","Queen")
					U.client.images += image(tempHud,target,"hudalien")
				if("Death Commando")
					U.client.images += image(tempHud,target,"huddeathsquad")
				if("Ninja")
					U.client.images += image(tempHud,target,"hudninja")
				else//If we don't know what role they have but they have one.
					U.client.images += image(tempHud,target,"hudunknown1")
		else if(issilicon(target))//If the silicon mob has no law datum, no inherent laws, or a law zero, add them to the hud.
			var/mob/living/silicon/silicon_target = target
			if(!silicon_target.laws||(silicon_target.laws&&(silicon_target.laws.zeroth||!silicon_target.laws.inherent.len))||silicon_target.mind.special_role=="traitor")
				if(isrobot(silicon_target))//Different icons for robutts and AI.
					U.client.images += image(tempHud,silicon_target,"hudmalborg")
				else
					U.client.images += image(tempHud,silicon_target,"hudmalai")
	return 1

/mob/proc/ghostize(var/can_reenter_corpse = 1)
	if(key)
		var/mob/dead/observer/ghost = new(src)	//Transfer safety to observer spawning proc.
		ghost.can_reenter_corpse = can_reenter_corpse
		ghost.timeofdeath = src.timeofdeath //BS12 EDIT
		ghost.key = key
		add_overlay_wraith()
		ghost.add_overlay_wraith()
		ghost << sound(pick('ghosted1.ogg','geist.ogg','ghosted4.ogg','ghosted2.ogg'), repeat = 0, wait = 0, volume =  src?.client?.prefs?.music_volume, channel = 12)
		ghost << sound(null, repeat = 0, wait = 0, volume =  0, channel = 9) // remove the ambience
		ghost << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
		ghost << sound(null, repeat = 1, wait = 0, volume = 70, channel = 4)
/*
		if(ghost.client)
			if(!ghost.client.holder && !config.antag_hud_allowed)		// For new ghosts we remove the verb from even showing up if it's not allowed.
				ghost.verbs -= /mob/dead/observer/verb/toggle_antagHUD	// Poor guys, don't know what they are missing!
*/
		spawn(5)
			to_chat(ghost, "\n<div class='firstdivmood'><div class='moodbox'><span class='graytext'>Your adventures are not over. You may join a Late Party or soulbreaker squad.</span>\n<span class='feedback'><a href='?src=\ref[src];action=joinlateparty'>1. I agree.</a></span>\n<span class='feedback'><a href='?src=\ref[src];action=rejlateparty'>2. I refuse.</a></span></div></div>")
			ghost.lateparty()

		if(ticker && ticker.current_state == GAME_STATE_PLAYING && master_mode == "inspector")
			to_chat(src, "\n<div class='firstdivmood'><div class='moodbox'><span class='graytext'>You may join as the Inspector or his bodyguard.</span>\n<span class='feedback'><a href='?src=\ref[src];acao=joininspectree'>1. I want to.</a></span>\n<span class='feedback'><a href='?src=\ref[src];acao=nao'>2. I'll pass.</a></span></div></div>")

		if(ghost.client && !ghost.client.holder)
			animate(ghost.client, color = NOIRLIST, time = 10)
			//to_chat(ghost, "\n<div class='firstdivmood'><span class='graytext'>Your adventures are not over. You may join a Late Party or soulbreaker squad.</span>\n<span class='feedback'><a href='?src=\ref[src];action=joinlate'>1. I agree.</a></span>\n<span class='feedback'><a href='?src=\ref[src];action=rejlate'>2. I refuse.</a></span></div>")
			/*switch(alert(ghost,"Você deseja entrar na Lateparty?","Please answer in 30 seconds!","Yes","No"))
				if("Yes")
					if(latepartystarted)
						return
					ghost.lateparty()
				if("No")
					return
				else
					return*/
		return ghost

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/client/Topic(href, href_list, hsrc)
	..()
	switch(href_list["action"])
		if("joinlateparty")
			if(istype(src.mob, /mob/dead))
				var/mob/dead/observer/O = src.mob
				O.lateparty()

/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Wraith"
	set desc = "Relinquish your life and enter the land of the dead."
	if(!ishuman(src))
		if(stat == DEAD)
			ghostize(1)

	else
		//if ((src.health < 0 && src.health > -95.0))
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			if(H.stat == DEAD)
				if(H.time_since_death < 60)
					var/timertt = 60 - H.time_since_death
					to_chat(src, "<span class='passive'>[timertt] seconds before peace.</span>")
					return
				else if(ticker.mode.config_tag == "miniwar" && H.mini_war)
					client.screen.Cut()
					var/mob/new_player/M = new /mob/new_player()
					M.key = key
					M.old_key = key
					M.old_job = job
					M.client.color = null
					M.mini_war_side = H.mini_war
				else
					if(src.becoming_zombie)
						to_chat(src, "You're preparing to walk again.")
						return
					else
						ghostize(1)

			if(H.stat == UNCONSCIOUS && H.last_dam + oxyloss >= 120 && H.death_door || H.death_door)
				src.adjustOxyLoss(src.health + 200)
				src.health = 100 - src.getOxyLoss() - src.getToxLoss() - src.getFireLoss() - src.getBruteLoss()
				to_chat(src, "<span class='passive'>⠀You have given up life and succumbed to death.</span>")
				src.death()
			else
				to_chat(src, "<span class='passivesmaller'>⠀⠀You're too alive to die.</span>")
		else
			to_chat(src, "<span class='passivesmaller'>⠀⠀You're too alive to die.</span>")
	return

/mob/dead/observer/Move(NewLoc, direct)
	following = null
	..()

/mob/dead/observer/movement_delay()
	return 3

/mob/dead/observer/examine()
	if(usr)
		to_chat(usr, "[desc]")

/mob/dead/observer/can_use_hands()	return 0
/mob/dead/observer/is_active()		return 0

/mob/dead/observer/verb/reenter_corpse()
	set category = "Wraith"
	set name = "ReenterCorpse"
	if(!client)
		return
	if(!(mind?.current))
		src << "<span class='warning'>You have no body.</span>"
		return
	if(!can_reenter_corpse)
		src << "<span class='warning'>You cannot reenter your corpse.</span>"
		return
	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		usr << "<span class='warning'>Another consciousness is in your body...It is resisting you.</span>"
		return
	if(mind.current.ajourn && mind.current.stat != DEAD)	//check if the corpse is astral-journeying (it's client ghosted using a cultist rune).
		var/obj/effect/rune/R = locate() in mind.current.loc	//whilst corpse is alive, we can only reenter the body if it's on the rune
		if(!(R && R.word1 == cultwords["hell"] && R.word2 == cultwords["travel"] && R.word3 == cultwords["self"]))	//astral journeying rune
			usr << "<span class='warning'>The astral cord that ties your body and your spirit has been severed. You are likely to wander the realm beyond until your body is finally dead and thus reunited with you.</span>"
			return
	mind.current.ajourn=0
	mind.current.key = key
	if(client)
		animate(mind.current.client, color = null, time = 20)
	mind.current.clear_fullscreen("ghost")
	mind.current << sound(null, repeat = 0, wait = 0, volume =  0, channel = 9) // remove the ambience
	var/area/A = get_area(mind.current)
	if(A.forced_ambience)
		var/sound/S = sound(pick(A.forced_ambience), repeat=1, wait=0, channel=9, volume=src?.client?.prefs?.music_volume)
		mind.current << S
	return 1

/mob/dead/observer/proc/ForceToHellRespawn()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return
	client.screen.Cut()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return
	var/mob/new_player/M = new /mob/new_player()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		qdel(M)
		return
	src << sound(null, repeat = 1, wait = 0, 0, channel = 12)
	M.key = key
	M.old_key = key
	M.old_job = job
	M.client.color = null
	to_chat(M, "You have found peace.")
	M.unlock_medal("Ain't No Grave", 0, "Come back from the Limbo.", "8")
	return

var/list/usedremig = list()
/mob/dead/observer/verb/abandon_mob()
	set name = "GotoHell"
	set category = "OOC"

	if(ticker?.mode.config_tag == "siege")
		client.screen.Cut()
		var/mob/new_player/M = new /mob/new_player()
		M.key = key
		M.old_key = key
		M.old_job = job
		M.client.color = null
		return

	else if(master_mode != "holywar" && master_mode != "minimig")
		if (!( abandon_allowed ))
			to_chat(src, "Respawn is disabled.")
			return
		if ((stat != 2 || !( ticker )))
			to_chat(src, "<B>You must be dead to use this!</B>")
			return
		if(remigrator.Find(ckey) && !usedremig.Find(ckey))
			usedremig += ckey
			client.screen.Cut()
			var/mob/new_player/M = new /mob/new_player()
			M.key = key
			M.old_key = key
			M.old_job = job
			M.client.color = null
			return
	//	if (ticker.mode.name == "meteor" || ticker.mode.name == "epidemic") //BS12 EDIT
	//		usr << "\blue Respawn is disabled for this roundtype."
	//		return
	//	else
		var/deathtime = world.time - src.timeofdeath
		var/deathtimeminutes = round(deathtime / 600)
		var/pluralcheck = "minute"
		if(deathtimeminutes == 0)
			pluralcheck = ""
		else if(deathtimeminutes == 1)
			pluralcheck = " [deathtimeminutes] minute and"
		else if(deathtimeminutes > 1)
			pluralcheck = " [deathtimeminutes] minutes and"
		var/deathtimeseconds = round((deathtime - deathtimeminutes * 600) / 10,1)
		usr << "You have been dead for [pluralcheck] [deathtimeseconds] seconds."

		if(mind.current)
			if(!mind.current.buried && mind.current.loc != /obj/structure/closet/coffin) //If our current body is destroyed (incinerator etc.) it copunts as buried
				to_chat(src, "Your body is not buried nor destroyed.")
				return
/*
		if (deathtime < 6000)
			to_chat(src, "You must wait 10 minutes to escape from the limbo!")
			return
*/
		log_game("[usr.name]/[usr.key] used abandon mob.")

		to_chat(src, " <B>Make sure to play a different personality!</B>")
		src << sound(null, repeat = 1, wait = 0, volume = src?.client?.prefs?.music_volume, channel = 12)

		if(!client)
			log_game("[usr.key] AM failed due to disconnect.")
			return
		client.screen.Cut()
		if(!client)
			log_game("[usr.key] AM failed due to disconnect.")
			return

		var/mob/new_player/M = new /mob/new_player()
		if(!client)
			log_game("[usr.key] AM failed due to disconnect.")
			qdel(M)
			return

		M.key = key
		M.old_key = key
		M.old_job = job
		M.client.color = null
	else
		if ((stat != 2 || !( ticker )))
			usr << "\blue <B>You must be dead to use this!</B>"
			return
		var/deathtime = world.time - src.timeofdeath
		var/deathtimeminutes = round(deathtime / 600)
		var/pluralcheck = "minute"
		if(deathtimeminutes == 0)
			pluralcheck = ""
		else if(deathtimeminutes == 1)
			pluralcheck = " [deathtimeminutes] minute and"
		else if(deathtimeminutes > 1)
			pluralcheck = " [deathtimeminutes] minutes and"
		var/deathtimeseconds = round((deathtime - deathtimeminutes * 600) / 10,1)
		to_chat(usr, "You have been dead for[pluralcheck] [deathtimeseconds] seconds.")

		if (deathtime < 1200)
			to_chat(usr, "You must wait 2 minutes to escape from the limbo!")
			return
		to_chat(usr, "<B>Make sure to play a different soldier!</B>")
		client.screen.Cut()
		var/mob/new_player/M = new /mob/new_player()
		M.key = key
		M.old_key = key
		M.old_job = job
		M.client.color = null
	return
/*
/mob/dead/observer/verb/toggle_medHUD()
	set category = "Ghost"
	set name = "Toggle MedicHUD"
	set desc = "Toggles Medical HUD allowing you to see how everyone is doing"
	if(!client)
		return
	if(medHUD)
		medHUD = 0
		src << "\blue <B>Medical HUD Disabled</B>"
	else
		medHUD = 1
		src << "\blue <B>Medical HUD Enabled</B>"
*/
/*
/mob/dead/observer/verb/toggle_antagHUD()
	set category = "Ghost"
	set name = "Toggle AntagHUD"
	set desc = "Toggles AntagHUD allowing you to see who is the antagonist"
	if(!config.antag_hud_allowed && !client.holder)
		src << "\red Admins have disabled this for this round."
		return
	if(!client)
		return
	var/mob/dead/observer/M = src
	if(jobban_isbanned(M, "AntagHUD"))
		src << "\red <B>You have been banned from using this feature</B>"
		return
	if(config.antag_hud_restricted && !M.has_enabled_antagHUD &&!client.holder)
		var/response = alert(src, "If you turn this on, you will not be able to take any part in the round.","Are you sure you want to turn this feature on?","Yes","No")
		if(response == "No") return
		M.can_reenter_corpse = 0
	if(!M.has_enabled_antagHUD && !client.holder)
		M.has_enabled_antagHUD = 1
	if(M.antagHUD)
		M.antagHUD = 0
		src << "\blue <B>AntagHUD Disabled</B>"
	else
		M.antagHUD = 1
		src << "\blue <B>AntagHUD Enabled</B>"
*/
/mob/dead/observer/proc/dead_tele()
	set category = "Wraith"
	set name = "Teleport"
	set desc= "Teleport to a location"
	if(!istype(usr, /mob/dead/observer))
		usr << "Not when you're not dead!"
		return
	usr.verbs -= /mob/dead/observer/proc/dead_tele
	spawn(30)
		usr.verbs += /mob/dead/observer/proc/dead_tele
	var/A
	A = input("Area to jump to", "BOOYEA", A) as null|anything in ghostteleportlocs
	var/area/thearea = ghostteleportlocs[A]
	if(!thearea)	return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!L || !L.len)
		usr << "No area available."

	following = null
	usr.loc = pick(L)

var/latepartynum = 0
var/latepartystarted = FALSE
var/hasancest = FALSE
var/hasrolled = FALSE
var/pimp = FALSE
var/sirballat = FALSE
var/countess = FALSE
var/ladyballat = FALSE
var/wardeclared = FALSE
var/forcedlate = null
var/hasgifthand = FALSE

/*
/mob/dead/observer/verb/lateparty()
	set category = "Wraith"
	set name = "LateParty"
	set desc = "Joins the late party."
	//var/latepartynum = 0
	if(master_mode == "holywar" || master_mode == "minimig")
		to_chat(src, "<span class='combatbold'>[pick(nao_consigoen)],</span><span class='combat'> fuck you.</span>")
		return
	if(world.time < 6000)
		to_chat(usr, "<span class='passive'>It's too early for the late party,It will be available in [round((6000-world.time)/600)] minutes.</span>")
		return
	if(latepartynum > 6)
		to_chat(usr, "<span class='bname'>The late party is full!</span>")
		return
	if(latepartynum >= 6)
		if(!latepartied)
			to_chat(usr, "<span class='bname'>You can't join the</span> <span class='bname'>late party</span><span class='bname'>, it's full!</span>")
			check_lateparty()
			return
		else
			latepartied = FALSE
			latepartynum -= 1
			if(can_reenter_corpse)
				can_reenter_corpse = FALSE
				to_chat(usr, "<span class='combatglow'>You throw your chances away.</span>")

	if(!latepartied)
		latepartied = TRUE
		latepartynum += 1
		to_chat(usr, "<span class='passive'>You now have a chance to enter the round as a late group. If you're chosen, it's neccessary to avoid any revenge for the events of your previous life.</span>")
		check_lateparty()
	else
		latepartied = FALSE
		if(latepartynum <= 1)
			latepartynum = 0
		else
			latepartynum -= 1
		if(can_reenter_corpse)
			can_reenter_corpse = FALSE
			to_chat(usr, "<span class='combatglow'>You throw your chances away.</span>")


var/latemaximumreq = 6
var/inspectorarrival = FALSE
var/list/soulbreaker_names = list("Bashar Tarik","Hashim", "Faghil","Eunuch","Saffah","Sadir")

/mob/dead/observer/proc/check_lateparty()
	var/latepartytype = 4
	if(!latepartystarted)
		if(!hasrolled)
			if(forcedlate)
				latepartytype = forcedlate
			else
				latemaximumreq = 6
				if(ticker.mode.config_tag == "siege")
					latepartytype = pick(1,2,4,7,8,9,10,11)
				else
					latepartytype = pick(1,4,5,7,8,9,10,11)

		if(latepartynum >= latemaximumreq)
			for(var/mob/dead/observer/O in world)
				if(O.latepartied == TRUE && O.client)
					O << 'newBuzzer.ogg'
					latepartystarted = TRUE
					O.client.color = null
					hasrolled = TRUE
					O << sound(null, repeat = 0, wait = 0, volume = 0, channel = 12)
					if(latepartytype == 1)
						var/mob/living/carbon/human/new_character = new(pick(latejoin))
						new_character.key = O.key
						new_character.mind.key = O.key
						new_character.gender = MALE
						hasrolled = TRUE
						//ticker.mode.learn_basic_spells(current)
						new_character.f_style = random_facial_hair_style(gender = MALE, species = "Human")
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'>You're a Soulbreaker.</span>")
						to_chat(new_character, "<span class='dreamershit'>You enslave living people so they can restore lost planets. You have many tools to do this, so it should be easy to catch the common migrant.</span>")
						log_admin("[key_name_admin(usr)] has soulbreaker'ed [new_character.key].")
						new_character << sound('sound/music/soulbreaker.ogg', repeat = 0, wait = 0, volume = 80, channel = 3)
						new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(9,9))
						new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(11,11))
						new_character.old_job = "Soulbreaker"
						new_character.name = pick(soulbreaker_names)
						soulbreaker_names.Remove(new_character.name)
						new_character.real_name = new_character.name
						new_character.voice_name = new_character.real_name
						new_character.terriblethings = TRUE
						new_character.vice = pick(VicesList)
						new_character.age = rand(24,45)
						new_character.voicetype = "strong"
						new_character.my_stats.st = rand(13,14)
						if(new_character.name == "Eunuch")
							new_character.my_stats.st = rand(14,15)
							new_character.my_stats.dx = rand(8,9)
							new_character.my_stats.ht = rand(15,16)
							to_chat(new_character, "<span class='dreamershit'>You're the eunuch, teleport people through the console near the teleporter, they require to be wearing the collar on, you can sell these slaves by sitting down in a chair and pressing the console near the briefing room (RMB TO SWITCH BETWEEN : NOBLE, WORK, SEX)</span>")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/head/eunuch(new_character), slot_head)
							new_character.mutilate_genitals()
							log_game("[new_character.real_name]/[new_character.key] spawned as Eunuch")
						if(new_character.name == "Bashar Tarik")
							new_character.my_stats.st = rand(15,17)
							new_character.my_stats.ht = rand(15,16)
							log_game("[new_character.real_name]/[new_character.key] spawned as Bashar")
						else
							new_character.my_stats.st = rand(13,14)
							new_character.add_perk(/datum/perk/ref/strongback)
							new_character.my_stats.dx = rand(8,9)
							new_character.my_stats.ht = rand(13,16)
							log_game("[new_character.real_name]/[new_character.key] spawned as Soulbreaker")
						new_character.religion = "Allah"
						new_character.updatePig()
						for(var/obj/effect/landmark/L in landmarks_list)
							if (L.name == "Soulbreaker")
								new_character.forceMove(pick(L.loc))
						new_character.equip_to_slot_or_del(new /obj/item/weapon/card/id/ltgrey(new_character), slot_wear_id)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/soulbreaker(new_character), slot_w_uniform)
						var/obj/item/device/radio/R = new /obj/item/device/radio/headset/bracelet/soulbreaker(src)
						R.set_frequency(SYND_FREQ)
						new_character.equip_to_slot_or_del(R, slot_wrist_r)
						new_character.microbomb_soulbreaker()
						new_character.my_stats.st = rand(13,14)
					else if(latepartytype == 2)
						if(ticker.mode.config_tag != "siege")
							return
						var/datum/game_mode/siege/S = ticker.mode
						var/mob/living/carbon/human/new_character = new(pick(latejoin))
						new_character.key = O.key
						new_character.mind.key = O.key
						if(!countess && S.hascount.gender == MALE ||!countess && S.hascount.has_penis())
							new_character.gender = FEMALE
						else
							new_character.gender = MALE
						new_character.real_name  = random_name(new_character.gender)
						new_character.name = new_character.real_name
						new_character.voice_name = new_character.real_name
						latepartystarted = FALSE
						new_character.vice = pick(VicesList)
						new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
						new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
						var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(src)
						R.set_frequency(SYND_FREQ)
						new_character.equip_to_slot_or_del(R, slot_l_ear)
						var/obj/effect/landmark/SG = pick(siegestart)
						new_character.forceMove(SG.loc)
						if(!countess)
							countess = TRUE
							new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 5)
							new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(7,9))
							new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(10,11))
							new_character.my_skills.CHANGE_SKILL(SKILL_RIDE, rand(10,11))
							new_character.my_skills.CHANGE_SKILL(SKILL_COOK, rand(10,12))
							new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(8,8))
							new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(7,7))
							new_character.age = rand(18,30)
							new_character.my_stats.st = rand(9,11)
							new_character.my_stats.dx = rand(13,14)
							new_character.my_stats.ht = rand(10,12)
							new_character.old_job = "Countess"
							new_character.job = "Countess"
							log_game("[new_character.real_name]/[new_character.key] spawned as Countess (LP)")
							new_character.voicetype = "noble"
							if(new_character.gender == FEMALE)
								to_chat(new_character, "<span class='dreamershitfuckcomicao1'>You're the Countess, you follow your husband so he can't cheat on you.</span>")
								to_chat(new_character, "<span class='dreamershit'>Still alive until the end!</span>")
								new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/migrant/baroness(new_character), slot_w_uniform)
								new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/baronessdress(new_character), slot_wear_suit)
								new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(new_character), slot_shoes)
								new_character.equip_to_slot_or_del(new /obj/item/clothing/head/sunhat(new_character), slot_head)
								new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/evening(new_character), slot_gloves)
								new_character.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/minisatchelchurch2(new_character), slot_back)
								if(new_character.back)
									new_character.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/glass/bottle/lifeweb/widowtear(new_character.back), slot_in_backpack)
							else
								to_chat(new_character, "<span class='dreamershitfuckcomicao1'>You're the Countess, you follow your wife so he can't cheat on you.</span>")
								to_chat(new_character, "<span class='dreamershit'>Still alive until the end!</span>")
								new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/captain(new_character), slot_w_uniform)
								new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
								new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/rapier(new_character), slot_r_hand)
								new_character.equip_to_slot_or_del(new /obj/item/sheath(new_character), slot_belt)
							new_character.add_event("nobleblood", /datum/happiness_event/noble_blood)
							new_character.add_perk(/datum/perk/lessstamina)
						else
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'> You're the countess bodyguard.</span>")
							to_chat(new_character, "<span class='dreamershit'>Defend your countess at all cost!</span>")
							new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 9)
							new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 5)
							new_character.my_skills.CHANGE_SKILL(SKILL_MINE, rand(10,10))
							new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(13,13))
							new_character.my_skills.CHANGE_SKILL(SKILL_SURG, rand(9,9))
							new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(9,9))
							new_character.age = rand(17,40)
							new_character.my_stats.st = 11
							new_character.my_stats.dx = rand(9,10)
							new_character.my_stats.ht = rand(10,11)
							new_character.old_job = "Sieger"
							new_character.terriblethings = TRUE
							new_character.job = "Sieger"
							new_character.equip_to_slot_or_del(new /obj/item/clothing/under/common(new_character), slot_w_uniform)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_breastplate(new_character), slot_wear_suit)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/siegehelmet(new_character), slot_head)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
							new_character.equip_to_slot_or_del(new /obj/item/sheath/claymore(new_character), slot_belt)
							log_game("[new_character.real_name]/[new_character.key] spawned as Countess bodyguard.")
						S.siegerslist += new_character
						new_character.siegesoldier = TRUE
						new_character.outsider = TRUE
						new_character.update_all_siege_icons()
						new_character.updatePig()
						new_character.create_kg()
					else if(latepartytype == 3)
						var/mob/living/carbon/human/new_character = new(pick(latejoin))
						new_character.key = O.key
						new_character.mind.key = O.key
						new_character.gender = pick(MALE,FEMALE)
						new_character.real_name  = random_name(new_character.gender)
						new_character.name = new_character.real_name
						new_character.voice_name = new_character.real_name
						latepartystarted = FALSE
						new_character.vice = pick(VicesList)
						new_character.terriblethings = TRUE
						new_character.updatePig()
						for(var/obj/effect/landmark/L in landmarks_list)
							if (L.name == "SkeletonHorde")
								new_character.forceMove(L.loc)
						hasrolled = TRUE
						if(!hasancest)
							hasancest = 1
							new_character.set_species("Skeleton")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'> You're an ancestor.</span>")
							to_chat(new_character, "<span class='dreamershit'> Raid Firethorn!</span>")
							new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(3,6))
							new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(3,5))
							new_character.age = rand(60,100)
							new_character.my_stats.st = rand(12,18)
							new_character.my_stats.dx = rand(13,13)
							new_character.my_stats.ht = rand(13,15)
							new_character.old_job = "Ancestor"
							log_game("[new_character.real_name]/[new_character.key] spawned as Ancestor")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate(new_character), slot_wear_suit)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat/gauntlet/steel(new_character), slot_gloves)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/bastard(new_character), slot_r_hand)
							to_chat(world, "<br>")
							to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
							to_chat(world, "<span class='excomm'>⠀¤ Urgent message to the Baron!¤</span>")
							world << sound('sound/AI/urgent_message.ogg')
							to_chat(world, "<br>")
							for(var/obj/machinery/charon/C in world)
								var/obj/item/weapon/paper/lord/NG = new (C.loc)
								NG.info = "<span class='dreamershit'>Foi detectado um bando de esqueletos a caminho do forte, prepare as defesas!</span>"
								evermail_ref.receive(NG, 1)
						else
							new_character.set_species("Skeleton")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'> You're a skeleton, a screamer that has rotten months ago.</span>")
							to_chat(new_character, "<span class='dreamershit'> Raid Firethorn!</span>")
							new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(1,3))
							new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(1,3))
							new_character.age = rand(50,80)
							new_character.my_stats.st = rand(6,10)
							new_character.my_stats.dx = rand(6,10)
							new_character.my_stats.ht = rand(5,8)
							new_character.old_job = "Skeleton"
							log_game("[new_character.real_name]/[new_character.key] spawned as Skeleton")
							new_character.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/boneclub(new_character), slot_l_hand)
					else if(latepartytype == 4)
						var/mob/living/carbon/human/new_character = new(pick(latejoin))
						new_character.key = O.key
						var/ginklate = pick("Yang","Chi","Chang","Zhao","Huang","Tong","Liao","Qin","Qing","Ming","Wei","Jin","Xia","Yuan","Tang","Sui")
						var/ginkfirst
						new_character.gender = pick(MALE,FEMALE)
						if(new_character.gender == MALE)
							ginkfirst = pick(first_names_male)
						else
							ginkfirst = pick(first_names_female)
						new_character.real_name = "[ginkfirst] [ginklate]"
						new_character.mind.key = O.key
						new_character.voice_name = new_character.real_name
						new_character.vice = pick(VicesList)
						new_character.name  = new_character.real_name
						new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
						new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
						log_game("[new_character.real_name]/[new_character.key] spawned as Gink")
						latepartystarted = TRUE
						hasrolled = TRUE
						new_character << 'ginklate.ogg'
						to_chat(new_character, "<span class='dreamershit'>Escaping from the overcrowded Wei-Ji and north's xenophobia, you finally find somewhere stable to live.</span>")
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #1:</span> <span class='dreamershit'>Arrive at the fortress.</span>")
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #2:</span> <span class='dreamershit'>Find a job.</span>")
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #3:</span> Survive.</span>")
						new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(7,10))
						new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(7,10))
						new_character.age = rand(20,35)
						new_character.my_stats.st = rand(9,11)
						new_character.my_stats.dx = rand(10,11)
						new_character.my_stats.ht = rand(8,11)
						new_character.my_stats.it = rand(10,13)
						new_character.updatePig()
						new_character.old_job = "Gink"
						for(var/obj/effect/landmark/L in landmarks_list)
							if (L.name == "Gink")
								new_character.forceMove(L.loc)
						if(prob(10))
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/tribal_spear(new_character), slot_r_hand)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/head/ricehat(new_character), slot_head)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/leatherboots(new_character), slot_shoes)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/under/gink(new_character), slot_w_uniform)
						new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
					else if(latepartytype == 5)
						var/mob/living/carbon/human/new_character = new(pick(latejoin))
						new_character.key = O.key
						new_character.mind.key = O.key
						new_character.gender = pick(MALE,FEMALE)
						new_character.real_name  = random_name(new_character.gender)
						new_character.name = new_character.real_name
						new_character.voice_name = new_character.real_name
						new_character.vice = pick(VicesList)
						new_character.updatePig()
						new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
						new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
						var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(src)
						R.set_frequency(SYND_FREQ)
						new_character.equip_to_slot_or_del(R, slot_l_ear)
						for(var/obj/effect/landmark/L in landmarks_list)
							if (L.name == "Countgift")
								new_character.forceMove(L.loc)
						latepartystarted = TRUE
						if(!hasgifthand)
							hasgifthand = TRUE
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>You're the Count's hand, you must deliver the count's gift to the baron of Firethorn.</span>")
							to_chat(new_character, "<span class='dreamershit'>Lead your squad to Firethorn and deliver the gift!</span>")
							new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 12)
							new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 9)
							new_character.my_skills.CHANGE_SKILL(SKILL_MINE, rand(10,10))
							new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(13,13))
							new_character.my_skills.CHANGE_SKILL(SKILL_SURG, rand(9,9))
							new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(9,9))
							new_character.age = rand(28,50)
							new_character.my_stats.st = rand(12,14)
							new_character.my_stats.dx = rand(10,11)
							new_character.my_stats.ht = rand(13,14)
							new_character.old_job = "Count Hand"
							new_character.terriblethings = TRUE
							new_character.job = "Count Hand"
							log_game("[new_character.real_name]/[new_character.key] spawned as Count's Hand(Gift)")
							new/obj/structure/closet/crate/secure/baron(new_character.loc)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate(new_character), slot_wear_suit)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat/gauntlet/steel(new_character), slot_gloves)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/bastard(new_character), slot_belt)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/lantern/on(new_character), slot_l_hand)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/under/common(new_character), slot_w_uniform)
							new_character.equip_to_slot_or_del(new /obj/item/countflag(new_character), slot_r_hand)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate(new_character), slot_wear_suit)
							to_chat(world, "<br>")
							to_chat(world, "<h1 class='ravenheartfortress'>Firethorn Fortress</h1>")
							to_chat(world, "<span class='excomm'><b>¤Urgent message for the Baron!¤</b></span>")
							world << sound('sound/AI/urgent_message.ogg')
							to_chat("<br>")
							for(var/obj/machinery/charon/C in world)
								var/obj/item/weapon/paper/lord/NG = new (C.loc)
								NG.info = "<h2>The count sent a group to Firethorn to deliver us a gift!</h2>"
								evermail_ref.receive(NG, 1)
						else
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'> You're the count's hand bodyguard.</span>")
							to_chat(new_character, "<span class='dreamershit'>Help to deliver the gift, protect the hand at all costs!</span>")
							new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 9)
							new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 5)
							new_character.my_skills.CHANGE_SKILL(SKILL_MINE, rand(10,10))
							new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(13,13))
							new_character.my_skills.CHANGE_SKILL(SKILL_SURG, rand(9,9))
							new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(9,9))
							new_character.age = rand(17,40)
							new_character.my_stats.st = 11
							new_character.my_stats.dx = rand(9,10)
							new_character.my_stats.ht = rand(10,11)
							new_character.old_job = "Grunt"
							new_character.terriblethings = TRUE
							new_character.job = "Grunt"
							new_character.equip_to_slot_or_del(new /obj/item/clothing/under/common(new_character), slot_w_uniform)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_breastplate(new_character), slot_wear_suit)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/siegehelmet(new_character), slot_head)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
							new_character.equip_to_slot_or_del(new /obj/item/sheath/claymore(new_character), slot_belt)
							log_game("[new_character.real_name]/[new_character.key] spawned as Grunt(gift)")
						if(ticker.mode.config_tag == "siege")
							var/datum/game_mode/siege/S = ticker.mode
							S.siegerslist += new_character
							new_character.siegesoldier = TRUE
							new_character.update_all_siege_icons()
					else if(latepartytype == 6)
						var/mob/living/carbon/human/new_character = new(pick(latejoin))
						new_character.key = O.key
						new_character.mind.key = O.key
						new_character.gender = pick(MALE,FEMALE)
						new_character.set_species("Zombie")
						new_character.real_name = random_name(new_character.gender)
						new_character.voice_name = new_character.real_name
						new_character.name  = new_character.real_name
						new_character.vice = pick(VicesList)
						new_character.updatePig()
						new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
						if(new_character.gender == MALE)
							new_character.f_style = random_facial_hair_style(gender = MALE, species = "Human")
						latepartystarted = TRUE
						hasrolled = TRUE
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'> Você é um zumbi apodrecendo.</span>")
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #1:</span> <span class='dreamershit'>Se alimente.</span>")
						new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(2,4))
						new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(1,3))
						new_character.terriblethings = TRUE
						new_character.age = rand(30,35)
						new_character.old_job = "Zombie"
						new_character.my_stats.st = rand(9,13)
						new_character.my_stats.dx = rand(9,15)
						new_character.my_stats.ht = rand(8,11)
						new_character.my_stats.it = rand(2,5)
						log_game("[new_character.real_name]/[new_character.key] spawned as zombie")
						for(var/obj/effect/landmark/L in landmarks_list)
							if (L.name == "Zombie")
								new_character.forceMove(L.loc)
						new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
					else if(latepartytype == 7)
						var/mob/living/carbon/human/new_character = new(pick(latejoin))
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Você é uma freira Thanati.</span>")
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #1:</span> <span class='dreamershit'>Elimine a inquisição.</span>")
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #2:</span> <span class='dreamershit'>Ajude a célula thanati.</span>")
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #3:<</span> <span class='dreamershit'>Sobreviva.</span>")
						new_character.key = O.key
						new_character.mind.key = O.key
						new_character.age = rand(18,60)
						new_character.job = "Nun"
						new_character.vice = pick(VicesList)
						new_character.old_job = "Nun"
						new_character.gender = FEMALE
						new_character.real_name  = random_name(new_character.gender)
						new_character.terriblethings = TRUE
						new_character.name = new_character.real_name
						new_character.voice_name = new_character.real_name
						new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
						new_character.religion = "Thanati"
						log_game("[new_character.real_name]/[new_character.key] spawned as Thanati Nun")
						for(var/obj/effect/landmark/L in landmarks_list)
							if (L.name == "NunThanati")
								new_character.forceMove(L.loc)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(new_character), slot_w_uniform)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/nun(new_character), slot_wear_suit)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/black(new_character), slot_shoes)
						new_character.my_skills.CHANGE_SKILL(SKILL_MELEE,rand(5,5))
						new_character.my_skills.CHANGE_SKILL(SKILL_RANGE,rand(6,6))
						new_character.my_skills.CHANGE_SKILL(SKILL_FARM,rand(10,10))
						new_character.my_skills.CHANGE_SKILL(SKILL_COOK,rand(11,12))
						new_character.my_skills.CHANGE_SKILL(SKILL_ENGINE,rand(0,0))
						new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(11,11))
						new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC,rand(11,11))
						new_character.my_skills.CHANGE_SKILL(SKILL_CLEAN,rand(12,12))
						new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(8,8))
						new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(0,0))
						new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(8,9))
						new_character.my_stats.st = 10
						new_character.my_stats.dx = rand(10,11)
						new_character.my_stats.ht = rand(8,9)
						new_character.my_stats.it = 11
					else if(latepartytype == 8)
						var/mob/living/carbon/human/new_character = new(pick(latejoin))
						new_character.vice = pick(VicesList)
						var/mob/living/carbon/human/sirballat_mob
						if(!sirballat)
							sirballat = 1
							sirballat_mob = new_character
							new_character.terriblethings = TRUE
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>You are Sir Ballat, you secretly married Baron Kleiharo's daughter and ran away with her, guards were sent after you to bring your wife back.</span>")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #1:</span> <span class='dreamershit'>Protect your wife at all costs.</span>")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #2:</span> <span class='dreamershit'>Hide in Firethorn.</span>")
							new_character.age = rand(30,45)
							new_character.real_name  = "Sir Ballat"
							new_character.name = new_character.real_name
							new_character.key = O.key
							new_character.mind.key = O.key
							new_character.job = "Sir Ballat"
							new_character.old_job = "Sir Ballat"
							new_character.voice_name = new_character.real_name
							new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
							new_character.f_style = random_facial_hair_style(gender = MALE, species = "Human")
							new_character.gender = "male"
							new_character.updatePig()
							log_game("[new_character.real_name]/[new_character.key] spawned as Sir Ballet")
							for(var/obj/effect/landmark/L in landmarks_list)
								if (L.name == "SirBallat")
									new_character.forceMove(L.loc)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_character), slot_w_uniform)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate(new_character), slot_wear_suit)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/black(new_character), slot_shoes)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/bastard(new_character), slot_belt)
						else if(!ladyballat)
							ladyballat = 1
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>You are Lady Ballat, you secretly married Baron Kleiharo's bodyguard and ran away with him, guards were sent after you to bring you back.</span>")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #1:</span> <span class='dreamershit'>Protect yourself at all costs.</span>")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #2:</span> <span class='dreamershit'>Hide in Firethorn.</span>")
							new_character.age = rand(30,45)
							new_character.key = O.key
							new_character.mind.key = O.key
							new_character.real_name  = "Lady Ballat"
							new_character.job = "Lady Ballat"
							new_character.old_job = "Lady Ballat"
							new_character.name = new_character.real_name
							new_character.voice_name = new_character.real_name
							new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
							new_character.gender = "female"
							new_character.updatePig()
							log_game("[new_character.real_name]/[new_character.key] spawned as Lady Ballet")
							for(var/obj/effect/landmark/L in landmarks_list)
								if (L.name == "LadyBallat")
									new_character.forceMove(L.loc)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_character), slot_w_uniform)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/ladydress(new_character), slot_wear_suit)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/black(new_character), slot_shoes)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol/ml23/gold(new_character), slot_belt)
							matchmaker.setmarriage(sirballat_mob,new_character)
						else
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>You're Baron Kleiharo's bodyguard.</span>")
							to_chat(new_character, "<span class='dreamershit'>Sir Ballat, a glorious bodyguard of Baron Kleiharo, secretly married his daughter and ran away with her. Do they have a chance to escape?</span>")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #1:</B> Find and arrest Kleiharo's daughter ALIVE.")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #2:</B> Find and arrest Sir Ballat.")
							new_character.age = rand(30,45)
							new_character.real_name  = random_name(new_character.gender)
							new_character.name = new_character.real_name
							if(trapapoc.Find(ckey(src.client.key)))
								new_character.gender = pick(MALE,FEMALE)
							else
								new_character.gender = MALE
							new_character.voice_name = new_character.real_name
							new_character.key = O.key
							new_character.mind.key = O.key
							new_character.my_stats.st = rand(12,14)
							new_character.terriblethings = TRUE
							new_character.job = "Kleiharo Guard"
							new_character.old_job = "Kleiharo Guard"
							new_character.my_stats.dx = rand(12,13)
							new_character.my_stats.ht = rand(13,14)
							new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(10,12))
							new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(10,12))
							new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
							new_character.f_style = random_facial_hair_style(gender = MALE, species = "Human")
							new_character.updatePig()
							log_game("[new_character.real_name]/[new_character.key] spawned as Kleiharo Guard")
							for(var/obj/effect/landmark/L in landmarks_list)
								if (L.name == "Kleiharo")
									new_character.forceMove(L.loc)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_character), slot_w_uniform)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/leper(new_character), slot_wear_suit)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/head/plebhood/leper(new_character), slot_head)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/spear(new_character), slot_r_hand)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore(new_character), slot_belt)
					else if(latepartytype == 9)
						var/mob/living/carbon/human/new_character = new(pick(latejoin))
						new_character.vice = pick(VicesList)
						if(!pimp)
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Você é um cafetão do sul procurando ficar rico, você tem bucetas fedidas, bucetas sujas, bucetas peludas e bucetas asiáticas, é hora de lucrar.</span>")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #1:</span> <span class='dreamershit'>Proteja sua esposa a todo custo.</span>")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #2:</span> <span class='dreamershit'>Se esconda em Firethorn.</span>")
							new_character.key = O.key
							new_character.mind.key = O.key
							new_character.age = rand(30,45)
							if(trapapoc.Find(ckey(src.client.key)))
								new_character.gender = pick(MALE,FEMALE)
							else
								new_character.gender = MALE
							new_character.real_name  = pick("Jukebox","Ghettobox","Graga","J.C")
							new_character.name = new_character.real_name
							new_character.old_job = "Pimp"
							new_character.job = "Pimp"
							new_character.terriblethings = TRUE
							new_character.voice_name = new_character.real_name
							new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
							new_character.f_style = random_facial_hair_style(gender = MALE, species = "Human")
							new_character.updatePig()
							new_character.add_perk(/datum/perk/ref/strongback)
							log_game("[new_character.real_name]/[new_character.key] spawned as the Pimp")
							for(var/obj/effect/landmark/L in landmarks_list)
								if (L.name == "Pimp")
									new_character.forceMove(L.loc)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/under/common(new_character), slot_w_uniform)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armitage(new_character), slot_wear_suit)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/black(new_character), slot_shoes)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar(new_character), slot_wear_mask)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_character), slot_glasses)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol/magnum66/mother(new_character), slot_belt)
							pimp = 1
						else
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Você é uma prostituta de um cafetão rico do sul.</span>")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #1:</span> <span class='dreamershit'>Fique rica e siga seu cafetão.</span>")
							to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #2:</span> <span class='dreamershit'>Sobreviva.</span>")
							new_character.age = rand(20,45)
							new_character.key = O.key
							new_character.mind.key = O.key
							new_character.old_job = "Whore"
							new_character.job = "Whore"
							new_character.gender = "female"
							new_character.add_perk(/datum/perk/illiterate)
							new_character.real_name  = random_name(new_character.gender)
							new_character.name = new_character.real_name
							new_character.voice_name = new_character.real_name
							new_character.updatePig()
							new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
							log_game("[new_character.real_name]/[new_character.key] spawned as a Whore")
							for(var/obj/effect/landmark/L in landmarks_list)
								if (L.name == "PimpWhore")
									new_character.forceMove(L.loc)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/hooker/pimp(new_character), slot_wear_suit)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/black(new_character), slot_shoes)
					else if(latepartytype == 10)
						var/mob/living/carbon/human/new_character = new(pick(latejoin))
						new_character.key = O.key
						new_character.mind.key = O.key
						new_character.gender = pick(MALE,FEMALE)
						new_character.real_name  = random_name(new_character.gender)
						new_character.name = new_character.real_name
						new_character.voice_name = new_character.real_name
						new_character.terriblethings = TRUE
						new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
						new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
						new_character.vice = pick(VicesList)
						new_character.updatePig()
						log_game("[new_character.real_name]/[new_character.key] spawned as mortician(lateparty)")
						for(var/obj/effect/landmark/L in landmarks_list)
							if (L.name == "migstart")
								new_character.forceMove(L.loc)
						hasrolled = TRUE
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'> You're a very skilled Mortician coming from Ravenheart.</span>")
						to_chat(new_character, "<span class='dreamershit'> Get to the fortress and feed your new machine!</span>")
						new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(8,11))
						new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 0)
						new_character.my_stats.st = rand(11,12)
						new_character.my_stats.dx = rand(9,10)
						new_character.my_stats.ht = rand(11,12)
						new_character.my_stats.pr = rand(9,10)
						new_character.old_job = "Mortus"
						new_character.job = "Mortus"
						new_character.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(new_character), slot_wrist_r)
						new_character.equip_to_slot_or_del(new /obj/item/daggerssheath(new_character), slot_wrist_l)
						new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/janitor(new_character), slot_w_uniform)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(new_character), slot_shoes)
						new_character.equip_to_slot_or_del(new /obj/item/daggerssheath(new_character), slot_wrist_l)
						new_character.equip_to_slot_or_del(new /obj/item/weapon/chisel(new_character), slot_r_store)
						new_character.equip_to_slot_or_del(new /obj/item/weapon/spacecash/c10(new_character), slot_l_store)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_character), slot_gloves)
						new_character.equip_to_slot_or_del(new /obj/item/weapon/cell/web/empty(new_character), slot_back)
						new_character.add_perk(/datum/perk/ref/strongback)
						new_character.add_perk(/datum/perk/ancitech)
					else if(latepartytype == 11)
						var/mob/living/carbon/human/new_character = new(pick(latejoin))
						new_character.key = O.key
						new_character.mind.key = O.key
						if(trapapoc.Find(ckey(src.client.key)))
							new_character.gender = pick(MALE,FEMALE)
						else
							new_character.gender = MALE
						new_character.real_name  = random_name(new_character.gender)
						new_character.name = new_character.real_name
						new_character.voice_name = new_character.real_name
						new_character.terriblethings = TRUE
						new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
						new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
						new_character.updatePig()
						new_character.vice = pick(VicesList)
						log_game("[new_character.real_name]/[new_character.key] spawned as Cerberus(lateparty)")
						for(var/obj/effect/landmark/L in landmarks_list)
							if (L.name == "migstart")
								new_character.forceMove(L.loc)
						hasrolled = TRUE
						to_chat(new_character, "<span class='dreamershitfuckcomicao1'> You're a very skilled Cerberus coming from Ravenheart.</span>")
						to_chat(new_character, "<span class='dreamershit'> Get to the fortress and look for a new home!</span>")
						new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(12,12))
						new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(11,11))
						new_character.my_stats.st = rand(12,14)
						new_character.my_stats.dx = rand(9,10)
						new_character.my_stats.ht = rand(12,13)
						new_character.my_stats.pr = rand(11,15)
						new_character.old_job = "Cerberus"
						new_character.job = "Cerberus"
						new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_character), slot_w_uniform)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sechelm/cerbhelm(new_character), slot_r_hand)
						new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/cerberusold(new_character), slot_wear_suit)
						new_character.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/taser/leet/sparq(new_character), slot_belt)
						new_character.add_perk(/datum/perk/ref/strongback)
						new_character.add_perk(/datum/perk/morestamina)
						new_character.add_perk(/datum/perk/heroiceffort)
			latepartynum = 0
			for(var/mob/dead/observer/O in mob_list)
				if(O.latepartied)
					O.latepartied = FALSE
		else
			to_chat(usr, "<span class='bname'>⠀[latepartynum]/[latemaximumreq] ready</span>")
	if(latepartystarted)
		to_chat(usr, "<span class='combatglow'>⠀<i>The late party is already here.</i></span>")
*/
// This is the ghost's follow verb with an argument
/mob/dead/observer/proc/ManualFollow(var/atom/movable/target)
	if(target && target != src)
		if(following && following == target)
			return
		following = target
		src << "\blue Now following [target]"
		spawn(0)
			while(target && following == target && client)
				var/turf/T = get_turf(target)
				if(!T)
					break
				// To stop the ghost flickering.
				if(loc != T)
					loc = T
				sleep(15)

/*
/mob/dead/observer/verb/jumptomob() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Ghost"
	set name = "Jump to Mob"
	set desc = "Teleport to a mob"

	if(istype(usr, /mob/dead/observer)) //Make sure they're an observer!


		var/list/dest = list() //List of possible destinations (mobs)
		var/target = null	   //Chosen target.

		dest += getmobs() //Fill list, prompt user with list
		target = input("Please, select a player!", "Jump to Mob", null, null) as null|anything in dest

		if (!target)//Make sure we actually have a target
			return
		else
			var/mob/M = dest[target] //Destination mob
			var/mob/A = src			 //Source mob
			var/turf/T = get_turf(M) //Turf of the destination mob

			if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
				A.loc = T
				following = null
			else
				A << "This mob is not located in the game world."
*/
/mob/dead/observer/verb/boo()
	set category = "Wraith"
	set name = "Flick the Lights"
	set desc= "Scare your crew members because of boredom!"

	if(bootime > world.time) return
	var/obj/machinery/light/L = locate(/obj/machinery/light) in view(1, src)
	if(L)
		L.flicker()
		bootime = world.time + 600
		return
	//Maybe in the future we can add more <i>spooky</i> code here!
	return


/mob/dead/observer/memory()
	set hidden = 1
	src << "\red You are dead! You have no mind to store memory!"

/mob/dead/observer/add_memory()
	set hidden = 1
	src << "\red You are dead! You have no mind to store memory!"
/*
/mob/dead/observer/verb/analyze_air()
	set name = "Analyze Air"
	set category = "Ghost"

	if(!istype(usr, /mob/dead/observer)) return

	// Shamelessly copied from the Gas Analyzers
	if (!( istype(usr.loc, /turf) ))
		return

	var/datum/gas_mixture/environment = usr.loc.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	src << "\blue <B>Results:</B>"
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		src << "\blue Pressure: [round(pressure,0.1)] kPa"
	else
		src << "\red Pressure: [round(pressure,0.1)] kPa"
	if(total_moles)
		for(var/g in environment.gas)
			src << "\blue [gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]% ([round(environment.gas[g], 0.01)] moles)"
		src << "\blue Temperature: [round(environment.temperature-T0C,0.1)]&deg;C"
		src << "\blue Heat Capacity: [round(environment.heat_capacity(),0.1)]"
*/

/mob/dead/observer/verb/toggle_darkness()
	set name = "ToggleDarkness"
	set category = "Wraith"

	if (see_invisible == SEE_INVISIBLE_OBSERVER_NOLIGHTING)
		see_invisible = SEE_INVISIBLE_OBSERVER
	else
		see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING
/*
/mob/dead/observer/verb/become_mouse()
	set name = "Become mouse"
	set category = "Ghost"

	if(config.disable_player_mice)
		src << "<span class='warning'>Spawning as a mouse is currently disabled.</span>"
		return

	var/mob/dead/observer/M = usr
	if(config.antag_hud_restricted && M.has_enabled_antagHUD == 1)
		src << "<span class='warning'>antagHUD restrictions prevent you from spawning in as a mouse.</span>"
		return

	var/timedifference = world.time - client.time_died_as_mouse
	if(client.time_died_as_mouse && timedifference <= mouse_respawn_time * 600)
		var/timedifference_text
		timedifference_text = time2text(mouse_respawn_time * 600 - timedifference,"mm:ss")
		src << "<span class='warning'>You may only spawn again as a mouse more than [mouse_respawn_time] minutes after your death. You have [timedifference_text] left.</span>"
		return

	var/response = alert(src, "Are you -sure- you want to become a mouse?","Are you sure you want to squeek?","Squeek!","Nope!")
	if(response != "Squeek!") return  //Hit the wrong key...again.


	//find a viable mouse candidate
	var/mob/living/simple_animal/mouse/host
	var/obj/machinery/atmospherics/unary/vent_pump/vent_found
	var/list/found_vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in world)
		if(!v.welded && v.z == src.z)
			found_vents.Add(v)
	if(found_vents.len)
		vent_found = pick(found_vents)
		host = new /mob/living/simple_animal/mouse(vent_found.loc)
	else
		src << "<span class='warning'>Unable to find any unwelded vents to spawn mice at.</span>"

	if(host)
		if(config.uneducated_mice)
			host.universal_understand = 0
		host.ckey = src.ckey
		host << "<span class='info'>You are now a mouse. Try to avoid interaction with players, and do not give hints away that you are more than a simple rodent.</span>"

/mob/dead/observer/verb/view_manfiest()
	set name = "View Crew Manifest"
	set category = "Ghost"

	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += data_core.get_manifest()

	src << browse(dat, "window=manifest;size=370x420;can_close=1")

//Used for drawing on walls with blood puddles as a spooky ghost.
*/
/mob/dead/verb/bloody_doodle()

	set category = "Wraith"
	set name = "Write in blood"
	set desc = "If the round is sufficiently spooky, write a short message in blood on the floor or a wall. Remember, no IC in OOC or OOC in IC."

	if(!(config.cult_ghostwriter))
		src << "\red That verb is not currently permitted."
		return

	if (!src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	var/ghosts_can_write
	if(ticker && ticker.mode.name == "cult")
		var/datum/game_mode/cult/C = ticker.mode
		if(C.cult.len > config.cult_ghostwriter_req_cultists)
			ghosts_can_write = 1

	if(!ghosts_can_write)
		src << "\red The veil is not thin enough for you to do that."
		return

	var/list/choices = list()
	for(var/obj/effect/decal/cleanable/blood/B in view(1,src))
		if(B.amount > 0)
			choices += B

	if(!choices.len)
		src << "<span class = 'warning'>There is no blood to use nearby.</span>"
		return

	var/obj/effect/decal/cleanable/blood/choice = input(src,"What blood would you like to use?") in null|choices

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	var/turf/simulated/T = src.loc
	if (direction != "Here")
		T = get_step(T,text2dir(direction))

	if (!istype(T))
		src << "<span class='warning'>You cannot doodle there.</span>"
		return

	if(!choice || choice.amount == 0 || !(src.Adjacent(choice)))
		return

	var/doodle_color = (choice.basecolor) ? choice.basecolor : "#A10808"

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		src << "<span class='warning'>There is no space to write on!</span>"
		return

	var/max_length = 50

	var/message = stripped_input(src,"Write a message. It cannot be longer than [max_length] characters.","Blood writing", "")

	if (message)

		if (length(message) > max_length)
			message += "-"
			src << "<span class='warning'>You ran out of blood to write with!</span>"

		var/obj/effect/decal/cleanable/blood/writing/W = PoolOrNew(/obj/effect/decal/cleanable/blood/writing, T)
		W.basecolor = doodle_color
		W.update_icon()
		W.message = message
		W.add_hiddenprint(src)
		W.visible_message("\red Invisible fingers crudely paint something in blood on [T]...")
/*COISAS RANDOM DE GHOST.*/
/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /mob/dead/observer))
		return 1
	. = ..()
/obj/machinery/door/CheckExit(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /mob/dead/observer))
		return 1
	. = ..()
/obj/structure/grille/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /mob/dead/observer))
		return 1
	. = ..()
/obj/structure/grille/CheckExit(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /mob/dead/observer))
		return 1
	. = ..()

/obj/structure/grille/reinforced/l/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /mob/dead/observer))
		return 1
	. = ..()
/obj/structure/grille/reinforced/l/CheckExit(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /mob/dead/observer))
		return 1
	. = ..()

/obj/structure/mineral_door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /mob/dead/observer))
		return 1
	. = ..()

/obj/structure/mineral_door/CheckExit(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /mob/dead/observer))
		return 1
	. = ..()

/obj/structure/CheckExit(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /mob/dead/observer))
		return 1
	. = ..()
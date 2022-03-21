/mob/Destroy()//This makes sure that mobs with clients/keys are not just deleted from the game.
	mob_list -= src


	unset_machine()
	if(hud_used)
		qdel(hud_used)
	if(attack_delayer)
		attack_delayer = null
		qdel(attack_delayer)
	if(click_delayer)
		click_delayer = null
		qdel(click_delayer)
	if(clong_delayer)
		clong_delayer = null
		qdel(clong_delayer)

	lastarea = null
	loc = null
	qdel(reagents)
	if(special_delayer)
		special_delayer = null
		qdel(special_delayer)
	if(throw_delayer)
		throw_delayer = null
		qdel(throw_delayer)
	clear_fullscreen()
	if(client)

		for(var/atom/movable/AM in client.screen)
			var/obj/screen/screenobj = AM
			if(!istype(screenobj) || !screenobj.globalscreen)
				qdel(screenobj)
		client.screen = list()
	if(client)
		ghostize()

	if(mind)
		qdel(mind)
	if(client)
		client = null
	. = ..()


/atom/movable/Destroy()
	if(virtual_mob && !ispath(virtual_mob))
		qdel(virtual_mob)
	virtual_mob = null
	return ..()

/mob/observer/virtual/Destroy()
	moved_event.unregister(host, src, /atom/movable/proc/move_to_turf_or_null)
	all_virtual_listeners -= src
	host.virtual_mob -= src
	host = null
	qdel(attack_delayer)
	qdel(click_delayer)
	qdel(clong_delayer)
	lastarea = null
	qdel(overlay_icons)
	qdel(special_delayer)
	qdel(throw_delayer)
	loc = null
	return ..()

/obj/Destroy()
	processing_objects -= src
	return ..()

/mob/New()
	mob_list += src
	if(stat == DEAD)
		dead_mob_list += src
	else
		living_mob_list += src
	update_gravity(src)
	..()

/mob/proc/Cell()
	set category = "Admin"
	set hidden = 1

	if(!loc) return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/t = "\blue Coordinates: [x],[y] \n"
	t+= "\red Temperature: [environment.temperature] \n"
	t+= "\blue Nitrogen: [environment.gas["nitrogen"]] \n"
	t+= "\blue Oxygen: [environment.gas["oxygen"]] \n"
	t+= "\blue Plasma : [environment.gas["plasma"]] \n"
	t+= "\blue Carbon Dioxide: [environment.gas["carbon_dioxide"]] \n"
/*	for(var/datum/gas/trace_gas in environment.trace_gases)
		usr << "\blue [trace_gas.type]: [trace_gas.moles] \n"
*/
	usr.show_message(t, 1)

/mob/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)

	if(!client)	return

	if (type)
		if(type & 1 && (sdisabilities & BLIND || blinded || paralysis) )//Vision related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
		if (type & 2 && (sdisabilities & DEAF || ear_deaf))//Hearing related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
				if ((type & 1 && sdisabilities & BLIND))
					return
	// Added voice muffling for Issue 41.
	if(!(stat == UNCONSCIOUS || sleeping > 0))
		to_chat(src, msg)
	return

// Show a message to all mobs in sight of this one
// This would be for visible actions by the src mob
// message is the message output to anyone who can see e.g. "[src] does something!"
// self_message (optional) is what the src mob sees  e.g. "You do something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"

/mob/visible_message(var/message, var/self_message, var/blind_message)
	for(var/mob/M in viewers(src))
		var/msg = message
		if(self_message && M==src)
			msg = self_message
		M.show_message( msg, 1, blind_message, 2)

// Show a message to all mobs in sight of this atom
// Use for objects performing visible actions
// message is output to anyone who can see, e.g. "The [src] does something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/atom/proc/visible_message(var/message, var/blind_message)
	for(var/mob/M in viewers(src))
		M.show_message( message, 1, blind_message, 2)


/mob/proc/findname(msg)
	. = 0
	for(var/mob/M in mob_list)
		if (M.real_name == text("[]", msg))
			return M
	return 0

/mob/proc/movement_delay(var/actualDir, var/goingTo)
	return (base_movement_tally() * movement_tally_multiplier())

/mob/proc/base_movement_tally()
	if(istype(loc, /turf))
		var/Adds = 1
		for(var/obj/train/T in loc)
			Adds = 0
		if(Adds)
			. += loc:movement_delay

	switch(m_intent)
		if("run")
			if(drowsyness > 0)
				. += 6
			. += config.run_speed
		if("walk")
			. += config.walk_speed

/mob/proc/movement_tally_multiplier()
	. = 1
	var/turf/T = loc
	if(istype(T))
		. = T.adjust_slowdown(src, .)
	if(movement_speed_modifier)
		. *= (1/movement_speed_modifier)

/mob/var/movement_speed_modifier = 1

/turf/proc/adjust_slowdown(mob/living/L, base_slowdown)
	for(var/atom/A in src)
		if(A.slowdown_modifier)
			base_slowdown *= A.slowdown_modifier
	base_slowdown *= turf_speed_multiplier
	return base_slowdown


/mob/proc/Life()
//	if(organStructure)
//		organStructure.ProcessOrgans()
	//handle_typing_indicator()
	return

/mob/proc/get_item_by_slot(slot_id)
	switch(slot_id)
		if(slot_l_hand)
			return l_hand
		if(slot_r_hand)
			return r_hand
	return null

/mob/proc/restrained()
	return

//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(slot)
	var/obj/item/W = get_active_hand()
	if(istype(W))
		equip_to_slot_if_possible(W, slot, delay=1)

/mob/proc/put_in_any_hand_if_possible(obj/item/W as obj, del_on_fail = 0, disable_warning = 1, redraw_mob = 1, delay=0)
	if(equip_to_slot_if_possible(W, slot_l_hand, del_on_fail, disable_warning, redraw_mob))
		return 1
	else if(equip_to_slot_if_possible(W, slot_r_hand, del_on_fail, disable_warning, redraw_mob))
		return 1
	return 0

//This is a SAFE proc. Use this instead of equip_to_splot()!
//set del_on_fail to have it delete W if it fails to equip
//set disable_warning to disable the 'you are unable to equip that' warning.
//unset redraw_mob to prevent the mob from being redrawn at the end.
/mob/proc/equip_to_slot_if_possible(obj/item/W as obj, slot, del_on_fail = 0, disable_warning = 0, redraw_mob = 1, delay=0)
	if(!istype(W)) return 0

	if(!W.mob_can_equip(src, slot, disable_warning))
		if(del_on_fail)
			qdel(W)
		else
			if(!disable_warning)
				src << "\red You are unable to equip that." //Only print if del_on_fail is false
		return 0

	equip_to_slot(W, slot, redraw_mob, delay) //This proc should not ever fail.
	return 1

//This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on whether you can or can't eqip need to be done before! Use mob_can_equip() for that task.
//In most cases you will want to use equip_to_slot_if_possible()
/mob/proc/equip_to_slot(obj/item/W as obj, slot, var/delay=0)
	return

//This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to equip people when the rounds tarts and when events happen and such.
/mob/proc/equip_to_slot_or_del(obj/item/W as obj, slot)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0)

//The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot.
var/list/slot_equipment_priority = list( \
		slot_back,\
		slot_wrist_r,\
		slot_wrist_l,\
		slot_amulet,\
		slot_back2,\
		slot_wear_id,\
		slot_w_uniform,\
		slot_wear_suit,\
		slot_wear_mask,\
		slot_head,\
		slot_shoes,\
		slot_gloves,\
		slot_l_ear,\
		slot_r_ear,\
		slot_glasses,\
		slot_belt,\
		slot_s_store,\
		slot_l_store,\
		slot_r_store\
	)

//puts the item "W" into an appropriate slot in a human's inventory
//returns 0 if it cannot, 1 if successful
/mob/proc/equip_to_appropriate_slot(obj/item/W)
	if(!istype(W)) return 0

	for(var/slot in slot_equipment_priority)
		if(equip_to_slot_if_possible(W, slot, 0, 1, 1)) //del_on_fail = 0; disable_warning = 0; redraw_mob = 1
			return 1

	return 0

/mob/proc/reset_view(atom/A)
	if (client)
		if(looking_up)
			var/turf/T = locate(x, y, z + 1)
			if(!istype(T, /turf/simulated/floor/open))
				looking_up = FALSE
				return reset_view(0)
			client.perspective = EYE_PERSPECTIVE
			client.eye = T
			return
		if (istype(A, /atom/movable))
			client.perspective = EYE_PERSPECTIVE
			client.eye = A
			src.looking_up = FALSE
		else
			if (isturf(loc))
				client.eye = client.mob
				client.perspective = MOB_PERSPECTIVE
				src.looking_up = FALSE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
				src.looking_up = FALSE
	return


/mob/proc/show_inv(mob/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[name]")
	return

/mob/proc/ret_grab(obj/effect/list_container/mobl/L as obj, flag)
	if ((!( istype(l_hand, /obj/item/weapon/grab) ) && !( istype(r_hand, /obj/item/weapon/grab) )))
		if (!( L ))
			return null
		else
			return L.container
	else
		if (!( L ))
			L = new /obj/effect/list_container/mobl( null )
			L.container += src
			L.master = src
		if (istype(l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = l_hand
			if (!( L.container.Find(G.affecting) ))
				L.container += G.affecting
				if (G.affecting)
					G.affecting.ret_grab(L, 1)
		if (istype(r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = r_hand
			if (!( L.container.Find(G.affecting) ))
				L.container += G.affecting
				if (G.affecting)
					G.affecting.ret_grab(L, 1)
		if (!( flag ))
			if (L.master == src)
				var/list/temp = list(  )
				temp += L.container
				//L = null
				qdel(L)
				return temp
			else
				return L.container
	return

/mob/var/football_mode = FALSE

/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	if(istype(loc,/obj/mecha)) return
	if (ishuman(src) && src.football_mode)
		var/mob/living/carbon/human/H = src
		if (H.football)
			var/turf/target = get_turf(H.football.loc)
			var/range = H.football.throw_range
			var/throw_dir = H.dir
			for(var/i = 1; i < range; i++)
				var/turf/new_turf = get_step(target, throw_dir)
				target = new_turf
				if(new_turf && new_turf.density)
					break
			H.football.owner = null
			H.football.throw_at(target, range, H.football.throw_speed, src)
			H.football.icon_state = H.football.normalstate
			visible_message("<span class='passivebold'>[src]</span><span class = 'passive'> kicks \the [H.football.name].</span>")
			H.football = null
			return
		else if (!H.football) //proceed to tackle whoever is in front
			Weaken(1)
			for (var/mob/living/carbon/human/HM in get_step(src.loc, dir))
				if (prob(80))
					visible_message("<span color='hitbold'>[src]</span><span color='hit'> tackles </span><span color='hitbold'>[HM]!</span>")
					playsound(loc, 'sound/weapons/punch1.ogg', 50, 1)
					HM.Weaken(1)
					if (HM.football)
						HM.football.owner = null
						HM.football.throw_at(get_step(HM.loc,HM.dir), 1, 1, HM)
						HM.football.icon_state = HM.football.normalstate
						HM.football = null
				else
					visible_message("<span color='hitbold'>[src]</span><span color='hit'> tries to tackle </span><span color='hitbold'>[HM]</span><span color='hit'>but fails!</span>")
					playsound(loc, 'sound/weapons/punchmiss.ogg', 50, 1)
				return

	if(hand)
		var/obj/item/W = l_hand
		if (W)
			W.attack_self(src)
			update_inv_l_hand()
	else
		var/obj/item/W = r_hand
		if (W)
			W.attack_self(src)
			update_inv_r_hand()
	if(next_move < world.time)
		next_move = world.time + 2
	return

/*
/mob/verb/dump_source()

	var/master = "<PRE>"
	for(var/t in typesof(/area))
		master += text("[]\n", t)
		//Foreach goto(26)
	src << browse(master)
	return
*/

/mob/verb/memory()
	set name = "Notes"
	set category = "IC"
	if(mind)
		mind.show_memory(src)
	else
		src << "The game appears to have misplaced your mind datum, so we can't show you your notes."

/mob/verb/add_memory(msg as message)
	set name = "Add Note"
	set category = "IC"

	msg = copytext(msg, 1, MAX_MESSAGE_LEN)
	msg = sanitize(msg)

	if(mind)
		mind.store_memory(msg)
	else
		src << "The game appears to have misplaced your mind datum, so we can't show you your notes."

/mob/verb/AddNote()
	if(!client) return
	var/input = sanitize(input(usr, "What am i remembering?", "Memories", "") as message|null, list("\t"="#","ÿ"="&#255;"))
	if(!input) return
	if(mind)
		mind.store_memory(input)

/mob/proc/store_memory(msg as message, popup, sane = 1)
	msg = copytext(msg, 1, MAX_MESSAGE_LEN)

	if (sane)
		msg = sanitize(msg)

	if (length(memory) == 0)
		memory += msg
	else
		memory += "<BR>[msg]"

	if (popup)
		memory()

/mob/proc/update_flavor_text()
	set src in usr
	if(usr != src)
		usr << "No."
	var/msg = input(usr,"Set the flavor text in your 'examine' verb. Can also be used for OOC notes about your character.","Flavor Text",rhtml_decode_paper(flavor_text)) as message|null

	if(msg != null)
//		msg = sanitize_uni(copytext(msg, 1, MAX_MESSAGE_LEN))
		msg = rhtml_encode_paper(msg)

		flavor_text = msg

/mob/proc/warn_flavor_changed()
	if(flavor_text && flavor_text != "") // don't spam people that don't use it!
		src << "<h2 class='alert'>OOC Warning:</h2>"
		src << "<span class='alert'>Your flavor text is likely out of date! <a href='byond://?src=\ref[src];flavor_change=1'>Change</a></span>"

/mob/proc/print_flavor_text()
	if(flavor_text && flavor_text != "")
		var/msg = sanitize_uni(replacetext(flavor_text, "\n", " "))
		if(length(msg) <= 40)
			return "\blue [msg]"
		else
			return "\blue [copytext(msg, 1, 37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</a>"
	else
		return 0
/*
/mob/verb/abandon_mob()
	set name = "GotoHell"
	set category = "OOC"
	if(master_mode != "holywar")
		if (!( abandon_allowed ))
			to_chat(src, "Respawn is disabled.")
			return
		if ((stat != 2 || !( ticker )))
			to_chat(src, "<B>You must be dead to use this!</B>")
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
		usr << "You have been dead for[pluralcheck] [deathtimeseconds] seconds."


		if (deathtime < 6000)
			to_chat(src, "You must wait 10 minutes to escape from the limbo!")
			return

		log_game("[usr.name]/[usr.key] used abandon mob.")

		to_chat(src, " <B>Make sure to play a different personality!</B>")

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
		M.client.lobbyPig()
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
		M.client.lobbyPig()
	return
*/
/*
/client/verb/changes()
	set name = "Changelog"
	set category = "OOC"
	getFiles(
		'html/postcardsmall.jpg',
		'html/somerights20.png',
		'html/88x31.png',
		'html/bug-minus.png',
		'html/cross-circle.png',
		'html/hard-hat-exclamation.png',
		'html/image-minus.png',
		'html/image-plus.png',
		'html/music-minus.png',
		'html/music-plus.png',
		'html/tick-circle.png',
		'html/wrench-screwdriver.png',
		'html/spell-check.png',
		'html/burn-exclamation.png',
		'html/chevron.png',
		'html/chevron-expand.png',
		'html/changelog.css',
		'html/changelog.js',
		'html/changelog.html'
		)
	src << browse('html/changelog.html', "window=changes;size=675x650")
	if(prefs.lastchangelog != changelog_hash)
		prefs.lastchangelog = changelog_hash
		prefs.save_preferences()
		winset(src, "rpane.changelog", "background-color=none;font-style=;")
*/
/mob/verb/observe()
	set name = "Observe"
	set category = "OOC"
	var/is_admin = 0

	if(client.holder && (client.holder.rights & R_ADMIN))
		is_admin = 1
	else if(stat != DEAD || istype(src, /mob/new_player))
		usr << "\blue You must be observing to use this!"
		return

	if(is_admin && stat == DEAD)
		is_admin = 0

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()

	for(var/obj/O in world)				//EWWWWWWWWWWWWWWWWWWWWWWWW ~needs to be optimised
		if(!O.loc)
			continue
		if(istype(O, /obj/item/weapon/disk/nuclear))
			var/name = "Nuclear Disk"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O

		if(istype(O, /obj/machinery/singularity))
			var/name = "Singularity"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O

		if(istype(O, /obj/machinery/bot))
			var/name = "BOT: [O.name]"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O


	for(var/mob/M in sortAtom(mob_list))
		var/name = M.name
		if (names.Find(name))
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1

		creatures[name] = M


	client.perspective = EYE_PERSPECTIVE

	var/eye_name = null

	var/ok = "[is_admin ? "Admin Observe" : "Observe"]"
	eye_name = input("Please, select a player!", ok, null, null) as null|anything in creatures

	if (!eye_name)
		return

	var/mob/mob_eye = creatures[eye_name]

	if(client && mob_eye)
		client.eye = mob_eye
		if (is_admin)
			client.adminobs = 1
			if(mob_eye == client.mob || client.eye == client.mob)
				client.adminobs = 0

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "OOC"
	reset_view(null)
	unset_machine()
	if(istype(src, /mob/living))
		if(src:cameraFollow)
			src:cameraFollow = null

/mob/Topic(href, href_list)
	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		unset_machine()
		src << browse(null, t1)

	if(href_list["flavor_more"])
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", name, sanitize_uni(replaceText(flavor_text), "\n", "<BR>")), text("window=[];size=500x200", name))
		onclose(usr, "[name]")
	if(href_list["flavor_change"])
		update_flavor_text()
	return


/mob/proc/pull_damage()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.health - H.halloss <= config.health_threshold_softcrit)
			for(var/name in H.organs_by_name)
				var/datum/organ/external/e = H.organs_by_name[name]
				if(H.lying)
					if(((e.status & ORGAN_BROKEN && !(e.status & ORGAN_SPLINTED)) || e.status & ORGAN_BLEEDING) && (H.getBruteLoss() + H.getFireLoss() >= 100))
						return 1
						break
		return 0

/mob/MouseDrop(mob/M as mob)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	if(istype(M,/mob/living/silicon/ai)) return
	show_inv(usr)


/mob/verb/stop_pulling()

	set name = "Stop Pulling"
	set category = "IC"

	if(pulling)
		pulling.pulledby = null
		pulling = null

/mob/proc/start_pulling(var/atom/movable/AM)

	if ( !AM || !usr || src==AM || !isturf(src.loc) )	//if there's no person pulling OR the person is pulling themself OR the object being pulled is inside something: abort!
		return

	if (AM.anchored)
		return

	if(iszombie(src)) // No...
		return

	var/mob/M = AM
	if(ismob(AM))
		if(!iscarbon(src))
			M.LAssailant = null
		else
			M.LAssailant = usr

	if(pulling)
		var/pulling_old = pulling
		stop_pulling()
		// Are we pulling the same thing twice? Just stop pulling.
		if(pulling_old == AM)
			return

	src.pulling = AM
	AM.pulledby = src

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.pull_damage())
			src << "\red <B>Pulling \the [H] in their current condition would probably be a bad idea.</B>"

	//Attempted fix for people flying away through space when cuffed and dragged.
	if(ismob(AM))
		var/mob/pulled = AM
		pulled.inertia_dir = 0

/mob/proc/can_use_hands()
	return

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/is_mechanical()
	if(mind && (mind.assigned_role == "Cyborg" || mind.assigned_role == "AI"))
		return 1
	return istype(src, /mob/living/silicon) || get_species() == "Machine"


/mob/proc/see(message)
	if(!is_active())
		return 0
	src << message
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		M.see(message)

/*
adds a dizziness amount to a mob
use this rather than directly changing var/dizziness
since this ensures that the dizzy_process proc is started
currently only humans get dizzy

value of dizziness ranges from 0 to 1000
below 100 is not dizzy
*/
/mob/proc/make_dizzy(var/amount)
	if(!istype(src, /mob/living/carbon/human)) // for the moment, only humans get dizzy
		return

	dizziness = min(1000, dizziness + amount)	// store what will be new value
													// clamped to max 1000
	if(dizziness > 100 && !is_dizzy)
		spawn(0)
			dizzy_process()


/*
dizzy process - wiggles the client's pixel offset over time
spawned from make_dizzy(), will terminate automatically when dizziness gets <100
note dizziness decrements automatically in the mob's Life() proc.
*/
/mob/proc/dizzy_process()
	is_dizzy = 1
	while(dizziness > 100)
		if(client)
			var/amplitude = dizziness*(sin(dizziness * 0.044 * world.time) + 1) / 70
			client.pixel_x = amplitude * sin(0.008 * dizziness * world.time)
			client.pixel_y = amplitude * cos(0.008 * dizziness * world.time)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_dizzy = 0
	if(client)
		client.pixel_x = 0
		client.pixel_y = 0

// jitteriness - copy+paste of dizziness

/mob/proc/Jitter(var/amount)
	if(!istype(src, /mob/living/carbon/human)) // for the moment, only humans get dizzy
		return

	jitteriness = min(1000, jitteriness + amount)	// store what will be new value
													// clamped to max 1000
	if(jitteriness > 100 && !is_jittery)
		spawn(0)
			jittery_process()


// Typo from the oriignal coder here, below lies the jitteriness process. So make of his code what you will, the previous comment here was just a copypaste of the above.
/mob/proc/jittery_process()
	var/old_x = pixel_x
	var/old_y = pixel_y
	is_jittery = 1
	while(jitteriness > 100)
//		var/amplitude = jitteriness*(sin(jitteriness * 0.044 * world.time) + 1) / 70
//		pixel_x = amplitude * sin(0.008 * jitteriness * world.time)
//		pixel_y = amplitude * cos(0.008 * jitteriness * world.time)

		var/amplitude = min(4, jitteriness / 100)
		pixel_x = rand(-amplitude, amplitude)
		pixel_y = rand(-amplitude/3, amplitude/3)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_jittery = 0
	pixel_x = old_x
	pixel_y = old_y


// facing verbs
/mob/proc/canface()
	if(!canmove)						return 0
	if(stat)							return 0
	if(anchored)						return 0
	if(monkeyizing)						return 0
	if(restrained())					return 0
	return 1

//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
//Robots and brains have their own version so don't worry about them
/mob/proc/update_canmove()
        var/ko = weakened || paralysis || stat || (status_flags & FAKEDEATH)
        var/bed = !(buckled && istype(buckled, /obj/structure/stool/bed/chair))
        if(ko || stunned)
                drop_r_hand()
                drop_l_hand()
        else
                lying = 0
                canmove = 1
        if(buckled && (!istype(buckled, /mob/living/carbon/human) && !istype(buckled, /obj/structure/stool/bed/chair/wheelchair)))
                lying = 90 * bed
                anchored = buckled
        else
                if((ko || resting) && !lying && !istype(buckled, /mob/living/carbon/human))
                        fall(ko)
        canmove = !(ko || resting || stunned || buckled && (!istype(buckled, /mob/living/carbon/human)) && !istype(buckled, /obj/structure/stool/bed/chair/wheelchair))

        density = !lying
        if(!istype(buckled, /mob/living/carbon/human))
                layer = initial(layer)
        if(lying)
                layer = 3.9
        if(ishuman(src))
                var/mob/living/carbon/human/H = src
                if(H.isLeaning)
                        density = 0
                        layer = layer-0.1
                        if(istype(buckled, /mob/living/carbon/human))
                                lying = 0
        update_transform()
        lying_prev = lying
        if(update_icon) //forces a full overlay update
                update_icon = 0
                regenerate_icons()
        update_vision_cone()
        return canmove


/mob/proc/fall(var/forced)
	drop_l_hand()
	drop_r_hand()

/mob/proc/facedir(var/ndir)
	if(!canface() || client?.moving || world.time < client.move_delay)
		return 0
	set_dir(ndir)
	client.move_delay += movement_delay()
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		var/datum/organ/external/head/E = H.get_organ("head")
		if(E && E.headwrenched)
			H.update_hair()
			H.update_inv_glasses()
			H.update_inv_head()
			H.update_body()
			H.UpdateDamageIcon()
	return 1

/mob/verb/eastface()
	set hidden = 1
	return facedir(client.client_dir(EAST))


/mob/verb/westface()
	set hidden = 1
	return facedir(client.client_dir(WEST))


/mob/verb/northface()
	set hidden = 1
	return facedir(client.client_dir(NORTH))


/mob/verb/southface()
	set hidden = 1
	return facedir(client.client_dir(SOUTH))


/mob/proc/IsAdvancedToolUser()//This might need a rename but it should replace the can this mob use things check
	return 0


/mob/proc/Stun(amount)
	if(ismonster(src)){
		return
	}
	if(status_flags & CANSTUN)
		stunned = max(max(stunned,amount),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		//facing_dir = null
		//resting = 1
	return

/mob/proc/SetStunned(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned = max(amount,0)
		//resting = 1
	return

/mob/proc/AdjustStunned(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount,0)
	return

/mob/proc/Weaken(amount)
	if(ismonster(src)){
		return
	}
	if(status_flags & CANWEAKEN)
		weakened = max(max(weakened,amount),0)
		update_canmove()	//updates lying, canmove and icons
		resting = 1
	return

/mob/proc/SetWeakened(amount)
	if(status_flags & CANWEAKEN)
		facing_dir = null
		//resting = 1
		weakened = max(amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/AdjustWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(weakened + amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/Paralyse(amount)
	if(ismonster(src)){
		return
	}
	if(status_flags & CANPARALYSE)
		facing_dir = null
		paralysis = max(max(paralysis,amount),0)
	return

/mob/proc/SetParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(amount,0)
		//resting = 1
	return

/mob/proc/AdjustParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(paralysis + amount,0)
	return

/mob/proc/Sleeping(amount)
	facing_dir = null
	sleeping = max(max(sleeping,amount),0)
	return

/mob/proc/SetSleeping(amount)
	sleeping = max(amount,0)
	return

/mob/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount,0)
	return

/mob/proc/Resting(amount)
	facing_dir = null
	resting = max(max(resting,amount),0)
	return

/mob/proc/SetResting(amount)
	resting = max(amount,0)
	return

/mob/proc/AdjustResting(amount)
	resting = max(resting + amount,0)
	return

/mob/proc/Dizzy(amount)
	dizziness = max(dizziness,amount,0)

/mob/proc/SpeciesCanConsume()
	return 0

/mob/proc/get_species()
	return ""

/mob/proc/yank_out_object()
	set category = "Object"
	set name = "Yank out object"
	set desc = "Remove an embedded item at the cost of bleeding and pain."
	set src in view(1)

	if(!isliving(usr) || usr.next_move > world.time)
		return
	usr.next_move = world.time + 20

	if(usr.stat == 1)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/list/valid_objects = list()
	var/self = null

	if(S == U)
		self = 1 // Removing object from yourself.

	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		valid_objects = H.get_visible_implants(0)
/*		if(/obj/item/weapon/surgery_tool/speculum in valid_objects)
			for(var/datum/organ/external/organ in H.organs)
				for(var/obj/item/weapon/surgery_tool/speculum/SP in organ.implants)
					if(organ.open != 2)
						to_chat(U, "<span class='combat'>The [SP.name] stucks in [S]'s body!</span>")*/
	else
		for(var/obj/item/W in embedded)
			valid_objects += W

	if(!valid_objects.len)
		if(self)
			to_chat(src,"You have nothing stuck in your body that is large enough to remove.")
		else
			to_chat(U, "[src] has nothing stuck in their wounds that is large enough to remove.")
		src.verbs -= /mob/proc/yank_out_object
		return

	var/obj/item/weapon/selection = input("What do you want to yank out?", "Embedded objects") in valid_objects

	if(self)
		to_chat(usr, "<span class='combat'>You attempt to get a good grip on the [selection] in your body.</span>")
	else
		to_chat(U,  "<span class='combat'>You attempt to get a good grip on the [selection] in [S]'s body.</span>")

	if(!do_after(U, 2))
		return
	if(!selection || !S || !U)
		return

	if(self)
		visible_message("<span class='combat'><b>[src] rips [selection] out of their body.</b></span>","<span class='combat'><b>You rip [selection] out of your body.</b></span>")
	else
		visible_message("<span class='combat'><b>[usr] rips [selection] out of [src]'s body.</b></span>","<span class='combat'><b>[usr] rips [selection] out of your body.</b></span>")
	src.update_icons()
	usr.update_icons()
	playsound(src.loc, selection.drawsound, 50, 0, -1)
	if(istype(src,/mob/living/carbon/human))

		var/mob/living/carbon/human/H = src
		var/datum/organ/external/affected

		for(var/datum/organ/external/organ in H.organs) //Grab the organ holding the implant.
			for(var/obj/item/weapon/O in organ.implants)
				if(O == selection)
					affected = organ

		affected.implants -= selection
		if(selection in src.pinned)
			src.pinned -= selection
			if(!pinned.len)
				anchored = 0
		if(istype(selection, /obj/item/weapon/surgery_tool/speculum))
			affected.open = 1
			H.update_surgery(1)
		U.put_in_hands(selection)

		H.bloody_hands(S)
		H.update_icons()
		H.update_embedhit()

		return 1
/*
/mob/living/verb/head()
	set hidden = 1
	usr.unlock_medal("Find Head", 0, "You found head!", "medium")
*/
/mob/living/proc/handle_statuses()
	handle_stunned()
	handle_weakened()
	handle_stuttering()
	handle_silent()
	handle_drugged()
	handle_slurring()

/mob/living/proc/handle_stunned()
	if(stunned)
		AdjustStunned(-1)
	return stunned

/mob/living/proc/handle_weakened()
	if(weakened)
		weakened = max(weakened-1,0)	//before you get mad Rockdtben: I done this so update_canmove isn't called multiple times
	return weakened

/mob/living/proc/handle_stuttering()
	if(stuttering)
		stuttering = max(stuttering-1, 0)
	return stuttering

/mob/living/proc/handle_silent()
	if(silent)
		silent = max(silent-1, 0)
	return silent

/mob/living/proc/handle_drugged()
	if(druggy)
		druggy = max(druggy-1, 0)
	return druggy

/mob/living/proc/handle_slurring()
	if(slurring)
		slurring = max(slurring-1, 0)
	return slurring

/mob/living/proc/handle_paralysed() // Currently only used by simple_animal.dm, treated as a special case in other mobs
	if(paralysis)
		AdjustParalysis(-1)
	return paralysis


/mob/proc/UpdateLuminosity()			//�� ������, ��� ���������, �� �� ������ ������ ������� � �����.

	return 1

/mob/proc/face_direction()
	set_face_dir()

/mob/verb/mouse_fixeye()
	set name = ".mousefixeye"
	set instant = 1
	if(!usr.follow_mouse)
		usr.follow_mouse = TRUE
		to_chat(usr, "<span class='jogtowalk'>You will now face the mouse</span>")
	else
		usr.follow_mouse = FALSE
		to_chat(usr, "<span class='jogtowalk'>You will no longer face the mouse</span>")
	if(!usr.facing_dir)
		usr.fixeye()
	if(usr.facing_dir)
		usr.eye_fix?.icon_state = "fixed_e1"
	else
		usr.eye_fix?.icon_state = "fixed_e0"

/mob/verb/fixeye()
	set name = ".fixeye"
	set instant = 1
	set_face_dir()
	if(usr.facing_dir)
		usr.eye_fix?.icon_state = "fixed_e1"
	else
		follow_mouse = FALSE
		usr.eye_fix?.icon_state = "fixed_e0"

/mob/living/carbon/human/mouse_fixeye()
	if(src.special == "weirdgait")
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] I'm stuck!</span>")
		return
	..()

/mob/proc/set_face_dir(var/newdir)
	if(!isnull(facing_dir) && newdir == facing_dir)
		facing_dir = null
	else if(newdir)
		set_dir(newdir)
		facing_dir = newdir
	else if(facing_dir)
		facing_dir = null
	else
		set_dir(dir)
		facing_dir = dir

/mob/set_dir()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(istype(H.buckled_mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/A = H.buckled_mob
			A.plane = initial(A.plane)
			A.layer = 3.9
			A.pixel_y = 7
			switch(dir)
				if(NORTH)
					A.layer = 4.1
					A.pixel_x = 0
					A.pixel_y = 7
				if(EAST)
					A.layer = 3.9
					A.pixel_x = -5
					A.pixel_y = 7
				if(WEST)
					A.layer = 3.9
					A.pixel_x = 5
					A.pixel_y = 7
				if(SOUTH)
					A.layer = 3.9
					A.pixel_x = 0
					A.pixel_y = 7
	if(facing_dir)
		if(!canface() || lying || buckled || restrained())
			facing_dir = null
		else if(dir != facing_dir)
			return ..(facing_dir)
	else
		return ..()

/mob/proc/set_stat(var/new_stat)
	. = stat != new_stat
	stat = new_stat

/mob/verb/northfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(NORTH))

/mob/verb/southfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(SOUTH))

/mob/verb/eastfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(EAST))

/mob/verb/westfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(WEST))
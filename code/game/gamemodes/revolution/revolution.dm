// To add a rev to the list of revolutionaries, make sure it's rev (with if(ticker.mode.name == "revolution)),
// then call ticker.mode:add_revolutionary(_THE_PLAYERS_MIND_)
// nothing else needs to be done, as that proc will check if they are a valid target.
// Just make sure the converter is a head before you call it!
// To remove a rev (from brainwashing or w/e), call ticker.mode:remove_revolutionary(_THE_PLAYERS_MIND_),
// this will also check they're not a head, so it can just be called freely
// If the rev icons start going wrong for some reason, ticker.mode:update_all_rev_icons() can be called to correct them.
// If the game somtimes isn't registering a win properly, then ticker.mode.check_win() isn't being called somewhere.
var/plinioposters = 0

/datum/game_mode
	var/list/datum/mind/head_revolutionaries = list()
	var/list/datum/mind/revolutionaries = list()
	var/mob/living/carbon/human/inspector

/datum/game_mode/revolution
	name = "Integralist Outrise"
	config_tag = "revolution"
	restricted_jobs = list("Baron", "Baroness Bodyguard","Incarn","Squire","Marduk","Tiamat","Hand","Heir","Successor","Baroness","Guest","Meister","Treasurer","Meister Disciple","Sitzfrau","Butler", "Inquisitor", "Practicus")
	required_players = 1
	required_players_secret = 1
	required_enemies = 1
	recommended_enemies = 1


	uplink_welcome = "Revolutionary Uplink Console:"
	uplink_uses = 10

	var/finished = 0
	var/checkwin_counter = 0
	var/max_headrevs = 3
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)
///////////////////////////
//Announces the game type//
///////////////////////////
/datum/game_mode/revolution/announce()
	world << "<B>The current game mode is - Revolution!</B>"
	world << "<B>Some crewmembers are attempting to start a revolution!<BR>\nRevolutionaries - Kill the Captain, HoP, HoS, CE, RD and CMO. Convert other crewmembers (excluding the heads of staff, and security officers) to your cause by flashing them. Protect your leaders.<BR>\nPersonnel - Protect the heads of staff. Kill the leaders of the revolution, and brainwash the other revolutionaries (by beating them in the head).</B>"

/datum/game_mode/revolution/can_start()
	for(var/mob/new_player/player in player_list)
		for(var/mob/new_player/player2 in player_list)
			for(var/mob/new_player/player3 in player_list)
				if(player.ready && player.client.work_chosen == "Baron" && player2.ready && player2.client.work_chosen == "Inquisitor"&& player3.ready && player3.client.work_chosen == "Bookkeeper")
					return 1
	return 0

///////////////////////////////////////////////////////////////////////////////
//Gets the round setup, cancelling if there's not enough players at the start//
///////////////////////////////////////////////////////////////////////////////
/datum/game_mode/revolution/pre_setup()

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	var/list/datum/mind/possible_headrevs = get_players_for_role(BE_REV)

	var/head_check = 0
	for(var/mob/new_player/player in player_list)
		if(player.mind.assigned_role in command_positions)
			head_check = 1
			break

	for(var/datum/mind/player in possible_headrevs)
		for(var/job in restricted_jobs)//Removing heads and such from the list
			if(player.assigned_role == job)
				possible_headrevs -= player

	for (var/i=1 to max_headrevs)
		if (possible_headrevs.len==0)
			break
		var/datum/mind/lenin = pick(possible_headrevs)
		possible_headrevs -= lenin
		head_revolutionaries += lenin

	if((head_revolutionaries.len==0)||(!head_check))
		return 0

	return 1


/datum/game_mode/revolution/post_setup()
	var/list/heads = get_living_heads()

	for(var/datum/mind/rev_mind in head_revolutionaries)
		for(var/datum/mind/head_mind in heads)
			var/datum/objective/mutiny/rev_obj = new
			rev_obj.owner = rev_mind
			rev_obj.target = head_mind
			rev_obj.explanation_text = "Assassinate [head_mind.name], the [head_mind.assigned_role]."
			rev_mind.objectives += rev_obj

	//	equip_traitor(rev_mind.current, 1) //changing how revs get assigned their uplink so they can get PDA uplinks. --NEO
	//	Removing revolutionary uplinks.	-Pete
		equip_revolutionary(rev_mind.current)
		rev_mind.current.verbs += /mob/living/carbon/human/proc/RevConvert
		update_rev_icons_added(rev_mind)

	for(var/datum/mind/rev_mind in head_revolutionaries)
		greet_revolutionary(rev_mind)
	modePlayer += head_revolutionaries
	spawn(15000)
		for(var/obj/machinery/charon/C in world)
			var/obj/item/weapon/paper/lord/NG = new (C.loc)
			var/list/Names = list()
			for(var/mob/living/carbon/human/H in mob_list)
				if(H?.species?.name != "Human") continue
				if(H?.mind?.special_role == "Head Revolutionary")
					Names += "[H?.real_name]\n"
				else if(H?.mind?.special_role == "Revolutionary" && prob(50))
					Names += "[H?.real_name]\n"
				else
					if(prob(6))
						Names += "[H?.real_name]\n"
			NG.info = "to Firethorn Fortress"
			NG.info += "There are a few integralists revolutionaries around the Fortress."
			NG.info += "The suspects are: \n"
			NG.info += "[Names]"
			evermail_ref.receive(NG, 1)
	..()


/datum/game_mode/revolution/process()
	checkwin_counter++
	if(checkwin_counter >= 5)
		if(!finished)
			ticker.mode.check_win()
		checkwin_counter = 0
	return 0


/datum/game_mode/proc/forge_revolutionary_objectives(var/datum/mind/rev_mind)
	var/list/heads = get_living_heads()
	for(var/datum/mind/head_mind in heads)
		var/datum/objective/mutiny/rev_obj = new
		rev_obj.owner = rev_mind
		rev_obj.target = head_mind
		rev_obj.explanation_text = "Assassinate [head_mind.name], the [head_mind.assigned_role]."
		rev_mind.objectives += rev_obj

/datum/game_mode/proc/greet_revolutionary(var/datum/mind/rev_mind, var/you_are=1, mob/living/carbon/human/user as mob)
	var/obj_count = 1
	if (you_are)
		user?.isrev = 1
		to_chat(rev_mind.current, "<span class='bname'> You are one of the leaders of the integralist cell in Firethorn!</span>")
		to_chat(rev_mind.current, "Assist your fellow integralist comrades to victory!")
		rev_mind.current << sound('sound/music/liberty.ogg', repeat = 0, wait = 0, volume = 70, channel = 3)
	for(var/datum/objective/objective in rev_mind.objectives)
		to_chat(rev_mind.current, "<B>INTEGRALIST ACTION #[obj_count]</B>: [objective.explanation_text]")
		rev_mind.special_role = "Head Revolutionary"
		obj_count++

/////////////////////////////////////////////////////////////////////////////////
//This are equips the rev heads with their gear, and makes the clown not clumsy//
/////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/equip_revolutionary(mob/living/carbon/human/mob)
	if(!istype(mob))
		return
	var/obj/item/weapon/spacecash/gold/c20/T = new(mob)

	var/list/slots = list (
		"backpack" = slot_in_backpack,
		"left pocket" = slot_l_store,
		"right pocket" = slot_r_store,
		"left hand" = slot_l_hand,
		"right hand" = slot_r_hand,
	)
	var/where = mob.equip_in_one_of_slots(T, slots)
	if (!where)
		mob << "The Syndicate were unfortunately unable to get you a flash."
	else
		to_chat(mob, "The gold in your [where] will help you to persuade the civilians to join the integralists.")
		mob.update_icons()
		return 1

//////////////////////////////////////
//Checks if the revs have won or not//
//////////////////////////////////////
/datum/game_mode/revolution/check_win()
	if(check_rev_victory())
		finished = 1
	else if(check_heads_victory())
		finished = 2
	return

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/revolution/check_finished()
	if(config.continous_rounds)
		if(finished != 0)
			if(emergency_shuttle)
				emergency_shuttle.always_fake_recall = 0
		return ..()
	if(finished != 0)
		return 1
	else
		return 0

///////////////////////////////////////////////////
//Deals with converting players to the revolution//
///////////////////////////////////////////////////
/datum/game_mode/proc/add_revolutionary(datum/mind/rev_mind, mob/living/carbon/human/user as mob)
	if(rev_mind.assigned_role in command_positions)
		return 0
	var/mob/living/carbon/human/H = rev_mind.current//Check to see if the potential rev is implanted
	for(var/obj/item/weapon/implant/loyalty/L in H)//Checking that there is a loyalty implant in the contents
		if(L.imp_in == H)//Checking that it's actually implanted
			return 0
	for(var/obj/item/weapon/implant/mentor/L in H)//Checking that there is a mentor implant in the contents
		if(L.imp_in == H)//Checking that it's actually implanted
			return 0
	if((rev_mind in revolutionaries) || (rev_mind in head_revolutionaries))
		return 0
	revolutionaries += rev_mind
	user.isrev = 1
	to_chat(rev_mind.current, "\red <FONT size = 3> You are now a revolutionary! Help your cause. You can identify your comrades by the \"E\" icons. Help them kill the nobility to win the revolution!</FONT>")
	rev_mind.current << sound('sound/music/liberty.ogg', repeat = 0, wait = 0, volume = 70, channel = 3)
	rev_mind.special_role = "Revolutionary"
	update_rev_icons_added(rev_mind)
	return 1

/mob/living/carbon/human/proc/RevConvert()
	set name = "RevConvert"
	set category = "IC"
	var/list/Possible = list()
	if(src.stat)
		return
	for (var/mob/living/carbon/human/P in oview(src))
		if(!stat && P.client && P.mind && !P.mind.special_role)
			Possible += P
	if(!Possible.len)
		to_chat(src, "\red There doesn't appear to be anyone available for you to convert here.")
		return
	var/mob/living/carbon/human/M = input("Select a person to convert", "Viva la revolution!", null) as mob in Possible
	if(((src.mind in ticker.mode:head_revolutionaries) || (src.mind in ticker.mode:revolutionaries)))
		if((M.mind in ticker.mode:head_revolutionaries) || (M.mind in ticker.mode:revolutionaries))
			to_chat(src, "\red <b>[M] is already be a revolutionary!</b>")
			return
		if(M.combat_mode)
			to_chat(src, "<span class='combat'>I cannot convert them while they're aware!</span>")
			return
		if(M.stat)
			return
		if(M.job in command_positions)
			to_chat(src, "\red <b>[M] is a filthy communist traitor of the Integralists -  I CANNOT CONVERT HIM!</b>")
			return
		else
			if(world.time < M.mind.rev_cooldown)
				to_chat(src, "\red I must wait a bit before conversion attempt.")
				return
			var/whatosay = input(src, "What should i say?", "INTEGRALISMO") as text
			src.say(whatosay)
			log_admin("[src]([src.ckey]) attempted to convert [M].")
			message_admins("\red [src]([src.ckey]) attempted to convert [M].")
			var/choice = alert(M,"Asked by [src]: Do you want to join the Integralist revolution?","Align Thyself with the Integralists!","Yes!","No!")
			if(choice == "Yes!")
				ticker.mode:add_revolutionary(M.mind)
				to_chat(M, "\blue You join the revolution!")
				src?.client.ChromieWinorLoose(M?.client, 1)
				src.say("Anauê!")
				src.say("*salutes extending his hand.")
				M.say("Anauê")
				M.say("*salutes extending his hand.")
			else if(choice == "No!")
				to_chat(M, "\red You reject this traitorous cause!")
			M.mind.rev_cooldown = world.time+50

//////////////////////////////////////////////////////////////////////////////
//Deals with players being converted from the revolution (Not a rev anymore)//  // Modified to handle borged MMIs.  Accepts another var if the target is being borged at the time  -- Polymorph.
//////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/remove_revolutionary(datum/mind/rev_mind , beingborged, mob/living/carbon/human/user as mob)
	if(rev_mind in revolutionaries)
		revolutionaries -= rev_mind
		rev_mind.special_role = null

		if(beingborged)
			rev_mind.current << "\red <FONT size = 3><B>The frame's firmware detects and deletes your neural reprogramming!  You remember nothing from the moment you were flashed until now.</B></FONT>"

		else
			rev_mind.current << "\red <FONT size = 3><B>You have been brainwashed! You are no longer a revolutionary! Your memory is hazy from the time you were a rebel...the only thing you remember is the name of the one who brainwashed you...</B></FONT>"
			user.isrev = 0
		update_rev_icons_removed(rev_mind)
		for(var/mob/living/M in view(rev_mind.current))
			if(beingborged)
				M << "The frame beeps contentedly, purging the hostile memory engram from the MMI before initalizing it."

			else
				M << "[rev_mind.current] looks like they just remembered their real allegiance!"


/////////////////////////////////////////////////////////////////////////////////////////////////
//Keeps track of players having the correct icons////////////////////////////////////////////////
//CURRENTLY CONTAINS BUGS:///////////////////////////////////////////////////////////////////////
//-PLAYERS THAT HAVE BEEN REVS FOR AWHILE OBTAIN THE BLUE ICON WHILE STILL NOT BEING A REV HEAD//
// -Possibly caused by cloning of a standard rev/////////////////////////////////////////////////
//-UNCONFIRMED: DECONVERTED REVS NOT LOSING THEIR ICON PROPERLY//////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/update_all_rev_icons()
	spawn(0)
		for(var/datum/mind/head_rev_mind in head_revolutionaries)
			if(head_rev_mind.current)
				if(head_rev_mind.current.client)
					for(var/image/I in head_rev_mind.current.client.images)
						if(I.icon_state == "rev" || I.icon_state == "rev_head")
							qdel(I)

		for(var/datum/mind/rev_mind in revolutionaries)
			if(rev_mind.current)
				if(rev_mind.current.client)
					for(var/image/I in rev_mind.current.client.images)
						if(I.icon_state == "rev" || I.icon_state == "rev_head")
							qdel(I)

		for(var/datum/mind/head_rev in head_revolutionaries)
			if(head_rev.current)
				if(head_rev.current.client)
					for(var/datum/mind/rev in revolutionaries)
						if(rev.current)
							var/I = image('icons/mob/mob.dmi', loc = rev.current, icon_state = "rev")
							head_rev.current.client.images += I
					for(var/datum/mind/head_rev_1 in head_revolutionaries)
						if(head_rev_1.current)
							var/I = image('icons/mob/mob.dmi', loc = head_rev_1.current, icon_state = "rev_head")
							head_rev.current.client.images += I

		for(var/datum/mind/rev in revolutionaries)
			if(rev.current)
				if(rev.current.client)
					for(var/datum/mind/head_rev in head_revolutionaries)
						if(head_rev.current)
							var/I = image('icons/mob/mob.dmi', loc = head_rev.current, icon_state = "rev_head")
							rev.current.client.images += I
					for(var/datum/mind/rev_1 in revolutionaries)
						if(rev_1.current)
							var/I = image('icons/mob/mob.dmi', loc = rev_1.current, icon_state = "rev")
							rev.current.client.images += I

////////////////////////////////////////////////////
//Keeps track of converted revs icons///////////////
//Refer to above bugs. They may apply here as well//
////////////////////////////////////////////////////
/datum/game_mode/proc/update_rev_icons_added(datum/mind/rev_mind)
	spawn(0)
		for(var/datum/mind/head_rev_mind in head_revolutionaries)
			if(head_rev_mind.current)
				if(head_rev_mind.current.client)
					var/I = image('icons/mob/mob.dmi', loc = rev_mind.current, icon_state = "rev")
					head_rev_mind.current.client.images += I
			if(rev_mind.current)
				if(rev_mind.current.client)
					var/image/J = image('icons/mob/mob.dmi', loc = head_rev_mind.current, icon_state = "rev_head")
					rev_mind.current.client.images += J

		for(var/datum/mind/rev_mind_1 in revolutionaries)
			if(rev_mind_1.current)
				if(rev_mind_1.current.client)
					var/I = image('icons/mob/mob.dmi', loc = rev_mind.current, icon_state = "rev")
					rev_mind_1.current.client.images += I
			if(rev_mind.current)
				if(rev_mind.current.client)
					var/image/J = image('icons/mob/mob.dmi', loc = rev_mind_1.current, icon_state = "rev")
					rev_mind.current.client.images += J

///////////////////////////////////
//Keeps track of deconverted revs//
///////////////////////////////////
/datum/game_mode/proc/update_rev_icons_removed(datum/mind/rev_mind)
	spawn(0)
		for(var/datum/mind/head_rev_mind in head_revolutionaries)
			if(head_rev_mind.current)
				if(head_rev_mind.current.client)
					for(var/image/I in head_rev_mind.current.client.images)
						if((I.icon_state == "rev" || I.icon_state == "rev_head") && I.loc == rev_mind.current)
							qdel(I)

		for(var/datum/mind/rev_mind_1 in revolutionaries)
			if(rev_mind_1.current)
				if(rev_mind_1.current.client)
					for(var/image/I in rev_mind_1.current.client.images)
						if((I.icon_state == "rev" || I.icon_state == "rev_head") && I.loc == rev_mind.current)
							qdel(I)

		if(rev_mind.current)
			if(rev_mind.current.client)
				for(var/image/I in rev_mind.current.client.images)
					if(I.icon_state == "rev" || I.icon_state == "rev_head")
						qdel(I)

//////////////////////////
//Checks for rev victory//
//////////////////////////
/datum/game_mode/revolution/proc/check_rev_victory()
	for(var/datum/mind/rev_mind in head_revolutionaries)
		for(var/datum/objective/objective in rev_mind.objectives)
			if(!(objective.check_completion()))
				return 0

		return 1

/////////////////////////////
//Checks for a head victory//
/////////////////////////////
/datum/game_mode/revolution/proc/check_heads_victory()
	for(var/datum/mind/rev_mind in head_revolutionaries)
		var/turf/T = get_turf(rev_mind.current)
		if((rev_mind) && (rev_mind.current) && (rev_mind.current.stat != 2) && T && (T.z in vessel_z))
			if(ishuman(rev_mind.current))
				return 0
	return 1

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relavent information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/revolution/declare_completion()
	..()
	if(finished == 1)
		to_chat(world, "<h2><span class='combatbold'>Anauê! The nobles were killed or abandoned the Fortress! The integralist cell wins!</B></span></h2>")
		NEGROSSALGAKA()
	else if(finished == 2)
		to_chat(world, "<h2><span class='combatbold'>The nobles managed to stop the revolution!</span></h2>")
	return 1

/datum/game_mode/proc/auto_declare_completion_revolution()
	var/list/targets = list()

	if(head_revolutionaries.len || istype(ticker.mode,/datum/game_mode/revolution))
		var/text = "<FONT size = 2><B>The head revolutionaries were:</B></FONT>"

		for(var/datum/mind/headrev in head_revolutionaries)
			text += "<br>[headrev.key] was [headrev.name] ("
			if(headrev.current)
				if(headrev.current.stat == DEAD)
					text += "died"
				else if(!(headrev.current.z in vessel_z))
					text += "fled the [vessel_type]"
				else
					text += "survived the revolution"
				if(headrev.current.real_name != headrev.name)
					text += " as [headrev.current.real_name]"
			else
				text += "body destroyed"
			text += ")"

			for(var/datum/objective/mutiny/objective in headrev.objectives)
				targets |= objective.target

		to_chat(world, text)

	if(revolutionaries.len || istype(ticker.mode,/datum/game_mode/revolution))
		var/text = "<FONT size = 2><B>The revolutionaries were:</B></FONT>"

		for(var/datum/mind/rev in revolutionaries)
			text += "<br>[rev.key] was [rev.name] ("
			if(rev.current)
				if(rev.current.stat == DEAD)
					text += "died"
				else if(!(rev.current.z in vessel_z))
					text += "fled the [vessel_type]"
				else
					text += "survived the revolution"
				if(rev.current.real_name != rev.name)
					text += " as [rev.current.real_name]"
			else
				text += "body destroyed"
			text += ")"

		to_chat(world, text)


	if( head_revolutionaries.len || revolutionaries.len || istype(ticker.mode,/datum/game_mode/revolution) )
		var/text = "<FONT size = 2><B>The nobles were:</B></FONT>"

		var/list/heads = get_all_heads()
		for(var/datum/mind/head in heads)
			var/target = (head in targets)
			if(target)
				text += "<font color='red'>"
			text += "<br>[head.key] was [head.name] ("
			if(head.current)
				if(head.current.stat == DEAD)
					text += "died"
				else if(!(head.current.z in vessel_z))
					text += "fled the [vessel_type]"
				else
					text += "survived the revolution"
				if(head.current.real_name != head.name)
					text += " as [head.current.real_name]"
			else
				text += "body destroyed"
			text += ")"
			if(target)
				text += "</font>"

		to_chat(world, text)

/proc/is_convertable_to_rev(datum/mind/mind)
	return istype(mind) && \
		istype(mind.current, /mob/living/carbon/human) && \
		!(mind.assigned_role in command_positions) && \
		!(mind.assigned_role in list("Marduk", "Baron"))

/obj/structure/sign/signnew/web/plineosalgado/tela
	icon = 'icons/effects/96x96.dmi'
	icon_state = "plinio"

/obj/structure/sign/signnew/web/plineosalgado/tela/examine()
	return


/datum/game_mode/revolution/proc/NEGROSSALGAKA(){
	for(var/mob/living/carbon/human/H in mob_list){
		if(!H.client){continue}
		sound_to(H, 'plotvictory.ogg')
		var/obj/structure/sign/signnew/web/plineosalgado/tela/P = new
		H.client.screen.Add(P)
		P.screen_loc = "CENTER"
		P.plane = 150
		var/howmuch = 1
		while(howmuch < 5.5){
			sleep(1)
			var/matrix/A = matrix()
			A.Scale(howmuch)
			howmuch += 0.03
			P.transform = A
		}
	}
}
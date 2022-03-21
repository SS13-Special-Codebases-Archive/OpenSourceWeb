//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33
//NÃO FAÇO IDEIA DE COMO ARRUMAR ISSO.
var/list/SpecialRolledList = list()
var/aspects_max = 3

/client/New()
	..()
	src << browse_rsc('code/modules/mob/new_player/html/bg2.png', "bg2.png")
	src << browse_rsc('code/modules/mob/new_player/html/cond2.ttf', "cond2.ttf")
	src << browse_rsc('code/modules/mob/new_player/html/pointer.cur', "pointer.cur")

/mob/new_player
	var/ready = 0
	var/special = 0
	var/qualspecial = ""
	var/specialitem = null
	var/specialdesc = null
	var/list/aspects_list = list()
	var/aspects_rerolls = 3
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/datum/preferences/preferences
	var/datum/special/specialdatum = new
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/mini_war_side
	universal_speak = 1
	virtual_mob = null // Hear no evil, speak no evil

	invisibility = 101

	density = 0
	stat = 2
	canmove = 0

	anchored = 1	//  don't get pushed around

	New()
		mob_list += src

	Destroy()
		mob_list -= src
		qdel(attack_delayer)
		qdel(click_delayer)
		client = null
		qdel(clong_delayer)
		hud_used?.mymob = null
		qdel(hud_used)
		lastarea = null
		loc = null
		mind?.current = null

		qdel(specialdatum)
		qdel(preferences)
		..()

	verb/new_player_panel()
		set src = usr
		new_player_panel_proc()


	proc/new_player_panel_proc()
		set waitfor = 0
		var/output = "<div align='center'><B>New Player Options</B>"
		output +="<hr>"
		output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A></p>"

		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
			if(!ready)	output += "<p><a href='byond://?src=\ref[src];ready=1'>Declare Ready</A></p>"
			else	output += "<p><b>You are ready</b> (<a href='byond://?src=\ref[src];ready=2'>Cancel</A>)</p>"
		else if(ticker?.mode.config_tag == "siege")
			if(!ready)
				output += "<p><a href='byond://?src=\ref[src];late_war=1'>War!</A></p>"
			else
				output += "<p><a href='byond://?src=\ref[src];late_war=1'>Cancel</A></p>"
		else
			output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
			output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

		output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"
		output += "</div>"

		//src << browse(output,"window=playersetup;size=210x240;can_close=0")
		var/datum/browser/popup = new(src, "playersetup", "Player Setup", 210, 240)
		popup.set_content(output)
		popup.set_window_options("can_close=0;")
		client.prefs.ShowChoices(src)
		client << browse_rsc('code/modules/mob/new_player/html/bg2.png', "bg2.png")
		client << browse_rsc('code/modules/mob/new_player/html/cond2.ttf', "cond2.ttf")
		client << browse_rsc('code/modules/mob/new_player/html/pointer.cur', "pointer.cur")
		client << browse('code/modules/mob/new_player/html/chatbot.html', "window=playerlist;size=300x385;can_close=0; can_resize=0;")
		return

	Stat()
		..()
		//statpanel("Lobby")
		updateTimeToStart()
		updatePig()
		if(ticker)
			if(ticker.current_state == GAME_STATE_PLAYING)
				src << browse(null, "window=playerlist")
				return

			if((ticker.current_state == GAME_STATE_PREGAME) && going)
				client << output(list2params(list("[ticker.pregame_timeleft]")), "playerlist.browser:setTimeToStart")
			if((ticker.current_state == GAME_STATE_PREGAME) && !going)
				client << output(list2params(list("[ticker.pregame_timeleft]")), "playerlist.browser:setTimeToStart")
			//dat += "<TABLE><TR><TD class='rank'></TD>"
			for(var/mob/new_player/player in player_list)
				if(client)
					if(player.ready && player.client.work_chosen)
						client << output(list2params(list("[player.client.work_chosen]", "[player.client.key]")), "playerlist.browser:addPlayerCell")
					else
						client << output(list2params(list("HIDDEN", "[player.client.key]")), "playerlist.browser:addPlayerCell")
					client << output(list2params(list()), "playerlist.browser:renderPlayerList")
					player.updateTimeToStart()
					/*
					if(client && !ready)
						dat += "<TABLE><TR><TD>[player.key]</TD></TR></TABLE>"
					else if(client && ready)
						dat += "<TABLE><TR><TD class='rank'>[player.client.work_chosen]</TD><TD>[player.key]</TD></TR></TABLE>"
					*/
					// DESATIVAR ISSO CASO DE ERRADO
/*
		if(client.statpanel=="Lobby" && ticker)
			if(ticker.hide_mode)
				stat("Game Mode:", "Secret")
			else
				if(ticker.hide_mode == 0)
					stat("Game Mode:", "[master_mode]") // Old setting for showing the game mode

			if((ticker.current_state == GAME_STATE_PREGAME) && going)
				stat("Tempo para começar:", ticker.pregame_timeleft)
			if((ticker.current_state == GAME_STATE_PREGAME) && !going)
				stat("Tempo para começar:", "TRAVADO")

			if(ticker.current_state == GAME_STATE_PREGAME)
				stat("Jogadores: [totalPlayers]", "Jogadores prontos: [totalPlayersReady]")
				totalPlayers = 0
				totalPlayersReady = 0
				for(var/mob/new_player/player in player_list)
					if(client)
						stat("[player.key]", (player.ready)?("(Jogando de [player.client.work_chosen])"):(null))
					else
						stat("[player.key]", (player.ready)?("(Jogando de [player.client.work_chosen])"):(null))
					totalPlayers++
					if(player.ready)totalPlayersReady++
*/
	proc/updatelobbypiglet()
	//EMERGENCIA
		//return
		if(ticker)
			if(ticker.current_state == GAME_STATE_PLAYING)
				src << browse(null, "window=playerlist")
				return
			var/dat = "<head><style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: PTSANS;src: url(PTSANS.ttf);} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style><style type='text/css'> @charset 'utf-8'; body {font-family: PTSANS;cursor: url('pointer.cur'), auto;} a {text-decoration:none;outline: none;border: none;margin:-1px;} a:focus{outline:none;} a:hover {color:#0d0d0d;background:#505055;outline: none;border: none;} a.active { text-decoration:none; color:#533333;} a.inactive:hover {color:#0d0d0d;background:#bb0000} a.active:hover {color:#bb0000;background:#0f0f0f} a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style></head><body background bgColor=#0d0d0d text=#533333 alink=#777777 vlink=#777777 link=#777777>"
			dat += "<style type='text/css'> body {font-family: 'Cond'; margin: 0; color:#888;padding: 10px;font-size:75%;overflow:hidden; background-image: url('bg2.png'); background-repeat: no-repeat; background-size: cover; } table{width:100%;background: #322;} table,tr,td{ border:none;border-collapse: collapse;padding:3px;} .horriblestate	{color: #ff00c0; text-shadow:0px 0px 5px #ff00c0; font-size: 110%;}.rank{color:#bbb;width:30%;text-align:right;padding-right:10px;} tr:nth-child(even){background: #422;} </style>"
			dat += "<TITLE>Farweb Lobby</TITLE>"
			/*
			if((ticker.current_state == GAME_STATE_PREGAME) && going)
				dat += "<CENTER>Time to Start: [ticker.pregame_timeleft]</CENTER>"
			if((ticker.current_state == GAME_STATE_PREGAME) && !going)
				dat += "<CENTER>Time to Start: <span class='horriblestate'>CURSED!</span></CENTER>"*/
			//dat += "<TABLE><TR><TD class='rank'></TD>"
			for(var/mob/new_player/player in player_list)
				if(client)
					dat += "<TABLE><TR><TD class='rank'>[player.client.work_chosen]</TD><TD>[player.key]</TD></TR></TABLE>"
				/*
				if(client && !ready)
					dat += "<TABLE><TR><TD>[player.key]</TD></TR></TABLE>"
				else if(client && ready)
					dat += "<TABLE><TR><TD class='rank'>[player.client.work_chosen]</TD><TD>[player.key]</TD></TR></TABLE>"
				*/
				// DESATIVAR ISSO CASO DE ERRADO
				player.client << browse(dat, "window=playerlist;size=300x385;can_close=0; can_resize=0;")
			//dat += "</TR></TABLE>"
/*			for(var/mob/new_player/player in player_list)
				if(client && ready)
					dat += "<TABLE><TR><TD class='rank'>[player.client.work_chosen]</TD><TD>[player.key]</TD></TR></TABLE>"

			if(src.client)
				src.client << browse(dat, "window=playerlist;size=300x385;can_close=0; can_resize=0;")
*/
	Topic(href, href_list[])
		if(!client)	return 0

		if(href_list["show_preferences"])
			client.prefs.ShowChoices(src)
			return 1

		if(href_list["ready"])
			ready = !ready
			client.GetHighJob()

		if(href_list["special"])
			if(special)
				to_chat(src, "<span class='specialhbold'>⠀Your character is now <i>special</i>!</span>")
				to_chat(src, "<span class='specialbold'>Limitations:</span> <span class='special'>[specialdatum.limitationsen]</span>")
				to_chat(src, "<span class='specialbold'>Description:</span> <span class='special'>[specialdatum.descriptionen]</span>")
				to_chat(src, "<span class='specialbold'>Reward:</span> <span class='special'>[specialdatum.rewarden]</span>")

			if(!special && !SpecialRolledList.Find(src.ckey))
				special = 1
				specialdatum = specialdatum.pick_special()
				src << 'sound/lfwbsounds/special_toggle.ogg'

				qualspecial = specialdatum.name
				specialdesc = specialdatum.descriptionen
				specialitem = specialdatum.specialitem
				SpecialRolledList.Add(src.ckey)

				to_chat(src, "<span class='specialhbold'>⠀Your character is now <i>special</i>!</span>")
				to_chat(src, "<span class='specialbold'>Limitations:</span> <span class='special'>[specialdatum.limitationsen]</span>")
				to_chat(src, "<span class='specialbold'>Description:</span> <span class='special'>[specialdatum.descriptionen]</span>")
				to_chat(src, "<span class='specialbold'>Reward:</span> <span class='special'>[specialdatum.rewarden]</span>")

		if(href_list["refresh"])
			src << browse(null, "window=playersetup") //closes the player setup window
			new_player_panel_proc()

		if(href_list["aspects"])
			if(!aspects_rerolls)
				to_chat(src, "No rerolls left.")
			else
				aspects_rerolls -= 1
				aspects_list = list()
				var/events_pick = subtypesof(/datum/round_event)
				for(var/i = 1, i <= aspects_max, i++)
					var/event_pick = pick(events_pick)
					if(event_pick)
						var/event_into_list = new event_pick
						aspects_list += event_into_list
						events_pick -= event_pick

				to_chat(src, "<b>Aspect Rerolls Left:</b> [aspects_rerolls]")
				var/number = 1
				for(var/datum/round_event/R in aspects_list)
					to_chat(src, "[number]. <b>[R.name]</b> - [R.event_message]")
					number++

/*
		if(href_list["ready"])

			if(!ready)
				if(alert(src,"Are you sure you are ready?.","Player Setup","Yes","No") == "Yes")
					ready = 1
					preferences.ShowChoices(src)
*/
		if(href_list["late_join"])
			LateChoices()
		if(href_list["mini_war"])
			Joining_War()
		if(href_list["late_war"])
			if(ticker.current_state == GAME_STATE_PLAYING)
				if(ticker.migrants_inwave.Find(src.client))
					ticker.migrants_inwave.Remove(src.client)
					client.prefs.ShowChoices(src)
					ready = FALSE
				else
					ticker.migrants_inwave.Add(src.client)
					client.prefs.ShowChoices(src)
					ready = TRUE

		if(href_list["SelectedJob"])

			if(!enter_allowed)
				usr << "\blue There is an administrative lock on entering the game!"
				return

			if(client.prefs.species != "Human")
				if(!is_alien_whitelisted(src, client.prefs.species) && config.usealienwhitelist)
					src << alert("You are currently not whitelisted to play [client.prefs.species].")
					return 0

				var/datum/species/S = all_species[client.prefs.species]
				if(!(S.flags & IS_WHITELISTED))
					src << alert("Your current species,[client.prefs.species], is not available for play on the [vessel_type].")
					return 0

			AttemptLateSpawn(href_list["SelectedJob"])
			return

		if(!ready && href_list["preference"])
			if(client)
				client.prefs.process_link(src, href_list)

		else if(!href_list["late_join"])
			new_player_panel()


	proc/IsJobAvailable(rank)
		var/datum/job/job = job_master.GetJob(rank)
		if(!job)	return 0
		if((job.current_positions >= job.total_positions) && job.total_positions != -1)	return 0
		if(jobban_isbanned(src,rank))	return 0
		if(!job.player_old_enough(src.client))	return 0
		return 1


	proc/AttemptLateSpawn(rank)
		if (src != usr)
			return 0
		if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
			usr << "\red The round is either not ready, or has already finished..."
			return 0
		if(!enter_allowed)
			usr << "\blue There is an administrative lock on entering the game!"
			return 0
		if(!IsJobAvailable(rank))
			src << alert("[rank] is not available. Please try another.")
			return 0

		spawning = 1
		close_spawn_windows()

		job_master.AssignRole(src, rank, 1)

		var/mob/living/carbon/human/character = create_character(TRUE)	//creates the human and transfers vars and mind
		job_master.EquipRank(character, rank)					//equips the human
		job_master.PostEquip(character, 1)
		EquipCustomItems(character)
		if(ticker.mode.config_tag == "miniwar")
			if(rank == "Southner")
				character.loc = pick(MiniWarJoinS)
			else
				character.loc = pick(MiniWarJoinN)
		else
			character.loc = pick(latejoin)
		character.lastarea = get_area(loc)

		ticker.mode.latespawn(character)

		//ticker.mode.latespawn(character)
		matchmaker.do_matchmaking()

		if(character.mind.assigned_role != "Cyborg")
			data_core.manifest_inject(character)
			ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
			AnnounceArrival(character, rank)


		else
			character.Robotize()
		qdel(src)


	proc/AttemptMigSpawn()
		/*if (src != usr)
			return 0*/
		if(!IsJobAvailable("Migrant"))
			src << alert("Migrant is not available. Please try another.")
			return 0

		spawning = 1
		close_spawn_windows()
		var/mig_job = "Migrant"

		if(ticker.eof.id == "lostsquad")
			if(!firstmigwent)
				mig_job = "Ordinator"

		if(ticker?.mode.config_tag == "siege")
			var/datum/game_mode/siege/S = ticker.mode
			if(!S.hascount && (client.prefs.gender == MALE || trapapoc.Find(src.client.ckey)))
				mig_job = "Count"
			else if(!S.hascounthand)
				mig_job = "Count Hand"
			else if(!S.hascountheir && (client.prefs.gender == MALE || trapapoc.Find(src.client.ckey)))
				mig_job = "Count Heir"
			else
				mig_job = "Sieger"

		job_master.AssignRole(src, mig_job, 1)

		var/mob/living/carbon/human/character = create_character(TRUE)	//creates the human and transfers vars and mind
		job_master.EquipRank(character, mig_job)					//equips the human
		job_master.PostEquip(character,1, MiniSpawn)
		EquipCustomItems(character)
		character.x = MiniSpawn.x
		character.y = MiniSpawn.y
		character.z = MiniSpawn.z
		character.lastarea = get_area(loc)
		if(ticker?.mode.config_tag == "siege")
			character.siegesoldier = TRUE

		ticker.mode.latespawn(character)
		spawn(0)
			qdel(src)
		return character

	proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank)
		if (ticker.current_state == GAME_STATE_PLAYING)
			var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)// BS12 EDIT Arrivals Announcement Computer, rather than the AI.
			if(rank == "Bum" || rank == "Migrant")
				return
			else
				a.autosay("[character.real_name],[rank ? " [rank]," : " visitor," ] has arrived at Firethorn.", "Firethorn CTTU")
				world << 'sound/effects/arrival.ogg'
				qdel(a)

	proc/LateChoices()
		var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
		//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
		var/mins = (mills % 36000) / 600
		var/hours = mills / 36000

		var/dat = "<html><Title>Farweb</title><style type='text/css'>body {font-family: Times;cursor: url('pointer.cur'), auto;}a {text-decoration:none;outline: none;border: none;margin:-1px;}a:focus{outline:none;}a:hover {color:#0d0d0d;background:#505055;border: none;outline: none;border: none;}a.active { text-decoration:none; color:#533333;border: none;}a.inactive:hover {color:#0d0d0d;background:#bb0000;border: none;}a.active:hover {color:#bb0000;background:#0f0f0f;border: none;}a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style><body background bgColor=#0d0d0d text=#555555 alink=#777777 vlink=#777777 link=#777777>"
		dat += "Game Duration: [round(hours)]h [round(mins)]m<br>"
		dat += "Choose your fate:<br>"
		var/list/allowedFatesList = list("Migrant","Bum","Servant","Nun","Maid")
		if(mercenary_donor.Find(src.client.ckey))
			allowedFatesList.Add("Mercenary")
		if(urchin_donor.Find(src.client.ckey))
			allowedFatesList.Add("Urchin")
		if(tribunal_vet.Find(src.client.ckey))
			allowedFatesList.Add("Tribunal Veteran")
		for(var/datum/job/job in job_master.occupations)
			if(job && IsJobAvailable(job.title))
				if(!trapapoc.Find(ckey(src.client.key)) || job.no_trapoc)
					if(job.sex_lock && job.sex_lock != src.client.prefs.gender)
						continue
				if(job.job_whitelisted)
					if(job.job_whitelisted.Find(PIGPLUS))
						if(!comradelist.Find(ckey(src.client.key)) && !villainlist.Find(ckey(src.client.key)))
							if(!pigpluslist.Find(ckey(src.client.key)))
								continue
					else
						if(job.job_whitelisted.Find(COMRADE))
							if(!comradelist.Find(ckey(src.client.key)) && !villainlist.Find(ckey(src.client.key)))
								continue
						else
							if(job.job_whitelisted.Find(VILLAIN))
								if(!villainlist.Find(ckey(src.client.key)))
									continue
				if(job.latejoin_locked)
					continue
				if(job.donation_lock.len >= 1 && !job.donation_lock.Find(ckey(src.client.key)))
					continue
				if(!allowedFatesList.Find(job.title) && world.time < 7200)
					continue
				if(job.title != "Migrant" && master_mode == "minimig")
					continue

				if(job.title == "Migrant")
					dat += "<a href='byond://?src=\ref[src];action=joinMigWave'>[job.title]</a><br>"
				else
					dat += "<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions])</a><br>"

		dat += "</center>"
		src << browse(dat, "window=latechoices;size=300x640;can_close=1")

	proc/Joining_War()
		var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
		//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
		var/mins = (mills % 36000) / 600
		var/hours = mills / 36000
		if(ticker.mode.config_tag != "miniwar")
			return
		var/datum/game_mode/miniwar/M = ticker.mode
		var/dat = "<html><Title>Farweb</title><style type='text/css'>body {font-family: Times;cursor: url('pointer.cur'), auto;}a {text-decoration:none;outline: none;border: none;margin:-1px;}a:focus{outline:none;}a:hover {color:#0d0d0d;background:#505055;border: none;outline: none;border: none;}a.active { text-decoration:none; color:#533333;border: none;}a.inactive:hover {color:#0d0d0d;background:#bb0000;border: none;}a.active:hover {color:#bb0000;background:#0f0f0f;border: none;}a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style><body background bgColor=#0d0d0d text=#555555 alink=#777777 vlink=#777777 link=#777777>"
		dat += "Game Duration: [round(hours)]h [round(mins)]m<br>"
		dat += "Choose your team:<br>"
		var/list/War_Teams = list("Northner", "Southner")
		if(mini_war_side)
			War_Teams -= mini_war_side
		else if((length(M.south_team) - length(M.north_team)) > M.count_restriction)
			War_Teams -= "Southner"
		else if((length(M.north_team) - length(M.south_team)) > M.count_restriction)
			War_Teams -= "Northner"
		for(var/side_name in War_Teams)
			dat += "<a href='byond://?src=\ref[src];SelectedJob=[side_name]'>Join [side_name]s Team!</a><br>"
		dat += "</center>"
		src << browse(dat, "window=miniwar;size=300x640;can_close=1")

	proc/create_character(var/joined_late = 0)
		spawning = 1
		close_spawn_windows()

		var/mob/living/carbon/human/new_character

		var/datum/species/chosen_species
		if(client.prefs.species)
			chosen_species = all_species[client.prefs.species]
		if(chosen_species)
			// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
			if(is_species_whitelisted(chosen_species) || has_admin_rights())
				new_character = new(loc, client.prefs.species)

		if(!new_character)
			new_character = new(loc)

		if(mind)
			new_character.job = mind.assigned_role

		if(!joined_late)
			var/obj/S = null
			for(var/obj/effect/landmark/start/sloc in landmarks_list)
				if(sloc.name != new_character.job)	continue
				if(locate(/mob/living) in sloc.loc)	continue
				S = sloc
				break
			if(!S)
				S = locate("start*[new_character.job]") // use old stype
			if(istype(S, /obj/effect/landmark/start) && istype(S.loc, /turf))
				new_character.loc = S.loc

		new_character.lastarea = get_area(loc)

		var/datum/language/chosen_language
		if(client.prefs.language)
			chosen_language = all_languages["[client.prefs.language]"]
		if(chosen_language)
			if(is_alien_whitelisted(src, client.prefs.language) || !config.usealienwhitelist || !(chosen_language.flags & WHITELISTED) || (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language("[client.prefs.language]")


		if(ticker.random_players)
			new_character.gender = pick(MALE, FEMALE)
			client.prefs.real_name = random_name(new_character.gender)
			client.prefs.randomize_appearance_for(new_character)
		else
			client.prefs.copy_to(new_character)

		if(client?.prefs.togglesize)
			new_character.potenzia = 30
		if(baliset.Find(client?.ckey))
			new_character.my_skills.CHANGE_SKILL(SKILL_MUSIC, rand(13,15))
		if(singer.Find(client?.ckey))
			new_character.add_perk(/datum/perk/singer)
			new_character.verbs += /mob/living/carbon/human/proc/remembersong
			new_character.verbs += /mob/living/carbon/human/proc/sing
		if(bee_queen.Find(client?.ckey))
			new_character.add_perk(/datum/perk/bee_queen)
		if(client?.prefs.togglefuta)
			new_character.futa = TRUE
		src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

		if(mind)
			mind.active = 0					//we wish to transfer the key manually
			mind.original = new_character
			mind.transfer_to(new_character)					//won't transfer key since the mind is not active

		new_character.name = real_name
		new_character.dna.ready_dna(new_character)
		new_character.dna.b_type = client.prefs.b_type
		if(client.prefs.disabilities)
			// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
			new_character.dna.SetSEState(GLASSESBLOCK,1,0)
			new_character.disabilities |= NEARSIGHTED

		// And uncomment this, too.
		//new_character.dna.UpdateSE()

		if(qualspecial)
			new_character.special = qualspecial
			new_character.special_item = specialitem
			new_character.specialdesc = specialdesc
		new_character.key = key		//Manually transfer the key to log them in
		if(SpecialRolledList.Find(new_character.client.ckey))
			SpecialRolledList.Remove(new_character.client.ckey)

		if(prob(rand(1,3)))
			new_character.vampire_me()

		return new_character

	proc/ViewManifest()
		var/dat = "<html><body>"
		dat += "<h4>Crew Manifest</h4>"
		dat += data_core.get_manifest(OOC = 1)

		src << browse(dat, "window=manifest;size=370x420;can_close=1")

	Move()
		return 0


	proc/close_spawn_windows()
		src << browse(null, "window=latechoices") //closes late choices window
		src << browse(null, "window=miniwar") //closes miniwar choices window
		src << browse(null, "window=playersetup") //closes the player setup window
		src << browse(null, "window=preferences")
		src << browse(null, "window=playerlist")
	proc/has_admin_rights()
		return client.holder.rights & R_ADMIN

	proc/is_species_whitelisted(datum/species/S)
		if(!S) return 1
		return is_alien_whitelisted(src, S.name) || !config.usealienwhitelist || !(S.flags & IS_WHITELISTED)



/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(!chosen_species)
		return "Human"

	if(is_species_whitelisted(chosen_species) || has_admin_rights())
		return chosen_species.name

	return "Human"


/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

/mob/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0)
	return

/mob/new_player/proc/aghost_observe()
	var/mob/dead/observer/observer = new(pick(latejoin))

	spawning = 1
	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo


	observer.started_as_observer = 1
	close_spawn_windows()
	observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

	client.prefs.update_preview_icon()
	observer.icon = client.prefs.preview_icon
	observer.alpha = 127

	observer.real_name = client.prefs.real_name
	observer.name = observer.real_name

	observer.key = key
	qdel(src)

	return 1
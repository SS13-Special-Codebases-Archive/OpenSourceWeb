
/datum/game_mode/siege
	name = "Siege"
	config_tag = "siege"
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10
	var/special_time = 6000
	var/datum/family/count_family = null
	var/mob/living/carbon/human/hascount = null
	var/hascounthand = FALSE
	var/mob/living/carbon/human/hascountheir = null
	var/hasblacksmithsiege = FALSE
	var/list/flag_colors = list()
	var/losses = 0
	var/max_losses = 30
	var/list/siegerslist = list()
	var/maxblacksmithsiege = 2
	var/blacksmithsiege = 0
	var/hasalchemistsiege = FALSE
	var/list/special_troops = list()
	var/specialrifleman = FALSE
	var/specialtownguard = FALSE
	var/specialgang = FALSE
	var/siegewar = FALSE
	var/flagdropped = FALSE
	var/obj/item/weapon/paper/war_paper
	var/camp_attack
	var/camp_time = 30 MINUTES
	var/result

/datum/game_mode/siege/can_start()
	for(var/mob/new_player/player in player_list)
		for(var/mob/new_player/player2 in player_list)
			for(var/mob/new_player/player3 in player_list)
				if(player.ready && player.client.work_chosen == "Baron" && player2.ready && player2.client.work_chosen == "Inquisitor"&& player3.ready && player3.client.work_chosen == "Bookkeeper")
					return 1
	return 0

/datum/game_mode/siege/post_setup()
	ticker.migrant_req = 3
	ticker.max_migrant_req = 3
	camp_attack = world.time
	job_master.AddOccupations("Siege")
	global.login_music = 'sound/lfwbambi/invasion.ogg'
	for(var/mob/new_player/player in player_list)
		if(player.client)
			player.client << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
			player.client.playtitlemusic()

/datum/game_mode/siege/process()
	if(!siegewar && camp_attack + camp_time <= world.time)
		for(var/turf/T in siegecamp)
			new /mob/living/carbon/human/skinless(T)
			new /mob/living/carbon/human/skinless(T)
		for(var/mob/living/carbon/human/F in siegerslist)
			to_chat(F, "<span class='excomm'>AMBUSH!!!</span>")
			F << sound(pick('ambush1.ogg','ambush2.ogg','ambush3.ogg','ambush4.ogg','ambush5.ogg','ambush6.ogg'))
		camp_attack = world.time
	if(flagdropped)
		for(var/mob/living/carbon/human/F in siegerslist)
			if(F.check_event("flag")) continue
			F.add_event("flag", /datum/happiness_event/flag)
	if(length(special_troops))
		for(var/T in special_troops)
			var/time_live = special_troops[T] + special_time
			if(time_live <= world.time)
				special_troops -= T
				siegerclasses -= T

/mob/living/carbon/human/proc/update_all_siege_icons()
	if(src.siegesoldier && ticker.mode.config_tag == "siege")
		var/datum/game_mode/siege/S = ticker.mode
		var/my_I
		if(job == "Count")
			my_I = image('icons/mob/mob.dmi', loc = src, icon_state = "leader")
		else if(job == "Count Hand" || job == "Count Heir" || job == "Countess")
			my_I = image('icons/mob/mob.dmi', loc = src, icon_state = "comrade")
		else if(migclass == "Healer")
			my_I = image('icons/mob/mob.dmi', loc = src, icon_state = "medic")
		else
			my_I = image('icons/mob/mob.dmi', loc = src, icon_state = "gren")
		for(var/mob/living/carbon/human/HH in S.siegerslist)
			var/I
			if(HH.job == "Count")
				I = image('icons/mob/mob.dmi', loc = HH, icon_state = "leader")
			else if(HH.job == "Count Hand" || HH.job == "Count Heir")
				I = image('icons/mob/mob.dmi', loc = HH, icon_state = "comrade")
			else if(HH.migclass == "Healer")
				I = image('icons/mob/mob.dmi', loc = HH, icon_state = "medic")
			else
				I = image('icons/mob/mob.dmi', loc = HH, icon_state = "gren")

			src?.client?.images += I
			HH?.client?.images += my_I

/datum/game_mode/siege/declare_completion()
	..()
	switch(result)
		if(SIEGE_FAILED_REINFORCEMENT)
			to_chat(world, "<h2><B>Great losses broke down the attackers! Count [hascount.real_name]([hascount.key]) gathers cave warriors withdraw from the Firethorn Fortress to fight another day.</B></h2>")
		if(SIEGE_FAILED_COUNT)
			to_chat(world, "<h2><B>Great losses broke down the attackers! The defenders have managed to slay count [hascount.real_name]([hascount.key])!</B></h2>")
		if(SIEGE_DRAW_MARRIAGE)
			to_chat(world, "<h2><B>The great result to attackers and defenders! Both sides have made truces!</B></h2>")
		if(SIEGE_WIN_THRONE)
			to_chat(world, "<h2><B>Firethorn is lost! The throne was usurped by [hascount.real_name]([hascount.key])!</B></h2>")
			for(var/mob/living/carbon/human/H in player_list)
				var/dat
				dat += {"<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: PTSANS;src: url(PTSANS.ttf);} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style> <style type='text/css'> @charset 'utf-8'; body {font-family: PTSANS;cursor: url('pointer.cur'), auto;} a {text-decoration:none;outline: none;border: none;margin:-1px;} a:focus{outline:none;} a:hover {color:#0d0d0d;background:#505055;outline: none;border: none;} a.active { text-decoration:none; color:#533333;} a.inactive:hover {color:#0d0d0d;background:#bb0000} a.active:hover {color:#bb0000;background:#0f0f0f} a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style>
				<body background bgColor=#cacbc6 text=#533333 alink=#777777 vlink=#777777 link=#777777>
				<TT><CENTER><b></b></CENTER></TT><br>
				"}
				dat += "<HTML><HEAD><TITLE>[war_paper.name]</TITLE></HEAD><BODY>[war_paper.info][war_paper.stamps]</BODY></HTML>"
				H << browse(dat, "window=[war_paper.name]")
				onclose(H, "[war_paper.name]")
	to_chat(world, "Losses: [losses]/[max_losses]")

/datum/game_mode/siege/end_round_rewards()
	switch(result)
		if(SIEGE_WIN_THRONE)
			var/list/areas = get_areas(/area/dunwell/station/bridge/noble/throne_room)
			for(var/area/A in areas)
				for(var/mob/living/carbon/human/H in A)
					if(!(H in siegerslist) || H.stat)
						continue
					to_chat(H, "<span class='passivebold'>We are victorious!</span>")
					switch(H.job)
						if("Count")
							if(specialrifleman)
								H?.client?.ChromieWinorLoose(H, 5)
							else
								H?.client?.ChromieWinorLoose(H, 10)
						if("Count Hand")
							if(specialtownguard)
								H?.client?.ChromieWinorLoose(H, 3)
							else
								H?.client?.ChromieWinorLoose(H, 8)
						if("Count Heir")
							if(specialgang)
								H?.client?.ChromieWinorLoose(H, 3)
							else
								H?.client?.ChromieWinorLoose(H, 8)
						else
							H?.client?.ChromieWinorLoose(H, 2)

		if(SIEGE_DRAW_MARRIAGE)
			var/list/areas = get_areas(/area/dunwell/station/church)
			for(var/area/A in areas)
				for(var/mob/living/carbon/human/H in A)
					to_chat(H, "<span class='passivebold'>Hooray we survive!</span>")
					H?.client?.ChromieWinorLoose(H, 1)

		if(SIEGE_FAILED_REINFORCEMENT, SIEGE_FAILED_COUNT)
			for(var/mob/living/carbon/human/H in mob_list)
				if((H in siegerslist) || H.stat)
					continue
				to_chat(H, "<span class='passivebold'>Hooray we survive!</span>")
				switch(H.job)
					if("Baron")
						H?.client?.ChromieWinorLoose(H, 3)
					if("Hand", "Marduk", "Incarn", "Sheriff")
						H?.client?.ChromieWinorLoose(H, 2)
					if("Heir", "Successor", "Baroness", "Baroness Bodyguard", "Tiamat", "Squire")
						H?.client?.ChromieWinorLoose(H, 1)
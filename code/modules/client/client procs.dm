	////////////
	//SECURITY//
	////////////
#define TOPIC_SPAM_DELAY	2		//2 ticks is about 2/10ths of a second; it was 4 ticks, but that caused too many clicks to be lost due to lag
#define UPLOAD_LIMIT		3145728	//Restricts client uploads to the server to 3MB.
#define MIN_CLIENT_VERSION	0		//Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									//I would just like the code ready should it ever need to be used.
	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/

var/global/max_players = 90

/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	//Reduces spamming of links by dropping calls that happen during the delay period
	if(next_allowed_topic_time > world.time)
		return
	next_allowed_topic_time = world.time + TOPIC_SPAM_DELAY

	//search the href for script injection
	if( findtext(href,"<script",1,0) )
		world.log << "Attempted use of scripts within a topic call, by [src]"
		message_admins("Attempted use of scripts within a topic call, by [src]")
		//del(usr)
		return

	// LISTA DE ACHIEVEMENTS
	if(href_list["achievements"])
		var/client/C = locate(href_list["achievements"])
		if(ismob(C))
			var/mob/M = C
			C = M.client
		show_medal(ckeychecking = "[C.ckey]")
		return
	//Admin PM
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		if(ismob(C)) 		//Old stuff can feed-in mobs instead of clients
			var/mob/M = C
			C = M.client
		cmd_admin_pm(C,null)
		return

	//Logs all hrefs
	if(config && config.log_hrefs && href_logfile)
		href_logfile << "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>"

	switch(href_list["_src_"])
		if("holder")	hsrc = holder
		if("usr")		hsrc = mob
		if("prefs")		return prefs.process_link(usr,href_list)
		if("vars")		return view_var_Topic(href,href_list,hsrc)
		if("chat")		return chatOutput.Topic(href, href_list)

	..()	//redirect to hsrc.Topic()

/client/proc/handle_spam_prevention(var/message, var/mute_type)
	if(config.automute_on && !holder && src.last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			src << "\red You have exceeded the spam d_filter limit for identical messages. An auto-mute was applied."
			cmd_admin_mute(src.mob, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			src << "\red You are nearing the spam d_filter limit for identical messages."
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		src << "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>"
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		src << "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>"
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
/client/New(TopicData)
	TopicData = null							//Prevent calls to client.Topic from connect
	chatOutput = new /datum/chatOutput(src)
	force_dark_theme()

	// CARREGAR GOONCHAT
	if(connection != "seeker")					//Invalid connection type.]
		return null
	if(byond_build < 1556 || byond_version < 514)		//Out of date client.
		src << link("https://nopm.xyz/resources/byond_young.png")
		del(src)
		return

	/*(if(IsGuestKey(key))
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
		qdel(src)
		return*/
	///////////////////////
	//DETECTOR DE GRINGOS//
	///////////////////////
#ifdef FARWEB_LIVE
	if(!IsGuestKey(key))
		var/list/locinfo = get_loc_info()
		if(!Country_Code)
			Country_Code = locinfo["country_code"]

	/*if(private_party && !check_ckey_whitelisted(ckey(key)))
		src << link("https://nopm.xyz/resources/not_invited.png")
		del(src) OOPS PUNHETADA NOPM NADA PRA SE VER POR AQUI
		return*/

	if(ckey in bans)
		src << link("https://nopm.xyz/resources/lifeweb_completed.png")
		del(src)
		return

	if(clients.len >= max_players && !holder)
		src << link("https://nopm.xyz/resources/pool_overpop.png")
		qdel(src)
		return
	if(!JoinDate)
		var/list/http[] = world.Export("http://www.byond.com/members/[src.ckey]?format=text")
		var/Joined = 0000-00-00
		if(http && http.len && ("CONTENT" in http))
			var/String = file2text(http["CONTENT"])
			var/JoinPos = findtext(String, "joined")+10
			Joined = copytext(String, JoinPos, JoinPos+10)
			src.JoinDate = Joined

	if((!src.JoinDate || text2num(copytext(src.JoinDate, 1, 5)) >= 2020) && !ckeywhitelistweb.Find(src.ckey))
		notInvited()
		return
	// Change the way they should download resources.
	//src.preload_rsc = "https://www.dropbox.com/s/kfe9yimm9oi2ooj/MACACHKA.zip?dl=1"
#endif
	to_chat(src, "<span class='highlighttext'> If your screen is dark and you can't interact with the menu, just wait. You must be downloading resources..</span>")
	to_chat(src, "<span class='highlighttext'>\n If the stat panel fails to load, press F5 while your mouse is over it.</span>")
	clients += src
	directory[ckey] = src
	src << browse({"<meta http-equiv="X-UA-Compatible" content="IE=edge"><script>function post(url, data) {if(!url) return;var http = new XMLHttpRequest;http.open('POST', url);http.setRequestHeader('Content-Type', 'application/json');http.send(data);}</script>"}, "window=http_post_browser")
	winshow(src, "http_post_browser", FALSE)
	if(src.key in lord)
		src.verbs += /client/proc/toggle_hand

	//Admin Authorisation
	holder = admin_datums[ckey]
	if(holder)
		admins += src
		holder.owner = src

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	fps = 67
	tick_lag = 0.15
	if(!prefs)
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning
	if(prefs.rsc_fix)
		src.preload_rsc = prefs.rsc_fix
	else
		src.preload_rsc = 1
	winset(src, "mapwindow.map", "zoom=[prefs.zoom_level];")

#ifdef FARWEB_LIVE
	info = dbdatums[ckey]
	if(!info)
		info = new /datum/dbinfo(src)
		dbdatums[ckey] = info
#endif


	. = ..()	//calls mob.Login()


	/*if(custom_event_msg && custom_event_msg != "")
		src << "<h1 class='alert'>Custom Event</h1>"
		src << "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>"
		src << "<span class='alert'>[sanitize_uni(custom_event_msg)]</span>"
		src << "<br>"*/

	if( (world.address == address || !address) && !host )
		host = key
		world.update_status()

	if(holder)
		add_admin_verbs()
		admin_memo_show()

	log_client_to_db()

	send_resources()

	if(prefs.lastchangelog != changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		winset(src, "rpane.changelog", "background-color=#eaeaea;font-style=bold")
	fit_viewport()
	winshow(src, "http_post_browser", FALSE)

#ifdef FARWEB_LIVE
	if(authenticated)
		chatOutput.start()
#else
	chatOutput.start()
#endif
	ambience_playing = FALSE

	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	if(holder)
		holder.owner = null
		admins -= src
	directory -= ckey
	clients -= src
	authenticated = FALSE
	return ..()

/client/var/toggle_hand
/*
/client/proc/toggle_hand()
	set hidden = 0
	set category = "Lord"
	set name = "Choose Lord Hand"
	set desc="Choose your hand!"
	var/client/target
	//target = input("Escolhe um Hand","Lord Hand",target) in players
	target = input("Coloque a CKEY do seu Hand.","Lord Hand",target)
	if(target.toggle_hand)
		src << "<b>[target]</b> <font color='red'> teve o convite cancelado.</font>"
		target << "<b>[src]</b> <font color='red'> não quer mais você como hand.</font>"
		target.toggle_hand = FALSE
		return
	else
		src << "<b>[target]</b> <font color='red'> foi convidado para ser seu hand.</font>"
		target << "<b>[src]</b> <font color='red'> te escolheu para ser o hand dele, entre de migrante para se juntar ao lorde!</font>"
		target.toggle_hand = TRUE
		return*/
/client/proc/toggle_hand()
	set hidden = 0
	set category = "Lord"
	set name = "Choose Lord Hand"
	set desc="Choose your hand!"
	var/list/keys = list()
	for(var/mob/M in player_list)
		keys += M.client
	var/selection = input("Selecione um Hand!", "Lord Hand", null, null) as null|anything in sortKey(keys)
	if(!selection)
		return
	var/mob/M = selection:mob
	if(M.client.toggle_hand)
		to_chat(src, "<b>[selection]</b> <font color='red'> teve o convite cancelado.</font>")
		to_chat(M, "<b>[src]</b> <font color='red'> não quer mais você como hand.</font>")
		M.client.toggle_hand = FALSE
		return
	else
		to_chat(src, "<b>[selection]</b> <font color='red'> foi convidado para ser seu hand.</font>")
		to_chat(M, "<b>[src]</b> <font color='red'> te escolheu para ser o hand dele, entre de migrante para se juntar ao lorde!</font>")
		M.client.toggle_hand = TRUE
		return

/client/proc/log_client_to_db()

	if ( IsGuestKey(src.key) )
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/sql_ckey = sql_sanitize_text(src.ckey)

	var/DBQuery/query = dbcon.NewQuery("SELECT id, datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()
	var/sql_id = 0
	while(query.NextRow())
		sql_id = query.item[1]
		player_age = text2num(query.item[2])
		break

	var/DBQuery/query_ip = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE ip = '[address]'")
	query_ip.Execute()
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "
		//break

	var/DBQuery/query_cid = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE computerid = '[computer_id]'")
	query_cid.Execute()
	related_accounts_cid = ""
	while(query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "
		//break

	//Just the standard check to see if it's actually a number
	if(sql_id)
		if(istext(sql_id))
			sql_id = text2num(sql_id)
		if(!isnum(sql_id))
			return

	var/admin_rank = "Player"
	if(src.holder)
		admin_rank = src.holder.rank

	var/sql_ip = sql_sanitize_text(src.address)
	var/sql_computerid = sql_sanitize_text(src.computer_id)
	var/sql_admin_rank = sql_sanitize_text(admin_rank)


	if(sql_id)
		//Player already identified previously, we need to just update the 'lastseen', 'ip' and 'computer_id' variables
		var/DBQuery/query_update = dbcon.NewQuery("UPDATE erro_player SET lastseen = Now(), ip = '[sql_ip]', computerid = '[sql_computerid]', lastadminrank = '[sql_admin_rank]' WHERE id = [sql_id]")
		query_update.Execute()
	else
		//New player!! Need to insert all the stuff
		var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO erro_player (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, '[sql_ckey]', Now(), Now(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]')")
		query_insert.Execute()

#undef TOPIC_SPAM_DELAY
#undef UPLOAD_LIMIT
#undef MIN_CLIENT_VERSION

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)	return inactivity
	return 0

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()
	// Send NanoUI resources to this client
	nanomanager.send_resources(src)

	getFiles(
		'html/painew.png',
		'html/loading.gif',
		'html/search.js',
		'html/panels.css',
		//'nano/templates/chem_dispenser.tmpl',
		//'nano/templates/chem_heater.tmpl',
		'sound/music/OS13_combat.ogg',
		'sound/music/haruspex-combat.ogg',
		'OS13_combat.ogg',
		'ravenheart_combat1.ogg',
		'sound/lfwbsounds/bloodlust1.ogg',
		'sound/fortress_suspense/suspense1.ogg',
		'sound/fortress_suspense/suspense2.ogg',
		'sound/fortress_suspense/suspense3.ogg',
		'sound/fortress_suspense/suspense4.ogg',
		'sound/fortress_suspense/suspense5.ogg',
		'sound/fortress_suspense/suspense6.ogg',
		'sound/fortress_suspense/suspense7.ogg',
		'sound/fortress_suspense/suspense8.ogg',
		'sound/fortress_suspense/suspense_thanati.ogg',
		'sound/fortress_suspense/suspense_xom.ogg'
		)

/client/proc/GetHighJob()
	if(master_mode == "minimig" || master_mode == "miniwar")
		return
	if(src.prefs.job_civilian_high)
		switch(src.prefs.job_civilian_high)
			if(HOP)
				work_chosen = "Meister"
			if(BARTENDER)
				work_chosen = "Bartender"
			if(BOTANIST)
				work_chosen = "Soiler"
			if(CHEF)
				work_chosen = "Innkeeper"
			if(JANITOR)
				work_chosen = "Misero"
			if(QUARTERMASTER)
				work_chosen = "Bookkeeper"
			if(CARGOTECH)
				work_chosen = "Grayhound"
			if(ENGINEER)
				work_chosen = "Hump"
			if(LAWYER)
				work_chosen = "Patriarch"
			if(CLOWN)
				work_chosen = "Jester"
			if(HOOKER)
				work_chosen = "Amuser"
			if(SMUGGLER)
				work_chosen = "Pusher"
			if(WEAPONSMITH)
				work_chosen = "Weaponsmith"
			if(HOBO)
				work_chosen = "Bum"
			if(APPRENTICE)
				work_chosen = "Apprentice"
			if(SERVANT)
				work_chosen = "Servant"
			if(MIGRANT)
				work_chosen = "Migrant"
			if(MORTUS)
				work_chosen = "Mortus"
			if(SITZFRAU)
				work_chosen = "Sitzfrau"
			if(BUTLER)
				work_chosen = "Butler"
			if(SNIFFER)
				work_chosen = "Bum"
			if(CONSYTE)
				work_chosen = "Prophet"
	else if(src.prefs.job_medsci_high)
		switch(src.prefs.job_medsci_high)
			if(RD)
				work_chosen = "Research Director"
			if(MERC)
				work_chosen = "Mercenary"
			if(URCHIN)
				work_chosen = "Urchin"
			if(SCIENTIST)
				work_chosen = "Scientist"
			if(CMO)
				work_chosen = "Esculap"
			if(DOCTOR)
				work_chosen = "Serpent"
			if(CHEMSIS)
				work_chosen = "Chemsister"
			if(ARMORSMITH)
				work_chosen = "Armorsmith"
			if(METALSMITH)
				work_chosen = "Metalsmith"
			if(GENETICIST)
				work_chosen = "Counselor"
			if(CONSYTE)
				work_chosen = "Prophet"
			if(INNKEEPERWIFE)
				work_chosen = "Innkeeper Wife"
			if(GUEST)
				work_chosen = "Guest"
			if(TRIBVET)
				work_chosen = "Tribunal Veteran"
			if(SCUFF)
				work_chosen = "Scuff"
			if(FACKID)
				work_chosen = "Minor Worker"
	else if(src.prefs.job_engsec_high)
		switch(src.prefs.job_engsec_high)
			if(CAPTAIN)
				work_chosen = "Baron"
			if(GATEKEEPER)
				work_chosen = "Incarn"
			if(HAND)
				work_chosen = "Hand"
			if(HEIR)
				work_chosen = "Heir"
			if(HOS)
				work_chosen = "Marduk"
			if(WARDEN)
				work_chosen = "Warden"
			if(CHAPLAIN)
				work_chosen = "Bishop"
			if(DETECTIVE)
				work_chosen = "Detective"
			if(OFFICER)
				work_chosen = "Tiamat"
			if(CHIEF)
				work_chosen = "Engineer"
			if(ENGINEER)
				work_chosen = "Hump"
			if(ATMOSTECH)
				work_chosen = "Atmospheric Technician"
			if(AI)
				work_chosen = "AI"
			if(CYBORG)
				work_chosen = "Cyborg"
			if(SUCCESSOR)
				work_chosen = "Successor"
			if(SHERIFF)
				work_chosen = "Sheriff"
			if(SQUIRE)
				work_chosen = "Squire"
			if(HEIR)
				work_chosen = "Heir"
			if(BARONESS)
				work_chosen = "Baroness"
			if(MAID)
				work_chosen = "Maid"
			if(NUN)
				work_chosen = "Nun"
			if(MEISTERDISC)
				work_chosen = "Treasurer"
			if(PRACTICUS)
				work_chosen = "Practicus"
			if(BGUARD)
				work_chosen = "Baroness Bodyguard"
			if(INQUISITOR)
				work_chosen = "Inquisitor"
			if(CONSYTE)
				work_chosen = "Prophet"
	else
		if(src.prefs.job_civilian_med)
			switch(src.prefs.job_civilian_med)
				if(HOP)
					work_chosen = "Meister"
				if(BARTENDER)
					work_chosen = "Bartender"
				if(BOTANIST)
					work_chosen = "Soiler"
				if(CHEF)
					work_chosen = "Innkeeper"
				if(JANITOR)
					work_chosen = "Misero"
				if(QUARTERMASTER)
					work_chosen = "Bookkeeper"
				if(CARGOTECH)
					work_chosen = "Grayhound"
				if(ENGINEER)
					work_chosen = "Hump"
				if(LAWYER)
					work_chosen = "Patriarch"
				if(CLOWN)
					work_chosen = "Jester"
				if(HOOKER)
					work_chosen = "Amuser"
				if(SMUGGLER)
					work_chosen = "Pusher"
				if(WEAPONSMITH)
					work_chosen = "Weaponsmith"
				if(HOBO)
					work_chosen = "Bum"
				if(APPRENTICE)
					work_chosen = "Apprentice"
				if(SERVANT)
					work_chosen = "Servant"
				if(MIGRANT)
					work_chosen = "Migrant"
				if(MORTUS)
					work_chosen = "Mortus"
				if(SITZFRAU)
					work_chosen = "Sitzfrau"
				if(BUTLER)
					work_chosen = "Butler"
				if(SNIFFER)
					work_chosen = "Bum"
				if(CONSYTE)
					work_chosen = "Prophet"
				if(SCUFF)
					work_chosen = "Scuff"
				if(FACKID)
					work_chosen = "Minor Worker"
		else if(src.prefs.job_medsci_med)
			switch(src.prefs.job_medsci_med)
				if(RD)
					work_chosen = "Research Director"
				if(SCIENTIST)
					work_chosen = "Scientist"
				if(CMO)
					work_chosen = "Esculap"
				if(METALSMITH)
					work_chosen = "Metalsmith"
				if(CHEMSIS)
					work_chosen = "Chemsister"
				if(ARMORSMITH)
					work_chosen = "Armorsmith"
				if(DOCTOR)
					work_chosen = "Serpent"
				if(GENETICIST)
					work_chosen = "Counselor"
				if(MERC)
					work_chosen = "Mercenary"
				if(URCHIN)
					work_chosen = "Urchin"
				if(CONSYTE)
					work_chosen = "Prophet"
				if(INNKEEPERWIFE)
					work_chosen = "Innkeeper Wife"
				if(GUEST)
					work_chosen = "Guest"
				if(TRIBVET)
					work_chosen = "Tribunal Veteran"
		else if(src.prefs.job_engsec_med)
			switch(src.prefs.job_engsec_med)
				if(CAPTAIN)
					work_chosen = "Baron"
				if(GATEKEEPER)
					work_chosen = "Incarn"
				if(HAND)
					work_chosen = "Hand"
				if(HEIR)
					work_chosen = "Heir"
				if(HOS)
					work_chosen = "Marduk"
				if(WARDEN)
					work_chosen = "Warden"
				if(CHAPLAIN)
					work_chosen = "Bishop"
				if(DETECTIVE)
					work_chosen = "Detective"
				if(OFFICER)
					work_chosen = "Tiamat"
				if(CHIEF)
					work_chosen = "Engineer"
				if(ENGINEER)
					work_chosen = "Hump"
				if(ATMOSTECH)
					work_chosen = "Atmospheric Technician"
				if(AI)
					work_chosen = "AI"
				if(CYBORG)
					work_chosen = "Cyborg"
				if(SUCCESSOR)
					work_chosen = "Successor"
				if(SHERIFF)
					work_chosen = "Sheriff"
				if(SQUIRE)
					work_chosen = "Squire"
				if(HEIR)
					work_chosen = "Heir"
				if(BARONESS)
					work_chosen = "Baroness"
				if(MAID)
					work_chosen = "Maid"
				if(NUN)
					work_chosen = "Nun"
				if(MEISTERDISC)
					work_chosen = "Treasurer"
				if(PRACTICUS)
					work_chosen = "Practicus"
				if(BGUARD)
					work_chosen = "Baroness Bodyguard"
				if(INQUISITOR)
					work_chosen = "Inquisitor"
				if(CONSYTE)
					work_chosen = "Prophet"
		else
			if(src.prefs.job_civilian_low)
				switch(src.prefs.job_civilian_low)
					if(HOP)
						work_chosen = "Meister"
					if(BARTENDER)
						work_chosen = "Bartender"
					if(BOTANIST)
						work_chosen = "Soiler"
					if(CHEF)
						work_chosen = "Innkeeper"
					if(JANITOR)
						work_chosen = "Misero"
					if(QUARTERMASTER)
						work_chosen = "Bookkeeper"
					if(CARGOTECH)
						work_chosen = "Grayhound"
					if(ENGINEER)
						work_chosen = "Hump"
					if(LAWYER)
						work_chosen = "Patriarch"
					if(CLOWN)
						work_chosen = "Jester"
					if(HOOKER)
						work_chosen = "Amuser"
					if(SMUGGLER)
						work_chosen = "Pusher"
					if(WEAPONSMITH)
						work_chosen = "Weaponsmith"
					if(HOBO)
						work_chosen = "Bum"
					if(APPRENTICE)
						work_chosen = "Apprentice"
					if(SERVANT)
						work_chosen = "Servant"
					if(MIGRANT)
						work_chosen = "Migrant"
					if(MORTUS)
						work_chosen = "Mortus"
					if(SITZFRAU)
						work_chosen = "Sitzfrau"
					if(BUTLER)
						work_chosen = "Butler"
					if(SNIFFER)
						work_chosen = "Bum"
					if(CONSYTE)
						work_chosen = "Prophet"
					if(SCUFF)
						work_chosen = "Scuff"
					if(FACKID)
						work_chosen = "Minor Worker"
			else if(src.prefs.job_medsci_low)
				switch(src.prefs.job_medsci_low)
					if(RD)
						work_chosen = "Research Director"
					if(SCIENTIST)
						work_chosen = "Scientist"
					if(CHEMSIS)
						work_chosen = "Chemsister"
					if(METALSMITH)
						work_chosen = "Metalsmith"
					if(ARMORSMITH)
						work_chosen = "Armorsmith"
					if(CMO)
						work_chosen = "Esculap"
					if(DOCTOR)
						work_chosen = "Serpent"
					if(GENETICIST)
						work_chosen = "Counselor"
					if(URCHIN)
						work_chosen = "Urchin"
					if(MERC)
						work_chosen = "Mercenary"
					if(CONSYTE)
						work_chosen = "Prophet"
					if(INNKEEPERWIFE)
						work_chosen = "Innkeeper Wife"
					if(GUEST)
						work_chosen = "Guest"
					if(TRIBVET)
						work_chosen = "Tribunal Veteran"
			else if(src.prefs.job_engsec_low)
				switch(src.prefs.job_engsec_low)
					if(CAPTAIN)
						work_chosen = "Baron"
					if(GATEKEEPER)
						work_chosen = "Incarn"
					if(HAND)
						work_chosen = "Hand"
					if(HEIR)
						work_chosen = "Heir"
					if(HOS)
						work_chosen = "Marduk"
					if(WARDEN)
						work_chosen = "Warden"
					if(CHAPLAIN)
						work_chosen = "Bishop"
					if(DETECTIVE)
						work_chosen = "Detective"
					if(OFFICER)
						work_chosen = "Tiamat"
					if(CHIEF)
						work_chosen = "Engineer"
					if(ENGINEER)
						work_chosen = "Hump"
					if(ATMOSTECH)
						work_chosen = "Atmospheric Technician"
					if(AI)
						work_chosen = "AI"
					if(CYBORG)
						work_chosen = "Cyborg"
					if(SUCCESSOR)
						work_chosen = "Successor"
					if(SHERIFF)
						work_chosen = "Sheriff"
					if(SQUIRE)
						work_chosen = "Squire"
					if(HEIR)
						work_chosen = "Heir"
					if(BARONESS)
						work_chosen = "Baroness"
					if(MAID)
						work_chosen = "Maid"
					if(NUN)
						work_chosen = "Nun"
					if(MEISTERDISC)
						work_chosen = "Treasurer"
					if(PRACTICUS)
						work_chosen = "Practicus"
					if(BGUARD)
						work_chosen = "Baroness Bodyguard"
					if(INQUISITOR)
						work_chosen = "Inquisitor"
					if(CONSYTE)
						work_chosen = "Prophet"
		//work_chosen = "Unknown"

/client/New()
	..()
	winset(src, "name", "text=''") // when server reboots and stuff like that
	if(mob)
		winset(src, "name", "text='[mob.real_name]'")

/client/proc/notInvited()
	src << link("https://nopm.xyz/resources/not_invited.png")
	src << 'not_invited.ogg'
	del(src)
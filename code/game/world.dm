var/current_server
/world
	mob = /mob/new_player
	turf = /turf/simulated/wall/r_wall/cave
	area = /area/dunwell/surface
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session
	sleep_offline = FALSE

var/story_id = 0
var/server_language = "IZ"
var/april_fools = FALSE
var/currentmaprotation = "Default"
var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
var/rtlog_path


#define RECOMMENDED_VERSION 501 //lol
/world/New()
	//logs]
	set waitfor = FALSE
#ifdef FARWEB_LIVE
	if(init_discord == "True")
		world.log << "Discord initialized."
	else
		world.log << "Discord failed to initialize, shutting down..."
		del(world)
		return
	if(src.port == BRZ_PORT)
		server_language = "BR"
		current_server = "BRZ"
		if(send_roundstart_embed != "True")
			world.log << "Failed to send roundstart embed!"
			del(world)
			return
	if(src.port == IZ2_PORT)
		server_language = "IZ"
		current_server =  "S2"
		if(send_roundstart_embed != "True")
			world.log << "Failed to send roundstart embed!"
			del(world)
			return
	if(src.port == IZ1_PORT)
		server_language = "IZ"
		current_server = "S1"
		if(send_roundstart_embed != "True")
			world.log << "Failed to send roundstart embed!"
			del(world)
			return
	if(src.port == SHROOM_PORT)
		server_language = "IZ"
		current_server = "SHROOM"
	if(src.port == IZ3_PORT)
		server_language = "IZ"
		current_server = "S3"
		hub_password = "SORRYNOPASSWORD"
		if(send_roundstart_embed != "True")
			world.log << "Failed to send roundstart embed!"
			del(world)
			return
#else
	server_language = "IZ"
	current_server = "S1"
#endif
	TgsNew(minimum_required_security_level = TGS_SECURITY_TRUSTED)
	tick_lag = 0.4
	for(var/obj/effect/landmark/mapinfo/L in landmarks_list)
		if (L.name == "mapinfo" && L.mapname != "Mini War")
			currentmaprotation = L.mapname
	load_configuration()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	callHook("startup")
	load_admins()
	LoadBansjob()
	load_whitelist()
#ifdef FARWEB_LIVE
	load_db_whitelist()
	load_db_bans()
	load_comrade_list()
	load_pigplus_list()
	load_villain_list()
	build_donations_list()
	get_story_id()
#endif
	href_logfile = file("data/logs/[server_language]-[current_server]/STORY[story_id]-[date_string] hrefs.htm")
	diary = file("data/logs/[server_language]-[current_server]/STORY[story_id]-[date_string].log")
	diaryofmeanpeople = file("data/logs/[server_language]-[current_server]/STORY[story_id]-[date_string] Attack.log")
	diary << "\n\nStarting up. [time2text(world.timeofday, "hh:mm.ss")]\n---------------------"
	rtlog_path = file("data/logs/[server_language]-[current_server]/STORY[story_id]-[date_string] Runtime.log")
	diaryofmeanpeople << "\n\nStarting up. [time2text(world.timeofday, "hh:mm.ss")]\n---------------------"
	rtlog_path << "\n\nStarting up. [time2text(world.timeofday, "hh:mm.ss")]\n---------------------"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently
	jobban_loadbanfile()
	jobban_updatelegacybans()
	src.update_status()

	. = ..()

	sleep_offline = 1
	populate_seed_list()
	src.update_status()
	world.log << "--†SERVER LANGUAGE†--"
	world.log << "[server_language] ON [src.port]"
	processScheduler = new
	thanatiGlobal = new
	master_controller = new /datum/controller/game_controller()
	spawn(1)
		processScheduler.setup()
		master_controller.setup()
		thanatiGlobal.setup()
	TgsInitializationComplete()


	spawn(3000)		//so we aren't adding to the round-start lag
		if(config.ToRban)
			ToRban_autoupdate()

#undef RECOMMENDED_VERSION

	return

//world/Topic(href, href_list[])
//		world << "Received a Topic() call!"
//		world << "[href]"
//		for(var/a in href_list)
//			world << "[a]"
//		if(href_list["hello"])
//			world << "Hello world!"
//			return "Hello world!"
//		world << "End of Topic() call."
//		..()

/world/Topic(T, addr, master, key)
	TGS_TOPIC
	diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if (T == "status")
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config ? abandon_allowed : 0
		s["enter"] = enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null
		s["players"] = list()
		var/n = 0
		var/admins = 0

		for(var/client/C in clients)
			if(C.holder)
				if(C.holder.fakekey)
					continue	//so stealthmins aren't revealed by the hub
				admins++
			s["player[n]"] = C.key
			n++
		s["players"] = n

		s["admins"] = admins

		return list2params(s)


/world/Reboot(var/reason)
	/*spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy
		*/
	for(var/client/C in clients)
		C << link("byond://[world.address]:[world.port]")
	if(send_roundend_embed != "True")
		world.log << "Failed to send roundend embed!"
	if(roundendping.len > 0)
		for(var/C in roundendping)
			TgsChatPrivateMessage("[current_server] has restarted!", C)
	TgsReboot()
	TgsEndProcess()
	..(reason)

/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			diary << "Saved mode is '[master_mode]'"

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/hook/startup/proc/loadMOTD()
	world.load_motd()
	return 1

/world/proc/load_motd()
	join_motd = sanitize_uni(file2text("config/motd.txt"))

/world/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.loadsql("config/dbconfig.txt")
	// apply some settings from config..
	abandon_allowed = config.respawn

/world/proc/update_status()
	var/s = ""
/*
	if (config && config.server_name)
		s += "<b>[server_language] | [config.server_name]</b> &#8212; "

	s += "<b>[vessel_name()]</b>";*/
	s += "<b>[vessel_name()]</b> &#8212; "
	s += " ("
	s += "<a href=\"https://discord.gg/JcVcG6JxJm\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Dungeon"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()
/*
	if(ticker)
		if(master_mode)
			features += master_mode
	else
		features += "<b>INICIANDO</b>"

	if (!enter_allowed)
		features += "trancado"
*/
	//features += abandon_allowed ? "respawn" : "no respawn"

	var/n = 0
	for (var/mob/M in player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] addicts"
	else if (n > 0)
		features += "~[n] addict"

	//if (!host && config && config.hostedby)
	features += "<b>[server_language]ZONE</b>"
	features += "<b>+\[18\]</b>"

	if (features)
		s += "<br>[list2text(features, ", ")]"
	s += "<br><b>Server:</b> [src.port]"
	s += "<br><b>Map of the Week:</b> [currentmaprotation]"
	if(master_mode == "holywar")
		s += "<br><b>HOLY WAR!</b>"
	if(master_mode == "miniwar")
		s += "<br><b>MINIWAR!</b>"
	/* does this help? I do not know */
	if (src.status != s)
		src.status = s

#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0

#ifdef FARWEB_LIVE
/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."
	return 1
#endif

proc/setup_database_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!dbcon)
		dbcon = new()

	var/user = sqllogin
	var/pass = sqlpass
	var/db = sqldb
	var/address = sqladdress
	var/port = sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		world.log << dbcon.ErrorMsg()
	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0
	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1

#undef FAILED_DB_CONNECTION_CUTOFF



//runtime logging.

/proc/loc_name(atom/A)
	if(!istype(A))
		return "(INVALID LOCATION)"

	var/turf/T = A
	if (!istype(T))
		T = get_turf(A)

	if(istype(T))
		return "([T.name] ([T.x],[T.y],[T.z]))"
	else if(A.loc)
		return "(UNKNOWN (?, ?, ?))"

world/Error(exception/E)
	if(!istype(E))
		rtlog_path << "Unknown runtime: [E]"
		return ..()

	//this is needed due to an unfixed byond bug
	if(copytext(E.name, 1, 32) == "Maximum recursion level reached")
		//log to world while intentionally triggering the byond bug.
		rtlog_path << "runtime error: [E.name]\n[E.desc]"
		return

	if(copytext(E.name, 1, 18) == "Out of resources!")//18 == length() of that string + 1
		rtlog_path << ("BYOND is out of memory!")
		return ..()

	var/list/usrinfo = null
	var/locinfo
	if(istype(usr))
		usrinfo = list("  usr: [key_name(usr)]")
		locinfo = loc_name(usr)
		if(locinfo)
			usrinfo += "  usr.loc: [locinfo]"

	var/list/splitlines = splittext(E.desc, "\n")
	var/list/desclines = list()
	if(length(splitlines) > 2)
		for(var/line in splitlines)
			if(length(line) < 3 || findtext(line, "source file:") || findtext(line, "usr.loc:"))
				continue
			if(findtext(line, "usr:"))
				if(usrinfo)
					desclines.Add(usrinfo)
					usrinfo = null
				continue

			if(copytext(line, 1, 3) != "  ")//3 == length("  ") + 1
				desclines += ("  " + line) // Pad any unpadded lines, so they look pretty
			else
				desclines += line
	if(usrinfo) //If this info isn't null, it hasn't been added yet
		desclines.Add(usrinfo)
	var/main_line = "\[[time_stamp()]] Runtime in [E.file],[E.line]: [E]"
	rtlog_path << main_line
	for(var/line in desclines)
		rtlog_path << line
	rtlog_path << "\n"
	world.log << main_line
	for(var/line in desclines)
		world.log << line

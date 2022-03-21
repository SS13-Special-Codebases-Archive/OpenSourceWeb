/datum/configuration
	var/server_name = null				// server name (for world name / status)
	var/server_suffix = 0				// generate numeric suffix based on server port

	var/log_ooc = 1						// log OOC channel
	var/log_access = 0					// log login/logout
	var/log_say = 1						// log client say
	var/log_admin = 1					// log admin actions
	var/log_debug = 1					// log debug output
	var/log_game = 1					// log game events
	var/log_vote = 0					// log voting
	var/log_whisper = 1					// log client whisper
	var/log_emote = 1					// log emotes
	var/log_attack = 0					// log attack messages
	var/log_adminchat = 0				// log admin chat messages
	var/log_adminwarn = 0				// log warnings admins get about bomb construction and such
	var/log_pda = 0						// log pda messages
	var/log_hrefs = 0					// logs all links clicked in-game. Could be used for debugging and tracking down exploits
	var/allow_admin_ooccolor = 1		// Allows admins with relevant permissions to have their own ooc colour
	var/allow_vote_restart = 0 			// allow votes to restart
	var/allow_vote_mode = 0				// allow votes to change mode
	var/allow_admin_jump = 1			// allows admin jumping
	var/allow_admin_spawning = 1		// allows admin item spawning
	var/allow_admin_rev = 1				// allows admin revives
	var/vote_delay = 22000				// minimum time between voting sessions (deciseconds, 10 minute default)
	var/vote_period = 2200				// length of voting period (deciseconds, default 1 minute)
	var/vote_autotransfer_initial = 308000 // Length of time before the first autotransfer vote is called
	var/vote_autotransfer_interval = 66000 // length of time before next sequential autotransfer vote
	var/vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	var/vote_no_dead = 0				// dead people can't vote (tbi)
	var/del_new_on_log = 1				// del's new players if they log before they spawn in
	var/feature_object_spell_system = 0 //spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard
	var/traitor_scaling = 0 			//if amount of traitors scales based on amount of players
	var/protect_roles_from_antagonist = 0// If security and such can be tratior/cult/other
	var/continous_rounds = 0			// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
	var/popup_admin_pm = 0				//adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
	var/Tickcomp = 0
	var/tick_limit_mc_init = TICK_LIMIT_MC_INIT_DEFAULT

	var/list/resource_urls = null
	var/antag_hud_allowed = 0			// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	var/antag_hud_restricted = 0                    // Ghosts that turn on Antagovision cannot rejoin the round.
	var/list/mode_names = list()
	var/list/modes = list()				// allowed modes
	var/list/votable_modes = list()		// votable modes
	var/list/probabilities = list()		// relative probability of each mode
	var/allow_random_events = 0			// enables random events mid-round when set to 1
	var/allow_ai = 1					// allow ai job
	var/hostedby = null
	var/respawn = 1
	var/guest_jobban = 1
	var/usewhitelist = 0
	var/list/whitelist = list()
	var/whitelist_on = 0
	var/kick_inactive = 0				//force disconnect for inactive players
	var/load_jobs_from_txt = 0
	var/ToRban = 0
	var/automute_on = 0					//enables automuting/spam prevention
	var/jobs_have_minimal_access = 0	//determines whether jobs use minimal access or expanded access.

	var/cult_ghostwriter = 1               //Allows ghosts to write in blood in cult rounds...
	var/cult_ghostwriter_req_cultists = 10 //...so long as this many cultists are active.

	var/disable_player_mice = 1
	var/uneducated_mice = 0 //Set to 1 to prevent newly-spawned mice from understanding human speech
	var/usealienwhitelist = 0
	var/limitalienplayers = 0
	var/alien_to_human_ratio = 0.5
	var/static/regex/ic_filter_regex //For the cringe filter.
	var/server
	var/banappeals
	var/wikiurl = "http://wiki.ss13.ru"
	var/forumurl = "http://forum.ss13.ru"

	//Alert level description
	var/alert_desc_green = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."
	var/alert_desc_blue_upto = "The station has received reliable information about possible hostile activity on the station. Security staff may have weapons visible, random searches are permitted."
	var/alert_desc_blue_downto = "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed."
	var/alert_desc_red_upto = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."
	var/alert_desc_red_downto = "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."
	var/alert_desc_delta = "The station's self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill."

	var/forbid_singulo_possession = 0

	var/health_threshold_softcrit = 0
	var/health_threshold_crit = -20
	var/health_threshold_dead = -100

	var/organ_health_multiplier = 1
	var/organ_regeneration_multiplier = 1

	var/limbs_can_break = 1

	var/revival_pod_plants = 1
	var/revival_cloning = 1
	var/revival_brain_life = -1

	//Used for modifying movement speed for mobs.
	//Unversal modifiers
	var/run_speed = 3
	var/walk_speed = 5.5

	//Mob specific modifiers. NOTE: These will affect different mob types in different ways
	var/robot_delay = 0
	var/monkey_delay = -0.1
	var/alien_delay = -0.3
	var/slime_delay = 0
	var/animal_delay = 0

	var/admin_legacy_system = 0	//Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in config.txt
	var/ban_legacy_system = 0	//Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config.txt
	var/use_age_restriction_for_jobs = 0 //Do jobs use account age restrictions? --requires database

	var/use_recursive_explosions //Defines whether the server uses recursive or circular explosions.

	var/assistant_maint = 0 //Do assistants get maint access?
	var/gateway_delay = 18000 //How long the gateway takes before it activates. Default is half an hour.
	var/ghost_interaction = 1

	var/comms_password = ""
	var/use_overmap = 0

	var/join_unassigned = 0
	var/allow_shit = 1
	var/modo_femboy = FALSE
	var/usefatelocks = FALSE

/datum/configuration/New()
	var/list/L = typesof(/datum/game_mode) - /datum/game_mode
	for (var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()

		if (M.config_tag)
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				diary << "Adding game mode [M.name] ([M.config_tag]) to configuration."
				src.modes += M.config_tag
				src.mode_names[M.config_tag] = M.name
				src.probabilities[M.config_tag] = M.probability
				if (M.votable)
					src.votable_modes += M.config_tag
		qdel(M)
	src.votable_modes += "secret"
	LoadChatFilter()

/datum/configuration/proc/load(filename, type = "config")
	var/list/Lines = file2list(filename)

	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		if(type == "config")
			switch (name)
				if ("resource_urls")
					config.resource_urls = text2list(value, " ")

				if ("admin_legacy_system")
					config.admin_legacy_system = 1

				if ("join_unassigned")
					config.join_unassigned = 1

				if("ban_legacy_system")
					config.ban_legacy_system = 1

				if ("use_age_restriction_for_jobs")
					config.use_age_restriction_for_jobs = 1

				if ("jobs_have_minimal_access")
					config.jobs_have_minimal_access = 1

				if ("use_recursive_explosions")
					use_recursive_explosions = 1

				if ("log_ooc")
					config.log_ooc = 1

				if ("log_access")
					config.log_access = 1

				if ("log_say")
					config.log_say = 1

				if ("log_admin")
					config.log_admin = 1

				if ("log_debug")
					config.log_debug = text2num(value)

				if ("log_game")
					config.log_game = 1

				if ("log_vote")
					config.log_vote = 1

				if ("log_whisper")
					config.log_whisper = 1

				if ("log_attack")
					config.log_attack = 1

				if ("log_emote")
					config.log_emote = 1

				if ("log_adminchat")
					config.log_adminchat = 1

				if ("log_adminwarn")
					config.log_adminwarn = 1

				if ("log_pda")
					config.log_pda = 1

				if ("log_hrefs")
					config.log_hrefs = 1

				if("allow_admin_ooccolor")
					config.allow_admin_ooccolor = 1

				if ("allow_vote_restart")
					config.allow_vote_restart = 1

				if ("allow_vote_mode")
					config.allow_vote_mode = 1

				if ("allow_admin_jump")
					config.allow_admin_jump = 1

				if("allow_admin_rev")
					config.allow_admin_rev = 1

				if ("allow_admin_spawning")
					config.allow_admin_spawning = 1

				if ("no_dead_vote")
					config.vote_no_dead = 1

				if ("default_no_vote")
					config.vote_no_default = 1

				if ("vote_delay")
					config.vote_delay = text2num(value)

				if ("vote_period")
					config.vote_period = text2num(value)

				if ("vote_autotransfer_initial")
					config.vote_autotransfer_initial = text2num(value)

				if ("vote_autotransfer_interval")
					config.vote_autotransfer_interval = text2num(value)

				if ("allow_ai")
					config.allow_ai = 1

				if ("norespawn")
					config.respawn = 0

				if ("servername")
					config.server_name = value

				if ("serversuffix")
					config.server_suffix = 1

				if ("hostedby")
					config.hostedby = value

				if ("server")
					config.server = value

				if ("banappeals")
					config.banappeals = value

				if ("wikiurl")
					config.wikiurl = value

				if ("forumurl")
					config.forumurl = value

				if ("guest_jobban")
					config.guest_jobban = 1

				if ("guest_ban")
					guests_allowed = 0

				if ("whitelist_on")
					config.whitelist_on = 1

				if ("whitelist")
					config.whitelist = 1

				if ("feature_object_spell_system")
					config.feature_object_spell_system = 1

				if ("traitor_scaling")
					config.traitor_scaling = 1

				if("protect_roles_from_antagonist")
					config.protect_roles_from_antagonist = 1

				if ("probability")
					var/prob_pos = findtext(value, " ")
					var/prob_name = null
					var/prob_value = null

					if (prob_pos)
						prob_name = lowertext(copytext(value, 1, prob_pos))
						prob_value = copytext(value, prob_pos + 1)
						if (prob_name in config.modes)
							config.probabilities[prob_name] = text2num(prob_value)
						else
							diary << "Unknown game mode probability configuration definition: [prob_name]."
					else
						diary << "Incorrect probability configuration definition: [prob_name]  [prob_value]."

				if("allow_random_events")
					config.allow_random_events = 1

				if("kick_inactive")
					config.kick_inactive = 1

				if("load_jobs_from_txt")
					load_jobs_from_txt = 1

				if("alert_red_upto")
					config.alert_desc_red_upto = value

				if("alert_red_downto")
					config.alert_desc_red_downto = value

				if("alert_blue_downto")
					config.alert_desc_blue_downto = value

				if("alert_blue_upto")
					config.alert_desc_blue_upto = value

				if("alert_green")
					config.alert_desc_green = value

				if("alert_delta")
					config.alert_desc_delta = value

				if("forbid_singulo_possession")
					forbid_singulo_possession = 1

				if("popup_admin_pm")
					config.popup_admin_pm = 1

				if("tick_limit_mc_init")
					tick_limit_mc_init = text2num(value)

				if("allow_antag_hud")
					config.antag_hud_allowed = 1
				if("antag_hud_restricted")
					config.antag_hud_restricted = 1

				if("tickcomp")
					Tickcomp = 1

				if("tor_ban")
					ToRban = 1

				if("automute_on")
					automute_on = 1

				if("usealienwhitelist")
					usealienwhitelist = 1

				if("alien_player_ratio")
					limitalienplayers = 1
					alien_to_human_ratio = text2num(value)

				if("assistant_maint")
					config.assistant_maint = 1

				if("gateway_delay")
					config.gateway_delay = text2num(value)

				if("continuous_rounds")
					config.continous_rounds = 1

				if("ghost_interaction")
					config.ghost_interaction = 1

				if("disable_player_mice")
					config.disable_player_mice = 1

				if("uneducated_mice")
					config.uneducated_mice = 1

				if("comms_password")
					config.comms_password = value

				if("allow_cult_ghostwriter")
					config.cult_ghostwriter = 1

				if("req_cult_ghostwriter")
					config.cult_ghostwriter_req_cultists = value

				if("robot_delay")
					config.robot_delay = text2num(value)

				if("monkey_delay")
					config.monkey_delay = text2num(value)

				if("alien_delay")
					config.alien_delay = text2num(value)

				if("slime_delay")
					config.slime_delay = text2num(value)

				if("animal_delay")
					config.animal_delay = text2num(value)

				if("health_threshold_crit")
					config.health_threshold_crit = text2num(value)

				if("health_threshold_softcrit")
					config.health_threshold_softcrit = text2num(value)

				if("health_threshold_dead")
					config.health_threshold_dead = text2num(value)

				if("revival_pod_plants")
					config.revival_pod_plants = text2num(value)

				if("revival_cloning")
					config.revival_cloning = text2num(value)

				if("revival_brain_life")
					config.revival_brain_life = text2num(value)

				if("organ_health_multiplier")
					config.organ_health_multiplier = text2num(value) / 100

				if("organ_regeneration_multiplier")
					config.organ_regeneration_multiplier = text2num(value) / 100

				if("limbs_can_break")
					config.limbs_can_break = text2num(value)

				if("use_overmap")
					config.use_overmap = 1

				if("allow_shit")
					config.allow_shit = 1

				if("fate_locks")
					config.usefatelocks = TRUE

				else
					diary << "Unknown setting in configuration: '[name]'"

/datum/configuration/proc/loadsql(filename)  // -- TLE
	var/list/Lines = file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("address")
				sqladdress = value
			if ("port")
				sqlport = value
			if ("database")
				sqldb = value
			if ("login")
				sqllogin = value
			if ("password")
				sqlpass = value
			else
				diary << "Unknown setting in configuration: '[name]'"

/datum/configuration/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for (var/T in (typesof(/datum/game_mode) - /datum/game_mode))
		var/datum/game_mode/M = new T()
		if (M.config_tag && M.config_tag == mode_name)
			return M
		qdel(M)
	return new /datum/game_mode/quietday()

/datum/configuration/proc/get_runnable_modes()
	var/list/datum/game_mode/runnable_modes = new
	for (var/T in (typesof(/datum/game_mode) - /datum/game_mode))
		var/datum/game_mode/M = new T()
		//world << "DEBUG: [T], tag=[M.config_tag], prob=[probabilities[M.config_tag]]"
		if (!(M.config_tag in modes))
			qdel(M)
			continue
		if (probabilities[M.config_tag]<=0)
			qdel(M)
			continue
		if (M.can_start())
			runnable_modes[M] = probabilities[M.config_tag]
			//world << "DEBUG: runnable_mode\[[runnable_modes.len]\] = [M.config_tag]"
	return runnable_modes

/datum/configuration/proc/LoadChatFilter()
	in_character_filter = list()

	for(var/line in world.file2list("config/in_character_filter.txt"))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		in_character_filter += line

	if(!ic_filter_regex && in_character_filter.len)
		ic_filter_regex = regex("\\b([jointext(in_character_filter, "|")])\\b", "i")
//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:04

/datum/game_mode/var/list/borers = list()

/datum/game_mode/borer
	name = "borer"
	config_tag = "borer"
	required_players = 7
	required_players_secret = 7
	restricted_jobs = list("AI", "Cyborg")
	recommended_enemies = 1// need at least a borer and a host
	votable = 0 // temporarily disable this mode for voting
	var/attuned = 0


	var/var/list/datum/mind/first_hosts = list()
	var/var/list/assigned_hosts = list()

	var/const/prob_int_murder_target = 50 // intercept names the assassination target half the time
	var/const/prob_right_murder_target_l = 25 // lower bound on probability of naming right assassination target
	var/const/prob_right_murder_target_h = 50 // upper bound on probability of naimg the right assassination target

	var/const/prob_int_item = 50 // intercept names the theft target half the time
	var/const/prob_right_item_l = 25 // lower bound on probability of naming right theft target
	var/const/prob_right_item_h = 50 // upper bound on probability of naming the right theft target

	var/const/prob_int_sab_target = 50 // intercept names the sabotage target half the time
	var/const/prob_right_sab_target_l = 25 // lower bound on probability of naming right sabotage target
	var/const/prob_right_sab_target_h = 50 // upper bound on probability of naming right sabotage target

	var/const/prob_right_killer_l = 25 //lower bound on probability of naming the right operative
	var/const/prob_right_killer_h = 50 //upper bound on probability of naming the right operative
	var/const/prob_right_objective_l = 25 //lower bound on probability of determining the objective correctly
	var/const/prob_right_objective_h = 50 //upper bound on probability of determining the objective correctly

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)


/datum/game_mode/borer/announce()
	world << "<B>The current game mode is - Borer!</B>"
	world << "<B>An unknown creature has infested the mind of a crew member. Find and destroy it by any means necessary.</B>"

/datum/game_mode/borer/can_start()
	if(!..())
		return 0

	// for every 10 players, get 1 borer, and for each borer, get a host
	// also make sure that there's at least one borer and one host
	recommended_enemies = max(src.num_players() / 20 * 2, 2)

	var/list/datum/mind/possible_borers = get_players_for_role(BE_ALIEN)

	if(possible_borers.len < 2)
		log_admin("MODE FAILURE: BORER. NOT ENOUGH borer CANDIDATES.")
		return 0 // not enough candidates for borer

	// for each 2 possible borers, add one borer and one host
	if(possible_borers.len >= 2)
		var/datum/mind/borer = pick(possible_borers)
		possible_borers.Remove(borer)

		var/datum/mind/first_host = pick(possible_borers)
		possible_borers.Remove(first_host)

		modePlayer += borer
		modePlayer += first_host
		borers += borer
		first_hosts += first_host



		// so that we can later know which host belongs to which borer
		assigned_hosts[borer.key] = first_host

		borer.assigned_role = "MODE" //So they aren't chosen for other jobs.
		borer.special_role = "borer"

	return 1

/datum/game_mode/borer/pre_setup()
	return 1


/datum/game_mode/borer/post_setup()
	// create a borer and enter it
	for(var/datum/mind/borer in borers)
		var/mob/living/simple_animal/borer/M = new
		var/mob/original = borer.current
		borer.transfer_to(M)
		M.clearHUD()


		// get the host for this borer
		var/datum/mind/first_host = assigned_hosts[borer.key]
		// this is a redundant check, but I don't think the above works..
		// if picking hosts works with this method, remove the method above
		if(!first_host)
			first_host = pick(first_hosts)
			first_hosts.Remove(first_host)
		M.enter_host(first_host.current)
		forge_borer_objectives(borer, first_host)

		ticker.mode.borers |= first_host    // make host antag
		first_host.special_role = "Borer Thrall"


		del original

	log_admin("Created [borers.len] borers.")

	spawn (rand(waittime_l, waittime_h))
		send_intercept()
	..()
	return


/datum/game_mode/proc/forge_borer_objectives(var/datum/mind/borer, var/datum/mind/first_host)

	// generate some random objectives, use standard traitor objectives
	switch(rand(1,66))
		if(1 to 45)
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = borer
			kill_objective.find_target()
			borer.objectives += kill_objective
		if(45 to 50)
			var/datum/objective/brig/brig_objective = new
			brig_objective.owner = borer
			brig_objective.find_target()
			borer.objectives += brig_objective
		if(51 to 66)
			var/datum/objective/harm/harm_objective = new
			harm_objective.owner = borer
			harm_objective.find_target()
			borer.objectives += harm_objective

/*	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = borer
	steal_objective.find_target()
	borer.objectives += steal_objective*/

	switch(rand(1,100))
		if(1 to 100)
			if (!(locate(/datum/objective/escape) in borer.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = borer
				borer.objectives += escape_objective
		else
			if (!(locate(/datum/objective/hijack) in borer.objectives))
				var/datum/objective/hijack/hijack_objective = new
				hijack_objective.owner = borer
				borer.objectives += hijack_objective

	greet_borer(borer)

	return

/datum/game_mode/proc/greet_borer(var/datum/mind/borer, var/you_are=1)
	if (you_are)
		borer.current << "<B>\red You are a borer!</B>"

	var/obj_count = 1
	for(var/datum/objective/objective in borer.objectives)
		borer.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return
/*
/datum/game_mode/borer/check_finished()
	var/borers_alive = 0
	for(var/datum/mind/borer in borers)
		if(!istype(borer.current,/mob/living))
			continue
		if(borer.current.stat==2)
			continue
		borers_alive++

	if (borers_alive)
		return ..()
	else
		return 1*/

/datum/game_mode/proc/auto_declare_completion_borer()
	for(var/datum/mind/borer in borers)
		var/borerwin = 1

		if((borer.current) && (istype(borer.current,/mob/living/simple_animal/borer) || istype(borer.current,/mob/living/captive_brain)))
			world << "<B>The borer was [borer.key].</B>"
			if(borer.current:last_host)
				world << "<B>The last host was [borer.current:last_host].</B>"

			var/count = 1
			for(var/datum/objective/objective in borer.objectives)
				if(objective.check_completion())
					world << "<B>Objective #[count]</B>: [objective.explanation_text] \green <B>Success</B>"
				else
					world << "<B>Objective #[count]</B>: [objective.explanation_text] \red Failed"
					borerwin = 0
				count++

		else
			borerwin = 0

		if(borerwin)
			world << "<B>The borer was successful!<B>"
		else
			world << "<B>The borer has failed!<B>"
	return 1

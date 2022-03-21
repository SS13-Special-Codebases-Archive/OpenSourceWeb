var/list/WarAirlocks = list()

/datum/game_mode/miniwar
	name = "Mini War"
	config_tag = "miniwar"
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10
	var/max_count = 30
	var/south_count = 0
	var/north_count = 0
	var/count_restriction = 2
	var/round_start
	var/time_to_end = 30 MINUTES
	var/list/south_team = list()
	var/list/north_team = list()
	var/result

/datum/game_mode/miniwar/announce()
	world << "<B>Prepare to war!</B>"
	job_master.ResetOccupations()
	return

/datum/game_mode/miniwar/pre_setup()
	return 1

/datum/game_mode/miniwar/post_setup()
	round_start = world.time
	job_master.AddOccupations("Mini War")
	global.login_music = 'sound/lfwbambi/invasion.ogg'
	for(var/mob/new_player/player in player_list)
		if(player.client)
			player.client << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
			player.client.playtitlemusic()

/datum/game_mode/miniwar/can_start()
	return 1

/datum/game_mode/miniwar/process()
	if(world.time >= round_start + 30 SECONDS)
		for(var/obj/machinery/door/airlock/A in WarAirlocks)
			spawn(1)
				if(A.locked)
					A.locked = 0
					playsound(A.loc, 'sound/airlock_boltswitch.ogg', 100, 1)
					A.update_icon()
					return
	else if(world.time >= round_start + time_to_end)
		if(south_count > north_count)
			result = SOUTH_VICTORY
			roundendready = TRUE

		else if(north_count > south_count)
			result = NORTH_VICTORY
			roundendready = TRUE

/mob/living/carbon/human/proc/update_all_miniwar_icons()
	if(ticker.mode.config_tag == "miniwar")
		var/datum/game_mode/miniwar/M = ticker.mode
		var/my_I
		var/I
		if(src in M.south_team)
			my_I = image('icons/mob/mob.dmi', loc = src, icon_state = "south_team")
			for(var/mob/living/carbon/human/HH in M.south_team)
				I = image('icons/mob/mob.dmi', loc = HH, icon_state = "south_team")
				src?.client?.images += I
				HH?.client?.images += my_I
		else
			my_I = image('icons/mob/mob.dmi', loc = src, icon_state = "north_team")
			for(var/mob/living/carbon/human/HH in M.north_team)
				I = image('icons/mob/mob.dmi', loc = HH, icon_state = "north_team")
				src?.client?.images += I
				HH?.client?.images += my_I

/datum/game_mode/miniwar/declare_completion()
	..()
	switch(result)
		if(SOUTH_VICTORY)
			to_chat(world, "<h2><B>Northners has been defeated! Southners are glorious tonight!</B></h2>")
		if(NORTH_VICTORY)
			to_chat(world, "<h2><B>Southners has been defeated! Northners are glorious tonight!</B></h2>")

	to_chat(world, "Northners Losses: [north_count]/[max_count]")
	to_chat(world, "Southners Losses: [south_count]/[max_count]")
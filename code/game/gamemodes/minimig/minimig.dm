/datum/game_mode/minimig
	name = "Mini Mig"
	config_tag = "minimig"
	required_players = 0
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

	var/const/waittime_l = 1800 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 3000

/datum/game_mode/minimig/announce()
	world << "<B>Our fate is a peaceful one.</B>"
	job_master.ResetOccupations()
	return
/datum/game_mode/minimig/pre_setup()
	return 1

var/minimig_grace = TRUE
var/minimig_bandit = FALSE
/datum/game_mode/minimig/post_setup()
	job_master.ResetOccupations()
	world << 'allmigration_start.ogg'
	spawn (rand(waittime_l, waittime_h))
		to_chat(world, "<br>")
		to_chat(world, "<span class='ravenheartfortress'>Mini-Migration</span>")
		to_chat(world, "<span class='excomm'>⠀¤The grace period has ended!¤</span>")
		world << sound('sound/effects/crisis.ogg')
		to_chat(world, "<br>")
		minimig_grace = FALSE
		for(var/obj/effect/blockedminimig/BLOCKED in minimiglist)
			minimiglist -= BLOCKED
			BLOCKED.density = FALSE
			qdel(BLOCKED)
		spawn(rand(12000, 16800))
			to_chat(world, "<br>")
			to_chat(world, "<span class='ravenheartfortress'>Mini-Migration</span>")
			to_chat(world, "<span class='excomm'>⠀¤The plague has reached the river!¤</span>")
			world << sound('sound/effects/crisis.ogg')
			to_chat(world, "<br>")
			for(var/turf/simulated/floor/exoplanet/water/shallow/S in world)
				S.safewater = FALSE
			spawn (rand(waittime_l, waittime_h))
				to_chat(world, "<br>")
				to_chat(world, "<span class='ravenheartfortress'>Mini-Migration</span>")
				to_chat(world, "<span class='excomm'>⠀¤Outlaws are coming!¤</span>")
				world << sound('sound/effects/crisis2.ogg')
				to_chat(world, "<br>")
				minimig_bandit = TRUE
				spawn (6000)
					to_chat(world, "<br>")
					to_chat(world, "<span class='ravenheartfortress'>Mini-Migration</span>")
					to_chat(world, "<span class='excomm'>⠀¤15 minutes until the end!¤</span>")
					world << sound('sound/effects/crisis.ogg')
					to_chat(world, "<br>")
					spawn (9000)
						to_chat(world, "<br>")
						to_chat(world, "<span class='ravenheartfortress'>Mini-Migration</span>")
						to_chat(world, "<span class='excomm'>⠀¤This is the end, 1 minute left!¤</span>")
						world << sound('sound/effects/crisis.ogg')
						to_chat(world, "<br>")
						spawn(600)
							roundendready = TRUE
							ticker.mode.check_win()
							world << 'allmigration_end.ogg'
							/* Temp Chromie farm prevention
							for(var/client/C in clients)
								C.ChromieWinorLoose(C, 1)
							*/
							for(var/mob/living/M in player_list)
								if(M.stat != DEAD)
									M.client.ChromieWinorLoose(M.client, 1)
	..()
/*
/datum/game_mode/quietday/can_start()
	for(var/mob/new_player/player in mob_list)
		if(player.ready && player.client.work_chosen == "Baron")
			return 1
		else
			return 0
	return 0
*/
/datum/game_mode/minimig/can_start()
	return 1
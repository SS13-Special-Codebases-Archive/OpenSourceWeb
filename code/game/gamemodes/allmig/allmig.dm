/datum/game_mode/allmig
	name = "All Migration"
	config_tag = "allmig"
	required_players = 20
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800

/datum/game_mode/allmig/announce()
	world << "<B>All migration!</B>"
	world << 'allmigration_start.ogg'

/datum/game_mode/allmig/pre_setup()
	return 1

/datum/game_mode/allmig/post_setup()
	..()


/datum/game_mode/allmig/can_start()
	var/playerC = 0
	for(var/mob/new_player/player in player_list)
		if((player.client)&&(player.ready))
			playerC++

	if(master_mode=="secret")
		if(playerC >= required_players_secret)
			return 1
	else
		if(playerC >= required_players)
			return 1
	return 0

/datum/game_mode/extended
	name = "Extended"
	config_tag = "extended"
	required_players = 0
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800

/datum/game_mode/announce()
	world << "<B>Our fate is peaceful.</B>"

/datum/game_mode/extended/pre_setup()
	return 1

/datum/game_mode/extended/post_setup()
	..()

/datum/game_mode/extended/can_start()
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


/datum/game_mode/extended/declare_completion()
	..()
	if(!has_starring)
		var/mob/living/carbon/human/H
		H = pick(player_list)
		to_chat(world, "<span class='bname'>Starring: [H.real_name]</span>")
		to_chat(world, "<span class='bname'>Objective #1:</span> Prevent tragedy from happening in Firethorn. <font color='green'>Success!</font>")
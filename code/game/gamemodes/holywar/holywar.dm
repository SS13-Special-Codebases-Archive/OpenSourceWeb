/datum/game_mode/holywar
	name = "Holy War"
	config_tag = "holywar"
	required_players = 20
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10
	var/warcasualties = 0
	var/veterans = 0
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800

/datum/game_mode/holywar/announce()
	to_chat(world, "<h2>Holy War!</h2>")
	world << 'siege_declared.ogg'

/datum/game_mode/holywar/pre_setup()
	return 1

/datum/game_mode/holywar/post_setup()
	..()


/datum/game_mode/holywar/can_start()
	var/playerC = 0
	for(var/mob/new_player/player in player_list)
		if(player.client)
			playerC++

	if(master_mode=="secret")
		if(playerC >= required_players_secret)
			return 1
	else
		if(playerC >= required_players)
			return 1
	return 0

/mob/living/carbon/human/var/list/updateteamlist = list()

/mob/living/carbon/human/proc/update_all_team_icons()
	if(src.religion == "Thanati")
		for(var/mob/living/carbon/human/HH in player_list)
			if(HH.religion == "Thanati" && !src.updateteamlist.Find(HH))
				if(src.client && !src.updateteamlist.Find(HH))
					var/I = image('icons/mob/mob.dmi', loc = HH, icon_state = "thanati")
					src.client.images += I
					src.updateteamlist.Add(HH)
	else
		for(var/mob/living/carbon/human/HH in player_list)
			if(HH.religion == "Gray Church" && !src.updateteamlist.Find(HH))
				if(src.client && !src.updateteamlist.Find(HH))
					var/I = image('icons/mob/mob.dmi', loc = HH, icon_state = "crusade")
					src.client.images += I
					src.updateteamlist.Add(HH)


/datum/game_mode/holywar/declare_completion()
	to_chat(world, "\n<span class='ricagames'>[vessel_name()] : Holy War</span>")
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.stat == DEAD)
			warcasualties++
		if(H.stat != DEAD)
			veterans++
	to_chat(world, "<span class='baron'>War Veterans: [veterans]</span>")
	to_chat(world, "<span class='baron'>Casualties: [warcasualties]</span>")
	to_chat(world, "<span class='baron'>Thanati Casualties: [th_casualties]</span>")
	to_chat(world, "<span class='baron'>P.C Casualties: [pc_casualties]</span>")
	to_chat(world, "<span class='baron'>Teeth lost: [dentesperdidos]</span>")
	to_chat(world, "<span class='baron'>First victim:</span> <span class='highlighttext'>[firstvictim]</span> <span class='baron'>Last Words:</span> <span class='highlighttext'>\"[firstvictimlastword]\"</span>")
	return 1
/datum/game_mode
	// this includes admin-appointed traitors and multitraitors. Easy!
	var/list/datum/mind/xenos = list()

/datum/game_mode/xenomorph
	name = "The Outsiders"
	config_tag = "alien"
	restricted_jobs = list("Cyborg")//They are part of the AI if he is traitor so are they, they use to get double chances
	required_players = 1
	required_enemies = 1
	recommended_enemies = 1

/datum/game_mode/proc/greet_xeno(var/datum/mind/xenos)
	to_chat(xenos.current,"<span class='dreamershitfuckcomicao1'>A few nights ago, a monster landed on my face.</span>")
	to_chat(xenos.current,"<span class='dreamershitfuckcomicao1'>And it impregnated me with something.</span>")
	to_chat(xenos.current,"<span class='dreamershitfuckcomicao1'>Voices #1: Find a safe hiding spot for your flowering.</span>")

	new /obj/item/alien_embryo(xenos.current)
	xenos.current.status_flags |= XENO_HOST
	return

/datum/game_mode/xenomorph/pre_setup()
	var/list/possible_xenos = get_players_for_role(BE_TRAITOR)
	var/max_xenos = 2

	for(var/j = 0, j < max_xenos, j++)
		if (!possible_xenos.len)
			break
		var/datum/mind/xeno_mind = pick(possible_xenos)
		xenos += xeno_mind
		possible_xenos.Remove(xenos)
	return 1


/datum/game_mode/xenomorph/post_setup()
	for(var/datum/mind/xeno_mind in xenos)
		spawn(rand(10,100))
			greet_xeno(xeno_mind)

	modePlayer += xenos
	return 1
/*
/datum/game_mode/quietday/can_start()
	for(var/mob/new_player/player in mob_list)
		if(player.ready && player.client.work_chosen == "Baron")
			return 1
		else
			return 0
	return 0
*/
/datum/game_mode/xenomorph/can_start()
	for(var/mob/new_player/player in player_list)
		for(var/mob/new_player/player2 in player_list)
			for(var/mob/new_player/player3 in player_list)
				if(player.ready && player.client.work_chosen == "Baron" && player2.ready && player2.client.work_chosen == "Inquisitor"&& player3.ready && player3.client.work_chosen == "Bookkeeper")
					return 1
	return 0

/datum/game_mode/xenomorph/declare_completion()
	..()
	var/number = 0
	var/isOnLeviathan = 0
	for(var/mob/living/carbon/human/H in mob_list)
		if(istype(H?.species, /datum/species/human/alien))
			number++
			if(H.z == 7)
				isOnLeviathan = 1
	if(number >= 6 && isOnLeviathan)
		to_chat(world, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The Outsiders managed to complete their objectives.</span>")
		for(var/mob/living/carbon/human/H in player_list)
			if(istype(H?.species, /datum/species/human/alien))
				H.client.ChromieWinorLoose(H.client, 2)
	else
		if(number >= 6 || isOnLeviathan)
			to_chat(world, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The Outsiders only managed to complete half of their objectives.</span>")
		else if(!number >= 6 && !isOnLeviathan)
			to_chat(world, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The Outsiders were a complete failure.</span>")
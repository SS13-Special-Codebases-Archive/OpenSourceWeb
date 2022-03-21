/datum/game_mode
	// this includes admin-appointed traitors and multitraitors. Easy!
	var/list/datum/mind/dreamer = list()

/datum/game_mode/dreamer
	name = "The Dreamer"
	config_tag = "dreamer"
	restricted_jobs = list("Cyborg")//They are part of the AI if he is traitor so are they, they use to get double chances
	required_players = 1
	required_enemies = 1
	recommended_enemies = 1

/datum/game_mode/dreamer/can_start()
	for(var/mob/new_player/player in player_list)
		for(var/mob/new_player/player2 in player_list)
			for(var/mob/new_player/player3 in player_list)
				if(player.ready && player.client.work_chosen == "Baron" && player2.ready && player2.client.work_chosen == "Inquisitor"&& player3.ready && player3.client.work_chosen == "Bookkeeper")
					return 1
	return 0
/datum/game_mode/proc/greet_dreamer(var/datum/mind/dreamer)
	//ticker.mode.learn_basic_spells(current)
	to_chat(dreamer.current,"<span class='dreamershitfuckcomicao1'>Another NIGHT here. This labyrinthine fortress TWISTS and DISTORTS, something shimmers under the CRACKS. I know in my VISIONS, something GREATER lies beyond this LIFE.</span>")
	to_chat(dreamer.current,"<span class='dreamershitfuckcomicao1'>I shall CUT my BONDS, only beneath the skin does the TRUTH lay.</span>")
	to_chat(dreamer.current,"<span class='dreamershitfuckcomicao1'>Dream #1: FOLLOWING my HEART shall be the WHOLE of the law.</span>")
	return
/datum/game_mode/proc/finalize_dreamer(var/datum/mind/dreamer)
	dreamer.special_role = "Waker"
	var/datum/antagonist/dreamer/M = new()
	dreamer.antag_datums = M
	var/mob/living/carbon/human/H = dreamer.current
	H.combat_music = 'sound/lfwbsounds/bloodlust1.ogg'
	H.my_skills.CHANGE_SKILL(SKILL_MELEE, 17)
	H.my_skills.CHANGE_SKILL(SKILL_RANGE, 13)
	H.my_skills.CHANGE_SKILL(SKILL_CRAFT, 15)
	H.vice = "Graphomaniac"
	H.my_stats.st = rand(20,25)
	H.my_stats.dx += rand(5,5)
	H.my_stats.ht = rand(20,25)
	H.verbs += /mob/living/carbon/human/proc/dreamer
	H.updatePig()
	H.consyte = 0
	H.status_flags |= STATUS_NO_PAIN
	starringlist += "[H.key] "
	if(H.religion == "Thanati")
		if(prob(80))
			H.religion = "Gray Church"

/datum/game_mode/dreamer/pre_setup()
	var/list/possible_dreamers = get_players_for_role(BE_TRAITOR)
	var/max_dreamer = 1

	for(var/j = 0, j < max_dreamer, j++)
		if (!possible_dreamers.len)
			break
		var/datum/mind/dreamer_mind = pick(possible_dreamers)
		dreamer += dreamer_mind
		possible_dreamers.Remove(dreamer)
	return 1


/datum/game_mode/dreamer/post_setup()
	for(var/datum/mind/dreamer_mind in dreamer)
		spawn(rand(10,100))
			finalize_dreamer(dreamer_mind)
			greet_dreamer(dreamer_mind)

	modePlayer += dreamer
	return 1

/datum/game_mode/dreamer/declare_completion()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.mind.special_role == "Waker" && H.mind.farwebcompletionantagonist)
			to_chat(world, "<span class='dreamershitfuckcomicao1'>Starring: [starringlist]</span>")
			to_chat(world, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The Dreamer has awakened!</span>")
			H.unlock_medal("Finally Awake", 0, "As the Dreamer, followed their heart to the whole of the law.", "23")
		else if(H.mind.special_role == "Waker" && !H.mind.farwebcompletionantagonist)
			to_chat(world, "<span class='dreamershitfuckcomicao1'>Starring: [starringlist]</span>")
			to_chat(world, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The Dreamer is still imprisioned in his own labyrinth.</span>")
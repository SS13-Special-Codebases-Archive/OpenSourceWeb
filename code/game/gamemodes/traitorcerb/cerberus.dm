/datum/game_mode
	// this includes admin-appointed traitors and multitraitors. Easy!
	var/list/datum/mind/traitcerb = list()

/datum/game_mode/traitcerb
	name = "Traitor Tiamat"
	config_tag = "traitcerb"
	restricted_jobs = list("Cyborg")//They are part of the AI if he is traitor so are they, they use to get double chances
	required_players = 1
	required_enemies = 1
	recommended_enemies = 1

/datum/game_mode/traitcerb/announce()
	spawn(400)
		to_chat(world, "<span class='baronboldoutlined'>Um dos tiamatii é O TRAIDOR.</span> <span class='baron'>Rumores sobre isso perturbam a Fortaleza há semanas, mas a identidade do vilão ainda é desconhecida.</span>")

/datum/game_mode/traitcerb/can_start()
	for(var/mob/new_player/player in player_list)
		for(var/mob/new_player/player2 in player_list)
			if(player.ready && player.client.work_chosen == "Baron" && player2.ready && player2.client.work_chosen == "Inquisitor")
				return 1
	return 0

/datum/game_mode/proc/greet_cerb(var/datum/mind/traitorcerb)
	//ticker.mode.learn_basic_spells(current)
	to_chat(traitorcerb.current, "<span class='baronboldoutlined'>Você é um Tiamat traidor. </span><span class='baron'>Seu salário é patético, suas tarefas são suicidas, e os Thanati lhe ofereceram o dinheiro suficiente para comprar uma dúzia de fortalezas.</span>")
	to_chat(traitorcerb.current, "<span class='baronboldoutlined'>OBJETIVO: </span><span class='baron'>Assasinar o Barão e conseguir sobreviver com o seu anel.</span>")

/datum/game_mode/proc/finalize_cerb(var/datum/mind/traitorcerb)
	traitorcerb.special_role = "traitcerb"
	var/mob/living/carbon/human/H = traitorcerb.current
	H.combat_music = 'sound/lfwbsounds/bloodlust1.ogg'

/datum/game_mode/traitcerb/pre_setup()
	var/list/possible_traitcerb = get_players_for_role(BE_TRAITOR)
	var/max_traitcerb = 1

	for(var/datum/mind/player in possible_traitcerb)
		if(player.assigned_role != "Cerberus")
			possible_traitcerb -= player
	for(var/j = 0, j < max_traitcerb, j++)
		if (!possible_traitcerb.len)
			break
		var/datum/mind/traitorcerb_mind = pick(possible_traitcerb)
		traitcerb += traitorcerb_mind
		possible_traitcerb.Remove(traitcerb)
	return 1



/datum/game_mode/traitcerb/post_setup()
	for(var/datum/mind/traitorcerberus in traitcerb)
		spawn(rand(10,100))
			finalize_cerb(traitorcerberus)
			greet_cerb(traitorcerberus)

	modePlayer += dreamer
	return 1

/datum/game_mode/dreamer/declare_completion()
	to_chat(world, "\n<span class='ricagames'>[vessel_name()] (Story #1)</span>")
	to_chat(world, "\n<span class='dreamershitbutitsbigasfuckanditsboldtoo'>			     O Traidor</span>\n\n\n")
	var/amountswon = 0
	var/mob/living/carbon/human/cerberustraedo = null
	for(var/mob/living/carbon/human/H in world)
		if(H.job == "Baron" && H.stat == DEAD)
			amountswon++
		if(H.job == "Tiamat" && H.stat == 0 && H.mind.special_role == "traitcerb")
			cerberustraedo = H
			var/list/all_items = H.get_contents()
			for(var/obj/item/I in all_items)
				if(istype(I, /obj/item/weapon/card/id/lord))
					amountswon++

	if(amountswon >= 0)
		to_chat(world, "<span class='dreamershitfuckcomicao1'>Estrelando: [capitalize(pick(cerberustraedo.ckey))]</span>")
		cerberustraedo.client.ChromieWinorLoose(cerberustraedo.client, -5)

	if(amountswon >= 2)
		to_chat(world, "<span class='dreamershitfuckcomicao1'>Estrelando: [capitalize(pick(cerberustraedo.ckey))]</span>")
		to_chat(world, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>O Tiamat Traidor foi bem sucedido!</span>")
		traitcerb.farwebcompletionantagonist = 1

	if(traitcerb.farwebcompletionantagonist)
		cerberustraedo.client.ChromieWinorLoose(cerberustraedo.client, 6)
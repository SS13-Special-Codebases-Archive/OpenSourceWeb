/datum/game_mode
	var/list/datum/mind/succubi = list()

/datum/game_mode/succubus
	name = "The Succubus"
	config_tag = "succubus"
	required_players = 0
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10
	has_starring = TRUE

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800

/datum/game_mode/succubus/announce()
	world << "<B>Our fate is a peaceful one.</B>"
	return

/datum/game_mode/succubus/post_setup()
	var/list/candidatelist = list()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.client && H.gender == FEMALE && H.species.name != "Child" && !H.outsider && !H.has_penis())
			candidatelist.Add(H)
	candidatelist = shuffle(candidatelist)
	var/mob/living/carbon/human/SUC
	var/mob/living/carbon/human/SUC1
	if(candidatelist.len)
		SUC = pick(candidatelist)
	candidatelist -= SUC
	if(candidatelist.len)
		SUC1 = pick(candidatelist)
	if(SUC)
		grant_succubi_powers(SUC)
		SUC.mind.special_role = "Succubus"
		succubi.Add(SUC.mind)
		forge_succubi_objective(SUC.mind)
	if(SUC1)
		grant_succubi_powers(SUC1)
		SUC1.mind.special_role = "Succubus"
		succubi.Add(SUC1.mind)
		forge_succubi_objective(SUC1.mind)
	..()

/datum/game_mode/proc/grant_succubi_powers(mob/living/carbon/succubi_mob)
	if(!istype(succubi_mob))	return
	succubi_mob.make_succubi()

/mob/proc/make_succubi()
	if(!mind)				return
	if(!mind.succubus)	mind.succubus = new /datum/succubus()
	verbs += /mob/living/carbon/human/proc/teleportSlaves
	verbs += /mob/living/carbon/human/proc/killSlave
	verbs += /mob/living/carbon/human/proc/punishSlave
	var/mob/living/carbon/human/H = src
	if(ishuman(src))
		H.my_skills.CHANGE_SKILL(SKILL_PARTY, 17)
		H.add_perk(/datum/perk/morestamina)
		H.add_perk(/datum/perk/ref/slippery)
		H.add_perk(/datum/perk/sexaddict)
	to_chat(src, "<h4><br><span class='bname'><font color='pink'>You're a succubus.</font></span></h4>")
	to_chat(src, "You're able to enslave men through your bedroom tricks and corrupt their souls with the pleasures of the flesh.<br>")
	to_chat(src, "<i>Your lips are enough to drive a man crazy, kiss him and he will crave you.</i><br>")

	src.mind.special_role = "Succubus"
	for(var/datum/relation/family/R in H.mind.relations)
		if(R.name == "Husband")
			if(ishuman(R.relation_holder.current))
				var/mob/living/carbon/human/lover = R.relation_holder.current
				if(lover.age >= 18)
					H.succubus_enslave(lover,TRUE)
					to_chat(H,"<h4><br><span class='bname'><font color='pink'>As a result of our wonderful relationship, my loving Husband, [lover] happens to be one my slaves.</font></span></h4>")
	return 1


/datum/game_mode/succubus/can_start()
	for(var/mob/new_player/player in player_list)
		for(var/mob/new_player/player2 in player_list)
			for(var/mob/new_player/player3 in player_list)
				if(player.ready && player.client.work_chosen == "Baron" && player2.ready && player2.client.work_chosen == "Inquisitor"&& player3.ready && player3.client.work_chosen == "Bookkeeper")
					return 1
	return 0
/datum/game_mode/proc/forge_succubi_objective(var/datum/mind/succubi_mind)
	var/datum/objective/succubus/sucubjective = new
	sucubjective.owner = succubi_mind
	succubi_mind.objectives |= sucubjective
	var/datum/objective/succubusTwo/sucubjective2 = new
	sucubjective2.owner = succubi_mind
	succubi_mind.objectives |= sucubjective2
	var/datum/objective/survive/survival = new
	survival.owner = succubi_mind
	succubi_mind.objectives += survival
	var/obj_count = 1
	for(var/datum/objective/objective in succubi_mind.objectives)
		to_chat(succubi_mind.current, "<B>WISH #[obj_count]</B>: [objective.explanation_text]")
		obj_count++


/datum/game_mode/succubus/declare_completion()
	..()
	var/datum/mind/SUC = pick(succubi)
	succubi -= SUC
	var/datum/mind/SUC2 = pick(succubi)
	succubi -= SUC2

	var/list/succers = list()
	succers.Add(SUC.current)
	succers.Add(SUC2.current)

	var/succwin = 1
	var/text = ""

	for(var/mob/living/H in succers)
		succwin = 1
		text += "<span class='bname'>Starring: [H.real_name] ([H.key])</span>"
		if(H.mind.objectives.len)
			var/count = 1
			for(var/datum/objective/objective in H.mind.objectives)
				if(objective.check_completion())
					text += "<br><span class='bname'>Objective #[count]</span>: [objective.explanation_text] <font color='green'><B>Success</B></font>"
				else
					text += "<br><span class='bname'>Objective #[count]</span>: [objective.explanation_text] <font color='red'>Failure</font>"
					succwin = 0
				count++
		if(succwin)
			text += "<h3><span class='passive'>[H.real_name] The Succubus has achieved her goals! The sinners will serve their Mistress for eternity!</span></h3>"
		else
			text += "<h3><span class='combat'>Morality Victory! The Succubus has failed at corrupting the fortress!</span></h3>"
	to_chat(player_list, text)


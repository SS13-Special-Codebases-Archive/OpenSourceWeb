var/list/datum/succubus/succubi = list()

/datum/succubus //stores changeling powers, changeling recharge thingie, changeling absorbed DNA and changeling ID (for changeling hivemind)
	var/list/succubusSlaves = list()
	var/skillCooldown = FALSE
	var/list/datum/mind/punished_slaves = list()

/datum/succubus/New()
	..()
	succubi.Add(src)

mob/proc/succubus_mood(var/mob/living/carbon/human/target)
	var/datum/happiness_event/misc/needsex/E = new()
	E.description = "<span class='badmood'>• I NEED TO FUCK [uppertext(src.real_name)]!</span>\n"
	target.add_precreated_event("[src.real_name]", E)

mob/proc/succubus_enslave(var/mob/living/carbon/human/target, var/silent = FALSE)
	if(!src?.mind?.succubus)
		return
	if(target.stat == DEAD) //shouldn't happen
		return
	if(target?.mind?.succubus)//shouldn't happen
		if(!silent)
			to_chat(src, "<span class='erpbold'>FUCK!</span><span class='erp' They're one of us!</span>")
		return
	for(var/datum/succubus/S in (succubi - src.mind.succubus))
		if(S.succubusSlaves.Find(target))
			if(!silent)
				to_chat(src, "<span class='combatbold'>FUCK!</span><span class='combat'> They already have a master!</span>")
			return
	if(!src.mind.succubus.succubusSlaves.Find(target) && target.client)
		src.mind.succubus.succubusSlaves.Add(target)
		to_chat(src, "<h4><span class='bname'>[target.real_name] is now your slave.</h4>")
		to_chat(target, "<h4>You're now <span class='bname'>[src.real_name]</span>'s slave</h4>")
		to_chat(target, "you must loyaly serve them.")
		return

/mob/living/carbon/human/proc/teleportSlaves()
	set hidden = 0
	set name = "teleportSlaves"
	if(src?.mind?.succubus?.skillCooldown)
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] It's not ready yet!</span>")
		return
	to_chat(src, "<span class='jogtowalk'>[pick("You teleport your slaves near yourself.","You bring your slaves to you.","You bring your slaves near you.")]</span>")
	src?.mind?.succubus?.skillCooldown = TRUE
	for(var/mob/living/carbon/human/M in src?.mind?.succubus.succubusSlaves)
		M.forceMove(src.loc)
	playsound(src.loc, 'sound/effects/witch_teleport.ogg', 100, 1)
	spawn(50)
		src?.mind?.succubus?.skillCooldown = FALSE

/mob/living/carbon/human/proc/killSlave()
	set hidden = 0
	set name = "killSlave"
	if(src.stat)
		return
	if(src?.mind?.succubus?.skillCooldown)
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] It's not ready yet!</span>")
		return
	var/mob/living/carbon/human/selection = input("Kill someone!", "SLAVE LIST", null, null) as null|anything in src.mind.succubus.succubusSlaves
	if(!selection)
		to_chat(src, "<span class='jogtowalk'>[pick("You change your mind.","Maybe Later.","They will get to live another night.")]</span>")
		return
	to_chat(src, "<span class='jogtowalk'>[pick("You sentence this slave to death.","You execute this slave.","You stop his heart.")]</span>")
	src?.mind?.succubus?.skillCooldown = TRUE
	selection.emote("cough")
	to_chat(selection, "<h2><span class='bname'>You have been [pick("sentenced to death","executed","punished")] by your mistress!</span></h2>")
	var/datum/organ/internal/heart/HE = locate() in selection.internal_organs
	HE.heart_attack()
	playsound(src.loc, 'sound/effects/witch_teleport.ogg', 100, 1)
	log_game("[src.real_name]/[src.key] Succubus killed: [selection.real_name]")
	spawn(100)
		src?.mind?.succubus?.skillCooldown = FALSE

/mob/living/carbon/human/proc/punishSlave()
	set hidden = 0
	set name = "punishSlave"
	var/mob/living/carbon/human/selection = input("PUNISH someone!", "SLAVE LIST", null, null) as null|anything in src.mind.succubus.succubusSlaves
	if(!selection)
		to_chat(src, "<span class='jogtowalk'>[pick("You change your mind.","Maybe Later.","They will get to keep their dignity for another night.")]</span>")
		return
	if(selection.mind in src.mind.succubus.punished_slaves)
		to_chat(src, "<span class='jogtowalk'>[selection.real_name] has already felt the sting of punishment tonight. Perhaps I should kill them instead.</span>")
		return
	to_chat(src, "<span class='jogtowalk'>You remind [selection.real_name] of their place.</span>")
	src.mind.succubus.punished_slaves |= selection.mind
	selection.emote("agonydeath")
	selection.CU()
	selection.client.ChromieWinorLoose(selection,-5)
	log_game("[src.real_name]/[src.key] Succubus punished: [selection.real_name]")
	to_chat(selection, "<h2><span class='bname'>You have been <span class='excomm'PUNISHED</span> by your mistress!</span></h2>")
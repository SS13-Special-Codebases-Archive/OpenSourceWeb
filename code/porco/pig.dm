/client/
	var/scrollbarready = 0

/client/proc/loadDataPig()
	var/datum/asset/stuff = get_asset_datum(/datum/asset/pig)
	stuff.register()
	stuff.send(src)

/client/verb/ready()
	set hidden = 1
	set name = "doneRsc"

	pigReady = 1

/client/verb/unready()
	set hidden = 1
	set name = "notdoneRsc"

	pigReady = 0

/mob/new_player/proc/updateTimeToStart()
	if(!client)
		return
	if(!client.pigReady)
		return
	client << output(list2params(list("#timestart", "[ticker?.pregame_timeleft]")), "outputwindow.browser:change")

/mob/new_player/Login()
	..()
	spawn while(client)
		sleep(35)
		updateTimeToStart()
		updatePig()

/mob/new_player/Life()
	..()
	updateTimeToStart()
	updatePig()

/mob/living/carbon/human/proc/updateSpider()
	if(!client)
		return

	var/list/text = list()
	var/fulltext = ""

	if(reflectneed >= 750)
		text += "<a href='#' id='ReflectExperience'>Reflect your Experience!<br></a>"
	if(src?.mind?.succubus)
		text += "<a href='#' id='teleportSlaves'>Teleport Slaves<br></a><a href='#' id='punishSlave'>Punish Slave<br></a> <a href='#' id='killSlave'>Kill Slave<br></a>"
	if(src.verbs.Find(/mob/living/carbon/human/proc/plantEgg))
		text += "<a href='#' id='plantEgg'>Lay Egg<br></a>"
	if(src.verbs.Find(/mob/living/carbon/human/proc/plantWeeds))
		text += "<a href='#' id='plantWeeds'>Plant Weeds<br></a>"
	switch(job)
		if("Bishop")
			text += "<a href='#'' id='Excommunicate'>Excommunicate<br></a><a href='#'' id='BannishtheUndead'>Banish Undead</a><a href='#'' id='RobofSins'><br>Rob of Sins<br></a><a href='#' id='Epitemia''>Epitemia<br></a><a href='#'' id='RewardtheInquisitor'>Reward the Inquisitor</a><a href='#'' id='Coronation'><br>Coronation</a><a href='#'' id='Eucharisty'><br>Eucharisty<br></a><a href='#'' id='BannishSpirits'>Banish Spirits<br></a><a href='#'' id='CallforChurchMeeting'>Call for Chuch Meeting<br></a><a href='#' id='Marriage''>Marriage!<br></a><a href='#' id='ClearName''>Clear Name<br></a>"
		if("Priest")
			text += "<a href='#'' id='Excommunicate'>Excommunicate<br></a><a href='#'' id='BannishtheUndead'>Banish Undead</a><a href='#'' id='RobofSins'><br>Rob of Sins<br></a><a href='#' id='Epitemia''>Epitemia<br></a><a href='#'' id='RewardtheInquisitor'>Reward the Inquisitor</a><a href='#'' id='Coronation'><br>Coronation</a><a href='#'' id='Eucharisty'><br>Eucharisty<br></a><a href='#'' id='BannishSpirits'>Banish Spirits<br></a><a href='#'' id='CallforChurchMeeting'>Call for Chuch Meeting<br></a><a href='#' id='Marriage''>Marriage!<br></a><a href='#' id='ClearName''>Clear Name<br></a>"
		if("Monk")
			text += "<a href='#'' id='BannishtheUndead'>Banish Undead</a><a href='#'' id='RobofSins'><br>Rob of Sins<br></a><a href='#'' id='Eucharisty'><br>Eucharisty<br></a><a href='#'' id='BannishSpirits'>Banish Spirits<br></a><a href='#' id='Marriage!''>Marriage<br></a>"
		if("Expedition Leader")
			text += "<a href='#' id='SetMigSpawn'>Set Migrant Arrival<br></a><a href='#' id='announceEx'>Announce (14 TILES)<br></a>"
		if("Bum")
			text += "<a href='#' id='tellTheTruth'>Tell the Truth<br></a>"
		if("Urchin")
			text += "<a href='#' id='tellTheTruth'>Tell the Truth<br></a>"
		if("Migrant")
			if(!migclass)
				if(ckey in outlaw)
					text += "<a href='#' id='ChoosemigrantClass'>Choose Migrant Class!<br></a><a href='#' id='ToggleOutlaw'>Toggle Outlaw!<br></a>"
				else
					text += "<a href='#' id='ChoosemigrantClass'>Choose Migrant Class!<br></a>"
		if("Count")
			text += "<a href='#' id='Reinforcement'>Change Reinforcement Type<br></a><a href='#' id='Command'>Command<br></a><a href='#' id='SpecialReinforcement'>Call for Special Reinforcement!<br></a><a href='#' id='Recruit'>Recruit<br></a><a href='#' id='CaptureThrone'>Capture Throne<br></a>"
		if("Count Hand")
			text += "<a href='#' id='Command'>Command<br></a><a href='#' id='SpecialReinforcement'>Call for Special Reinforcement!<br></a><a href='#' id='Recruit'>Recruit<br></a>"
		if("Count Heir")
			text += "<a href='#' id='SpecialReinforcement'>Call for Special Reinforcement!<br></a>"
		if("Sieger")
			if(!migclass)
				text += "<a href='#' id='ChoosesiegerClass'>Choose Sieger Class!<br></a>"
		if("Mercenary")
			if(!migclass)
				text += "<a href='#' id='PegaclasseMerc'>Choose Mercenary Class!<br></a>"
	if(src.consyte)
		text += "<a href='#' id='Choir'>Choir<br></a><a href='#' id='respark'>Respark<br></a>"
	if(src.job == "Jester")
		text += "<a href='#' id='Choir'>Choir<br></a><a href='#' id='nickname'>Give a nickname!<br></a>"
		text += "<a href='#' id='Choir'>Choir<br></a><a href='#' id='juggle'>Juggle!<br></a>"
		text += "<a href='#' id='Choir'>Choir<br></a><a href='#' id='rememberjoke'>Remember Joke!<br></a>"
		text += "<a href='#' id='Choir'>Choir<br></a><a href='#' id='joke'>Joke!<br></a>"
	if(check_perk(/datum/perk/pathfinder))
		text += "<a href='#' id='TrackSomeonePathfinder'>Track Someone<br></a><a href='#' id='TrackselfPathfinder'>Track Yourself<br></a>"

	if(check_perk(/datum/perk/singer))
		text += "<a href='#' id='RememberSong'>Remember Song<br></a><a href='#' id='Sing'>Sing<br></a>"

	for(var/T in text)
		fulltext += "[T]"


/mob/living/carbon/human/proc/updateSmalltext()
	if(!client)
		return

	var/list/text = list()
	var/fulltext = ""

	if(job == "Pusher")
		if(mind)
			text += "TIME TO PAY: <span id='timepusher'>[secondsToMintues(mind.time_to_pay)]</span>"
	if(job == "Inquisitor")
		if(mind && Inquisitor_Type == "Month's Inquisitor")
			text += "Avowals of Guilt sent: (<span id='timepusher'>[secondsToMintues(mind.avowals_of_guilt_sent)] / 6)</span>"
		text += "Inquisitorial Points: <span id='timepusher'>[Inquisitor_Points]</span>"
	if(old_ways.god)
		if(old_ways.god == "Xom")
			text += "THOU ARE XOM'S TOY"

	if(src?.mind?.succubus)
		text += "Slaves : [src.mind.succubus.succubusSlaves.len]"
	if(ticker.mode.config_tag == "siege" && siegesoldier)
		var/datum/game_mode/siege/S = ticker.mode
		text += "Losses: [S.losses]/[S.max_losses]"
	else if(ticker.mode.config_tag == "miniwar" && mini_war)
		var/datum/game_mode/miniwar/M = ticker.mode
		switch(mini_war)
			if("Northner")
				text += "Losses: [M.north_count]/[M.max_count]"
			if("Southner")
				text += "Losses: [M.south_count]/[M.max_count]"

	for(var/T in text)
		fulltext += "[T]<br>"

	return fulltext

/proc/generateVerbHtml(var/verbname = "", var/displayname = "", var/number = 1)
	if(number % 2)
		return {"<a href='#' class='verb dim' onclick='window.location = "byond://winset?command=[verbname]"'>[displayname]</a>"}
	return {"<a href='#' class='verb' onclick='window.location = "byond://winset?command=[verbname]"'>[displayname]</a>"}

/proc/generateVerbList(var/list/verbs = list(), var/count = 1)
	var/html = ""
	var/counter = count
	for(var/list/L in verbs)
		counter++
		html += generateVerbHtml(L[1], L[2], counter) + "$"

	return html

/client/proc/newtext(var/newcontent = "")
	src << output(list2params(list("[newcontent]")), "outputwindow.browser:InputMsg")

/client/proc/changebuttoncontent(var/idcontent = "", var/newcontent = "")
	src << output(list2params(list("[newcontent]", "[idcontent]")), "outputwindow.browser:changel")

/client/proc/addbutton(var/newcontent = "", var/selector = "")
	src << output(list2params(list("[newcontent]", "[selector]")), "outputwindow.browser:addel")

/mob/proc/updatePig()
	set waitfor = 0
	if(!client)
		return
	if(!client.pigReady)
		return

	var/pixelDistancing = 46
	var/buttonTimes = 1

	var/buttonHTML = ""
	defaultButton()

	buttonHTML += {"<a href="#"><div style="background-image: url(\'Verbs.png\'); margin-right: 8px;" id="Verb" class="button" /></div></a>"}

	if(isobserver(src) || istype(src, /mob/living/carbon/brain))
		buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Dead.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"DeadGhost\" class=\"button\" /></div></a>"

	if(istype(src, /mob/living/carbon/alien) && src.stat == DEAD)
		buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Dead.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"DeadGhost\" class=\"button\" /></div></a>"

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Emotes.png\'); margin-top: -50px; margin-left: [pixelDistancing * buttonTimes]px; \" id=\"Emotes\" class=\"button\" /></div></a>"
		buttonTimes++;
		buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Craft.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"Craft\" class=\"button\" /></div></a>"
		buttonTimes++;
		buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'GPC.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"GPC\" class=\"button\" /></div></a>"

		if(H.isVampire)
			buttonTimes++;
			buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Fangs.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"Vampire\" class=\"button\" /></div></a>"
		if(H.job == "Francisco's Advisor")
			buttonTimes++;
			buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Plot.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"Advisor\" class=\"button\" /></div></a>"
		if(H.job == "Francisco's Bodyguard")
			buttonTimes++;
			buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Plot.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"Bodyguard\" class=\"button\" /></div></a>"
		if(H?.mind)
			if(H?.mind?.changeling)
				buttonTimes++
				buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Villain.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"They\" class=\"button\" /></div></a>"
			if(H.mind.special_role == "Head Revolutionary")
				buttonTimes++
				buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Epsilon.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"Integralist\" class=\"button\" /></div></a>"
		if(H?.religion == "Thanati")
			buttonTimes++
			buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Thanati.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"Thanati\" class=\"button\" /></div></a>"
		if(H.anchored && istype(H.anchored, /obj/structure/stool/bed/chair/ThroneMid) && H.head && istype(H.head, /obj/item/clothing/head/caphat))
			buttonTimes++
			buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Crown.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"Crown\" class=\"button\" /></div></a>"
		if(H.anchored && istype(H.anchored, /obj/structure/stool/bed/chair/comfy/judge) && H.job == "Patriarch")
			buttonTimes++
			buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Crown.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"Patriarch\" class=\"button\" /></div></a>"
		if((H.stat == DEAD || H.death_door) && (!(H.status_flags & FAKEDEATH)))
			if((H.health < 0 && H.health > -95.0) || H.death_door || iszombie(H))
				buttonTimes++
				buttonHTML += "<a href=\"#\"><div style=\"background-image: url(\'Dead.png\'); margin-top: -50px; margin-left:[pixelDistancing * buttonTimes]px; \" id=\"Dead\" class=\"button\" /></div></a>"

	client.addbutton(buttonHTML, "#dynamicpanel")
	updateButtons()

/mob/proc/noteUpdate()
	var/newHTML = ""

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		newHTML += "<span style='white-space: nowrap' class='segment1 ST'>ST: <span id='st'>[H.my_stats.st]</span>$HT: <span id='ht'>[H.my_stats.ht]</span>$IN: <span id='int'>[H.my_stats.it]</span>$DX: <span id='dx'>[H.my_stats.dx]</span></span><span style='word-break:keep-all;white-space: nowrap; position:absolute; margin-right: 35%;' class='segment2 ST MINOR'>CR: <span id='cr'>[client.info?.chromosomes]</span>$PR: <span id='pr'>[H.my_stats.pr]</span>$IM: <span id='im'>[H.my_stats.im]</span>$WP: <span id='wp'>[H.my_stats.wp]</span></span>$$$$$$$$$"
		newHTML += "<span class='smallstat'>[H.updateSmalltext()]</span>"

	return newHTML

/mob/proc/updateButtons()
	set waitfor = 0
	if(!client)
		return
	if(!client.pigReady)
		return

	client.changebuttoncontent("#note", noteUpdate())
	client.changebuttoncontent("#Verb", verbUpdate())
	client.changebuttoncontent("#GPC", spiderUpdate())
	client.changebuttoncontent("#Emotes", {"<span class='segment1'>[generateVerbList(list(list("slap", "Slap"), list("Nod", "Nod"), list(".praiselord", "Cross"), list("Hug", "Hug"), list("Bow", "Bow"), list("Scream", "Scream"), list("Whimper", "Whimper"), list("Laugh", "Laugh"), list("Sigh", "Sigh"), list("Clearthroat", "Clear Throat"), list("mob_rest", "Collapse")))]</span>"} + {"<span class='segment2'>[generateVerbList(list(list("Kiss", "Kiss"), list("LickLips", "Lick Lips"), list("Cough", "Cough"), list("SpitonSomeone", "Spit on Someone"), list("Yawn", "Yawn"), list("Wink", "Wink"), list("Grumble", "Grumble"), list("Cry", "Cry"), list("Hem", "Hem"), list("Smile", "Smile")), 2)]</span>"})
	client.changebuttoncontent("#Craft", {"<span class='segment1'>[generateVerbList(list(list("Furniture", "Furniture"), list("Cult", "Cult"), list("Items", "Items"), list("Leather", "Leather"), list("Mason", "Mason"), list("Tanning", "Tanning"), list("Signs", "Signs")))]</span><span class='segment2'>[generateVerbList(list(list("Weapons", "Weapons"), list("Other", "Other")), 2)]</span>"})

	client.changebuttoncontent("#DeadGhost", {"<span class='segment1'>[generateVerbList(list(list("Wraith", "Wraith"), list("Ascend", "Ascend"), list("LateParty", "Late Party"), list("ToggleDarkness", "Shroud Thickness"), list("GotoHell", "Go to Hell"), list("Jaunt", "(5) Jaunt"), list("GrueSpawn", "(15) Grue"), list("Ignition", "(30) Ignition"), list("InterveneDreams", "Intervene Dreams"), list("ReenterCorpse", "Re-enter Corpse")))]</span>"})
	client.changebuttoncontent("#Dead", {"<span class='segment1'>[generateVerbList(list(list("Wraith", "Wraith")))]</span>"})

	client.changebuttoncontent("#Vampire", {"<span class='segment1'>[generateVerbList(list(list("ExposeFangs", "Expose Fangs"), list("BloodStrength", "Blood Strength (50cl)"), list("Fortitude", "Fortitude (50cl)"), list("Heal", "Heal (150cl)"), list("Celerety", "Celerety (250cl)"), list("DeadEyes", "Dead Eyes")))]</span>"})
	client.changebuttoncontent("#Advisor", {"<span class='segment1'>[generateVerbList(list(list("gradeHygiene", "Grade the Hygiene"), list("gradePeople", "Grade the People"), list("gradeFortress", "Grade the Fortress")))]</span>"})
	client.changebuttoncontent("#Bodyguard", {"<span class='segment1'>[generateVerbList(list(list("localizeAdvisor", "Localize Advisor")))]</span>"})
	client.changebuttoncontent("#They", {"<span class='segment1'>[generateVerbList(list(list("ExtendTentacles", "Extend Tentacles"), list("AbsorbDNA", "Absorb Victim"), list("Hunt", "Hunt"), list("infest", "Infest the Lifeweb"), list("Lump", "Lump"), list("Learnch", "Learn from the Associates"), list("RegenerativeStasis", "Regenerative Stasis")))]</span>"})
	client.changebuttoncontent("#Crown", {"<span class='segment1'>[generateVerbList(list(list("DecretodoBarao", "Baron Decree"), list("Abrirtrapdoors", "Open Traps"), list("ColocarTaxas", "Impose Fees"), list("Declararalerta", "Declare Emergency"), list("VendadeDrogas", "Drug Sell"), list("VendadeArmas", "Gun Sell"), list("Expandirpoderesdaigreja", "Expand Church Power"), list("SetHands", "Set Hand")))]</span>"})
	client.changebuttoncontent("#Integralist", {"<span class='segment1'>[generateVerbList(list(list("RevConvert", "Convert a Citizen")))]</span>"})
	client.changebuttoncontent("#Thanati", {"<span class='segment1'>[generateVerbList(list(list("praisethelord", "Call to the Lord"), list("getWords", "Remember the Words"), list("getBrothers", "Remember the Associates")))]</span>"})

/mob/proc/verbUpdate()
	var/newHTML = ""
	if(istype(src, /mob/new_player))
		var/lobby = ""
		if(ticker.current_state == GAME_STATE_PREGAME)
			lobby += "Time to Start: <span id='timestart'>[ticker.pregame_timeleft]</span>$"
			lobby += "Chromosomes: [client.info?.chromosomes]$"
		if(ticker.current_state == GAME_STATE_PLAYING)
			if(ticker.mode.config_tag == "siege")
				var/datum/game_mode/siege/S = ticker.mode
				lobby += "Losses: [S.losses]/[S.max_losses]$"
				lobby += "Next Reinforcement Wave: [ticker.migwave_timeleft]s$"
				lobby += "Reinforcement: [ticker.migrants_inwave.len]/[ticker.migrant_req]$"
			else
				lobby += "Next Migrant Wave: [ticker.migwave_timeleft]s$"
				lobby += "Migrants: [ticker.migrants_inwave.len]/[ticker.migrant_req]$"
			lobby += "Chromosomes: [client.info?.chromosomes]$"
			for(var/client/C in ticker.migrants_inwave)
				var/religioncheck = ""
				var/gendercheck = "M"
				var/familycheck = ""

				if(C.prefs.religion != LEGAL_RELIGION)
					religioncheck = "!"
				if(C.prefs.family)
					familycheck = "*"
				if(C.prefs.gender != MALE)
					gendercheck = "F"

				lobby += "<b>[C.ckey]</b> ([C.prefs.age] [gendercheck]) [familycheck][religioncheck]$"
			lobby += "$$<i>! - Pagan </i>$<i>* - Family</i>"
			newHTML += {"<span style='color:#600; font-weight:bold;'>[lobby]</span>"}
	if(ishuman(src))
		newHTML += {"<span class='segment1'>[generateVerbList(list(list("DisguiseVoice", "Disguise Voice"), list("Dance", "Dance"), list("vomit", "Try to Vomit"), list("Pee", "Pee"), list(".asktostop", "Stop")))]</span>"} + {"<span class='segment2'>[generateVerbList(list(list("Notes", "Memories"), list("AddNote", "Add Memories"), list("Pray", "Pray"), list("Clean", "Clean"), list("Masturbate", "Masturbate"), list("Poo", "Poo")), 2)]</span>"}
	return newHTML

/mob/proc/spiderUpdate()
	var/newOption = ""
	var/list/verbs = list()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		verbs += list(list("RememberTheTerrain", "Remember the Terrain"))

		if(is_dreamer(H))
			verbs += list(list("Wonders", "Wonders"))
		if(H.reflectneed >= 750)
			verbs += list(list("ReflectExperience", "Reflect your Experience!"))
		if(H?.mind?.succubus)
			verbs += list(list("teleportSlaves", "Teleport Slaves"), list("killSlave", "Kill Slave"))
		if(istype(H?.species, /datum/species/human/alien))
			verbs += list(list("plantWeeds", "Plant Weeds"), list("plantEgg", "Lay Egg"))

		if(H.job == "Bishop" || H.old_job == "Bishop")
			verbs += list(list("Excommunicate", "Excommunicate"), list("BannishtheUndead", "Banish Undead"), list("RobofSins", "Rob of Sins"), list("Epitemia", "Epitemia"), list("RewardtheInquisitor", "Reward the Inquisitor"), list("Coronation", "Coronation"), list("Eucharisty", "Eucharisty"), list("BannishSpirits", "Banish Spirits"), list("CallforChurchMeeting", "Call for Church Meeting"), list("Marriage", "Marriage!"), list("ClearName", "Clear Name"))
		if(H.job == "Priest" || H.old_job == "Priest")
			verbs += list(list("Excommunicate", "Excommunicate"), list("BannishtheUndead", "Banish Undead"), list("RobofSins", "Rob of Sins"), list("Epitemia", "Epitemia"), list("RewardtheInquisitor", "Reward the Inquisitor"), list("Coronation", "Coronation"), list("Eucharisty", "Eucharisty"), list("BannishSpirits", "Banish Spirits"), list("CallforChurchMeeting", "Call for Church Meeting"), list("Marriage", "Marriage!"), list("ClearName", "Clear Name"))
		if(H.job == "Monk" || H.old_job == "Monk")
			verbs += list(list("BannishtheUndead", "Banish Undead"), list("RobofSins", "Rob of Sins"), list("Eucharisty", "Eucharisty"), list("BannishSpirits", "Banish Spirits"), list("Marriage", "Marriage"))
		if(H.job == "Expedition Leader" || H.old_job == "Expedition Leader")
			verbs += list(list("SetMigSpawn", "Set Migrant Arrival"), list("announceEx", "Announce (14 TILES)"))

		if(H.job == "Bum" || H.old_job == "Bum")
			verbs += list(list("tellTheTruth", "Tell the Truth"))

		if(H.job == "Urchin" || H.old_job == "Urchin")
			verbs += list(list("tellTheTruth", "Tell the Truth"))

		if(H.job == "Migrant" || H.old_job == "Migrant")
			if(!H.migclass)
				verbs += list(list("ChoosemigrantClass", "Choose Migrant Class!"))
				if(ckey in outlaw)
					verbs += list(list("ToggleOutlaw", "Toggle Outlaw!"))

		if(H.job == "Count" || H.old_job == "Count")
			verbs += list(list("Reinforcement" , "Change Reinforcement Type"), list("Command", "Command"), list("SpecialReinforcement", "Call for Special Reinforcement!"), list("Recruit", "Recruit"), list("CaptureThrone", "Capture Throne"))

		if(H.job == "Count Hand" || H.old_job == "Count Hand")
			verbs += list(list("Command", "Command"), list("SpecialReinforcement", "Call for Special Reinforcement!"), list("Recruit", "Recruit"))

		if(H.job == "Count Heir" || H.old_job == "Count Heir")
			verbs += list(list("SpecialReinforcement", "Call for Special Reinforcement!"))

		if(H.job == "Sieger" || H.old_job == "Sieger")
			if(!H.migclass)
				verbs += list(list("ChoosesiegerClass", "Choose Sieger Class!"))

		if(H.job == "Mercenary" || H.old_job == "Mercenary")
			if(!H.migclass)
				verbs += list(list("PegaclasseMerc", "Choose Mercenary Class!"))

		if(H.consyte)
			verbs += list(list("Choir", "Choir"), list("Respark", "Respark"))
		if(H.job == "Jester")
			verbs += list(list("joke", "Joke"), list("rememberjoke", "Remember Joke"),list("apelidar", "Give a Nickname!"), list("malabares", "Juggling!"))
		if(H.check_perk(/datum/perk/pathfinder))
			verbs += list(list("TrackSomeonePathFinder", "Track Someone"), list("TrackselfPathfinder", "Track Yourself"))
		if(H.check_perk(/datum/perk/singer))
			verbs += list(list("RememberSong", "Remember Song"), list("Sing", "Sing"))

		if(H.verbs.Find(/mob/living/carbon/human/proc/interrogate))
			verbs += list(list("Interrogate", "Interrogate"))

	newOption = generateVerbList(verbs)
	return {"<span class='segment1'>[newOption]</span>"}

/client/proc/lobbyPig()
	src << browse('code/porco/html/pig.html', "window=outputwindow.browser; size=411x330;")

/mob/proc/defaultButton()
	client.changebuttoncontent("#options", "<span class='segment1'>" + generateVerbList(list(list("OOC", "OOC"), list("Adminhelp", "Admin Help"), list(".togglegraphics", "Graphics Settings"), list(".addeffects", "(EXPERIMENTAL) Add Effects"), list(".togglefullscreen", "Toggle Fullscreen"), list("LobbyMusic", "Toggle Lobby Music"), list("Midis", "Toggle Midis"), list("AmbiVolume", "Ambience Volume (0-255)"), list("MusicVolume", "Music Volume (0, 255)"))) + "</span>")
	if(istype(src, /mob/new_player) && ticker.current_state == GAME_STATE_PREGAME)
		client.changebuttoncontent("#chrome", "<span class='segment1'>" + generateVerbList(list(list("MigracaodeTodos", "(100) Allmigration"), list("LimparCromossomos", "(100) Wipe Chromosomes"), list("ForceAspect", "(10) Force Aspect"), list("EscondercargoCustom", "(10) Hide Custom Job"), list("Escondercargo", "(2) Hide Job"), list("ReRolarSpecial", "(2) Reroll Special"), list("silencePigs", "(2) Silence Pigs"), list("Trapokalipsis", "(15) Trapokalipsis"))) + "</span>")
	else if(istype(src, /mob/living/carbon/human) && ticker.current_state == GAME_STATE_PLAYING)
		client.changebuttoncontent("#chrome", "<span class='segment1'>" + generateVerbList(list(list("LimparCromossomos", "(100) Wipe Chromosomes"), list("ChamarCharon", "(10) Launch Babylon"), list("ForcePadla", "(7) Force Padla"), list("ReceiveObols", "(1) Receive Obols"), list("RetirarVice", "(1) Remove Vice"))) + "</span>")
	else
		client.changebuttoncontent("#chrome", "<span class='segment1'>" + generateVerbList(list(list("LimparCromossomos", "(100) Wipe Chromosomes"), list("ChamarCharon", "(10) Launch Babylon"), list("ForcePadla", "(7) Force Padla"), list("ReRolarSpecial", "(2) Reroll Special"))) + "</span>")

/client/proc/setDefaultButtons()
	changebuttoncontent("#Verb", {"<span class='segment1'>[generateVerbList(list(list("DisguiseVoice", "Disguise Voice"), list("Dance", "Dance"), list("vomit", "Try to Vomit"), list("Pee", "Pee"), list(".asktostop", "Stop")))]</span>"} + {"<span class='segment2'>[generateVerbList(list(list("Notes", "Memories"), list("Pray", "Pray"), list("AddNote", "Add Memories"), list("Clean", "Clean"), list("Masturbate", "Masturbate"), list("Poo", "Poo")))]</span>"})

/client/New()
	..()
	loadDataPig()
	lobbyPig()

	if(!holder)
		return
	winset(src, "outputwindow.csay", "is-visible=true")

/mob/new_player/say(message)
	if(!client)
		return

	client.ooc(message)

/mob/verb/soundbutton()
	set hidden = 1
	set name = "button"

	client << 'sound/uibutton.ogg'

/mob/verb/heartporcao()
	set hidden = 1
	set name = "heartpig"

	soundbutton()

/mob/proc/updateStatPig()
	if(!client)
		return
	if(!client.pigReady)
		return

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		client << output(list2params(list("#st", "[H.my_stats.st]")), "outputwindow.browser:change")
		client << output(list2params(list("#ht", "[H.my_stats.ht]")), "outputwindow.browser:change")
		client << output(list2params(list("#int", "[H.my_stats.it]")), "outputwindow.browser:change")
		client << output(list2params(list("#dx", "[H.my_stats.dx]")), "outputwindow.browser:change")

	client << output(list2params(list("#cr", "[client.info?.chromosomes]")), "outputwindow.browser:change")
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		client << output(list2params(list("#pr", "[H.my_stats.pr]")), "outputwindow.browser:change")
		client << output(list2params(list("#timepusher", "[src?:mind?.time_to_pay]")), "outputwindow.browser:change")
		client << output(list2params(list("#im", "[H.my_stats.im]")), "outputwindow.browser:change")
		client << output(list2params(list("#wp", "[H.my_stats.wp]")), "outputwindow.browser:change")

/mob/proc/pigHandler()
	updatePig()
	if(!ishuman(src))
		return

	var/mob/living/carbon/human/H = src
	H.updateStatPig()

/mob/living/carbon/human/New()
	..()

/mob/proc/startPig()
	spawn while(client)
		sleep(85)
		pigHandler()
		updateStatPig()

/mob/living/carbon/human/Login()
	..()
	heartporcao()
	updatePig()
	startPig()

//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣧⠀⠀⠀⢰⡿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡟⡆⠀⠀⣿⡇⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⣿⠀⢰⣿⡇⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡄⢸⠀⢸⣿⡇⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡇⢸⡄⠸⣿⡇⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⢸⡅⠀⣿⢠⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣥⣾⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡿⡿⣿⣿⡿⡅⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠉⠀⠉⡙⢔⠛⣟⢋⠦⢵⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣄⠀⠀⠁⣿⣯⡥⠃⠀⢳⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⡇⠀⠀⠀⠐⠠⠊⢀⠀⢸⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⡿⠀⠀⠀⠀⠀⠈⠁⠀⠀⠘⣿⣄⠀⠀⠀⠀⠀
//⠀⠀⠀⣠⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣷⡀⠀⠀⠀
//⠀⠀⣾⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣧⠀⠀
//⠀⡜⣭⠤⢍⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢛⢭⣗⠀
//⠀⠁⠈⠀⠀⣀⠝⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠠⠀⠀⠰⡅
//⠀⢀⠀⠀⡀⠡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠔⠠⡕⠀
//⠀⠀⣿⣷⣶⠒⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⠀⠀⠀
//⠀⠀⠘⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⠀⠀⠀⠀⠀
// ⠀⠀⠈⢿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠊⠉⢆⠀⠀⠀⠀
//⠤⠀⠀⢤⣤⣽⣿⣿⣦⣀⢀⡠⢤⡤⠄⠀⠒⠀⠁⠀⠀⠀⢘⠔⠀⠀⠀⠀
//⠀⡐⠈⠁⠈⠛⣛⠿⠟⠑⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠉⠑⠒⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

// ░░░░░▒░░▄██▄░▒░░░░░░
// ░░░▄██████████▄▒▒░░░
// ░▒▄████████████▓▓▒░░
// ▓███▓▓█████▀▀████▒░░
// ▄███████▀▀▒░░░░▀█▒░░
// ████████▄░░░░░░░▀▄░░
// ▀██████▀░░▄▀▀▄░░▄█▒░
// ░█████▀░░░░▄▄░░▒▄▀░░
// ░█▒▒██░░░░▀▄█░░▒▄█░░
// ░█░▓▒█▄░░░░░░░░░▒▓░░
// ░▀▄░░▀▀░▒░░░░░▄▄░▒░░
// ░░█▒▒▒▒▒▒▒▒▒░░░░▒░░░
// ░░░▓▒▒▒▒▒░▒▒▄██▀░░░░
// ░░░░▓▒▒▒░▒▒░▓▀▀▒░░░░
// ░░░░░▓▓▒▒░▒░░▓▓░░░░░
// ░░░░░░░▒▒▒▒▒▒▒░░░░░░

//`7MMF'   `7MF' db      `7MMF'    MMP""MM""YMM   .g8""8q. `7MMM.     ,MMF'      db      `7MM"""Mq.      `7MN.   `7MF' .g8""8q.         .g8"""bgd `7MMF'   `7MF'    `7MN.   `7MF' .g8""8q. `7MM"""Mq.`7MMM.     ,MMF'
//  `MA     ,V  ;MM:       MM      P'   MM   `7 .dP'    `YM. MMMb    dPMM       ;MM:       MM   `MM.       MMN.    M .dP'    `YM.     .dP'     `M   MM       M        MMN.    M .dP'    `YM. MM   `MM. MMMb    dPMM
//   VM:   ,V  ,V^MM.      MM           MM      dM'      `MM M YM   ,M MM      ,V^MM.      MM   ,M9        M YMb   M dM'      `MM     dM'       `   MM       M        M YMb   M dM'      `MM MM   ,M9  M YM   ,M MM
//    MM.  M' ,M  `MM      MM           MM      MM        MM M  Mb  M' MM     ,M  `MM      MMmmdM9         M  `MN. M MM        MM     MM            MM       M        M  `MN. M MM        MM MMmmdM9   M  Mb  M' MM
//    `MM A'  AbmmmqMA     MM           MM      MM.      ,MP M  YM.P'  MM     AbmmmqMA     MM  YM.         M   `MM.M MM.      ,MP     MM.           MM       M        M   `MM.M MM.      ,MP MM        M  YM.P'  MM
//     :MM;  A'     VML    MM           MM      `Mb.    ,dP' M  `YM'   MM    A'     VML    MM   `Mb.       M     YMM `Mb.    ,dP'     `Mb.     ,'   YM.     ,M        M     YMM `Mb.    ,dP' MM        M  `YM'   MM
//      VF .AMA.   .AMMA..JMML.       .JMML.      `"bmmd"' .JML. `'  .JMML..AMA.   .AMMA..JMML. .JMM.    .JML.    YM   `"bmmd"'         `"bmmmd'     `bmmmmd"'      .JML.    YM   `"bmmd"' .JMML.    .JML. `'  .JMML.⠀⠀⠀⠀⠀
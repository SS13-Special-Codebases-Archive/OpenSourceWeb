/datum/game_mode/inspector
	name = "The Realstate Agent"
	config_tag = "inspector"
	required_players = 0
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800

/datum/game_mode/inspector/announce()
	world << "<B>Our fate is a peaceful one.</B>"
	return
/datum/game_mode/inspector/pre_setup()
	return 1

/datum/game_mode/inspector/post_setup()

	for(var/mob/new_player/N in player_list)
		to_chat(N, "\n<div class='firstdivmood'><div class='moodbox'><span class='graytext'>You may join as the Inspector or his bodyguard.</span>\n<span class='feedback'><a href='?src=\ref[src];acao=joininspectree'>1. I want to.</a></span>\n<span class='feedback'><a href='?src=\ref[src];acao=nao'>2. I'll pass.</a></span></div></div>")


	spawn(rand(waittime_l, waittime_h))
		for(var/obj/machinery/charon/C in world)
			var/obj/item/weapon/paper/lord/NG = new (C.loc)
			NG.info = "The inspector will be coming to the Fortress in a few hours, make sure to keep everything clean and in order."
			evermail_ref.receive(NG, 1)
	..()

/datum/game_mode/inspector/can_start()
	for(var/mob/new_player/player in player_list)
		for(var/mob/new_player/player2 in player_list)
			for(var/mob/new_player/player3 in player_list)
				if(player.ready && player.client.work_chosen == "Baron" && player2.ready && player2.client.work_chosen == "Inquisitor"&& player3.ready && player3.client.work_chosen == "Bookkeeper")
					return 1
	return 0


/datum/game_mode/inspector/declare_completion()
	..()
	for(var/mob/living/carbon/human/H in player_list)
		if(!inspector.stat == DEAD)
			if(H.job == "Francisco's Advisor" || H.job == "Francisco's Bodyguard")
				H.client.ChromieWinorLoose(H.client, 3)
			else if(H.job == "Baron" || H.job == "Successor" || H.job == "Baroness" || H.job == "Heir")
				H.client.ChromieWinorLoose(H.client, 2)
			else
				H.client.ChromieWinorLoose(H.client, 1)
		H.RoundEnd()
	if(!has_starring)
		to_chat(world, "<span class='bname'>Starring: [inspector.real_name] ([inspector.key]) as the Inspector</span>")
		if(hygieneGrade+peopleGrade+fortressGrade >= 210 && !inspector.stat == DEAD)
			to_chat(world, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The inspection was successful with flying colours!</span>")
		else
			to_chat(world, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The inspection was a failure!</span>")


var/list/CandidatesForInspector = list() //max = 4

/client/Topic(href, href_list, hsrc)
	..()
	switch(href_list["acao"])
		if("joininspectree")
			if(CandidatesForInspector.len >= 4) return
			if(istype(src.mob, /mob/dead) || istype(src.mob, /mob/new_player))
				if(istype(src.mob, /mob/new_player))
					var/mob/new_player/N = src.mob
					N.close_spawn_windows()
					N << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo
				if(!CandidatesForInspector.len) // INSPECTOR SPAWN
					var/mob/living/carbon/human/new_character = new()
					new_character.vice = pick(VicesList)
					new_character.key = key
					new_character.mind.key = key
					new_character.gender = MALE
					new_character.age = rand(30,45)
					new_character.real_name  = random_name(new_character.gender)
					new_character.name = new_character.real_name
					new_character.old_job = "Francisco's Advisor"
					new_character.job = "Francisco's Advisor"
					new_character.voice_name = new_character.real_name
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					new_character.updatePig()
					var/obj/item/device/radio/R = new /obj/item/device/radio/headset/tribunal(new_character)
					R.set_frequency(COMM_FREQ)
					new_character.equip_to_slot_or_del(new_character, slot_l_ear)
					ticker.mode.inspector = new_character
					new_character.add_perk(/datum/perk/likeart)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/captain(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/advisor(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/amulet/holy/cross(new_character), slot_amulet)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/storage/photo_album(new_character), slot_r_hand)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/minisatchel/francisco(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/card/id/family/tribunal(new_character), slot_wear_id)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/obard(new_character), slot_head)
					new_character.equip_to_slot_or_del(new /obj/item/sheath/sabre(new_character), slot_belt)

					new_character.verbs += /mob/living/carbon/human/proc/gradeHygiene
					new_character.verbs += /mob/living/carbon/human/proc/gradePeople
					new_character.verbs += /mob/living/carbon/human/proc/gradeFortress

					new_character.client.color = null
					new_character.my_stats.st = 11
					new_character.my_stats.dx = rand(11,12)
					new_character.my_stats.ht = rand(14,16)
					new_character.my_stats.pr = rand(15,16)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(10,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(10,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG, rand(10,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(10,11))

					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "Inspector")
							new_character.forceMove(L.loc)

					CandidatesForInspector.Add("inspector")
					new_character.update_icons()
					new_character.FuncArea()
					var/area/A = get_area(new_character)
					A.Entered(new_character)
					new_character.create_kg()
					new_character.month_born = pick("vernes","lipen","stujen","plesnya","leden","cherven","krovotok","zmeinik","grezen","shramyn","kamnepad","ljutish")
					new_character.day_born = rand(1,30)
					new_character.year_born = 3021 - new_character.age
					var/Borntext = "I was [pick("made","lucky")] to be born on [new_character.month_born], [new_character.day_born], [new_character.year_born] ([new_character.zodiac] Sign)"
					new_character?.mind?.memory += Borntext
					var/personal_objective = pick("Have a sexual intercourse with the Baroness or Successor.", "Fuck the Baron of Firethorn.", "Get high for the first time.", "Do a shooting range on smerds. Ignoring the mess it will cause, of course.", "Have on myself atleast a thousand obols from guns to collars.") //I don't trust players creativity, so i'll just suggest them making retarded shit
					to_chat(new_character, "<span class='passive'>[Borntext]</span>")
					to_chat(new_character, "<span class='dreamershitfuckcomicao1'>You're Francisco's Advisor.</span>")
					to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objective #1:</span> <span class='dreamershit'>Review the fortress condition, take pictures of anything that violates the sanitary laws.</span>")
					to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objective #2:</span> <span class='dreamershit'>Leave a rating and abandon the fortress on the Babylon.</span>")
					to_chat(new_character, "<span class='dreamershitfuckcomicao1'>PERSONAL Objective:</span> <span class='dreamershit'>[personal_objective].</span>")


				else
					var/mob/living/carbon/human/new_character = new()
					new_character.vice = pick(VicesList)
					new_character.key = key
					new_character.mind.key = key
					new_character.gender = MALE
					new_character.age = rand(23,45)
					new_character.real_name  = random_name(new_character.gender)
					new_character.name = new_character.real_name
					new_character.old_job = "Francisco's Bodyguard"
					new_character.job = "Francisco's Bodyguard"
					new_character.voice_name = new_character.real_name
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					new_character.updatePig()
					var/obj/item/device/radio/R = new /obj/item/device/radio/headset/tribunal(new_character)
					R.set_frequency(COMM_FREQ)
					new_character.equip_to_slot_or_del(new_character, slot_l_ear)
					ticker.mode.inspector = new_character
					new_character.add_perk(/datum/perk/likeart)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/minisatchel/francisco(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/hevhelm(new_character), slot_head)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/card/id/family/tribunal(new_character), slot_wear_id)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/francisco(new_character), slot_wear_suit)
					if(prob(50))
						new_character.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/smallclub(new_character), slot_belt)
					else
						new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/sabre(new_character), slot_belt)

					if(prob(60))
						new_character.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/new_rifle/lakko(new_character), slot_back2)
					else
						new_character.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/shotgun/princess(new_character), slot_back2)
					new_character.verbs += /mob/living/carbon/human/proc/localizeAdvisor
					new_character.client.color = null
					new_character.my_stats.st = rand(13,14)
					new_character.my_stats.dx = rand(10,11)
					new_character.my_stats.ht = rand(13,14)
					new_character.my_stats.pr = rand(14,16)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(12,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(12,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(12,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG, rand(10,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(10,11))
					if(new_character.wear_id)
						var/obj/item/weapon/card/id/RR = new_character.wear_id
						RR.registered_name = new_character.real_name
						RR.rank = new_character.job
						RR.assignment = new_character.job
					CandidatesForInspector.Add("guard")
					new_character.update_icons()
					new_character.FuncArea()
					new_character.create_kg()
					new_character.month_born = pick("vernes","lipen","stujen","plesnya","leden","cherven","krovotok","zmeinik","grezen","shramyn","kamnepad","ljutish")
					new_character.day_born = rand(1,30)
					new_character.year_born = 3021 - new_character.age
					var/Borntext = "I was [pick("made","lucky")] to be born on [new_character.month_born], [new_character.day_born], [new_character.year_born] ([new_character.zodiac] Sign)"
					new_character?.mind?.memory += Borntext

					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "Inspector")
							new_character.forceMove(L.loc)

					to_chat(new_character, "<span class='passive'>[Borntext]</span>")
					to_chat(new_character, "<span class='dreamershitfuckcomicao1'>You're the Inspector's guard.</span>")
					to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #1:</span> <span class='dreamershit'>Protect your Advisor.</span>")
					to_chat(new_character, "<span class='dreamershitfuckcomicao1'>Objetivo #2:</span> <span class='dreamershit'>Survive.</span>")

var/hygieneGrade = 70
var/peopleGrade = 70
var/fortressGrade = 70

/mob/living/carbon/human/proc/gradeHygiene()
	var/hygiene = sanitize_uni(input(usr, "What will be the grade - Choose between 0 and 100.", "FIRETHORN FORTRESS HYGIENE") as num)
	if(hygiene > 100 || hygiene < 1)
		return
	hygieneGrade = hygiene
	to_chat(usr, "Hygiene grade is [hygiene].")


/mob/living/carbon/human/proc/gradePeople()
	var/people = sanitize_uni(input(usr, "What will be the grade? - Choose between 0 and 100.", "FIRETHORN FORTRESS PEOPLE") as num)
	if(people > 100 || people < 1)
		return
	peopleGrade = people
	to_chat(usr, "People grade is [people].")

/mob/living/carbon/human/proc/gradeFortress()
	var/fortress = sanitize_uni(input(usr, "What will be the grade? - Choose between 0 and 100.", "FIRETHORN FORTRESS BEAUTY") as num)
	if(fortress > 100 || fortress < 1)
		return
	fortressGrade = fortress
	to_chat(usr, "Beauty grade is [fortress].")

/mob/living/carbon/human/proc/localizeAdvisor()
	for(var/mob/living/carbon/human/L in mob_list)
		if(L.job == "Francisco's Advisor")
			var/dirR = get_dir(src,L)
			to_chat(src, "<span class='passive'><i>The advisor is [dir2text(dirR)] from me.</i></span>")

/mob/living/carbon/human/proc/RoundEnd()
	var/obj/texto/T = new
	src.client.screen.Add(T)
	var/obj/texto/T1 = new
	src.client.screen.Add(T1)
	var/obj/texto/T2 = new
	src.client.screen.Add(T2)
	var/obj/texto/T3 = new
	src.client.screen.Add(T3)
	var/higiene = 0
	var/pessoas = 0
	var/fortaleza = 0
	while(higiene <= hygieneGrade)
		higiene++
		var/randAlpha = rand(90, 220)
		if(higiene >= hygieneGrade)
			randAlpha = 255
		sleep(0.00001)
		T.Become("Firethorn's Hygiene: [higiene]", 20, -420, randAlpha, 200)
	while(fortaleza <= fortressGrade)
		fortaleza++
		var/randAlpha = rand(90, 220)
		if(fortaleza >= fortressGrade)
			randAlpha = 255
		sleep(0.00001)
		T2.Become("Firethorn's Fortress Beauty: [fortaleza]", 20, -230, randAlpha, 200)
	while(pessoas <= peopleGrade)
		pessoas++
		var/randAlpha = rand(90, 220)
		if(pessoas >= peopleGrade)
			randAlpha = 255
			world << "FOI"
		sleep(0.00001)
		T1.Become("Firethorn's People: [pessoas]", 20, -48, randAlpha, 200)
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Francisco's Advisor")
			if(H.stat != DEAD && higiene+pessoas+fortaleza >= 210)
				T3.Become("INSPECTION PASSED!", 70, -230, 255, 200)
			else
				T3.Become("INSPECTION FAILED!", 70, -230, 255, 200)
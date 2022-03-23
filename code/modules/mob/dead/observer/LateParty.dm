#define LATEPARTY_MAX 6
var/global/list/latepartied_list = list()
var/global/partying = 0
var/list/soulbreaker_names = list("Tarik","Hashim", "Faghil","Saffah","Sadir","Ahmed","Amir","Hassan","Nasir","Omar","Mohammad","Abdul","Asad","Bilal","Yousef","Ashraf","Fadir","Habib","Hakim","Hussein","Ibrahim","Jafar","Mahmud","Salim")
var/soulbreaker_bashar = ("Bashar")
var/soulbreaker_eunuch = ("Eunuch")
var/ludruk_captain = ("Sir")
var/list/ludruk_names = list("Vincent", "Julian", "Dante", "Jamie", "Gabriel", "Julius", "Malik", "Damien", "Godwin", "Maddox", "Ulric", "Russell", "Fulton", "Rusty", "Nasir", "Iving", "Nikita", "Feridey", "Symond")
var/list/ludruk_nicknames = list("Teeth-puller", "Uprooter", "Spinegrinder", "Bloodeater", "Bone-snapper", "Skinwalker", "Flesh-ripper", "Skull-cracker")
var/list/bandit_names = list("Maddox Mad-Eye", "Fast-Fingers Fairfax", "Blackjack Ackerly", "Lorde Crazy-Motherfucker", "Mad-Man Maddox", "Gunner Five-Fingers", "Ulysses Nine-Lives", "Damon Black-Tongue", "Draco Two-Face", "Rocky the Knuckles", "Three-Toed Ronan")
var/ludruk = 0
var/lady = 0
/mob/dead/observer/verb/lateparty()
	set category = "Wraith"
	set name = "LateParty"
	set desc = "Joins the late party."

	if(!client) return

	if(master_mode == "holywar" || master_mode == "minimig")
		to_chat(usr, "<span class	='combatbold'>[pick(nao_consigoen)],</span><span class='combat'> fuck you.</span>")
		return 0

	if(world.time < 1)
		to_chat(usr, "<span class='passive'>It's too early for the late party,It will be available in [round((6000-world.time)/600)] minutes.</span>")
		return 0

	if(partying)
		to_chat(usr, "<span class='combatglow'>The late party has already arrived.</span>")
		return 0

	if(latepartied_list.Find(src))
		to_chat(usr, "<span class='combatglow'>You throw your chances away.</span>")
		latepartied_list.Remove(src)
		return 0

	if(latepartied_list.len >= LATEPARTY_MAX)
		to_chat(usr, "<span class='bname'>You can't join the</span> <span class='bname'>late party</span><span class='bname'>, it's full!</span>")
		return 0
	else
		to_chat(usr, "<span class='passive'>You now have a chance to enter the round as a late group. If you're chosen, it's neccessary to avoid any revenge for the events of your previous life.</span>")
		latepartied_list.Add(src)
		to_chat(usr, "<span class='bname'>[latepartied_list.len]/6 ready</span>")
		check_late_party()
		return 1

/mob/living/carbon/human/var/mySon = ""
/mob/living/carbon/human/var/myWife = ""

/mob/living/carbon/human/var/hasMother = 1

/proc/check_late_party()
	if(latepartied_list.len >= LATEPARTY_MAX)
		var/list/candidatos = list()
		for(var/mob/dead/observer/O in latepartied_list)
			if(!O.client) continue
			candidatos.Add(O)

		var/whatLateParty = pick("soulbreaker", "countess", "ginkese", "countgift", "thanati", "sirvandenberg", "mortus", "cerberii", "inquis", "bandit")
		var/list/possiblefates = list()

		switch(whatLateParty)
			/*if("duelista")
				possiblefates = list("Father1", "Father1", "Wife1", "Wife1", "Heir1", "Heir1")*/
			if("soulbreaker")
				possiblefates = list("Bashar1", "Soulbreaker1", "Soulbreaker1", "Soulbreaker1", "Soulbreaker1", "Eunuch1")
			if("countess")
				if(ticker.mode.config_tag != "siege")
					return
				possiblefates = list("Countess1", "Sieger1", "Sieger1", "Sieger1", "Sieger1", "Sieger1")
			if("ginkese")
				possiblefates = list("Gink1", "Gink1", "Gink1", "Gink1", "Gink1", "Gink1")
			if("countgift")
				if(ticker.mode.config_tag == "siege")
					return
				possiblefates = list("Counthandgift", "Siegergift", "Siegergift", "Siegergift", "Siegergift", "Siegergift")
			if("thanati")
				possiblefates = list("ThanatiLeader", "Thanatibomber", "Thanati1", "Thanati1", "Thanati1", "Thanati1")
			if("sirvandenberg")
				possiblefates = list("SirVandenberg", "LadyVandenberg", "LudrukGuardCaptain", "LudrukGuard", "LudrukGuard", "LudrukGuard")
				vanden_late = 1
			if("mortus")
				possiblefates = list("Mortician", "Mortician", "Mortician", "Mortician", "Mortician", "Mortician")
			if("cerberii")
				possiblefates = list("Cerberus", "Cerberus", "Cerberus", "Cerberus", "Cerberus", "Cerberus")
			if("inquis")
				possiblefates = list("Inquisitor1", "Practicus1", "Practicus1", "Practicus1", "Practicus1", "Practicus1")
			if("bandit")
				possiblefates = list("Nephi", "Bandit", "Bandit", "Bandit", "Bandit", "Bandit")
		while(candidatos.len)
			var/mob/dead/observer/OO = pick(candidatos)
			if(!OO.client) continue
			OO << 'newBuzzer.ogg'
			animate(OO.client, color = null, time = 10)
			var/chosen = pick(possiblefates)
			switch(chosen)
				if("Father1")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.gender = MALE
					new_character.real_name  = random_name(new_character.gender)
					new_character.name = new_character.real_name
					to_chat(new_character, "<span class='objectivesbig'>You're migrating to Firethorn.</span>")
					to_chat(new_character, "<span class='objectives'>My brother is an asshole. My wife's been cheating on me for a long time with MY BROTHER.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1: Duel my brother on Firethorn and give my wife a LESSON.</span>")
					new_character.f_style = random_facial_hair_style(gender = MALE, species = "Human")
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.r_facial = rand(40, 80)
					new_character.g_facial = rand(40, 80)
					new_character.b_facial = rand(40, 80)
					new_character.r_hair = rand(40, 90)
					new_character.g_hair = rand(40, 90)
					new_character.b_hair = rand(40, 90)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(3,4))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(5,7))
					new_character.my_stats.st = rand(12, 14)
					new_character.my_stats.ht = rand(14, 17)
					new_character.my_stats.it = rand(8, 10)
					new_character.my_stats.dx = rand(7, 9)
					new_character.old_job = "Migrant"
					new_character.voice_name = new_character.real_name
					new_character.terriblethings = TRUE
					new_character.vice = pick(VicesList)
					new_character.age = rand(45,65)
					new_character.voicetype = "strong"
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/hydroponics(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/leatherboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/leja(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/newRevolver/duelista(new_character), slot_belt)
					new_character.equip_to_slot_or_del(new /obj/item/stack/bullets/Newduelista/three(new_character), slot_r_store)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/capelp(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/wrist/bracer(new_character), slot_wrist_r)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/wrist/bracer(new_character), slot_wrist_l)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_r_hand)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/card/id/family(new_character), slot_wear_id)
					new_character.updatePig()
					new_character.create_kg()

					spawn(5)
						for(var/mob/living/carbon/human/H in range(4, new_character))
							if(H.age >= 24 && H.age < 31 && !new_character.mySon && H.gender == MALE) // pai e filho
								var/I = image('icons/mob/mob.dmi', loc = new_character, icon_state = "rel")
								var/II = image('icons/mob/mob.dmi', loc = H, icon_state = "rel")
								new_character.client.images += II
								new_character.mySon = H.real_name
								H?.client?.images += I
							if(H.gender == FEMALE && !new_character.myWife) // pai e mulher
								var/I = image('icons/mob/mob.dmi', loc = new_character, icon_state = "love")
								var/II = image('icons/mob/mob.dmi', loc = H, icon_state = "Unlove")
								new_character.client.images += II
								new_character.myWife = H.real_name
								H?.client?.images += I
							if(H.gender == FEMALE && !(H.real_name == new_character.myWife)) //pai e amante
								var/I = image('icons/mob/mob.dmi', loc = new_character, icon_state = "love")
								var/II = image('icons/mob/mob.dmi', loc = H, icon_state = "love")
								new_character.client.images += II
								H?.client?.images += I

				if("Wife1")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.gender = FEMALE
					new_character.real_name  = random_name(new_character.gender)
					new_character.name = new_character.real_name
					to_chat(new_character, "<span class='objectivesbig'>You're migrating to Firethorn with your husband.</span>")
					to_chat(new_character, "<span class='objectives'>I know he's going to duel his brother for something.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1: Support my husband on his fight.</span>")
					new_character.f_style = random_facial_hair_style(gender = FEMALE, species = "Human")
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.r_facial = rand(40, 80)
					new_character.g_facial = rand(40, 80)
					new_character.b_facial = rand(40, 80)
					new_character.r_hair = rand(40, 90)
					new_character.g_hair = rand(40, 90)
					new_character.b_hair = rand(40, 90)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(1,2))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(3,4))
					new_character.my_skills.CHANGE_SKILL(SKILL_FISH, rand(5,7))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(5,7))
					new_character.my_skills.CHANGE_SKILL(SKILL_COOK, rand(8,9))
					new_character.my_stats.st = rand(8, 10)
					new_character.my_stats.ht = rand(7, 10)
					new_character.my_stats.it = rand(10, 13)
					new_character.my_stats.dx = rand(10, 13)
					new_character.old_job = "Migrant"
					new_character.voice_name = new_character.real_name
					new_character.terriblethings = TRUE
					new_character.vice = pick(VicesList)
					new_character.age = rand(35,55)
					new_character.updatePig()
					new_character.create_kg()
				if("Heir1")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.gender = MALE
					new_character.real_name  = random_name(new_character.gender)
					new_character.name = new_character.real_name
					to_chat(new_character, "<span class='objectivesbig'>You're migrating to Firethorn.</span>")
					to_chat(new_character, "<span class='objectives'>My uncle is an asshole. My uncle's been fucking my MOTHER and my father knows it.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1: Support my father on Firethorn.</span>")
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.r_facial = rand(10, 20)
					new_character.g_facial = rand(10, 20)
					new_character.b_facial = rand(10, 20)
					new_character.r_hair = rand(10, 20)
					new_character.g_hair = rand(10, 20)
					new_character.b_hair = rand(10, 20)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(3,4))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(5,7))
					new_character.my_skills.CHANGE_SKILL(SKILL_FISH, rand(2,4))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(3,5))
					new_character.my_stats.st = rand(12, 13)
					new_character.my_stats.ht = rand(12, 13)
					new_character.my_stats.it = rand(9, 11)
					new_character.my_stats.dx = rand(8, 10)
					new_character.old_job = "Migrant"
					new_character.voice_name = new_character.real_name
					new_character.terriblethings = TRUE
					new_character.vice = pick(VicesList)
					new_character.age = rand(24,30)
					new_character.voicetype = "strong"
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/hydroponics(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/leatherboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/leja(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/rusty(new_character), slot_belt)
					new_character.equip_to_slot_or_del(new /obj/item/stack/bullets/Newduelista/three(new_character), slot_r_store)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/capelp(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/wrist/bracer(new_character), slot_wrist_r)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/wrist/bracer(new_character), slot_wrist_l)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_r_hand)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/card/id/family(new_character), slot_wear_id)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather(new_character), slot_gloves)
					new_character.updatePig()
					new_character.create_kg()
					spawn(5)
						for(var/mob/living/carbon/human/H in range(4, new_character))
							if(H.gender == FEMALE && !new_character.hasMother) // pai e mulher
								var/I = image('icons/mob/mob.dmi', loc = new_character, icon_state = "rel")
								var/II = image('icons/mob/mob.dmi', loc = H, icon_state = "rel")
								new_character.client.images += II
								new_character.hasMother = 1
								H?.client?.images += I
		// SOULBREAKER
				if("Bashar1")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					log_game("[new_character.real_name]/[new_character.key] spawned as Soulbreaker Bashar.")
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/morestamina)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/card/id/ltgrey(new_character), slot_wear_id)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/soulbreaker(new_character), slot_w_uniform)
					var/obj/item/device/radio/R = new /obj/item/device/radio/headset/bracelet/soulbreaker(src)
					R.set_frequency(SYND_FREQ)
					new_character.equip_to_slot_or_del(R, slot_wrist_r)
					new_character.microbomb_soulbreaker()
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.gender = MALE
					new_character.f_style = "Very Long Beard"
					to_chat(new_character, "<span class='objectivesbig'>You're the Bashar.</span>")
					to_chat(new_character, "<span class='objectives'>Lead your soulbreakers and fulfil your CR quota in the name of the Allahopressor.</span>")
					new_character << sound('sound/music/soulbreaker.ogg', repeat = 0, wait = 0, volume = 80, channel = 3)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 14)
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 11)
					new_character.my_skills.CHANGE_SKILL(SKILL_UNARM,rand(1,3))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_MASON, 8)
					new_character.my_skills.CHANGE_SKILL(SKILL_CRAFT, 8)
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC,rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(11,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(11,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURVIV, rand(11,14))
					new_character.my_stats.st = rand(15,16)
					new_character.my_stats.ht = rand(15,16)
					new_character.my_stats.it = 12
					new_character.my_stats.dx = rand(10,11)
					new_character.old_job = "Soulbreaker Bashar"
					new_character.name = pick(soulbreaker_names)
					soulbreaker_names.Remove(new_character.name)
					new_character.real_name = "[soulbreaker_bashar] [new_character.name]"
					new_character.voice_name = new_character.real_name
					new_character.vice = pick(VicesList)
					new_character.age = rand(24,45)
					new_character.voicetype = "strong"
					new_character.religion = "Allah"
					new_character.updatePig()
					new_character.create_kg()
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "Soulbreaker")
							new_character.forceMove(pick(L.loc))
				if("Soulbreaker1")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					log_game("[new_character.real_name]/[new_character.key] spawned as Soulbreaker.")
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/morestamina)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/card/id/ltgrey(new_character), slot_wear_id)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/soulbreaker(new_character), slot_w_uniform)
					var/obj/item/device/radio/R = new /obj/item/device/radio/headset/bracelet/soulbreaker(src)
					R.set_frequency(SYND_FREQ)
					new_character.equip_to_slot_or_del(R, slot_wrist_r)
					new_character.microbomb_soulbreaker()
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.gender = MALE
					new_character.f_style = "Very Long Beard"
					to_chat(new_character, "<span class='objectivesbig'>You're a soulbreaker.</span>")
					to_chat(new_character, "<span class='objectives'>Fulfil the CR quota and break the minds and wills of the kafir in the name of the Allahopressor.</span>")
					new_character << sound('sound/music/soulbreaker.ogg', repeat = 0, wait = 0, volume = 80, channel = 3)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 11)
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 11)
					new_character.my_skills.CHANGE_SKILL(SKILL_UNARM,rand(1,3))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(0,0))
					new_character.my_skills.CHANGE_SKILL(SKILL_MASON, 8)
					new_character.my_skills.CHANGE_SKILL(SKILL_CRAFT, 8)
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC,rand(0,0))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(11,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(11,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURVIV, rand(11,11))
					new_character.my_stats.st = rand(13,14)
					new_character.my_stats.ht = rand(13,14)
					new_character.my_stats.it = rand(9,10)
					new_character.my_stats.dx = rand(9,10)
					new_character.old_job = "Soulbreaker"
					new_character.name = pick(soulbreaker_names)
					soulbreaker_names.Remove(new_character.name)
					new_character.real_name = new_character.name
					new_character.voice_name = new_character.real_name
					new_character.vice = pick(VicesList)
					new_character.age = rand(24,45)
					new_character.voicetype = "strong"
					new_character.religion = "Allah"
					new_character.updatePig()
					new_character.create_kg()
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "Soulbreaker")
							new_character.forceMove(pick(L.loc))
				if("Eunuch1")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					log_game("[new_character.real_name]/[new_character.key] spawned as Soulbreaker Eunuch.")
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/morestamina)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/card/id/ltgrey(new_character), slot_wear_id)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/soulbreaker(new_character), slot_w_uniform)
					var/obj/item/device/radio/R = new /obj/item/device/radio/headset/bracelet/soulbreaker(src)
					R.set_frequency(SYND_FREQ)
					new_character.equip_to_slot_or_del(R, slot_wrist_r)
					new_character.microbomb_soulbreaker()
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.gender = MALE
					new_character.f_style = "Very Long Beard"
					to_chat(new_character, "<span class='objectivesbig'>You're a soulbreaker eunuch.</span>")
					to_chat(new_character, "<span class='objectives'>Fulfil the CR quota while breaking the minds and wills of the kafir in the name of the Allahopressor.</span>")
					new_character << sound('sound/music/soulbreaker.ogg', repeat = 0, wait = 0, volume = 80, channel = 3)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 9)
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 9)
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(11,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_MASON, 8)
					new_character.my_skills.CHANGE_SKILL(SKILL_CRAFT, 8)
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, 11)
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(12,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(11,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(11,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURVIV, rand(11,11))
					new_character.my_stats.st = rand(11,12)
					new_character.my_stats.ht = rand(11,12)
					new_character.my_stats.it = rand(11,12)
					new_character.my_stats.dx = rand(9,10)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/eunuch(new_character), slot_head)
					new_character.old_job = "Soulbreaker Eunuch"
					new_character.name = pick(soulbreaker_names)
					soulbreaker_names.Remove(new_character.name)
					new_character.real_name = "[soulbreaker_eunuch] [new_character.name]"
					new_character.voice_name = new_character.real_name
					new_character.vice = pick(VicesList)
					new_character.age = rand(24,45)
					new_character.voicetype = "strong"
					new_character.mutilate_genitals()
					new_character.religion = "Allah"
					new_character.updatePig()
					new_character.create_kg()
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "Soulbreaker")
							new_character.forceMove(pick(L.loc))
			// COUNTESS
				if("Countess1")
					var/datum/game_mode/siege/S = ticker.mode
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					if(!countess && S.hascount.gender == MALE ||!countess && S.hascount.has_penis())
						new_character.gender = FEMALE
					else
						new_character.gender = MALE
					new_character.real_name = random_name(new_character.gender)
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.vice = pick(VicesList)
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					new_character.voicetype = "noble"
					var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(src)
					R.set_frequency(SYND_FREQ)
					new_character.equip_to_slot_or_del(R, slot_l_ear)
					var/obj/effect/landmark/SG = pick(siegestart)
					new_character.forceMove(SG.loc)
					if(!countess)
						countess = TRUE
						new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 5)
						new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(7,9))
						new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(10,11))
						new_character.my_skills.CHANGE_SKILL(SKILL_RIDE, rand(10,11))
						new_character.my_skills.CHANGE_SKILL(SKILL_COOK, rand(10,12))
						new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(8,8))
						new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(7,7))
						new_character.age = rand(18,30)
						new_character.my_stats.st = rand(9,11)
						new_character.my_stats.dx = rand(13,14)
						new_character.my_stats.ht = rand(10,12)
						new_character.old_job = "Countess"
						new_character.job = "Countess"
						log_game("[new_character.real_name]/[new_character.key] spawned as Countess (LP)")
						new_character.voicetype = "noble"
						if(new_character.gender == FEMALE)
							to_chat(new_character, "<span class='objectivesbig'>You're the Countess.</span>")
							to_chat(new_character, "<span class='objectives'>Stay alive until the end!</span>")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/migrant/baroness(new_character), slot_w_uniform)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/baronessdress(new_character), slot_wear_suit)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(new_character), slot_shoes)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/head/sunhat(new_character), slot_head)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/evening(new_character), slot_gloves)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/minisatchelchurch2(new_character), slot_back)
							if(new_character.back)
								new_character.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/glass/bottle/lifeweb/widowtear(new_character.back), slot_in_backpack)
						else
							to_chat(new_character, "<span class='objectivesbig'>You're the Count.</span>")
							to_chat(new_character, "<span class='objectives'>Stay alive until the end!</span>")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/captain(new_character), slot_w_uniform)
							new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/rapier(new_character), slot_r_hand)
							new_character.equip_to_slot_or_del(new /obj/item/sheath(new_character), slot_belt)
						new_character.add_event("nobleblood", /datum/happiness_event/noble_blood)
						new_character.add_perk(/datum/perk/lessstamina)
						S.siegerslist += new_character
						new_character.siegesoldier = TRUE
						new_character.outsider = TRUE
						new_character.update_all_siege_icons()
						new_character.updatePig()
						new_character.create_kg()
						spawn(5)
						if(S.hascount)
							var/I = image('icons/mob/mob.dmi', loc = new_character, icon_state = "love")
							var/II = image('icons/mob/mob.dmi', loc = S.hascount, icon_state = "love")
							new_character.client.images += II
							S.hascount?.client?.images += I
							matchmaker.setmarriage(S.hascount,new_character)

				if("Sieger1")
					var/datum/game_mode/siege/S = ticker.mode
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.real_name = random_name(new_character.gender)
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.vice = pick(VicesList)
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(src)
					R.set_frequency(SYND_FREQ)
					new_character.equip_to_slot_or_del(R, slot_l_ear)
					to_chat(new_character, "<span class='objectivesbig'> You're the Countess's bodyguard.</span>")
					to_chat(new_character, "<span class='objectives'>Defend your countess at all cost!</span>")
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 9)
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 5)
					new_character.my_skills.CHANGE_SKILL(SKILL_MINE, rand(10,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG, rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(9,9))
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/morestamina)
					new_character.age = rand(17,40)
					new_character.my_stats.st = 11
					new_character.my_stats.dx = rand(9,10)
					new_character.my_stats.ht = rand(10,11)
					new_character.old_job = "Sieger"
					new_character.terriblethings = TRUE
					new_character.job = "Sieger"
					new_character.voicetype = "strong"
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/common(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_breastplate(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/siegehelmet(new_character), slot_head)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
					new_character.equip_to_slot_or_del(new /obj/item/sheath/claymore(new_character), slot_belt)
					log_game("[new_character.real_name]/[new_character.key] spawned as Countess bodyguard.")
					S.siegerslist += new_character
					new_character.siegesoldier = TRUE
					new_character.outsider = TRUE
					new_character.update_all_siege_icons()
					new_character.updatePig()
					new_character.create_kg()
					var/obj/effect/landmark/SG = pick(siegestart)
					new_character.forceMove(SG.loc)

				if("Gink1")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					var/ginklate = pick("Yang","Chi","Chang","Zhao","Huang","Tong","Liao","Qin","Qing","Ming","Wei","Jin","Xia","Yuan","Tang","Sui")
					var/ginkfirst
					new_character.gender = pick(MALE,FEMALE)
					if(new_character.gender == MALE)
						ginkfirst = pick(first_names_male)
					else
						ginkfirst = pick(first_names_female)
					new_character.real_name = "[ginkfirst] [ginklate]"
					new_character.mind.key = OO.key
					new_character.voice_name = new_character.real_name
					new_character.vice = pick(VicesList)
					new_character.name  = new_character.real_name
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					log_game("[new_character.real_name]/[new_character.key] spawned as Gink")
					latepartystarted = TRUE
					hasrolled = TRUE
					new_character << 'ginklate.ogg'
					to_chat(new_character, "<span class='objectives'>Escaping from the overcrowded Wei-Ji and north's xenophobia, you finally find somewhere stable to live.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>Arrive at the fortress.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #2:</span> <span class='objectives'>Find a job.</span>")
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(7,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(7,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(10,11))
					new_character.age = rand(20,35)
					new_character.my_stats.st = rand(9,10)
					new_character.my_stats.dx = rand(10,11)
					new_character.my_stats.ht = rand(8,11)
					new_character.my_stats.it = rand(9,10)
					new_character.old_job = "Gink"
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "Gink")
							new_character.forceMove(L.loc)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/tribal_spear(new_character), slot_r_hand)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/ricehat(new_character), slot_head)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/leatherboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/gink(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
					new_character.updatePig()
					new_character.create_kg()

				if("Counthandgift")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					if(trapapoc.Find(ckey(OO.client.key)))
						new_character.gender = pick(MALE,FEMALE)
					else
						new_character.gender = MALE
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.real_name  = random_name(new_character.gender)
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.vice = pick(VicesList)
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(src)
					R.set_frequency(SYND_FREQ)
					new_character.equip_to_slot_or_del(R, slot_l_ear)
					to_chat(new_character, "<span class='objectivesbig'>You're the Count's hand</span>")
					to_chat(new_character, "<span class='objectives'>Lead your squad to Firethorn and deliver the gift!</span>")
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 12)
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 9)
					new_character.my_skills.CHANGE_SKILL(SKILL_MINE, rand(10,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG, rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(9,9))
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/morestamina)
					new_character.age = rand(28,50)
					new_character.my_stats.st = rand(12,14)
					new_character.my_stats.dx = rand(10,11)
					new_character.my_stats.ht = rand(13,14)
					new_character.old_job = "Count Hand"
					new_character.terriblethings = TRUE
					new_character.job = "Count Hand"
					log_game("[new_character.real_name]/[new_character.key] spawned as Count's Hand(Gift)")
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat/gauntlet/steel(new_character), slot_gloves)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/bastard(new_character), slot_belt)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/lantern/on(new_character), slot_l_hand)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/common(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/countflag(new_character), slot_r_hand)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate(new_character), slot_wear_suit)
					new_character.updatePig()
					new_character.create_kg()
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "Countgift")
							new_character.forceMove(L.loc)
					to_chat(world, "<br>")
					to_chat(world, "<h1 class='ravenheartfortress'>Firethorn Fortress</h1>")
					to_chat(world, "<span class='excomm'><b>¤Urgent message for the Baron!¤</b></span>")
					world << sound('sound/AI/urgent_message.ogg')
					to_chat("<br>")
					for(var/obj/machinery/charon/C in world)
						var/obj/item/weapon/paper/lord/NG = new (C.loc)
						NG.info = "<h2>The count sent a group to Firethorn to deliver us a gift!</h2>"
						evermail_ref.receive(NG, 1)
					new/obj/structure/closet/crate/secure/baron(new_character.loc)

				if("Siegergift")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					if(trapapoc.Find(ckey(OO.client.key)))
						new_character.gender = pick(MALE,FEMALE)
					else
						new_character.gender = MALE
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.real_name  = random_name(new_character.gender)
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.vice = pick(VicesList)
					new_character.voicetype = "strong"
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(src)
					R.set_frequency(SYND_FREQ)
					new_character.equip_to_slot_or_del(R, slot_l_ear)
					to_chat(new_character, "<span class='objectivesbig'> You're the Hand's bodyguard.</span>")
					to_chat(new_character, "<span class='objectives'>Help deliver the gift, protect the hand at all costs!</span>")
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 9)
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 5)
					new_character.my_skills.CHANGE_SKILL(SKILL_MINE, rand(10,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG, rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(9,9))
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/morestamina)
					new_character.age = rand(17,40)
					new_character.my_stats.st = 11
					new_character.my_stats.dx = rand(9,10)
					new_character.my_stats.ht = rand(10,11)
					new_character.old_job = "Grunt"
					new_character.terriblethings = TRUE
					new_character.job = "Grunt"
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/common(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_breastplate(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/siegehelmet(new_character), slot_head)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
					new_character.equip_to_slot_or_del(new /obj/item/sheath/claymore(new_character), slot_belt)
					new_character.updatePig()
					new_character.create_kg()
					log_game("[new_character.real_name]/[new_character.key] spawned as Grunt(gift)")
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "Countgift")
							new_character.forceMove(L.loc)

				if("Thanati1")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.age = rand(18,60)
					new_character.vice = pick(VicesList)
					new_character.gender = MALE
					new_character.real_name = random_name(new_character.gender)
					new_character.terriblethings = TRUE
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					new_character.religion = "Thanati"
					to_chat(new_character, "<span class='baronboldoutlined'>⠀You're part of the [new_character.religion] cult.</span> <span class='baron'>Though, you are not a part of the local cell and should inquire with them about their objectives. Check your memories to see who's your brothers and sisters in faith.</span>")
					new_character << pick('sound/effects/thanati_investigation1.ogg', 'sound/effects/thanati_investigation2.ogg', 'sound/effects/thanati_investigation3.ogg')
					to_chat(new_character, "<span class='objectivesbig'>You are a Thanati militant.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>Eliminate the Inquisition.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #2:</span> <span class='objectives'>Assist the local Thanati cell.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #3:</span> <span class='objectives'>Let them see the light. Convert or kill the residents, in the name of Tzchernobog!</span>")
					var/CorruptWord3 = list("Staza", "Gmysa", "Gxero", "Fgaxa", "Ixero", "Bpah", "Xhot")
					var/CorruptWord4 = list("Gmyhoxe", "Gmyho", "Gzma", "Tzche", "Bog", "Irkhvi")
					var/ThanatiTypes = list("Doll Making", "Malice", "Traps", "Alteration", "Fate", "Grief", "Mind", "Speech")
					new_character.mind.thanati_word_random = "[pick(CorruptWord3) + " " + pick(CorruptWord4)]"
					new_character.mind.thanati_type = pick(ThanatiTypes)
					if(!length(thanatiWords))
						var/CorruptWord = list("Staza", "Gmysa", "Gxero", "Fgaxa", "Ixero", "Bpah", "Xhot")
						var/CorruptWord2 = list("Gmyhoxe", "Gmyho", "Gzma", "Tzche", "Bog", "Irkhvi")
						var/fullWord = "[pick(CorruptWord) + " " + pick(CorruptWord2)]"
						thanatiWords += fullWord
						new_character.mind.thanati_corrupt = pick(thanatiWords)
					else
						new_character.mind.thanati_corrupt = pick(thanatiWords)
					new_character.mind.store_memory("My word is [new_character.mind.thanati_corrupt] and my circle is [new_character.mind.thanati_type]")
					to_chat(new_character, "<span class='baron'>Your corrupt word: [new_character.mind.thanati_corrupt], [new_character.mind.thanati_word_random] (The Circle of [new_character.mind.thanati_type]).</span>\n")
					new_character.verbs += /mob/living/carbon/human/proc/getWords
					new_character.verbs += /mob/living/carbon/human/proc/praisethelord
					new_character.verbs += /mob/living/carbon/human/proc/getBrothers
					log_game("[new_character.real_name]/[new_character.key] spawned as Thanati (LP)")
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "ThanatiLate")
							new_character.forceMove(L.loc)

					new_character.equip_to_slot_or_del(new /obj/item/clothing/mask/silvermask(new_character), slot_wear_mask)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/common/outlaw(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/thanati/thanatilateparty(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/merc_boots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
					var/swordtype = pick("claymore","club","bardiche","spear")
					switch(swordtype)
						if("claymore")
							new_character.equip_to_slot_or_del(new /obj/item/sheath/claymore(new_character), slot_belt)
							new_character.my_skills.CHANGE_SKILL(SKILL_SWORD, 3)
						if("club")
							new_character.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/club, slot_belt)
							new_character.my_skills.CHANGE_SKILL(SKILL_SWING, 3)
						if("bardiche")
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/bardiche(new_character), slot_r_hand)
							new_character.my_skills.CHANGE_SKILL(SKILL_STAFF, 3)
						if("spear")
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/spear(new_character), slot_r_hand)
							new_character.my_skills.CHANGE_SKILL(SKILL_STAFF, 3)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE,rand(9,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE,rand(9,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(6,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC,rand(6,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(12,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(9,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(9,10))
					new_character.my_stats.st = rand(11,12)
					new_character.my_stats.dx = rand(10,11)
					new_character.my_stats.ht = rand(10,11)
					new_character.my_stats.it = rand(9,10)
					new_character.updatePig()
					new_character.create_kg()
					spawn(30)
						new_character << sound('sound/music/thanati2.ogg', repeat = 0, wait = 0, volume = 100, channel = 3)

				if("ThanatiLeader")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.age = rand(18,60)
					new_character.vice = pick(VicesList)
					new_character.gender = MALE
					new_character.real_name = random_name(new_character.gender)
					new_character.terriblethings = TRUE
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					new_character.religion = "Thanati"
					to_chat(new_character, "<span class='baronboldoutlined'>⠀You're part of the [new_character.religion] cult.</span> <span class='baron'>Though, you are not a part of the local cell and should inquire with them about their objectives. Check your memories to see who's your brothers and sisters in faith.</span>")
					new_character << pick('sound/effects/thanati_investigation1.ogg', 'sound/effects/thanati_investigation2.ogg', 'sound/effects/thanati_investigation3.ogg')
					to_chat(new_character, "<span class='objectivesbig'>You are the Thanati militant leader.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>Eliminate the Inquisition.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #2:</span> <span class='objectives'>Assist the local Thanati cell.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #3:</span> <span class='objectives'>Let them see the light. Convert or kill the residents, in the name of Tzchernobog!</span>")
					var/CorruptWord3 = list("Staza", "Gmysa", "Gxero", "Fgaxa", "Ixero", "Bpah", "Xhot")
					var/CorruptWord4 = list("Gmyhoxe", "Gmyho", "Gzma", "Tzche", "Bog", "Irkhvi")
					var/ThanatiTypes = list("Doll Making", "Malice", "Traps", "Alteration", "Fate", "Grief", "Mind", "Speech")
					new_character.mind.thanati_word_random = "[pick(CorruptWord3) + " " + pick(CorruptWord4)]"
					new_character.mind.thanati_type = pick(ThanatiTypes)
					if(!length(thanatiWords))
						var/CorruptWord = list("Staza", "Gmysa", "Gxero", "Fgaxa", "Ixero", "Bpah", "Xhot")
						var/CorruptWord2 = list("Gmyhoxe", "Gmyho", "Gzma", "Tzche", "Bog", "Irkhvi")
						var/fullWord = "[pick(CorruptWord) + " " + pick(CorruptWord2)]"
						thanatiWords += fullWord
						new_character.mind.thanati_corrupt = pick(thanatiWords)
					else
						new_character.mind.thanati_corrupt = pick(thanatiWords)
					new_character.mind.store_memory("My word is [new_character.mind.thanati_corrupt] and my circle is [new_character.mind.thanati_type]")
					to_chat(new_character, "<span class='baron'>Your corrupt word: [new_character.mind.thanati_corrupt], [new_character.mind.thanati_word_random] (The Circle of [new_character.mind.thanati_type]).</span>\n")
					new_character.verbs += /mob/living/carbon/human/proc/getWords
					new_character.verbs += /mob/living/carbon/human/proc/praisethelord
					new_character.verbs += /mob/living/carbon/human/proc/getBrothers
					log_game("[new_character.real_name]/[new_character.key] spawned as Thanati Leader (LP)")
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "ThanatiLate")
							new_character.forceMove(L.loc)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/mask/silvermask(new_character), slot_wear_mask)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/common/outlaw(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/thanati/thanatiblack(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/merc_boots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/new_rifle/thanatikabal(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/drum_thanatikabal(new_character), slot_l_store)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 12)
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 12)
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG, 9)
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, 9)
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, 13)
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(9,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(9,10))
					new_character.my_stats.st = 12
					new_character.my_stats.dx = rand(10,11)
					new_character.my_stats.ht = 12
					new_character.my_stats.it = rand(9,10)
					new_character.updatePig()
					new_character.create_kg()
					spawn(30)
						playsound(new_character.loc, pick('sound/ThanatiLP/ThanatiLP_1.ogg', 'sound/ThanatiLP/ThanatiLP_2.ogg', 'sound/ThanatiLP/ThanatiLP_3.ogg', 'sound/ThanatiLP/ThanatiLP_4.ogg', 'sound/ThanatiLP/ThanatiLP_5.ogg', 'sound/ThanatiLP/ThanatiLP_6.ogg', 'sound/ThanatiLP/ThanatiLP_7.ogg', 'sound/ThanatiLP/ThanatiLP_8.ogg', 'sound/ThanatiLP/ThanatiLP_9.ogg', 'sound/ThanatiLP/ThanatiLP_10.ogg', 'sound/ThanatiLP/ThanatiLP_11.ogg', 'sound/ThanatiLP/ThanatiLP_12.ogg', 'sound/ThanatiLP/ThanatiLP_13.ogg', 'sound/ThanatiLP/ThanatiLP_14.ogg'), 100)
						new_character << sound('sound/music/thanati2.ogg', repeat = 0, wait = 0, volume = 100, channel = 3)

				if("Thanatibomber")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.age = rand(18,60)
					new_character.vice = pick(VicesList)
					new_character.gender = MALE
					new_character.real_name = random_name(new_character.gender)
					new_character.terriblethings = TRUE
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					new_character.religion = "Thanati"
					to_chat(new_character, "<span class='baronboldoutlined'>⠀You're part of the [new_character.religion] cult.</span> <span class='baron'>Though, you are not a part of the local cell and should inquire with them about their objectives. Check your memories to see who's your brothers and sisters in faith.</span>")
					new_character << pick('sound/effects/thanati_investigation1.ogg', 'sound/effects/thanati_investigation2.ogg', 'sound/effects/thanati_investigation3.ogg')
					to_chat(new_character, "<span class='objectivesbig'>You are a Thanati militant specialist.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>Eliminate the Inquisition.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #2:</span> <span class='objectives'>Assist the local Thanati cell.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #3:</span> <span class='objectives'>Let them see the light. Convert or kill the residents, in the name of Tzchernobog!</span>")
					var/CorruptWord3 = list("Staza", "Gmysa", "Gxero", "Fgaxa", "Ixero", "Bpah", "Xhot")
					var/CorruptWord4 = list("Gmyhoxe", "Gmyho", "Gzma", "Tzche", "Bog", "Irkhvi")
					var/ThanatiTypes = list("Doll Making", "Malice", "Traps", "Alteration", "Fate", "Grief", "Mind", "Speech")
					new_character.mind.thanati_word_random = "[pick(CorruptWord3) + " " + pick(CorruptWord4)]"
					new_character.mind.thanati_type = pick(ThanatiTypes)
					if(!length(thanatiWords))
						var/CorruptWord = list("Staza", "Gmysa", "Gxero", "Fgaxa", "Ixero", "Bpah", "Xhot")
						var/CorruptWord2 = list("Gmyhoxe", "Gmyho", "Gzma", "Tzche", "Bog", "Irkhvi")
						var/fullWord = "[pick(CorruptWord) + " " + pick(CorruptWord2)]"
						thanatiWords += fullWord
						new_character.mind.thanati_corrupt = pick(thanatiWords)
					else
						new_character.mind.thanati_corrupt = pick(thanatiWords)
					new_character.mind.store_memory("My word is [new_character.mind.thanati_corrupt] and my circle is [new_character.mind.thanati_type]")
					to_chat(new_character, "<span class='baron'>Your corrupt word: [new_character.mind.thanati_corrupt], [new_character.mind.thanati_word_random] (The Circle of [new_character.mind.thanati_type]).</span>\n")
					new_character.verbs += /mob/living/carbon/human/proc/getWords
					new_character.verbs += /mob/living/carbon/human/proc/praisethelord
					new_character.verbs += /mob/living/carbon/human/proc/getBrothers
					log_game("[new_character.real_name]/[new_character.key] spawned as Thanati Bomber (LP)")
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "ThanatiLate")
							new_character.forceMove(L.loc)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/mask/silvermask(new_character), slot_wear_mask)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/common/outlaw(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/thanati/thanatilateparty(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/merc_boots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/beltsatchelthanati/bomb(new_character), slot_belt)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/minisatchel/satchelthanati(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/lighter/zippo(new_character), slot_l_store)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE,rand(9,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE,rand(9,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(6,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC,rand(6,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(12,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(9,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(9,10))
					new_character.my_stats.st = rand(11,12)
					new_character.my_stats.dx = rand(10,11)
					new_character.my_stats.ht = rand(10,11)
					new_character.my_stats.it = rand(9,10)
					new_character.updatePig()
					new_character.create_kg()
					spawn(30)
						new_character << sound('sound/music/thanati2.ogg', repeat = 0, wait = 0, volume = 100, channel = 3)

				if("SirVandenberg")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.vice = pick(VicesList)
					new_character.terriblethings = TRUE
					to_chat(new_character, "<span class='objectivesbig'>You are Sir Vandenberg.</span> <span class='objectives'>Once apart of Baron Ludruk's highest Order, in secret you married his daughter and planned to run away with her.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>Protect your wife at all costs.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #2:</span> <span class='objectives'>Seek refuge in Firethorn.</span>")
					new_character.age = rand(30,45)
					new_character.real_name  = "Sir Vandenberg"
					new_character.name = new_character.real_name
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.voice_name = new_character.real_name
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = MALE, species = "Human")
					new_character.gender = "male"
					new_character.job = "Sir Vandenberg"
					new_character.my_stats.st = rand(15,16)
					new_character.my_stats.dx = rand(10,11)
					new_character.my_stats.ht = rand(15,16)
					new_character.my_stats.it = rand(10,11)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 15)
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 11)
					new_character.my_skills.CHANGE_SKILL(SKILL_UNARM, 3)
					new_character.my_skills.CHANGE_SKILL(SKILL_SWORD, 3)
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC,rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(11,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(11,11))
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/morestamina)
					new_character.add_perk(/datum/perk/heroiceffort)
					log_game("[new_character.real_name]/[new_character.key] spawned as Sir Vandenberg")
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "SirVandenberg")
							new_character.forceMove(L.loc)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/vandenberg(new_character), slot_l_hand)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate/vandenberg(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/iron(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/bastard(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat/gauntlet/steel(new_character), slot_gloves)
					new_character.updatePig()
					new_character.create_kg()
					spawn(5)
						for(var/mob/living/carbon/human/H in range(4, new_character))
							if(H.gender == FEMALE && H.real_name == "Lady Alicia Vandenberg") //pai e amante
								var/I = image('icons/mob/mob.dmi', loc = new_character, icon_state = "love")
								var/II = image('icons/mob/mob.dmi', loc = H, icon_state = "love")
								new_character.client.images += II
								H?.client?.images += I
								matchmaker.setmarriage(new_character,H)
								H.real_name = "Lady Alicia Vandenberg" // coped
								H.voice_name = H.real_name

				if("LadyVandenberg")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.real_name  = "Lady Alicia Vandenberg"
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.h_style = "Fling"
					new_character.age = rand(18,24)
					new_character.gender = "female"
					new_character.my_stats.st = rand(7,8)
					new_character.my_stats.dx = rand(10,11)
					new_character.my_stats.ht = rand(9,10)
					new_character.my_stats.it = rand(10,11)
					new_character.job = "Lady Vandenberg"
					lady = 1
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 5)
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 9)
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(11,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC,rand(11,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(8,8))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(9,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(9,10))
					to_chat(new_character, "<span class='objectivesbig'>You are Lady Alicia Vandenberg.</span> <span class='objectives'>In secret you married one of your father's most decorated Chevaliers and plan to run away with him.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>Seek refuge in Firethorn.</span>")
					log_game("[new_character.real_name]/[new_character.key] spawned as Lady Vandenberg")
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "LadyVandenberg")
							new_character.forceMove(L.loc)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/migrant/baroness(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/ladydress(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol/ml23/gold(new_character), slot_belt)
					new_character.updatePig()
					new_character.create_kg()

				if("LudrukGuard")
					var/nickname = pick(ludruk_nicknames)
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.voice_name = new_character.real_name
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.gender = MALE
					new_character.terriblethings = TRUE
					new_character.age = rand(30,45)
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = MALE, species = "Human")
					new_character.name = pick(ludruk_names)
					ludruk_names.Remove(new_character.name)
					ludruk_nicknames.Remove(nickname)
					new_character.real_name = "[new_character.name] the [nickname]"
					new_character.voice_name = new_character.real_name
					new_character.my_stats.st = rand(12,13)
					new_character.my_stats.dx = rand(10,11)
					new_character.my_stats.ht = rand(11,12)
					new_character.my_stats.it = rand(9,10)
					new_character.job = "Ludruk's Leper"
					ludruk = 1
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 11)
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 11)
					new_character.my_skills.CHANGE_SKILL(SKILL_UNARM,rand(0,2))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWORD,rand(0,3))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(10,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(9,10))
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/morestamina)
					to_chat(new_character, "<span class='objectivesbig'>You're Baron Ludruk's Leper.</span>")
					to_chat(new_character, "<span class='objectives'>Sir Vandenberg, a once-decorated Chevalier of Baron Ludrook's highest order, has married the Lord's daughter and ran away with her in secret.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>Lord Ludruk wants his daughter back. Seize her and bring her to him safely.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #2:</span> <span class='objectives'>Capture Sir Vandenberg if possible. He must be tried for his crimes!</span>")
					to_chat(new_character, "<span class='objectives'>I should get my gear. The storm's passed just long enough for us to make our move.</span>")
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_character), slot_w_uniform)
					/*new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/leper(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/plebhood/leper(new_character), slot_head)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/legcuffs/bola(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(new_character), slot_l_store)
					var/swordtype = pick("club","mace","spear")
					switch(swordtype)
						if("club")
							new_character.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/club(new_character), slot_belt)
							new_character.my_skills.CHANGE_SKILL(SKILL_SWING, 3)
						if("mace")
							new_character.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/mace(new_character), slot_belt)
							new_character.my_skills.CHANGE_SKILL(SKILL_SWING, 3)
						if("spear")
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/spear(new_character), slot_r_hand)
							new_character.my_skills.CHANGE_SKILL(SKILL_STAFF, 3)*/
					log_game("[new_character.real_name]/[new_character.key] spawned as Leper")
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "LudrukGuard")
							new_character.forceMove(L.loc)
					new_character.updatePig()
					new_character.create_kg()

				if("LudrukGuardCaptain")
					var/nickname = pick(ludruk_nicknames)
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.voice_name = new_character.real_name
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.gender = MALE
					new_character.terriblethings = TRUE
					new_character.age = rand(30,45)
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = MALE, species = "Human")
					new_character.name = pick(ludruk_names)
					ludruk_names.Remove(new_character.name)
					ludruk_nicknames.Remove(nickname)
					new_character.real_name = "[ludruk_captain] [new_character.name] the [nickname]"
					new_character.voice_name = new_character.real_name
					new_character.my_stats.st = rand(13,14)
					new_character.my_stats.dx = rand(10,11)
					new_character.my_stats.ht = rand(13,14)
					new_character.my_stats.it = rand(10,11)
					new_character.job = "Ludruk's Leper"
					ludruk = 1
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, 13)
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, 11)
					new_character.my_skills.CHANGE_SKILL(SKILL_UNARM, 3)
					new_character.my_skills.CHANGE_SKILL(SKILL_SWORD, 4)
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC,rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(10,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(9,10))
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/morestamina)
					to_chat(new_character, "<span class='objectivesbig'>You're the Leper Captain.</span>")
					to_chat(new_character, "<span class='objectives'>Sir Vandenberg, a once-decorated Chevalier of Baron Ludrook's highest order, has married the Lord's daughter and ran away with her in secret.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>Lord Ludruk wants his daughter back. Seize her and bring her to him safely.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #2:</span> <span class='objectives'>Capture Sir Vandenberg if possible. He must be tried for his crimes!</span>")
					to_chat(new_character, "<span class='objectives'>I should get my gear. The storm's passed just long enough for us to make our move.</span>")
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_character), slot_w_uniform)
					/*new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/leper(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/openskulliron(new_character), slot_head)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/sheath/claymore(new_character), slot_belt)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/legcuffs/bola(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(new_character), slot_l_store)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/amulet/gorget/iron(new_character), slot_amulet)*/
					log_game("[new_character.real_name]/[new_character.key] spawned as Leper Captain")
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "LudrukGuard")
							new_character.forceMove(L.loc)
					new_character.updatePig()
					new_character.create_kg()

				if("Mortician")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.gender = pick(MALE,FEMALE)
					new_character.real_name  = random_name(new_character.gender)
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.terriblethings = TRUE
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					new_character.vice = pick(VicesList)
					log_game("[new_character.real_name]/[new_character.key] spawned as mortician (LP)")
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "migstart")
							new_character.forceMove(L.loc)
					to_chat(new_character, "<span class='objectivesbig'> You're a mortician</span>")
					to_chat(new_character, "<span class='objectives'> Get to the fortress and feed your new machine!</span>")
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE,rand(11,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_UNARM,rand(1,2))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE,rand(6,6))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(8,8))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(12,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(6,8))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(10,10))
					new_character.my_stats.st = rand(11,12)
					new_character.my_stats.dx = rand(9,10)
					new_character.my_stats.ht = rand(11,12)
					new_character.my_stats.pr = rand(9,10)
					new_character.old_job = "Mortus"
					new_character.job = "Mortus"
					new_character.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(new_character), slot_wrist_r)
					new_character.equip_to_slot_or_del(new /obj/item/daggerssheath(new_character), slot_wrist_l)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/janitor(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/chisel(new_character), slot_r_store)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/spacecash/c10(new_character), slot_l_store)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(new_character), slot_gloves)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/cell/web/empty(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/ancitech)
					new_character.updatePig()
					new_character.create_kg()

				if("Cerberus")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					if(trapapoc.Find(ckey(OO.client.key)))
						new_character.gender = pick(MALE,FEMALE)
					else
						new_character.gender = MALE
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.real_name  = random_name(new_character.gender)
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.terriblethings = TRUE
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					new_character.vice = pick(VicesList)
					log_game("[new_character.real_name]/[new_character.key] spawned as Cerberus (LP)")
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "migstart")
							new_character.forceMove(L.loc)
					hasrolled = TRUE
					to_chat(new_character, "<span class='objectivesbig'> You're a cerberus</span>")
					to_chat(new_character, "<span class='objectives'> Get to Firethorn fortress and rest your weary legs.</span>")
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(12,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(11,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE,rand(12,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE,rand(11,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_UNARM,rand(0,3))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(11,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(11,11))
					new_character.my_stats.st = rand(12,14)
					new_character.my_stats.dx = rand(9,10)
					new_character.my_stats.ht = rand(12,13)
					new_character.my_stats.pr = rand(11,15)
					new_character.old_job = "Cerberus"
					new_character.job = "Cerberus"
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sechelm/cerbhelm(new_character), slot_r_hand)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/cerberusold(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/taser/leet/sparq(new_character), slot_belt)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_l_hand)
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/morestamina)
					new_character.add_perk(/datum/perk/heroiceffort)
					new_character.updatePig()
					new_character.create_kg()

				if("Inquisitor1")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.age = rand(30,60)
					new_character.vice = pick(VicesList)
					new_character.gender = MALE
					new_character.real_name = random_name(new_character.gender)
					new_character.terriblethings = TRUE
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					new_character.voicetype = "sketchy"
					new_character.religion = "Gray Church"
					to_chat(new_character, "<span class='objectivesbig'>You are the Inquisitor.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>This place is truly Godless. Ensure your practicii teach these sinners.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #2:</span> <span class='objectives'>Seek out what remains of heretical activity in Firethorn.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #3:</span> <span class='objectives'>The crosses must be filled to the brim with worthy men.</span>")
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE,rand(11,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE,rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_UNARM,rand(1,3))
					new_character.my_skills.CHANGE_SKILL(SKILL_KNIFE,rand(1,3))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWING,rand(1,3))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(10,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC,rand(10,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(12,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(15,16))
					new_character.add_perk(/datum/perk/interrogate)
					new_character.add_perk(/datum/perk/morestamina)
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.add_perk(/datum/perk/heroiceffort)
					new_character.verbs += /mob/living/carbon/human/proc/interrogate
					new_character.my_stats.st = rand(11,12)
					new_character.my_stats.dx = rand(11,12)
					new_character.my_stats.ht = rand(11,12)
					new_character.my_stats.it = rand(12,14)
					new_character.my_stats.pr = rand(12,14)
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "InquisitorLate")
							new_character.forceMove(L.loc)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/card/id/churchkeeper(new_character), slot_wear_id)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/general_inquisitor(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/eng(new_character), slot_wrist_r)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/amulet/holy/cross/old(new_character), slot_amulet)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/inqcap(new_character), slot_head)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/inquisitor(new_character), slot_gloves)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/taser/leet/noctis(new_character), slot_belt)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/minisatchelchurch(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/cell/crap/leet/noctis(new_character), slot_l_store)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/melee/baton(new_character), slot_r_hand)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(new_character), slot_r_store)
					/obj/item/weapon/handcuffs
					new_character.old_job = "Inquisitor"
					new_character.job = "Inquisitor"
					if(new_character.wear_id)
						var/obj/item/weapon/card/id/R = new_character.wear_id
						R.registered_name = new_character.real_name
						R.rank = new_character.job
						R.assignment = new_character.job
						R.name = "[R.registered_name]'s Ring"
						R.access = list(church, access_morgue, access_chapel_office, access_maint_tunnels)
					new_character.updatePig()
					new_character.create_kg()

				if("Practicus1")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.age = rand(20,50)
					new_character.vice = pick(VicesList)
					new_character.gender = MALE
					new_character.real_name = random_name(new_character.gender)
					new_character.terriblethings = TRUE
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					to_chat(new_character, "<span class='objectivesbig'>You are a Practicus.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>Seek out what remains of heretical activity in Firethorn.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #2:</span> <span class='objectives'>The crosses must be filled to the brim with worthy men.</span>")
					new_character.voicetype = "sketchy"
					new_character.religion = "Gray Church"
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE,rand(12,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE,rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_UNARM,rand(1,2))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWING,rand(1,2))
					new_character.my_skills.CHANGE_SKILL(SKILL_ENGINE,rand(0,0))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG,rand(7,7))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC,rand(8,8))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB,rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_STEAL,rand(11,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_SWIM,rand(10,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(11,11))
					new_character.add_perk(/datum/perk/morestamina)
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.my_stats.st = rand(12,13)
					new_character.my_stats.dx = rand(9,10)
					new_character.my_stats.ht = rand(11,12)
					new_character.my_stats.it = rand(9,10)
					new_character.my_stats.pr = rand(11,12)
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "PracticusLate")
							new_character.forceMove(L.loc)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/card/id/churchkeeper(new_character), slot_wear_id)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/practicus(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/comissar(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/eng(new_character), slot_wrist_r)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/amulet/holy/cross/old(new_character), slot_amulet)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/taser/leet/noctis(new_character), slot_belt)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/minisatchelchurch(new_character), slot_back)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/cell/crap/leet/noctis(new_character), slot_l_store)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(new_character), slot_r_store)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton(new_character), slot_r_hand)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/hood(new_character), slot_head)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/head/blackbag(new_character), slot_wrist_r)
					new_character.old_job = "Practicus"
					new_character.job = "Practicus"
					if(new_character.wear_id)
						var/obj/item/weapon/card/id/R = new_character.wear_id
						R.registered_name = new_character.real_name
						R.rank = new_character.job
						R.assignment = new_character.job
						R.name = "[R.registered_name]'s Ring"
						R.access = list(church, access_morgue, access_chapel_office, access_maint_tunnels)
					new_character.updatePig()
					new_character.create_kg()

				if("Bandit")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.gender = MALE
					new_character.name = pick(bandit_names)
					bandit_names.Remove(new_character.name)
					new_character.real_name = new_character.name
					new_character.voice_name = new_character.real_name
					new_character.terriblethings = TRUE
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					new_character.vice = pick(VicesList)
					new_character.voicetype = "sketchy"
					log_game("[new_character.real_name]/[new_character.key] spawned as Bandit (LP)")
					new_character.bandit = TRUE
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/common/outlaw(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife/dagger(new_character), slot_r_store)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_r_hand)
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.terriblethings = TRUE
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "Bandit")
							new_character.forceMove(L.loc)
					var/banditweapon = pick("sword","spear","club","mace")
					var/glovetype = pick("gauntlet","leather")
					var/armortype = pick("cuirass","breastplate","plate")
					var/helmettype = pick("elite","neckguard","open","skull")
					switch(glovetype)
						if("gauntlet")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat/gauntlet/steel(new_character), slot_gloves)
						if("leather")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather(new_character), slot_gloves)

					switch(helmettype)
						if("elite")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/elitehelmet(new_character), slot_head)
						if("neckguard")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/head/plebhood(new_character), slot_head)
						if("open")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/ironopenhelmet(new_character), slot_head)
						if("skull")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/openskulliron(new_character), slot_head)

					switch(armortype)
						if("cuirass")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_cuirass(new_character), slot_wear_suit)
						if("breastplate")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_breastplate(new_character), slot_wear_suit)
						if("plate")
							new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate(new_character), slot_wear_suit)

					switch(banditweapon)
						if("sword")
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/falchion(new_character), slot_belt)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/shield/wood(new_character), slot_l_hand)
						if("spear")
							new_character.equip_to_slot_or_del(new /obj/item/weapon/claymore/spear(new_character), slot_l_hand)
						if("club")
							new_character.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/smallclub(new_character), slot_belt)
							new_character.equip_to_slot_or_del(new /obj/item/weapon/shield/wood(new_character), slot_l_hand)
						if("mace")
							new_character.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/club/bronze(new_character), slot_l_hand)
					to_chat(new_character, "<span class='objectivesbig'>You are a Bandit.</span>")
					to_chat(new_character, "<span class='objectives'>Our highwaymen are growing restless, and our troop is unsustainable with our current provisions.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>Take over the village. Let the Lord know we mean business.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #2:</span> <span class='objectives'>We'll need some extra supplies. Do whatever is necessary to obtain them.</span>")
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(12,12))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(8,8))
					new_character.my_skills.CHANGE_SKILL(SKILL_COOK, rand(4,7))
					new_character.my_skills.CHANGE_SKILL(SKILL_MASON, 8)
					new_character.my_skills.CHANGE_SKILL(SKILL_CRAFT, 8)
					new_character.my_skills.CHANGE_SKILL(SKILL_ENGINE, rand(0,0))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG, rand(0,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(0,10))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLEAN, rand(0,0))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(10,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_STEAL, rand(8,9))
					new_character.my_stats.st = rand(12,13)
					new_character.my_stats.ht = rand(11,13)
					new_character.my_stats.dx = rand(9,10)
					new_character.my_stats.it = rand(7,9)
					new_character.create_kg()
					new_character.updatePig()

				if("Nephi")
					var/mob/living/carbon/human/new_character = new(pick(latejoin))
					new_character.key = OO.key
					new_character.mind.key = OO.key
					new_character.age = rand(20,40)
					new_character.vice = pick(VicesList)
					new_character.gender = MALE
					new_character.real_name = "9-Iron Nephi"
					new_character.terriblethings = TRUE
					new_character.bandit = TRUE
					new_character.name = new_character.real_name
					new_character.voice_name = new_character.real_name
					new_character.h_style = random_hair_style(gender = new_character.gender, species = "Human")
					new_character.f_style = random_facial_hair_style(gender = new_character.gender, species = "Human")
					to_chat(new_character, "<span class='objectivesbig'>You are 9-Iron Nephi.</span>")
					to_chat(new_character, "<span class='objectives'>You're the leader of this troop, and the men need a big score tonight.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #1:</span> <span class='objectives'>Take over the village. Let the Lord know we mean business.</span>")
					to_chat(new_character, "<span class='baronboldoutlined'>Objective #2:</span> <span class='objectives'>We'll need some extra supplies. Do whatever is necessary to obtain them.</span>")
					new_character.voicetype = "sketchy"
					new_character.religion = "Gray Church"
					new_character.equip_to_slot_or_del(new /obj/item/clothing/under/rank/hydroponics(new_character), slot_w_uniform)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(new_character), slot_gloves)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/flame/torch/on(new_character), slot_r_hand)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/fjacket(new_character), slot_wear_suit)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(new_character), slot_shoes)
					new_character.equip_to_slot_or_del(new /obj/item/clothing/mask/ironmask(new_character), slot_wear_mask)
					new_character.equip_to_slot_or_del(new /obj/item/weapon/melee/golfclub(new_character), slot_belt)
					new_character.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(13,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(11,11))
					new_character.my_skills.CHANGE_SKILL(SKILL_COOK, rand(4,7))
					new_character.my_skills.CHANGE_SKILL(SKILL_MASON, 8)
					new_character.my_skills.CHANGE_SKILL(SKILL_CRAFT, 8)
					new_character.my_skills.CHANGE_SKILL(SKILL_ENGINE, rand(0,0))
					new_character.my_skills.CHANGE_SKILL(SKILL_SURG, rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(9,9))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLEAN, rand(0,0))
					new_character.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(12,13))
					new_character.my_skills.CHANGE_SKILL(SKILL_STEAL, rand(11,13))
					new_character.my_stats.st = 13
					new_character.my_stats.ht = 13
					new_character.my_stats.dx = rand(10,11)
					new_character.my_stats.it = rand(7,9)
					new_character.add_perk(/datum/perk/morestamina)
					new_character.add_perk(/datum/perk/ref/strongback)
					new_character.create_kg()
					new_character.updatePig()
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "Bandit")
							new_character.forceMove(L.loc)

			possiblefates.Remove(chosen)
			candidatos.Remove(OO)
			partying = 1
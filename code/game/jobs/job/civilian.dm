//Food
/*
/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(access_hydroponics, access_bar, access_kitchen, access_morgue)
	minimal_access = list(access_bar)


	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/bartender(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/bar(H), slot_belt)
		return 1

*/
/datum/job/tribvet
	title = "Tribunal Veteran"
	titlebr = "Veterano do Tribunal"
	flag = TRIBVET
	department_head = list("Head of Personnel")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "Life"
	jobdesc = "Once apart of the King’s Army, you have lost your legs and with it your service. However, you have gained acknowledgement and respect - so far as that will take you in a wheelchair."
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/ltgrey
	access = list()
	minimal_access = list()
	latejoin_locked = FALSE
	thanati_chance = 1
	sex_lock = MALE
	minimal_character_age = 25

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		if(H?.client?.info?.chromosomes >= 5)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/ordinator/old(H), slot_w_uniform)
			if(prob(20))
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/vest/flakjacket/old/coat(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/ordinator/old/vietnam(H), slot_head)
			else
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/vest/flakjacket/old(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/ordinator/old(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/grinder/old(H), slot_back)
			if(prob(50))
				H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/grinder(H), slot_r_store)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/under/ordinator(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/vest/flakjacket(H), slot_wear_suit)
			var/pickhat = rand(1,2)
			switch(pickhat)
				if(1)
					H.equip_to_slot_or_del(new /obj/item/clothing/head/fedora(H), slot_head)
				if(2)
					H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), slot_head)
		H.nutrition = 200
		H.add_perk(/datum/perk/lessstamina)
		H.hidratacao = 150
		for(var/obj/item/weapon/reagent_containers/food/snacks/organ/O in H.organ_storage)
			O.bumorgans()
		for(var/organ_name in list("l_foot","r_foot","l_leg","r_leg"))
			var/datum/organ/external/O = H.get_organ(organ_name)
			//O.amputated = TRUE
			//O.status |= ORGAN_ROBOT
			O.amputated = TRUE
			O.droplimb(1,0,0, TRUE)
		return 1

/datum/job/chef
	title = "Innkeeper"
	titlebr = "Taverneiro"
	flag = CHEF
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the baron"
	jobdesc = "The owner of The Old Cock inn. The people are hungry, and you&#8217;re starving for their coin, so feed them! You know just about everyone, and get to hear rumors from those temporarily passing through Firethorn. The soilers often grow the ingredients you use for your delicious stews and provide the arellit meat for your juicy burgers, and they know you&#8217;re not cheap."
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/ltgrey
	access = list(innkeep)
	minimal_access = list(innkeep)
	thanati_chance = 75
	sex_lock = MALE
	money = 14

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/soviet(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/rag(H), slot_r_store)
		H.add_perk(/datum/perk/lessstamina)
		return 1

/datum/job/chefwife
	title = "Innkeeper Wife"
	titlebr = "Esposa do Taverneiro"
	flag = INNKEEPERWIFE
	department_head = list("Head of Personnel")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the baron"
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/ltgrey
	access = list(innkeep)
	minimal_access = list(innkeep)
	jobdesc = "The darling wife of the Innkeeper - you run a family business. Loving your husband and cooking food while he tends to the hungry patrons is often your daily excercise. Some men flash awry looks at you, but its often met by the sound of a pumping shotgun."
	thanati_chance = 75
	money = 13
	sex_lock = FEMALE

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		if(H.gender == MALE)
			H.voicetype = "noble"
			H.equip_to_slot_or_del(new /obj/item/clothing/under/soviet(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/weapon/rag(H), slot_r_store)
			H.add_perk(/datum/perk/lessstamina)
			return 1

		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/soviet(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/wife(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/rag(H), slot_r_store)
		H.add_perk(/datum/perk/lessstamina)
		return 1

/datum/job/chefwife/set_runtime_title(var/mob/living/carbon/human/H)
	for(var/datum/relation/family/R in H.mind.relations)
		if(R.relation_holder.current.job == "Innkeeper")
			return "Innkeeper [R.connected_relation.name]"
	return "Innkeeper Consociate"

/datum/job/butler
	title = "Butler"
	titlebr = "Mordomo"
	flag = BUTLER
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the baron"
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/ltgrey
	access = list(keep)
	minimal_access = list(keep)
	jobdesc = "The chief manservant and personal servant to the Baron. You handle all predictable and unpredictable needs of the household. Be it organizing stock for the scullery, preparing food for the Baron&#8217;s family and his guests, or arranging social events at the cost of the treasury."
	thanati_chance = 75
	money = 27
	latejoin_locked = TRUE
	sex_lock = MALE

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/butler(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/butler(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/rag(H), slot_r_store)
		H.add_perk(/datum/perk/lessstamina)
		return 1

/datum/job/sitzfrau
	title = "Sitzfrau"
	titlebr = "Sitzfrau"
	flag = SITZFRAU
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	jobdesc = "The head housekeeper of the Baron&#8217;s female staff and personal servant. Your pecking order consists of the maids and child servants beneath you. Being the sole teacher and caretaker responsible for the upbringing Baron&#8217;s progeny, they consider you as much a mother as their real one."
	jobdescbr = "The head housekeeper of the Baron&#8217;s female staff and personal servant. Your pecking order consists of the maids and child servants beneath you. Being the sole teacher and caretaker responsible for the upbringing Baron&#8217;s progeny, they consider you as much a mother as their real one."
	supervisors = "the baron"
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/ltgrey
	access = list(keep)
	minimal_access = list(keep)
	thanati_chance = 75
	latejoin_locked = TRUE
	sex_lock = FEMALE
	money = 25

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/sitzfrau(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/rag(H), slot_r_store)
		H.add_perk(/datum/perk/lessstamina)
		return 1

/datum/job/consyte
	title = "Prophet"
	titlebr = "Profeta"
	flag = CONSYTE
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the spark."
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/ltgrey
	access = list()
	minimal_access = list()
	jobdesc = "A heretic miracle worker who&#8217;s usefulness to the residents of the fortress has granted them temporary amnesty from execution. Said to belong to the Cult of Cons, the Consytes and some unknowing residents refer to him as the &#8217;Prophet&#8217; - blasphemy, if you&#8217;ve ever heard it. Able to receive and recite visions in great detail before they happen, the Bishop often dissuades any acknowledgement to these &#8217;Truths&#8217;. But sometimes you can&#8217;t help but feel its not a coincidence..."
	jobdescbr = "A heretic miracle worker who&#8217;s usefulness to the residents of the fortress has granted them temporary amnesty from execution. Said to belong to the Cult of Cons, the Consytes and some unknowing residents refer to him as the &#8217;Prophet&#8217; - blasphemy, if you&#8217;ve ever heard it. Able to receive and recite visions in great detail before they happen, the Bishop often dissuades any acknowledgement to these &#8217;Truths&#8217;. But sometimes you can&#8217;t help but feel its not a coincidence..."

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/consyte(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/consyte(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/brown(H), slot_shoes)
		H.verbs += /mob/living/carbon/human/verb/respark
		H.verbs += /mob/living/carbon/human/verb/choir
		H.add_perk(/datum/perk/morestamina)
		H.consyte = TRUE
		H.religion = "ConsCult"
		H.status_flags |= STATUS_NO_PAIN
		return 1

/mob/living/carbon/human/verb/respark()
	set name = "respark"
	set desc="Brings someone back to life!"

	if(!consyte)
		return

	var/turf/T = get_step(src, dir)
	for(var/mob/living/carbon/human/H in T.contents)
		if(H.stat != DEAD)
			to_chat(src, "They're still alive.")
			return
		if(src.species.name != "Human" && src.species.name != "Child")
			return
		if(iszombie(H) || H.isVampire)
			return
		var/datum/organ/external/affectedorgan = H.get_organ(BP_HEAD)
		if(affectedorgan.amputated || affectedorgan.status & ORGAN_DESTROYED)
			return
		visible_message("<span class='examinebold'>[src]</span> <span class='examine'>bends down and kisses</span> <span class='examinebold'>[H]</span><span class='examine'> on the lips.</span>")
		H.respark_revival()
		H.verbs += /mob/living/carbon/human/verb/respark
		H.verbs += /mob/living/carbon/human/verb/choir
		H.consyte = TRUE
		H.religion = "ConsCult"
		return 1
/*
	if(!isturf(loc)){
		return
	}

	var/turf/F = get_step(src, dir)
	for(var/mob/living/carbon/human/H in F.contents){
		if(H.species.name != "Human"){
			return
		}
		if(H.stat != DEAD){
			return
		}
		if(iszombie(H) || iszombie(src)){
			return
		}
		if(H == src)
			return
		var/datum/organ/external/affectedorgan = H.get_organ(BP_HEAD)
		if(affectedorgan.amputated || affectedorgan.status & ORGAN_DESTROYED)
			return


		visible_message("<span class='bname'>[src]</span> bends down and kisses [H] on the lips.")
		H.respark_revival()
		H.verbs += /mob/living/carbon/human/proc/respark
		H.verbs += /mob/living/carbon/human/proc/choir
		return 1
	}
	for(var/mob/living/carbon/human/H in loc.contents){
		if(H.species.name != "Human"){
			return
		}
		if(H.stat != DEAD){
			return
		}
		if(iszombie(H) || iszombie(src)){
			return
		}

		var/datum/organ/external/affectedorgan = H.get_organ(BP_HEAD)
		if(affectedorgan.amputated || affectedorgan.status & ORGAN_DESTROYED)
			return
		visible_message("<span class='bname'>[src]</span> bends down and kisses [H] on the lips.")
		H.respark_revival()
		H.verbs += /mob/living/carbon/human/proc/respark
		H.verbs += /mob/living/carbon/human/proc/choir
		return 1
	}
	to_chat(src, "There's no one nearby to revive.")
	return
*/
/mob/living/carbon/human/verb/choir()
	set hidden = 0
	set category = "Consyte"
	set name = "Choir"
	if(!consyte)
		return
	if(!consyte_voice)
		consyte_voice = sanitize(input("Choose a name for the choir.","[src.real_name]",consyte_voice))
		if(!consyte_voice)
			return
		if(findtext(consyte_voice, "http"))
			return
	var/consytemessage = sanitize(input("CHOIR!","[src.consyte_voice]") as message)
	if(!consytemessage)
		return
	if(findtext(consytemessage, "http"))
		return
	for(var/mob/living/carbon/human/L in player_list)
		if(L.consyte)
			to_chat(L, "<span class='bname'>[consyte_voice] \[Consyte's Choir]</span> <i>sings,</i> \"[consytemessage]\"")

/datum/job/urchin
	title = "Urchin"
	titlebr = "Garoto de Rua"
	flag = URCHIN
	department_head = list("Head of Personnel")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = -1
	supervisors = "No one"
	selection_color = "#dddddd"
	access = list()
	minimal_access = list()
	jobdesc = "Lost street kids are littered among the homeless in Firethorn. Often starting an early life of crime, they are malleable to the influences of the more opportunistic residents. Downtrodden and without a home to return to, they often find themselves turning to the local consyte for shelter and food."
	jobdescbr = "Lost street kids are littered among the homeless in Firethorn. Often starting an early life of crime, they are malleable to the influences of the more opportunistic residents. Downtrodden and without a home to return to, they often find themselves turning to the local consyte for shelter and food."

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.set_species("Child")
		var/regex/R = regex("(^\\S+) (.*$)")
		R.Find(H.real_name)
		var/first_name = R.group[1]
		H.religion = "Gray Church"
		H.real_name =  "[first_name]"
		H.name = H.real_name
		H.verbs += /mob/living/carbon/human/proc/tellTheTruth
		if(prob(80))
			H.add_perk(/datum/perk/illiterate)
		for(var/obj/item/weapon/reagent_containers/food/snacks/organ/O in H.organ_storage)
			O.bumorgans()
		H.equip_to_slot_or_del(new /obj/item/clothing/under/urchin(H), slot_w_uniform)
		var/pickitem = pick("knife","syringe","teddybear","teddybear2","dob","coupon","duster")
		switch(pickitem)
			if("knife")
				H.equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife(H), slot_r_store)
			if("syringe")
				H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/syringe(H), slot_r_store)
			if("dob")
				H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/pill/lifeweb/blotter/DOB(H), slot_r_store)
			if("coupon")
				H.equip_to_slot_or_del(new /obj/item/coupon/food(H), slot_r_store)
			if("teddybear1")
				H.equip_to_slot_or_del(new /obj/item/toy/teddybear(H), slot_r_hand)
			if("teddybear2")
				H.equip_to_slot_or_del(new /obj/item/toy/teddybear/pink(H), slot_r_hand)
			if("duster")
				H.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/club/knuckleduster(H), slot_r_hand)
		return 1

/datum/job/bum
	title = "Bum"
	titlebr = "Mendigo"
	flag = HOBO
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 14
	spawn_positions = -1
	supervisors = "No one"
	selection_color = "#dddddd"
	idtype = null
	access = list()
	minimal_access = list()
	jobdesc = "A veteran of the streets, you&#8217;ve lived and breathed them all your life. The rancid smell of the sewers is now numb to your senses and you&#8217;ve survived off the pickings of the dead vermin you find in the dark alleyways. People think you&#8217;re dirt - but the streets have changed you, and you know the truth."
	jobdescbr = "Você perdeu uma vida decente, o respeito da sociedade e sua própria mente, e não se arrepende de nada. Hoje à noite alguém vai te matar só por diversão."

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		var/regex/R = regex("(^\\S+) (.*$)")
		R.Find(H.real_name)
		var/first_name = R.group[1]
		H.voicetype = pick("hobo")
		H.religion = "Gray Church"
		H.real_name =  "[first_name]"
		H.name = H.real_name
		H.hygiene = -400
		H.nutrition = rand(80, 180)
		H.hidratacao = 150
		H.verbs += /mob/living/carbon/human/proc/tellTheTruth
		if(prob(80))
			H.add_perk(/datum/perk/illiterate)
		if(prob(5))
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol/magnum66/screamer23(H), slot_l_hand)
			H.my_skills.ADD_SKILL(SKILL_RANGE, 11)
		for(var/obj/item/weapon/reagent_containers/food/snacks/organ/O in H.organ_storage)
			O.bumorgans()
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/migrant/bum(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka/nushanka(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/watch, slot_wrist_r)
		if(H?.client.info.chromosomes >= 5)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/veteran_bum(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/veteran_bum(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/veteran_bum(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/veteran_bum(H), slot_gloves)

		var/pickitem = pick("knife","syringe","teddybear","teddybear2","dob","coupon","duster","switchblade")
		switch(pickitem)
			if("knife")
				H.equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife(H), slot_r_store)
			if("syringe")
				H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/syringe/heroin(H), slot_r_store)
			if("dob")
				H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/pill/lifeweb/blotter/DOB(H), slot_r_store)
			if("coupon")
				H.equip_to_slot_or_del(new /obj/item/coupon/food(H), slot_r_store)
			if("teddybear1")
				H.equip_to_slot_or_del(new /obj/item/toy/teddybear(H), slot_r_hand)
			if("teddybear2")
				H.equip_to_slot_or_del(new /obj/item/toy/teddybear/pink(H), slot_r_hand)
			if("duster")
				H.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/club/knuckleduster(H), slot_r_hand)
			if("switchblade")
				H.equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife/switchblade(H), slot_r_hand)
		if(prob(2))
			H.real_name =  "[first_name] The Strong"
			H.name = H.real_name
			H.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(13,13))
			H.my_stats.st = rand(18,25)
			H.my_stats.ht = rand(20,25)
			H.my_stats.dx = rand(12,15)
			H.my_stats.it = rand(3,5)
			if(H.gender != FEMALE)
				H.mutations += FAT
		return 1


/datum/job/mercenary
	title = "Mercenary"
	titlebr = "Mercenário"
	flag = MERC
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 8
	spawn_positions = 3
	selection_color = "#ffeeee"
	idtype = /obj/item/weapon/card/id
	access = list()
	jobdesc = "A sellsword of Firethorn, you joined the local mercenary&#8217;s guild for a chance of landing a paying job. You have yet to find one."
	minimal_access = list()
	latejoin_locked = FALSE
	thanati_chance = 12
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/heroiceffort)
		H.add_perk(/datum/perk/morestamina)
		H.terriblethings = TRUE
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
		H.create_kg()
		H.can_stand = 0
		H.sleeping = 500
		H.stat = UNCONSCIOUS
		H.voicetype = pick("noble","strong","sketchy")
		H.verbs += /mob/living/carbon/human/proc/pegaclassemerc
		H.updatePig()
		return 1


/mob/living/carbon/human/proc/pegaclassemerc()
	set hidden = 0
	set category = "Migrant"
	set name = "PegaclasseMerc"
	set desc="Choose your Merc class!"
	var/list/mercList = list("Mercenary")
	if(migclass)
		return
	if(reddawn_merc.Find(src.ckey))
		mercList.Add("Ex-Red Dawn Mercenary")
	if(seaspotter_merc.Find(src.ckey))
		mercList.Add("Ex-Seaspotter Mercenary")
	sleep(10)
	if(migclass)
		return
	var/mercClass = input(src,"Select a mercenary type.","MERCENARIES") in mercList
	sleep(1)
	if(migclass)
		return
	switch(mercClass)
		if("Mercenary")
			src.job = "Mercenary"
			src.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/leather(src), slot_wear_suit)
			src.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(src), slot_wrist_l)
			src.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/merc_boots(src), slot_shoes)
		if("Ex-Red Dawn Mercenary")
			src.job = "Mercenary"
			src.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/leather/reddawn(src), slot_wear_suit)
			src.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(src), slot_wrist_l)
			src.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(src), slot_shoes)

			src.my_skills.ADD_SKILL(SKILL_CLIMB, 4)
			src.my_skills.ADD_SKILL(SKILL_RANGE, 2)
			src.my_skills.ADD_SKILL(SKILL_MELEE, 1)

		if("Ex-Seaspotter Mercenary")
			src.job = "Mercenary"
			src.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/leather/seaspotter(src), slot_wear_suit)
			src.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(src), slot_wrist_l)
			src.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(src), slot_shoes)

			src.my_skills.ADD_SKILL(SKILL_SWIM, 4)
			src.my_skills.ADD_SKILL(SKILL_RANGE, 1)

	if(src.ckey in black_cloak)
		src.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/merccloak(src), slot_back)
	var/list/mercWeapons = list("Axe","Spear","Sword","Club")
	sleep(10)
	if(migclass)
		return
	var/mercWeapon = input(src,"Select a starter weapon from the list.","MERCENARIES") in mercWeapons
	if(migclass)
		return
	switch(mercWeapon)
		if("Axe")
			src.equip_to_slot_or_del(new /obj/item/weapon/hatchet(src), slot_l_hand)
			src.my_skills.CHANGE_SKILL(SKILL_SWING, rand(0,3))
		if("Spear")
			src.equip_to_slot_or_del(new /obj/item/weapon/claymore/spear(src), slot_l_hand)
			src.my_skills.CHANGE_SKILL(SKILL_STAFF, rand(0,3))
		if("Sword")
			src.equip_to_slot_or_del(new /obj/item/sheath/claymore(src), slot_l_hand)
			src.my_skills.CHANGE_SKILL(SKILL_SWORD, rand(0,3))
		/*if("Combat Knives")
			src.equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife/combat(src), slot_l_hand)
			src.equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife/combat(src), slot_r_hand)
			src.my_skills.CHANGE_SKILL(SKILL_KNIFE, rand(0,3))*/
		if("Club")
			src.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/mace(src), slot_l_hand)
			src.my_skills.CHANGE_SKILL(SKILL_SWING, rand(0,3))
	src.can_stand = 1
	src.sleeping = 0
	src.stat = CONSCIOUS
	src.migclass = "Mercenary"

/datum/job/jester
	title = "Jester"
	titlebr = "Bobo da corte"
	flag = CLOWN
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	jobdesc = "A sufferer of dwarfism whose talent for being small and making a fool of himself has brought him to the attention of the Baron&#8217;s court. His limitless ability for self-deprecation is often met with those laughing at him - not with him."
	total_positions = 1
	spawn_positions = 1
	supervisors = "the duke"
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/ltgrey
	access = list(keep)
	minimal_access = list(keep)
	thanati_chance = 90
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		if(H.species.name == "Midget")
			H.voicetype = "midget"
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jester_suit(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/jester_hat(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jester_shoes(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol/jester(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/grenade/syndieminibomb/frag/fake(H), slot_l_hand)
			H.combat_music = pick('jester_combat.ogg')
			H.add_perk(/datum/perk/lessstamina)
			H.add_perk(/datum/perk/singer)
			H.height = rand(100,130)
			H << sound(H.combat_music, repeat = 1, wait = 0, volume = 50, channel = 12)
			H << sound(null, repeat = 0, wait = 0, volume = 0, channel = 12)
			H.create_kg()
			H.my_skills.CHANGE_SKILL(SKILL_MELEE, 5)
			H.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(8,8))
			H.my_skills.CHANGE_SKILL(SKILL_MUSIC, 9)
			H.my_skills.CHANGE_SKILL(SKILL_UNARM, rand(0,2))
			H.my_skills.CHANGE_SKILL(SKILL_CLEAN, rand(0,0))
			H.my_skills.CHANGE_SKILL(SKILL_CLIMB, 9)
			H.my_skills.CHANGE_SKILL(SKILL_BOAT, 10)
			H.my_stats.st = rand(9,15)
			H.my_stats.ht = rand(10,12)
			H.my_stats.dx = rand(6,7)
			H.my_stats.it = rand(9,10)
			H.my_stats.pr = rand(8,9)
			H.verbs += /mob/living/carbon/human/proc/apelidar
			H.verbs += /mob/living/carbon/human/proc/malabares
			H.verbs += /mob/living/carbon/human/proc/rememberjoke
			H.verbs += /mob/living/carbon/human/proc/joke
			H.verbs += /mob/living/carbon/human/proc/remembersong
			H.verbs += /mob/living/carbon/human/proc/sing
			return 1
		else
			H.voicetype = "midget"
			idtype = /obj/item/weapon/card/id/jester
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/jester_court(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/jester_court(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jester_court(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/jester(H), slot_gloves)
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol/jester(H), slot_r_store)
			H.equip_to_slot_or_del(new /obj/item/weapon/grenade/syndieminibomb/frag/fake(H), slot_l_store)
			H.verbs += /mob/living/carbon/human/proc/apelidar
			H.verbs += /mob/living/carbon/human/proc/malabares
			H.verbs += /mob/living/carbon/human/proc/rememberjoke
			H.verbs += /mob/living/carbon/human/proc/joke
			H.verbs += /mob/living/carbon/human/proc/remembersong
			H.verbs += /mob/living/carbon/human/proc/sing
			H.acrobat = 1
			H.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(6,6))
			H.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(12,12))
			H.my_skills.CHANGE_SKILL(SKILL_FARM, rand(0,0))
			H.my_skills.CHANGE_SKILL(SKILL_COOK, rand(7,7))
			H.my_skills.CHANGE_SKILL(SKILL_ENGINE, 0)
			H.my_skills.CHANGE_SKILL(SKILL_SURG, 8)
			H.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(17,17))
			H.my_skills.CHANGE_SKILL(SKILL_MEDIC, rand(5,5))
			H.my_skills.CHANGE_SKILL(SKILL_CLEAN, rand(6,9))
			H.my_skills.CHANGE_SKILL(SKILL_MUSIC, rand(14,17))
			H.my_skills.CHANGE_SKILL(SKILL_THROW, rand(14,16))
			H.my_skills.CHANGE_SKILL(SKILL_STEAL, rand(13,17))
			H.my_skills.CHANGE_SKILL(SKILL_SWIM, rand(12,17))
			H.my_skills.CHANGE_SKILL(SKILL_OBSERV, rand(14,15))
			H.my_stats.st = rand(7,8)
			H.my_stats.ht = rand(8,9)
			H.my_stats.dx = rand(13,16)
			H.my_stats.it = rand(11,12)
			H.my_stats.pr = rand(13,15)
			H.add_perk(/datum/perk/morestamina)
			H.add_perk(/datum/perk/singer)
			H.add_perk(/datum/perk/ref/jumper)
			if(H.wear_id && istype(H.wear_id, /obj/item/weapon/card/id))
				var/obj/item/weapon/card/id/I = H.wear_id
				I.icon_state = "id_jester"
			H.combat_music = pick('jester_combat.ogg')
			H << sound(H.combat_music, repeat = 1, wait = 0, volume = 50, channel = 12)
			H << sound(null, repeat = 0, wait = 0, volume = 0, channel = 12)
			H.create_kg()
			return


/mob/var/nickname = FALSE //if they already have a nickname
/mob/living/carbon/human/var/is_joking = FALSE
/mob/living/carbon/human/var/list/jokes_remembered = list() //jokes remembered by Jester, so he can use them later.

/mob/living/carbon/human/proc/apelidar()
	if(stat) return
	var/list/lista = list()
	for(var/mob/M in view(7))
		lista.Add(M)
	lista.Add("(CANCEL)")
	var/response = input(usr, "Who?", "Who?") in lista
	if(!response)
		return
	var/responseTwo = sanitize(input(usr, "What name?", "What name?")) as text
	if(!length(responseTwo))
		return
	if(stat) return

	if(istype(response, /mob))
		var/mob/M = response
		if(M.nickname)
			to_chat(src, "<span class='combat'>They already have a nickname!</span>")
			return

		log_game("([src.ckey])[src.real_name] gave ([M.ckey])[M.real_name] the nickname: [responseTwo]")
		if(findtext(responseTwo, config.ic_filter_regex))
			src << 'vam_ban.ogg'
			to_chat("THAT'S SO FUNNY!")
			var/datum/organ/internal/heart/HE = (locate() in internal_organs)
			if(HE)
				src.emote("laugh")
				HE.heart_attack()
			else
				src.gib()
			bans.Add(src.client.ckey)
			sleep(30)
			qdel(src.client)
			return
		visible_message("[src.name] gave [M.name] the nickname: [responseTwo]")
		M.nickname = responseTwo

/mob/living/carbon/human/proc/malabares()
	if(malabares)
		qdel(malabares)
		malabares = null
	var/obj/item/I = get_active_hand()
	var/obj/item/II = new(src.loc)
	if(I && II)
		II.icon = I.icon
		II.icon_state = I.icon_state
		malabares = II
		malabares.plane = 15
		malabares.pixel_y = 4
		malabares.transform *= 0.5
		malabares.GireAmigao()

/atom/proc/B()

	var/radius = 10
	var/rotation_speed = 20
	var/rotation_segments = 26
	var/clockwise = FALSE


	var/matrix/M = matrix(transform)
	var/pre_rot = 90
	M.Turn(pre_rot)
	transform = M
	var/matrix/shift = matrix(transform)
	shift.Translate(0, radius)
	transform = shift
	SpinAnimationn(rotation_speed, -1, clockwise, rotation_segments, parallel = FALSE)

/atom/proc/GireAmigao()
	var/icon/I = icon(icon,icon_state,dir)

	var/orbitsize = (I.Width()+I.Height())*10
	orbitsize -= (orbitsize/world.icon_size)*(world.icon_size*2)
	B(src,orbitsize, FALSE, 20, 3)

/atom/proc/SpinAnimationn(speed = 10, loops = -1, clockwise = 1, segments = 3, parallel = TRUE)
	if(!segments)
		return
	var/segment = 360/segments
	if(!clockwise)
		segment = -segment
	var/list/matrices = list()
	for(var/i in 1 to segments-1)
		var/matrix/M = matrix(transform)
		M.Turn(segment*i)
		matrices += M
	var/matrix/last = matrix(transform)
	matrices += last

	speed /= segments

	if(parallel)
		animate(src, transform = matrices[1], time = speed, loops , flags = ANIMATION_PARALLEL)
	else
		animate(src, transform = matrices[1], time = speed, loops)
	for(var/i in 2 to segments) //2 because 1 is covered above
		animate(transform = matrices[i], time = speed)
		//doesn't have an object argument because this is "Stacking" with the animate call above
		//3 billion% intentional

/mob/living/carbon/human/proc/rememberjoke()
	var/list/joke_to_safe
	var/list/begining_list = list("One day, an Inquisitor walks into a brothel", "A Southerner and a Northerner meet each other in the cave", "The Baron returns from the campaign", "A Migrant arrives at the throne room", "The Bookkeeper asks the Baron for a favor", "The Jester decided to make a joke", "A woman calls for help", "The Heir and the Successor locked themselves in a room", "(ANOTHER)")
	if(stat) return
	var/joke_name = sanitize(input(src, "Choose the name of your joke!", "Joke", "") as text)
	if(!length(joke_name))
		return
	var/begining = input(src, "Choose the FIRST PART of your joke!", "Joke") in begining_list
	if(!length(begining))
		return
	var/joke_input = sanitize(input(src, "Joke Plot", "Joke", "") as message, repl_chars = list("\t"="#","ÿ"="&#255;"))
	if(!length(joke_input))
		return
	if(stat) return
	var/list/joke_list = splittext(joke_input, "\n")
	if(begining == "(ANOTHER)")
		if(length(joke_list) < 2)
			to_chat(src, "<span class='combat'>The length of the joke must be at least 2 lines!</span>")
			return
		joke_to_safe = joke_list

	else
		joke_to_safe = list(begining) | joke_list

	jokes_remembered[joke_name] = joke_to_safe
	to_chat(src, "I remember a joke named [joke_name].")
	return


/mob/living/carbon/human/proc/joke()
	if(stat) return
	if(is_joking)
		is_joking = FALSE
		return
	if(!length(jokes_remembered))
		to_chat(src, "<span class='combat'>I don't know any jokes!</span>")
		return
	var/joke_name = input(usr, "Which joke i should use?", "Joke") in jokes_remembered
	if(stat) return
	is_joking = TRUE
	var/the_joke = ""
	for(var/joke_text in jokes_remembered[joke_name])
		if(!is_joking)
			to_chat(src, "<span class='combat'>I need to stop joking!</span>")
			return
		say("poison*[joke_text]")
		the_joke += joke_text
		sleep(20)
	playsound(src.loc, 'sound/effects/badumts.ogg', rand(50,60), 1)
	var/list/funnywords = list("doing", "mom", "fuck", "bum", "inquisitor", "gay", "suspicious", "allah", "heretics", "orphanage", "cock", "dancer", "penis", "ass", "graga", "kthanid", "strygh", "tzanch", "tzchernobog", "thanati", "gmyza", "copetti", "grenade", "gun", "spear", "sword", "explosion", "boom")

	sleep(10)

	var/howfunny = 1 //it was funny. laugh
	if(length(the_joke) > 73)
		howfunny++
	if(findtext(the_joke, funnywords))
		howfunny++



	for(var/mob/living/carbon/human/M in view(7, src))
		if(M == src) continue
		var/stat_math = round((M.my_stats.ht + M.my_stats.it) / 2) + M.my_stats.wp
		var/list/roll_result = roll3d6(M, stat_math, howfunny * -1, FALSE, TRUE)
		switch(roll_result[GP_RESULT])
			if(GP_SUCCESS, GP_CRITSUCCESS)
				spawn(rand(1,3))
					if(roll_result[GP_RESULT] == GP_CRITSUCCESS)
						M.my_stats.wp += 1
					M.emote("laugh")
			if(GP_FAILED)
				spawn(rand(1,3))
					if(prob(50))
						M.emote("laugh")
						M.Weaken(5)
					else
						M.Stun(2)
						M.emote("laugh")
			if(GP_CRITFAIL)
				spawn(rand(1,3))
					if(prob(20 - M.my_stats.ht))
						var/datum/organ/internal/heart/HE = (locate() in M.internal_organs)
						if(HE)
							HE.heart_attack()
					if(prob(45))
						M.Weaken(5)
					if(prob(30))
						M.Stun(2)
					if(prob(20))
						M.handle_piss()
					M.Jitter(100)
					M.emote("laugh")
					spawn(20)
						M.emote("gasp")
	is_joking = FALSE


/datum/job/hydro
	title = "Soiler"
	titlebr = "Agricultor"
	flag = BOTANIST
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the Duke and the Chef."
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/hydro
	access = list(soilery)
	minimal_access = list(soilery)
	jobdesc = "The life blood of the fort. Many people rely on you to supply crops. They provide Firethorn with its freshest produce and arellits for both food and riding. Most of Firethorn&#8217;s food production is domestic and bought locally from the soilers who market to both individuals and businesses within the fort."
	jobdescbr = "The life blood of the fort. Many people rely on you to supply crops. They provide Firethorn with its freshest produce and arellits for both food and riding. Most of Firethorn&#8217;s food production is domestic and bought locally from the soilers who market to both individuals and businesses within the fort."
	thanati_chance = 75
	money = 5
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "strong"
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/hydroponics(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/leatherboots(H), slot_shoes)
		//H.equip_to_slot_or_del(new /obj/item/device/analyzer/plant_analyzer(H), slot_s_store)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/minerapron(H), slot_wear_suit)
		H.add_perk(/datum/perk/illiterate)
		H.add_perk(/datum/perk/ref/strongback)
		H.create_kg()
		return 1



//Cargo

/datum/job/qm
	title = "Bookkeeper"
	titlebr = "Agente de Vendas"
	flag = QUARTERMASTER
	department_head = list("Duke")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the merchant guild"
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/qm
	access = list(merchant)
	minimal_access = list(merchant)
	latejoin_locked = TRUE
	thanati_chance = 33
	jobdesc = "A newcomer from somewhere in the east, rumors say he&#8217;s a known book maker and came to Firethorn to outrun tribunal troops."
	jobdescbr = "A newcomer from somewhere in the east, rumors say he&#8217;s a known book maker and came to Firethorn to outrun tribunal troops."
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/new_cut_alt(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/new_cut(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/new_cut(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/cap(H), slot_head)
		//H.jewish = TRUE
		H.add_perk(/datum/perk/ref/value)
		H.create_kg()
		return 1


/datum/job/cargo_tech
	title = "Grayhound"
	titlebr = "Doqueiro"
	flag = CARGOTECH
	department_head = list("Bookkeeper")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the merchant and the BARON"
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/qm
	access = list(merchant)
	minimal_access = list(merchant)
	sex_lock = MALE
	money = 12
	jobdesc = "Hired by the Bookkeeper for manual labor, you work their shop and docks by assisting them with unloading their goods from the barge and ensuring they don&#8217;t have to do physical duties. Do it well enough and your boss may be gracious enough to pay you."
	jobdescbr = "Hired by the Bookkeeper for manual labor, you work their shop and docks by assisting them with unloading their goods from the barge and ensuring they don&#8217;t have to do physical duties. Do it well enough and your boss may be gracious enough to pay you."
	thanati_chance = 70
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "strong"
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/new_cut(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/cap(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/new_cut_alt2(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/club/knuckleduster(H), slot_l_store)
		H.add_perk(/datum/perk/docker)
		H.terriblethings = TRUE
		H.add_perk(/datum/perk/ref/strongback)
		H.add_perk(/datum/perk/illiterate)
		H.add_perk(/datum/perk/morestamina)
		H.create_kg()
		return 1
/*
/datum/job/mining
	title = "Miner"
	flag = MINER
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/engie
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mint, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mint, access_mining_station, access_mailsorting)


	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "strong"
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cargo (H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/miner(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/shaftminer(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/crowbar(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/bag/ore(H), slot_in_backpack)
		return 1
*/

/datum/job/hooker
	title = "Amuser"
	titlebr = "Prostituta"
	flag = HOOKER
	department_head = list("Trader")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 3
	supervisors = "Your customer and the pusher."
	selection_color = "#ae00ff"
	access = list(amuser)
	minimal_access = list(amuser)
	idtype = /obj/item/weapon/card/id/ltgrey
	sex_lock = FEMALE
	thanati_chance = 75
	money = 3
	jobdesc = "The lady of the night, a seductress who welcomes men into her soft embrace for coin. The pusher is your pimp, and he&#8217;s expecting a cut of the earnings. Enticing men these nights is not that hard - nights get dreary and lonely after all, but with the recent arrival of the Inquisition, you&#8217;ve noticed your frequent visitors become strangely chaste in your presence."
	jobdescbr = "Após a chegada da Inquisição, os homens da fortaleza tornaram-se subitamente ... assexuados. Eles têm medo de uma reeducação que agrada a Deus e incapacitante ou apenas se sublimam em fanatismo, intrigas e expectativa de uma matança? De qualquer forma, você deve se esforçar para lembrá-los de simples alegrias corporais."
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/hooker(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/fetish(H), slot_shoes)
		//H.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.add_perk(/datum/perk/illiterate)
		H.add_perk(/datum/perk/morestamina)
		if(prob(80))
			H.virgin = FALSE
			if(prob(20))
				H.contract_disease(new /datum/disease/aids,1,0)
		return 1

/datum/job/scuff
	title = "Scuff"
	titlebr = "Scuff"
	flag = SCUFF
	department_head = list("Captain")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Your parents."
	selection_color = "#ddddff"
	idtype = /obj/item/weapon/card/id/other
	minimal_player_age = 10
	money = 5
	latejoin_locked = FALSE
	children = TRUE
	//sex_lock = MALE
	access = list(brothel)
	jobdesc = "A street urchin caught up under the pusher&#8217;s influence. He gets you to do menial jobs he can&#8217;t be caught doing, like nicking the jingling bags around people&#8217;s necks and working your way into people&#8217;s pockets. He promises you compensation, too. Sometimes you get your share."
	minimal_access = list(brothel, amuser)
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.set_species("Child")
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/child_jumpsuit(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/shoes(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/scuff(H), slot_wear_suit)
		H.add_perk(/datum/perk/illiterate)
		H.vice = null
		H.height = rand(130,150)
		H.religion = "Gray Church"
		return 1

/datum/job/smuggler
	title = "Pusher"
	titlebr = "Pusher"
	flag = SMUGGLER
	department_head = null
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "The loan sharks and your luck."
	selection_color = "#ae00ff"
	access = list(brothel, amuser)
	minimal_access = list(brothel, amuser)
	idtype = /obj/item/weapon/card/id/ltgrey
	money = 20
	thanati_chance = 75
	jobdesc = "Those who come by the den to purchase your blood plungers range from nobility to dirt, and you&#8217;re here to sell them sex and indulge in all of their immoral hedonism. You hear the kids calling you the coolest person in the fortress, and you make sure that the obol-less bums spend it on a hit once it finally looks like they&#8217;ve made some dough. You&#8217;re looked up to by scoundrels and vermin, and are a target for those looking to challenge your drug trade. You won&#8217;t let that happen."
	jobdescbr = "Those who come by the den to purchase your blood plungers range from nobility to dirt, and you&#8217;re here to sell them sex and indulge in all of their immoral hedonism. You hear the kids calling you the coolest person in the fortress, and you make sure that the obol-less bums spend it on a hit once it finally looks like they&#8217;ve made some dough. You&#8217;re looked up to by scoundrels and vermin, and are a target for those looking to challenge your drug trade. You won&#8217;t let that happen."
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "sketchy"
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/migrant/baroness(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/pusher(H), slot_wear_suit)
		H.mind.time_to_pay = rand(15, 40)
		if(prob(50))
			H.equip_to_slot_or_del(new /obj/item/weapon/flame/lighter/zippo(H), slot_r_store)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife/switchblade(H), slot_r_store)
		H.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/club/knuckleduster(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/briefcase(H), slot_r_hand)
		H.terriblethings = TRUE

		spawn while(H.mind)
			if(!isnum(H.mind.time_to_pay))
				break;
			if(H.mind.time_to_pay <= 0)
				H.mind.time_to_pay = "dead meat."
				for(var/obj/machinery/information_terminal/IM in vending_list)
					IM.pusherize()
				break;
			sleep(550)
			H.mind.time_to_pay--
		return 1

/*
/datum/job/clown
	title = "Clown"
	flag = CLOWN
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(access_clown, access_theatre, access_maint_tunnels)
	minimal_access = list(access_clown, access_theatre)


	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/clown(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/clown_shoes(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/clown(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/snacks/grown/banana(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/bikehorn(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/stamp/clown(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/toy/crayon/rainbow(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/fancy/crayons(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/toy/waterflower(H), slot_in_backpack)
		H.mutations.Add(CLUMSY)
		return 1
*/

/datum/job/janitor
	title = "Misero"
	titlebr = "Misero"
	flag = JANITOR
	department_head = list("Captain")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Baron"
	selection_color = "#dddddd"
	access = list(lifeweb)
	minimal_access = list(lifeweb)
	idtype = /obj/item/weapon/card/id/ltgrey
	jobdesc = "Proven too dumb to be a mortus, the misero cannot work the lifeweb. Instead, he cleans up after the mortii, keeps the streets washed, and deals with the burial of the deceased in the graveyard."
	jobdescbr = "Proven too dumb to be a mortus, the misero cannot work the lifeweb. Instead, he cleans up after the mortii, keeps the streets washed, and deals with the burial of the deceased in the graveyard."
	thanati_chance = 75
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/cheap(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/janitor(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/misero(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/misero(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), slot_glasses)
		H.terriblethings = TRUE
		H.add_perk(/datum/perk/illiterate)
		H.create_kg()
		return 1

//var/global/lawyer = 0//Checks for another lawyer //This changed clothes on 2nd lawyer, both IA get the same dreds.


/datum/job/lawyer
	title = "Patriarch"
	titlebr = "Patriarca"
	flag = LAWYER
	department_head = list("Duke")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the baron and the northern law"
	selection_color = "#dddddd"
	access = list(keep,courtroom)
	minimal_access = list(keep,courtroom)
	sex_lock = MALE
	jobdesc = "The most respected man in the fortress outside of the Baron himself. He is one of the eldest residents, with a large family to show for it. He handles domestic disputes and ensures that the law is adhered. Residents often find themselves coming to him for advice."
	latejoin_locked = FALSE
	thanati_chance = 75
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.voicetype = "noble"
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/internalaffairs(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/merc_boots(H), slot_shoes)
		H.create_kg()
//		H.verbs += /mob/living/carbon/human/proc/execution
//		H.verbs += /mob/living/carbon/human/proc/great_hunt
//		H.verbs += /mob/living/carbon/human/proc/duel
		return 1

/mob/living/carbon/human/proc/execution()
	set hidden = 0
	set category = "Law"
	set name = "Execucao"
	set desc="Executa alguém."
	var/input = sanitize_uni(input(usr, "Nome do julgado.", "What?", "") as message|null)
	if(!input)
		return
	if(!src.anchored && !istype(src.anchored, /obj/structure/stool/bed/chair/comfy/judge))
		return
	world << sound('sound/AI/judgement.ogg')
	command_alert("<b>[input]</b> will be executed in court.", "Patriarch [src] & South's Law");
	log_admin("[key_name(src)] has declared execution on someone: [input]")
	message_admins("[key_name_admin(src)] has created a execution report", 1)

/mob/living/carbon/human/proc/duel()
	set hidden = 0
	set category = "Law"
	set name = "Duelo"
	set desc="Bota pessoas para duelar."
	var/input = sanitize_uni(input(usr, "Nome do julgado.", "What?", "") as message|null)
	var/input2 = sanitize_uni(input(usr, "Nome do outro juglado.", "What?", "") as message|null)
	if(!input)
		return
	if(!input2)
		return
	if(!src.anchored && !istype(src.anchored, /obj/structure/stool/bed/chair/comfy/judge))
		return
	world << sound('sound/AI/judgement.ogg')
	command_alert("<b>[input]</b> e <b>[input2]</b> will duel to their death.", "Patriarch [src] & South's Law")
	log_admin("[key_name(src)] has declared execution on someone: [input]")
	message_admins("[key_name_admin(src)] has created a execution report", 1)

/mob/living/carbon/human/proc/great_hunt()
	set hidden = 0
	set category = "Law"
	set name = "Cacada"
	set desc="Caça alguém."
	var/input = sanitize_uni(input(usr, "Nome do julgado.", "What?", "") as message|null)
	if(!input)
		return
	if(!src.anchored && !istype(src.anchored, /obj/structure/stool/bed/chair/comfy/judge))
		return
	world << sound('sound/AI/judgement.ogg')
	command_alert("A great hunt has been declared on <b>[input]</b>", "Patriarch [src] & South's Law")
	log_admin("[key_name(src)] has declared a great hunt on someone: [input]")
	message_admins("[key_name_admin(src)] has created a great hunt report", 1)

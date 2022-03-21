var/dangerousday = FALSE
var/list/allClothing = list()

/mob/living/carbon
	var/Chosenlover = 0
	var/ChosenChromieGive = 0
	var/ChosenChromieReceive = 0

/obj/item/clothing/New()
    ..()
    allClothing.Add(src)

/obj/item/clothing/Destroy()
    allClothing.Remove(src)
    ..()

#define subtypesof(prototype) (typesof(prototype) - prototype)
/datum/controller/gameticker/proc/pick_round_event()
	var/event_type = pick(subtypesof(/datum/round_event))
	if (event_type)
		var/event = new event_type
		return event
	else
		log_debug("No valid /datum/round_events found.")

/datum/round_event
	var/name = "default"
	var/id = "default"
	var/event_message = "You shouldn't have seen this. Yell at a Pernambucao."
	var/roundstartdisplay = 1

/datum/round_event/proc/apply_event()
	return

/datum/round_event/default
	name = "Quiet Night"
	id = "default"
	roundstartdisplay = 0
	event_message = "It's a quiet night."


/datum/round_event/size_matters
	name = "Size Matters"
	id = "size_matters"

	event_message = "Man's strength is defined by his penis size."

/datum/round_event/weak
	name = "Weak Tradition"
	id = "weak"

	event_message = "It's a tradition in Firethorn to ignore all kinds of physical exercises. Weak and proud!"

/datum/round_event/kidcensor
	name = "Baby Marduk"
	id = "kidcensor"

	event_message = "Abusing DOB during his childhood has prevented a boy's body from growing. To compensate it, he trained a lot, and eventually he became our marduk."

/datum/round_event/helpless
	name = "Helpless Fortress"
	id = "helpless"

	event_message = "Noone in the fortress knows how to fight."

/datum/round_event/helpchildren
	name = "Helpless Fortress?"
	id = "helpchildren"

	event_message = "Noone in the fortress knows how to fight... except children!"


/datum/round_event/erpfaggots
	name = "Eunuch Fortress"
	id = "erp"

	event_message = "A <b>curse</b> has arrived in Firethorn! Most fortress inhabitants were castrated by a demon during their sleep!"
//REMOVE PRETO DA ROTAÇÃO ATÉ ADCIONAR PROBABILIDADE
/*
/datum/round_event/black
	id = "negresco"

*/
/datum/round_event/child
	name = "Strong Kids"
	id = "crianca"

	event_message = "Due to a heavy mix of powerful drugs during pregnancy, many children lost their inteligence, but were rewarded with heavy fists."

/*/datum/round_event/name
	name = "Farewell Gift"
	id = "name"

	event_message = "The last baron died recently, and left a mark! Everyone in the fortress has been renamed to the Baron's name!"*/

/datum/round_event/man
	name = "Only Male"
	id = "machismo"

	event_message = "For some weird reason, all women in the fortress are now male! Must be some sort of curse!"

/datum/round_event/pathologic
	name = "Pathologic"
	id = "pathologic"
	roundstartdisplay = 0
	event_message = "A plague is infecting the fortress, the Haruspex is the salvation!"

/datum/round_event/freedom
	name = "Freedom"
	id = "freedom"

	event_message = "You can go whereever you want."

/*/datum/round_event/polyhedron
	name = "Polyhedron"
	id = "polyhedron"

	event_message = "Recently, some of the local children have been witnessed crafting strange, makeshift masks resembling Ravenheart's barons illustrious Cerberii, and occasionally talking about a strange Polyhedron rumored to be somewhere on Evergreen on the north. Surely it's just the wild imagination of children."
*/ // this shit does not work (the FUCKING item isnt even in the game??? HELLO???)
/datum/round_event/ordinators
	name = "King's Guards"
	id = "ordinators"

	event_message = "The garrison are replaced with Tribunal Ordinators. They have better equipment, but are loyal to the King and their only goal is to keep order."

/datum/round_event/shattereddreams
	name = "Shattered Dreams"
	id = "shattereddreams"

	event_message = "Poor male prostitute by the name of Morgan James, the universal favorite, fell down the roof. Everyone in the fortress is depressed."

/datum/round_event/goldenfortress
	name = "Golden Fortress"
	id = "goldenfortress"

	event_message = "The Baron was a great ruler. The treasury is full."

/*
/datum/round_event/informant
	name = "Informed"
	id = "informant"

	event_message = "All thanati in the fortress got ratted out!"
*/
/datum/round_event/privatesecurity
	name = "Private Security"
	id = "privatesecurity"

	event_message = "The Bookkeeper was forced to hire goons to protect himself."

/datum/round_event/bankrupt
	name = "Bankrupt"
	id = "bankrupt"

	event_message = "The baron has lost all the treasury to his gamble habit."

/datum/round_event/gifted
	name = "Dark Nights"
	id = "gifted"

	event_message = "The fortress is not known to be bright."

/datum/round_event/united
	name = "United"
	id = "united"
	roundstartdisplay = 0
	event_message = "Everyone in the fortress shares the same vice."

/datum/round_event/childbaron
	name = "Child Baron"
	id = "childbaron"

	event_message = "The Baron celebrates his 13th birthday today!"

/datum/round_event/crowded
	name = "Crowded"
	id = "crowded"

	event_message = "There is a meeting in the throne room!"

/datum/round_event/godwill
	name = "God's Will"
	id = "godwill"

	event_message = "Today, an excommunication is the worst possible thing for you."

/datum/round_event/bumdanger
	name = "Dangerous Bums"
	id = "bumdanger"

	event_message = "Bums are extremely dangerous nowanights."

/datum/round_event/dangerousday
	name = "Horrible Night"
	id = "dangerousday"

	event_message = "Death has a horrible outcome."

/datum/round_event/holiday
	name = "Holiday"
	id = "holiday"

	event_message = "Today is St. Gunther's day. It would be a shame to not drink to it."

/datum/round_event/deadlyforce
	name = "Death Squad"
	id = "deadlyforce"

	event_message = "Only mass executions could save Firethorn."

/datum/round_event/freshmalemilk
	name = "Nutritious Milk"
	id = "freshmalemilk"

	event_message = "That diet was a great choice. Fresh male milk is exremely nutritious in Firethorn."

/datum/round_event/blessedflesh
	name = "Guardian"
	id = "blessedflesh"

	event_message = "By taking the Successor's freshness, a hero could obtain much power."

/datum/round_event/fangtasia
	name = "Masquerade"
	id = "fangtasia"
	roundstartdisplay = 0
	event_message = "Nobody respects the Masquerade nowanights. The Fortress is infested with bloodsuckers."

/datum/round_event/buryyourdead
	name = "Undead Fortress"
	id = "buryyourdead"

	event_message = "Fallen ones raise even in the fortress."

/datum/round_event/intouch
	name = "Intouch"
	id = "intouch"

	event_message = "Migrants have bracelets."

/datum/round_event/safecaves
	name = "Safe Caves"
	id = "safecaves"

	event_message = "Thanks to our brave warriors, there will be no ambushes in the caves today."

/datum/round_event/migrantess
	name = "Migrantess"
	id = "migrantess"

	event_message = "All migrants are females."

/datum/round_event/deprived
	name = "Deprived"
	id = "deprived"

	event_message = "Migrants are poor, naked, and humiliated."

/datum/round_event/drunkjester
	name = "Drunk Jester"
	id = "drunkjester"

	event_message = "All gates were stolen by a drunk jester!"

/datum/round_event/ihavenoson
	name = "I Have No Son"
	id = "ihavenoson"

	event_message = "The Baron has two daughters."

/datum/round_event/cheapmerchandise
	name = "Cheap Merchandise"
	id = "cheapmerchandise"

	event_message = "The Bookkeeper has been trading with some weird ginks. All packs are cheaper this night."

/datum/round_event/armedbums
	name = "Armed Bums"
	id = "armedbums"

	event_message = "The orphans have given various weapons to the bums of Firethorn."

/*
/datum/round_event/bluepoison
	id = "bluepoison"

	event_message = "Bad mood kills."
*/
/datum/round_event/wargirl
	name = "Wargirl"
	id = "wargirl"

	event_message = "Unlike other girls, Successor is a natural born warrior."

/*/datum/round_event/organs
	name = "Good taste"
	id = "organs"

	event_message = "There's nothing like the taste of a good piece of organ."*/

/datum/round_event/ghostpower
	name = "Ghost Power"
	id = "ghostpower"

	event_message = "Ghosts obtain their power much faster."

/datum/round_event/beekeeper
	name = "The Bee's Knees"
	id = "beekeeper"

	event_message = "Bookkeeper was overthrown by the new merchant. Greetings, Beekeeper!"

/datum/round_event/childgarrison
	name = "Youth Camp"
	id = "childgarrison"

	event_message = "The garrison have went missing in the caves. Their sons and daughters now take their place!"

/datum/round_event/thunderstruck
	name = "Thunderstruck"
	id = "thunderstruck"

	event_message = "The Baron accidently dropped his lawful scepter. It works differently now."

/datum/round_event/losttribs
	name = "Lost Squad"
	id = "lostsquad"
	roundstartdisplay = 1
	event_message = "The first wave of migrants is replaced by a lost Tribunal squad."

/datum/round_event/washingmachine
	name = "Comically Large Washing Machine"
	id = "washing"
	roundstartdisplay = 1
	event_message = "Oh no! The fortress washing machine broke down!"

/datum/round_event/reallover
	name = "Lover"
	id = "lover"
	roundstartdisplay = 0
	event_message = "There is a great lover!"

/datum/round_event/goldenfortress/apply_event()
	treasuryworth.add_money(50000)

/datum/round_event/wargirl/apply_event()
	for(var/mob/living/carbon/human/H in player_list)
		if(H.job == "Successor")
			H.my_stats.st += 2
			H.my_stats.ht += 3
			H.my_stats.dx += 3
			H.my_skills.ADD_SKILL(SKILL_MELEE, 17)
			H.my_skills.ADD_SKILL(SKILL_RANGE, 9)
			H.equip_to_slot_or_del(new /obj/item/sheath/sabre(H), slot_belt)

/datum/round_event/cheapmerchandise/apply_event()
	for(var/pack_name in supply_shuttle.supply_packs)
		var/datum/supply_packs/pack = supply_shuttle.supply_packs[pack_name]
		pack.cost *= rand(30, 80)/100

/datum/round_event/armedbums/apply_event()
	var/static/possible_weapons = list(
		/obj/item/weapon/gun/projectile/shotgun,
		/obj/item/weapon/gun/projectile/shotgun/princess,
		/obj/item/weapon/gun/projectile/newRevolver/duelista,
		/obj/item/weapon/gun/projectile/newRevolver/duelista/neoclassic,
		/obj/item/weapon/gun/projectile/automatic/pistol,
		/obj/item/weapon/gun/projectile/automatic/pistol/ml23,
		/obj/item/weapon/gun/projectile/automatic/carbine,
		/obj/item/weapon/claymore/golden,
		/obj/item/weapon/claymore/silver,
		/obj/item/weapon/claymore/copper,
		/obj/item/weapon/claymore,
		/obj/item/weapon/claymore/spear,
		/obj/item/weapon/claymore/scimitar,
		/obj/item/weapon/claymore/gladius,
		/obj/item/weapon/claymore/bastard,
		/obj/item/weapon/claymore/bastard/silver,
		/obj/item/weapon/kitchen/utensil/knife/dagger/silver,
		/obj/item/weapon/kitchen/utensil/knife/dagger/copper,
		/obj/item/weapon/kitchen/utensil/knife/dagger,
		/obj/item/weapon/melee/telebaton,
		/obj/item/weapon/melee/classic_baton/tonfa,
		/obj/item/weapon/melee/classic_baton/mace,
		/obj/item/weapon/melee/classic_baton/blackjack,
		/obj/item/weapon/melee/classic_baton/smallclub,
		/obj/item/weapon/melee/classic_baton/club,
		/obj/item/weapon/melee/classic_baton/boneclub,
	)
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Bum" || istype(H, /mob/living/carbon/human/bumbot))
			var/weapontype = pick(possible_weapons)
			var/obj/item/weapon = new weapontype(get_turf(H))
			H.put_in_active_hand(weapon)

/datum/round_event/fangtasia/apply_event()
	for(var/mob/living/carbon/human/H in player_list)
		if(prob(50))
			H.vampire_me()

/datum/round_event/ihavenoson/apply_event()
	for(var/mob/living/carbon/human/H in player_list)
		if(H.job == "Heir")
			H.job = "Successor"
			H.gender = FEMALE
			if(H.isChild())
				H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/shoes(H), slot_shoes)
				H.voicetype = "noble"
				H.add_event("nobleblood", /datum/happiness_event/noble_blood)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/succdress/child(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/weapon/card/id/successor(H), slot_wear_id)
				return
			H.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/captain(H), slot_wrist_r)
			H.voicetype = "noble"
			H.equip_to_slot_or_del(new /obj/item/clothing/under/common(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/boots(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/succdress(H), slot_wear_suit)
			H.add_event("nobleblood", /datum/happiness_event/noble_blood)
			H.equip_to_slot_or_del(new /obj/item/weapon/card/id/successor(H), slot_wear_id)

/*/datum/round_event/name/apply_event()
	var/firstName = pick("Bruno","Vinicius","Yuri","Almeida","Copetti","Gabriel","Felipe","João","Pedro","Bartolomeu","Everaldo")
	var/lastName = pick("Almeida","Silva","Fiaes","Souto","Fernandes","Honorato","Esvael","Messias","Pinto","Caixeta")
	var/fullName = firstName + " " + lastName
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.outsider == 0 || H.royalty == 0)
			H.name = fullName
			H.voice = fullName
			H.real_name = fullName*/

/datum/round_event/crowded/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.outsider == 0 && H.job != "Baron" && H.job != "Hand" && H.job != "Marduk" && H.job != "Tiamat" && H.job != "Squire" && H.job != "Inquisitor" && H.job != "Practicus" && H.job != "Bishop" && H.job != "Nun" && H.job != "Heir" && H.job != "Baroness" && H.job != "Successor")
			for(var/obj/effect/landmark/L in landmarks_list)
				if(L.name == "Crowded")
					H.forceMove(L.loc)

/datum/round_event/gifted/apply_event()
	for(var/mob/living/carbon/human/H in player_list)
		if(H.outsider == 0 && H.my_stats)
			H.my_stats.it = rand(3,4)

/datum/round_event/privatesecurity/apply_event()
	for(var/mob/living/carbon/human/H in player_list)
		if(H.job == "Grayhound")
			H.my_stats.st += 3
			H.my_skills.ADD_SKILL(SKILL_MELEE, 2)
			H.my_skills.ADD_SKILL(SKILL_RANGE, 4)
			if(H.w_uniform)
				qdel(H.w_uniform)
			if(H.wear_suit)
				qdel(H.wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/common/outlaw(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/vest/flakjacket(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/balaclava(H), slot_wear_mask)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/carbine(H), slot_back)
/*
/datum/round_event/informant/apply_event()
	for(var/mob/living/carbon/human/H in world)
		spawn(5)
			to_chat(world, "<br>")
			to_chat(world, "<span class='ravenheartfortress'>Fortaleza de Firethorn</span>")
			to_chat(world, "<span class='excomm'><b>¤Mensagem urgente ao Barão!¤</b></span>")
			world << sound('sound/AI/urgent_message.ogg')
			to_chat(world, "<br>")
			for(var/obj/machinery/charon/C in world)
				var/obj/item/weapon/paper/lord/NG = new (C.loc)
				NG.info = "<h2>O Lorde [H.real_name] veio para Firethorn e espera que seja bem recebido pelo forte!</h2>"
*/
/datum/round_event/shattereddreams/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.outsider == 0)
			H.add_event("shattereddreams", /datum/happiness_event/misc/shattereddreams)

/datum/round_event/bankrupt/apply_event()
	treasuryworth.set_money(0)

/datum/round_event/pathologic/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.outsider == 0)
			if(H.job == "Esculap")
				H.combat_music = 'haruspex-combat.ogg'
				H.my_skills.ADD_SKILL(SKILL_MELEE, rand(3,5))
				H.my_skills.ADD_SKILL(SKILL_RANGE, 3)
				H.my_stats.st += 2
				H.my_stats.dx += 3
				H.my_stats.ht += 3
			else
				H << sound(pick('pathologic.ogg','haruspex.ogg'), repeat = 0, wait = 0, volume = H?.client?.prefs?.ambi_volume, channel = 12)
				if(prob(75))
					H.contract_disease(new /datum/disease/fluspanish,1,0)

/datum/round_event/man/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.outsider == 0 && !H.has_penis())
			H.gender = "male"
			H.update_body()

/*/datum/round_event/polyhedron/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H?.species?.name == "Child")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/doghead(H), slot_head)*/

/datum/round_event/ordinators/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Tiamat" || H.job == "Marduk")
			if(H.belt)
				qdel(H.belt)
			if(H.s_store)
				qdel(H.s_store)
			if(H.w_uniform)
				qdel(H.w_uniform)
			if(H.wear_suit)
				qdel(H.wear_suit)
			if(H.r_hand)
				qdel(H.r_hand) // get rid of their helmets
			if(H.wrist_l)
				qdel(H.wrist_l)
			if(H.job == "Marduk")
				var/syndicate_commando_leader_rank = "Lt."
				H.real_name = "[syndicate_commando_leader_rank] [H.real_name]"
				H.my_skills.ADD_SKILL(SKILL_RANGE, 3)
				H.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(H), slot_l_hand)
				H.equip_to_slot_or_del(new /obj/item/clothing/under/ordinatorLT(H), slot_w_uniform)
			if(H.job == "Tiamat")
				var/syndicate_commando_rank = pick("Pvt.", "Pfc.", "LCpl.", "Cpl.", "Sgt.")
				H.real_name = "[syndicate_commando_rank] [H.real_name]"
				H.my_skills.ADD_SKILL(SKILL_RANGE, 1)
				H.equip_to_slot_or_del(new /obj/item/clothing/under/ordinator(H), slot_w_uniform)
			H.assignment = "Ordinator"
			if(H.wear_id)
				var/obj/item/weapon/card/id/R = H.wear_id
				R.registered_name = H.real_name
				R.rank = H.job
				R.assignment = H.assignment
				R.name = "[R.registered_name]'s Ring"
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/vest/flakjacket(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/ordinator(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/grinder(H), slot_back)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/infantry(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/taser/leet/sparq(H), slot_belt)
			H.equip_to_slot_or_del(new /obj/item/weapon/shield/generator/wrist(H), slot_wrist_l)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/grinder(H), slot_r_store)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/grinder(H), slot_l_store)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/external/grinder(H), slot_s_store)

/datum/round_event/size_matters/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		H.my_stats.st = H.potenzia

/datum/round_event/deadlyforce/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Tiamat" || H.job == "Marduk")
			if(H.belt)
				qdel(H.belt)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/taser/leet/laser(H), slot_belt)

/datum/round_event/child/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.age < 18 && H.outsider == 0)
			H.my_stats.st += rand(4, 5)
			H.my_stats.it = 3
/*
/datum/round_event/black/apply_event()
	for(var/mob/living/carbon/human/H in world)
		if(H.outsider == 0)
			H.s_tone = -185
			H.update_body()
*/
/datum/round_event/erpfaggots/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(prob(70))
			if(!H.outsider)
				H.mutilated_genitals = 1
				H.potenzia = -1

/datum/round_event/weak/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		spawn(1)
			if(!H.outsider)
				H.my_stats.st -= 4
				H.my_stats.ht -= 4


/datum/round_event/helpless/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		spawn(1)
			if(!H.outsider)
				H.my_skills.CHANGE_SKILL(SKILL_MELEE, 1)
				H.my_skills.CHANGE_SKILL(SKILL_RANGE, 1)

/datum/round_event/helpchildren/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		spawn(1)
			if(!H.outsider || !H.age < 18)
				H.my_skills.CHANGE_SKILL(SKILL_MELEE, 1)
				H.my_skills.CHANGE_SKILL(SKILL_RANGE, 1)
			if(H.age < 18)
				H.my_skills.ADD_SKILL(SKILL_MELEE, 3,6)
				H.my_skills.ADD_SKILL(SKILL_RANGE, 3,6)

/datum/round_event/kidcensor/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Marduk")
			H.set_species("Child")
			H.height = rand(130,150)

/datum/round_event/childbaron/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Baron")
			H.set_species("Child")
			H.height = rand(130,150)

/datum/round_event/childgarrison/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Tiamat")
			H.set_species("Child")
			H.height = rand(130,150)
			if(H.wear_suit)
				qdel(H.wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/squire(H), slot_wear_suit)
			H.my_skills.job_stats("Squire")
			H.my_stats.job_stats("Squire")

/datum/round_event/bumdanger/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Bum" || istype(H, /mob/living/carbon/human/bumbot))
			H.my_stats.st += 8
			H.my_stats.dx += 8
			H.my_stats.ht += 8
			H.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(13,16))
			H.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(13,16))

/datum/round_event/united/apply_event()
	var/finalvice = pick(vices)
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.outsider)	continue
		H.vice = finalvice

/datum/round_event/drunkjester/apply_event()
	for(var/obj/machinery/door/airlock/transgates/T in world)
		qdel(T)
	for(var/obj/machinery/door/airlock/orbital/gates/ex/E in world)
		qdel(E)
	for(var/obj/machinery/door/airlock/orbital/gates/ins/I in world)
		qdel(I)

/datum/round_event/freedom/apply_event()
	for(var/obj/machinery/door/airlock/T in world)
		if(T.req_access)
			T.req_access = null
			T.req_access_txt = null
			T.locked = FALSE

/datum/round_event/beekeeper/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Bookkeeper")
			H.add_perk(/datum/perk/bee_queen)
			H.assignment = "Beekeeper"
			if(H.wear_id)
				var/obj/item/weapon/card/id/R = H.wear_id
				R.registered_name = H.real_name
				R.rank = H.job
				R.assignment = H.assignment
				R.name = "[R.registered_name]'s Ring"
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/bee(H), slot_wear_mask)
			continue
		if(H.job == "Grayhound")
			if(H.wear_suit)
				qdel(H.wear_suit)
			if(H.head)
				qdel(H.head)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/bio_suit(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/bio_hood(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/bee(H), slot_wear_mask)

	for(var/obj/effect/landmark/S in landmarks_list)
		if(S.name == "Beekeeper")
			new /obj/structure/bee_hive(S.loc)

/datum/round_event/thunderstruck/apply_event()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Baron")
			if(H.r_hand)
				qdel(H.r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/staffoflaw/zeus(H), slot_r_hand)

/datum/round_event/washingmachine/apply_event()
	for(var/obj/item/clothing/C in allClothing)
		var/mob/living/carbon/human/wearsMe = null            
		if(istype(C.loc, /mob/living/carbon/human))
			wearsMe = C.loc
		var/area/A = get_area(C)
		if(wearsMe?.job == "Inquisitor" || wearsMe?.job == "Practicus" || wearsMe?.job == "Bishop")
			continue
		if(istype(A, /area/safespawnarea/ladycapturezone))
			continue
		if(istype(A, /area/dunwell/trainpathInquisition))
			continue
		if(istype(A, /area/dunwell/station/soulbreaker))
			continue
		if(istype(A, /area/dunwell/miscplaces))
			continue
		if(istype(C, /obj/item/clothing/head/caphat))
			continue
		else            
			qdel(C)
	spawn(5 SECONDS)
		for(var/mob/living/carbon/human/bumbot/B in mob_list)
			qdel(B.head)
			qdel(B.wear_mask)
			qdel(B.w_uniform)
			qdel(B.gloves)
			qdel(B.wear_suit)
			qdel(B.shoes)

/datum/round_event/reallover/apply_event()
	var/list/L = list()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.client && H.age >= 18)
			L.Add(H)
	var/mob/living/carbon/human/chosenOne = pick(L)
	chosenOne.Chosenlover = 1
	chosenOne.potenzia = 30
	spawn(5 SECONDS)
		to_chat(world, "<span class='horriblestate' style='font-size: 150%;'><b><i>They say [chosenOne.real_name] is a great lover!</i></b></span>")
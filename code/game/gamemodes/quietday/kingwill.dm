/datum/game_mode/kingwill
	name = "King's Will"
	config_tag = "kingwill"
	required_players = 0
	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800
	var/atom/kingwillobj1
	var/atom/kingwillobj2
	var/atom/kingwillobj3
	var/kingwillamount1 = 2
	var/kingwillamount2 = 2
	var/kingwillamount3 = 2
	var/kingwillamountdone1 = 0
	var/kingwillamountdone2 = 0
	var/kingwillamountdone3 = 0
	var/kingwilldone1 = FALSE
	var/kingwilldone2 = FALSE
	var/kingwilldone3 = FALSE


/datum/game_mode/kingwill/announce()
	world << "<B>Our fate is a peaceful one.</B>"
	return

/datum/game_mode/kingwill/pre_setup()
	return 1

/datum/game_mode/kingwill/post_setup()
	kingwillamount1 = rand(1,14)
	kingwillamount2 = rand(1,12)
	kingwillamount3 = rand(1,8)
	kingwillobj1 = pick(/obj/item/weapon/cloaking_device, /obj/item/weapon/reagent_containers/food/snacks/meat, /obj/item/weapon/reagent_containers/food/snacks/organ/lungs)
	kingwillobj2 = pick(/obj/item/weapon/kitchen/utensil/knife, /obj/item/weapon/reagent_containers/syringe, /obj/item/weapon/reagent_containers/food/snacks/organ/heart)
	kingwillobj3 = pick(/obj/item/weapon/grenade/syndieminibomb/frag, /obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis)
	spawn (rand(3000, 4800))
		for(var/obj/machinery/charon/C in world)
			var/obj/item/weapon/paper/lord/NG = new (C.loc)
			var/obj/kingw1 = new kingwillobj1
			var/obj/kingw2 = new kingwillobj2
			var/obj/kingw3 = new kingwillobj3
			NG.info = "The God king demands a few gifts from the baron of Firethorn!"
			NG.info += "<br>[kingwillamount1] [kingw1.name], [kingwillamount2] [kingw2.name], [kingwillamount3] [kingw3.name]"
			NG.info += "You have 30 minutes to deliver everything through the Bookkeeper's barge before the tribunals are sent!"
			evermail_ref.receive(NG, 1)
		spawn(30 MINUTES)
			if(kingwilldone1 && kingwilldone2 && kingwilldone3)
				for(var/obj/machinery/charon/C in world)
					var/obj/item/weapon/paper/lord/NG = new (C.loc)
					NG.info = "The God king has received the gifts!"
					evermail_ref.receive(NG, 1)
				to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
				to_chat(world, "<span class='excomm'>The King has received his tributes!</span>")
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<span class='decree'>One minute until the celebration in the feasting hall!</span>")
				to_chat(world, "<br>")
				spawn(1 MINUTES)
					for(var/mob/living/carbon/human/H in mob_list)
						if(istype(get_area(H), /area/dunwell/station/dining))
							H.client.ChromieWinorLoose(H.client, 2)
					ticker.declare_completion()
			else
				for(var/obj/machinery/charon/C in world)
					var/obj/item/weapon/paper/lord/NG = new (C.loc)
					NG.info = "The God king hasn't received the gifts, a Tribunal squad has been sent!"
					evermail_ref.receive(NG, 1)
				makeDeathsquad()
	..()

/datum/game_mode/kingwill/declare_completion()
	..()
	if(kingwilldone1 && kingwilldone2 && kingwilldone3)
		to_chat(world, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The Lord Baron managed to give the God-King his tributes!</span>")
	else
		to_chat(world, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The Lord Baron managed to survive for another night!</span>")
	return 1

/datum/game_mode/kingwill/proc/checkSellKing(var/soldobj)
	if(istype(soldobj, kingwillobj1))
		kingwillamountdone1 += 1
		if(kingwillamountdone1 >= kingwillamount1)
			kingwilldone1 = TRUE
	if(istype(soldobj, kingwillobj2))
		kingwillamountdone2 += 1
		if(kingwillamountdone2 >= kingwillamount2)
			kingwilldone2 = TRUE
	if(istype(soldobj, kingwillobj3))
		kingwillamountdone3 += 1
		if(kingwillamountdone3 >= kingwillamount3)
			kingwilldone3 = TRUE

/datum/game_mode/kingwill/proc/makeDeathsquad()
	var/list/mob/dead/observer/candidates = list()
	var/mob/dead/observer/theghost = null
	var/time_passed = world.time
	var/input = "Purify the fort and evacuate the church."
	var/nuke_code

	var/syndicate_leader_selected = 0 //when the leader is chosen. The last person spawned.

	//Generates a list of commandos from active ghosts. Then the user picks which characters to respawn as the commandos.
	for(var/obj/machinery/nuclearbomb/N in world)
		if(N.r_code)//if it's actually a number. It won't convert any non-numericals.
			nuke_code = N.r_code

	for(var/mob/dead/observer/G in player_list)
		spawn(0)
			G << 'console_interact7.ogg'
			switch(alert(G,"Do you want to join a Tribunal Ordinator Squad?","You have thiry seconds to comply.","Yes","No"))
				if("Yes")
					if((world.time-time_passed)>300)//If more than 30 game seconds passed.
						return
					candidates += G
				if("No")
					return
				else
					return
	sleep(300)

	for(var/mob/dead/observer/G in candidates)
		if(!G.key)
			candidates.Remove(G)

	if(candidates.len)
		var/numagents = 6
		//Spawns commandos and equips them.
		for(var/obj/effect/landmark/L in landmarks_list)
			if(numagents<=0)
				break
			if (L.name == "Syndicate-Commando")
				syndicate_leader_selected = numagents == 1?1:0
				while((!theghost || !theghost.client) && candidates.len)
					theghost = pick(candidates)
					candidates.Remove(theghost)

				var/mob/living/carbon/human/new_syndicate_commando = create_syndicate_death_commando(L, syndicate_leader_selected, theghost.key)

				if(!theghost)
					qdel(new_syndicate_commando)
					break

				new_syndicate_commando.internal = new_syndicate_commando.s_store
				new_syndicate_commando.internals.icon_state = "internal1"

				//So they don't forget their code or mission.
				new_syndicate_commando.mind.store_memory("<B>Nuke Code:</B> \red [nuke_code].")
				new_syndicate_commando << "<B>Nuke Code:</B> \red [nuke_code]."
				new_syndicate_commando.old_job = "Tribunal Ordinator"
				new_syndicate_commando.job = "Tribunal Ordinator"
				to_chat(new_syndicate_commando, "\blue You are an Tribunal Ordinator. in the service of the God-king. \nYour current mission is: \red<B> [input]</B>")
				numagents -= 1
		if(numagents >= 6)
			return 0

	return 1

/datum/game_mode/kingwill/proc/create_syndicate_death_commando(obj/spawn_location, syndicate_leader_selected = 0, var/keyChosen)
	var/mob/living/carbon/human/new_syndicate_commando = new(spawn_location.loc)
	var/syndicate_commando_leader_rank = "Lt"
	var/syndicate_commando_rank = pick("Pvt", "Sgt")
	var/syndicate_commando_name = pick(last_names)

	new_syndicate_commando.gender = MALE

	var/datum/preferences/A = new()//Randomize appearance for the commando.
	A.randomize_appearance_for(new_syndicate_commando)

	new_syndicate_commando.real_name = "[!syndicate_leader_selected ? syndicate_commando_rank : syndicate_commando_leader_rank] [syndicate_commando_name]"
	new_syndicate_commando.name = new_syndicate_commando.real_name
	new_syndicate_commando.age = !syndicate_leader_selected ? rand(20,35) : rand(35,45)
	new_syndicate_commando.key = keyChosen

	new_syndicate_commando.dna.ready_dna(new_syndicate_commando)//Creates DNA.

	//Creates mind stuff.
	new_syndicate_commando.mind_initialize()
	new_syndicate_commando.mind.assigned_role = "MODE"
	new_syndicate_commando.mind.special_role = "Tribunal Ordinator"
	new_syndicate_commando.microbomb_soulbreaker()
	new_syndicate_commando.client.color = null

	//Adds them to current traitor list. Which is really the extra antagonist list.

	new_syndicate_commando.equip_syndicate_commando(syndicate_leader_selected)

	return new_syndicate_commando


/datum/game_mode/kingwill/can_start()
	for(var/mob/new_player/player in player_list)
		for(var/mob/new_player/player2 in player_list)
			for(var/mob/new_player/player3 in player_list)
				if(player.ready && player.client.work_chosen == "Baron" && player2.ready && player2.client.work_chosen == "Inquisitor"&& player3.ready && player3.client.work_chosen == "Bookkeeper")
					return 1
	return 0
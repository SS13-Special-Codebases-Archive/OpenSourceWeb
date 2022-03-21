client/proc/one_click_antag()
	set name = "Create Antagonist"
	set desc = "Auto-create an antagonist of your choice"
	set category = "Admin"

	if(holder)
		holder.one_click_antag()
	return


/datum/admins/proc/one_click_antag()

	var/dat = {"<B>One-click Antagonist</B><br>
		<a href='?src=\ref[src];makeAntag=1'>Make Traitors</a><br>
		<a href='?src=\ref[src];makeAntag=2'>Make Changlings</a><br>
		<a href='?src=\ref[src];makeAntag=3'>Make Revs</a><br>
		<a href='?src=\ref[src];makeAntag=4'>Make Cult</a><br>
		<a href='?src=\ref[src];makeAntag=5'>Make Malf AI</a><br>
		<a href='?src=\ref[src];makeAntag=6'>Make Wizard (Requires Ghosts)</a><br>
		<a href='?src=\ref[src];makeAntag=11'>Make Vox Raiders (Requires Ghosts)</a><br>
		<a href='?src=\ref[src];makeAntag=10'>Make Ordinators (Requires Ghosts)</a><br>
		"}

	usr << browse(dat, "window=oneclickantag;size=400x400")
	return



/datum/admins/proc/makeDeathsquad()
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
			switch(alert(G,"Do you want to join a Tribunal Ordinator Squad?","Please answer in 30 seconds!","Yes","No"))
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
		var/numagents = 4
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
		if(numagents >= 4)
			return 0

	return 1

/*
		for (var/obj/effect/landmark/L in /area/shuttle/syndicate_elite)
			if (L.name == "Syndicate-Commando-Bomb")
				new /obj/effect/spawner/newbomb/timer/syndicate(L.loc)
*/



/datum/admins/proc/makeBody(var/mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
	if(!G_found || !G_found.key)	return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new(pick(latejoin))//The mob being spawned.

	new_character.gender = pick(MALE,FEMALE)

	var/datum/preferences/A = new()
	A.randomize_appearance_for(new_character)
	if(new_character.gender == MALE)
		new_character.real_name = "[pick(first_names_male)] [pick(last_names)]"
	else
		new_character.real_name = "[pick(first_names_female)] [pick(last_names)]"
	new_character.name = new_character.real_name
	new_character.age = rand(17,45)

	new_character.dna.ready_dna(new_character)
	new_character.key = G_found.key

	return new_character

/datum/admins/proc/create_syndicate_death_commando(obj/spawn_location, syndicate_leader_selected = 0, var/keyChosen)
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
	new_syndicate_commando.client.color = null

	//Adds them to current traitor list. Which is really the extra antagonist list.

	new_syndicate_commando.equip_syndicate_commando(syndicate_leader_selected)

	return new_syndicate_commando

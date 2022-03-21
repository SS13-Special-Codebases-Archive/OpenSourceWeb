var/global/datum/controller/occupations/job_master
var/global/thanatiWords = list()

#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

/datum/controller/occupations
		//List of all jobs
	var/list/occupations = list()
		//Players who need jobs
	var/list/unassigned = list()
		//Debug info
	var/list/job_debug = list()


	proc/SetupOccupations(var/faction = "Station")
		occupations = list()
		var/list/all_jobs = typesof(/datum/job)
		if(!all_jobs.len)
			world << "\red \b Error setting up jobs, no job datums found"
			return 0
		for(var/J in all_jobs)
			var/datum/job/job = new J()
			if(!job)	continue
			if(job.faction != faction)	continue
			occupations += job


		return 1

	proc/AddOccupations(var/faction = "Station")
		var/list/all_jobs = typesof(/datum/job)
		if(!all_jobs.len)
			world << "\red \b Error setting up jobs, no job datums found"
			return 0
		for(var/J in all_jobs)
			var/datum/job/job = new J()
			if(!job)	continue
			if(job.faction != faction)	continue
			occupations += job

		return 1

	proc/Debug(var/text)
		if(!Debug2)	return 0
		job_debug.Add(text)
		return 1


	proc/GetJob(var/rank)
		if(!rank)	return null
		for(var/datum/job/J in occupations)
			if(!J)	continue
			if(J.title == rank)	return J
		return null

	proc/AssignRole(var/mob/new_player/player, var/rank, var/latejoin = 0)
		Debug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
		if(player && player.mind && rank)
			var/datum/job/job = GetJob(rank)
			if(!job)	return 0
			if(jobban_isbanned(player, rank))	return 0
			if(player.client.info?.chromosomes < 0 && rank == "Marduk") return 0
			if(!trapapoc.Find(ckey(player.key)) || job.no_trapoc)
				if(job.sex_lock && player.client.prefs.gender != job.sex_lock)
					return 0
			if(!job.player_old_enough(player.client)) return 0
			if(job.job_whitelisted)
				if(job.job_whitelisted.Find(PIGPLUS))
					if(!comradelist.Find(ckey(player.client.key)) && !villainlist.Find(ckey(player.client.key)))
						if(!pigpluslist.Find(ckey(player.client.key)))
							return 0
				else
					if(job.job_whitelisted.Find(COMRADE))
						if(!comradelist.Find(ckey(player.client.key)) && !villainlist.Find(ckey(player.client.key)))
							return 0
					else
						if(job.job_whitelisted.Find(VILLAIN))
							if(!villainlist.Find(ckey(player.client.key)))
								return 0
			var/position_limit = job.total_positions
			if(!latejoin)
				position_limit = job.spawn_positions
			if((job.current_positions < position_limit) || position_limit == -1)
				Debug("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
				player.mind.assigned_role = rank
				unassigned -= player
				//player.preferences.save_preferences()
				player.client.prefs.save_preferences()
				player.client.prefs.savefile_update()
				job.current_positions++
				return 1
		Debug("AR has failed, Player: [player], Rank: [rank]")
		return 0

	proc/FreeRole(var/rank)	//making additional slot on the fly
		var/datum/job/job = GetJob(rank)
		if(job && job.current_positions >= job.total_positions && job.total_positions != -1)
			job.total_positions++
			return 1
		return 0

	proc/FindOccupationCandidates(datum/job/job, level, flag)
		Debug("Running FOC, Job: [job], Level: [level], Flag: [flag]")
		var/list/candidates = list()
		for(var/mob/new_player/player in unassigned)
			if(jobban_isbanned(player, job.title))
				Debug("FOC isbanned failed, Player: [player]")
				continue
			if(!job.player_old_enough(player.client))
				Debug("FOC player not old enough, Player: [player]")
				continue
			if(flag && (!player.client.prefs.be_special & flag))
				Debug("FOC flag failed, Player: [player], Flag: [flag], ")
				continue
			if(!trapapoc.Find(ckey(player.key)) || job.no_trapoc)
				if(job.sex_lock && player.client.prefs.gender != job.sex_lock)
					Debug("FOC character wrong gender, Player: [player]")
					continue
			if(job.job_whitelisted)
				if(job.job_whitelisted.Find(PIGPLUS))
					if(!comradelist.Find(ckey(player.client.key)) && !villainlist.Find(ckey(player.client.key)))
						if(!pigpluslist.Find(ckey(player.client.key)))
							continue
				else
					if(job.job_whitelisted.Find(COMRADE))
						if(!comradelist.Find(ckey(player.client.key)) && !villainlist.Find(ckey(player.client.key)))
							continue
					else
						if(job.job_whitelisted.Find(VILLAIN))
							if(!villainlist.Find(ckey(player.client.key)))
								continue
			if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
				Debug("FOC pass, Player: [player], Level:[level]")
				candidates += player
		return candidates

	proc/GiveRandomJob(var/mob/new_player/player)
		Debug("GRJ Giving random job, Player: [player]")
		for(var/datum/job/job in shuffle(occupations))
			if(!job)
				continue

			if(istype(job, GetJob("Unassigned"))) // We don't want to give him assistant, that's boring!
				continue

			if(job in command_positions) //If you want a command position, select it!
				continue

			if(jobban_isbanned(player, job.title))
				Debug("GRJ isbanned failed, Player: [player], Job: [job.title]")
				continue

			if(!job.player_old_enough(player.client))
				Debug("GRJ player not old enough, Player: [player]")
				continue

			if(!trapapoc.Find(ckey(player.key)) || job.no_trapoc)
				if(job.sex_lock && player.client.prefs.gender  != job.sex_lock)
					continue


			if(job.job_whitelisted)
				if(job.job_whitelisted.Find(PIGPLUS))
					if(!comradelist.Find(ckey(player.client.key)) && !villainlist.Find(ckey(player.client.key)))
						if(!pigpluslist.Find(ckey(player.client.key)))
							continue
				else
					if(job.job_whitelisted.Find(COMRADE))
						if(!comradelist.Find(ckey(player.client.key)) && !villainlist.Find(ckey(player.client.key)))
							continue
					else
						if(job.job_whitelisted.Find(VILLAIN))
							if(!villainlist.Find(ckey(player.client.key)))
								continue

			if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
				Debug("GRJ Random job given, Player: [player], Job: [job]")
				if(master_mode == "minimig")
					AssignRole(player, "Migrant")
				else
					AssignRole(player, job.title)
				unassigned -= player
				break

	proc/ResetOccupations()
		for(var/mob/new_player/player in player_list)
			if((player) && (player.mind))
				player.mind.assigned_role = null
				player.mind.special_role = null
		SetupOccupations()
		unassigned = list()
		return


	///This proc is called before the level loop of DivideOccupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
	proc/FillHeadPosition()
		for(var/level = 1 to 3)
			for(var/command_position in command_positions)
				var/datum/job/job = GetJob(command_position)
				if(!job)	continue
				var/list/candidates = FindOccupationCandidates(job, level)
				if(!candidates.len)	continue

				// Build a weighted list, weight by age.
				var/list/weightedCandidates = list()

				// Different head positions have different good ages.
				var/good_age_minimal = 25
				var/good_age_maximal = 60
				if(command_position == "Baron")
					good_age_minimal = 25
					good_age_maximal = 70 // Old geezer captains ftw

				for(var/mob/V in candidates)
					// Log-out during round-start? What a bad boy, no head position for you!
					if(!V.client) continue
					var/age = V.client.prefs.age
					switch(age)
						if(good_age_minimal - 10 to good_age_minimal)
							weightedCandidates[V] = 3 // Still a bit young.
						if(good_age_minimal to good_age_minimal + 10)
							weightedCandidates[V] = 6 // Better.
						if(good_age_minimal + 10 to good_age_maximal - 10)
							weightedCandidates[V] = 10 // Great.
						if(good_age_maximal - 10 to good_age_maximal)
							weightedCandidates[V] = 6 // Still good.
						if(good_age_maximal to good_age_maximal + 10)
							weightedCandidates[V] = 6 // Bit old, don't you think?
						if(good_age_maximal to good_age_maximal + 50)
							weightedCandidates[V] = 3 // Geezer.
						else
							// If there's ABSOLUTELY NOBODY ELSE
							if(candidates.len == 1) weightedCandidates[V] = 1


				var/mob/new_player/candidate = pickweight(weightedCandidates)
				if(AssignRole(candidate, command_position))
					return 1

		if(config.join_unassigned)
			Debug("FillHeadPosition, Forcing Captain")
			ForceCaptain()
		return 0


	///This proc is called at the start of the level loop of DivideOccupations() and will cause head jobs to be checked before any other jobs of the same level
	proc/CheckHeadPositions(var/level)
		for(var/command_position in command_positions)
			var/datum/job/job = GetJob(command_position)
			if(!job)	continue
			var/list/candidates = FindOccupationCandidates(job, level)
			if(!candidates.len)	continue
			var/mob/new_player/candidate = pick(candidates)
			AssignRole(candidate, command_position)
		return


	proc/FillAIPosition()
		var/ai_selected = 0
		var/datum/job/job = GetJob("AI")
		if(!job)	return 0
		if((job.title == "AI") && (config) && (!config.allow_ai))	return 0

		for(var/i = job.total_positions, i > 0, i--)
			for(var/level = 1 to 3)
				var/list/candidates = list()
				if(ticker.mode.name == "AI malfunction")//Make sure they want to malf if its malf
					candidates = FindOccupationCandidates(job, level, BE_MALF)
				else
					candidates = FindOccupationCandidates(job, level)
				if(candidates.len)
					var/mob/new_player/candidate = pick(candidates)
					if(AssignRole(candidate, "AI"))
						ai_selected++
						break
			//Malf NEEDS an AI so force one if we didn't get a player who wanted it
			if((ticker.mode.name == "AI malfunction")&&(!ai_selected))
				unassigned = shuffle(unassigned)
				for(var/mob/new_player/player in unassigned)
					if(jobban_isbanned(player, "AI"))	continue
					if(AssignRole(player, "AI"))
						ai_selected++
						break
			if(ai_selected)	return 1
			return 0

	proc/ForceCaptain()
		var/mob/new_player/captain_choice = null

		for(var/mob/new_player/player in player_list)
			if(player.ready && player.mind && player.mind.assigned_role == "Baron")
				captain_choice = player

		if(!captain_choice && unassigned.len > 0)
			unassigned = shuffle(unassigned)
			for(var/mob/new_player/player in unassigned)
				if(jobban_isbanned(player, "Baron"))
					continue
				else
					captain_choice = player
					break

			unassigned -= captain_choice

		if(captain_choice)
			captain_choice.mind.assigned_role = "Baron"


/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
	proc/DivideOccupations()
		//Setup new player list and get the jobs list
		Debug("Running DO")
		SetupOccupations()

		//Holder for Triumvirate is stored in the ticker, this just processes it
/*		if(ticker)
			for(var/datum/job/ai/A in occupations)
				if(ticker.triai)
					A.spawn_positions = 3
*/
		//Get the players who are ready
		for(var/mob/new_player/player in player_list)
			if(player.ready && player.mind && !player.mind.assigned_role)
				unassigned += player

		Debug("DO, Len: [unassigned.len]")
		if(unassigned.len == 0)	return 0

		//Shuffle players and jobs
		unassigned = shuffle(unassigned)

		//People who wants to be assistants, sure, go on.
		Debug("DO, Running Assistant Check 1")
		var/datum/job/assist = new /datum/job/assistant()
		var/list/assistant_candidates = FindOccupationCandidates(assist, 3)
		Debug("AC1, Candidates: [assistant_candidates.len]")
		for(var/mob/new_player/player in assistant_candidates)
			Debug("AC1 pass, Player: [player]")
			AssignRole(player, "Unassigned")
			assistant_candidates -= player
		Debug("DO, AC1 end")

		//Select one head
		Debug("DO, Running Head Check")
		FillHeadPosition()
		Debug("DO, Head Check end")

		//Check for an AI
		Debug("DO, Running AI Check")
		FillAIPosition()
		Debug("DO, AI Check end")

		//Other jobs are now checked
		Debug("DO, Running Standard Check")


		// New job giving system by Donkie
		// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
		// Hopefully this will add more randomness and fairness to job giving.

		// Loop through all levels from high to low
		var/list/shuffledoccupations = shuffle(occupations)
		for(var/level = 1 to 3)
			//Check the head jobs first each level
			CheckHeadPositions(level)

			// Loop through all unassigned players
			for(var/mob/new_player/player in unassigned)

				// Loop through all jobs
				for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
					if(!job)
						continue

					if(jobban_isbanned(player, job.title))
						Debug("DO isbanned failed, Player: [player], Job:[job.title]")
						continue

					if(!trapapoc.Find(ckey(player.key)))
						if(job.sex_lock && job.sex_lock != player.client.prefs.gender)
							Debug("DO player wrong gender, Player: [player], Job:[job.title]")
							continue

					if(!job.player_old_enough(player.client))
						Debug("DO player not old enough, Player: [player], Job:[job.title]")
						continue

					// If the player wants that job on this level, then try give it to him.
					if(player.client.prefs.GetJobDepartment(job, level) & job.flag)

						// If the job isn't filled
						if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
							Debug("DO pass, Player: [player], Level:[level], Job:[job.title]")
							AssignRole(player, job.title)
							unassigned -= player
							break

		// Hand out random jobs to the people who didn't get any in the last check
		// Also makes sure that they got their preference correct
		for(var/mob/new_player/player in unassigned)
			if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
				GiveRandomJob(player)

		Debug("DO, Standard Check end")

		Debug("DO, Running AC2")

		// For those who wanted to be assistant if their preferences were filled, here you go.
		for(var/mob/new_player/player in unassigned)
			if(player.client.prefs.alternate_option == BE_ASSISTANT)
				Debug("AC2 Assistant located, Player: [player]")
				AssignRole(player, "Unassigned")

		//For ones returning to lobby
		for(var/mob/new_player/player in unassigned)
			if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
				player.ready = 0
				unassigned -= player
		return 1


	proc/EquipRank(var/mob/living/carbon/human/H, var/rank)
		if(!H)	return 0
		var/datum/job/job = GetJob(rank)
		if(job)
			job.equip(H)
		else
			to_chat(H, "Your job is [rank] and the game just can't handle it! Please report this.")

		if(!H.assignment)
			var/alt_title = job.set_runtime_title(H)
			if(!isnull(alt_title))
				H.assignment = alt_title
			else
				H.assignment = rank

		H.job = rank
		if(H.age < job.minimal_character_age && !job.children)
			var/randextra = rand(1,3)
			if(prob(50))
				H.age = job.minimal_character_age+randextra
			else
				H.age = job.minimal_character_age
		return 1

	proc/PostEquip(var/mob/living/carbon/human/H, var/joined_late = 0, var/turf/pickNewmigLocs)
		var/rank = H.job
		var/datum/job/job = GetJob(rank)
		var/alt_title = H.assignment

		//give them an account in the station database
		var/datum/money_account/M = create_account(H.real_name, rand(10,40), null)
		if(H.mind)
			//var/remembered_info = ""
			//remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
			//remembered_info += "<b>Your account funds are:</b> $[M.money]<br>"
/*			remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
			remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
			remembered_info += "<b>Your account funds are:</b> $[M.money]<br>"

			if(M.transaction_log.len)
				var/datum/transaction/T = M.transaction_log[1]
				remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
			H.mind.store_memory(remembered_info)
*/
			H.mind.initial_account = M

		// If they're head, give them the account info for their department
/*
		if(H.mind && job.head_position)
			var/remembered_info = ""
			var/datum/money_account/department_account = department_accounts[job.department]

			if(department_account)
				remembered_info += "<b>Your department's account number is:</b> #[department_account.account_number]<br>"
				remembered_info += "<b>Your department's account pin is:</b> [department_account.remote_access_pin]<br>"
				remembered_info += "<b>Your department's account funds are:</b> $[department_account.money]<br>"

			H.mind.store_memory(remembered_info)
*/
/*
		spawn(0)
			H << "\blue<b>Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]</b>"
*/
		if(H.mind)
			H.mind.assigned_role = rank
		//H << "<b>As the [alt_title ? alt_title : rank] you answer directly to [job.supervisors]. Special circumstances may change this.</b>"
		if(job.title != "Bum")
			var/regex/R = regex("(^\\S+) (.*$)") //Get first name and last name
			R.Find(H.real_name)
			var/last_name = R.group[2]
			if(gink_last_names.Find(last_name))
				H.voicetype = "gink"
				H.my_stats.st -= 1
				H.my_stats.dx += 1


		spawnId(H, rank, alt_title)
		spawn(30 SECONDS)
			if(H.religion == "Heresy")
				var/modifier = 0
				if(H.client?.info?.chromosomes > 0)
					modifier = rand(8,20)
				if(H.job == "Migrant")
					H.religion = "Old Ways"
					to_chat(H, "<span class='baronboldoutlined'>You profess the Old Ways.</span> <span class='baron'>It is a forgotten religion. May our Gods shine in the darkness of the caves.</span>")
				else
					if(prob(job.thanati_chance+modifier) && !H.isChild() && !joined_late)
						H.religion = "Thanati"
						to_chat(H, "<span class='baronboldoutlined'>⠀You're part of the [H.religion] cult.</span> <span class='baron'>It's not a legal religion in Evergreen, stay away from the Inquisition. Check your memories to see who's your brothers and sisters in faith.</span>")
						H << pick('sound/effects/thanati_investigation1.ogg', 'sound/effects/thanati_investigation2.ogg', 'sound/effects/thanati_investigation3.ogg')
						to_chat(H, "<span class='jogtowalk'><i>Thanati Roll: Successful!</i></span>")
						if(H.mind)
							var/ThanatiTypes = list("Doll Making", "Malice", "Traps", "Alteration", "Fate", "Grief", "Mind", "Speech")
							H.mind.thanati_type = pick(ThanatiTypes)
							var/CorruptWord = list("Staza", "Gmysa", "Gxero", "Fgaxa", "Ixero", "Bpah", "Xhot")
							var/CorruptWord2 = list("Gmyhoxe", "Gmyho", "Gzma", "Tzche", "Bog", "Irkhvi")
							var/fullWord = "[pick(CorruptWord) + " " + pick(CorruptWord2)]"
							H.mind.thanati_corrupt = fullWord
							var/CorruptWord3 = list("Staza", "Gmysa", "Gxero", "Fgaxa", "Ixero", "Bpah", "Xhot")
							var/CorruptWord4 = list("Gmyhoxe", "Gmyho", "Gzma", "Tzche", "Bog", "Irkhvi")
							H.mind.thanati_word_random = "[pick(CorruptWord3) + " " + pick(CorruptWord4)]"

							thanatiWords += fullWord
							H.mind.store_memory("My word is [H.mind.thanati_corrupt] and my circle is [H.mind.thanati_type]")
							to_chat(H, "<span class='baron'>Your corrupt word: [H.mind.thanati_corrupt], [H.mind.thanati_word_random] (The Circle of [H.mind.thanati_type]).</span>\n")
							to_chat(H, "\n<span class='barondarker'><i>* Glorify our lord in a Sigil to remember our goals. *</i></span>")
							H.verbs += /mob/living/carbon/human/proc/getWords
							H.verbs += /mob/living/carbon/human/proc/praisethelord
							H.verbs += /mob/living/carbon/human/proc/getBrothers
					else
						if(!H.isChild() && !joined_late)
							to_chat(H, "<span class='jogtowalk'><i>Thanati Roll: Failed!</i></span>")
						H.religion = "Gray Church"
			if(H.religion == "Gray Church")
				if(H.job == "Mortus")
					to_chat(H, "<span class='baronboldoutlined'>You profess Post-Christianity.</span><span class='baron'>, but in practice it is indifferent. The more you work in this place, the less you care about</span> <span class='baronboldoutlined'>religions</span><span class='baron'>, </span><span class='baronboldoutlined'>thoughts</span> <span class='baron'>and</span> <span class='baronboldoutlined'>common affairs</span><span class='baron'>. Your attention is consumed by the intoxicating anxiety that you continue to feel close to the Lifeweb.</span>")
				else
					to_chat(H, "<span class='baronboldoutlined'>You profess Post-Christianity.</span> <span class='baron'>It is Evergreen's only legal religion. May God and the Inquisition save us from Thanati. Amen.</span>")
				H.religion = "Gray Church"
		H.create_kg()
		H.month_born = pick("vernes","lipen","stujen","plesnya","leden","cherven","krovotok","zmeinik","grezen","shramyn","kamnepad","ljutish")
		H.day_born = rand(1,30)
		H.year_born = 3021 - H.age
		var/Borntext = "I was [pick("made","lucky")] to be born on [H.month_born], [H.day_born], [H.year_born] ([H.zodiac] Sign)"
		H?.mind?.memory += Borntext
		spawn(15 SECONDS)
			to_chat(H, "<span class='passive'>[Borntext]</span>")
		//Gives glasses to the vision impaired
		if(H.disabilities & NEARSIGHTED)
			var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), slot_glasses)
			if(equipped != 1)
				var/obj/item/clothing/glasses/G = H.glasses
				G.prescription = 1
		H.update_icons()
		H.FuncArea()
		if(H.job == "Migrant")
			if(H.religion == "Gray Church" && set_mig_spawn_th)
				H.forceMove(set_mig_spawn_th)
			else if (!(H.religion == "Gray Church") && set_mig_spawn_pc)
				H.forceMove(set_mig_spawn_pc)
			else
				H.forceMove(pickNewmigLocs)
		if(H.job == "Tribunal Veteran")
			var/obj/structure/stool/bed/chair/wheelchair/NG = new (H.loc)
			H.resting = FALSE
			H.lying = FALSE
			NG.buckle_mob(H,H)
		if(H.vice == "Smoker")
			for(var/obj/item/weapon/reagent_containers/food/snacks/organ/lungs/O in H.organ_storage)
				O.bumorgans()
			if(prob(5))
				H.contract_disease(new /datum/disease/croniccough,1,0)
		if(H.vice == "Alcoholic")
			for(var/obj/item/weapon/reagent_containers/food/snacks/organ/liver/O in H.organ_storage)
				O.bumorgans()
		if(H.vice == "Sexoholic")
			if(prob(15))
				H.contract_disease(new /datum/disease/aids,1,0)
		if(H.ckey in patreons)
			handle_patreon(H)

	proc/handle_patreon(var/mob/living/carbon/human/H)
		if(H.w_uniform && istype(H.w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/U = H.w_uniform
			U.medal_attached = new /obj/item/medal/patreon(U)
			U.medal_overlay()
			H.update_inv_w_uniform()

	proc/spawnId(var/mob/living/carbon/human/H, rank, title)
		if(!H)	return 0
		var/obj/item/weapon/card/id/C = null

		var/datum/job/job = null
		for(var/datum/job/J in occupations)
			if(J.title == rank)
				job = J
				break

		if(job)
			if(job.title == "Cyborg")
				return
			else if(job.title == "Migrant")
				return
			else if(job.title == "Bum")
				return
			else
				if(job.idtype)
					C = new job.idtype(H)
					C.access = job.get_access()
		else
			C = new /obj/item/weapon/card/id(H)
		if(C)
			C.registered_name = H.real_name
			C.rank = rank
			C.assignment = title ? title : rank
			C.name = "[C.registered_name]'s Ring"
			if(istype(C, /obj/item/weapon/card/id/lord))
				C.money_account = treasuryworth
				C.money_account.set_account(H, C.registered_name, C.assignment, treasuryworth.money)
			else
				C.money_account = new /datum/ring_account
				var/randomValue = rand(0,30)
				C.money_account.set_account(H, C.registered_name, C.assignment, job.money+randomValue)
				treasuryworth.add_money(job.money+randomValue)
			rings_account[C] = C.money_account
			//put the player's account number onto the ID
			if(H.mind && H.mind.initial_account)
				C.associated_account_number = H.mind.initial_account.account_number

			H.equip_to_slot_or_del(C, slot_wear_id)
/*
		H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_belt)
		if(locate(/obj/item/device/pda,H))
			var/obj/item/device/pda/pda = locate(/obj/item/device/pda,H)
			pda.owner = H.real_name
			pda.ownjob = C.assignment
			pda.name = "PDA-[H.real_name] ([pda.ownjob])"
*/
		return 1


	proc/LoadJobs(jobsfile) //ran during round setup, reads info from jobs.txt -- Urist
		if(!config.load_jobs_from_txt)
			return 0

		var/list/jobEntries = file2list(jobsfile)

		for(var/job in jobEntries)
			if(!job)
				continue

			job = trim(job)
			if (!length(job))
				continue

			var/pos = findtext(job, "=")
			var/name = null
			var/value = null

			if(pos)
				name = copytext(job, 1, pos)
				value = copytext(job, pos + 1)
			else
				continue

			if(name && value)
				var/datum/job/J = GetJob(name)
				if(!J)	continue
				J.total_positions = text2num(value)
				J.spawn_positions = text2num(value)
				if(name == "AI" || name == "Cyborg")//I dont like this here but it will do for now
					J.total_positions = 0

		return 1

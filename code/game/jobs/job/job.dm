/datum/job

	//The name of the job
	var/title = "NOPE"
	var/titlebr = "NAO"

	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()		//Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()				//Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)

	//Determines who can demote this position
	var/department_head = list()

	//Bitflags for the job
	var/flag = 0
	var/department_flag = 0

	//Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = "None"

	//How many players can be this job
	var/total_positions = 0

	//How many players can spawn in as this job
	var/spawn_positions = 0

	//How many players have this job
	var/current_positions = 0

	//Supervisors, who this person answers to directly
	var/supervisors = ""

	//Sellection screen color
	var/selection_color = "#ffffff"

	//the type of the ID the player will have
	var/idtype = /obj/item/weapon/card/id

	//If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	var/sex_lock

	var/no_trapoc

	var/latejoin_locked

	var/list/donation_lock = list()

	var/money = 0 // SPAWN MONEY, DEFAULT = 0

	var/list/job_whitelisted = list()

	var/thanati_chance

	var/minimal_character_age

	var/children

	var/jobdesc // use html_decode if you want to display anywhere other than html.
	var/jobdescbr

/mob/living/carbon/human/proc/playambi()
	var/area/newarea = get_area(src.loc)
	if(src.client)
		if(!src.client.ambience_playing)
			src.client.ambience_playing = 1
			src << sound(pick(newarea.forced_ambience), repeat = 1, wait = 1, volume = 30, channel = 2)
			spawn(3600)
				src.client.ambience_playing = 0

/mob/living/carbon/human/proc/qualarea()
	var/area/newarea = get_area(src.loc)
	if(lastarea)
		lastarea = newarea

/mob/living/carbon/human/proc/FuncArea()
	var/area/newarea = get_area(src.loc)
	newarea.Entered(src)

/datum/job/proc/equip(var/mob/living/carbon/human/H)
	H.my_skills.job_stats(title)
	H.my_stats.job_stats(title)
	H.old_job = src.title
	H.create_kg()
	return 1

/datum/job/proc/get_access()
	if(!config)	//Needed for robots.
		return src.minimal_access.Copy()

	if(config.jobs_have_minimal_access)
		return src.minimal_access.Copy()
	else
		return src.access.Copy()

/datum/job/proc/set_runtime_title(var/mob/living/carbon/human/H)
	return

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0)
		return 1	//Available in 0 days = available right now = player is old enough to play.
	return 0


/datum/job/proc/available_in_days(client/C)
	if(!C)
		return 0
	if(!config.use_age_restriction_for_jobs)
		return 0
	if(!isnum(C.player_age))
		return 0 //This is only a number if the db connection is established, otherwise it is text: "Requires database", meaning these restrictions cannot be enforced
	if(!isnum(minimal_player_age))
		return 0

	return max(0, minimal_player_age - C.player_age)
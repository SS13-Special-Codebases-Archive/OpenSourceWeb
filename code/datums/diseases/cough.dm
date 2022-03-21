/datum/disease/croniccough
	name = "Cough"
	max_stages = 3
	stage = 1
	spread = "Blood"
	spread_type = BLOOD
	cure = "No Cure"
	cure_id = null
	affected_species = list("Human", "Monkey")
	permeability_mod = 0.5
	severity = "Minor"

/datum/disease/aids/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(6))
				affected_mob.emote("cough")
		if(3)
			if(prob(8))
				affected_mob.emote("cough")
	return
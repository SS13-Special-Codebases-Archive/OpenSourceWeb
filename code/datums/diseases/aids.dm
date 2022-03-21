/datum/disease/aids
	name = "The Aids"
	max_stages = 3
	stage = 1
	spread = "Sexual Intercourse"
	spread_type = SPECIAL
	cure = "Rest & Spaceacillin"
	cure_id = "spaceacillin"
	agent = "acquired immunodeficiency syndrome"
	affected_species = list("Human", "Monkey")
	permeability_mod = 0.5
	desc = "If left untreated the subject will die."
	severity = "Minor"

/datum/disease/aids/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(5))
				affected_mob.bodytemperature += rand(0.1,1)
			if(prob(5))
				to_chat(affected_mob, "<span class='jogtowalk'><i>[pick("It itches!!","My SkIn Is BuRnInG!","My GrOiN ItChEs!")]</i></span>")
		if(3)
			if(prob(5))
				affected_mob.bodytemperature += rand(0.1,1)
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
	return
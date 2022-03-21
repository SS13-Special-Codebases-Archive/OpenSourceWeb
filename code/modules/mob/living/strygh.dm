//STRYGH
/mob/living/carbon/human/monster/strygh
	maxHealth = 120
	health = 120
	item_worth = 80

/datum/species/strygh
	name = "Strygh"
	icobase = 'icons/monsters/strygh.dmi'
	primitive = /mob/living/carbon/human/monster/strygh
	unarmed_type = /datum/unarmed_attack/claws
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong
	minheightm = 135
	maxheightm = 165
	minheightf = 135
	maxheightf = 165

/mob/living/carbon/human/monster/strygh/New()
	..()
	set_species("Strygh")
	var/selectedName = "[pick("Khor-Khor", "Gwon-Gwon")]"

	name = selectedName
	real_name = selectedName

	src.zone_sel = new /obj/screen/zone_sel( null )

	potenzia = rand(16, 25)
	my_stats.initst = 13
	my_stats.initht = 13
	my_stats.initdx = rand(12,16)
	my_stats.st = my_stats.initst
	my_stats.ht = my_stats.initht
	my_stats.dx = my_stats.initdx
	my_skills.CHANGE_SKILL(SKILL_MELEE, 14)
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

/mob/living/carbon/human/monster/strygh/Move()
	if(resting || stat)
		return ..()
	var/selectedSound = pick('sound/effects/strygh_life1.ogg', 'sound/effects/strygh_life2.ogg')
	playsound(loc, 'chameleon_step.ogg', 25, 0)
	if(prob(5))
		playsound(loc, selectedSound, 80, 1)
	return ..()

/mob/living/carbon/human/monster/strygh/movement_delay()
	return 1
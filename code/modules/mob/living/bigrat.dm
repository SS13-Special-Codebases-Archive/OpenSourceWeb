//RATON
/mob/living/carbon/human/monster/rat
	maxHealth = 30
	health = 30
	item_worth = 10
	name = "Big Rat"
	real_name = "Big Rat"
	attacksound = 'rat_attack.ogg'
	viewrange = 4
	zone_allowed = list("l_foot", "r_foot", "l_leg", "r_leg")

/mob/living/carbon/human/monster/rat/process()
	set background = 1

	target = null
	zone_sel.selecting = pick("l_foot", "r_foot", "l_leg", "r_leg")
	if (stat == 2)
		return 0
	if(weakened || paralysis || handcuffed || !canmove)
		return 1
	if(resting)
		mob_rest()
		return
	if(prob(20))
		step_rand(src)
	for(var/mob/living/carbon/human/H in orange(1, src.loc))
		combat_mode = 1
		if(prob(75))
			dir = get_dir(src, H)
			target = H
			attack_target()
			if(prob(25))
				return 1

			var/amountToRun = rand(1, 3)
			var/dirToGo = pick(cardinal)
			while(dirToGo == dir)
				dirToGo = pick(cardinal)
			for(var/x = 0; x != amountToRun; x++)
				var/turf/T = get_step(src, dirToGo)

				if(T.density)
					return 1
				for(var/atom/A in T.contents)
					if(A.density)
						return 1

				step_to(src, T)
				sleep(3)
		return 1
	return

/datum/species/rat
	name = "rat"
	icobase = 'icons/monsters/rat.dmi'
	primitive = /mob/living/carbon/human/monster/rat
	unarmed_type = /datum/unarmed_attack/rat
	secondary_unarmed_type = /datum/unarmed_attack/rat
	minheightm = 60
	maxheightm = 30
	minheightf = 30
	maxheightf = 60

/datum/unarmed_attack/rat
	attack_verb = list("slash", "bit")
	attack_sound = 'bite.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 1
	sharp = 1
	edge = 0

/mob/living/carbon/human/monster/rat/New()
	..()
	set_species("rat")

	src.zone_sel = new /obj/screen/zone_sel( null )
	potenzia = rand(16, 25)
	my_stats.initst = rand(2,3)
	my_stats.initht = rand(2,3)
	my_stats.initdx = rand(2,3)
	my_stats.st = my_stats.initst
	my_stats.ht = my_stats.initht
	my_stats.dx = my_stats.initdx
	my_skills.CHANGE_SKILL(SKILL_MELEE, rand(1,2))
	for(var/obj/item/weapon/reagent_containers/food/snacks/organ/O in src.organ_storage)
		O.bumorgans()
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

/mob/living/carbon/human/monster/rat/Move()
	if(resting || stat)
		return ..()
	var/selectedSound = pick('rat_life.ogg','rat_life2.ogg','rat_life3.ogg')
	if(prob(25))
		playsound(loc, selectedSound, 80, 1)
	return ..()

/mob/living/carbon/human/monster/rat/movement_delay()
	return 1

/mob/living/carbon/human/monster/rat/is_it_high()
	return FALSE
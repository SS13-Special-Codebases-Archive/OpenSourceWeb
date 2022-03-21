//EELO
/mob/living/carbon/human/skinless
	maxHealth = 120
	health = 120
	item_worth = 80
	var/cycle_pause = 15
	var/atom/target
	var/attacksound
	var/rushing = 0
	var/stamina = 100
	var/maxstamina = 100
	var/list/zone_allowed = list("chest", "head", "l_arm", "r_arm", "groin")
	var/viewrange = 6
	var/frustration = 1000
	bot = 1

/datum/species/skinless
	name = "skinless"
	icobase = 'icons/monsters/subhuman.dmi'
	primitive = /mob/living/carbon/human/skinless
	unarmed_type = /datum/unarmed_attack
	secondary_unarmed_type = /datum/unarmed_attack
	minheightm = 170
	maxheightm = 220
	minheightf = 170
	maxheightf = 220
	flags = NO_PAIN


/mob/living/carbon/human/skinless/Move()
	if(resting || stat)
		return ..()
	var/selectedSound = pick('sound/voice/skinless1.ogg', 'sound/voice/skinless2.ogg','sound/voice/skinless3.ogg','sound/voice/skinless4.ogg','sound/voice/skinless5.ogg')
	if(prob(10))
		src.sound2()
		src.emote("screams violently!")
		playsound(loc, selectedSound, 100, 1, 0, 0)
	return ..()

/mob/living/carbon/human/skinless/Life()
	nutrition = 900
	becoming_zombie = 0
	zombify = 0
	src.vessel.add_reagent("dentrine", 30)
	return ..()

/mob/living/carbon/human/skinless/New()
	..()

	set_species("skinless")
	gender = MALE
	src.real_name = random_name(src.gender)
	var/regex/R = regex("(^\\S+) (.*$)")
	R.Find(src.real_name)
	var/first_name = R.group[1]
	src.name = "[first_name] Skinless"
	src.real_name = "[first_name] Skinless"
	a_intent = "harm"
	src.zone_sel = new /obj/screen/zone_sel( null )
	var/skinless = pick("knife","club","spear")
	switch(skinless)
		if("knife")
			src.equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife/dagger/copper(src), slot_r_hand)
		if("club")
			src.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/club(src), slot_r_hand)
		if("spear")
			src.equip_to_slot_or_del(new /obj/item/weapon/claymore/wspear(src), slot_r_hand)
	if(prob(45))
		src.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/lw/ironopenhelmet(src), slot_head)
	if(prob(60))
		src.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_cuirass(src), slot_wear_suit)
	potenzia = rand(16, 25)
	my_stats.initst = rand(12,13)
	my_stats.initht = rand(10,13)
	my_stats.initdx = rand(10,11)
	my_stats.st = my_stats.initst
	my_stats.ht = my_stats.initht
	my_stats.dx = my_stats.initdx
	my_skills.CHANGE_SKILL(SKILL_MELEE, 11)
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

/mob/living/carbon/human/skinless
	proc/attack_target()

		var/direct = get_dir(src, target)
		if ( (direct - 1) & direct)
			var/turf/Step_1
			var/turf/Step_2
			switch(direct)
				if(EAST|NORTH)
					Step_1 = get_step(src, NORTH)
					Step_2 = get_step(src, EAST)

				if(EAST|SOUTH)
					Step_1 = get_step(src, SOUTH)
					Step_2 = get_step(src, EAST)

				if(NORTH|WEST)
					Step_1 = get_step(src, NORTH)
					Step_2 = get_step(src, WEST)

				if(SOUTH|WEST)
					Step_1 = get_step(src, SOUTH)
					Step_2 = get_step(src, WEST)

			if(Step_1 && Step_2)
				var/check_1 = 1
				var/check_2 = 1

				check_1 = Adjacent(get_turf(src), Step_1, target) && Adjacent(Step_1, get_turf(target), target)

				check_2 = Adjacent(get_turf(src), Step_2, target) && Adjacent(Step_2, get_turf(target), target)

				if(check_1 || check_2)
					target.attack_hand(src)
					return
				else
					var/obj/structure/window/W = locate() in target.loc
					var/obj/structure/window/WW = locate() in src.loc
					if(W)
						if(src.r_hand || src.l_hand)
							if(r_hand)
								W.attackby(r_hand, src)
							else
								if(l_hand)
									W.attackby(l_hand, src)
						else
							W.attack_hand(src)
						return 1
					else if(WW)
						if(src.r_hand || src.l_hand)
							if(r_hand)
								WW.attackby(r_hand, src)
							else
								if(l_hand)
									WW.attackby(l_hand, src)
						else
							WW.attack_hand(src)
						return 1
		if(!loc) return
		if(!target) return
		else if(Adjacent(src?.loc , target?.loc,target))
			if(src.r_hand || src.l_hand)
				if(r_hand)
					target.attackby(r_hand, src)
				else
					if(l_hand)
						target.attackby(l_hand, src)
			else
				target.attack_hand(src)
				if(prob(50) && attacksound)
					playsound(loc, attacksound, 80, 0)
			//target.attack_hand(src)
			// sometimes push the enemy
			if(prob(10))
				step(src,direct)
			else
				if(prob(30))
					zone_sel.selecting = pick(zone_allowed)
					kick_act(target)
				else
					if(prob(18))
						zone_sel.selecting = pick(zone_allowed)
						steal_act(target)
			return 1
		else
			var/obj/structure/window/W = locate() in target.loc
			var/obj/structure/window/WW = locate() in src.loc
			if(W)
				if(src.r_hand || src.l_hand)
					if(r_hand)
						W.attackby(r_hand, src)
					else
						if(l_hand)
							W.attackby(l_hand, src)
				else
					W.attack_hand(src)
				return 1
			else if(WW)
				if(src.r_hand || src.l_hand)
					if(r_hand)
						WW.attackby(r_hand, src)
					else
						if(l_hand)
							WW.attackby(l_hand, src)
				else
					WW.attack_hand(src)
				return 1
	proc/process()
		set background = 1
		..()
		if(client)
			return FALSE

		zone_sel.selecting = pick(zone_allowed)
		if (stat == DEAD)
			return FALSE
		if(resting)
			mob_rest()
			return

		stamina++
		if(stamina >= maxstamina)
			stamina = maxstamina
		if (!target)
			// no target, look for a new one

			// look for a target, taking into consideration their health
			// and distance from the zombie
			var/last_health = INFINITY
			combat_mode = 0
			if(resting)
				mob_rest()
			for (var/mob/living/carbon/human/C in orange(viewrange-2,src.loc))
				var/dist = get_dist(src, C)

				// if the zombie can't directly see the human, they're
				// probably blocked off by a wall, so act as if the
				// human is further away
				if(!(C in view(src, viewrange)))
					dist += 3

				if (C.stat == 2 || istype(C, /mob/living/carbon/human/skinless) || !can_see(src,C,viewrange) || C.consyte)
					continue
				if(C.stunned || C.paralysis || C.weakened)
					target = C
					break
				if(C.health < last_health) if(!prob(30))
					last_health = C.health
					target = C

		// if we have found a target
		if(target)

			if(stamina >= 40)
				if(prob(5))
					jump_act(target, src)
			if(stamina == maxstamina && species.name == "Graga")
				rushing = 1
				stamina = 0
				var/selectedSound = pick('sound/effects/graga_life1.ogg', 'sound/effects/graga_life2.ogg', 'sound/effects/graga_life3.ogg')
				playsound(loc, selectedSound, 70, 0)
				cycle_pause = 5
				spawn(150)
					rushing = 0
					cycle_pause = 15
				return

			for(var/direction in cardinal)
				var/turf/T = get_step(src, direction)
				for(var/atom/A in T?.contents)
					if(ismob(A))
						continue
					if(istype(A, /obj/multiz/stairs/))
						continue
					if(A.density  && src.my_stats.st >= 20)
						qdel(A)
				if(T.density && src.my_stats.st >= 20)
					qdel(T)

			// change the target if there is another human that is closer
			for (var/mob/living/carbon/human/C in orange(2,src.loc))
				if (C.stat == 2 || istype(C, /mob/living/carbon/human/skinless) || C.consyte)
					continue
				if(get_dist(src, target) >= get_dist(src, C) && prob(30) && !rushing)
					target = C
					break

			if(ismob(target))
				var/mob/T = target
				if(T.stat == 2)
					target = null

			var/distance = get_dist(src, target)

			if(target in orange(viewrange,src))
				if(distance <= 1 && !rushing)
					if(attack_target())
						return 1
				if(step_towards_3d(src,target))
					return 1
			else
				target = null
				return 1

		// if there is no target in range, roam randomly
		else

			frustration--
			frustration = max(frustration, 0)

			if(stat == 2) return 0

			var/prev_loc = loc
			// make sure they don't walk into space
			if(!(locate(/turf/space) in get_step(src,dir)) && !(locate(/turf/simulated/floor/open) in get_step(src,dir)))
				step(src,dir)
			// if we couldn't move, pick a different direction
			// also change the direction at random sometimes
			if(loc == prev_loc || prob(20))
				sleep(5)
				dir = pick(NORTH,SOUTH,EAST,WEST)

			return 1

		// if we couldn't do anything, take a random step
		step_rand(src)
		dir = get_dir(src,target) // still face to the target
		frustration++

		return 1
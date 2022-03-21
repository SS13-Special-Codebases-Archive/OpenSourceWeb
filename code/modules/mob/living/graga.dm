/mob/living/carbon/human/monster
	var/AIControlled = 0
	var/stance = HOSTILE_STANCE_ATTACK
	var/atom/target
	var/list/mobListView = list()
	var/viewrange = 6
	var/frustration = 1000
	bot = 1
	var/attacksound
	a_intent = "hurt"
	var/cycle_pause = 15
	var/list/zone_allowed = list("chest", "head", "l_arm", "r_arm", "groin")
	icon = 'human.dmi'

	var/rushing = 0
	var/stamina = 100
	var/maxstamina = 100
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

				if (C.stat == 2 || istype(C, /mob/living/carbon/human/monster) || !can_see(src,C,viewrange) || C.consyte)
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
			if(stamina == maxstamina && species?.name == "Graga")
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
				if (C.stat == 2 || istype(C, /mob/living/carbon/human/monster) || C.consyte)
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

/mob/living/carbon/human/monster/update_inv_gloves() //stops bloody hands from appearing on monsters
	return

/mob/living/carbon/human/monster/firstvictimCheck()
	return

/mob/living/carbon/human/monster/graga
	desc = "What the hell is that thing?! It looks like a fucking monster bodybuilder!?"
	maxHealth = 1000
	health = 1000
	item_worth = 300
	// main loop

/datum/species/graga
	name = "Graga"
	icobase = 'icons/monsters/graga.dmi'
	primitive = /mob/living/carbon/human/monster/graga
	minheightm = 200
	maxheightm = 240
	minheightf = 200
	maxheightf = 240

/mob/living/carbon/human/monster/graga/New()
	..()
	set_species("Graga")
	var/selectedName = "[pick("Copetti", "Gutus", "Nenem", "Toby", "Bidu", "Mel", "Negresco", "Fatherless", "Cachorro Azul", "Pai do Borg")]"
	equip_to_slot_or_del(new /obj/item/clothing/under/GRAGA(src), slot_w_uniform)
	name = selectedName
	real_name = selectedName
	my_stats.initst = 100
	my_stats.initht = 50
	my_stats.initdx = rand(8, 10)
	my_stats.st = my_stats.initst
	my_stats.ht = my_stats.initht
	my_stats.dx = my_stats.initdx
	my_skills.CHANGE_SKILL(SKILL_MELEE, 14)

	src.zone_sel = new /obj/screen/zone_sel( null )

	potenzia = rand(16, 25)
	if(name == "Negresco")
		color = "#A52A2A"
		potenzia = rand(25, 40)

	if(!mind)
		mind = new /datum/mind(src)
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

/mob/living/carbon/human/monster/graga/say()
	var/selectedSound = pick('sound/effects/graga_life1.ogg', 'sound/effects/graga_life2.ogg', 'sound/effects/graga_life3.ogg')
	playsound(src.loc, selectedSound, 100, 1)
	sleep(100)

/mob/living/carbon/human/monster/graga/Move()
	if(resting || stat)
		return ..()
	var/selectedSound = pick('sound/effects/graga_life1.ogg', 'sound/effects/graga_life2.ogg', 'sound/effects/graga_life3.ogg')
	var/stepSound = pick('sound/effects/graga_step1.ogg', 'sound/effects/graga_step2.ogg')
	playsound(loc, stepSound, 70, 0)
	if(prob(5))
		playsound(loc, selectedSound, 100, 1)

	for(var/mob/living/carbon/human/H in view(world.view, src))
		shake_camera(H, 1, 1)
	for(var/mob/living/carbon/human/H in loc.contents)
		if(H != src)
			H.apply_damage(rand(45, 65), BRUTE, pick("head", "l_arm", "r_arm", "l_leg", "r_leg", "chest", "groin"))
	return ..()

/mob/living/carbon/human/monster/graga/movement_delay()
	if(rushing)
		return -2
	return 5

/mob/living/carbon/human/monster/Life()
	nutrition = 900
	becoming_zombie = 0
	zombify = 0
	src.vessel.add_reagent("dentrine", 30)
	return ..()

/proc/ismonster(var/mob/M)
	if(istype(M, /mob/living/carbon/human/monster))
		return 1

/mob/living/carbon/human/monster/examine()
	to_chat(usr, "<span class='combat'>Eeeww!</span>")
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(!H.StingerSeen.Find(src))
			H.StingerSeen.Add(src)
			H << sound(pick('sound/tension/tension.ogg','sound/tension/tension2.ogg','sound/tension/tension3.ogg','sound/tension/tension4.ogg','sound/tension/tension5.ogg','sound/tension/tension6.ogg','sound/tension/tension7.ogg'), repeat = 0, wait = 0, volume = H?.client?.prefs?.ambi_volume, channel = 23)
	..()
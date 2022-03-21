#define cycle_pause 15 //min 1
#define viewrange 4 //min 2

#define BUM_SLEEP 0
#define BUM_ATTACK 1
#define BUM_IDLE 2
var/michael_shepard = FALSE

/mob/living/carbon/human/bumbot/Move()
	..()
	if(stat != 0)
		return
	if(prob(6))
		say(pick(bumquotes))
	if(prob(0.5))
		emote(pick("cry","scream","laugh"))

var/list/bumquotes = list("Cold... So cold...","Did you know?","People are so stupid compared to me.","Are we there yet?","Not enough love.","This fortress is my substitute for love.","Everything is fake.","I can't keep it in my mind. Can you help me?","Well, as usual","Vampires drink blood.","But if these ravens disappear one of these nights, the sun will still shine forever.","We need to endure it a little.","Today is just like yesterday.","It would be fun, but no.","Will I die in a great way?","I make a mistake here.","You've changed!","Long ago, I was a lord.","Meat eaters, bone gnawlers, skin lickers...","Foe","HOW DOES IT FEEL?!","I was told I do.", "I'm not a bum, I'm sapient!", "Who am I? I'm a hard worker. I set high goals and I've been told that I'm persistent.", "I surrender!")

/mob/living/carbon/human/bumbot/examine()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(!H.StingerSeen.Find(src))
			H.StingerSeen.Add(src)
			H << sound(pick('sound/tension/tension.ogg','sound/tension/tension2.ogg','sound/tension/tension3.ogg','sound/tension/tension4.ogg','sound/tension/tension5.ogg','sound/tension/tension6.ogg','sound/tension/tension7.ogg'), repeat = 0, wait = 0, volume = H?.client?.prefs?.ambi_volume, channel = 23)
	..()

/mob/living/carbon/human/bumbot
	name = "Michael Shepard"
	real_name = "Michael Shepard"
	voice_name = "Michael Shepard"
	a_intent = "hurt"
	density = 1
	var/list/path = new/list()
	var/frustration = 0
	var/atom/object_target
	var/reach_unable
	var/mob/living/carbon/target
	var/list/path_target = new/list()
	bot = 1
	var/list/path_idle = new/list()
	var/list/objects
	health = 100

	New()
		..()
		sleep(10)
		if(!mind)
			mind = new /datum/mind(src)
		// main loop
		spawn while(stat != 2 && bot)
			sleep(cycle_pause)
			src.process()
		src.zone_sel = new /obj/screen/zone_sel( null )
		zone_sel.selecting = pick("chest","head","l_arm","r_arm","throat","mouth","right eye","left eye","vitals","r_hand","l_hand","groin","l_leg","r_leg","r_foot","l_foot")
		real_name  = random_name()
		var/regex/R = regex("(^\\S+) (.*$)")
		R.Find(real_name)
		var/first_name = R.group[1]
		real_name = first_name
		name = real_name
		gender = pick(MALE,FEMALE)
		job = "Bum"
		voice_name = real_name
		my_skills.CHANGE_SKILL(SKILL_MELEE, rand(1,7))
		my_stats.st = rand(7,13)
		my_stats.ht = rand(7,14)
		my_stats.dx = rand(7,15)
		if(prob(2))
			real_name =  "[first_name] The Strong"
			name = real_name
			my_skills.CHANGE_SKILL(SKILL_MELEE, rand(1,7))
			my_stats.st = rand(18,25)
			my_stats.ht = rand(20,25)
			my_stats.dx = rand(12,15)
			my_stats.it = rand(3,5)
			if(gender == MALE)
				mutations += FAT
		voicetype = pick("hobo")
		for(var/obj/item/weapon/reagent_containers/food/snacks/organ/O in src.organ_storage)
			O.bumorgans()
		hygiene = -400
		if(gender == MALE)
			f_style = random_facial_hair_style(gender = src.gender, species = "Human")
		h_style = random_hair_style(gender = src.gender, species = "Human")
		regenerate_icons()
		var/bumweapon = pick("knife","club")
		if(prob(1))
			bumweapon = "revolver"
		switch(bumweapon)
			if("knife")
				if(prob(50))
					equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife/dagger/copper(src), slot_r_hand)
				else
					equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife(src), slot_r_hand)
			if("club")
				equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/woodenclub(src), slot_r_hand)
			if("revolver")
				equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/newRevolver/duelista/neoclassic(src), slot_r_hand)
		equip_to_slot_or_del(new /obj/item/clothing/under/rank/migrant/bum(src), slot_w_uniform)
		if(prob(30))
			say(pick(bumquotes))

		if(prob(90))
			virgin = FALSE
			contract_disease(new /datum/disease/aids,1,0)

	// this is called when the target is within one tile
	// of distance from the zombie
	proc/attack_target(var/mob/living/carbon/human/target)
		if(!target)
			return
		if(target?.stat != CONSCIOUS && prob(70))
			return
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
					var/obj/structure/rack/lwtable/W = locate() in target.loc
					var/obj/structure/rack/lwtable/WW = locate() in src.loc
					if(W)
						W.climb_table(src)
						return 1
					else if(WW)
						WW.climb_table(src)
						return 1
/*					var/obj/structure/window/W = locate() in target.loc
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
							else if(l_hand)
								WW.attackby(l_hand, src)
						else
							WW.attack_hand(src)
						return 1*/
		else if(Adjacent(src?.loc , target?.loc,target))
			if(src.r_hand || src.l_hand)
				if(r_hand && istype(r_hand, /obj/item))
					target.attackby(r_hand, src)
				else
					if(l_hand && istype(l_hand, /obj/item))
						target.attackby(l_hand, src)
			else
				target.attack_hand(src)
			//target.attack_hand(src)
			// sometimes push the enemy
			if(prob(80))
				if(prob(10))
					step(src,direct)
				else
					if(prob(80))
						zone_sel.selecting = pick("groin","l_leg","r_leg","r_foot","l_foot")
						target.kick_act(src)
					else
						if(prob(80))
							zone_sel.selecting = pick("chest","vitals","r_hand","l_hand","groin")
							target.steal_act(src)
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
				if(r_hand)
					WW.attackby(r_hand, src)
				else if(l_hand)
					WW.attackby(l_hand, src)
				else
					WW.attack_hand(src)
				return 1

	// main loop
	proc/process()
		set background = 1

		if (stat == 2)
			return 0
		if(weakened || paralysis || handcuffed || !canmove)
			return 1
		if(resting)
			mob_rest()
			return

		if(destroy_on_path())
			return 1

		combat_mode = 0
		if(target)
			// change the target if there is another human that is closer
			if(prob(30))
				target = null
			for (var/mob/living/carbon/C in orange(2,src.loc))
				if (C.stat == 2|| !can_see(src,C,viewrange))
					continue
				if (istype(C, /mob/living/carbon/human/bumbot))
					continue
				if(get_dist(src, target) >= get_dist(src, C) && prob(30))
					target = C
					break

			if(target?.stat == 2)
				target = null


			var/distance = get_dist(src, target)

			if(target in orange(viewrange,src))
				if(distance <= 1)
					if(attack_target())
						var/turf/T = get_step(src, target.dir)
						for(var/atom/A in T.contents)
							if(A.density)
								return 1
						if(!T.density)
							Move(T)
						return 1
				if(step_towards_3d(src,target))
					return 1
			else
				target = null
				return 1
		if(prob(20))
			step_rand(src)
		for(var/mob/living/carbon/human/H in orange(1, src.loc))
			if (!istype(H, /mob/living/carbon/human/bumbot))
				combat_mode = 1
				if(prob(75))
					var/face = 0
					if(grabbed_by.len)
						for(var/x = 1; x <= grabbed_by.len; x++)
							if(grabbed_by[x])
								face = 1
								break

					if(face)
						resist()
					if(!face)
						dir = get_dir(src, H)
						attack_target(H)
					target = H
				return 1
		return

	// destroy items on the path
	proc/destroy_on_path()
		// if we already have a target, use that
		if(object_target)
			if(!object_target.density)
				object_target = null
				frustration = 0
			else
				// we know the target has attack_hand
				// since we only use such objects as the target
				object_target:attack_hand(src)
				return 1

		// first, try to destroy airlocks and walls that are in the way
		if(locate(/obj/machinery/door/airlock) in get_step(src,src.dir))
			var/obj/machinery/door/airlock/D = locate() in get_step(src,src.dir)
			if(D)
				if(D.density && !(locate(/turf/space) in range(1,D)) )
					D.attack_hand(src)
					object_target = D
					return 1
		// before clawing through walls, try to find a direct path first
		if(frustration > 8 )
			if(istype(get_step(src,src.dir),/turf/simulated/wall))
				var/turf/simulated/wall/W = get_step(src,src.dir)
				if(W)
					if(W.density && !(locate(/turf/space) in range(1,W)))
						W.attack_hand(src)
						object_target = W
						return 1
		return 0

	death()
		..()
		target = null

/mob/living/carbon/human/bumbot/firstvictimCheck()
	return
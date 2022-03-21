/datum/arellitstats
	var/toughnessmax = 5 //LIMITE PRA ESSA CAPACIDADE DO ARELLIT
	var/speedmax = 5 //LIMITE PRA ESSA CAPACIDADE DO ARELLIT
	var/damagenessmax = 5 //LIMITE PRA ESSA CAPACIDADE DO ARELLIT
	var/toughness = 1 // INFLUENCIA NA FORMAÇAO DE VIDA DO ARELLIT
	var/speed = 1 // INFLUENCIA QUANTO DE VELOCIDADE O ARELLIT TEM
	var/damageness = 1 // INFLUENCIA QUANTO DE DANO O ARELLIT VAI DAR

/mob/living/carbon/human/monster/arellit
	maxHealth = 80
	health = 80
	item_worth = 10
	name = "Arelit"
	real_name = "Arelit"
	plane = 10
	viewrange = 3
	var/datum/arellitstats/arestats = new()
	var/fome = 0 //SO INFLUENCIA NO TESAO
	var/tamed = FALSE
	var/querotransar = 0 //MINHA VONTADE COM A MAE DE QUEM TA LENDO
	var/virgem = TRUE // A MAE DE VOCES NUNCA VAI SER ISSO KKKKKKKKKKK
	zone_allowed = list("neck", "head", "r_arm", "l_arm")
	var/mob/living/carbon/human/master = null
	var/mob/living/carbon/human/list/failed_tamers = list()
	flags = NO_SLIP

/mob/living/carbon/human/monster/arellit/Destroy()
	master = null
	failed_tamers = null
	return ..()

/mob/living/carbon/human/monster/arellit/baby
	maxHealth = 20
	health = 20
	name = "Arelityonoks"
	real_name = "Arelityonoks"
	viewrange = 2
	zone_allowed = list("r_foot", "l_foot", "r_leg", "l_leg", "groin")

/mob/living/carbon/human/monster/arellit/New()
	..()
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

/mob/living/carbon/human/monster/arellit/adult/New()
	..()
	set_species("arellit")
	src.zone_sel = new /obj/screen/zone_sel( null )
	my_stats.initst = rand(5,6)
	my_stats.initht = rand(9,13)
	my_stats.initdx = rand(10,13)
	my_stats.st = my_stats.initst
	my_stats.ht = my_stats.initht
	my_stats.dx = my_stats.initdx
	my_skills.CHANGE_SKILL(SKILL_MELEE, rand(1,3))

/mob/living/carbon/human/monster/arellit/baby/New()
	..()
	set_species("arellitbaby")

	my_stats.initst = rand(1,4)
	my_stats.initht = rand(1,4)
	my_stats.initdx = rand(1,4)
	my_stats.st = my_stats.initst
	my_stats.ht = my_stats.initht
	my_stats.dx = my_stats.initdx
	my_skills.CHANGE_SKILL(SKILL_MELEE, rand(1,3))

	spawn(3 MINUTES)
		var/mob/living/carbon/human/monster/arellit/adult/A = new(loc)
		mob_list -= src
		A.arestats = arestats
		qdel(src)

/mob/living/carbon/human/monster/arellit/Move()
	if(resting || stat)
		return ..()
	var/selectedSound = 'sound/effects/arl_step.ogg'
	if(prob(50))
		playsound(loc, selectedSound, 30, 1)
	return ..()

/mob/living/carbon/human/monster/arellit/adult/proc/tentarsexo(var/mob/living/carbon/human/monster/arellit/adult/vitima)
	if(!querotransar) return
	if(!vitima.querotransar) return vitima.rolldesexo();

	var/umbabychance = 4
	if(!prob(umbabychance)) return

	sexo(vitima)

/mob/living/carbon/human/monster/arellit/adult/proc/rolldesexo()
	if(querotransar) return
	if(fome < 3)
		return
	for(var/mob/living/carbon/human/monster/arellit/adult/A in orange(1, loc))
		if(!type == A.type) return
		var/chancedetesao = 10
		if(A == src) return;
		if(A.fome < 3)
			return 0
		if(!virgem)
			chancedetesao -= 9
		if(/mob/living/carbon/human in view(5, loc))
			chancedetesao -= 2
		if(!prob(max(1, chancedetesao)))
			return 0

		querotransar = 1
		return 1

/mob/living/carbon/human/monster/arellit/adult/proc/sexo(var/mob/living/carbon/human/monster/arellit/adult/puta)
	if(!puta) return
	if(!puta.querotransar && !puta.rolldesexo())
		return
	visible_message("<span class='examinebold'>[src]</span><span class='examine'> kisses </span><span class='examinebold'>[puta]</span>")
	querotransar = 0
	puta.querotransar = 0

	virgem = FALSE
	puta.virgem =  FALSE

	fome = 0
	puta.fome = 0

	var/obj/structure/eggarellit/A = new(loc)
	A.pai = arestats
	A.mae = puta.arestats
	return A

/obj/structure/eggarellit
	name = "arelit egg"
	icon = 'icons/egg.dmi'
	desc = "I wonder what's inside"
	density = 0
	var/datum/arellitstats/pai
	var/datum/arellitstats/mae

/obj/structure/eggarellit/New()
	..()
	spawn(rand(300, 750))
		daraluz(pai, mae)
		qdel(src)

/obj/structure/eggarellit/proc/daraluz(var/datum/arellitstats/pai, var/datum/arellitstats/mae)
	var/mob/living/carbon/human/monster/arellit/baby/AA = new(loc)
	var/datum/arellitstats/aredatum = new

	aredatum.toughnessmax =  (mae.toughnessmax + pai.toughnessmax) / rand(1, 2);
	aredatum.speedmax = (mae.speedmax + pai.speedmax) / rand(1, 2);
	aredatum.damagenessmax = (mae.damagenessmax + pai.damagenessmax) / rand(1, 2);

	aredatum.toughness = pick(pai, mae).toughness
	aredatum.speed = pick(pai, mae).speed
	aredatum.damageness = pick(pai, mae).damageness

	AA.arestats = aredatum

	var/novavida = aredatum.toughness * 15
	AA.maxHealth = novavida
	AA.health = novavida

	return AA;

/mob/living/carbon/human/monster/arellit/process()
	set background = 1

	combat_mode = 0

	if(stat == 2)
		return 0
	if(weakened || paralysis || handcuffed || !canmove)
		return 0
	if(buckled_mob) return
	if(resting)
		mob_rest()
		return
	if(prob(35))
		var/list/possibleDirs = list(NORTH, EAST, WEST, SOUTH)
		var/chosenDir = pick(possibleDirs)
		step(src, chosenDir);
	if(prob(60))
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in orange(1, loc))
			if(prob(50)) continue;
			qdel(G)
			visible_message("<span class='passivebold'><b>[name]</b> eats <b>[G.name]!</b></span>")
			fome++
			src.get_snack_effect(G)

	for(var/mob/living/carbon/human/H in orange(1, src.loc))
		if(!ismonster(H)) return;

		combat_mode = 1
		if(!tamed)
			if(prob(60))
				dir = get_dir(src, H)
				attack_target(H)
	return 1

/mob/living/carbon/human/monster/arellit/adult/process()
	if(!..()) return
	if(prob(40))
		rolldesexo();
		for(var/mob/living/carbon/human/monster/arellit/adult/A in orange(1, loc))
			if(A == src) continue
			tentarsexo(A)

/mob/living/carbon/human/proc/buckle_mob(var/mob/victim)
	victim.buckled = src
	victim.loc = loc
	buckled_mob = victim

	if(!lying)
		buckled_mob.mob_rest()
	buckled_mob.pixel_y = 2
	victim.update_canmove()

/mob/living/carbon/human/proc/unbuckle()
	if(!buckled_mob) return

	buckled_mob.buckled = null
	buckled_mob.update_canmove()
	buckled_mob = null

	buckled_mob.pixel_y = initial(buckled_mob.pixel_x)

/mob/living/carbon/human/monster/arellit/adult/attack_hand(mob/living/carbon/human/H as mob)
	if(H.a_intent != "help" || buckled_mob  != H) return ..()
	unbuckle()

/mob/living/carbon/human/monster/arellit/adult/MouseDrop_T(mob/victim as mob, mob/user as mob)
	if(victim != user) return ..()
	if(type != /mob/living/carbon/human/monster/arellit/adult) return ..();
	if(ishuman(victim))
		if(istype(victim:species, /datum/species/human/alien))
			return
	if(!victim.lying) return ..()
	if(!tamed) return ..()
	buckle_mob(user)

/mob/living/carbon/human/Move()
	..()
	if(!buckled_mob) return;

	buckled_mob.dir = dir
	buckled_mob.loc = loc

/mob/living/carbon/human/Move(NewLoc)
	if(isChild() || isMidget())
		pixel_y = -4
	else
		pixel_y = initial(pixel_y)
	pixel_x = initial(pixel_x)
	plane = initial(plane)
	isLeaning = 0
	..()
	if(malabares)
		malabares.loc = loc
		malabares.glide_size = glide_size
		switch(dir)
			if(NORTH)
				malabares.plane = 10
				malabares.pixel_x = 0
				malabares.pixel_y = 7
			if(EAST)
				malabares.plane = 15
				malabares.pixel_x = 5
				malabares.pixel_y = 7
			if(WEST)
				malabares.plane = 15
				malabares.pixel_x = -5
				malabares.pixel_y = 7
			if(SOUTH)
				malabares.plane = 15
				malabares.pixel_x = 0
				malabares.pixel_y = 7
	if(istype(buckled, /mob/living/carbon/human))
		var/mob/living/carbon/human/A = buckled

		if(A.lying)
			src.buckled = null
			src.update_canmove()
			src = null

			src.mob_rest()

		A.loc = loc
		A.dir = dir

		A.glide_size = glide_size
		update_vision_cone()

		A.plane = initial(A.plane)
		pixel_y = 5
		switch(dir)
			if(NORTH)
				A.plane = plane - 1
			if(EAST)
				pixel_x = -5
			if(WEST)
				pixel_x = 5
	if(istype(buckled_mob, /mob/living/carbon/human))


		var/mob/living/carbon/human/A = buckled_mob
		var/neededST = 7
		if(A.gender == "female")
			neededST = 9
		if(A.gender == "male")
			neededST = 10
		if(isMidget(A))
			neededST = 9
		if(FAT in A.mutations)
			neededST = 12
		if(isChild(A))
			neededST = 7

		if(neededST > src?.my_stats?.st && !istype(src, /mob/living/carbon/human/monster/arellit/adult))
			unbuckle()
			playsound(A.loc, 'sound/effects/fallsmash.ogg', 50, 0)//Splat
			A.apply_damage(10/2 + rand(-5,12), BRUTE, "l_leg")
			A.apply_damage(10/2 + rand(-5,12), BRUTE, "r_leg")
			A.apply_damage(10 + rand(-5,12), BRUTE, "l_foot")
			A.apply_damage(10 + rand(-5,12), BRUTE, "r_foot")
			A.mob_rest()

			src.apply_damage(10/2 + rand(-5,12), BRUTE, "l_leg")
			src.apply_damage(10/2 + rand(-5,12), BRUTE, "r_leg")
			src.apply_damage(10 + rand(-5,12), BRUTE, "l_foot")
			src.apply_damage(10 + rand(-5,12), BRUTE, "r_foot")
			src.mob_rest()

		A.loc = loc
		A.dir = dir

		A.glide_size = glide_size
		update_vision_cone()

		A.plane = initial(A.plane)
		A.layer = 3.9
		A.pixel_y = 7
		switch(dir)
			if(NORTH)
				A.layer = 4.1
				A.pixel_x = 0
				A.pixel_y = 7
			if(EAST)
				A.layer = 3.9
				A.pixel_x = -5
				A.pixel_y = 7
			if(WEST)
				A.layer = 3.9
				A.pixel_x = 5
				A.pixel_y = 7
			if(SOUTH)
				A.layer = 3.9
				A.pixel_x = 0
				A.pixel_y = 7

/mob/living/carbon/human/Bump(atom/movable/target as mob|obj)
	if(!istype(buckled, /mob/living/carbon/human/monster)) return ..();
	var/obj/item/Itm = get_active_hand()
	if(!Itm) return ..();
	if(!ishuman(target)) return ..();
	if(!combat_mode) return ..();

	var/mob/living/carbon/human/victim = target
	Itm.attack(victim, src)

/mob/living/carbon/human/movement_delay()
	if(!istype(buckled, /mob/living/carbon/human/monster)) return ..();

	var/mob/living/carbon/human/monster/arellit/A = buckled
	var/speed = !A.arestats.speed ? 10 : 9 / A.arestats.speed
	return speed

/mob/living/carbon/human/monster/arellit/proc/tame_attempt(mob/user)
	if(!ishuman(user) || failed_tamers.Find(user) || tamed)
		return
	var/mob/living/carbon/human/H = user
	var/list/roll = roll3d6(H, SKILL_RIDE, null,TRUE)
	var/result = roll[GP_RESULT]
	switch(result)
		if(GP_SUCCESS, GP_CRITSUCCESS)
			master = user
			tamed = TRUE
		else
			failed_tamers |= H
			return

/mob/living/carbon/human/monster/arellit/proc/name_attempt(mob/user,var/message)
	if(!tamed || master != user)
		return
	if(length(message) >= 21)
		return
	name = message
	real_name = message

/mob/living/carbon/human/monster/arellit/attackby(obj/item/C,mob/user)
	if(istype(C,/obj/item/weapon/reagent_containers/food/snacks/grown))
		visible_message("<span class='passive'><b>[src]</b> eats \the <b>[C.name]!</b></span>")
		playsound(src.loc, pick('sound/webbers/flesh_eat_01.ogg', 'sound/webbers/flesh_eat_02.ogg', 'sound/webbers/flesh_eat_03.ogg', 'sound/webbers/flesh_eat_04.ogg', 'sound/webbers/flesh_eat_05.ogg', 'sound/webbers/flesh_eat_06.ogg'), rand(40,50), 0)//Splat
		fome++
		src.get_snack_effect(C)
		qdel(C)
		return

	return ..()

/mob/living/carbon/human/monster/arellit/proc/get_snack_effect(obj/item/weapon/reagent_containers/food/snacks/grown/G)
	if(istype(src, /mob/living/carbon/human/monster/arellit/adult))
		return

	switch(G.type)
		if(/obj/item/weapon/reagent_containers/food/snacks/grown/carrot)
			if(arestats.speedmax <= arestats.speed)
				return
			arestats.speed++
		if(/obj/item/weapon/reagent_containers/food/snacks/grown/apple)
			if(arestats.toughnessmax <= arestats.toughness)
				return
			arestats.toughness++
		if(/obj/item/weapon/reagent_containers/food/snacks/grown/lemon)
			if(arestats.damagenessmax <= arestats.damageness)
				return
			arestats.damageness++

/datum/species/arellit/baby
	name = "arellitbaby"
	icobase = 'icons/monsters/arellitbaby.dmi'
	primitive = /mob/living/carbon/human/monster/arellit/baby
	unarmed_type = /datum/unarmed_attack/arelbite
	secondary_unarmed_type = /datum/unarmed_attack/arelbite
	minheightm = 140
	maxheightm = 170
	minheightf = 140
	maxheightf = 170

/datum/species/arellit
	name = "arellit"
	icobase = 'icons/monsters/arellit.dmi'
	primitive = /mob/living/carbon/human/monster/arellit
	unarmed_type = /datum/unarmed_attack/arelbite
	secondary_unarmed_type = /datum/unarmed_attack/arelbite
	minheightm = 140
	maxheightm = 170
	minheightf = 140
	maxheightf = 170

/datum/unarmed_attack/arelbite
	attack_verb = list("hits","slash")
	attack_sound = 'bite.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 10
	sharp = 1
	edge = 0

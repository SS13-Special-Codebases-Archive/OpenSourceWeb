//new monkey
/mob/living/carbon/human/monster/newmonkey
	maxHealth = 50
	health = 50
	item_worth = 10
	name = "Monkey"
	real_name = "Monkey"
	attacksound = 'monkey1.ogg'
	viewrange = 4

/mob/living/carbon/human/monster/newmonkey/macaco
	name = "Macaco"
	real_name = "Macaco"
	item_worth = 600

/mob/living/carbon/human/monster/newmonkey/process()
	set background = 1
	if(client)
		return FALSE

	target = null
	if (stat == DEAD)
		return FALSE
	if(weakened || paralysis || handcuffed || !canmove)
		return TRUE
	if(resting)
		mob_rest()
		return
	if(prob(20))
		step_rand(src)
	for(var/mob/living/carbon/human/H in orange(1, src.loc))
		combat_mode = TRUE
		if(prob(75))
			dir = get_dir(src, H)
			target = H
			attack_target()
			if(prob(25))
				return TRUE

			var/amountToRun = rand(1, 3)
			var/dirToGo = pick(cardinal)
			while(dirToGo == dir)
				dirToGo = pick(cardinal)
			for(var/x = 0; x != amountToRun; x++)
				var/turf/T = get_step(src, dirToGo)

				if(T.density)
					return TRUE
				for(var/atom/A in T.contents)
					if(A.density)
						return TRUE

				step_to(src, T)
				sleep(3)
		return TRUE
	return

/datum/species/newmonkey
	name = "newmonkey"
	icobase = 'icons/monsters/newmonkey.dmi'
	primitive = /mob/living/carbon/human/monster/newmonkey
	unarmed_type = /datum/unarmed_attack/newmonkey
	secondary_unarmed_type = /datum/unarmed_attack/newmonkey
	minheightm = 60
	maxheightm = 30
	minheightf = 30
	maxheightf = 60

/datum/unarmed_attack/newmonkey
	attack_verb = list("hits","slash")
	attack_sound = 'bite.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 2
	sharp = 0
	edge = 0

/mob/living/carbon/human/monster/newmonkey/New()
    ..()
    set_species("newmonkey")
    src.zone_sel = new /obj/screen/zone_sel( null )
    potenzia = rand(16, 25)
    my_stats.initst = rand(4,6)
    my_stats.initht = rand(3,5)
    my_stats.initdx = rand(7,10)
    my_stats.st = my_stats.initst
    my_stats.ht = my_stats.initht
    my_stats.dx = my_stats.initdx
    my_skills.CHANGE_SKILL(SKILL_MELEE, rand(1,2))
    src.gender = pick(FEMALE, MALE)
    sleep(10)
    if(!mind)
        mind = new /datum/mind(src)
    // main loop
    spawn while(stat != 2 && bot)
        sleep(cycle_pause)
        src.process()

/mob/living/carbon/human/monster/newmonkey/Move()
	if(resting || stat)
		return ..()
	var/selectedSound = pick('monkey1.ogg','monkey2.ogg','monkey3.ogg','monkey4.ogg','monkey5.ogg','monkey6.ogg')
	if(prob(35))
		playsound(loc, selectedSound, 75, 0)
	return ..()

/mob/living/carbon/human/monster/newmonkey/movement_delay()
	return 1


/obj/structure/monkey_chamber
	name = "Macachka Chamber"
	desc = "What could be inside?"
	icon = 'monkeycage.dmi'
	icon_state = "macaco-inside"
	density = TRUE
	var/icon_empty = "macaco-empty"
	var/icon_broken = "macaco-broken"
	var/opened = FALSE


/obj/structure/monkey_chamber/attack_hand(var/mob/living/carbon/human/user as mob)
	if(src.opened)
		return
	visible_message("<span class='bname'>[usr]</span> begins to open \the [src]!")
	if (do_after(usr, 30))
		if(prob(70))
			visible_message("<span class='bname'>[user]</span> <span class='combat'> opens \the [src]!")
			src.opened = TRUE
			src.icon_state = icon_empty
			new /mob/living/carbon/human/monster/newmonkey/macaco(src.loc)
			return
		else
			visible_message("<span class='bname'>⠀[user]</span> tries to open \the [src]!")
			return
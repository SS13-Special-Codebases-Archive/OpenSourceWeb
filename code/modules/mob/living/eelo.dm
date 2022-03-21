//EELO
/mob/living/carbon/human/monster/eelo
	maxHealth = 120
	health = 120
	item_worth = 80
	attacksound = 'kthanid_attack.ogg'

/datum/species/eelo
	name = "eelo"
	icobase = 'icons/monsters/eelo.dmi'
	primitive = /mob/living/carbon/human/monster/eelo
	unarmed_type = /datum/unarmed_attack/eelo
	secondary_unarmed_type = /datum/unarmed_attack/eelo
	minheightm = 170
	maxheightm = 220
	minheightf = 170
	maxheightf = 220

/datum/unarmed_attack/eelo
	attack_verb = list("stabs", "hits","slash")
	attack_sound = 'attackchan1.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 25
	sharp = 1
	edge = 0

/mob/living/carbon/human/monster/eelo/New()
	..()
	set_species("eelo")
	var/selectedName = pick("Eelo","Kthanid")

	name = selectedName
	real_name = selectedName

	src.zone_sel = new /obj/screen/zone_sel( null )
	equip_to_slot_or_del(new /obj/item/clothing/under/eelo(src), slot_w_uniform)
	potenzia = rand(16, 25)
	my_stats.initst = rand(10,12)
	my_stats.initht = rand(5,10)
	my_stats.initdx = rand(4,5)
	my_stats.st = my_stats.initst
	my_stats.ht = my_stats.initht
	my_stats.dx = my_stats.initdx
	my_skills.CHANGE_SKILL(SKILL_MELEE, rand(6,7))
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

/mob/living/carbon/human/monster/eelo/Move()
	if(resting || stat)
		return ..()
	var/selectedSound = pick('kthanid_life.ogg')
	playsound(loc, 'kthanid_move.ogg', 50, 0)
	if(prob(25))
		playsound(loc, selectedSound, 80, 1)
	return ..()

/mob/living/carbon/human/monster/eelo/movement_delay()
	return 1
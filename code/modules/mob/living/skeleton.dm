/mob/living/carbon/human/monster/skeleton
	maxHealth = 120
	health = 120
	item_worth = 0
	flags = NO_PAIN

/mob/living/carbon/human/monster/skeleton/New()
	..()
	makeSkeleton()
	src.zone_sel = new /obj/screen/zone_sel( null )
	potenzia = rand(16, 25)
	my_stats.initst = rand(13,15)
	my_stats.initht = rand(1,2)
	my_stats.initdx = rand(10,14)
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

/mob/living/carbon/human/monster/skeleton/movement_delay()
	return 1

/mob/living/carbon/human/monster/skeleton/ancestor
	maxHealth = 300
	health = 300
	item_worth = 100

/mob/living/carbon/human/monster/skeleton/ancestor/New()
	..()
	makeSkeleton()
	real_name = "Ancestor"
	name = "Ancestor"

	src.zone_sel = new /obj/screen/zone_sel( null )
	potenzia = rand(16, 25)
	my_stats.initst = rand(18,19)
	my_stats.initht = rand(18,30)
	my_stats.initdx = rand(15,18)
	my_stats.st = my_stats.initst
	my_stats.ht = my_stats.initht
	my_stats.dx = my_stats.initdx
	var/pickit = pick("spear","sabre","rapier","copper")
	switch(pickit)
		if("sabre")
			equip_to_slot_or_del(new /obj/item/weapon/claymore/rusty/sabre(src), slot_r_hand)
		if("spear")
			equip_to_slot_or_del(new /obj/item/weapon/claymore/cspear(src), slot_r_hand)
		if("rapier")
			equip_to_slot_or_del(new /obj/item/weapon/claymore/rusty/rapier(src), slot_r_hand)
		if("copper")
			equip_to_slot_or_del(new /obj/item/weapon/claymore/copper(src), slot_r_hand)
	equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/iron_plate(src), slot_wear_suit)
	my_skills.CHANGE_SKILL(SKILL_MELEE, 7)
	my_skills.CHANGE_SKILL(SKILL_RANGE, 7)
	sleep(10)
	if(!mind)
		mind = new /datum/mind(src)
	// main loop
	spawn while(stat != 2 && bot)
		sleep(cycle_pause)
		src.process()

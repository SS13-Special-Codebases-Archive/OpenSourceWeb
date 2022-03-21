/obj/effect/decal/cleanable/bloodpool
	name = "blood pool"
	desc = "A pool of blood. Or, perhaps, the chef spilled his cooking again?"
	gender = PLURAL //pool of blood refers to itself by zie xie or some shit those retards with colored hair make up
	density = 0
	anchored = 1
	icon = 'icons/effects/pool.dmi'
	icon_state = "pool1"
	blood_DNA = list()
	layer = 2.02
	var/base_icon = 'icons/effects/pool.dmi'
	var/list/viruses = list()
	var/basecolor="#b90000" // Color when wet.
	var/list/datum/disease2/disease/virus2 = list()
	var/list/stages = list(100,200,300,400)
	var/stop
	var/amount = 00

/obj/effect/decal/cleanable/bloodpool/clean_blood()
	if(invisibility != 100)
		invisibility = 100
		processing_objects.Remove(src)
	..()

/obj/effect/decal/cleanable/bloodpool/Destroy()
	processing_objects.Remove(src)
	return QDEL_HINT_PUTINPOOL

/obj/effect/decal/cleanable/bloodpool/New()
	. = ..()
	update_icon()
	stop = world.time + 1000 //in 100(!) seconds the pool of blood should be at max size
	stages[1] = stages[1] + world.time + 50
	stages[2] = stages[2] + world.time + 50
	stages[3] = stages[3] + world.time + 50
	stages[4] = stages[4] + world.time + 50

	processing_objects.Add(src)

	spawn(DRYING_TIME * (amount+1))
		dry()

/obj/effect/decal/cleanable/bloodpool/proc/dry()
		name = "dried [src.name]"
		desc = "It's dry and crusty. Someone is not doing their job."
		color = adjust_brightness("#610505", -2)
		amount = 0

/obj/effect/decal/cleanable/bloodpool/process()
	//sorry for the shitty yandare dev code, but its the only way without switches(broken) or maths(inneficient apparently)
	if(locate(/mob/living/carbon/human) in src.loc)
		if(world.time < src?.stages[1])
			icon_state = "pool1"
			amount = 2
		else if(src?.stages[1]>world.time && world.time<src?.stages[2])
			icon_state = "pool2"
			amount = 4
		else if(src?.stages[2]>world.time && world.time<src?.stages[3])
			icon_state = "pool3"
			amount = 6
		else if(src?.stages[3]>world.time && world.time<src?.stages[4])
			icon_state = "pool4"
			amount = 8
		else if(src?.stages[4]>world.time && world.time<stop)
			icon_state = "pool5"
			amount = 10
		else if(world.time>stop + 30)
			processing_objects.Remove(src)
	else
		processing_objects.Remove(src)

/obj/effect/decal/cleanable/bloodpool/update_icon()
	color = basecolor
	if(basecolor == SYNTH_BLOOD_COLOUR)
		name = "oil"
		desc = "It's black and greasy."
	else
		name = initial(name)
		desc = initial(desc)


/obj/effect/decal/cleanable/bloodpool/Crossed(mob/living/carbon/human/perp)
	if (!istype(perp))
		return
	if(amount < 1)
		return

	var/datum/organ/external/l_foot = perp.get_organ(BP_L_FOOT)
	var/datum/organ/external/r_foot = perp.get_organ(BP_R_FOOT)
	var/hasfeet = 1
	if((!l_foot) && (!r_foot))
		hasfeet = 0
	if(perp.shoes && !perp.buckled)//Adding blood to shoes
		var/obj/item/clothing/shoes/S = perp.shoes
		if(istype(S))
			S.blood_color = basecolor
			S.track_blood = max(amount,S.track_blood)

	else if (hasfeet)//Or feet
		perp.feet_blood_color = basecolor
		perp.track_blood = max(amount,perp.track_blood)

	perp.update_inv_shoes(1)
	amount--
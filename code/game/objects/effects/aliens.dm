/* Alien Effects!
 * Contains:
 *		effect/alien
 *		Resin
 *		Weeds
 *		Acid
 *		Egg
 */

/*
 * effect/alien
 */
/obj/effect/alien
	name = "alien thing"
	desc = "theres something alien about this"
	icon = 'icons/mob/alien.dmi'

/*
 * Resin
 */
/obj/effect/alien/resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "resin"

	density = 1
	opacity = 1
	anchored = 1
	var/health = 200
	//var/mob/living/affecting = null

/obj/effect/alien/resin/wall
	name = "resin wall"
	desc = "Purple slime solidified into a wall."
	icon_state = "resinwall" //same as resin, but consistency ho!

/obj/effect/alien/resin/membrane
	name = "resin membrane"
	desc = "Purple slime just thin enough to let light pass through."
	icon_state = "resinmembrane"
	opacity = 0
	health = 120

/obj/effect/alien/resin/New()
	..()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

/obj/effect/alien/resin/Destroy()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = initial(T.thermal_conductivity)
	..()

/obj/effect/alien/resin/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)
	return

/obj/effect/alien/resin/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/effect/alien/resin/ex_act(severity)
	switch(severity)
		if(1.0)
			health-=50
		if(2.0)
			health-=50
		if(3.0)
			if (prob(50))
				health-=50
			else
				health-=25
	healthcheck()
	return

/obj/effect/alien/resin/blob_act()
	health-=50
	healthcheck()
	return

/obj/effect/alien/resin/meteorhit()
	health-=50
	healthcheck()
	return

/obj/effect/alien/resin/hitby(AM as mob|obj)
	..()
	for(var/mob/O in viewers(src, null))
		O.show_message("\red <B>[src] was hit by [AM].</B>", 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	health = max(0, health - tforce)
	healthcheck()
	..()
	return

/obj/effect/alien/resin/attack_hand()
	if (HULK in usr.mutations)
		usr << "\blue You easily destroy the [name]."
		for(var/mob/O in oviewers(src))
			O.show_message("\red [usr] destroys the [name]!", 1)
		health = 0
	else

		// Aliens can get straight through these.
		if(istype(usr,/mob/living/carbon))
			var/mob/living/carbon/M = usr
			if(locate(/datum/organ/internal/xenos/hivenode) in M.internal_organs)
				for(var/mob/O in oviewers(src))
					O.show_message("\red [usr] strokes the [name] and it melts away!", 1)
				health = 0
				healthcheck()
				return

		usr << "\blue You claw at the [name]."
		for(var/mob/O in oviewers(src))
			O.show_message("\red [usr] claws at the [name]!", 1)
		health -= rand(5,10)
	healthcheck()
	return

/obj/effect/alien/resin/attack_paw()
	return attack_hand()

/obj/effect/alien/resin/attackby(obj/item/weapon/W as obj, mob/user as mob)

	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	healthcheck()
	..()
	return

/obj/effect/alien/resin/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 0
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density


/*
 * Weeds
 */
#define NODERANGE 3

/obj/structure/stool/bed/weeds
	name = "weeds"
	desc = "Weird gray weeds."
	icon_state = "creep_northsouthwesteast"		//lol
	icon = 'icons/mob/alien.dmi'
	anchored = 1
	density = 0
	layer = 2
	var/health = 15
	var/obj/structure/stool/bed/weeds/node/linked_node = null

/obj/structure/stool/bed/weeds/node
	icon_state = "weednode"
	name = "weeds"
	desc = "Weird gray weeds."
	layer = 2
	luminosity = NODERANGE
	var/node_range = NODERANGE

/obj/structure/stool/bed/weeds/node/New()
	var/image/I = image('icons/mob/alien.dmi', icon_state = "weednode")
	I = new(src)
	src.overlays += I
	..(src.loc, src)


/obj/structure/stool/bed/weeds/New(pos, node)
	..()
	if(istype(loc, /turf/space))
		qdel(src)
		return
	linked_node = node
	update_icon()
	spawn(rand(150, 200))
		if(src)
			Life()
	return

/obj/structure/stool/bed/weeds/update_icon()

	var/turf/T = get_turf(src)

	var/obj/structure/stool/bed/weeds/north = locate() in get_step(T, NORTH)
	var/obj/structure/stool/bed/weeds/west = locate() in get_step(T, WEST)
	var/obj/structure/stool/bed/weeds/east = locate() in get_step(T, EAST)
	var/obj/structure/stool/bed/weeds/south = locate() in get_step(T, SOUTH)
	src.overlays = null
	var/direct

	if(!north)
		direct += "north"

	if(!south)
		direct += "south"

	if(!west)
		direct += "west"

	if(!east)
		direct += "east"

	if(!direct)
		icon_state = "creep_center"
	else
		icon_state = "creep_[direct]"
	return

/obj/structure/stool/bed/weeds/proc/Life()
	set background = 1
	var/turf/U = get_turf(src)
	if (istype(U, /turf/space))
		qdel(src)
		return

	if(!linked_node || (get_dist(linked_node, src) > linked_node.node_range) )
		return

	direction_loop:
		//First we will try to break stuff
		var/obj/machinery/light/L = locate() in src.loc
		if(L)
			L.broken()



		for(var/dirn in cardinal)
			var/turf/T = get_step(src, dirn)

			if (!istype(T) || T.density || locate(/obj/structure/stool/bed/weeds) in T || istype(T.loc, /area/arrival) || istype(T, /turf/space))
				continue

			if(locate(/obj/machinery/door/airlock) in T)
				if(locate(/obj/machinery/door/airlock/external) in T)
					continue
				if(!locate(/obj/structure/stool/bed/weeds) in T)
					var/obj/machinery/door/airlock/D = locate() in T
					if(D.density)
						D.open(1)
						D.locked = 1

			for(var/obj/O in T)
				if(O.density)
					if(locate(/obj/structure/closet) in T || locate(/obj/structure/table) in T || locate(/obj/machinery/computer) in T || locate(/obj/machinery/disposal) in T)
						new /obj/structure/stool/bed/weeds(T, linked_node)
					else
						continue direction_loop

			var/obj/structure/stool/bed/weeds/NewWeed = new(T, linked_node)
			if(NewWeed)
				NewWeed.update_icon()

			update_icon()


/obj/structure/stool/bed/weeds/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(5))
				qdel(src)
	return

/obj/structure/stool/bed/weeds/attackby(var/obj/item/weapon/W, var/mob/user)
	if(W.attack_verb.len)
		visible_message("\red <B>\The [src] have been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]")
	else
		visible_message("\red <B>\The [src] have been attacked with \the [W][(user ? " by [user]." : ".")]")

	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)

	health -= damage
	healthcheck()

/obj/structure/stool/bed/weeds/proc/healthcheck()
	if(health <= 0)
		qdel(src)


/obj/structure/stool/bed/weeds/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		health -= 5
		healthcheck()

#undef NODERANGE


/*
 * Acid
 */
/obj/effect/alien/acid
	name = "acid"
	desc = "Burbling corrossive stuff. I wouldn't want to touch it."
	icon_state = "acid"

	density = 0
	opacity = 0
	anchored = 1

	var/atom/target
	var/ticks = 0
	var/target_strength = 0

/obj/effect/alien/acid/New(loc, target)
	..(loc)
	src.target = target

	if(isturf(target)) // Turf take twice as long to take down.
		target_strength = 8
	else
		target_strength = 4
	tick()

/obj/effect/alien/acid/proc/tick()
	if(!target)
		qdel(src)

	ticks += 1

	if(ticks >= target_strength)

		for(var/mob/O in hearers(src, null))
			O.show_message("\green <B>[src.target] collapses under its own weight into a puddle of goop and undigested debris!</B>", 1)

		if(istype(target, /turf/simulated/wall)) // I hate turf code.
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else
			qdel(target)
		qdel(src)
		return

	switch(target_strength - ticks)
		if(6)
			visible_message("\green <B>[src.target] is holding up against the acid!</B>")
		if(4)
			visible_message("\green <B>[src.target]\s structure is being melted by the acid!</B>")
		if(2)
			visible_message("\green <B>[src.target] is struggling to withstand the acid!</B>")
		if(0 to 1)
			visible_message("\green <B>[src.target] begins to crumble under the acid!</B>")
	spawn(rand(150, 200)) tick()

/*
 * Egg
 */
#define BURST 0
#define BURSTING 1
#define GROWING 2
#define GROWN  3

#define MIN_GROWTH_TIME 600 //time it takes to grow a hugger
#define MAX_GROWTH_TIME 1800

/obj/effect/alien/egg
	desc = "It looks like a weird egg"
	name = "egg"
	icon_state = "egg_growing"
	density = 0
	anchored = 1

	var/health = 100
	var/status = GROWING //can be GROWING, GROWN or BURST; all mutually exclusive

var/global/global_eggs = 0

/obj/effect/alien/egg/New()
	if(aliens_allowed)
		..()
		global_eggs += 1
		spawn(rand(MIN_GROWTH_TIME,MAX_GROWTH_TIME))
			Grow()
	else
		qdel(src)

/obj/effect/alien/egg/attack_hand(user as mob)

	var/mob/living/carbon/M = user
	if(!istype(M) || !(locate(/datum/organ/internal/xenos/hivenode) in M.internal_organs))
		user << "\red You touch the egg."
		return

	switch(status)
		if(BURST)
			user << "\red You clear the hatched egg."
			qdel(src)
			return
		if(GROWING)
			user << "\red The child is not developed yet."
			return
		if(GROWN)
			user << "\red You retrieve the child."
			Burst(0)
			return

/obj/effect/alien/egg/attackhand_right(mob/living/carbon/human/H)
	if(status == BURST && istype(H.species, /datum/species/human/alien))
		playsound(src.loc, pick('alien_creep.ogg', 'alien_creep2.ogg'), 50, 1)
		qdel(src)

/obj/effect/alien/egg/proc/GetFacehugger()
	return locate(/obj/item/clothing/mask/facehugger) in contents

/obj/effect/alien/egg/proc/Grow()
	icon_state = "egg"
	status = GROWN
	new /obj/item/clothing/mask/facehugger(src)
	global_eggs = max(0, global_eggs-1)
	for(var/mob/M in range(1,src))
		if(CanHug(M))
			Burst()
	return

/obj/effect/alien/egg/proc/Burst(var/kill = 1) //drops and kills the hugger if any is remaining
	if(status == GROWN || status == GROWING)
		var/obj/item/clothing/mask/facehugger/child = GetFacehugger()
		icon_state = "egg_hatched"
		flick("egg_opening", src)
		status = BURSTING
		global_eggs = max(0, global_eggs-1)
		playsound(src.loc, pick('eggshake.ogg'), 60, 1)
		spawn(15)
			status = BURST
			child.loc = get_turf(src)

			if(kill && istype(child))
				child.Die()
				playsound(src.loc, pick('death_egg.ogg'), 60, 1)

			else
				playsound(src.loc, pick('eggopen.ogg'), 60, 1)
				for(var/mob/M in range(1,src))
					if(CanHug(M))
						child.Attach(M)
						break

/obj/effect/alien/egg/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return


/obj/effect/alien/egg/attackby(var/obj/item/weapon/W, var/mob/user)
	if(health <= 0)
		return
	if(W.attack_verb.len)
		src.visible_message("\red <B>\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]")
	else
		src.visible_message("\red <B>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]")
	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)

	src.health -= damage
	src.healthcheck()


/obj/effect/alien/egg/proc/healthcheck()
	if(health <= 0)
		Burst()

/obj/effect/alien/egg/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 500)
		health -= 5
		healthcheck()

/obj/effect/alien/egg/HasProximity(atom/movable/AM as mob|obj)
	if(status == GROWN)
		if(!CanHug(AM))
			return

		var/mob/living/carbon/C = AM
		if(C.stat == CONSCIOUS && C.status_flags & XENO_HOST)
			return

		Burst(0)

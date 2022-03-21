//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door1"
	anchored = 1
	opacity = 1
	density = 1
	layer = 2.7
	var/open_layer = 2.8
	var/obj/machinery/card_scanner/my_scanner = null

	var/secondsElectrified = 0
	var/visible = 1
	var/p_open = 0
	var/operating = 0
	var/autoclose = 0
	var/glass = 0
	var/normalspeed = 1
	var/heat_proof = 0 // For glass airlocks/opacity firedoors
	var/air_properties_vary_with_direction = 0
	var/locked = 0									//Moved it here to simplify zombie-interaction code.
	var/zombiedamage
	var/obj/machinery/filler_object/f5 //Filler objects so you can't see through doors.
	var/obj/machinery/filler_object/f6

	//Multi-tile doors
	dir = EAST
	var/width = 1

/obj/machinery/door/New()
	. = ..()
	if(density)
		layer = 3.1 //Above most items if closed
		explosion_resistance = initial(explosion_resistance)
		update_heat_protection(get_turf(src))
	else
		layer = open_layer //Under all objects if opened. 2.7 due to tables being at 2.6
		explosion_resistance = 0
	if(istype(src, /obj/machinery/door/airlock/orbital || /obj/machinery/door/airlock/transgates))
		layer = MOB_LAYER+1

	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	update_nearby_tiles(need_rebuild=1)
	return


/obj/machinery/door/Destroy()
	density = 0
	update_nearby_tiles()
	..()
	return

//process()
	//return

/obj/machinery/door/Bumped(atom/AM)
	if(p_open || operating) return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10) return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(!M.restrained() && !M.small)
			bumpopen(M)
		return

	if(istype(AM, /obj/machinery/bot))
		var/obj/machinery/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /mob/dead/observer))
		return

	if(istype(AM, /obj/mecha))
		var/obj/mecha/mecha = AM
		if(density)
			if(mecha.occupant && (src.allowed(mecha.occupant) || src.check_access_list(mecha.operation_req_access)))
				open()
			else
				flick("door_deny", src)
				playsound(src.loc, 'sound/webbers/airlock_deny2.ogg', 100, 1)
		return
	return


/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 0
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density


/obj/machinery/door/proc/bumpopen(mob/user as mob)
	if(operating || my_scanner)	return
	if(user.last_airflow > world.time - vsc.airflow_delay) //Fakkit
		return
	src.add_fingerprint(user)
	if(!src.requiresID())
		user = null

	if(density)
		if(!locked)	open()
		else
			playsound(src.loc, 'sound/webbers/airlock_deny2.ogg', 100, 1)
			flick("door_deny", src)
	return

/obj/machinery/door/meteorhit(obj/M as obj)
	src.open()
	return


/obj/machinery/door/attack_ai(mob/user as mob)
	return src.attack_hand(user)


/obj/machinery/door/attack_paw(mob/user as mob)
	return src.attack_hand(user)


/obj/machinery/door/attack_hand(mob/user as mob)
	return src.attackby(user, user)

/obj/machinery/door/attack_tk(mob/user as mob)
	if(requiresID() && !allowed(null))
		return
	..()

/obj/machinery/door/attackby(obj/item/I as obj, mob/living/carbon/user as mob)
	if(istype(I, /obj/item/device/detective_scanner))
		return
	if(istype(I, /obj/item/weapon/keycard))
		return
	if(src.operating || isrobot(user))	return //borgs can't attack doors open because it conflicts with their AI-like interaction with them.
	if(iszombie(user) || istype(user?:species, /datum/species/human/alien))
		if(istype(user?:species, /datum/species/human/alien))
			playsound(src.loc, pick('aliendoor1.ogg', 'aliendoor2.ogg', 'aliendoor3.ogg', 'aliendoor4.ogg'), 50, 1)
		else
			playsound(src.loc, 'bang.ogg', 50, 1)
		src.Jitter(pick(1,2,3))
		user.visible_message("<span class='combatbold'>[user]</span><span class='combat'> [pick("slashes against")] the airlock!</span>")
		if(zombiedamage > 80 || (locked && zombiedamage > 200))
			src.locked = 0
			user << "\blue You break the circuitry"
			flick("door_spark", src)
			sleep(6)
			open(1)
			operating = -1
			return 1
		operating = 1
		spawn(6) operating = 0
		return 1
	src.add_fingerprint(user)
	if(!Adjacent(user))
		user = null
	if(!src.requiresID())
		user = null
	if(src.density && (istype(I, /obj/item/weapon/card/emag)||istype(I, /obj/item/weapon/melee/energy/blade)))
		flick("door_spark", src)
		sleep(6)
		open()
		operating = -1
		return 1
	if(!locked)
		if(src.density)
			open()
		else
			close()
		return
	if(src.density && locked)
		flick("door_deny", src)
		playsound(src.loc, 'sound/webbers/airlock_deny2.ogg', 100, 1)
	return


/obj/machinery/door/blob_act()
	if(prob(40))
		qdel(src)
	return


/obj/machinery/door/emp_act(severity)
	if(prob(20/severity) && (istype(src,/obj/machinery/door/airlock) || istype(src,/obj/machinery/door/window)) )
		open()
	if(prob(40/severity))
		if(secondsElectrified == 0)
			secondsElectrified = -1
			spawn(300)
				secondsElectrified = 0
	..()


/obj/machinery/door/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(25))
				qdel(src)
		if(3.0)
			if(prob(80))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
	return


/obj/machinery/door/update_icon()
	if(density)
		icon_state = "door1"
	else
		icon_state = "door0"
	return


/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(p_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if(p_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("deny")
			flick("door_deny", src)
			playsound(src.loc, 'sound/webbers/airlock_deny2.ogg', 100, 1)
	return


/obj/machinery/door/proc/open()
	if(!density)		return 1
	if(operating > 0)	return
	if(!ticker)			return 0
	if(!operating)		operating = 1

	set_opacity(0)
	if(istype(src, /obj/machinery/door/airlock/multi_tile/noble))
		f5.set_opacity(0)
		f6.set_opacity(0)
	do_animate("opening")
	icon_state = "door0"
	sleep(5)
	density = 0
	layer = open_layer
	if(istype(src, /obj/machinery/door/airlock/orbital || /obj/machinery/door/airlock/transgates))
		layer = MOB_LAYER+1
	explosion_resistance = 0
	update_icon()
	update_nearby_tiles()

	if(operating)	operating = 0

	if(autoclose  && normalspeed)
		spawn(150)
			autoclose()
	if(autoclose && !normalspeed)
		spawn(5)
			autoclose()

	if(src?:loc)
		src?:loc?:check_for_reagents_to_update()

	return 1


/obj/machinery/door/proc/close()
	if(density)	return 1
	if(operating > 0)	return
	operating = 1

	do_animate("closing")
	src.density = 1
	explosion_resistance = initial(explosion_resistance)
	src.layer = 3.1
	if(istype(src, /obj/machinery/door/airlock/orbital || /obj/machinery/door/airlock/transgates))
		layer = MOB_LAYER+1
	sleep(10)
	update_icon()
	if(visible && !glass)
		set_opacity(1)	//caaaaarn!
	if(istype(src, /obj/machinery/door/airlock/multi_tile/noble))
		f5.set_opacity(1)
		f6.set_opacity(1)
	operating = 0
	update_nearby_tiles()
	if(src?:loc)
		src?:loc?:check_for_reagents_to_update()

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/reagent/reagente = locate() in loc
	if(reagente)
		qdel(reagente)
	update_fluid_icon(0, null)
	return

/obj/machinery/door/proc/requiresID()
	return 1
/*
/obj/machinery/door/proc/update_nearby_tiles(need_rebuild)
	if(!air_master)
		return 0

	for(var/turf/simulated/turf in locs)
		update_heat_protection(turf)
		air_master.AddTurfToUpdate(turf)

	return 1
*/
/obj/machinery/door/proc/update_heat_protection(var/turf/simulated/source)
	if(istype(source))
		if(src.density && (src.opacity || src.heat_proof))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/proc/autoclose()
//	if(!istype(src,/obj/machinery/door/airlock))
//		close()
//		return
	var/obj/machinery/door/airlock/A = src
	if(!A.density && !A.operating && !A.locked && !A.welded && A.autoclose)
		close()
	return

/obj/machinery/door/Move(new_loc, new_dir)
	update_nearby_tiles()
	. = ..()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	update_nearby_tiles()

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/doormorgue.dmi'

/obj/machinery/door/proc/crush()
	for(var/mob/living/L in get_turf(src))
		if(isalien(L))  //For xenos
			L.adjustBruteLoss(10* 1.5) //Xenos go into crit after aproximately the same amount of crushes as humans.
			L.emote("roar")
		else if(ishuman(L)) //For humans
			L.adjustBruteLoss(10)
			L.emote("scream")
			L.Weaken(5)
		else if(ismonkey(L)) //For monkeys
			L.adjustBruteLoss(10)
			L.Weaken(5)
		else //for simple_animals & borgs
			L.adjustBruteLoss(10)
		var/turf/location = src.loc
		if(istype(location, /turf/simulated)) //add_blood doesn't work for borgs/xenos, but add_blood_floor does.
			location.add_blood(L)

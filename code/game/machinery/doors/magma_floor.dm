/turf/simulated/floor/lifeweb/magma
	name = "magma"
	icon = 'icons/life/magma.dmi'
	icon_state = "magma"
	burnAble = 0
/*
/turf/simulated/floor/lifeweb/magma/Crossed(mob/living/carbon/human/M as mob|obj)
	for(var/obj/machinery/door/airlock/orbital/gates/magma/C in src.loc)
		if(C.fechado == FALSE)
			M.icon = 'icons/life/burnmotherfucker.dmi'
			M.icon_state = "fire_s"
			M.emote("agonyscream")
			spawn(10)
				new/obj/effect/decal/cleanable/ash
				del M
*/

/turf/simulated/floor/plating/magmareal
	name = "magma"
	icon = 'icons/life/magma.dmi'
	icon_state = "magma"
	temperature = MAGMA
	burnAble = 0

/turf/simulated/floor/plating/magmareal/ex_act(severity)
	return

/turf/simulated/floor/plating/magmareal/New()
	set_light(6, 4, "#ff2f00")
	update_icon()
	..()

/turf/simulated/floor/plating/magmareal/bite_act(mob/M as mob)
	var/mob/living/carbon/human/H = M
	if(M.stat != DEAD)
		return
	/*
	var/datum/reagents/reagents = new/datum/reagents(2)
	reagents.add_reagent(/datum/reagent/water, 2)
	reagents.reaction(H, INGEST)
	reagents.trans_to(H, 2)
	H.bladder += 5 //For peeing
	*/
	visible_message("<span class='bname'>⠀[H]</span> drinks from \the [src]!</span>")
	playsound(M.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
	if(H.client)
		H.client.ChromieWinorLoose(H.client, -3)
	H.death(1)
	return

/turf/simulated/floor/plating/magmareal/Entered(AM)
	if(!istype(AM, /mob/living))
		if(!istype(AM, /obj))
			return
		qdel(AM)
		return
	var/mob/living/M = AM
	var/is_client_moving = (ismob(M) && M.client && M.client.moving)
	//var/is_client_moving = (ismob(M) && M.client && M.client.moving)
	if(M.throwing)
		sleep(4)
		spawn(0)
			if(M.throwing == 0)
				M.icon = 'icons/life/burnmotherfucker.dmi'
				M.icon_state = "fire_s"
				if(ishuman(M))
					M.emote("agonyscream")
				else
					M.emote("scream")
				spawn(rand(5,10))
					if(ishuman(M))
						//M.dust()
						//spawn(5)
						var/mob/living/carbon/human/H = M
						H.buried = TRUE
						if(H.stat == DEAD)
							M.dust()
							return
						if(H.client)
							H.client.ChromieWinorLoose(H.client, -1)
						M.dust()
					else
						qdel(M)
			else
				return
	else
		spawn(0)
			if(is_client_moving) M.client.moving = 1
			//handle_burn()
			if(is_client_moving) M.client.moving = 0
		M.icon = 'icons/life/burnmotherfucker.dmi'
		M.icon_state = "fire_s"
		if(ishuman(M))
			M.emote("agonyscream")
		else
			M.emote("scream")
		spawn(rand(5,10))
			if(ishuman(M))
				//spawn(5)
				var/mob/living/carbon/human/H = M
				if(H.client)
					H.client.ChromieWinorLoose(H.client, -1)
				H.buried = TRUE
				M.dust()
			else
				qdel(M)

/turf/simulated/floor/plating/magmareal/update_icon()
	overlays.Cut()
	for(var/direction in cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(istype(turf_to_check, /turf/simulated/floor/plating/magmareal))
			continue

		else if(istype(turf_to_check, /turf/simulated))
			var/image/water_side = image('icons/obj/warfare.dmi', "over_water1", dir = direction)//turn(direction, 180))

			overlays += water_side
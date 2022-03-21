#define BELOW 1
#define ABOVE 2

var/elevatorMain = null

/datum/elevador
	var/obj/list/elevatorTiles = list()
	var/turf/list/aboveTurfs = list()
	var/turf/list/belowTurfs = list()

	var/moving = 0
	var/location = BELOW

/datum/elevador/proc/move(var/direction)

	if(moving) return

	moving = 1

	sleep(3 SECONDS)

	if(location == BELOW)
		for(var/i = 1; i <= belowTurfs.len; i++)
			var/turf/T = belowTurfs[i]
			for(var/atom/movable/A in T)
				if(istype(A, /atom/movable/lighting_overlay)) continue
				if(iscarbon(A))
					var/mob/living/carbon/C = A
					shake_camera(C, 10, 1)
					to_chat(C, "You feel the floor underneath you push from below.")
				A.forceMove(locate(A.x, A.y, A.z+1))
				if(isobj(A) && !istype(A, /obj/structure/elevador) && !A.anchored)
					A.throw_at(get_edge_target_turf(A, pick(alldirs)), 4, 2)
		location = ABOVE
		moving = 0
		return 1

	if(location == ABOVE)

		for(var/i = 1; i <= belowTurfs.len; i++)
			var/turf/T = belowTurfs[i]
			for(var/mob/living/carbon/C in T)
				C.gib()

		for(var/i = 1; i <= aboveTurfs.len; i++)
			var/turf/T = aboveTurfs[i]
			for(var/atom/movable/A in T)
				if(istype(A, /atom/movable/lighting_overlay)) continue
				if(iscarbon(A))
					var/mob/living/carbon/C = A
					shake_camera(C, 10, 1)
					to_chat(C, "You feel the floor underneath you fall to the below.")
				A.forceMove(locate(A.x, A.y, A.z-1))
				if(isobj(A) && !istype(A, /obj/structure/elevador) && !A.anchored)
					A.throw_at(get_edge_target_turf(A, pick(alldirs)), 4, 2)
		location = BELOW
		moving = 0
		return 1

	return 0



/obj/structure/elevador
	icon = 'icons/life/elevator.dmi'
	var/enumeracao = "MainElevator"
	layer = 2.1

/obj/structure/elevador/New()
	..()
	if(enumeracao == "MainElevator")
		if(!elevatorMain)
			var/datum/elevador/E = new
			elevatorMain = E
		var/datum/elevador/elevador = elevatorMain
		elevador.elevatorTiles.Add(src)
		if(isturf(src.loc))
			elevador.belowTurfs.Add(src.loc)
		var/turf/above = locate(src.x, src.y, src.z+1)
		if(above)
			elevador.aboveTurfs.Add(above)

/obj/structure/elevador/A
	name = "floor"
	icon_state = "elevatorte"

/obj/structure/elevador/B
	name = "floor"
	icon_state = "elevatori"

#undef BELOW
#undef ABOVE


/obj/machinery/elevator_button
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "elevator_standby"
	name = "elevator button"
	density = 1
	anchored = 1
	density = 1

/obj/machinery/elevator_button/attack_hand(mob/user)
	var/datum/elevador/elevador = elevatorMain
	if(prob(85))
		playsound(src.loc, "sound/effects/ELV1_1.ogg", 100)
		flick("elevator_on", src)
		elevador.move()
	else
		playsound(src.loc, "sound/effects/ELV1_1.ogg", 100)

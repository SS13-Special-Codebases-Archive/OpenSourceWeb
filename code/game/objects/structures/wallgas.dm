/obj/structure/vent_gas
	desc = "A large ventilation panel attached to the wall."
	name = "vent"
	icon = 'icons/obj/structures.dmi'
	icon_state = "obj37"
	density = 1
	anchored = 1
	flags = 300000000
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = 3
	level = 3
	plane = 21
	explosion_resistance = 1

/obj/structure/vent_gas/New()
	..()
	processo()

/obj/structure/vent_gas/proc/processo()
	INICIO
	sleep(20)
	spawn(45)
		playsound(src.loc, 'sound/machines/loop_vent.ogg', 10, 0, 3)
	for(var/i = 0; 6 > i; i++)
		var/obj/effect/gas_particle/O = new(src.loc)
		animate(O, pixel_y = rand(50, 98), time=rand(14,20))
		sleep(5)
		spawn(20)
			animate(O, alpha = 0, time = 20)
			spawn(20)
				qdel(O)
	goto INICIO

/obj/effect/gas_particle
	name = "gas particles"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke2"
	opacity = 0
	anchored = 1
	layer = 4.1
	plane = 15
	alpha = 120
	mouse_opacity = 0

/obj/effect/gas_particle/New()
	..()
	src.pixel_x = rand(-5,5)
	src.pixel_y = rand(-5, 2)
	src.icon = turn(src.icon,rand(0,90))

/obj/structure/vent_gas_deactivated
	desc = "A large ventilation panel attached to the wall."
	name = "vent"
	icon = 'icons/obj/structures.dmi'
	icon_state = "obj37"
	density = 1
	anchored = 1
	flags = 300000000
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = 3
	level = 3
	explosion_resistance = 1
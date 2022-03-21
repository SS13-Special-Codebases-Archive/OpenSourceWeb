/proc/is_dreamer(mob/living/carbon/human/M)
	return (M && M.mind && M.mind.special_role == "Waker")

/turf/simulated/floor/var
	may_dreamer_see = 1

/turf/simulated/floor/open //Openspace buga com image por cima
	burnAble = 0
	may_dreamer_see = 0

/turf/simulated/floor/open/New()
	..()
	for(var/direction in cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(istype(turf_to_check, /turf/simulated/floor/plating/magmareal))
			continue

		else if(istype(turf_to_check, /turf/simulated))
			var/image/water_side = image('icons/obj/warfare.dmi', "over_water1", dir = direction)//turn(direction, 180))

			overlays += water_side
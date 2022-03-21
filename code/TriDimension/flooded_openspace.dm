/mob/proc/swim_up()
	var/turf/simulated/above = locate(loc.x, loc.y, loc.z+1)
	if(istype(above, /turf/simulated/floor/open))
		var/turf/simulated/floor/open/buracodecima = above
		if(buracodecima.flooded)
			src.forceMove(buracodecima)
			playsound(src.loc, 'sound/effects/fst_water_jump_down_01.ogg', 80, 1, -1)
			src.visible_message("<span class='bname'>[src.name]</span> rises!")

/mob/proc/swim_down()
	var/turf/simulated/below = locate(loc.x, loc.y, loc.z-1)
	if(istype(loc, /turf/simulated/floor/open))
		var/turf/simulated/floor/open/buracoatual = loc
		if(buracoatual.flooded)
			src.forceMove(below)
			playsound(src.loc, 'sound/effects/fst_water_jump_down_01.ogg', 80, 1, -1)
			src.visible_message("<span class='bname'>[src.name]</span> dives in!")
/obj/effect/landmark/zcontroller
	name = "Z-Level Controller"
	var/initialized = 0 // when set to 1, turfs will report to the controller
	var/up = 0	// 1 allows  up movement
	var/up_target = 0 // the Z-level that is above the current one
	var/down = 0 // 1 allows down movement
	var/down_target = 0 // the Z-level that is below the current one

/obj/effect/landmark/zcontroller/proc/calc(var/list/L)
	while(L.len)
		var/turf/T = pick(L)
		if(!T || !istype(T, /turf))
			L -= T
			continue
		if(down && istype(T, /turf/simulated/floor/open) || istype(T, /turf/simulated/floor/plating/catwalk) || istype(T, /obj/structure/catwalk))
			var/turf/below = locate(T.x, T.y, T.z-1)
			if(below)
				if(istype(below, /turf/simulated/floor/open))
					var/turf/belower = locate(below.x, below.y, below.z-1)
					if(istype(belower, /turf/simulated/floor/open))
						var/turf/belowerer = locate(belower.x, belower.y, belower.z-1)
						if(istype(belowerer, /turf/simulated/floor/open))
							var/turf/belowerer2 = locate(belower.x, belower.y, belower.z-1)
						else
							T.vis_contents += belowerer
					else
						T.vis_contents += belower
				if(!istype(below, /turf/simulated/floor/open))
					T.vis_contents += below
		global_openspace -= T
	return


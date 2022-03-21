/proc/create_all_lighting_overlayss()
	for(var/zlevel = 2 to 3)
		create_lighting_overlays_zlevelss(zlevel)

/proc/create_lighting_overlays_zlevelss(var/zlevel)
	ASSERT(zlevel)

	for(var/turf/simulated/floor/lifeweb/elevator/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
		if(T.dynamic_lighting && istype(T.loc, /area/shuttle/elevator/cargo/first) || T.dynamic_lighting && istype(T.loc, /area/shuttle/elevator/cargo/second))
			T.lighting_build_overlay()

/obj/New()
	. = ..()
	if(opacity)
		var/turf/T = loc
		T.Entered(src)

#define NORMAL_LIGHTING 1
#define ROUND_LIGHTING 2
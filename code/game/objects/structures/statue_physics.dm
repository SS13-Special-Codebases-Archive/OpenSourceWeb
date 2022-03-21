/obj/structure/front
	opacity = 0
	density = 1
	anchored = 1
	dir = NORTH

/obj/structure/back
	opacity = 0
	layer = 4.1
	density = 1
	anchored = 1
	dir = SOUTH

/obj/structure/back/New()
	var/location = get_step(src, SOUTH)
	new /obj/structure/front(location)
	..()

/obj/structure/back/CanPass(atom/movable/mover, turf/target, height=0, air_group=0, var/mob/living/user)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group) return 0
		return !density
	else
		return 1

/obj/structure/front/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group) return 0
		return !density
	else
		return 1
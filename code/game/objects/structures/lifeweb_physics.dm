/obj/structure/lifeweb
	opacity = 0
	layer = 4.1
	plane = 15
	density = 1
	anchored = 1
	var/cantpass = FALSE
	var/reverse = FALSE
	var/onedir = FALSE
	var/can_in = FALSE
	dir = SOUTH
	var/donation_storage = TRUE //can pull donations/items out.
	var/display_hiding = FALSE //can be hidden behind. Used for examine.

/obj/structure/lifeweb/examine()
	..()
	if(display_hiding)
		for(var/mob/living/carbon/human/H in src.loc)
			to_chat(usr, "<span class='combatbold'>Someone is hiding here!</span>")
			break

/obj/structure/lifeweb/tallshroom_barrier
	opacity = 0
	layer = 4.1
	icon_state = ""

	density = 1
	anchored = 1
	dir = SOUTH

/obj/structure/lifeweb/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	//if(!istype(src, /obj/structure/lifeweb/mushroom/glorbmushroom))
	var/dir_bump
	if(reverse)
		dir_bump = turn(dir, 180)
	else
		dir_bump = dir

	if(!cantpass)
		if(istype(mover) && mover.checkpass(PASSTABLE))
			return 1
	if(onedir)
		if((get_dir(loc, target) == turn(dir_bump, 180)))
			if(air_group) return 0
			return density
		else
			return 0
	if(get_dir(loc, target) == dir_bump) //Make sure looking at appropriate border
		if(air_group) return 0
		if(can_in && mover?.loc != src?.loc) return 1
		return !density
	else
		return 1

/obj/structure/lifeweb/CheckExit(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1

	if(reverse)
		if(get_dir(loc, target) == dir)
			return 1
		else
			return 0

	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group) return 0
		return !density
	else
		return 1


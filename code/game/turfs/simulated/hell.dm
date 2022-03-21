/turf/simulated/floor/hell
	name = "HELL"
	desc = "Burn."
	icon = 'icons/turf/hell.dmi'
	icon_state = "floor"

/turf/simulated/wall/r_wall/hell
	name = "HELL"
	desc = "You will never get out."
	icon = 'hell.dmi'
	icon_state = "wall14"
	walltype = "wall"


/area/dunwell/hell
	name = "Hell"
	icon_state = "maze"
	hum = 0
	luminosity = 1
	lighting_use_dynamic = FALSE


obj/structure/helldoor
	name = "ESCAPE"
	icon = 'icons/turf/hell.dmi'

	anchored = TRUE
	density = FALSE
	appearance_flags = NO_CLIENT_COLOR
	flammable = 0
	icon_state = "door"

/obj/structure/helldoor/attack_ghost(mob/dead/observer/user as mob)
	user.ForceToHellRespawn()
	limbodoors += 1
	var/turf/newLoc = pick(HellDoor)
	new /obj/structure/helldoor(newLoc)
	qdel(src)
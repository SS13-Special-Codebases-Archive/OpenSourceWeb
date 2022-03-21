var/list/minimiglist = list()

/obj/effect/blockedsiege
	name = "Evil Siege Camp"
	desc = "I Better stay away from that thing."
	density = 1
	anchored = 1
	mouse_opacity = 0
	icon = 'icons/life/screen1.dmi'
	icon_state = "dark23"
	Bumped(atom/user)
		if(ismob(user))
			to_chat(user, "War hasn't been declared, I can't go past this.")
	New()
		..()
		if(istype(src.loc,/turf/simulated/wall/r_wall))
			var/turf/simulated/wall/r_wall/W = src.loc
			W.siegeblocked = TRUE
	Del()
		if(istype(src.loc,/turf/simulated/wall/r_wall))
			var/turf/simulated/wall/r_wall/W = src.loc
			W.siegeblocked = FALSE
		..()

/obj/effect/blockedminimig
	name = "Evil Minimig Camp"
	desc = "I Better stay away from that thing."
	density = 1
	anchored = 1
	mouse_opacity = 0
	icon = 'icons/life/screen1.dmi'
	icon_state = "dark23"
	New()
		minimiglist.Add(src)
	Bumped(atom/user)
		if(ismob(user))
			if(minimig_grace)
				to_chat(user, "Grace period hasn't ended, I can't go past this.")
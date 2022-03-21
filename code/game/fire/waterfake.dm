/obj/effect/fakewater
	density = 0
	alpha = 255
	layer = 2
	anchored = 1
	icon = 'icons/effects/effects.dmi'
	icon_state = "foam"
	plane = 200

/obj/effect/fakewater/New()
	..()
	src.loc:add_fluid(src.loc, 4, "water")
	qdel(src)
/obj/structure/wallvent
	desc = "A large ventilation panel attached to the wall."
	name = "vent"
	icon = 'icons/obj/structures.dmi'
	icon_state = "vent"
	var/broken_state = "ventbroken"
	density = 1
	anchored = 1
	flags = 300000000
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = 3
	level = 3
	explosion_resistance = 1
	var/health = 10
	var/destroyed = 0

/obj/structure/wallvent/broken
	name = "broken vent"
	destroyed = 1
	icon_state = "ventbroken"

/obj/structure/wallvent/Bumped(AM)

	if(!istype(AM, /mob/living/carbon/human))
		return

	if(destroyed)
		return

	if(!destroyed)

		var/mob/living/carbon/human/hu = AM
		var/chosenOrgan = pick("l_hand", "r_hand", "l_foot", "r_foot")
		var/chosenOrgan2 = pick("l_hand", "r_hand", "l_foot", "r_foot")

		hu.apply_damage(220	, BRUTE, chosenOrgan)
		hu.apply_damage(220	, BRUTE, chosenOrgan2)
		to_chat(hu, "<b style='color: #ff33cc;'>You're caught by the vent!</b>")
		playsound(src.loc, 'sound/effects/vent.ogg', 100, 1)

		if(chosenOrgan == "r_hand")
			hu.drop_r_hand()
		else if(chosenOrgan == "l_hand")
			hu.drop_l_hand()
		var/datum/effect/effect/system/smoke_spread/chem/S = new /datum/effect/effect/system/smoke_spread/chem
		S.attach(src.loc)
		S.set_up(null, 10, 0, src.loc)
		playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
		S.start()
		new /obj/structure/wallvent/broken(src.loc)
		qdel(src)
	else
		return
	..()
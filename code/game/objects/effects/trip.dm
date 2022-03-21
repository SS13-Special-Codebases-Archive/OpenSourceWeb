var/list/trip_markers = list()

/obj/effect/trip
	name = "Journey"
	icon = 'icons/misc/trip.dmi'
	icon_state = "trip"
	anchored = 1
	unacidable = 1
	flammable = 0
	var/to_trip = "Journey"
	var/know_as = "Journey"
	var/pulling_mob = TRUE
	var/time_to_travel = 50 //5 seconds

/obj/effect/trip/New()
	..()
	trip_markers += src

/obj/effect/trip/Crossed(var/mob/living/carbon/human/H)
	if(!ishuman(H))
		return
	start_journey(H)

/obj/effect/trip/attack_hand(var/mob/living/carbon/human/H)
	if(!ishuman(H))
		return
	start_journey(H)

/obj/effect/trip/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return

/obj/effect/trip/proc/start_journey(var/mob/living/carbon/human/H)
	if(H.stat || !istype(H))
		return
	if(!to_trip)
		return
	to_chat(src, "My journey begins.")
	if(do_after(H, time_to_travel))
		var/list/choose_spot = list()
		for(var/obj/effect/trip/T in trip_markers)
			if(to_trip == T.know_as)
				choose_spot += T
		var/obj/effect/trip/T = pick(choose_spot)
		if(H.pulling)
			var/atom/movable/pulled = H.pulling
			while(pulled)
				if(ismob(pulled))
					if(!pulling_mob)
						break
					var/mob/M = pulled
					if(M.pulling)
						pulled = M.pulling
						M.forceMove(T.loc)
						continue
				else if(istype(pulled, /obj/structure/miningcar))
					var/obj/structure/miningcar/MC = pulled
					if(length(MC.mob_storage) && !pulling_mob)
						break
				pulled.forceMove(T.loc)
				pulled = null
		var/list/grab_hands = list(H.get_inactive_hand())
		grab_hands += H.get_active_hand()
		if(length(grab_hands))
			for(var/A in grab_hands)
				if(istype(A, /obj/item/weapon/grab))
					var/obj/item/weapon/grab/G = A
					if(ismob(G.affecting))
						var/mob/GM = G.affecting
						GM.forceMove(T.loc)
		H.forceMove(T.loc)
		if(H.buckled)
			var/atom/movable/buckled_to = H.buckled
			buckled_to.forceMove(T.loc)
	else
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] I need to stay still!</span>")

/obj/effect/trip/siege
	name = ""
	icon = 'icons/misc/trip.dmi'
	icon_state = "trip3"
	pulling_mob = FALSE
	var/list/classes_observers = list()

/obj/effect/trip/siege/New()
	..()
	classes_observers += builderssiegers
	classes_observers += scoutssiegers

/obj/effect/trip/siege/start_journey(var/mob/living/carbon/human/H)
	if(!(ticker.mode.config_tag == "siege"))
		return
	var/datum/game_mode/siege/S = ticker.mode
	if(!(H.siegesoldier))
		return
	if(!S.siegewar && (!(H.migclass) || !(H.migclass in classes_observers)))
		to_chat(H, "[pick(nao_consigoen)] War isn't declared!")
		return
	..()

/obj/effect/trip/ludruk
	name = ""
	icon = 'icons/misc/trip.dmi'
	icon_state = "trip3"
	pulling_mob = TRUE

/obj/effect/trip/ludruk/start_journey(var/mob/living/carbon/human/H)
	if(vanden_late != 1)
		to_chat(H, "<span class='objectives'>I can't. The way is blocked by a powerful storm.</span>")
		return
	..()
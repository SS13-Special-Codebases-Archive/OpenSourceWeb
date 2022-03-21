#define FIRE_BIG 3
#define FIRE_MEDIUM 2
#define FIRE_SMALL 1

/obj/item/trash
	flammable = 1

/obj/structure/fire
	density = 0
	icon = 'icons/fire/fire2.dmi'
	icon_state = "1"
	layer = 5
	anchored = 1
	plane = 15

	var/state = FIRE_SMALL
	var/chanceToGrow = 0
	var/timeLeft = 25 SECONDS
	var/damage = 10

/obj/structure/fire/New()
	if(isturf(loc))
		var/turf/T = loc
		if(!T.burnAble) //It doesn't allow fire on it
			qdel(src)
			return
		for(var/obj/structure/S in T) // There's already a fire object there
			if(S == src) continue
			if(istype(S, /obj/structure/fire))
				qdel(src)
				return
		processing_objects.Add(src)
		timeLeft = rand(15, 25) SECONDS
		playsound(src.loc, 'sound/effects/fire.ogg', 30, 1)
		overlays += image('icons/fire/fire2.dmi', "o[state]")
		for(var/i = 0; i < 5; i++)
			if(prob(42))
				new/obj/effect/effect/smoke/explosion(T)

/obj/structure/fire/Destroy()
	processing_objects.Remove(src)
	return ..()

/obj/structure/fire/process()
	updateRandom()
	updateFire()

/obj/structure/fire/Crossed(H as mob|obj)
	if(!ishuman(H))
		return
	if(ismonster(H))
		return
	var/mob/living/carbon/human/M = H
	if(prob(50 * state))
		M.apply_damage(damage * 1.5, BURN, pick("l_foot", "r_foot", "l_leg", "r_leg", "chest", "head"))
		M.emote("scream")
	if(prob(20))
		M.apply_damage(damage -5, OXY)
		M.emote("gasp")

/obj/structure/fire/proc/updateFire()
	. = ..()
	if(!isturf(loc)) return
	var/turf/simulated/T = loc
	if(!T.burnAble)
		qdel(src)
		return
	for(var/atom/A in T.contents)
		A.flame_act()
		if(T.liquid)
			var/obj/reagent/R = T.liquid
			var/datum/reagent/RR = R.reagents.get_random_reagent()
			if(RR.flammable)
				src.chanceToGrow += 200
				qdel(R)
			else
				playsound(src.loc, 'torch_snuff.ogg', 75, 0)
				qdel(src)
				return
		if(!A.flammable)
			continue
		if(istype(A, /obj/structure/fire))
			continue
		if(istype(A, /obj/item))
			var/obj/item/I = A
			chanceToGrow += I.w_class+4*10
			animate(I, color = "#363636", time = 35)
			I.flammable = 0
			spawn(40)
				new/obj/item/ash(I.loc)
				playsound(src,pick('dustdrop.ogg','fx_dust_a_01.ogg','fx_dust_a_02.ogg','fx_dust_a_03.ogg'),75)
				I.visible_message("<span class='combat'>[I] is consumed by fire!</span>")
				qdel(I)
		else if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(H?.species?.name == "Skeleton")
				continue
			if(prob(35 * state))
				H.apply_damage(damage * 1.5, BURN, pick("l_foot", "r_foot", "l_leg", "r_leg", "chest", "head"))
			if(H.health < -20)
				if(H.health < -70)
					if(prob(1) && H.on_fire && H.resting)
						H.visible_message("<span class='combat'>[H] is consumed by fire!</span>")
						playsound(src,pick('dustdrop.ogg','fx_dust_a_01.ogg','fx_dust_a_02.ogg','fx_dust_a_03.ogg'),75)
						H.dust()
				if(prob(80))
					H.on_fire = 1
					H.update_fire()
		else if(istype(A, /obj/structure))
			chanceToGrow += 100
			animate(A, color = "#363636", time = 35)
			A.flammable = 0
			spawn(40)
				new/obj/item/ash(A.loc)
				playsound(src,pick('dustdrop.ogg','fx_dust_a_01.ogg','fx_dust_a_02.ogg','fx_dust_a_03.ogg'),75)
				A.visible_message("<span class='combat'>[A] is consumed by fire!</span>")
				qdel(A)
		else
			chanceToGrow += 40
			animate(A, color = "#363636", time = 50)
			A.flammable = 0
			spawn(50)
				new/obj/item/ash(A.loc)
				playsound(src,pick('dustdrop.ogg','fx_dust_a_01.ogg','fx_dust_a_02.ogg','fx_dust_a_03.ogg'),75)
				A.visible_message("<span class='combat'>[A] is consumed by fire!</span>")
				qdel(A)

	if(T.flammable)
		chanceToGrow += 200
		T.overlays += image('icons/fire/fire2.dmi', "burn")
		T.flammable = 0
		spawn(15 SECONDS)
			if(prob(25))
				var/turf/below = locate(T.x, T.y, T.z-1)
				if(!below.density && !istype(below, /turf/simulated/floor/open))
					new/turf/simulated/floor/open(src.loc)

	spawn(10)
		playsound(src.loc, 'sound/effects/flesh_burning.ogg', 60+(1+state)*10, 1)

	if(chanceToGrow >= 100 && state != FIRE_BIG)
		state += FIRE_SMALL
		timeLeft += 60 SECONDS
		chanceToGrow = 0

	for(var/direction in alldirs)
		var/turf/simulated/SIDETURF = get_step(src, direction)
		if(SIDETURF.flammable && prob(5))
			new/obj/structure/fire(SIDETURF)
		if(SIDETURF.liquid)
			var/obj/reagent/reagante = SIDETURF.liquid
			if(reagante.reagents.reagent_list.len)
				var/datum/reagent/R = reagante.reagents.get_random_reagent()
				if(R.flammable)
					var/obj/structure/fire/FFF = new(reagante.loc)
					FFF.chanceToGrow += 200
					qdel(reagante)
		if(state < FIRE_MEDIUM) continue
		for(var/obj/A in SIDETURF.contents)
			if(!A.flammable) continue
			new/obj/structure/fire(SIDETURF)

	timeLeft = max(0, timeLeft - 2 SECONDS)

	if(timeLeft == 0)
		if(state == FIRE_BIG)
			playsound(src.loc, 'torch_snuff.ogg', 75, 0)
			state -= 1
			timeLeft += 60 SECONDS
			updateRandom()
			return
		if(state == FIRE_MEDIUM)
			playsound(src.loc, 'torch_snuff.ogg', 75, 0)
			state -= 1
			timeLeft += 30 SECONDS
			updateRandom()
			return
		if(state == FIRE_SMALL)
			playsound(src.loc, 'torch_snuff.ogg', 75, 0)
			qdel(src)
			return


/obj/structure/fire/proc/updateRandom()
	overlays.Cut()
	overlays += image('icons/fire/fire2.dmi', "o[state]")
	switch(state)
		if(FIRE_SMALL)
			icon_state = "[FIRE_SMALL]"
			set_light(3, 1, "#f27d0c")
			damage = 10
		if(FIRE_MEDIUM)
			icon_state = "[FIRE_MEDIUM]"
			set_light(5, 3, "#f27d0c")
			damage = 20
		if(FIRE_BIG)
			icon_state = "[FIRE_BIG]"
			set_light(6, 5, "#f27d0c")
			damage = 30
		if(0)
			set_light(0)
	for(var/mob/living/carbon/human/H in view(2, H))
		if(H.vice == "Pyromaniac")
			H.viceneed = 0
			H.clear_event("vice")

/obj/structure/fire/fluid_act()
	..()
	playsound(src.loc, 'torch_snuff.ogg', 75, 0)
	qdel(src)
	return

/obj/structure/fire/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/R = W

		var/reagentResult = R.reagents.get_reagent_amount("water")

		if(reagentResult > 10)
			user.visible_message("<span class='passivebold'>Splashes water into the fire, trying to put it out!</span>")
			R.reagents.remove_reagent("water", rand(5, 10))
			state--
			if(state < FIRE_SMALL)
				qdel(src)
			if(prob(10))
				qdel(src)
				return
	if(istype(W, /obj/item/weapon/flame/torch))
		var/obj/item/weapon/flame/torch/T = W
		T.turn_on()

	return ..()

#undef FIRE_BIG
#undef FIRE_MEDIUM
#undef FIRE_SMALL
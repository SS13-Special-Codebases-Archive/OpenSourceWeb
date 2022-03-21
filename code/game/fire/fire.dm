/obj/item/trash
    flammable = 1
    burnable = 1

/obj/structure/fire
    density = 0
    icon = 'icons/fire/fire2.dmi'
    icon_state = "1"
    layer = 5
    anchored = 1
    plane = 5
    var/probEvolve = 1
    var/intensityFire = 1
    var/growingIntensity = 2
    var/damage = 10

/obj/structure/fire/Destroy()
	loc = null
	qdel(reagents)
	reagents = null
	..()

/obj/structure/fire/New()
    if(isturf(loc))
        var/turf/T = loc
        if(T.fired)
            qdel(src)
            return
        if(!T.fireSpawnable)
            qdel(src)
            return
        T.fired = src
    ..()
    processing_objects += src

    playsound(src.loc, 'sound/effects/fire.ogg', 30, 1)

/obj/effect/effect/fireGas
    density = 0
    icon = 'icons/fire/fire2.dmi'
    icon_state = "1o"
    layer = 5
    burnable = 0

/obj/effect/effect/fireGas/f2
    icon_state = "2o"

/obj/effect/effect/fireGas/f3
    icon_state = "3o"

/obj/effect/effect/fireGas/New()
    ..()

    spawn(25)
        qdel(src)
    return

/obj/effect/effect/smoke/fire
    color = "black"
    alpha = 85
    time_to_live = 80
    opacity = 0


/obj/effect/effect/smoke/fire/New()
    if(isturf(loc))
        var/turf/T = loc

        if(T.smokeAmount >= 3)
            qdel(src)
            return

        T.smokeAmount++

    ..()


/obj/effect/effect/smoke/fire/delete()
    if(isturf(loc))
        var/turf/T = loc

        T.smokeAmount--

    ..()


/obj/effect/effect/smoke/fire/affect(mob/living/carbon/human/M as mob )
	..()
	if(ismonster(M))
		return

	if(prob(38))
		M.apply_damage(rand(5, 10), BURN);

	if(prob(90))
		if(M.holding_breath)
			return
		M.apply_damage(rand(20, 30), OXY);

/obj/structure/fire/attackby(obj/item/W, mob/user)
    ..()
    if(istype(W, /obj/item/weapon/reagent_containers))
        var/obj/item/weapon/reagent_containers/R = W

        var/reagentResult = R.reagents.get_reagent_amount("water")

        if(reagentResult > 10)
            user.visible_message("<span class='passivebold'>Splashes water into the fire, trying to put it out!</span>")
            R.reagents.remove_reagent("water", rand(5, 10))

            intensityFire--
            if(prob(90))
                intensityFire = 0
                return
    if(istype(W, /obj/item/weapon/flame/torch))
        var/obj/item/weapon/flame/torch/T = W

        T.lit = 1
        T.update_brightness()

/obj/structure/fire/Bumped(var/mob/living/carbon/human/AM)
    ..()
    if(ismonster(AM))
        return
    if(prob(20 * intensityFire))
        AM.apply_damage(damage * 1.5, BURN, pick("l_foot", "r_foot", "l_leg", "r_leg", "chest", "head"))
    if(prob(60))
        AM.apply_damage(damage * 2, OXY)

/obj/structure/fire/process()
    var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
    var/turf/locTurf = null
    if(isturf(loc))
        locTurf = loc

    spawn(10)
        playsound(src.loc, 'sound/effects/flesh_burning.ogg', 60+intensityFire, 1)

    if(istype(loc, /turf/simulated/floor/plating/dirt2))
        if(prob(25*intensityFire))
            var/turf/simulated/floor/plating/dirt2/D = loc
            D.sede = 0
            D.plantgrowing = new
            D.jacresciumavez = 0
            D.updateplantoverlay()

    switch(intensityFire)
        if(0)
            processing_objects -= src
            locTurf.fired = null
            qdel(src)
        if(1)
            icon_state = "1"
            probEvolve = 2
            set_light(2, 3, LIGHT_COLOR_FIRE)
            if(prob(13))
                new /obj/effect/effect/smoke/fire(loc)
            new /obj/effect/effect/fireGas(loc)
        if(2)
            icon_state = "2"
            probEvolve = 3
            growingIntensity = 4
            damage = 20
            set_light(4, 5, LIGHT_COLOR_FIRE)
            if(prob(20)){
                new /obj/effect/effect/smoke/fire(loc)
            }
            new /obj/effect/effect/fireGas/f2(loc)
        if(3)
            icon_state = "3"
            probEvolve = 5
            growingIntensity = 6
            damage = 30
            set_light(6, 8, LIGHT_COLOR_FIRE)
            if(prob(26)){
                new /obj/effect/effect/smoke/fire(loc)
            }
            new /obj/effect/effect/fireGas/f3(loc)
        else
            intensityFire = 3

    for(var/atom/A in locTurf.contents)
        var/chanceToGrow = 40
        if(ismob(A))
            if(ismonster(A))
                continue
            if(ishuman(A))
                var/mob/living/carbon/human/H = A
                if(prob(35 * intensityFire))
                    H.apply_damage(damage * 1.5, BURN, pick("l_foot", "r_foot", "l_leg", "r_leg", "chest", "head"))
                if(H.health < -20)
                    if(H.health < -70)
                        if(prob(20) && H.on_fire)
                            qdel(H)
                    if(prob(80))
                        H.on_fire = 1
                        H.update_fire()
            continue
        if(!A.burnable)
            continue
        if(A == src)
            continue
        if(!prob(probEvolve * 2))
            continue
        qdel(A)

        if(istype(A, /obj/item/stack/sheet/wood/))
            chanceToGrow = 65
        if(chanceToGrow)
            intensityFire++

    var/adjacentFire = 0
    for(var/direction in dirs)
        var/turf/T = get_step(src, direction)

        if(!isturf(T))
            continue
        if(!T.fired)
            if(!T.fireSpawnable)
                continue
            if(intensityFire >= 2){
                if(prob(growingIntensity) * 3.5){
                    new /obj/structure/fire(T);
                    break;
                }
            }
            for(var/atom/I in T.contents){
                if(I.flammable){
                    if(prob(growingIntensity) * 6){
                        new /obj/structure/fire(T);
                        break;
                    }
                }
            }
        else
            adjacentFire++
            if(T.fired.intensityFire < intensityFire)
                continue
            if(!(intensityFire - 1))
                continue
            intensityFire = T.fired.intensityFire - 1
            continue


    if(prob((8 * intensityFire)))
        intensityFire--
    if(!probEvolve)
        return

    if(adjacentFire < 3)
        intensityFire = 1
    if(adjacentFire == 3)
        intensityFire = 2
    if(adjacentFire > 3)
        intensityFire = 3

/turf/simulated/floor/exoplanet/water/Enter(mob/living/C)
    if(ishuman(C)){
        var/mob/living/carbon/human/H = C
        if(H.on_fire)
            H.on_fire = 0
    }
    return ..()

/turf/simulated/floor/lifeweb/wood
    flammable = 1

/turf/simulated/floor/lifeweb/New()
	if(src.icon_state == "bloodbar")
		set_light(2, 1, 5, 4, "#d53c3c")
		spawn(50)
			for(var/atom/movable/lighting_overlay/O in view(5, src))
				O.icon_state = "Noggs"

/obj/structure/fire/Destroy()
	loc = null
	..()
obj/machinery/door
	var/health = 900
	var/broken_icon
	var/isshaking = FALSE

obj/machinery/door/airlock/orbital/gates
	safe = 0

obj/machinery/door/airlock/orbital/gates/attack_paw(mob/user as mob)
	attack_hand(user)

obj/machinery/door/airlock/orbital/gates/proc/healthcheck()
	if(health <= 0)
		playsound(src.loc, 'sound/effects/metalwall.ogg', 80, 1)
		src.visible_message("<span class='badmood'>THE GATES ARE DESTROYED!</span>",)
		density = 0
		opacity = 0
		icon_state = broken_icon
		broken = 1
	return

/obj/machinery/door/proc/Jitter(var/type)
	var/old_x = pixel_x
	var/old_y = pixel_y
	if(!isshaking)
		isshaking = TRUE
		switch(type)
			if(1)
				pixel_x += 1
				pixel_y += 1
				sleep(0.5)
				pixel_x += 1
				pixel_y += 1
				sleep(0.5)
				pixel_x = old_x
				pixel_y = old_y
				isshaking = FALSE
			if(2)
				pixel_x += 1
				pixel_y -= 1
				sleep(0.5)
				pixel_x += 1
				pixel_y -= 1
				sleep(0.5)
				pixel_x = old_x
				pixel_y = old_y
				isshaking = FALSE
			if(3)
				pixel_x -= 1
				pixel_y += 1
				sleep(0.5)
				pixel_x -= 1
				pixel_y += 1
				sleep(0.5)
				pixel_x = old_x
				pixel_y = old_y
				isshaking = FALSE
	else
		return

obj/machinery/door/airlock/orbital/gates/attack_hand(mob/user as mob)
	if(!user)
		return playsound(loc, 'sound/effects/metalwall.ogg', 80, 1)
	playsound(loc, 'sound/effects/metalwall.ogg', 80, 1)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	for(var/obj/machinery/door/airlock/orbital/gates/GATE in range(src,3))
		if(GATE.airlock_tag == src.airlock_tag && !GATE.broken)
			var/picktype = pick(1,2,3)
			GATE.Jitter(picktype)
			src.Jitter(picktype)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			src.health -= rand(10,15)
			user.visible_message("<span class='combatbold'>[user]</span> <span class='combat'>mangles [src].</span>", \
					 "<span class='combat'>⠀You mangle [src].</span>", \
					 "You hear twisting metal.")

	if(iszombie(usr))			//If it's a zombie
		user.visible_message("<span class='danger'>[user] [pick("bangs on","slashes against")] the [src.name]!</span>", \
						 "<span class='warning'>You bang on the [src.name].</span>", \
						 "You hear twisting metal.")
		src.health -= rand(20,30)
		healthcheck()
		return
	if(HULK in user.mutations)		//Or hulk
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message("<span class='danger'>[user] tears the [src.name] apart!</span>", \
						 "<span class='warning'>You tear the [src.name] apart.</span>", \
						 "You hear a sound of twisting metal followed by a crack.")
		health -= 10
		return
	else
		//health -= rand(5,8)
		user.visible_message("<span class='combatbold'>[user]</span> <span class='combat'>kicks [src].</span>", \
						 "<span class='combat'>⠀You kick [src].</span>", \
						 "You hear twisting metal.")
	healthcheck()

obj/machinery/door/airlock/orbital/gates/attackby(obj/item/W as obj, mob/user as mob)
	src.health -= W.force * 0.75
	playsound(src.loc, 'sound/effects/metalwall.ogg', 80, 1)
	visible_message("<span class='danger'>[src] has been hit by [user] with [W].</span>")
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	for(var/obj/machinery/door/airlock/orbital/gates/GATE in range(src,3))
		if(GATE.airlock_tag == src.airlock_tag && !GATE.broken)
			var/picktype = pick(1,2,3)
			GATE.Jitter(picktype)
			src.Jitter(picktype)
	if(src.health <= 0)
		src.healthcheck()

obj/machinery/door/airlock/orbital/gates/ins
	name = "Internal Gates"
	airlock_tag = "gatein"
	broken_icon = "door_broken"
	locked = 0
	autoclose = 0

obj/machinery/door/airlock/orbital/gates/ins/healthcheck()
	if(health <= 0 && !broken)
		playsound(src.loc, 'sound/effects/gates_done.ogg', 100, 1)
		src.visible_message("<span class='badmood'>THE GATES ARE DESTROYED!</span>",)
		density = 0
		opacity = 0
		icon_state = broken_icon
		broken = 1
		for(var/obj/machinery/door/airlock/orbital/gates/ins/GATE in world)
			GATE.density = 0
			GATE.opacity = 0
			GATE.icon_state = broken_icon
			broken = 1
	return

/obj/machinery/door/airlock/orbital/gates/ins/RightClick()
	return 0

/obj/machinery/door/airlock/orbital/gates/ins/_1
	icon = 'icons/life/gate1.dmi'
	icon_state = "door_closed"
/obj/machinery/door/airlock/orbital/gates/ins/_2
	icon = 'icons/life/gate2.dmi'
	icon_state = "door_closed"
/obj/machinery/door/airlock/orbital/gates/ins/_3
	icon = 'icons/life/gate3.dmi'
	icon_state = "door_closed"

/obj/machinery/door/airlock/orbital/gates/ex
	name = "External Gates"
	airlock_tag = "gateex"
	broken_icon = "door_broken"
	locked = 0
	autoclose = 0

/obj/machinery/door/airlock/orbital/gates/ex/RightClick()
	return 0

/obj/machinery/door/airlock/orbital/gates/ex/_1
	icon = 'icons/life/gate1.dmi'
	icon_state = "door_closed"
/obj/machinery/door/airlock/orbital/gates/ex/_2
	icon = 'icons/life/gate2.dmi'
	icon_state = "door_closed"
/obj/machinery/door/airlock/orbital/gates/ex/_3
	icon = 'icons/life/gate3.dmi'
	icon_state = "door_closed"

obj/machinery/door/airlock/orbital/gates/ex/healthcheck()
	if(health <= 0 && !broken)
		playsound(src.loc, 'sound/effects/gates_done.ogg', 100, 1)
		src.visible_message("<span class='badmood'>THE GATES ARE DESTROYED!</span>",)
		density = 0
		opacity = 0
		icon_state = broken_icon
		broken = 1
		for(var/obj/machinery/door/airlock/orbital/gates/ex/GATE in world)
			GATE.density = 0
			GATE.opacity = 0
			GATE.icon_state = broken_icon
			broken = 1
	return

/obj/machinery/door/airlock/orbital/gates/magma
	name = "floor"
	desc = "Uma escotilha."
	locked = 0
	autoclose = 0
	opacity = 0
	layer = 2
	density = 0
	icon = 'icons/life/escotilha.dmi'
	icon_state = "door_closed"
	airlock_tag = "magma"
	var/inicializado = 0

	var/fechado = 1

/obj/machinery/door/airlock/orbital/gates/magma/process()
	if(ticker.current_state == GAME_STATE_PLAYING)
		if(!inicializado && src.icon_state == "door_open")
			src.icon_state = "door_closed"
			inicializado = 1
	if(!fechado)
		for(var/mob/living/carbon/human/M in src.loc)
			if(istype(M, /mob/living/carbon/human))
				M.icon = 'icons/life/burnmotherfucker.dmi'
				M.icon_state = "fire_s"
				playsound(M.loc, 'flesh_burning.ogg', 80, 1)
				M.emote("agonyscream")
				new/obj/effect/decal/cleanable/ash
				M.dust()
				return

/obj/machinery/door/airlock/orbital/gates/magma/New()
	opacity = 0
	density = 0
	fechado = 1
	layer = 2
	icon_state = "door_closed"
	processing_objects.Add(src)
	close()

/obj/machinery/door/airlock/orbital/gates/magma/open(mob/living/carbon/human/M as mob)
	fechado = 0
	playsound(src.loc, 'sound/lfwbsounds/lava_open.ogg', 30, 1)
	flick("door_opening", src)
	spawn(10)
		icon_state = "door_open"
	for(M in src.loc)
		if(istype(M, /mob/living/carbon/human))
			M.icon = 'icons/life/burnmotherfucker.dmi'
			M.icon_state = "fire_s"
			playsound(M.loc, 'flesh_burning.ogg', 80, 1)
			M.emote("agonyscream")
			new/obj/effect/decal/cleanable/ash
			M.dust()
			return

/obj/machinery/door/airlock/orbital/gates/magma/close()
	fechado = 1
	playsound(src.loc, 'sound/lfwbsounds/lava_close.ogg', 30, 1)
	flick("door_closing", src)
	spawn(10)
		icon_state = "door_closed"

/obj/machinery/door/airlock/orbital/gates/magma/RightClick()
	return 0

/obj/machinery/door/airlock/orbital/gates/magma/Crossed(mob/living/carbon/human/M as mob|obj)
	if(!fechado)
		if(istype(M, /mob/living/carbon/human))
			if(!M.jumping)
				M.icon = 'icons/life/burnmotherfucker.dmi'
				playsound(M.loc, 'flesh_burning.ogg', 80, 1)
				M.icon_state = "fire_s"
				M.emote("agonyscream")
				spawn(10)
					new/obj/effect/decal/cleanable/ash
					M.dust()
				return
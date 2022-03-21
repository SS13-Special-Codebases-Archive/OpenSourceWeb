//NOT using the existing /obj/machinery/door type, since that has some complications on its own, mainly based on its
//machineryness

/obj/structure/mineral_door
	name = "mineral door"
	density = 1
	anchored = 1
	opacity = 1

	icon = 'icons/obj/doors/mineral_doors.dmi'
	icon_state = "metal"

	var/mineralType = "metal"
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/hardness = 1
	var/oreAmount = 7
	var/broken = 0

	New(location)
		..()
		icon_state = mineralType
		update_nearby_tiles(need_rebuild=1)

	Destroy()
		update_nearby_tiles()
		..()

	Bumped(atom/user)
		if(istype(user, /mob/dead/observer))
			return
		..()
		if(!state)
			return TryToSwitchState(user)
		return

	attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
		if(isAI(user)) //so the AI can't open it
			return
		else if(isrobot(user)) //but cyborgs can
			if(get_dist(user,src) <= 1) //not remotely though
				return TryToSwitchState(user)

	attack_paw(mob/user as mob)
		return TryToSwitchState(user)

	attack_hand(mob/user as mob)
		return TryToSwitchState(user)

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group) return 0
		if(istype(mover, /obj/effect/beam))
			return !opacity
		return !density

	proc/TryToSwitchState(atom/user)
		if(isSwitchingStates) return
		if(ismob(user))
			var/mob/M = user
			if(world.time - user.last_bumped <= 60) return //NOTE do we really need that?
			if(M.client)
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					if(!C.handcuffed)
						SwitchState()
				else
					SwitchState()
		else if(istype(user, /obj/mecha))
			SwitchState()

	proc/SwitchState()
		if(state)
			Close()
		else
			Open()
		if(src?:loc)
			src?:loc?:check_for_reagents_to_update()

	proc/Open()
		isSwitchingStates = 1
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 100, 1)
		flick("[mineralType]opening",src)
		sleep(10)
		density = 0
		if(hardness <= 0.50)
			icon_state = "y[icon_state]"
			set_opacity(0)
		else
			set_opacity(0)
		state = 1
		update_icon()
		isSwitchingStates = 0
	proc/Close()
		isSwitchingStates = 1
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 100, 1)
		flick("[mineralType]closing",src)
		sleep(10)
		density = 1
		if(hardness <= 0.50)
			icon_state = "y[icon_state]"
			set_opacity(0)
		else
			set_opacity(1)
		var/obj/reagent/reagente = locate() in loc
		if(reagente)
			qdel(reagente)
		state = 0
		update_icon()
		isSwitchingStates = 0
		update_fluid_icon(0, null)

	update_icon()
		if(state)
			icon_state = "[mineralType]open"
		else
			icon_state = mineralType

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W,/obj/item/weapon/pickaxe))
			var/obj/item/weapon/pickaxe/digTool = W
			user << "You start digging the [name]."
			if(do_after(user,digTool.digspeed*hardness) && src)
				user << "You finished digging."
				Dismantle()
		else if(istype(W,/obj/item/weapon)) //not sure, can't not just weapons get passed to this proc?
			hardness -= W.force/100
			user << "You hit the [name] with your [W.name]!"
			CheckHardness()
		else
			attack_hand(user)
		return

	proc/CheckHardness()
		if(hardness <= 0)
			Dismantle(1)
		if(hardness <= 0.25)
			state = 1
			update_icon()
			icon_state = "x[mineralType]"
			broken = 1
			density = 0
			opacity = 0
			if(prob(76))
				playsound(loc, pick('sound/effects/melee_wood_destroy_01.ogg','sound/effects/melee_wood_destroy_02.ogg','sound/effects/melee_wood_destroy_03.ogg'), 70, 0)
			return
		if(hardness <= 0.50)
			if(state)
				icon_state = "y[mineralType]open"
			else
				icon_state = "y[mineralType]"
			if(prob(50))
				playsound(loc, pick('sound/effects/melee_wood_destroy_01.ogg','sound/effects/melee_wood_destroy_02.ogg','sound/effects/melee_wood_destroy_03.ogg'), 70, 0)
			opacity = 0
			return

	proc/Dismantle(devastated = 0)
		if(!devastated)
			if (mineralType == "metal")
				var/ore = /obj/item/stack/sheet/metal
				for(var/i = 1, i <= oreAmount, i++)
					new ore(get_turf(src))
			else
				var/ore = text2path("/obj/item/stack/sheet/mineral/[mineralType]")
				for(var/i = 1, i <= oreAmount, i++)
					new ore(get_turf(src))
		else
			if (mineralType == "metal")
				var/ore = /obj/item/stack/sheet/metal
				for(var/i = 3, i <= oreAmount, i++)
					new ore(get_turf(src))
			else
				var/ore = text2path("/obj/item/stack/sheet/mineral/[mineralType]")
				for(var/i = 3, i <= oreAmount, i++)
					new ore(get_turf(src))
		qdel(src)

	ex_act(severity = 1)
		switch(severity)
			if(1)
				Dismantle(1)
			if(2)
				if(prob(20))
					Dismantle(1)
				else
					hardness--
					CheckHardness()
			if(3)
				hardness -= 0.1
				CheckHardness()
		return

/obj/structure/mineral_door/wood/north
	dir=NORTH
/obj/structure/mineral_door/wood/south
	dir=SOUTH
/obj/structure/mineral_door/wood/west
	dir=WEST
/obj/structure/mineral_door/wood/east
	dir=EAST

/obj/structure/mineral_door/wood/_1/north
	dir=NORTH
/obj/structure/mineral_door/wood/_1/south
	dir=SOUTH
/obj/structure/mineral_door/wood/_1/west
	dir=WEST
/obj/structure/mineral_door/wood/_1/east
	dir=EAST

/obj/structure/mineral_door/wood/proc/Jitter(var/type)
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

/obj/structure/mineral_door/wood
	name = "wooden door"
	icon_state = "wood"
	mineralType = "wood"
	hardness = 3
	var/locked = FALSE
	var/cooldown = FALSE
	var/isshaking
	var/key_lock = null

	Open()
		if(cooldown)
			return
		if(broken)
			return
		if(locked)
			playsound(loc, pick('sound/effects/wlocked1.ogg','sound/effects/wlocked2.ogg'), 100, 0)
			cooldown = TRUE
			spawn(5)
				cooldown = FALSE
			return
		isSwitchingStates = 1
		playsound(loc, 'sound/effects/wood_open.ogg', 100, 0)
		flick("[mineralType]opening",src)
		sleep(3)
		density = 0
		set_opacity(0)
		state = 1
		update_icon()
		isSwitchingStates = 0

	Close()
		if(cooldown)
			return
		if(broken)
			return
		if(locked)
			playsound(loc, pick('sound/effects/wlocked1.ogg','sound/effects/wlocked2.ogg'), 100, 0)
			cooldown = TRUE
			spawn(5)
				cooldown = FALSE
			return
		isSwitchingStates = 1
		playsound(loc, 'sound/effects/wood_close.ogg', 100, 0)
		flick("[mineralType]closing",src)
		sleep(3)
		density = 1
		set_opacity(1)
		state = 0
		update_icon()
		isSwitchingStates = 0
		var/obj/reagent/reagente = locate() in loc
		if(reagente)
			qdel(reagente)
		update_fluid_icon(0, null)

	RightClick()
		if(cooldown)
			return
		if(key_lock)
			return
		var/mob/M = usr
		if(get_dist(src, M) >= 2)
			return
		var/realDir = get_dir(src,M)
		var/otroDir = turn(src.dir, 180)
		if(realDir == otroDir)
			if(locked)
				playsound(loc, 'sound/effects/wboltswitch.ogg', 100, 0)
				sound2()
				locked = FALSE
			else
				playsound(loc, 'sound/effects/wboltswitch.ogg', 100, 0)
				sound2()
				locked = TRUE
			cooldown = TRUE
			spawn(5)
				cooldown = FALSE
		else
			playsound(loc, pick('sound/effects/knockknock1.ogg','sound/effects/knockknock2.ogg','sound/effects/knockknock3.ogg','sound/effects/knockknock4.ogg','sound/effects/knockknock5.ogg','sound/effects/knockknock6.ogg'), 80, 0)
			cooldown = TRUE
			spawn(5)
				cooldown = FALSE
			sound2()

	Dismantle(devastated = 0)
		if(!devastated)
			for(var/i = 1, i <= oreAmount, i++)
				new/obj/item/stack/sheet/wood(get_turf(src))
		qdel(src)


/obj/structure/mineral_door/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/lockpick) && !lockpicking)
		do_lockpicking(user, W)
	if(istype(W, /obj/item/weapon/key))
		var/obj/item/weapon/key/K = W
		if(K.key_lock == src.key_lock)
			if(locked)
				locked = FALSE
			else
				locked = TRUE
			return
	else
		..()

/obj/structure/mineral_door/proc/do_lockpicking(var/mob/living/carbon/human/H, var/obj/item/weapon/lockpick/W)
	lockpicking = TRUE
	to_chat(H, "<span class='jogtowalk'><i>You attempt to lockpick \the [src].</i></span>")
	var/obj/screen/lockpicking/base/BASE = new ()
	if(!H.client.screen.Find(BASE))
		H.client.screen += BASE
		H.client.screen += BASE.left
		H.client.screen += BASE.right
		H.client.screen += BASE.forceit
		H.client.screen += BASE.push
		H.client.screen += BASE.pin
		BASE.lockpickable = src
		BASE.lockpick = W
		BASE.M = H
		H.lockpickingObj = src
		LockBASEs = BASE

/obj/structure/mineral_door/metal/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/lockpick) && !lockpicking)
		do_lockpicking(user, W)
	else
		..()

/obj/structure/mineral_door/metal
	name = "metal door"
	icon_state = "door"
	mineralType = "door"
	hardness = 1

	Open()
		isSwitchingStates = 1
		var/som = pick('sound/lfwbsounds/double_open1.ogg', 'sound/lfwbsounds/double_open2.ogg')
		playsound(loc, som, 50, 0)
		flick("[mineralType]opening",src)
		sleep(3)
		density = 0
		set_opacity(0)
		state = 1
		update_icon()
		isSwitchingStates = 0

	Close()
		isSwitchingStates = 1
		playsound(loc, 'sound/lfwbsounds/double_close.ogg', 50, 0)
		flick("[mineralType]closing",src)
		sleep(3)
		density = 1
		set_opacity(1)
		state = 0
		update_icon()
		isSwitchingStates = 0
		var/obj/reagent/reagente = locate() in loc
		if(reagente)
			qdel(reagente)
		update_fluid_icon(0, null)

	Dismantle(devastated = 0)
		if(!devastated)
			for(var/i = 1, i <= oreAmount, i++)
				new/obj/item/stack/sheet/wood(get_turf(src))
		qdel(src)

/obj/structure/mineral_door/wood/_1
	name = "wooden door"
	icon_state = "wood1"
	mineralType = "wood1"

/obj/structure/mineral_door/wood/_1/residencesONE
	locked = 1
	key_lock = "residencesONE"

/obj/structure/mineral_door/wood/_1/residencesTWO
	locked = 1
	key_lock = "residencesTWO"

/obj/structure/mineral_door/wood/_1/residencesHUMP
	locked = 1
	key_lock = "residencesHUMP"

/obj/structure/mineral_door/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/key))
		var/obj/item/weapon/key/K = W
		if(K.key_lock == src.key_lock)
			if(locked)
				locked = FALSE
			else
				locked = TRUE
			playsound(loc, 'sound/effects/wboltswitch.ogg', 100, 0)
			sound2()
			return
	if(istype(W,/obj/item/weapon))
		hardness -= W.force/100
		user << "You hit the [name] with your [W.name]!"
		playsound(loc, 'sound/webbers/wdoorhit.ogg', 70, 0)
		CheckHardness()
		Jitter(rand(1,3))
		user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
	else
		attack_hand(user)
	return
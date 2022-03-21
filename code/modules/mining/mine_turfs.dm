/**********************Mineral deposits**************************/


datum/controller/game_controller/var/list/artifact_spawning_turfs = list()
var/list/artifact_spawn = list() // Runtime fix for geometry loading before controller is instantiated.

/turf/simulated/mineral //wall piece
	name = "Rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	oxygen = 0
	nitrogen = 0
	opacity = 1
	density = 1
	blocks_air = 1
	temperature = TCMB
	var/mineral/mineral
	var/mined_ore = 0
	var/last_act = 0

	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/weapon/last_find
	var/datum/artifact_find/artifact_find


	New()
		. = ..()

		MineralSpread()

		spawn(1)
			var/turf/T
			if((istype(get_step(src, NORTH), /turf/simulated/floor)) || (istype(get_step(src, NORTH), /turf/space)) || (istype(get_step(src, NORTH), /turf/simulated/shuttle/floor)))
				T = get_step(src, NORTH)
				if (T)
					T.overlays += image('icons/turf/walls.dmi', "rock_side_s")
			if((istype(get_step(src, SOUTH), /turf/simulated/floor)) || (istype(get_step(src, SOUTH), /turf/space)) || (istype(get_step(src, SOUTH), /turf/simulated/shuttle/floor)))
				T = get_step(src, SOUTH)
				if (T)
					T.overlays += image('icons/turf/walls.dmi', "rock_side_n", layer=6)
			if((istype(get_step(src, EAST), /turf/simulated/floor)) || (istype(get_step(src, EAST), /turf/space)) || (istype(get_step(src, EAST), /turf/simulated/shuttle/floor)))
				T = get_step(src, EAST)
				if (T)
					T.overlays += image('icons/turf/walls.dmi', "rock_side_w", layer=6)
			if((istype(get_step(src, WEST), /turf/simulated/floor)) || (istype(get_step(src, WEST), /turf/space)) || (istype(get_step(src, WEST), /turf/simulated/shuttle/floor)))
				T = get_step(src, WEST)
				if (T)
					T.overlays += image('icons/turf/walls.dmi', "rock_side_e", layer=6)


	ex_act(severity)
		switch(severity)
			if(2.0)
				if (prob(70))
					mined_ore = 1 //some of the stuff gets blown up
					GetDrilled()
			if(1.0)
				mined_ore = 2 //some of the stuff gets blown up
				GetDrilled()


	Bumped(AM)
		. = ..()
		if(istype(AM,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = AM
			if((istype(H.l_hand,/obj/item/weapon/pickaxe)) && (!H.hand))
				attackby(H.l_hand,H)
			else if((istype(H.r_hand,/obj/item/weapon/pickaxe)) && H.hand)
				attackby(H.r_hand,H)

		else if(istype(AM,/mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = AM
			if(istype(R.module_active,/obj/item/weapon/pickaxe))
				attackby(R.module_active,R)

		else if(istype(AM,/obj/mecha))
			var/obj/mecha/M = AM
			if(istype(M.selected,/obj/item/mecha_parts/mecha_equipment/tool/drill))
				M.selected.action(src)


	proc/MineralSpread()
		if(mineral && mineral.spread)
			for(var/trydir in cardinal)
				if(prob(mineral.spread_chance))
					var/turf/simulated/mineral/random/target_turf = get_step(src, trydir)
					if(istype(target_turf) && !target_turf.mineral)
						target_turf.mineral = mineral
						target_turf.UpdateMineral()
						target_turf.MineralSpread()


	proc/UpdateMineral()
		if(!mineral)
			name = "\improper Rock"
			icon_state = "rock"
			return
		name = "\improper [mineral.display_name] deposit"
		icon_state = "rock_[mineral.name]"


/turf/simulated/mineral/random
	name = "Mineral deposit"
	var/mineralSpawnChanceList = list("Uranium" = 5, "Iron" = 50, "Diamond" = 1, "Gold" = 5, "Silver" = 5, "Plasma" = 25)//Currently, Adamantine won't spawn as it has no uses. -Durandan
	var/mineralChance = 10  //means 10% chance of this plot changing to a mineral deposit

	New()
		if (prob(mineralChance) && !mineral)
			var/mineral_name = pickweight(mineralSpawnChanceList) //temp mineral name

			if(!name_to_mineral)
				SetupMinerals()

			if (mineral_name && mineral_name in name_to_mineral)
				mineral = name_to_mineral[mineral_name]
				UpdateMineral()

		. = ..()


/turf/simulated/mineral/random/high_chance
	mineralChance = 25
	mineralSpawnChanceList = list("Uranium" = 10, "Iron" = 30, "Diamond" = 2, "Gold" = 10, "Silver" = 10, "Plasma" = 25)


/**********************Asteroid**************************/

/turf/simulated/floor/plating/airless/asteroid/cave
	var/length = 100
	var/mob_spawn_list = list("Goldgrub" = 1, "Goliath" = 5, "Basilisk" = 4, "Hivelord" = 3)
	var/sanity = 1

/turf/simulated/floor/plating/airless/asteroid/cave/New(loc, var/length, var/go_backwards = 1, var/exclude_dir = -1)

	// If length (arg2) isn't defined, get a random length; otherwise assign our length to the length arg.
	if(!length)
		src.length = rand(25, 50)
	else
		src.length = length

	// Get our directiosn
	var/forward_cave_dir = pick(alldirs - exclude_dir)
	// Get the opposite direction of our facing direction
	var/backward_cave_dir = angle2dir(dir2angle(forward_cave_dir) + 180)

	// Make our tunnels
	make_tunnel(forward_cave_dir)
	if(go_backwards)
		make_tunnel(backward_cave_dir)
	// Kill ourselves by replacing ourselves with a normal floor.
	SpawnFloor(src)
	..()

/turf/simulated/floor/plating/airless/asteroid/cave/proc/make_tunnel(var/dir)

	var/turf/simulated/mineral/tunnel = src
	var/next_angle = pick(45, -45)

	for(var/i = 0; i < length; i++)
		if(!sanity)
			break

		var/list/L = list(45)
		if(IsOdd(dir2angle(dir))) // We're going at an angle and we want thick angled tunnels.
			L += -45

		// Expand the edges of our tunnel
		for(var/edge_angle in L)
			var/turf/simulated/mineral/edge = get_step(tunnel, angle2dir(dir2angle(dir) + edge_angle))
			if(istype(edge))
				SpawnFloor(edge)

		// Move our tunnel forward
		tunnel = get_step(tunnel, dir)

		if(istype(tunnel))
			// Small chance to have forks in our tunnel; otherwise dig our tunnel.
			if(i > 3 && prob(20))
				new src.type(tunnel, rand(10, 15), 0, dir)
			else
				SpawnFloor(tunnel)
		else //if(!istype(tunnel, src.parent)) // We hit space/normal/wall, stop our tunnel.
			break

		// Chance to change our direction left or right.
		if(i > 2 && prob(33))
			// We can't go a full loop though
			next_angle = -next_angle
			dir = angle2dir(dir2angle(dir) + next_angle)


/turf/simulated/floor/plating/airless/asteroid/cave/proc/SpawnFloor(var/turf/T)
	for(var/turf/S in range(2,T))
		if(istype(S, /turf/space) || istype(S.loc, /area/mine/explored))
			sanity = 0
			break
	if(!sanity)
		return

	SpawnMonster(T)
/*	var/turf/simulated/floor/t = new /turf/simulated/floor/plating/airless/asteroid(T)
	spawn(2)
		t.fullUpdateMineralOverlays()*/

/turf/simulated/floor/plating/airless/asteroid/cave/proc/SpawnMonster(var/turf/T)
	if(prob(30))
		if(istype(loc, /area/mine/explored))
			return
		for(var/atom/A in range(30,T))//Lowers chance of mob clumps
			if(istype(A, /mob/living/simple_animal/hostile/asteroid))
				return
		var/randumb = pickweight(mob_spawn_list)
		switch(randumb)
			if("Goliath")
				new /mob/living/simple_animal/hostile/asteroid/goliath(T)
			if("Goldgrub")
				new /mob/living/simple_animal/hostile/asteroid/goldgrub(T)
			if("Basilisk")
				new /mob/living/simple_animal/hostile/asteroid/basilisk(T)
			if("Hivelord")
				new /mob/living/simple_animal/hostile/asteroid/hivelord(T)
	return


/turf/simulated/floor/plating/airless/asteroid //floor piece
	name = "Asteroid"
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB
	icon_plating = "asteroid"
	var/dug = 0       //0 = has not yet been dug, 1 = has already been dug

/turf/simulated/floor/plating/airless/asteroid/New()
	var/proper_name = name
	..()
	name = proper_name
	//if (prob(50))
	//	seedName = pick(list("1","2","3","4"))
	//	seedAmt = rand(1,4)
	if(prob(20))
		icon_state = "asteroid[rand(0,12)]"
	spawn(2)
		updateMineralOverlays()

/turf/simulated/floor/plating/airless/asteroid/ex_act(severity)
	switch(severity)
		if(3.0)
			return
		if(2.0)
			if (prob(70))
				gets_dug()
		if(1.0)
			gets_dug()
	return

/turf/simulated/floor/plating/airless/asteroid/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(!W || !user)
		return 0

	if ((istype(W, /obj/item/weapon/shovel)))
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return

		if (dug)
			user << "\red This area has already been dug"
			return

		user << "\red You start digging."
		playsound(loc, 'sound/effects/rustle1.ogg', 50, 1) //russle sounds sounded better

		sleep(40)
		if ((user.loc == T && user.get_active_hand() == W))
			user << "\blue You dug a hole."
			gets_dug()

	if ((istype(W,/obj/item/weapon/pickaxe/drill)))
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return

		if (dug)
			user << "\red This area has already been dug"
			return

		user << "\red You start digging."
		playsound(loc, 'sound/effects/rustle1.ogg', 50, 1) //russle sounds sounded better

		sleep(30)
		if ((user.loc == T && user.get_active_hand() == W))
			user << "\blue You dug a hole."
			gets_dug()

	if ((istype(W,/obj/item/weapon/pickaxe/diamonddrill)) || (istype(W,/obj/item/weapon/pickaxe/borgdrill)))
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return

		if (dug)
			user << "\red This area has already been dug"
			return

		user << "\red You start digging."
		playsound(loc, 'sound/effects/rustle1.ogg', 50, 1) //russle sounds sounded better

		sleep(0)
		if ((user.loc == T && user.get_active_hand() == W))
			user << "\blue You dug a hole."
			gets_dug()

	if(istype(W,/obj/item/weapon/storage/bag/ore))
		var/obj/item/weapon/storage/bag/ore/S = W
		if(S.collection_mode)
			for(var/obj/item/weapon/ore/O in contents)
				O.attackby(W,user)
				return

	else
		..(W,user)
	return

/turf/simulated/floor/plating/airless/asteroid/gets_dug()
	if(dug)
		return
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	dug = 1
	icon_plating = "asteroid_dug"
	icon_state = "asteroid_dug"
	return

/turf/simulated/floor/plating/airless/asteroid/proc/updateMineralOverlays()

	overlays.Cut()

	if(istype(get_step(src, NORTH), /turf/simulated/mineral))
		overlays += image('icons/turf/walls.dmi', "rock_side_n")
	if(istype(get_step(src, SOUTH), /turf/simulated/mineral))
		overlays += image('icons/turf/walls.dmi', "rock_side_s", layer=6)
	if(istype(get_step(src, EAST), /turf/simulated/mineral))
		overlays += image('icons/turf/walls.dmi', "rock_side_e", layer=6)
	if(istype(get_step(src, WEST), /turf/simulated/mineral))
		overlays += image('icons/turf/walls.dmi', "rock_side_w", layer=6)

/turf/simulated/floor/plating/airless/asteroid/proc/fullUpdateMineralOverlays()
	var/turf/simulated/floor/plating/airless/asteroid/A
	if(istype(get_step(src, WEST), /turf/simulated/floor/plating/airless/asteroid))
		A = get_step(src, WEST)
		A.updateMineralOverlays()
	if(istype(get_step(src, EAST), /turf/simulated/floor/plating/airless/asteroid))
		A = get_step(src, EAST)
		A.updateMineralOverlays()
	if(istype(get_step(src, NORTH), /turf/simulated/floor/plating/airless/asteroid))
		A = get_step(src, NORTH)
		A.updateMineralOverlays()
	if(istype(get_step(src, NORTHWEST), /turf/simulated/floor/plating/airless/asteroid))
		A = get_step(src, NORTHWEST)
		A.updateMineralOverlays()
	if(istype(get_step(src, NORTHEAST), /turf/simulated/floor/plating/airless/asteroid))
		A = get_step(src, NORTHEAST)
		A.updateMineralOverlays()
	if(istype(get_step(src, SOUTHWEST), /turf/simulated/floor/plating/airless/asteroid))
		A = get_step(src, SOUTHWEST)
		A.updateMineralOverlays()
	if(istype(get_step(src, SOUTHEAST), /turf/simulated/floor/plating/airless/asteroid))
		A = get_step(src, SOUTHEAST)
		A.updateMineralOverlays()
	if(istype(get_step(src, SOUTH), /turf/simulated/floor/plating/airless/asteroid))
		A = get_step(src, SOUTH)
		A.updateMineralOverlays()
	updateMineralOverlays()



/turf/simulated/floor/plating/airless/asteroid/Entered(atom/movable/M as mob|obj)
	..()
	if(istype(M,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		if(istype(R.module, /obj/item/weapon/robot_module/miner))
			if(istype(R.module_state_1,/obj/item/weapon/storage/bag/ore))
				attackby(R.module_state_1,R)
			else if(istype(R.module_state_2,/obj/item/weapon/storage/bag/ore))
				attackby(R.module_state_2,R)
			else if(istype(R.module_state_3,/obj/item/weapon/storage/bag/ore))
				attackby(R.module_state_3,R)
			else
				return
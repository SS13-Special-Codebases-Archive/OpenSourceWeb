/turf/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	icon_state = "white"

	temperature = T0C
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
//	heat_capacity = 700000 No.

	var/static/list/dust_cache
	var/static/list/stars_cache

/turf/space/proc/build_dust_cache()
	LAZYINITLIST(dust_cache)
	for (var/i in 0 to 25)
		var/image/im = image('icons/turf/space_dust.dmi',"[i]")
		im.layer = DUST_PLANE
		im.alpha = 80
		im.blend_mode = BLEND_ADD
		dust_cache["[i]"] = im

/turf/space/proc/build_stars_cache()
	LAZYINITLIST(stars_cache)
	for (var/i in 1 to 46)
		var/image/ima = image('icons/turf/stars.dmi',"[i]")
		ima.layer = SPACE_PLANE
		ima.blend_mode = BLEND_ADD
		stars_cache["[i]"] = ima

/turf/space/New()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		// check if there is something to draw below
		if(controller.down)
			var/turf/temp =  get_turf(locate(x,y,controller.down_target))
			if(!istype(temp,/turf/space))
				src.ChangeTurf(/turf/simulated/floor/open)
			return
	if (!dust_cache)
		build_dust_cache()
	if(!stars_cache)
		build_stars_cache()
	overlays += dust_cache["[((x + y) ^ ~(x * y) + z) % 25]"]
	overlays += stars_cache["[((x + y) ^ ~(x * y) + z) % 25]"]
	return

/turf/space/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/turf/space/attack_hand(mob/user as mob)
	if ((user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored || !isturf(user.pulling.loc))
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/space/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		user << "\blue Constructing support lattice ..."
		//playsound(src.loc, 'sound/weapons/Genhit.ogg', 50, 1)
		ReplaceWithLattice()
		R.use(1)
		return

	if (istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			qdel(L)
			//playsound(src.loc, 'sound/weapons/Genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return
		else
			user << "\red The plating is going to need some support."
	return


// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	..()
	if ((!(A) || src != A.loc))	return

	inertial_drift(A)

	if(ticker && ticker.mode)

		// Okay, so let's make it so that people can travel z levels but not nuke disks!
		// if(ticker.mode.name == "nuclear emergency")	return
		if(A.z > world.maxz && !config.use_overmap) return
		if (A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE - 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE - 1))
			if(istype(A, /obj/effect/meteor))
				qdel(A)
				return

			if(istype(A, /obj/item/weapon/disk/nuclear)) // Don't let nuke disks travel Z levels  ... And moving this shit down here so it only fires when they're actually trying to change z-level.
				qdel(A) //The disk's Destroy() proc ensures a new one is created
				return

			if(config.use_overmap)
				overmap_spacetravel(src,A)
				return

			var/list/disk_search = A.search_contents_for(/obj/item/weapon/disk/nuclear)
			if(!isemptylist(disk_search))
				if(istype(A, /mob/living))
					var/mob/living/MM = A
					if(MM.client && !MM.stat)
						MM << "\red Something you are carrying is preventing you from leaving. Don't play stupid; you know exactly what it is."
						if(MM.x <= TRANSITIONEDGE)
							MM.inertia_dir = 4
						else if(MM.x >= world.maxx -TRANSITIONEDGE)
							MM.inertia_dir = 8
						else if(MM.y <= TRANSITIONEDGE)
							MM.inertia_dir = 1
						else if(MM.y >= world.maxy -TRANSITIONEDGE)
							MM.inertia_dir = 2
					else
						for(var/obj/item/weapon/disk/nuclear/N in disk_search)
							qdel(N)//Make the disk respawn it is on a clientless mob or corpse
				else
					for(var/obj/item/weapon/disk/nuclear/N in disk_search)
						qdel(N)//Make the disk respawn if it is floating on its own
				return

			var/move_to_z = src.z
			var/safety = 1

			while(move_to_z == src.z)
				var/move_to_z_str = pickweight(accessable_z_levels)
				move_to_z = text2num(move_to_z_str)
				safety++
				if(safety > 10)
					break

			if(!move_to_z)
				return

			A.z = move_to_z

			if(src.x <= TRANSITIONEDGE)
				A.x = world.maxx - TRANSITIONEDGE - 2
				A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if (A.x >= (world.maxx - TRANSITIONEDGE - 1))
				A.x = TRANSITIONEDGE + 1
				A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if (src.y <= TRANSITIONEDGE)
				A.y = world.maxy - TRANSITIONEDGE -2
				A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

			else if (A.y >= (world.maxy - TRANSITIONEDGE - 1))
				A.y = TRANSITIONEDGE + 1
				A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)




			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
					//now we're on the new z_level, proceed the space drifting
					A.newtonian_move(A.inertia_dir)

/turf/space/proc/Sandbox_Spacemove(atom/movable/A as mob|obj)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/target_z
	var/list/y_arr

	if(src.x <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (--cur_x||global_map.len)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Target Z = [target_z]"
		world << "Next X = [next_x]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = world.maxx - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (++cur_x > global_map.len ? 1 : cur_x)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Target Z = [target_z]"
		world << "Next X = [next_x]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.y <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (--cur_y||y_arr.len)
		target_z = y_arr[next_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Next Y = [next_y]"
		world << "Target Z = [target_z]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = world.maxy - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)

	else if (src.y >= world.maxy)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (++cur_y > y_arr.len ? 1 : cur_y)
		target_z = y_arr[next_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Next Y = [next_y]"
		world << "Target Z = [target_z]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	return


/*
/turf/space/hull
	name = "Hull Plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "engine"

/turf/space/hull/New()
	return
	oxygen = 0
	nitrogen = 0.000
	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000
	thermal_conductivity = 0.025

/turf/space/hull/attackby(obj/item/weapon/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(istype(C, /obj/item/weapon/wrench))
		user << "\blue Removing rods..."
		playsound(src.loc, 'sound/items/Ratchet.ogg', 80, 1)
		if(do_after(user, 30))
			new /obj/item/stack/rods(src, 2)
			ChangeTurf(/turf/simulated/floor/airless)
			var/turf/simulated/floor/airless/F = src
			F.make_plating()
			return
	if (istype(C, /obj/item/stack/rods))
		user << "\blue Floor already reinforced."
		return
*/
//Will fix this later, need to make it act as a reinf floor

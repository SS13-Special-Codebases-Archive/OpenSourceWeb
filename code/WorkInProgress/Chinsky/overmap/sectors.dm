
//===================================================================================
//Hook for building overmap
//===================================================================================
var/global/list/map_sectors = list()

/hook/startup/proc/build_map()					//I had a problem reading this, so I decided to explain everything.
	if(!config.use_overmap)
		return 1
	testing("Building overmap...")
	var/obj/effect/mapinfo/data

	moving_levels.len = world.maxz

	for(var/level in 1 to world.maxz)

		data = locate("sector[level]")

		if(istype(data, /obj/effect/mapinfo/ship))							//First we'll check for ships, because they can occupy multiplie levels
			var/obj/effect/map/ship/found_ship = locate("ship_[data.shipname]")
			if(found_ship)													//If there is a ship with such a name...
				testing("Ship \"[data.shipname]\" found at [data.mapx],[data.mapy] corresponding to zlevel [level]")
				found_ship.ship_levels += level								//Adding this z-level to the list of the ship's z-levels.
				map_sectors["[level]"] = found_ship
			else
				found_ship = new data.obj_type(data)	//If there is no ship with such name, we will create one.
				found_ship.ship_levels += level
				map_sectors["[level]"] = found_ship
				testing("Ship \"[data.shipname]\" created \"[data.name]\" at [data.mapx],[data.mapy] corresponding to zlevel [level]")

		else if (data)														//Else we will just create an object, corresponding to it.
			testing("Located sector \"[data.name]\" at [data.mapx],[data.mapy] corresponding to zlevel [level]")
			map_sectors["[level]"] = new data.obj_type(data)

	for(var/obj/effect/map/ship/S in world)
		S.update_spaceturfs()

	return 1

//===================================================================================
//Metaobject for storing information about sector this zlevel is representing.
//Should be placed only once on every zlevel.
//===================================================================================
/obj/effect/mapinfo/
	name = "map info metaobject"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	invisibility = 101
	var/obj_type		//type of overmap object it spawns
	var/landing_area 	//type of area used as inbound shuttle landing, null if no shuttle landing area
	var/zlevel
	var/mapx			//coordinates on the
	var/mapy			//overmap zlevel
	var/known = 1
	var/shipname


/obj/effect/mapinfo/New()
	tag = "sector[z]"
	zlevel = z

/obj/effect/mapinfo/sector
	name = "generic sector"
	obj_type = /obj/effect/map/sector

/obj/effect/mapinfo/sector/New()
	tag = "sector[z]"
	zlevel = z

/obj/effect/mapinfo/ship
	name = "generic ship"
	obj_type = /obj/effect/map/ship
	var/ship_turfs
	var/ship_levels
	shipname = "generic_ship"

/obj/effect/mapinfo/ship/New()
	tag = "sector[z]"
	zlevel = z

/obj/effect/mapinfo/New()
	shipname = "ship_[shipname]"

//===================================================================================
//Overmap object representing zlevel
//===================================================================================

/obj/effect/map
	name = "map object"
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-plasteel"
	var/map_z = 0
	var/area/shuttle/shuttle_landing
	var/always_known = 1

/obj/effect/map/New(var/obj/effect/mapinfo/data)
	map_z = data.zlevel
	name = data.name
	always_known = data.known
	if (data.icon != 'icons/mob/screen1.dmi')
		icon = data.icon
		icon_state = data.icon_state
	if(data.desc)
		desc = data.desc
	var/new_x = data.mapx ? data.mapx : rand(OVERMAP_EDGE, world.maxx - OVERMAP_EDGE)
	var/new_y = data.mapy ? data.mapy : rand(OVERMAP_EDGE, world.maxy - OVERMAP_EDGE)
	loc = locate(new_x, new_y, OVERMAP_ZLEVEL)

	if(data.landing_area)
		shuttle_landing = locate(data.landing_area)

/obj/effect/map/CanPass(atom/movable/A)
//	testing("[A] attempts to enter sector\"[name]\"")
	return 1

/obj/effect/map/Crossed(atom/movable/A)
//	testing("[A] has entered sector\"[name]\"")
	if (istype(A,/obj/effect/map/ship))
		var/obj/effect/map/ship/S = A
		S.current_sector = src

/obj/effect/map/Uncrossed(atom/movable/A)
//	testing("[A] has left sector\"[name]\"")
	if (istype(A,/obj/effect/map/ship))
		var/obj/effect/map/ship/S = A
		S.current_sector = null

/obj/effect/map/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	anchored = 1

//Space stragglers go here

/obj/effect/map/sector/temporary
	name = "Deep Space"
	icon_state = ""
	always_known = 0

/obj/effect/map/sector/temporary/New(var/nx, var/ny, var/nz)
	loc = locate(nx, ny, OVERMAP_ZLEVEL)
	map_z = nz
	map_sectors["[map_z]"] = src
//	testing("Temporary sector at [x],[y] was created, corresponding zlevel is [map_z].")

/obj/effect/map/sector/temporary/Del()
	map_sectors["[map_z]"] = null
//	testing("Temporary sector at [x],[y] was deleted.")
	if (can_die())
//		testing("Associated zlevel disappeared.")
		world.maxz--

/obj/effect/map/sector/temporary/proc/can_die(var/mob/observer)
//	testing("Checking if sector at [map_z] can die.")
	for(var/mob/M in player_list)
		if(M != observer && M.z == map_z)
//			testing("There are people on it.")
			return 0
	return 1

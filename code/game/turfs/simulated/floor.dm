//This is so damaged or burnt tiles or platings don't get remembered as the default tile
var/list/icons_to_ignore_at_floor_init = list("damaged1","damaged2","damaged3","damaged4",
				"damaged5","panelscorched","floorscorched1","floorscorched2","platingdmg1","platingdmg2",
				"platingdmg3","plating","light_on","light_on_flicker1","light_on_flicker2",
				"light_on_clicker3","light_on_clicker4","light_on_clicker5","light_broken",
				"light_on_broken","light_off","wall_thermite","grass1","grass2","grass3","grass4",
				"asteroid","asteroid_dug",
				"asteroid0","asteroid1","asteroid2","asteroid3","asteroid4",
				"asteroid5","asteroid6","asteroid7","asteroid8","asteroid9","asteroid10","asteroid11","asteroid12",
				"oldburning","light-on-r","light-on-y","light-on-g","light-on-b", "wood", "wood-broken", "carpet",
				"carpetcorner", "carpetside", "carpet", "ironsand1", "ironsand2", "ironsand3", "ironsand4", "ironsand5",
				"ironsand6", "ironsand7", "ironsand8", "ironsand9", "ironsand10", "ironsand11",
				"ironsand12", "ironsand13", "ironsand14", "ironsand15",
				"carpetblue", "carpetblue2", "carpetblue3",
				 "carpetblue4", "carpetblue5" ,"carpetblue6" ,"carpetfblue1" ,
				  "carpetfblue2" ,"carpetfblue3" ,"carpetfblue4" ,"carpetfblue5" ,
				  "carpetfblue6" /*,"" ,"","",""*/)

var/list/plating_icons = list("plating","platingdmg1","platingdmg2","platingdmg3","asteroid","asteroid_dug",
				"ironsand1", "ironsand2", "ironsand3", "ironsand4", "ironsand5", "ironsand6", "ironsand7",
				"ironsand8", "ironsand9", "ironsand10", "ironsand11",
				"ironsand12", "ironsand13", "ironsand14", "ironsand15")
var/list/wood_icons = list("wood","wood-broken")

/turf/simulated/floor/proc/damage_overlay()
	var/image/img = image(icon = 'icons/turf/bholes.dmi', icon_state = pick("bhole1","bhole2","bhole3","bhole4"))
	img.pixel_x = rand(1,32)
	img.pixel_y = rand(1,32)
	src.overlays += img

/turf/simulated/floor

	//Note to coders, the 'intact' var can no longer be used to determine if the floor is a plating or not.
	//Use the is_plating(), is_plasteel_floor() and is_light_floor() procs instead. --Errorage
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"

	var/icon_regular_floor = "floor" //used to remember what icon the tile should have by default
	var/icon_plating = "plating"
	thermal_conductivity = 0.040
	heat_capacity = 10000
	var/lava = 0
	var/broken = 0
	var/burnt = 0
	var/mineral = "metal"

	var/style = null
	var/mudpit = 0
/turf/simulated/floor/bullet_act()
	..()
	var/som = pick('sound/projectilesnew/ric1.ogg', 'sound/projectilesnew/ric2.ogg', 'sound/projectilesnew/ric3.ogg', 'sound/projectilesnew/ric4.ogg')
	playsound(src, som, 300, 0)
	damage_overlay()

/turf/simulated/floor/New()
	..()
	if(icon_state in icons_to_ignore_at_floor_init) //so damaged/burned tiles or plating icons aren't saved as the default
		icon_regular_floor = "floor"
	else
		icon_regular_floor = icon_state

//turf/simulated/floor/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
//	if ((istype(mover, /obj/machinery/vehicle) && !(src.burnt)))
//		if (!( locate(/obj/machinery/mass_driver, src) ))
//			return 0
//	return ..()

/turf/simulated/floor/MiddleClick(mob/user)
	..()
	var/mob/living/carbon/human/H = user
	if(H.middle_click_intent)
		return
	if(!ishuman(user))
		return
	if(get_dist(src, H) >= 2)
		return
	if(src.contents.len <= 0)
		return
	if(H.stat)
		return
	var/list/NewContents = list()
	for(var/obj/item/O in src.contents)
		NewContents.Add(O)
	var/obj/item/O = input("What will [user.name] pick up?","") as null|anything in NewContents
	if(!O)
		return
	if(get_dist(O, H) >= 2)
		return
	O.attack_hand(user)

/turf/simulated/floor/ex_act(severity)
	//set src in oview(1)
	switch(severity)
		if(1.0)
			if(prob(80))
				src.ChangeTurf(/turf/simulated/floor/lifeweb/damaged)
			else
				src.ChangeTurf(/turf/simulated/floor/open)
		if(2.0)
			switch(pick(1,2;75,3))
				if (1)
					src.ReplaceWithLattice()
					if(prob(33)) new /obj/item/stack/sheet/metal(src)
				if(2)
					if(prob(70))
						src.ChangeTurf(/turf/simulated/floor/lifeweb/damaged)
					else
						src.ChangeTurf(/turf/space)
				if(3)
					if(prob(80))
						src.break_tile_to_plating()
					else
						src.break_tile()
					src.hotspot_expose(1000,CELL_VOLUME)
					if(prob(33)) new /obj/item/stack/sheet/metal(src)
		if(3.0)
			if (prob(50))
				src.break_tile()
				src.hotspot_expose(1000,CELL_VOLUME)
	return

/turf/simulated/floor/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return //LOCKADO

	if(!burnt && prob(5))
		burn_tile()
	else if(prob(1) && !is_plating())
		make_plating()
		burn_tile()
	return

/turf/simulated/floor/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = get_dir(src, adj_turf)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_fulltile()) //Same direction or diagonal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)

/turf/simulated/floor/blob_act()
	return
/*
/turf/simulated/floor/Entered(mob/living/M as mob)
	..()
	if(src.contents.len >= 9 && M?.m_intent != "walk")
		var/howmany = src.contents.len
		if(prob(howmany/2))
			M.stumble(0, src, "\the [src] is clustered, you stumble.")
*/
turf/simulated/floor/proc/update_icon()
	if(lava)
		return
	else if(is_plasteel_floor())
		if(!broken && !burnt)
			icon_state = icon_regular_floor
	else if(is_plating())
		if(!broken && !burnt)
			icon_state = icon_plating //Because asteroids are 'platings' too.
	if(style == "hull_new")
		var/connectdir = 0
		var/random_icon = "center[rand(1,34)]"
		for(var/direction in cardinal)
			if(istype(get_step(src,direction),/turf/simulated/floor) || istype(get_step(src,direction),/turf/simulated/wall))
				connectdir |= direction
			//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
		var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW
		//Northeast
		if(connectdir & NORTH && connectdir & EAST)
			if(istype(get_step(src,NORTHEAST),/turf/simulated/floor) || istype(get_step(src,NORTHEAST),/turf/simulated/wall))
				diagonalconnect |= 1
		//Southeast
		if(connectdir & SOUTH && connectdir & EAST)
			if(istype(get_step(src,SOUTHEAST),/turf/simulated/floor) || istype(get_step(src,SOUTHEAST),/turf/simulated/wall))
				diagonalconnect |= 2
			//Northwest
		if(connectdir & NORTH && connectdir & WEST)
			if(istype(get_step(src,NORTHWEST),/turf/simulated/floor) || istype(get_step(src,NORTHWEST),/turf/simulated/wall))
				diagonalconnect |= 4
			//Southwest
		if(connectdir & SOUTH && connectdir & WEST)
			if(istype(get_step(src,SOUTHWEST),/turf/simulated/floor) || istype(get_step(src,SOUTHWEST),/turf/simulated/wall))
				diagonalconnect |= 8
		if(!(connectdir == 15 && diagonalconnect == 15))
			random_icon = "[connectdir]-[diagonalconnect]"

		icon_state = "hull[random_icon]"


	else if(is_grass_floor())
		if(!broken && !burnt)
			if(!(icon_state in list("grass1","grass2","grass3","grass4")))
				icon_state = "grass[pick("1","2","3","4")]"
	else if(is_carpet_floor())
		if(!broken && !burnt)
			if(icon_state != "carpetsymbol")
				var/connectdir = 0
				for(var/direction in cardinal)
					if(istype(get_step(src,direction),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						if(FF.is_carpet_floor())
							connectdir |= direction

				//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
				var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW

				//Northeast
				if(connectdir & NORTH && connectdir & EAST)
					if(istype(get_step(src,NORTHEAST),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,NORTHEAST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 1

				//Southeast
				if(connectdir & SOUTH && connectdir & EAST)
					if(istype(get_step(src,SOUTHEAST),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,SOUTHEAST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 2

				//Northwest
				if(connectdir & NORTH && connectdir & WEST)
					if(istype(get_step(src,NORTHWEST),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,NORTHWEST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 4

				//Southwest
				if(connectdir & SOUTH && connectdir & WEST)
					if(istype(get_step(src,SOUTHWEST),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,SOUTHWEST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 8

				icon_state = "[src.style][connectdir]-[diagonalconnect]"

	else if(is_underplating(src))
		if(!broken && !burnt)
			var/connectdir = 0
			for(var/direction in cardinal)
				if(istype(get_step(src,direction),/turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src,direction)
					if(FF.is_underplating(src))
						connectdir |= direction
				//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
			var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW
			//Northeast
			if(connectdir & NORTH && connectdir & EAST)
				if(istype(get_step(src,NORTHEAST),/turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src,NORTHEAST)
					if(FF.is_underplating(src))
						diagonalconnect |= 1

			//Southeast
			if(connectdir & SOUTH && connectdir & EAST)
				if(istype(get_step(src,SOUTHEAST),/turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src,SOUTHEAST)
					if(FF.is_underplating(src))
						diagonalconnect |= 2

				//Northwest
			if(connectdir & NORTH && connectdir & WEST)
				if(istype(get_step(src,NORTHWEST),/turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src,NORTHWEST)
					if(FF.is_underplating(src))
						diagonalconnect |= 4

				//Southwest
			if(connectdir & SOUTH && connectdir & WEST)
				if(istype(get_step(src,SOUTHWEST),/turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src,SOUTHWEST)
					if(FF.is_underplating(src))
						diagonalconnect |= 8

			icon_state = "underplating[connectdir]-[diagonalconnect]"

	else if(is_wood_floor())
		if(!broken && !burnt)
			if( !(icon_state in wood_icons) )
				icon_state = "wood"
				//world << "[icon_state]y's got [icon_state]"
	/*spawn(1)
		if(istype(src,/turf/simulated/floor)) //Was throwing runtime errors due to a chance of it changing to space halfway through.
			if(air)
				update_visuals(air)*/

/turf/simulated/floor/return_siding_icon_state()
	..()
	if(is_grass_floor())
		var/dir_sum = 0
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(!(T.is_grass_floor()))
				dir_sum += direction
		if(dir_sum)
			return "wood_siding[dir_sum]"
		else
			return 0


/turf/simulated/floor/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/turf/simulated/floor/attack_hand(mob/user as mob)
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored || !isturf(user.pulling.loc))
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling

//		if(M==user)					//temporary hack to stop runtimes. ~Carn
//			user.stop_pulling()		//but...fixed the root of the problem
//			return					//shoudn't be needed now, unless somebody fucks with pulling again.

		var/mob/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/simulated/floor/proc/gets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	/*if(!is_plating())
		make_plating()*/
	break_tile()

/turf/simulated/floor/is_plasteel_floor()
	return 0

/turf/simulated/floor/is_light_floor()
	return 0

/turf/simulated/floor/proc/is_neon_floor()
	return 0


/turf/simulated/floor/is_grass_floor()
	return 0

/turf/simulated/floor/is_wood_floor()
	return 0

/turf/simulated/floor/is_carpet_floor()
	return 0

/turf/simulated/floor/is_underplating()
	return 0

/turf/simulated/floor/proc/is_hull()
	if(src.style == "hull_new")
		return 1
	else
		return 0

/turf/simulated/floor/is_plating()
	return 0

/turf/simulated/floor/proc/break_tile()
	if(istype(src,/turf/simulated/floor/engine)) return
	if(istype(src,/turf/simulated/floor/mech_bay_recharge_floor))
		src.ChangeTurf(/turf/simulated/floor/plating)
	if(broken) return
	if(is_plasteel_floor())
		//src.icon_state = "damaged[pick(1,2,3,4,5)]"
		broken = 1
	else if(is_light_floor())
		//src.icon_state = "light_broken"
		broken = 1
	else if(is_plating())
		if(istype(src, /turf/simulated/floor/lifeweb/stone))
			//src.icon_state = "stonedamaged"
			broken = 1
		else
			//src.icon_state = "ldamaged[pick(1,2,3)]"
			broken = 1
	else if(is_wood_floor())
		if(istype(src, /turf/simulated/floor/carpet/beatifulcarpet1))
			//src.icon_state = "grimy3"
			broken = 1
		else
			broken = 1
	else if(is_carpet_floor())
		//src.icon_state = "carpet-broken"
		broken = 1
	else if(is_grass_floor())
		//src.icon_state = "sand[pick("1","2","3")]"
		broken = 1
	if(istype(src, /turf/simulated/floor/lifeweb/stone))
		icon_state = "stonedamaged"
		broken = 1
		return
	if(istype(src, /turf/simulated/floor/plating/dirt_path))
		broken = 1
		return
	icon_state = pick("floorscorched1", "floorscorched2")

/turf/simulated/floor/proc/burn_tile()
	if(istype(src,/turf/simulated/floor/engine)) return
	if(istype(src,/turf/simulated/floor/plating/airless/asteroid)) return//Asteroid tiles don't burn
	if(broken || burnt) return
	if(is_plasteel_floor())
		//src.icon_state = "damaged[pick(1,2,3,4,5)]"
		burnt = 1
	else if(is_plasteel_floor())
		src.icon_state = "floorscorched[pick(1,2)]"
		burnt = 1
	else if(is_plating())
		src.icon_state = "panelscorched"
		burnt = 1
	else if(is_wood_floor())
		src.icon_state = "wood-broken"
		burnt = 1
	else if(is_carpet_floor())
		src.icon_state = "carpet-broken"
		burnt = 1
	else if(is_grass_floor())
		src.icon_state = "sand[pick("1","2","3")]"
		burnt = 1

//This proc will delete the floor_tile and the update_iocn() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating()
	if(istype(src,/turf/simulated/floor/engine)) return

	if(is_grass_floor())
		for(var/direction in cardinal)
			if(istype(get_step(src,direction),/turf/simulated/floor))
				var/turf/simulated/floor/FF = get_step(src,direction)
				FF.update_icon() //so siding get updated properly
	else if(is_carpet_floor())
		spawn(5)
			if(src)
				for(var/direction in list(1,2,4,8,5,6,9,10))
					if(istype(get_step(src,direction),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly



	icon_plating = "plating"

	intact = 0
	broken = 0
	burnt = 0

	update_icon()
	levelupdate()

//This proc will make the turf a plasteel floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/simulated/floor/proc/make_plasteel_floor(var/obj/item/stack/tile/plasteel/T = null)
	broken = 0
	burnt = 0
	intact = 1

	if(T)
		if(istype(T,/obj/item/stack/tile/plasteel))

			if (icon_regular_floor)
				icon_state = icon_regular_floor
			else
				icon_state = "floor"
				icon_regular_floor = icon_state
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.

	icon_state = "floor"
	icon_regular_floor = icon_state

	update_icon()
	levelupdate()

//This proc will make the turf a light floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/simulated/floor/proc/make_light_floor(var/obj/item/stack/tile/light/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/light))

			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.


	update_icon()
	levelupdate()

//This proc will make a turf into a grass patch. Fun eh? Insert the grass tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_grass_floor(var/obj/item/stack/tile/grass/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/grass))

			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.


	update_icon()
	levelupdate()

//This proc will make a turf into a wood floor. Fun eh? Insert the wood tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_wood_floor(var/obj/item/stack/tile/wood/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/wood))

			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.


	update_icon()
	levelupdate()

//This proc will make a turf into a carpet floor. Fun eh? Insert the carpet tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_carpet_floor(var/obj/item/stack/tile/carpet/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/carpet))

			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.


	update_icon()
	levelupdate()

/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)
	if(!C || !user)
		return 0

	if(istype(C, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = C
		if(G.assailant.zone_sel.selecting == "head" && G.affecting.lying)
			if(ishuman(G.affecting))
				G.affecting.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been smashed on the floor by [G.assailant.name] ([G.assailant.ckey])</font>")
				G.assailant.attack_log += text("\[[time_stamp()]\] <font color='red'>Smashed [G.affecting.name] ([G.affecting.ckey]) on the floor.</font>")

				//log_admin("ATTACK: [G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a table.", 2)
				message_admins("ATTACK: [G.assailant] ([G.assailant.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[G]'>JMP</A>) smashed [G.affecting] ([G.affecting.ckey]) on the floor.", 2)
				log_attack("[G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a table.")

				var/mob/living/carbon/human/H = G.affecting
				var/datum/organ/external/affecting = H.get_organ("head")
				if(prob(25))
					add_blood(G.affecting, 1) //Forced
					affecting.take_damage(rand(10,15), 0)
					H.Weaken(2)
					if(prob(20)) // One chance in 20 to DENT THE TABLE
						affecting.take_damage(rand(5,10), 0) //Extra damage
						G.assailant.visible_message("\red \The [G.assailant] smashes \the [H]'s head on \the [src] with enough force to further deform \the [src]!\nYou wish you could unhear that sound.",\
						"\red You smash \the [H]'s head on \the [src] with enough force to leave another dent!\n[prob(50)?"That was a satisfying noise." : "That sound will haunt your nightmares"]",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal and the squeal of said metal deforming.")
					else if(prob(50))
						G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
						"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal, the noise echoing through the room.")
					else
						G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
						"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
						"\red You hear the nauseating crunch of bone and gristle on solid metal and the gurgling gasp of someone who is trying to breathe through their own blood.")
				else
					affecting.take_damage(rand(5,10), 0)
					G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src]!",\
					"\red You smash \the [H]'s head on \the [src]!",\
					"\red You hear the nauseating crunch of bone and gristle on solid metal.")
				H.UpdateDamageIcon()
				H.updatehealth()
				var/mob/living/carbon/human/AS = G.assailant
				AS.adjustStaminaLoss(rand(6,15))
				playsound(H.loc, pick('sound/effects/gore/smash1.ogg','sound/effects/gore/smash2.ogg','sound/effects/gore/smash3.ogg'), 50, 1, -3)
				qdel(G)
	..()
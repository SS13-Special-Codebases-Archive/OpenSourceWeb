var/church_shuttle_tickstomove = 10
var/church_shuttle_moving = 0
var/church_shuttle_location = 1 // 0 = station 13, 1 = mining station

proc/move_church_shuttle()
	if(church_shuttle_moving)	return
	church_shuttle_moving = 1
	spawn(church_shuttle_tickstomove*10)
		var/area/fromArea
		var/area/toArea
		if (church_shuttle_location == 1)
			fromArea = locate(/area/shuttle/church/outpost)
			toArea = locate(/area/shuttle/church/station)

		else
			fromArea = locate(/area/shuttle/church/station)
			toArea = locate(/area/shuttle/church/outpost)

		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in toArea)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(T.x, throwy - 1, 1)
			//var/turf/E = get_step(D, SOUTH)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
				// NOTE: Commenting this out to avoid recreating mass driver glitch
				/*
				spawn(0)
					AM.throw_at(E, 1, 1)
					return
				*/
/*
			if(istype(T, /turf/simulated))
				qdel(T)
*/
		for(var/mob/living/carbon/bug in toArea) // If someone somehow is still in the shuttle's docking area...
			bug.gib()

		for(var/mob/living/simple_animal/pest in toArea) // And for the other kind of bug...
			pest.gib()

		fromArea.move_contents_to(toArea)
		if (church_shuttle_location)
			church_shuttle_location = 0
		else
			church_shuttle_location = 1

		for(var/mob/M in toArea)
			if(M.client)
				spawn(0)
					if(M.buckled)
						shake_camera(M, 3, 1) // buckled, not a lot of shaking
					else
						shake_camera(M, 10, 1) // unbuckled, HOLY SHIT SHAKE THE ROOM
			if(istype(M, /mob/living/carbon))
				if(!M.buckled)
					M.Weaken(3)

		church_shuttle_moving = 0
	return

/obj/machinery/computer/church_shuttle
	name = "shuttle console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "train"
	req_access = null
	circuit = "/obj/item/weapon/circuitboard/church_shuttle"
	var/hacked = 0
	var/location = 1 //0 = station, 1 = mining base

/obj/machinery/computer/church_shuttle/attack_hand(user as mob)
	if(..(user))
		return
	src.add_fingerprint(usr)
	var/dat

	dat = "<center>Train Control<hr>"

	if(church_shuttle_moving)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [church_shuttle_location ? "Outpost" : "Station"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=churchshuttle;size=200x150")

/obj/machinery/computer/church_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["move"])
		//if(ticker.mode.name == "blob")
		//	if(ticker.mode:declared)
		//		usr << "Under directive 7-10, [vessel_name()] is quarantined until further notice."
		//		return

		if (!church_shuttle_moving)
			usr << "\blue Shuttle recieved message and will be sent shortly."
			move_church_shuttle()
		else
			usr << "\blue Shuttle is already moving."

	updateUsrDialog()

/obj/machinery/computer/church_shuttle/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You fried the consoles ID checking system. It's now available to everyone!"

	else if(istype(W, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
			var/obj/item/weapon/circuitboard/church_shuttle/M = new /obj/item/weapon/circuitboard/church_shuttle( A )
			for (var/obj/C in src)
				C.loc = src.loc
			A.circuit = M
			A.anchored = 1

			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				new /obj/item/weapon/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				user << "\blue You disconnect the monitor."
				A.state = 4
				A.icon_state = "4"

			qdel(src)
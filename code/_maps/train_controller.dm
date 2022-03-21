//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

// Controls the emergency shuttle


// these define the time taken for the shuttle to get to SS13
// and the time before it leaves again
#define SHUTTLEARRIVETIME 21		// 10 minutes = 600 seconds
#define SHUTTLELEAVETIME 0		// 3 minutes = 180 seconds
#define SHUTTLETRANSITTIME 21		// 2 minutes = 120 seconds

var/global/datum/train_controller/train_shuttle/train_shuttle

datum/train_controller
	var/alert = 0 //0 = emergency, 1 = crew cycle

	var/location = 0 //0 = somewhere far away (in spess), 1 = at SS13, 2 = returned from SS13
	var/online = 0
	var/direction = 1 //-1 = going back to central command, 1 = going to SS13, 2 = in transit to centcom (not recalled)

	var/endtime			// timeofday that shuttle arrives
	var/timelimit //important when the shuttle gets called for more than shuttlearrivetime
		//timeleft = 360 //600
	var/fake_recall = 0 //Used in rounds to prevent "ON NOES, IT MUST [INSERT ROUND] BECAUSE SHUTTLE CAN'T BE CALLED"

	var/always_fake_recall = 0
	var/deny_shuttle = 0 //for admins not allowing it to be called.
	var/departed = 0
	var/last60 = 0
	// call the shuttle
	// if not called before, set the endtime to T+600 seconds
	// otherwise if outgoing, switch to incoming
	proc/incall(coeff = 1)
		if(deny_shuttle && alert == 1) //crew transfer shuttle does not gets recalled by gamemode
			return
		if(endtime)
			if(direction == -1)
				setdirection(1)
		else
			settimeleft(SHUTTLEARRIVETIME*coeff)
			online = 1
			last60 = timeleft()
			if(always_fake_recall)
				fake_recall = rand(300,500)		//turning on the red lights in hallways
		if(alert == 0)
			for(var/area/A in areas)
				if(istype(A, /area/hallway))
					A.readyalert()

datum/train_controller/proc/shuttlealert(var/X)
		alert = X


datum/train_controller/proc/recall()

	if(direction == 1)
		var/timeleft = timeleft()
		if(alert == 0)
			if(timeleft >= 600)
				return

			world << sound('sound/AI/shuttlerecalled.ogg')
			setdirection(-1)
			online = 1
			for(var/area/A in areas)
				if(istype(A, /area/hallway))
					A.readyreset()
			return
		else //makes it possible to send shuttle back.

			setdirection(-1)
			online = 1
			alert = 0 // set alert back to 0 after an admin recall
			return

	// returns the time (in seconds) before shuttle arrival
	// note if direction = -1, gives a count-up to SHUTTLEARRIVETIME
datum/train_controller/proc/timeleft()
	if(online)
		var/timeleft = round((endtime - world.timeofday)/10 ,1)
		if(direction == 1 || direction == 2)
			return timeleft
		else
			return SHUTTLEARRIVETIME-timeleft
	else
		return SHUTTLEARRIVETIME

	// sets the time left to a given delay (in seconds)
datum/train_controller/proc/settimeleft(var/delay)
	endtime = world.timeofday + delay * 10
	timelimit = delay

	// sets the shuttle direction
	// 1 = towards SS13, -1 = back to centcom
datum/train_controller/proc/setdirection(var/dirn)
	if(direction == dirn)
		return
	direction = dirn
	// if changing direction, flip the timeleft by SHUTTLEARRIVETIME
	var/ticksleft = endtime - world.timeofday
	endtime = world.timeofday + (SHUTTLEARRIVETIME*10 - ticksleft)
	return

datum/train_controller/proc/backtotransit()
	if(location == 2 && direction == 2)
		location = 5
		direction = 2
		departed = 1

					//main shuttle
		var/area/start_location = locate(/area/shuttle/train/fortress)
		var/area/end_location = locate(/area/shuttle/train/transit)

		start_location.move_contents_to(end_location, /turf/simulated/floor/engine/vacuum/hull, NORTH)

		for(var/obj/machinery/door/unpowered/shuttle/D in end_location)
			spawn(0)
			D.locked = 0
			D.open()

		create_lighting_overlays(3)

		for(var/obj/machinery/light/A in end_location)
			var/obj/machinery/light/B = new A.type(A.loc)
			B.dir = A.dir
			B.New()
			B.update()
			B.set_light(B.brightness_range, B.brightness_power, B.brightness_color)
			qdel(A)

		for(var/obj/structure/torchwall/A in end_location)
			var/obj/structure/torchwall/B = new A.type(A.loc)
			B.dir = A.dir
			B.New()
			qdel(A)

		for(var/mob/M in end_location)
			if(M.client)
				M << 'sound/lfwbsounds/train_loop.ogg'
				M << 'trainmusic.ogg'
				spawn(0)
					if(M.buckled)
						shake_camera(M, 4, 1) // buckled, not a lot of shaking
					else
						shake_camera(M, 10, 2) // unbuckled, HOLY SHIT SHAKE THE ROOM
					/*if(istype(M, /mob/living/carbon))
						if(!M.buckled)
							M.Weaken(5)*/

		sleep(210)
		backtostation()


datum/train_controller/proc/backtostation()
	if(location == 5 && direction == 2)
		alert = 0
		departed = 0
		direction = 1
		endtime = null
		last60 = 0
		location = 0
		online = 0
		timelimit = null

					//main shuttle
		var/area/start_location = locate(/area/shuttle/train/transit)
		var/area/end_location = locate(/area/shuttle/train/station)

		start_location.move_contents_to(end_location, /turf/simulated/floor/engine/vacuum/hull, NORTH)

		for(var/obj/machinery/door/unpowered/shuttle/D in end_location)
			spawn(0)
			D.locked = 0
			D.open()

		create_lighting_overlays(3)

		for(var/obj/machinery/light/A in end_location)
			var/obj/machinery/light/B = new A.type(A.loc)
			B.dir = A.dir
			B.New()
			B.update()
			B.set_light(B.brightness_range, B.brightness_power, B.brightness_color)
			qdel(A)

		for(var/obj/structure/torchwall/A in end_location)
			var/obj/structure/torchwall/B = new A.type(A.loc)
			B.dir = A.dir
			B.New()
			qdel(A)

		for(var/mob/M in end_location)
			if(M.client)
				spawn(0)
					if(M.buckled)
						shake_camera(M, 4, 1) // buckled, not a lot of shaking
					else
						shake_camera(M, 10, 2) // unbuckled, HOLY SHIT SHAKE THE ROOM
					/*if(istype(M, /mob/living/carbon))
						if(!M.buckled)
							M.Weaken(5)*/




datum/train_controller/proc/process()

datum/train_controller/train_shuttle/process()
	if(!online)
		return
	var/timeleft = timeleft()

	if(timeleft > 1e5)		// midnight rollover protection
		timeleft = 0
	if((online) && (timeleft() < last60) && (direction == 1))
		if(timeleft > 60)

			world << 'pods_launch_countdown.ogg'
			if(timeleft() - 60 > 60)
				last60 = timeleft() - 60
			else
				last60 = 60
		else if(timeleft > 30)

			world << 'pods_launch_countdown.ogg'
			if(timeleft() - 10 > 10)
				last60 = timeleft() - 10
			else
				last60 = timeleft() - 1
		else
			if(timeleft() > 0)
				if(timeleft() == 3)

					world << 'pods_launch_countdown.ogg'
				else
					if(timeleft() == 0)

						world << 'pods_launched.ogg'
					else


			last60 = timeleft() - 1

	switch(location)
		if(0)

			/* --- Shuttle is in transit to Central Command from SS13 --- */
			if(direction == 2)
				if(timeleft>0)
					return 0

				/* --- Shuttle has arrived at Centrcal Command --- */
				else
					// turn off the star spawners
					/*
					for(var/obj/effect/starspawner/S in areas)
						S.spawning = 0
					*/

					location = 2

					//main shuttle
					var/area/start_location = locate(/area/shuttle/train/transit)
					var/area/end_location = locate(/area/shuttle/train/fortress)

					start_location.move_contents_to(end_location, /turf/simulated/floor/engine/vacuum/hull, NORTH)

					for(var/obj/machinery/door/unpowered/shuttle/D in end_location)
						spawn(0)
							D.locked = 0
							D.open()

					create_lighting_overlays(3)

					for(var/obj/machinery/light/A in end_location)
						var/obj/machinery/light/B = new A.type(A.loc)
						B.dir = A.dir
						B.New()
						B.update()
						B.set_light(B.brightness_range, B.brightness_power, B.brightness_color)
						qdel(A)

					for(var/obj/structure/torchwall/A in end_location)
						var/obj/structure/torchwall/B = new A.type(A.loc)
						B.dir = A.dir
						B.New()
						qdel(A)

					for(var/mob/M in end_location)
						if(M.client)
							spawn(0)
								if(M.buckled)
									shake_camera(M, 4, 1) // buckled, not a lot of shaking
								else
									shake_camera(M, 10, 2) // unbuckled, HOLY SHIT SHAKE THE ROOM
						/*if(istype(M, /mob/living/carbon))
							if(!M.buckled)
								M.Weaken(5)*/


					online = 0



					return 1

					/* --- Shuttle has docked centcom after being recalled --- */
			if(timeleft>timelimit)
				online = 0
				direction = 1
				endtime = null

				return 0

			else if((fake_recall != 0) && (timeleft <= fake_recall))
				recall()
				fake_recall = 0
				return 0

					/* --- Time out, shooting off pods - begin countdown to transit --- */

			else if(timeleft <= 0)

				// Turn on the star effects

				/* // kinda buggy atm, i'll fix this later
				for(var/obj/effect/starspawner/S in areas)
					if(!S.spawning)
						spawn() S.startspawn()
				*/

				departed = 1 // It's going!
				location = 0 // in deep space
				direction = 2 // heading to centcom

				//main shuttle
				var/area/start_location = locate(/area/shuttle/train/station)
				var/area/end_location = locate(/area/shuttle/train/transit)

				settimeleft(SHUTTLETRANSITTIME)
				start_location.move_contents_to(end_location, /turf/simulated/floor/plating/dirt_path, NORTH)

				// Close shuttle doors, lock
				for(var/obj/machinery/door/unpowered/shuttle/D in end_location)
					spawn(0)
						D.close()
						D.locked = 1

				create_lighting_overlays(3)

				for(var/obj/machinery/light/A in end_location)
					var/obj/machinery/light/B = new A.type(A.loc)
					B.dir = A.dir
					B.New()
					B.update()
					B.set_light(B.brightness_range, B.brightness_power, B.brightness_color)
					qdel(A)

				for(var/obj/structure/torchwall/A in end_location)
					var/obj/structure/torchwall/B = new A.type(A.loc)
					B.dir = A.dir
					B.New()
					qdel(A)

							// Some aesthetic turbulance shaking
				for(var/mob/M in end_location)
					if(M.client)
						M << 'sound/lfwbsounds/train_loop.ogg'
						M << 'trainmusic.ogg'
						spawn(0)
							if(M.buckled)
								shake_camera(M, 4, 1) // buckled, not a lot of shaking
							else
								shake_camera(M, 10, 2) // unbuckled, HOLY SHIT SHAKE THE ROOM
					/*if(istype(M, /mob/living/carbon))
						if(!M.buckled)
							M.Weaken(5)*/


				return 1

		else
			// Just before it leaves, close the damn doors!
			if(timeleft == 2 || timeleft == 1)
				var/area/start_location = locate(/area/shuttle/escape/station)
				for(var/obj/machinery/door/unpowered/shuttle/D in start_location)
					spawn(0)
						D.close()
						D.locked = 1
				return 1

			/* --- Shuttle leaves the station, enters transit --- */

			//I've copied it to previos section
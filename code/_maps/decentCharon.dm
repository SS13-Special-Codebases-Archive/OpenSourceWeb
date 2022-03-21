#define FORTRESS 1
#define INTRANSIT 2
#define LEVIATHAN 3

var/shuttleMain = null

/datum/shuttle
	var/list/fortressTurfs = list()
	var/list/intransitTurfs = list()
	var/list/leviathanTurfs = list()

	var/called = 0
	var/timer = 10 MINUTES
	var/moving = 0
	var/location = FORTRESS
	var/launched = 0
	var/lordShip = null

	var/obj/item/device/radio/intercom/INTERCOM = new /obj/item/device/radio/intercom(null)// BS12 EDIT Arrivals Announcement Computer, rather than the AI.

/datum/shuttle/proc/process()
	if(called && !launched)
		timer = max(timer-1 SECONDS, 0)

	if(called && !launched && timer != 0) // i know its gross but i cant do anything about it!!
		switch(timer)
			if(9 MINUTES)
				world << 'pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 9 min. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")
			if(8 MINUTES)
				world << 'pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 8 min. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")
			if(7 MINUTES)
				world << 'pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 7 min. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")
			if(6 MINUTES)
				world << 'pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 6 min. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")
			if(5 MINUTES)
				world << 'pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 5 min. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")
			if(4 MINUTES)
				world << 'pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 4 min. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")
			if(3 MINUTES)
				world << 'pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 3 min. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")
			if(2 MINUTES)
				world << 'pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 2 min. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")
			if(1 MINUTES)
				world << 'pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 1 min. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")
			if(30 SECONDS)
				world << 'pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 30 secs. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")
			if(15 SECONDS)
				world << 'pods_launch_countdown.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 15 secs. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")
			if(5 SECONDS)
				world << 'sound/AI/5.ogg'
				INTERCOM.autosay("The Fortress will be abandoned in T - 5 secs. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")

	if(timer == 0 && !launched)
		world << 'pods_launched.ogg'
		world << 'podsfly.ogg'
		launched = 1
		INTERCOM.autosay("The Babylon has been launched. Firethorn has been abandoned.", "CTTU")
		move()
		spawn(2 MINUTES)
			move()

/datum/shuttle/proc/callshuttle()
	called = 1
	if(!lordShip)
		for(var/mob/living/carbon/human/H in mob_list)
			if(H.job == "Baron")
				var/regex/R = regex("(^\\S+) (.*$)")
				R.Find(H.real_name)
				var/second_name = R.group[2]
				lordShip = second_name
	if(world.time > 60 MINUTES)
		timer = 5 MINUTES
	world << sound('sound/AI/shuttlecalled.ogg')
	to_chat(world, "<span class='passivebold'>Warning: \"Babylon\" will be launched in T - [round(emergency_shuttle.timeleft()/60)] minutes.</span>")
	INTERCOM.autosay("The Fortress will be abandoned in T - 10 min. His Lordship baron [lordShip] and his confidants are awaited on the Babylon.", "CTTU")

/datum/shuttle/proc/recall()
	timer = 10 MINUTES
	called = 0
	world << sound('sound/AI/shuttlerecalled.ogg')
	to_chat(world, "<span class='passivebold'>Warning: The launch was canceled.")

/datum/shuttle/proc/move(var/direction)
	if(moving) return
	moving = 1

	var/Xdiff, Ydiff, Zdiff

	if(location == FORTRESS)
		//TRANSIT
		Xdiff = 1
		Ydiff = 59
		Zdiff = 3
		for(var/obj/effect/star_new/S in stars)
			processing_objects.Add(S)
		for(var/i = 1; i <= fortressTurfs.len; i++)
			var/turf/T = fortressTurfs[i]
			for(var/atom/movable/A in T)
				if(istype(A, /atom/movable/lighting_overlay)) continue
				if(iscarbon(A))
					var/mob/living/carbon/C = A
					shake_camera(C, 10, 1)
					if(C.buckled && istype(C.buckled, /obj/structure/stool/bed/chair/comfy/babylon))
						var/obj/structure/stool/bed/chair/comfy/babylon/B = C.buckled
						if(!B.locked)
							B.unbuckle()
					if(!C.buckled)
						C.visible_message("<span class='warning'>[C.name] is tossed around by the sudden acceleration!</span>")
						var/smashsound = pick("sound/effects/gore/smash[rand(1,3)].ogg", "sound/effects/gore/trauma1.ogg")
						playsound(C, smashsound, 80, 1, -1)
						C.emote("scream")
						C.Stun(5)
						C.Weaken(5)
						step(C,pick(cardinal))//move them
						C.apply_damage(rand(70) , BRUTE)


				A.x = A.x+Xdiff
				A.y = A.y+Ydiff
				A.z = A.z+Zdiff
				A.update_light()
				if(isobj(A) && !istype(A, /obj/structure/elevador) && !A.anchored)
					A.throw_at(get_edge_target_turf(A, pick(alldirs)), 4, 2)
				if(iscarbon(A))
					var/mob/living/carbon/C = A
					if(C.client)
						C.client.update_opacity_image()
				var/turf/intransit = A.loc
				intransitTurfs.Add(intransit)
		moving = 0
		location = INTRANSIT
		return
	if(location == INTRANSIT)
		//LEVIATHAN
		Xdiff = 61
		Ydiff = -46
		Zdiff = 0
		for(var/i = 1; i <= intransitTurfs.len; i++)
			var/turf/T = intransitTurfs[i]
			for(var/atom/movable/A in T)
				if(istype(A, /atom/movable/lighting_overlay)) continue
				if(iscarbon(A))
					var/mob/living/carbon/C = A
					shake_camera(C, 10, 1)
				A.x = A.x+Xdiff
				A.y = A.y+Ydiff
				A.z = A.z+Zdiff
				A.update_light()
				if(isobj(A) && !istype(A, /obj/structure/elevador) && !A.anchored)
					A.throw_at(get_edge_target_turf(A, pick(alldirs)), 4, 2)
				if(iscarbon(A))
					var/mob/living/carbon/C = A
					if(C.client)
						C.client.update_opacity_image()
				var/turf/intransit = A.loc
				leviathanTurfs.Add(intransit)
		moving = 0
		location = LEVIATHAN
		return
	return 0

/mob/verb/changeTimer()
	var/datum/shuttle/elevador = shuttleMain
	elevador.timer = 35 SECONDS

/obj/structure/babylon
	icon = 'icons/life/floors.dmi'
	var/enumeracao = "MainElevator"
	layer = 2.1
	anchored = 1

/obj/structure/babylon/New()
	..()
	if(enumeracao == "MainElevator")
		if(!shuttleMain)
			var/datum/shuttle/E = new
			shuttleMain = E
		var/datum/shuttle/elevador = shuttleMain
		if(isturf(src.loc))
			elevador.fortressTurfs.Add(src.loc)

/obj/structure/babylon/floor
	opacity = 0
	density = 0
/obj/structure/babylon/wall
	icon = 'icons/turf/walls.dmi'
	opacity = 1
	density = 1
	plane = 21
	layer = 5

var/list/stars = list()

/obj/effect/star_new
	icon = 'icons/turf/stars.dmi'
	icon_state = "1"
	layer = 2
/obj/effect/star_new/New()
	..()
	stars.Add(src)
	icon_state = "[rand(1,46)]"
	pixel_x = rand(4, 16)
	pixel_y = rand(4, 16)
/obj/effect/star_new/process()
	animate(src, pixel_y = pixel_y + rand(7,12), time = 21)
	if(prob(40))
		animate(src, alpha=rand(110, 255), time = 20)

#undef FORTRESS
#undef INTRANSIT
#undef LEVIATHAN
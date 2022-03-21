// Areas.dm
#define CLOSED 2


// ===
/area
	var/global/global_uid = 0
	var/uid
	var/area_lights_luminosity = 9
	var/musVolume = 25
	var/sound = null
	var/hasownamb = FALSE
	var/hum = FALSE
	var/ambience_vol = 30
	var/hassnow = FALSE
	var/playingambi = FALSE
	var/coldbreathing = FALSE
	var/list/webItems = list()
	var/sound_env = STANDARD_STATION
	plane = 300


/obj/screen/snowfog
	icon = 'icons/fog.dmi'
	icon_state =" "
	layer = TURF_LAYER+4
	mouse_opacity = 0

var/list/areas = list()

/area/New()
	icon_state = ""
	layer = 10
	master = src //moved outside the spawn(1) to avoid runtimes in lighting.dm when it references loc.loc.master ~Carn
	uid = ++global_uid
	if(requires_power)
		active_areas += src
	areas.Add(src)
	spawn(1)
	//world.log << "New: [src] [tag]"
		related = list(src)

		src.icon = 'alert.dmi'
		src.layer = 10
	//	update_lights()
		if(name == "Space")			// override defaults for space
			requires_power = 1
			always_unpowered = 1
			power_light = 0
			power_equip = 0
			power_environ = 0
			//has_gravity = 0    // Space has gravity.  Because.. because.

		if(!requires_power)
			power_light = 0//rastaf0
			power_equip = 0//rastaf0
			power_environ = 0//rastaf0
		else
			luminosity = 0
			area_lights_luminosity = rand(6,8)
/*
		if(hassnow)
			for(var/turf/simulated/floor/D in src)
				//D.underlays += image(icon='icons/fog.dmi',icon_state ="3",layer =MOB_LAYER+1)
				D.overlays += /obj/screen/snowfog
*/

/area/proc/poweralert(var/state, var/obj/source as obj)
	if (state != poweralm)
		poweralm = state
		if(istype(source))	//Only report power alarms on the z-level where the source is located.
			var/list/cameras = list()
			for (var/area/RA in related)
				for (var/obj/machinery/camera/C in RA)
					cameras += C
					if(state == 1)
						C.network.Remove("Power Alarms")
					else
						C.network.Add("Power Alarms")
			for (var/mob/living/silicon/aiPlayer in player_list)
				if(aiPlayer.z == source.z)
					if (state == 1)
						aiPlayer.cancelAlarm("Power", src, source)
					else
						aiPlayer.triggerAlarm("Power", src, cameras, source)
			for(var/obj/machinery/computer/station_alert/a in machines)
				if(a.z == source.z)
					if(state == 1)
						a.cancelAlarm("Power", src, source)
					else
						a.triggerAlarm("Power", src, cameras, source)
	return

/area/proc/atmosalert(danger_level)
//	if(type==/area) //No atmos alarms in space
//		return 0 //redudant
	if(danger_level != atmosalm)
		//updateicon()
		//mouse_opacity = 0
		if (danger_level==2)
			var/list/cameras = list()
			for(var/area/RA in related)
				//updateicon()
				for(var/obj/machinery/camera/C in RA)
					cameras += C
					C.network.Add("Atmosphere Alarms")
			for(var/mob/living/silicon/aiPlayer in player_list)
				aiPlayer.triggerAlarm("Atmosphere", src, cameras, src)
			for(var/obj/machinery/computer/station_alert/a in machines)
				a.triggerAlarm("Atmosphere", src, cameras, src)
		else if (atmosalm == 2)
			for(var/area/RA in related)
				for(var/obj/machinery/camera/C in RA)
					C.network.Remove("Atmosphere Alarms")
			for(var/mob/living/silicon/aiPlayer in player_list)
				aiPlayer.cancelAlarm("Atmosphere", src, src)
			for(var/obj/machinery/computer/station_alert/a in machines)
				a.cancelAlarm("Atmosphere", src, src)
		atmosalm = danger_level
		return 1
	return 0

/area/proc/firealert()
	if(name == "Space") //no fire alarms in space
		return
	if( !fire )
		fire = 1
		master.fire = 1		//used for firedoor checks
		updateicon()
		mouse_opacity = 0
		for(var/obj/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = CLOSED
				else if(!D.density)
					spawn()
						D.close()
		var/list/cameras = list()
		for(var/area/RA in related)
			for (var/obj/machinery/camera/C in RA)
				cameras.Add(C)
				C.network.Add("Fire Alarms")
		for (var/mob/living/silicon/ai/aiPlayer in player_list)
			aiPlayer.triggerAlarm("Fire", src, cameras, src)
		for (var/obj/machinery/computer/station_alert/a in machines)
			a.triggerAlarm("Fire", src, cameras, src)

/area/proc/firereset()
	if (fire)
		fire = 0
		master.fire = 0		//used for firedoor checks
		mouse_opacity = 0
		updateicon()
		for(var/obj/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = OPEN
				else if(D.density)
					spawn(0)
					D.open()
		for(var/area/RA in related)
			for (var/obj/machinery/camera/C in RA)
				C.network.Remove("Fire Alarms")
		for (var/mob/living/silicon/ai/aiPlayer in player_list)
			aiPlayer.cancelAlarm("Fire", src, src)
		for (var/obj/machinery/computer/station_alert/a in machines)
			a.cancelAlarm("Fire", src, src)

/area/proc/readyalert()
	if(name == "Space")
		return
	if(!eject)
		eject = 1
		updateicon()
	return

/area/proc/readyreset()
	if(eject)
		eject = 0
		updateicon()
	return

/area/proc/partyalert()
	if(name == "Space") //no parties in space!!!
		return
	if (!( party ))
		party = 1
		updateicon()
		mouse_opacity = 0
	return

/area/proc/partyreset()
	if (party)
		party = 0
		mouse_opacity = 0
		updateicon()
		for(var/obj/machinery/door/firedoor/D in src)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = OPEN
				else if(D.density)
					spawn(0)
					D.open()
	return

/area/proc/updateicon()
	if ((fire || eject || party) && ((!requires_power)?(!requires_power):power_environ))//If it doesn't require power, can still activate this proc.
		if(fire && !eject && !party)
			icon_state = "blue"
		else if(atmosalm && !fire && !eject && !party)
			icon_state = "bluenew"
		else if(!fire && eject && !party)
			icon_state = "red"
		else if(party && !fire && !eject)
			icon_state = "party"
		else
			icon_state = "blue-red"
	else
	//	new lighting behaviour with obj lights
		icon_state = null


/*
#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
*/

/area/proc/powered(var/chan)		// return true if the area has power to given channel

	if(!master.requires_power)
		return 1
	if(master.always_unpowered)
		return 0
	switch(chan)
		if(EQUIP)
			return master.power_equip
		if(LIGHT)
			return master.power_light
		if(ENVIRON)
			return master.power_environ

	return 0

// called when power status changes

/area/proc/power_change()
	master.powerupdate = 2
	for(var/area/RA in related)
		for(var/obj/machinery/M in RA)	// for each machine in the area
			M.power_change()				// reverify power status (to update icons etc.)
		if (fire || eject || party)
			RA.updateicon()

/area/proc/usage(var/chan)
	var/used = 0
	switch(chan)
		if(LIGHT)
			used += master.used_light
		if(EQUIP)
			used += master.used_equip
		if(ENVIRON)
			used += master.used_environ
		if(TOTAL)
			used += master.used_light + master.used_equip + master.used_environ

	return used

/area/proc/clear_usage()

	master.used_equip = 0
	master.used_light = 0
	master.used_environ = 0

/area/proc/use_power(var/amount, var/chan)

	switch(chan)
		if(EQUIP)
			master.used_equip += amount
		if(LIGHT)
			master.used_light += amount
		if(ENVIRON)
			master.used_environ += amount


/area/Entered(A)

	if(!istype(A,/mob/living))	return

	var/mob/living/L = A
	var/mob/living/carbon/human/H = A
	if(!L.ckey)	return
	if(ghost_safe)
		if(istype(A,/mob/dead/observer))
			var/mob/dead/observer/O = A
			O.forceMove(locate(68,28,5))
			return

	if(coldbreathing)
		H.add_coldbreath()
	if(H.job == "Sheriff")
		if(istype(src, /area/dunwell/station))
			H.add_event("sheriff", /datum/happiness_event/misc/sheriff)
		else
			H.clear_event("sheriff")

	// Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(!(L && L.client && (L.client.prefs.toggles & SOUND_AMBIENCE)))	return


	if(master_mode == "holywar")
		if(!L.client.ambience_playing)
			L.client.ambience_playing = 1
			L << sound('war.ogg', repeat=1, wait=0, channel=9, 65)

	else

		var/list/sounds_list = L.client.SoundQuery()
		var/list/final = list()
		var/list/final2 = forced_ambience // quem vem
		for(var/playing_sound in sounds_list)
			var/sound/found = playing_sound
			final += found.file

		if(final in final2)
			return
		else
			if(is_dreamer(L))
				L.client.ambience_playing = 1
				var/sound/S = sound('sound/lfwbcombatuse/dreamer_is_still_asleep.ogg', repeat=1, wait=0, channel=9, volume=L?.client?.prefs?.ambi_volume)
				L << S
			else
				var/list/sounds_liste = L.client.SoundQuery()
				var/list/finale = list()
				var/list/finale2 = forced_ambience // quem vem
				for(var/playing_sound in sounds_liste)
					var/sound/found = playing_sound
					finale += found.file

				if(!finale.len)
					var/sound/S = sound(pick(finale2), repeat=1, wait=0, channel=9, volume=L?.client?.prefs?.ambi_volume)
					src << S
				for(var/i = 1; i <= finale2?.len; i++)
					var/coisas = forced_ambience[i]
					if(coisas in L?.lastarea?.forced_ambience)
						return

				L.lastarea = src

				for(var/playing_sound in sounds_liste)
					var/sound/found = playing_sound
					if(found.channel == 9)
						var/sound/S = sound(null, channel=9)
						L << S
						var/sound/SS = sound(pick(finale2), repeat=1, wait=0, channel=9, volume=L?.client?.prefs?.ambi_volume)
						L << SS


//	play_ambience(L)
	if(prob(35))
		L << sound(pick('sound/lfwbambi/room_enter1.ogg','sound/lfwbambi/room_enter2.ogg','sound/lfwbambi/room_enter3.ogg','sound/lfwbambi/room_enter4.ogg','sound/lfwbambi/room_enter5.ogg'), repeat = 0, wait = 1, volume = L?.client?.prefs?.ambi_volume, channel = 25)
	if(prob(25))
		if(istype(src, /area/dunwell/station/church))
			L << sound(pick('sound/lfwbambi/church.ogg','sound/lfwbambi/amb34.ogg'), repeat = 0, wait = 1, volume = L?.client?.prefs?.ambi_volume, channel = 25)
		else if(istype(src, /area/dunwell/station/cerberon))
			L << sound(pick('sound/lfwbambi/cerberon.ogg'), repeat = 0, wait = 1, volume = L?.client?.prefs?.ambi_volume, channel = 25)
		else if(istype(src, /area/dunwell/surface))
			L << sound(pick('sound/lfwbambi/ambimo2.ogg','sound/lfwbambi/ambicha1.ogg'), repeat = 0, wait = 1, volume = L?.client?.prefs?.ambi_volume, channel = 25)
			if(prob(50))
				L << sound(pick('cavedrip1.ogg','cavedrip2.ogg','cavedrip3.ogg','cavedrip4.ogg','cavedrip5.ogg','cavedrip6.ogg','cavedrip7.ogg','cavedrip8.ogg'), repeat = 0, wait = 1, volume = L?.client?.prefs?.ambi_volume, channel = 25)
		else if(istype(src, /area/dunwell/station))
			L << sound(pick('sound/lfwbambi/ambigen6.ogg','sound/lfwbambi/ambigen13.ogg'), repeat = 0, wait = 1, volume = L?.client?.prefs?.ambi_volume, channel = 25)
		else
			L << sound(pick('amb1.ogg','amb2.ogg','amb3.ogg','amb4.ogg','amb5.ogg','amb6.ogg','amb7.ogg','amb8.ogg','amb9.ogg','amb10.ogg','amb11.ogg','amb12.ogg',
			'amb13.ogg','amb14.ogg','amb15.ogg','amb16.ogg','amb17.ogg','amb18.ogg','amb19.ogg','amb20.ogg','amb21.ogg','amb22.ogg','amb23.ogg','amb24.ogg','amb25.ogg',
			'amb26.ogg','amb27.ogg','amb28.ogg','amb30.ogg','amb31.ogg','amb32.ogg','amb33.ogg','amb34.ogg','amb35.ogg','amb36.ogg','amb37.ogg','amb38.ogg','amb39.ogg',
			'amb40.ogg'), repeat = 0, wait = 1, volume = L?.client?.prefs?.ambi_volume, channel = 25)
/*
		if(istype(src, /area/dunwell/station/church))
			sound = pick('sound/lfwbambi/church.ogg','sound/lfwbambi/amb34.ogg')
		else if(istype(src, /area/dunwell/station/medbay))
			sound = pick('sound/lfwbambi/amb40.ogg','sound/lfwbambi/amb39.ogg','sound/lfwbambi/amb37.ogg')
		else if(type == /area)
			sound = pick('sound/lfwbambi/amb26.ogg','sound/lfwbambi/amb25.ogg','sound/lfwbambi/amb24.ogg')
		else if(istype(src, /area/dunwell/station/gates))
			sound = pick('sound/lfwbambi/amb38.ogg','sound/lfwbambi/amb36.ogg','sound/lfwbambi/amb35.ogg','sound/lfwbambi/amb33.ogg','sound/lfwbambi/amb32.ogg','sound/lfwbambi/hostile_space.ogg')
		else if(istype(src, /area/dunwell/surface) || istype(src, /area/dunwell/caves))
			sound = pick('sound/lfwbambi/amb12.ogg', 'sound/lfwbambi/amb13.ogg','sound/lfwbambi/amb11.ogg','sound/lfwbambi/amb10.ogg','sound/lfwbambi/amb8.ogg','sound/lfwbambi/amb30.ogg','sound/lfwbambi/amb28.ogg','sound/lfwbambi/amb27.ogg')
			musVolume = 25
		else if (istype(src, /area/dunwell/station/gates))
			sound = pick('sound/lfwbambi/amb38.ogg','sound/lfwbambi/amb13.ogg','sound/lfwbambi/amb18.ogg','sound/lfwbambi/amb17.ogg','sound/lfwbambi/loop_pendulum.ogg','sound/lfwbambi/amb15.ogg','sound/lfwbambi/amb36.ogg','sound/lfwbambi/amb35.ogg','sound/lfwbambi/amb33.ogg','sound/lfwbambi/amb32.ogg')

		else if (istype(src, /area/dunwell/station) || istype(src, /area/dunwell/station/miser) || istype(src, /area/dunwell/station/harbor))
			sound = pick('sound/lfwbambi/amb38.ogg','sound/lfwbambi/amb13.ogg','sound/lfwbambi/amb18.ogg','sound/lfwbambi/amb17.ogg','sound/lfwbambi/amb17.ogg','sound/lfwbambi/amb15.ogg','sound/lfwbambi/amb36.ogg','sound/lfwbambi/amb35.ogg','sound/lfwbambi/amb33.ogg','sound/lfwbambi/amb32.ogg')
		else if(istype(src, /area/tcommsat) || istype(src, /area/turret_protected/tcomwest) || istype(src, /area/turret_protected/tcomeast) || istype(src, /area/turret_protected/tcomfoyer) || istype(src, /area/turret_protected/tcomsat))
			sound = pick('sound/lfwbambi/amb38.ogg','sound/lfwbambi/amb36.ogg','sound/lfwbambi/amb35.ogg','sound/lfwbambi/amb33.ogg','sound/lfwbambi/amb32.ogg')
		else
			sound = pick('sound/lfwbambi/amb38.ogg','sound/lfwbambi/amb36.ogg','sound/lfwbambi/amb35.ogg','sound/lfwbambi/amb33.ogg','sound/lfwbambi/amb32.ogg')
*/
/*
	play_ambience(L)

/area/proc/play_ambience(var/mob/living/L)
	// Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(!(L && L.client && (L.client.prefs.toggles & SOUND_AMBIENCE)))	return

	if(src.forced_ambience)
		if(single_ambience == TRUE)
			if(!L.client.ambience_playing)
				L.client.ambience_playing = 1
				L << sound(forced_ambience, repeat = 1, wait = 0, volume = ambience_vol, channel = 2)
				L.client.ambience_playing = 0
		else
			if(!L.client.ambience_playing)
				L.client.ambience_playing = 1
				L << sound(pick(forced_ambience), repeat = 1, wait = 0, volume = ambience_vol, channel = 2)
				L.client.ambience_playing = 0
	else	//stop any old area's forced ambience, and try to play our non-forced ones
		if(L.client.ambience_playing == 1)
			L << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
/*
	if(L.lastarea != src)
		if(src.forced_ambience)
			L << sound(forced_ambience, repeat = 1, wait = 0, volume = 25, channel = 2)
		else	//stop any old area's forced ambience, and try to play our non-forced ones
			L << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
*/
*/
/area/proc/play_ambience(var/mob/living/L)
	// Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	var/turf/T = get_turf(L)
	if(!L.client.ambience_playing)
		L.client.ambience_playing = 1
		L.playsound_local(T,sound(pick(forced_ambience), repeat = 1, wait = 0, volume = L?.client?.prefs?.ambi_volume, channel = 12))
	else
		L.client.ambience_playing = 0
		sound_to(L, sound(null, channel = 12))

	if(L.lastarea != src)
		if(forced_ambience)
			forced_ambience |= L
			L.playsound_local(T,sound(pick(forced_ambience), repeat = 1, wait = 0, volume = L?.client?.prefs?.ambi_volume, channel = 12))
		else	//stop any old area's forced ambience, and try to play our non-forced ones
			sound_to(L, sound(null, channel = 12))
			forced_ambience -= L

/area/proc/activate_air_doors(stayclosed)
	if(src.name == "Space") //no atmo alarms in space
		return
	if (!src.air_doors_activated)			//Edited by Strumpetplaya - Removed "( ) && !air_door_close_delay" from If Statement.
		if(stayclosed)
			air_door_close_delay = 1
			spawn(stayclosed*10)
				air_door_close_delay = 0
		src.air_doors_activated = 1
		//src.update_icon()					//Commented by Strumpetplaya - Alarm Change, not necessary.
		src.mouse_opacity = 0
	//	if(!alldoors)
		//	alldoors = get_doors(src)
		for(var/obj/machinery/door/airlock/D in all_doors)
			if((!D.arePowerSystemsOn()) || (D.stat & NOPOWER)) continue
			if(!D.density)
				spawn(0)
				D.close()
				sleep(10)
				if(D.density)
					D.locked = 1
					D.air_locked = 1
					D.update_icon()
			if(D.operating)
				spawn(10)
					D.close()
					//spawn(10)
					if(D.density)
						D.locked = 1
						D.air_locked = 1
						D.update_icon()
			else if(!D.locked) //Don't lock already bolted doors.
				D.locked = 1
				D.air_locked = 1
				D.update_icon()
		if(!fire)
			for(var/obj/machinery/door/firedoor/D in all_doors)
				if(!D.blocked)
					if(D.operating)
						D.nextstate = CLOSED
					else if(!D.density)
						spawn(0)
						D.close()

			//else
			//	D.air_locked = 0 //Ensure we're getting the right doors here.
		var/list/cameras = list()
		for (var/obj/machinery/camera/C in src)
			cameras += C
		for (var/mob/living/silicon/ai/aiPlayer in world)
			aiPlayer.triggerAlarm("Atmosphere", src, cameras, src)
		for (var/obj/machinery/computer/atmos_alert/a in world)
			a.triggerAlarm("Atmosphere", src, cameras, src)
			//deactivate_air_doors()
	return




/area/proc/deactivate_air_doors(stayopen)
	if (src.air_doors_activated)			//Edited by Strumpetplaya - Removed " && !air_door_close_delay" from If statement.
		if(stayopen)
			air_door_close_delay = 1
			spawn(stayopen*10)
				air_door_close_delay = 0
		src.air_doors_activated = 0
		src.mouse_opacity = 0
		src.updateicon()
	//	if(!alldoors)
		//	alldoors = get_doors(src)
		for(var/obj/machinery/door/airlock/D in src)
			var/AName = src.name
			var/turf/ANorth = locate(D.x,D.y+1,D.z)
			var/area/ANorthA = ANorth.loc
			var/turf/AEast = locate(D.x+1,D.y,D.z)
			var/area/AEastA = AEast.loc
			var/turf/ASouth = locate(D.x,D.y-1,D.z)
			var/area/ASouthA = ASouth.loc
			var/turf/AWest = locate(D.x-1,D.y,D.z)
			var/area/AWestA = AWest.loc

			//world << "If [ANorth.name] density ([ANorth.density]) != and [ANorthA.name] != [AName] then open the damn door."
			if(ANorth.density != 1 && ANorthA.name != AName)
				if(ANorthA.air_doors_activated != 1)
					if((!D.arePowerSystemsOn()) || (D.stat & NOPOWER)) continue
						//D.air_locked = 0
					if(D.air_locked) //Don't mess with doors locked for other reasons.
						if(D.density)
							D.locked = 0
							D.air_locked =0
							D.update_icon()
							//world << "opened North"
				if(ANorthA.air_doors_activated == 1)
					var/obj/LightTest = locate(/obj/effect/alertlighting/atmoslight) in D.loc
					if(isnull(LightTest))
						var/obj/effect/alertlighting/atmoslight/F = new/obj/effect/alertlighting/atmoslight(D.loc)
						var/image/imagelight = image('alert.dmi',F,icon_state = "blueold")
						world << imagelight

			else if(AEast.density != 1 && AEastA.name != AName)
				if(AEastA.air_doors_activated != 1)
					if((!D.arePowerSystemsOn()) || (D.stat & NOPOWER)) continue
						//D.air_locked = 0
					if(D.air_locked) //Don't mess with doors locked for other reasons.
						if(D.density)
							D.locked = 0
							D.air_locked =0
							D.update_icon()
							//world << "opened East"
				if(AEastA.air_doors_activated == 1)
					var/obj/LightTest = locate(/obj/effect/alertlighting/atmoslight) in D.loc
					if(isnull(LightTest))
						var/obj/effect/alertlighting/atmoslight/F = new/obj/effect/alertlighting/atmoslight(D.loc)
						var/image/imagelight = image('alert.dmi',F,icon_state = "blueold")
						world << imagelight
						//world << "Image should be placed"

			else if(ASouth.density != 1 && ASouthA.name != AName)
				if(ASouthA.air_doors_activated != 1)
					if((!D.arePowerSystemsOn()) || (D.stat & NOPOWER)) continue
						//D.air_locked = 0
					if(D.air_locked) //Don't mess with doors locked for other reasons.
						if(D.density)
							D.locked = 0
							D.air_locked =0
							D.update_icon()
							//world << "opened South"
				if(ASouthA.air_doors_activated == 1)
					var/obj/LightTest = locate(/obj/effect/alertlighting/atmoslight) in D.loc
					if(isnull(LightTest))
						var/obj/effect/alertlighting/atmoslight/F = new/obj/effect/alertlighting/atmoslight(D.loc)
						var/image/imagelight = image('alert.dmi',F,icon_state = "blueold")
						world << imagelight

			else if(AWest.density != 1 && AWestA.name != AName)
				if(AWestA.air_doors_activated != 1)
					if((!D.arePowerSystemsOn()) || (D.stat & NOPOWER)) continue
						//D.air_locked = 0
					if(D.air_locked) //Don't mess with doors locked for other reasons.
						if(D.density)
							D.locked = 0
							D.air_locked =0
							D.update_icon()
							//world << "opened West"
				if(AWestA.air_doors_activated == 1)
					var/obj/LightTest = locate(/obj/effect/alertlighting/atmoslight) in D.loc
					if(isnull(LightTest))
						var/obj/effect/alertlighting/atmoslight/F = new/obj/effect/alertlighting/atmoslight(D.loc)
						var/image/imagelight = image('alert.dmi',F,icon_state = "blueold")
						world << imagelight
			else
				if(src.air_doors_activated != 1)
					if((!D.arePowerSystemsOn()) || (D.stat & NOPOWER)) continue
						//D.air_locked = 0
					if(D.air_locked) //Don't mess with doors locked for other reasons.
						if(D.density)
							D.locked = 0
							D.air_locked =0
							D.update_icon()
/*	COMMENTED OUT BY STRUMPETPLAYA - ALARM GCHANGE
		for(var/obj/machinery/door/airlock/D in alldoors)
			if((!D.arePowerSystemsOn()) || (D.stat & NOPOWER)) continue
				//D.air_locked = 0
			if(D.air_locked) //Don't mess with doors locked for other reasons.
				if(D.density)
					D.locked = 0
					D.air_locked =0
					D.update_icon()
*/
		if(!fire)
			for(var/obj/machinery/door/firedoor/D in all_doors)
				if(!D.blocked)
					if(D.operating)
						D.nextstate = OPEN
					else if(D.density)
						spawn(0)
						D.open()
		for (var/mob/living/silicon/ai/aiPlayer in world)
			aiPlayer.cancelAlarm("Atmosphere", src, src)
		for (var/obj/machinery/computer/atmos_alert/a in world)
			a.cancelAlarm("Atmosphere", src, src)
	return

proc/get_doors(area/A) //Luckily for the CPU, this generally is only run once per area.
	. = list()
	for(var/area/AR in A.related)
		for(var/obj/machinery/door/D in AR)
			. += D


			//If at least one area that is different from this one is found, execute the rest of this code.
			/*var/area/B
			for(B in orange(T,1))
				if(B != A && !(B in A.related))
					break
			if(!B) continue
			var/list/z_doors_list = list()
			for(var/obj/machinery/door/D in T)
				z_doors_list += D
				z_doors_list[D] = D.density
				D.density = 0
			for(var/turf/X in T.GetBasicCardinals())
				if(X.loc == A || (X.loc in A.related)) continue //Don't bother with turfs already in the area.
				var/list/doors_list = list()
				for(var/obj/machinery/door/O in X)
					if(istype(O,/obj/machinery/door/firedoor))
						var/obj/machinery/door/airlock/maintenance/M = locate() in X
						if(M)
							continue
					doors_list += O
					doors_list[O] = O.density
					O.density = 0
				if(!T.CanPass(null,X,0,0))
					for(var/obj/machinery/door/O in doors_list)
						O.density = doors_list[O]
					continue
				for(var/obj/machinery/door/O in doors_list)
					. += O
					O.density = doors_list[O]*/
			//for(var/obj/machinery/door/D in T)
			//	D.density = z_doors_list[D]

/proc/has_gravity(atom/AT, turf/T)
	if(!T)
		T = get_turf(AT)
	var/area/A = get_area(T)
	if(istype(T, /turf/space)) // Turf never has gravity
		return 0
	else if(A && A.has_gravity) // Areas which always has gravity
		return 1
	else
		// There's a gravity generator on our z level
		if(T && gravity_generators["[T.z]"] && length(gravity_generators["[T.z]"]))
			return 1
	return 0
#define GENERIC 0
#define PADDED_CELL 1
#define ROOM 2
#define BATHROOM 3
#define LIVINGROOM 4
#define STONEROOM 5
#define AUDITORIUM 6
#define CONCERT_HALL 7
#define CAVE 8
#define ARENA 9
#define HANGAR 10
#define CARPETED_HALLWAY 11
#define HALLWAY 12
#define STONE_CORRIDOR 13
#define ALLEY 14
#define FOREST 15
#define CITY 16
#define MOUNTAINS 17
#define QUARRY 18
#define PLAIN 19
#define PARKING_LOT 20
#define SEWER_PIPE 21
#define UNDERWATER 22
#define DRUGGED 23
#define DIZZY 24
#define PSYCHOTIC 25

#define STANDARD_STATION STONEROOM
#define LARGE_ENCLOSED HANGAR
#define SMALL_ENCLOSED BATHROOM
#define TUNNEL_ENCLOSED CAVE
#define LARGE_SOFTFLOOR CARPETED_HALLWAY
#define MEDIUM_SOFTFLOOR LIVINGROOM
#define SMALL_SOFTFLOOR ROOM
#define ASTEROID CAVE
#define SPACE UNDERWATER

/proc/playsound(var/atom/source, soundin, vol as num, vary, extrarange as num, falloff, var/is_global, var/frequency, var/wait=0, var/repeat=0, var/channel = 0)

	soundin = get_sfx(soundin) // same sound for everyone

	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return

	frequency = isnull(frequency) ? get_rand_frequency() : frequency // Same frequency for everybody
	var/turf/turf_source = get_turf(source)

 	// Looping through the player list has the added bonus of working for mobs inside containers
	for (var/P in player_list)
		var/mob/M = P
		if(!M || !M.client)
			continue
		if(get_dist(M, turf_source) <= (world.view + extrarange) * 2)
			var/turf/T = get_turf(M)
			if(T && T.z == turf_source.z)
				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, is_global)
			var/z_dist = abs(T.z - turf_source.z)//Playing sound on a z-level above or below you.
			if(T && z_dist <= 1)
				M.playsound_local(turf_source, soundin, vol/(1+z_dist), vary, frequency, falloff, is_global, channel, wait, repeat)

var/const/FALLOFF_SOUNDS = 0.5


/mob/proc/playsound_local(var/turf/turf_source, soundin, vol as num, vary, frequency, falloff, is_global, channel=0, wait=0, repeat=0)
	if(!src.client || ear_deaf > 0)	return
	var/sound/S = soundin
	if(!istype(S))
		soundin = get_sfx(soundin)
		S = sound(soundin)
		S.wait = wait //No queue
		S.repeat = repeat
		S.channel = 0 //Any channel
		S.volume = vol
		S.environment = -1
		if (vary)
			if(frequency)
				S.frequency = frequency
			else
				S.frequency = get_rand_frequency()

	//sound volume falloff with pressure
	var/pressure_factor = 1.0

	if(isturf(turf_source))
		// 3D sounds, the technology is here!
		var/turf/T = get_turf(src)

		//sound volume falloff with distance
		var/distance = get_dist(T, turf_source)

		S.volume -= max(distance - world.view, 0) * 2 //multiplicative falloff to add on top of natural audio falloff.

		var/datum/gas_mixture/hearer_env = T.return_air()
		var/datum/gas_mixture/source_env = turf_source.return_air()

		if (hearer_env && source_env)
			var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())

			if (pressure < ONE_ATMOSPHERE)
				pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
		else //in space
			pressure_factor = 0

		if (distance <= 1)
			pressure_factor = max(pressure_factor, 0.15)	//hearing through contact

		S.volume *= pressure_factor

		if (S.volume <= 0)
			return	//no volume means no sound

		var/dx = turf_source.x - T.x // Hearing from the right/left
		S.x = dx
		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = dz
		// The y value is for above your head, but there is no ceiling in 2d spessmens.
		S.y = 1
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

	if(!is_global)

		if(istype(src,/mob/living/))
			var/mob/living/M = src
			if (M.hallucination)
				S.environment = PSYCHOTIC
			else if (M.druggy)
				S.environment = DRUGGED
			else if (M.drowsyness)
				S.environment = DIZZY
			else if (M.confused)
				S.environment = DIZZY
			else if (M.sleeping)
				S.environment = UNDERWATER
			else if (pressure_factor < 0.5)
				S.environment = SPACE
			else
				S.environment = 0

		else if (pressure_factor < 0.5)
			S.environment = SPACE
		else
			var/area/A = get_area(src)
			S.environment = A.sound_env

	src << S


/client/proc/playtitlemusic()
	if(!global.login_music) return
	if(prefs.toggles & SOUND_LOBBY)
		src << sound(global.login_music, repeat = 1, wait = 0, volume = prefs?.music_volume, channel = 1) // MAD JAMS


/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg')
			if ("explosion") soundin = pick('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg','sound/effects/Explosion3.ogg','sound/effects/Explosion4.ogg','sound/effects/Explosion5.ogg','sound/effects/Explosion6.ogg')
			if ("sparks") soundin = pick('sound/effects/electr1.ogg','sound/effects/electr2.ogg','sound/effects/electr3.ogg')
			if ("rustle") soundin = pick('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
			if ("punch") soundin = pick('sound/weapons/npc_kill_melee_01.ogg','sound/weapons/npc_kill_melee_02.ogg','npc_kill_melee_03.ogg')
			if ("footsteps_metal") soundin = pick('sound/effects/player/boots_run_metal_1.ogg','sound/effects/player/boots_run_metal_2.ogg','sound/effects/player/boots_run_metal_3.ogg','sound/effects/player/boots_run_metal_4.ogg')
			if ("footsteps_carpet") soundin = pick('sound/effects/player/cr_step1.ogg','sound/effects/player/cr_step2.ogg','sound/effects/player/cr_step3.ogg','sound/effects/player/cr_step4.ogg')
			if ("footsteps_wood") soundin = pick('sound/effects/player/wf_step1.ogg','sound/effects/player/wf_step2.ogg','sound/effects/player/wf_step3.ogg','sound/effects/player/wf_step4.ogg')
			if ("footsteps_magboots") soundin = pick('sound/effects/player/power_metal_1.ogg','sound/effects/player/power_metal_2.ogg','sound/effects/player/power_metal_3.ogg','sound/effects/player/power_metal_4.ogg')
			if ("clownstep") soundin = pick('sound/effects/footsteps/jester_big.ogg','sound/effects/footsteps/jester_big2.ogg','sound/effects/footsteps/jester_small.ogg','sound/effects/footsteps/jester_small2.ogg','sound/effects/footsteps/jester_small3.ogg','sound/effects/footsteps/jester_small4.ogg')
			if ("swing_hit") soundin = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			if ("hiss") soundin = pick('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
			if ("pageturn") soundin = pick('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
			if ("footsteps_water") soundin = pick('sound/effects/footsteps/step_water1.ogg','sound/effects/footsteps/step_water2.ogg','sound/effects/footsteps/step_water3.ogg','sound/effects/footsteps/step_water4.ogg')
			if ("swimwater") soundin = pick('water_med1.ogg','water_med2.ogg')
			if ("gunshot") soundin = pick('sound/weapons/Gunshot.ogg', 'sound/weapons/Gunshot2.ogg', 'sound/weapons/Gunshot3.ogg', 'sound/weapons/Gunshot4.ogg')
			if ("bodyfall") soundin = pick('sound/effects/bodyfall1.ogg', 'sound/effects/bodyfall2.ogg')
			if ("erikafootsteps") soundin = pick('sound/effects/footsteps/FTMET1.ogg', 'sound/effects/footsteps/FTMET2.ogg', 'sound/effects/footsteps/FTMET3.ogg', 'sound/effects/footsteps/FTMET4.ogg')
			if ("footsteps_snow") soundin = pick('sound/effects/footsteps/snowstep1.ogg', 'sound/effects/footsteps/snowstep2.ogg', 'sound/effects/footsteps/snowstep3.ogg', 'sound/effects/footsteps/snowstep4.ogg')
			if ("radio") soundin = pick('sound/lfwbsounds/radio_chatter.ogg')
			if ("revolver") soundin = pick('sound/weapons/revolver1.ogg', 'sound/weapons/revolver2.ogg')
			if ("pistol") soundin = pick('sound/weapons/pistoln1.ogg', 'sound/weapons/pistoln2.ogg')
			if ("dirtfootsteps") soundin = pick('sound/effects/footsteps/step_g1.ogg', 'sound/effects/footsteps/step_g2.ogg', 'sound/effects/footsteps/step_g3.ogg', 'sound/effects/footsteps/step_g4.ogg')
			if ("stonesound") soundin = pick('sound/effects/footsteps/step1.ogg', 'sound/effects/footsteps/step2.ogg', 'sound/effects/footsteps/step3.ogg', 'sound/effects/footsteps/step4.ogg')
			if ("metalzao") soundin = pick('sound/effects/footsteps/grate1.ogg','sound/effects/footsteps/grate2.ogg','sound/effects/footsteps/grate3.ogg','sound/effects/footsteps/grate4.ogg','sound/effects/footsteps/grate5.ogg','sound/effects/footsteps/grate6.ogg')
			if ("sparq") soundin = pick('sound/effects/painfire1.ogg', 'sound/effects/painfire2.ogg')
			if ("blade") soundin = pick('sound/effects/slash1.ogg', 'sound/effects/slash2.ogg', 'sound/effects/slash3.ogg')
			if ("unsheath") soundin = pick('sound/effects/sword_unsheath_01.ogg', 'sound/effects/sword_unsheath_02.ogg', 'sound/effects/sword_unsheath_03.ogg')
			if ("trauma") soundin = pick('sound/effects/gore/trauma1.ogg', 'sound/effects/gore/trauma2.ogg', 'sound/effects/gore/trauma3.ogg')
			if ("chop") soundin = pick('sound/effects/gore/chop.ogg', 'sound/effects/gore/chop2.ogg', 'sound/effects/gore/chop3.ogg', 'sound/effects/gore/chop4.ogg', 'sound/effects/gore/chop5.ogg', 'sound/effects/gore/chop6.ogg')
			if ("sheath") soundin = pick('sound/effects/sword_sheath_01.ogg', 'sound/effects/sword_sheath_02.ogg')
			if ("lifewebfootsteps") soundin = pick('sound/effects/footsteps/xstep1.ogg', 'sound/effects/footsteps/xstep2.ogg')
			if ("slash") soundin = pick('sound/lfwbcombatuse/slash1.ogg', 'sound/lfwbcombatuse/slash2.ogg', 'sound/lfwbcombatuse/slash3.ogg', 'sound/lfwbcombatuse/slash4.ogg', 'sound/lfwbcombatuse/slash5.ogg')
			if ("stab") soundin = pick('sound/lfwbcombatuse/stab1.ogg', 'sound/lfwbcombatuse/stab2.ogg', 'sound/lfwbcombatuse/stab3.ogg')
			if ("swing") soundin = pick('sound/lfwbcombatuse/swing_01.ogg', 'sound/lfwbcombatuse/swing_02.ogg', 'sound/lfwbcombatuse/swing_03.ogg')
			if ("hitsound") soundin = pick('sound/lfwbcombatuse/npc_kill_smash_01.ogg', 'sound/lfwbcombatuse/npc_kill_smash_02.ogg', 'sound/lfwbcombatuse/npc_kill_smash_03.ogg')
			if ("gravpulser") soundin = pick('sound/lfwbcombatuse/gravpulser1.ogg', 'sound/lfwbcombatuse/gravpulser3.ogg')
			if ("grinder") soundin = pick('sound/projectilesnew/rifle1.ogg', 'sound/projectilesnew/rifle2.ogg')
			if ("oldpistol") soundin = pick('sound/lfwbsounds/oldpistol1.ogg', 'sound/lfwbsounds/oldpistol2.ogg')
			if ("revolver_load") soundin = pick('sound/lfwbsounds/revolver_load1.ogg', 'sound/lfwbsounds/revolver_load2.ogg')
			if ("crowbar_hit") soundin = pick('sound/lfwbcombatuse/crowbarhit.ogg', 'sound/lfwbcombatuse/crowbarhit2.ogg')
			if ("crowbar_swing") soundin = pick('sound/lfwbcombatuse/swing_crowbar.ogg', 'sound/lfwbcombatuse/swing_crowbar2.ogg', 'sound/lfwbcombatuse/swing_crowbar3.ogg')
			if ("neoclassic") soundin = pick('sound/lfwbsounds/nrevolver.ogg', 'sound/lfwbsounds/nrevolver2.ogg')
			if ("kpfw") soundin = pick('pulse_rifle_01_shot_loopmono_01.ogg', 'pulse_rifle_01_shot_loopmono_02.ogg', 'pulse_rifle_01_shot_loopmono_03.ogg', 'pulse_rifle_01_shot_loopmono_04.ogg')
			if ("kabal") soundin = pick('sound/weapons/guns/kabal_fire1.ogg', 'sound/weapons/guns/kabal_fire2.ogg')
			if ("thanatikabal") soundin = pick('sound/weapons/guns/thanatikabal.ogg')
			if ("axeswing") soundin = pick('sound/weapons/wpn_swing_axe_01.ogg', 'sound/weapons/wpn_swing_axe_02.ogg')
			if ("axechop") soundin = pick('sound/weapons/npc_kill_chop_01.ogg', 'sound/weapons/npc_kill_chop_02.ogg', 'sound/weapons/npc_kill_chop_03.ogg')
			if ("jesterbig") soundin = pick('sound/lfwbsounds/jester_big.ogg', 'sound/lfwbsounds/jester_big2.ogg')
			if ("jestermedium") soundin = pick('sound/lfwbsounds/jester_medium.ogg', 'sound/lfwbsounds/jester_medium2.ogg')
			if ("jestersmall") soundin = pick('sound/lfwbsounds/jester_small.ogg', 'sound/lfwbsounds/jester_small2.ogg', 'sound/lfwbsounds/jester_small3.ogg', 'sound/lfwbsounds/jester_small4.ogg')
			if ("coolgunsound") soundin = pick('sound/weapons/newpistol.ogg', 'sound/weapons/newpistol2.ogg')
			if ("slash") soundin = pick('sound/webbers/slash1.ogg', 'sound/webbers/slash2.ogg', 'sound/webbers/slash3.ogg', 'sound/webbers/slash4.ogg', 'sound/webbers/slash5.ogg')
			if ("bardiche") soundin = pick('sound/weapons/bardiche1.ogg', 'sound/weapons/bardiche2.ogg', 'sound/weapons/bardiche3.ogg', 'sound/weapons/bardiche4.ogg')
			if ("paperdown") soundin = pick('sound/webbers/paper_down.ogg', 'sound/webbers/paper_down2.ogg')
			if ("slosh") soundin = pick('sound/water/slosh1.wav', 'sound/water/slosh2.wav', 'sound/water/slosh3.wav', 'sound/water/slosh4.wav')
	return soundin
/mob/living/carbon/human/proc/set_mig_spawn()
	set hidden = 0
	set name = "SetMigSpawn"
	var/area/A = get_area(src)
	var/turf/T = get_turf(src)
	if(!A)
		return
	if(!istype(A, /area/dunwell/surface))
		to_chat(src, "<span class='combat'>I must do this in the caves.</span>")
		return
	if(istype(T, /turf/simulated/floor/open) || istype(T, /turf/simulated/floor/plating/magmareal) || istype(T, /turf/simulated/floor/exoplanet/water))
		to_chat(src, "<span class='combat'>Not this place!</span>")
		return
	if(religion == "Gray Church")
		set_mig_spawn_pc = src.loc
	else
		set_mig_spawn_th = src.loc
	to_chat(src, "Migrant spawn is now at [A.name], at X [src.x] Y [src.y] of Evergreen.")

/mob/living/carbon/human/proc/announceEx()
	set hidden = 0
	set name = "announceEx"
	var/input = sanitize(input(usr, "Type your announcement (PEOPLE IN 14 TILES OF RANGE WILL HEAR)", "Expedition Announcement", "") as message|null)
	if(!input)
		return
	if(findtext(input, "http"))
		return
	for(var/mob/living/carbon/human/H in range(src, 14))
		if(religion != H.religion)
			continue
		to_chat(H, "<h3><span class='passivebold'>[src.real_name] <i>([src.job])</i></span> <span class='passive'>announces:</span></h3>")
		to_chat(H, "<h4><span class='passive'>\"[input]\"</span></h4>")
		to_chat(H, "<br>")
		var/distrange = get_dist(H, src)
		var/closesound = pick('horn1.ogg','horn2.ogg')
		H << sound(closesound, repeat = 0, wait = 0, volume = 80-distrange, channel = 12)
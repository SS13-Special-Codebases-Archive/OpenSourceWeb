/turf
	vis_flags = VIS_INHERIT_PLANE|VIS_INHERIT_ID

/obj
	vis_flags = VIS_INHERIT_PLANE|VIS_INHERIT_ID

/mob
	vis_flags = VIS_INHERIT_PLANE|VIS_INHERIT_ID

var/turf/global_openspace = list()

/turf/simulated/floor/open
	name = "open space"
	intact = 0
	density = 0
	icon = 'icons/turf/walls.dmi'
	icon_state = "dark_over"
	pathweight = 100000 // Seriously, don't try and path over this one numbnuts
	plane = -10
	mouse_opacity = 1
	vis_flags = 0
	var/turf/floorbelow
	var/global/atom/movable/darkover
	dynamic_lighting = 0
	var/flooded = 0

/turf/simulated/floor/open/New()
	..()
	if(!darkover)
		darkover = new()
		darkover.icon = 'icons/turf/walls.dmi'
		darkover.icon_state = "dark_over"
		darkover.plane = 15
		darkover.mouse_opacity = 0
	for(var/direction in cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(istype(turf_to_check, /turf/simulated/floor/open))
			continue
		else if(istype(turf_to_check, /turf/simulated))
			var/image/dark_side = image('icons/turf/walls.dmi', "dark_side", dir = direction)//turn(direction, 180))
			dark_side.plane = 15
			dark_side.layer = 6
			overlays += dark_side
	src.vis_contents += darkover
	global_openspace += src
	getbelow()

/turf/simulated/floor/open/Entered(atom/movable/M)
	if(!M) return
	if(!M.gravitydep) return
	if(flooded)
		floodEntered(M)
		return
	if(canFall(M))
		M.when_fall(floorbelow)

/turf/simulated/floor/open/proc/floodEntered(atom/movable/M)
	if(istype(M, /mob/dead)) return
	if(istype(M, /obj/effect/effect/light)) return
	if(isobj(M))
		if(istype(M, /obj/item/weapon/flame/torch))
			var/obj/item/weapon/flame/torch/F = M
			if(!F.throwing && F.lit)
				F.turn_off()
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjustStaminaLoss(rand(0,2))
		H.bodytemperature = 200
		if(H?.special == "sailor")
			H.rotate_plane()
		if(H.lying)
			for(var/obj/item/weapon/flame/torch/F in H.contents)
				F.turn_off()
		H.visible_message("<span class='bname'>[M.name]</span> floundes in water!")
		H.adjustStaminaLoss(rand(1,2))
		playsound(H.loc, 'sound/effects/fst_water_jump_down_01.ogg', 80, 1, -1)


/turf/simulated/floor/open/attack_hand(mob/living/carbon/human/H as mob)
	if(src.z != H.z)
		return
	if(flooded)
		return
	if(!canFall(H)) return
	H.visible_message("<span class='passiveboldsmaller'>[H.name]</span> <span class='passivesmaller'>starts to climb down.</span>")
	if(do_after(H, 42-H.my_skills.GET_SKILL(SKILL_CLIMB)))
		var/list/rolled = roll3d6(H,SKILL_CLIMB,null)
		switch(rolled[GP_RESULT])
			if(GP_SUCCESS, GP_CRITSUCCESS)
				var/turf/T = locate(src.x, src.y, src.z-1)
				if(T.density)
					to_chat(H, "<span class='hitbold'>  I cannot climb there!</span>")
					return
				H.forceMove(locate(src.x, src.y, src.z-1))
				playsound(H.loc, 'sound/effects/climb.ogg', 40, 1)
				H.visible_message("<span class='baronboldoutlined'>[H]</span> climbs down.")

			if(GP_FAILED)
				var/turf/T = locate(src.x, src.y, src.z-1)
				if(T.density)
					to_chat(H, "<span class='hitbold'>  I cannot climb there!</span>")
					return
				H.Move(locate(src.x, src.y, src.z-1))
				to_chat(H, "<span class='hitbold'>  You failed to climb \the [src]!</span>")
				if(H.special == "notafraid")
					to_chat(H, "You land softly.")
					playsound(H, pick('sound/webbers/fst_stone_solid_land_01.ogg', 'sound/webbers/fst_stone_solid_land_02.ogg'), 80, 1)
					H.visible_message("<span class='bname'>[H.name]</span> lands softly!")
					return
				var/damage = rand(15,25)
				H.apply_damage(damage + rand(-3,12), BRUTE, "l_leg")
				H.apply_damage(damage + rand(-3,12), BRUTE, "r_leg")
				H.apply_damage(damage + rand(-3,12), BRUTE, "l_foot")
				H.apply_damage(damage + rand(-3,12), BRUTE, "r_foot")
				H.weakened = max(H.weakened,4)
				playsound(H.loc, 'sound/effects/fallsmash.ogg', 50, 0)
				if(prob(70))
					H.emote("fallscream",1)
				if(prob(5))
					var/time = rand(2, 6)
					H.Paralyse(time)
					H.Stun(time)
					H:updatehealth()

			if(GP_CRITFAIL)
				H.Move(locate(src.x, src.y, src.z-1))
				var/turf/T = locate(src.x, src.y, src.z-1)
				if(T.density)
					to_chat(H, "<span class='hitbold'>  I cannot climb there!</span>")
					return
				to_chat(H, "<span class='crithit'>CRITICAL FAILURE!</span> <span class='hitbold'>You failed to climb \the [src]!</span>")
				if(H.special == "notafraid")
					to_chat(H, "You land softly.")
					playsound(H, pick('sound/webbers/fst_stone_solid_land_01.ogg', 'sound/webbers/fst_stone_solid_land_02.ogg'), 80, 1)
					H.visible_message("<span class='bname'>[H.name]</span> lands softly!")
					return
				var/damage = rand(28,45)
				H.apply_damage(damage + rand(-3,12), BRUTE, "l_leg")
				H.apply_damage(damage + rand(-3,12), BRUTE, "r_leg")
				H.apply_damage(damage + rand(-3,12), BRUTE, "l_foot")
				H.apply_damage(damage + rand(-3,12), BRUTE, "r_foot")
				H.weakened = max(H.weakened,8)
				playsound(H.loc, 'sound/effects/fallsmash.ogg', 50, 0)
				H.updatehealth()
				if(prob(70))
					H.emote("fallscream",1)
				if(prob(40))
					var/time = rand(2, 6)
					H.Paralyse(time)
					H.Stun(time)
					H.updatehealth()
					var/DICELOL = roll("3d6")
					if(DICELOL <= 8)
						H.apply_effect(5, PARALYZE)
						visible_message("<span class='combatglow'><b>[H]</b> has been knocked unconscious!</span>")
						H.ear_deaf = max(H.ear_deaf,6)
						H.CU()

/atom/movable/proc/when_fall(var/turf/simulated/O)
	if(!O) return
	if(istype(O, /turf/simulated/floor/open))
		var/turf/simulated/floor/open/aberto = O
		if(aberto.flooded)
			return
	src.forceMove(O)

/mob/living/carbon/human/when_fall(var/turf/simulated/floor/open/O)
	src.visible_message("<span class='bname'>[src.name]</span> falls!")
	src.forceMove(O)
	if(src.special == "notafraid")
		to_chat(src, "You land softly.")
		playsound(src, pick('sound/webbers/fst_stone_solid_land_01.ogg', 'sound/webbers/fst_stone_solid_land_02.ogg'), 80, 1)
		src.visible_message("<span class='bname'>[src.name]</span> lands softly!")
		return
	var/damage = 10
	var/list/roll_result = roll3d6(src, src.my_stats.dx, -1, FALSE, TRUE)
	switch(roll_result[GP_RESULT])
		if(GP_CRITSUCCESS)
			src.visible_message("<span class='bname'>[src.name]</span> lands softly!")
			playsound(src, pick('sound/webbers/fst_stone_solid_land_01.ogg', 'sound/webbers/fst_stone_solid_land_02.ogg'), 80, 1)
			return
		if(GP_SUCCESS)
			src.visible_message("<span class='bname'>[src.name]</span> lands softly!")
			playsound(src, pick('sound/webbers/fst_stone_solid_land_01.ogg', 'sound/webbers/fst_stone_solid_land_02.ogg'), 80, 1)
			return
		if(GP_CRITFAIL)
			damage = 15
	//Leaving this FOE PLS DO GURPS ROLL FOR DX WHEN FALLING AND LANDING SOFTLY (like this on lfwb)
	for(var/mob/living/carbon/human/victim in O.contents)
		if(victim == src)
			continue
		var/organ = pick("chest", "head")
		victim.emote("scream")
		victim.apply_damage(src.my_stats.ht + src.my_stats.st * 1.5, BRUTE, organ)
		victim.Stun(src.my_stats.ht)
		victim.updatehealth()
		victim.update_canmove()
	apply_damage(damage/2 + rand(-5,12), BRUTE, "l_leg")
	apply_damage(damage/2 + rand(-5,12), BRUTE, "r_leg")
	apply_damage(damage + rand(-5,12), BRUTE, "l_foot")
	apply_damage(damage + rand(-5,12), BRUTE, "r_foot")
	apply_damage(src.carryingweight/2, BRUTE, pick("head", "l_arm", "r_arm", "l_leg", "r_leg", "chest", "groin"))
	weakened = max(src.weakened,4)
	emote("fallscream",1)
	if(prob(40))
		Stun(rand(2, 6))
	playsound(loc, 'sound/effects/fallsmash.ogg', 50, 1)//Splat
	updatehealth()
	update_canmove()

/turf/simulated/floor/open/proc/canFall(atom/movable/M)
	if(!floorbelow) return
	if(flooded) return
	var/canfall = TRUE
	if(floorbelow.density)
		canfall = FALSE
	if(M.throwing)
		canfall = FALSE
	for(var/atom/A in src)
		if(istype(A, /obj/structure/elevador))
			canfall = FALSE
		if(A == M) continue
		if(A.blocksOpenFalling)
			canfall = FALSE
		if(A.density && A.countsDensity)
			canfall = FALSE
	for(var/atom/A in floorbelow.contents)
		if(A.density && A.countsDensity)
			canfall = FALSE
	if(isobserver(M))
		canfall = FALSE
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.clinged_turf)
			var/distancefrom = get_dist(H,H.clinged_turf)
			if(distancefrom <= 1)
				canfall = FALSE
	return canfall

/turf/simulated/floor/open/proc/getbelow()
	var/turf/below = locate(src.x, src.y, src.z-1)
	floorbelow = below
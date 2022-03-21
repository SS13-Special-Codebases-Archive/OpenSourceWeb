/turf/simulated/proc/update_slowlyness()
	if(src.liquid && src.liquid.depth >= 45)
		movement_delay = 2
	if(istype(src, /turf/simulated/floor/open))
		var/turf/simulated/floor/open/O = src
		if(O.flooded)
			movement_delay = 2
	else
		movement_delay = initial(movement_delay)

/turf/simulated/proc/check_watercango()
	for(var/obj/structure/mineral_door/M in src)
		if(M.density)
			return 0
	for(var/obj/machinery/door/airlock/A in src)
		if(A.density)
			return 0
	for(var/obj/structure/window/W in src)
		if(W.density)
			return 0
	if(src.density)
		return 0
	return 1

/atom/movable/proc/fluid_act(var/depth, var/cor)
	if(cor == WATER_COLOR)
		clean_blood()

/atom/movable/proc/update_fluid_icon(var/depth, var/cor)
	var/water_state = 0
	var/transparency = 100
	switch(depth)
		if(10 to 25)
			water_state = 2
			transparency = 100
		if(25 to 45)
			water_state = 3
			transparency = 120
		if(45 to 65)
			water_state = 4
			transparency = 130
		if(65 to 85)
			water_state = 5
			transparency = 140
		if(85 to 105)
			water_state = 6
			transparency = 150
		if(105 to 125)
			water_state = 7
			transparency = 160
		if(125 to 145)
			water_state = 8
			transparency = 170
		if(145 to 165)
			water_state = 9
			transparency = 180
		if(165 to 185)
			water_state = 10
			transparency = 185
		if(185 to 205)
			water_state = 11
			transparency = 190
		if(205 to INFINITY)
			water_state = 12
			transparency = 195
	if(src.last_water_state == water_state) return
	var/image/I = null
	overlays = null
	I = image('reagents.dmi', "reagent_filling[water_state]")
	src.appearance_flags |= KEEP_TOGETHER
	I.blend_mode = BLEND_INSET_OVERLAY
	I.color = cor
	I.pixel_y = src.pixel_y * -1
	I.pixel_x = src.pixel_x * -1
	I.alpha = transparency
	src.overlays += I
	src.last_water_state = water_state

/mob/living/carbon/human/fluid_act(var/depth, var/cor)
	if(cor == WATER_COLOR)
		clean_blood()
	if(cor == BLOOD_COLOR)
		src.bloody_body(src)
		src.bloody_hands(src)

/mob/living/carbon/human/update_fluid_icon(var/depth, var/cor)
	var/water_state = 0
	var/ripple_state = 0
	var/transparencia = 100
	switch(depth)
		if(10 to 25)
			water_state = 2
			transparencia = 100
		if(25 to 45)
			water_state = 3
			transparencia = 120
		if(45 to 65)
			water_state = 4
			transparencia = 130
		if(65 to 85)
			water_state = 5
			transparencia = 140
		if(85 to 105)
			water_state = 6
			transparencia = 150
		if(105 to 125)
			water_state = 7
			transparencia = 160
		if(125 to 145)
			water_state = 8
			transparencia = 170
		if(145 to 165)
			water_state = 9
			transparencia = 180
		if(165 to 185)
			water_state = 10
			transparencia = 185
		if(185 to 205)
			water_state = 11
			transparencia = 190
		if(205 to INFINITY)
			water_state = 12
			transparencia = 195

	if(hasActiveShield(0))
		if(depth >= 0.1)
			if(depth >= 85)
				electrocute_act(60, src, 1, 0, 1)
			var/obj/item/weapon/shield/generator/G = getActiveShield()
			if(G.CELL.charge && G.active)
				G.active = 0
				processing_objects.Remove(G)
				G.update_icon()
				src.update_icons()

	if(src.resting && depth >= 85)
		if(handle_drowning() && client)
			client.color = cor
		else
			client.color = cor
	if(!src.resting && depth >= 165)
		if(handle_drowning())
			if(client)
				client.color = cor
		else
			if(client)
				client.color = cor
	if(water_state)
		add_water(1, water_state, cor, transparencia)
	if(!water_state)
		remove_water()
	if(ripple_state)
		add_ripple(1, ripple_state, cor)
	if(!ripple_state)
		remove_ripple(1)

/mob/living/carbon/human/proc/add_water(var/update_icons=1, var/state=5, var/cor, var/transparency)
	overlays_standing[WATER_LAYER] = null
	var/image/standing = overlay_image('icons/life/reagents.dmi', "reagent_filling[state]")
	standing.blend_mode = BLEND_INSET_OVERLAY
	standing.color = cor
	standing.alpha = transparency
	overlays_standing[WATER_LAYER] = standing

	if(update_icons)	update_icons()
	return

/mob/living/carbon/human/proc/remove_water(var/update_icons=1)
	overlays_standing[WATER_LAYER] = null
	var/image/standing = null
	overlays_standing[WATER_LAYER] = standing

	if(update_icons)	update_icons()
	return

/mob/living/carbon/human/proc/add_ripple(var/update_icons=1, var/state=5, var/cor)
	overlays_standing[RIPPLE_LAYER] = null
	var/image/standing = overlay_image('icons/life/reagents.dmi', "water[state]ripple")
	standing.color = color
	overlays_standing[RIPPLE_LAYER] = standing

	if(update_icons)	update_icons()
	return

/mob/living/carbon/human/proc/remove_ripple(var/update_icons=1)
	overlays_standing[RIPPLE_LAYER] = null
	var/image/standing = null
	overlays_standing[RIPPLE_LAYER] = standing

	if(update_icons)	update_icons()
	return

/atom/proc/add_fluid_by_transfer(var/turf/simulated/local, var/profundidade = 1)
	if(!local.liquid)
		var/obj/reagent/R = new(local)
		R.depth = profundidade
		src.reagents.trans_to(R, src.reagents.total_volume)
		R.update_reagents()
	if(local.liquid)
		local.liquid:depth += profundidade
		src.reagents.trans_to(local.liquid, src.reagents.total_volume)
		local.liquid:update_reagents()

/atom/proc/add_fluid(var/turf/simulated/local, var/profundidade = 1, var/reagent = "water")
	if(!local.liquid)
		var/obj/reagent/R = new(local)
		R.depth = profundidade
		R.set_reagent(reagent)
		src.reagents.trans_to(R, src.reagents.total_volume)
		R.update_reagents()
	if(local.liquid)
		local.liquid:depth += profundidade
		local.liquid:reagents:add_reagent(reagent, profundidade)
		local.liquid:update_reagents()

/obj/reagent/proc/set_reagent(var/reagente)
	src.reagents.reagent_list.Cut()
	src.reagents.total_volume = 0
	src.reagents.add_reagent(reagente, src.depth)
	src.reagents.my_atom = src
	src.update_reagents()

/obj/reagent/proc/update_reagents()
	if(src.reagents.total_volume)
		var/datum/reagent/R = src.reagents.get_master_reagent()
		src.color = R.color
		R.reaction_turf(loc, src.reagents.total_volume, 0)

/obj/reagent/proc/update_dirs()
	ableDirs.Cut()
	for(var/dir in cardinal)
		var/turf/simulated/T = get_step(src, dir)
		if(!T) continue
		if(T.check_watercango())
			ableDirs += dir

/obj/reagent/proc/update_atoms()
	atomsInMe.Cut()
	for(var/atom/movable/A as mob|obj in src.loc.contents)
		if(istype(A, /obj/reagent)) continue
		if(istype(A, /atom/movable/lighting_overlay)) continue
		atomsInMe.Add(A)

/obj/reagent/proc/update_own_alpha()
	var/transparencia = 100
	switch(depth)
		if(10 to 25)
			transparencia = 100
		if(25 to 45)
			transparencia = 120
		if(45 to 65)
			transparencia = 130
		if(65 to 85)
			transparencia = 140
		if(85 to 105)
			transparencia = 150
		if(105 to 125)
			transparencia = 160
		if(125 to 145)
			transparencia = 170
		if(145 to 165)
			transparencia = 180
		if(165 to 185)
			transparencia = 185
		if(185 to 205)
			transparencia = 190
		if(205 to INFINITY)
			transparencia = 195
	src.alpha = transparencia

/turf/simulated/proc/check_for_reagents_to_update()
	for(var/obj/reagent/R in view(1, src))
		R.update_dirs()

/proc/temperature_mix_formula(var/amount1, amount2, temperature1, temperature2)
	return (amount1*temperature1 + amount2*temperature2) / (amount1 + amount2)

/obj/item/dropped()
	..()
	if(isturf(loc) && src?:loc?:liquid)
		src?:loc?:liquid?:update_atoms()

/obj/item/Move()
	..()
	if(src?:loc?:liquid)
		src?:loc?:liquid?:update_atoms()

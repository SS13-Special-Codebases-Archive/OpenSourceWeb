/turf/simulated/floor/exoplanet/water/shallow
	name = "water"
	icon = 'icons/obj/warfare.dmi'//This appears under the water.
	movement_delay = 4
	var/shallow = TRUE
	plane = 0
	layer = 1
	burnAble = 0
	var/safewater = FALSE

/turf/simulated/floor/exoplanet/water/shallow/Destroy()
	for(var/obj/effect/water/W in src)
		qdel(W)
	..()

/turf/simulated/floor/exoplanet/water/shallow/bite_act(mob/M as mob)
	var/mob/living/carbon/human/H = M
	if(get_dist(src,M) <= 1)
		if(M.wear_mask && M.wear_mask.flags & MASKCOVERSMOUTH)
			to_chat(M, "<span class='combat'>[pick(nao_consigoen)] my mask is in the way!</span>")
			return
		var/datum/reagents/reagents = new/datum/reagents(2)
		reagents.add_reagent("water", 2)
		if(!safewater)
			reagents.add_reagent("????", 2)
		reagents.reaction(H, INGEST)
		reagents.trans_to(H, 2)
		visible_message("<span class='bname'>⠀[H]</span> drinks from \the [src]!</span>")
		H.bladder += rand(1,3) //For peeing
		H.hidratacao += 5
		playsound(M.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
		return

/turf/simulated/floor/exoplanet/water/shallow/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(W, /obj/item/clothing/mask/sleeve))
		var/obj/item/clothing/mask/sleeve/S = W
		S.soaked = 10
		to_chat(user, "<span class='passive'>You soak \the [S] in \the [src]</span>")
	if(istype(W, /obj/item/weapon/alicate))
		var/obj/item/weapon/alicate/A = W
		var/obj/item/weapon/ore/refined/lw/lw = safepick(A.contents)
		if(A.contents.len && lw.itemToBecome && lw.percentageToBecome >= MAX_SMITHING)
			var/obj/item/weapon/WE = new lw.itemToBecome(user.loc)
			WE.quality = lw.qualidadeBarra
			WE.New()
			A.contents.Cut()
			A.update_icon()
			var/sound_to_go = pick('sound/effects/quench_barrel1.ogg', 'sound/effects/quench_barrel2.ogg')
			playsound(src.loc, sound_to_go, 50, 0)
	if (istype(W, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/RG = W
		RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		if(!safewater)
			RG.reagents.add_reagent("????", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("\blue [user] fills \the [RG] using \the [src].","\blue You fill \the [RG] using \the [src].")
		return
	if(istype(W, /obj/item/weapon/fishing_rod) && ishuman(user))
		var/obj/item/weapon/fishing_rod/F = W
		var/mob/living/carbon/human/H = user
		if(F.worms)
			to_chat(user, "<span class='passive'>You begin fishing.</span>")
			if(do_after(user, rand(60,120)))
				if(skillcheck(H.my_skills.GET_SKILL(SKILL_FISH), 50))
					if(prob(75))
						to_chat(user, "<span class='passivebold'>Got it!</span>")
						var/hookedfish
						if(prob(5))
							hookedfish = pick(/obj/item/weapon/claymore/copper, /obj/item/weapon/spacecash/silver/c15, /obj/item/weapon/grenade/syndieminibomb/frag, /obj/item/weapon/horn/horn2, /obj/item/weapon/gun/projectile/automatic/pistol/ml23)
						else
							hookedfish = pick(/obj/item/sea/deadfish, /obj/item/sea/seastar, /obj/item/weapon/reagent_containers/food/snacks/fish/fish1, /obj/item/weapon/reagent_containers/food/snacks/fish/fish2, /obj/item/weapon/reagent_containers/food/snacks/fish/fish3, /obj/item/weapon/reagent_containers/food/snacks/fish/fish4, /obj/item/weapon/reagent_containers/food/snacks/fish/fish5)
						new hookedfish(user.loc)
						F.worms = FALSE
						F.update_icon()
					else
						to_chat(user, "You failed to get any fish.")
						if(prob(20))
							to_chat(user, "The bait falls off the hook!")
							F.worms = FALSE
				else
					to_chat(user, "You failed to get any fish.")
					if(prob(40))
						to_chat(user, "The bait falls off the hook!")
						F.worms = FALSE
		else
			to_chat(user, "There is no bait.")
/turf/simulated/floor/exoplanet/water/shallow/nodive
	shallow = TRUE
	movement_delay = 3


/turf/simulated/floor/exoplanet/water/shallow/river
	icon_state = ""
	shallow = TRUE
	movement_delay = 3
	safewater = TRUE
	var/directionz = SOUTH

/turf/simulated/floor/exoplanet/water/shallow/river/Entered(AM)
	if(istype(AM, /mob/dead))	return
	if(istype(AM, /obj/effect/effect/light))	return
	if(!istype(AM, /mob/living/carbon/human))
		var/obj/A = AM
		if(istype(AM, /obj/item/weapon/flame/torch))
			var/obj/item/weapon/flame/torch/F = AM
			if(!F.throwing && F.lit)
				F.turn_off()
			spawn(rand(3,6))
				if(A.x == src.x && A.y == src.y && A.z == src.z)
					A.Move(get_step(A,src.directionz))
		else
			spawn(rand(3,6))
				if(A.x == src.x && A.y == src.y && A.z == src.z)
					A.Move(get_step(A,src.directionz))
		return
	var/mob/living/carbon/human/M = AM
	M.adjustStaminaLoss(rand(0,2))
	M.overlays += /obj/effect/water/waterlay
	var/obj/item/weapon/flame/torch/F
	M.bodytemperature = 200
	if(ishuman(M))
		if(M?.special == "sailor")
			M.rotate_plane()
	for(F in M.contents)
		F.turn_off()
	var/DXTOTAL = M.my_stats.dx * 2
	if(prob(70-DXTOTAL) && !skillcheck(M.my_skills.GET_SKILL(SKILL_SWIM), 40, 0, M))
		M.visible_message("<span class='bname'>[M.name]</span> floundes in water!")
		M.adjustStaminaLoss(rand(1,2))
		playsound(M.loc, 'sound/effects/fst_water_jump_down_01.ogg', 80, 1, -1)
	var/totalroll = (M.my_skills.GET_SKILL(SKILL_SWIM)+M.my_stats.dx) / 2
	spawn(rand(2,totalroll))
		if(M.x == src.x && M.y == src.y && M.z == src.z)
			M.Move(get_step(M,src.directionz))

/turf/simulated/floor/exoplanet/water/shallow/river/Exited(AM)
	if(!istype(AM, /mob/living))
		return
	if(istype(AM, /obj/effect/effect/light))	return
	var/atom/movable/M = AM
	for(var/turf/simulated/T in range(src,1))
		if(!istype(T, /turf/simulated/floor/exoplanet/water/shallow/river))
			M.overlays -= /obj/effect/water/waterlay

/obj/effect/water/waterlay
	name = "water"
	icon = 'icons/obj/warfare.dmi'
	icon_state = "waterlayer"
	plane = 0
	layer = 5
	density = FALSE
	alpha = 180
	anchored = TRUE
	mouse_opacity = FALSE

/turf/simulated/floor/exoplanet/water/shallow/river/north
	directionz = NORTH

/turf/simulated/floor/exoplanet/water/shallow/river/east
	directionz = EAST

/turf/simulated/floor/exoplanet/water/shallow/river/west
	directionz = WEST

/turf/simulated/floor/exoplanet/water/shallow/river/update_icon()

	var/image/wave_overlay = image('icons/obj/warfare.dmi', "waves")
	overlays += wave_overlay

/turf/simulated/floor/exoplanet/water/shallow/river/New()
	//..()
	temperature = T0C - 80
	for(var/obj/effect/water/top/river/T in src)
		if(T)
			qdel(T)

	new /obj/effect/water/bottom/river(src)//Put it right on top of the water so that they look like they're the same.
	new /obj/effect/water/top/river(src)
	spawn(5)
		update_icon()
		for(var/turf/simulated/floor/exoplanet/water/shallow/river/T in range(1))
			T.update_icon()
	var/datum/reagents/R = new/datum/reagents(10)
	reagents = R
	R.my_atom = src
	R.add_reagent("water",5)

/turf/simulated/floor/exoplanet/water/shallow/river/ChangeTurf(turf/N, tell_universe, force_lighting_update)
	var/obj/effect/water/top/river/T = locate() in loc
	if(T)
		qdel(T)
	var/obj/effect/water/bottom/river/B = locate() in loc
	if(B)
		qdel(B)
	. = ..()
	for(var/turf/simulated/floor/exoplanet/water/shallow/river/S in range(1))
		S.update_icon()

/obj/effect/water/top/river//This one appears over objects but under mobs.
	name = "water"
	icon = 'icons/obj/warfare.dmi'
	icon_state = "water_surface2"
	plane = 0
	layer = 3
	density = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

/obj/effect/water/bottom/river//This one appears over mobs.
	name = "water"
	icon = 'icons/obj/warfare.dmi'
	icon_state = ""
	plane = 0
	layer = 5
	density = FALSE
	anchored = TRUE
	mouse_opacity = FALSE//Don't want this being clicked.

/turf/simulated/floor/beach/water/shallow/Cross(var/atom/A)// se tu ta pegando fogo tu apaga agora
	if(isliving(A))
		var/mob/living/L = A
		L.ExtinguishMob()
		L.clean_blood()
		if(ishuman(L))
			L:update_inv_gloves()

/turf/simulated/floor/exoplanet/water/shallow/New()
	..()
	temperature = T0C - 80
	for(var/obj/effect/water/top/T in src)
		if(T)
			qdel(T)

	new /obj/effect/water/bottom(src)//Put it right on top of the water so that they look like they're the same.
	new /obj/effect/water/top(src)
	spawn(5)
		update_icon()
		for(var/turf/simulated/floor/exoplanet/water/shallow/T in range(1))
			T.update_icon()

/turf/simulated/floor/exoplanet/water/shallow/Entered(AM)
	if(isliving(AM))
		var/mob/living/L = AM
		L.ExtinguishMob()
		L.clean_blood()
		if(ishuman(L))
			L:update_inv_gloves()
		playsound(L, "footsteps_water", 50, 1)
	if(ishuman(AM))
		var/mob/living/carbon/human/M = AM
		for(var/obj/item/weapon/shield/generator/G in M.contents)
			if(G.active)
				G.failure(M)

	if(!istype(AM, /mob/living))
		if(istype(AM, /obj/item/weapon/flame/torch))
			var/obj/item/weapon/flame/torch/F = AM
			if(!F.throwing && F.lit)
				F.turn_off()

		return
	var/mob/living/carbon/human/M = AM
	var/obj/item/weapon/flame/torch/F
	M.bodytemperature = 200
	for(F in M.contents)
		if(F.lit)
			F.turn_off()
/*
/turf/simulated/floor/exoplanet/water/shallow/RightClick(mob/living/M as mob)
	if(shallow)
		M << "<span class='warning'>It's too shallow!</span>"
		return
	if(M.stat)
		return

	M.Move(locate(src.x, src.y, M.z-1))
	M << "<span class='warning'>You swim down.</span>"
	playsound(M.loc, 'fst_water_jump_down_01.ogg', 40, 0)
*/
/turf/simulated/floor/exoplanet/water/shallow/update_icon()

	overlays.Cut()

	var/image/wave_overlay = image('icons/obj/warfare.dmi', "waves")
	overlays += wave_overlay

/turf/simulated/floor/exoplanet/water/shallow/Destroy()
	. = ..()
	for(var/obj/effect/water/bottom/B in src)
		qdel(B)
	for(var/obj/effect/water/top/T in src)
		qdel(T)

/turf/simulated/floor/exoplanet/water/shallow/ChangeTurf(turf/N, tell_universe, force_lighting_update)
	var/obj/effect/water/top/T = locate() in loc
	if(T)
		qdel(T)
	var/obj/effect/water/bottom/B = locate() in loc
	if(B)
		qdel(B)
	. = ..()
	for(var/turf/simulated/floor/exoplanet/water/shallow/S in range(1))
		S.update_icon()


/obj/effect/water/top//This one appears over objects but under mobs.
	name = "water"
	icon = 'icons/obj/warfare.dmi'
	icon_state = "trench_water_top"
	plane = 0
	layer = 3
	density = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

/obj/effect/water/bottom//This one appears over mobs.
	name = "water"
	icon = 'icons/obj/warfare.dmi'
	icon_state = "trench_water_bottom"
	plane = 15
	layer = 5
	density = FALSE
	anchored = TRUE
	mouse_opacity = FALSE//Don't want this being clicked.
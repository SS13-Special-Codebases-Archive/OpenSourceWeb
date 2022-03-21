/obj/reagent
	icon = 'reagents.dmi'
	icon_state = "reagent"
	name = "liquid"
	density = 0
	alpha = 100
	layer = 2
	var/depth = 0 //depth of the water
	var/list/ableDirs = list()
	var/list/atomsInMe = list()
	var/fluid_update_atoms = 0
	var/fluid_push_atoms = 0
	mouse_opacity = 0
	vis_flags = 0

/obj/reagent/New()
	..()
	if(!loc) return // no loc, shouldnt exist, loc.liquid wouldnt exist either

	if(!istype(loc, /turf)) return // same reason as above
	if(src?:loc?:liquid) // if theres already a liquid on the turf
		src?:loc?:liquid?:depth += src.depth
		src.reagents.trans_to(src?:loc?:liquid, src.reagents.total_volume)
		qdel(src)
	if(src?:loc?:liquid == null) //  if theres no liquid on the turf
		src?:loc?:liquid = src
	update_dirs()
	update_atoms()
	playsound(src, 'sound/water/slosh.ogg', rand(80, 90), 1)
	ReagentsToUpdate.Add(src)
	src.set_reagent("water")
	var/area/A = get_area(src)
	if(istype(A, /area/dunwell/station/riverarea))
		if(prob(8))
			var/fishtype
			fishtype = pick(/obj/item/sea/deadfish, /obj/item/sea/seastar, /obj/item/weapon/reagent_containers/food/snacks/fish/fish1, /obj/item/weapon/reagent_containers/food/snacks/fish/fish2, /obj/item/weapon/reagent_containers/food/snacks/fish/fish3, /obj/item/weapon/reagent_containers/food/snacks/fish/fish4, /obj/item/weapon/reagent_containers/food/snacks/fish/fish5)
			new fishtype(src.loc)

	if(istype(loc, /turf/simulated/floor/plating/dirt2))
		var/turf/simulated/floor/plating/dirt2/D2 = loc
		D2.sede = max(50, D2.sede)


/obj/reagent/Destroy()
	src.loc:liquid = null
	src.loc:contents.Remove( src )
	ReagentsToUpdate.Remove( src )
	src.reagents.my_atom = null
	src.reagents.reagent_list.Cut()
	src.atomsInMe.Cut()
	return ..()

/obj/reagent/proc/update()
	if(depth <= -1)
		qdel(src)
	if(depth < MINIMUM_VALUE_TO_PROCCESS) return
	if(depth > MINIMUM_VALUE_TO_PROCCESS)
		for(var/dir in ableDirs)
			var/turf/simulated/T = get_step(src, dir)
			if(T && T.liquid && src.depth > T.liquid.depth+src.depth/12 || T && T.liquid == null)
				var/obj/reagent/R
				if(T.liquid)
					R = T.liquid
				if(!T.liquid)
					var/hasTOCREATE = 1
					if(istype(T, /turf/simulated/floor/open))
						var/turf/simulated/check = locate(T.x, T.y, T.z-1)
						if(check && !check.liquid)
							T = check
						if(check && (check.liquid))
							T = check
							hasTOCREATE = 0
							R = T.liquid
					if(hasTOCREATE)
						R = new(T)
					R.temperature = src.temperature
				var/depthToGo = src.depth/12
				R.reagents.my_atom = R
				R.reagents.add_reagent("[src.reagents.get_random_reagent_id()]", 0.2)
				R.update_reagents()


				R.depth += depthToGo
				src.depth -= depthToGo
				//meanwhile useless R.temperature = temperature_mix_formula(10, 10, R.temperature, src.temperature)
				//meanwhile useless src.temperature = temperature_mix_formula(10, 10, src.temperature, R.temperature)
				if(prob(5))
					playsound(src, pick('sound/effects/water_max1.ogg', 'sound/effects/water_max2.ogg'), rand(80, 90), 1)
				T.update_slowlyness()
				src.update_own_alpha()
				if(depth >= ENOUGH_DEPTH)
					if(world.time >= fluid_push_atoms)
						fluid_push_atoms = world.time + FLUID_UPDATE_DELAY_ATOMS
						for(var/atom/movable/A as mob|obj in atomsInMe)
							if(A == src) continue
							if(istype(A, /atom/movable/lighting_overlay)) continue
							if(A.loc != src.loc) continue
							if(A.simulated && !A.anchored)
								step(A, get_dir(A, T))
	if(depth >= ENOUGH_DEPTH)
		if(world.time >= fluid_update_atoms)
			fluid_update_atoms = world.time + FLUID_UPDATE_DELAY_ATOMS
			var/turf/simulated/simulado = locate(src.x, src.y, src.z+1)
			if(simulado && istype(simulado, /turf/simulated/floor/open))
				var/turf/simulated/floor/open/buraco = simulado
				if(src.depth >= 125)
					buraco.flooded = 1
				else
					buraco.flooded = 0
				buraco.update_slowlyness()
			for(var/atom/movable/A as mob|obj in atomsInMe)
				if(A == src) continue
				if(A.loc != src.loc) continue
				if(istype(A, /atom/movable/lighting_overlay)) continue
				A.fluid_act(depth, color)
				A.update_fluid_icon(depth, color)

/turf/simulated/bite_act(mob/living/carbon/human/H as mob)
	if(!..())
		return
	if(src.liquid)
		var/obj/reagent/R = src.liquid
		if(R.reagents?.total_volume && H?.zone_sel?.selecting == "mouth")
			if(H.wear_mask && H.wear_mask.flags & MASKCOVERSMOUTH)
				to_chat(H, "<span class='combat'>[pick(nao_consigoen)] my mask is in the way!</span>")
			R.reagents.reaction(H, INGEST, override = R.depth)
			visible_message("<span class='bname'>⠀[H]</span> drinks from \the [R]!</span>")
			playsound(R, 'sound/items/drink.ogg', rand(10, 50), 1)
			spawn(5)
				R.reagents.trans_to(H, 5)
				R.depth -= 5
	if(istype(src, /turf/simulated/floor/open))
		var/turf/simulated/floor/O = locate(src.x, src.y, src.z-1)
		if(O.liquid)
			var/obj/reagent/R = O.liquid
			if(R.reagents?.total_volume && H?.zone_sel?.selecting == "mouth")
				if(H.wear_mask && H.wear_mask.flags & MASKCOVERSMOUTH)
					to_chat(H, "<span class='combat'>[pick(nao_consigoen)] my mask is in the way!</span>")
				R.reagents.reaction(H, INGEST, override = R.depth)
				visible_message("<span class='bname'>⠀[H]</span> drinks from \the [R]!</span>")
				playsound(R, 'sound/items/drink.ogg', rand(10, 50), 1)
				spawn(5)
					R.reagents.trans_to(H, 5)
					R.depth -= 5
/obj/reagent/flame_act()
	if(src?.reagents?.reagent_list?.len)
		var/datum/reagent/R = src.reagents.get_random_reagent()
		if(R.flammable)
			var/obj/structure/fire/F = new(src.loc)
			F.chanceToGrow += 200
			qdel(src)

/turf/simulated/attackby(obj/item/O as obj, mob/living/carbon/human/user as mob)
	. = ..()
	if(src.liquid)
		var/obj/reagent/R = src.liquid
		if(istype(O, /obj/item/clothing/mask/sleeve))
			var/obj/item/clothing/mask/sleeve/S = O
			S.soaked = 10
			to_chat(user, "<span class='passive'>You soak \the [S] in \the [src]</span>")
			if(R.depth < 10)
				qdel(R)

		if(istype(O, /obj/item/weapon/flame))
			var/obj/item/weapon/flame/FF = O
			if(FF.lit && R.reagents.reagent_list.len)
				var/datum/reagent/RR = R.reagents.get_random_reagent()
				if(RR.flammable)
					var/obj/structure/fire/F = new(R.loc)
					F.chanceToGrow += 200
					qdel(R)

		if(istype(O, /obj/item/weapon/alicate))
			var/obj/item/weapon/alicate/A = O
			var/obj/item/weapon/ore/refined/lw/lw = safepick(A.contents)
			if(A.contents.len && lw.itemToBecome && lw.percentageToBecome >= MAX_SMITHING)
				var/obj/item/weapon/WE = new lw.itemToBecome(user.loc)
				WE.quality = lw.qualidadeBarra
				WE.New()
				A.contents.Cut()
				A.update_icon()
				var/sound_to_go = pick('sound/effects/quench_barrel1.ogg', 'sound/effects/quench_barrel2.ogg')
				playsound(src.loc, sound_to_go, 50, 0)

		if(R.depth >= 10 && user.a_intent != "hurt")
			if (istype(O, /obj/item/weapon/reagent_containers))
				var/obj/item/weapon/reagent_containers/RG = O
				R.reagents.trans_to(RG, R.reagents.total_volume/6)
				user.visible_message("<span class='passivebold'>[user]</span><span class='passive'> fills \the [RG] on \the [R].</span>")
				playsound(R, pick('sound/webbers/water_max1.ogg', 'sound/webbers/water_max2.ogg'), rand(35, 50), 1)
				return
	..()
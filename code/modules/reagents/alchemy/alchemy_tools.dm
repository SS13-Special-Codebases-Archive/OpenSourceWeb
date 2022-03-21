/obj/item/weapon/retort
	name = "Retort"
	desc = "A thing that using in alchemy."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "retort0"
	var/mob/living/carbon/alchemist
	var/is_on = 0
	var/obj/item/alchemy_powder/powder

/obj/item/weapon/retort/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/alchemy_powder) && !powder)
		user.drop_item()
		powder = W
		W.loc = null

	else if(istype(W, /obj/item/weapon/mortar) && !powder && !is_on)
		var/obj/item/weapon/mortar/M = W
		if(M.powder_contet)
			M.powder_contet.loc = src
			powder = M.powder_contet
			M.powder_contet = null
			M.update_icon()

	else if(istype(W, /obj/item/weapon/flame) && !is_on)
		var/obj/item/weapon/flame/F = W
		if(F.lit)
			processing_objects.Add(src)
			is_on = 1
			playsound(src.loc, 'torch_light.ogg', 50, 1)
			if(istype(user, /mob/living/carbon))
				alchemist = user

	else if(istype(W, /obj/item/weapon/reagent_containers/glass/beaker/vial))
		var/turf/T = locate(x+1,y,z)
		if(istype(T, /turf/simulated/wall))
			return
		for(var/atom/A in T)
			if(istype(A, /obj/structure/) || istype(A, /obj/machinery/))
				return
		user.drop_item()
		W.loc = T

	update_icon()

/obj/item/weapon/retort/attack_hand(mob/user as mob)
	if(is_on)
		is_on = 0
		playsound(src.loc, 'torch_snuff.ogg', 75, 1)
		powder = null
		alchemist = null
		processing_objects.Remove(src)
		update_icon()

	else ..()

/obj/item/weapon/retort/process()
	if(!is_on)
		processing_objects.Remove(src)
		return

	var/turf/T = locate(x+1,y,z)
	var/list/obj/item/weapon/reagent_containers/V_list = list()
	for(var/obj/item/weapon/reagent_containers/glass/V in T)
		V_list += V

	for(var/obj/item/weapon/reagent_containers/food/drinks/D in T)
		V_list += D

	if(powder && length(powder.reagents.reagent_list))
		if(length(V_list))
			powder.reagents.trans_to(V_list[1], 1)
		else
			powder.reagents.remove_any(1)
		playsound(src.loc, "sound/liquidplop.ogg", 50, 3)

	if(alchemist)
		if(alchemist.my_skills.GET_SKILL(SKILL_ALCH))
			if(!prob(30 * alchemist.my_skills.GET_SKILL(SKILL_ALCH)))
				explosion(src.loc, -1, -1, 2, 2)
				processing_objects.Remove(src)
				qdel(src)
		else
			if(!prob(30))
				explosion(src.loc, -1, -1, 2, 2)
				processing_objects.Remove(src)
				qdel(src)

	else if(!prob(30))
		explosion(src.loc, -1, -1, 2, 2)
		processing_objects.Remove(src)
		qdel(src)

/obj/item/weapon/retort/update_icon()
	if(is_on)
		icon_state = "retort1"
	else
		icon_state = "retort0"

/obj/item/weapon/mortar
	name = "Mortar"
	desc = "A thing that using in alchemy."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mortar0"
	w_class = 1
	var/obj/item/alchemy_powder/powder_contet
	var/list/datum/recipe/alchemy/alchemy_recipes = list()

/obj/item/weapon/mortar/New()
	..()
	if(!length(alchemy_recipes))
		for (var/type in (typesof(/datum/recipe/alchemy)-/datum/recipe/alchemy))
			alchemy_recipes += new type

/obj/item/weapon/mortar/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/alchemy_powder) && !powder_contet)
		user.drop_item()
		powder_contet = W
		W.loc = null

	else if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom) && length(contents) < 4 && !powder_contet)
		contents += W
		user.drop_item()
		W.loc = src


	else if(istype(W, /obj/item/weapon/pestle) && length(contents) && !powder_contet)
		var/datum/recipe/alchemy/recipe = select_recipe(alchemy_recipes, src)
		if(recipe && check_alchemy(user))
			powder_contet = recipe.make_powder(src, user)
		else
			powder_contet = fail(user)

	update_icon()

/obj/item/weapon/mortar/attack_self(mob/user as mob)
	empty()

/obj/item/weapon/mortar/proc/empty()
	if(powder_contet)
		var/obj/item/alchemy_powder/P = powder_contet
		P.loc = get_turf(src)
		powder_contet = null

	if(length(contents))
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/M in contents)
			contents -= M
			M.loc = get_turf(src)

	update_icon()

/obj/item/weapon/mortar/proc/fail(mob/user as mob)
	var/obj/item/alchemy_powder/powder = new /obj/item/alchemy_powder()
	for (var/obj/O in contents)
		del(O)
	var/potion_volume = 3
	var/alchemy_skill = 0
	if(istype(user, /mob/living/carbon))
		var/mob/living/carbon/C = user
		if(C.my_skills.GET_SKILL(SKILL_ALCH))
			alchemy_skill = C.my_skills.GET_SKILL(SKILL_ALCH)
	if(alchemy_skill)
		potion_volume *= alchemy_skill
	powder.reagents.add_reagent(pick("venom", "cyanide", "itching_powder", "neurotoxin2"), potion_volume)
	return powder

/obj/item/weapon/mortar/proc/check_alchemy(mob/user as mob)
	if(istype(user, /mob/living/carbon))
		var/mob/living/carbon/C = user
		if(C.my_skills.GET_SKILL(SKILL_ALCH))
			return prob(30 * C.my_skills.GET_SKILL(SKILL_ALCH))

	return prob(30)

/obj/item/weapon/mortar/update_icon()
	src.overlays.Cut()
	if(length(contents))
		icon_state = "mortar1"

	else if (powder_contet)
		icon_state = "mortar2"
		var/image/filling = image('icons/obj/chemical.dmi', src, "mortar_o")
		filling.icon += mix_color_from_reagents(powder_contet.reagents.reagent_list)
		overlays += filling

	else
		icon_state = "mortar0"

/obj/item/weapon/pestle
	name = "Pestle"
	desc = "A thing that using in alchemy."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pestle"
	w_class = 1

/obj/item/alchemy_powder
	name = "Unknown powder"
	desc = "A thing that using in alchemy."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "powder"
	w_class = 1

/obj/item/alchemy_powder/New()
	reagents = new/datum/reagents(100)
	..()
/datum/recipe/alchemy //Parent class not for use
	result = /obj/item/alchemy_powder
	var/potion_id

/datum/recipe/alchemy/proc/make_powder(var/obj/container as obj, mob/user as mob)
	var/obj/item/alchemy_powder/powder = new result()
	for (var/obj/O in (container.contents))
		del(O)
	var/potion_volume = 3
	var/alchemy_skill = 0
	if(istype(user, /mob/living/carbon))
		var/mob/living/carbon/C = user
		if(C.my_skills.GET_SKILL(SKILL_ALCH))
			alchemy_skill = C.my_skills.GET_SKILL(SKILL_ALCH)
	if(alchemy_skill)
		potion_volume *= alchemy_skill
	powder.reagents.add_reagent(potion_id, potion_volume)
	for(var/datum/reagent/alchemy/A in powder.reagents.reagent_list)
		A.alchemy_skill = alchemy_skill
	return powder

/datum/recipe/alchemy/hero_drops
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/gryab,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/gryab,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/zheleznyak
	)
	potion_id = "hero_drops"

/datum/recipe/alchemy/blessing_baccus
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/gryab,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/gryab,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/bezglaznik
	)
	potion_id = "blessing_baccus"

/datum/recipe/alchemy/bridge_of_ttf
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/ovrajnik,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/ovrajnik,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/otorvyannik
	)
	potion_id = "bridge_of_ttf"

/datum/recipe/alchemy/impossible_targets
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/zelegreeb,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/zelegreeb,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/krovnik
	)
	potion_id = "impossible_targets"

/datum/recipe/alchemy/thief_friend
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/zelegreeb,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/gryab,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/krovnik
	)
	potion_id = "thief_friend"

/datum/recipe/alchemy/angel_mercy
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/ljutogreeb,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/bezglaznik,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/krovnik
	)
	potion_id = "angel_mercy"

/datum/recipe/alchemy/lucky_shot
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/zelegreeb,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/krovnik,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/krovnik
	)
	potion_id = "lucky_shot"

/datum/recipe/alchemy/rotcleaner
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/barhovik,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/barhovik,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/krovnik
	)
	potion_id = "rotcleaner"

/datum/recipe/alchemy/berserker_sweat
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/bezglaznik,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/bezglaznik,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/bezglaznik
	)
	potion_id = "berserker_sweat"

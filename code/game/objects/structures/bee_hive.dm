/obj/structure/bee_hive
	name = "Bee Hive"
	icon = 'icons/obj/lw_bees.dmi'
	icon_state = "hive1"
	density = TRUE
	var/burned = FALSE
	var/without_honey = FALSE
	var/last_time = 0
	var/honey_time = 6000 //10 min
	var/mob_targeted
	var/mob/living/simple_animal/bee/child_bee
	var/obj/item/weapon/storage/touchable/storage_inside

/obj/structure/bee_hive/New()
	..()
	storage_inside = new /obj/item/weapon/storage/touchable(src)
	last_time = world.time
	new /obj/item/weapon/reagent_containers/food/snacks/honeycomb(src.storage_inside)
	processing_objects.Add(src)

/obj/structure/bee_hive/Destroy()
	qdel(storage_inside)
	processing_objects.Remove(src)
	..()

/obj/structure/bee_hive/process()
	if(storage_inside.contents && without_honey)
		for(var/HC in storage_inside.contents)
			if(istype(HC, /obj/item/weapon/reagent_containers/food/snacks/honeycomb))
				without_honey = FALSE
				break

	else if(!(storage_inside.contents.len))
		without_honey = TRUE

	if(!without_honey)
		if((last_time + honey_time < world.time) && (storage_inside.contents.len < storage_inside.storage_slots))
			new /obj/item/weapon/reagent_containers/food/snacks/honeycomb(src.storage_inside)
			last_time = world.time

		if(!mob_targeted)
			for(var/mob/living/carbon/human/M in view(5, src))
				if(!M.stat && !iszombie(M) && !(M.check_perk(/datum/perk/bee_queen)))
					child_bee = new /mob/living/simple_animal/bee(src.loc)
					child_bee.target_mob = M
					child_bee.hive = src
					mob_targeted = M
					break
	update_icon()

/obj/structure/bee_hive/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = O
		if(F.lit)
			processing_objects.Remove(src)
			burned = TRUE
			without_honey = TRUE
			for(var/obj/item/weapon/reagent_containers/food/snacks/honeycomb/H in storage_inside.contents)
				qdel(H)
				new /obj/item/wax(src.storage_inside)
			update_icon()

	else if(istype(O, /obj/item/wax) && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.check_perk(/datum/perk/bees))
			H.drop_item()
			qdel(O)
			processing_objects.Add(src)
			burned = FALSE
			update_icon()

/obj/structure/bee_hive/attack_hand(mob/living/carbon/human/user as mob)
	storage_inside.orient2hud(user)
	storage_inside.show_to(user)
	..()

/obj/structure/bee_hive/update_icon()
	if(burned) icon_state = "hive2"
	else if(without_honey)	icon_state = "hive0"
	else	icon_state = "hive1"

/obj/item/wax
	name = "wax"
	icon_state = "wax"
	icon = 'icons/obj/lw_bees.dmi'

/obj/item/weapon/reagent_containers/food/snacks/honeycomb
	name = "honeycomb"
	icon_state = "honeycomb"
	icon = 'icons/obj/food.dmi'
	desc = "Dripping with sugary sweetness."
	item_worth = 40
	New()
		..()
		reagents.add_reagent("honey",10)
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("sugar", 5)
		bitesize = 5
	On_Consume()
		..()

/datum/reagent/honey
	name = "Honey"
	id = "honey"
	description = "A golden yellow syrup, loaded with sugary sweetness."
	color = "#FFFF00"

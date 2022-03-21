/obj/item/sea/deadfish
	name = "dead fish"
	icon = 'icons/mining.dmi'
	icon_state = "fishskeleton"

/obj/item/sea/seastar
	name = "sea star"
	icon = 'icons/mining.dmi'
	icon_state = "seastar"

/obj/item/weapon/reagent_containers/food/snacks/fish/New()
	..()
	reagents.add_reagent("nutriment", 8)
	reagents.add_reagent("water", 2)
	bitesize = 5
	life()

/obj/item/weapon/reagent_containers/food/snacks/fish/proc/life()
	while(1)
		sleep(5)
		if(isturf(loc))
			var/turf/simulated/T = src.loc
			if(T:liquid && T:liquid:depth >= 30)
				step(src, pick(NORTH, SOUTH, EAST, WEST))
		continue

/obj/item/weapon/reagent_containers/food/snacks/fish/fish1
	name = "fish"
	icon = 'fish.dmi'
	icon_state = "fish1_l"
	filling_color = "#785210"
	item_worth = 5

/obj/item/weapon/reagent_containers/food/snacks/fish/fish2
	name = "fish"
	icon = 'fish.dmi'
	icon_state = "fish2_l"
	filling_color = "#785210"
	item_worth = 8

/obj/item/weapon/reagent_containers/food/snacks/fish/fish3
	name = "fish"
	icon = 'fish.dmi'
	icon_state = "fish3_l"
	filling_color = "#785210"
	item_worth = 5

/obj/item/weapon/reagent_containers/food/snacks/fish/fish4
	name = "fish"
	icon = 'fish.dmi'
	icon_state = "fish4_l"
	filling_color = "#785210"
	item_worth = 2

/obj/item/weapon/reagent_containers/food/snacks/fish/fish5
	name = "fish"
	icon = 'fish.dmi'
	icon_state = "fish5_l"
	filling_color = "#785210"
	item_worth = 10
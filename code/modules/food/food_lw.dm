/obj/item/weapon/reagent_containers/food/snacks/lw
	On_Consume()
		..()
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.add_event("goodfood", /datum/happiness_event/nutrition/goodfood)

/obj/item/weapon/reagent_containers/food/snacks/lw/bakedpotato
	name = "baked potato"
	icon_state = "bakedpotato"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/lw/steak
	name = "steak"
	icon_state = "steak"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/lw/ratburger
	name = "rat burger"
	icon_state = "ratburger"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/lw/omelette
	name = "omelette"
	icon_state = "omelette"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/lw/fries
	name = "fries"
	icon_state = "fries"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/lw/flatbread
	name = "flatbread"
	icon_state = "flatbread"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/lw/loaf
	name = "loaf"
	icon_state = "loaf4"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 4
	On_Consume()
		..()
		var/totial = bitesize-bitecount
		icon_state = "loaf[totial]"

/obj/item/weapon/reagent_containers/food/snacks/lw/ratburger/cheese
	name = "cheese rat burger"
	icon_state = "cheeseratburger"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/lw/pancake
	name = "pancake"
	icon_state = "pancake"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 3


/obj/item/weapon/reagent_containers/food/snacks/lw/cutlet
	name = "cutlet"
	icon_state = "cutlet4"
	icon = 'icons/obj/cooking.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 4
	On_Consume()
		..()

/obj/item/weapon/reagent_containers/food/snacks/lw/crackers
	name = "crackers"
	icon_state = "cracker5"
	icon = 'icons/obj/food.dmi'
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 5
	On_Consume()
		..()
		var/totial = bitesize-bitecount
		icon_state = "cracker[totial]"
obj/structure/millstone
	name = "millstone"
	icon = 'icons/obj/miscobjs.dmi'
	density = TRUE

	icon_state = "millstone"

obj/structure/millstone/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/weapon/bone))
		user.drop_from_inventory(C)
		qdel(C)
		playsound(src.loc,'sound/webbers/obj_windmill_wheel_lp.ogg', rand(40,50), 0)
		spawn(50)
			new/obj/item/weapon/reagent_containers/food/snacks/bone(src.loc)
			new/obj/item/weapon/reagent_containers/food/snacks/bone(src.loc)
			new/obj/item/weapon/reagent_containers/food/snacks/bone(src.loc)
	if(istype(C, /obj/item/weapon/reagent_containers/food/snacks/grown/sweetpod))
		user.drop_from_inventory(C)
		qdel(C)
		playsound(src.loc,'sound/webbers/obj_windmill_wheel_lp.ogg', rand(40,50), 0)
		spawn(50)
			new/obj/item/weapon/reagent_containers/food/snacks/sugar(src.loc)
			new/obj/item/weapon/reagent_containers/food/snacks/sugar(src.loc)
			new/obj/item/weapon/reagent_containers/food/snacks/sugar(src.loc)

/obj/item/weapon/reagent_containers/food/snacks/bone
	name = "bone powder"
	icon_state = "powder"
	filling_color = "#211F02"
	New()
		..()
		reagents.add_reagent("bone", 4)

/obj/item/weapon/reagent_containers/food/snacks/sugar
	name = "sugar powder"
	icon_state = "sugar"
	filling_color = "#FFC0CB"
	New()
		..()
		reagents.add_reagent("sugar", 4)

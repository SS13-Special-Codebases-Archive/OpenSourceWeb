//soda bomb crafting//
/obj/item/weapon/reagent_containers/food/drinks/cans/attackby(var/obj/item/I, mob/user as mob)
	if((istype(I, /obj/item/device/assembly/igniter) || istype(I, /obj/item/device/assembly/igniter)) && assemblystate == 0)
		assemblystate++
		qdel(I)
		user << "<span class='notice'>You stuff the igniter in the can, emptying the can in process.</span>"
		reagents.clear_reagents()
		canopened = 1
		underlays += image('icons/obj/drinks.dmi', icon_state = "grenade_ing")

	else if(istype(I, /obj/item/stack/cable_coil) && assemblystate == 1)
		var/obj/item/stack/cable_coil/C = I
		if(!C.use(2)) return

		assemblystate++
		user << "<span class='notice'>You wire the igniter.</span>"
		overlays += image('icons/obj/drinks.dmi', icon_state = "grenade_w")
	else ..()

/obj/item/weapon/reagent_containers/food/drinks/cans
	throw_speed = 4
	throw_range = 20
	var/assemblystate = 0
	var/det_time = 50
	var/active = 0



/obj/item/weapon/reagent_containers/food/drinks/cans/proc/try_to_explode()
	active = 0 //So you can reuse your failed bombs

	if(prob(9)) return //This crap just failed!

	var/expl_power = 0
	expl_power += reagents.get_reagent_amount("plasma") / 12.5	//2x power - bomber's choise!

	expl_power += reagents.get_reagent_amount("fuel") / 25		//Regular fuel - like a fuel tank in your hand!

	expl_power += reagents.get_reagent_amount("ethanol") / 25	//get_reagent_amount counts amount by ID, so no beer bombs

	expl_power += reagents.get_reagent_amount("vodka") / 25		//For that badass russians!
																//Maybe it needs ushanka (+1 to expl_power) and soviet uniform (+1 to expl_power) checks?

	expl_power = round(expl_power, 1)

	if(prob(3)) expl_power = min(expl_power - 1, 0) //Shit happens. Still better than nothing.

	if(expl_power)
		explosion(src.loc,-1,expl_power - 2, expl_power)
		qdel(src)
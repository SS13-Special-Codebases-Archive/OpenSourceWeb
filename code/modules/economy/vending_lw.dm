/obj/machinery/food_machine
	name = "Food Machine"
	desc = ""
	icon = 'icons/obj/vending.dmi'
	icon_state = "xneosnack"
	var/normal_state = "xneosnack"
	var/broken_state = "xneosnack0"
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	var/screenbroken = FALSE
	pixel_y = 26
	plane = 21

/obj/machinery/food_machine/New()
	set_light(2, 3, 2.8, 1, "#c95f5b")
	..()

/obj/machinery/food_machine/attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
	var/obj/item/weapon/spacecash/CA = I
	if(istype(CA,/obj/item/weapon/spacecash))
		if(CA.worth < 10)
			to_chat(user, "I need 10 obols.")
		else if(CA.worth > 10)
			to_chat(user, "I have more than 10 obols.")
		else if(CA.worth == 10)
			qdel(CA)
			playsound(src.loc, 'sound/machines/coin_ins.ogg', 30, 0)
			var/obj/item/weapon/reagent_containers/food/snacks/candy/C = new (user.loc)
			C.name = "candy"
			supply_shuttle.points += 5
		else
			to_chat(user,"This isn't working for it.")
	if(istype(I, /obj/item/coupon/food))
		qdel(I)
		playsound(src.loc, 'sound/machines/coin_ins.ogg', 30, 0)
		var/obj/item/weapon/reagent_containers/food/snacks/candy/C = new (user.loc)
		C.name = "candy"
/obj/machinery/onion
	name = "ONION"
	desc = "<font color = 'green'><b>--PRICES--</b> \n Mini-UZI - 350 Obols \n Magazine (.45) - 25 Obols \n Knife - 15 Obols \n Grenade - 80 Obols \n Cigarrete Pack - 20 Obols \n Zippo - 10 Obols \n Mini-Pistol - 80 Obols \n 9mm Magazine - 25 Obols\n</font>"
	icon = 'vending.dmi'
	icon_state = "onion"
	var/obols = 20
	var/product
	anchored = 1

/obj/machinery/onion/New()
	set_light(2, 2, 2.8, 1, "#5bc978")
	..()

/obj/machinery/onion/attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
	if(istype(I,/obj/item/weapon/spacecash))
		src.obols += I:worth
		qdel(I)
		playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)

/obj/machinery/onion/RightClick(mob/living/carbon/human/user as mob)
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
	if(src.obols)
		to_chat(user, "<i>The ONION has [src.obols] obols.</i>")
		var/withdraw = input("How much you want to withdraw | There is [src.obols] obols on the ONION.","ONION",src.obols)
		if(!withdraw)
			return
		if(withdraw > src.obols)
			to_chat(user, "There's not enough obols to withdraw that amount!")
		if(withdraw < 0)
			to_chat(user, "negro nem tente")
			usr << 'olha-o-macaco.ogg'
			return
		if(withdraw <= src.obols)
			to_chat(user, "<i>You withdraw [withdraw] from the ONION.</i>")
			playsound(src.loc, 'sound/effects/coin_m.ogg', 30, 0)
			spawn_money(withdraw,user.loc)
			src.obols -= withdraw

/obj/machinery/onion/attack_hand(mob/living/carbon/human/user as mob)
	if(!user.wear_id)
		usr << "I don't have a ring, I can't use the ONION!"
		return
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
	if(src.obols)
		usr << "<i>The ONION has [src.obols] obols.</i>"
	src.product = input("Select a product / [src.obols] obols left on the machine..","ONION",src.product) in list("Mini-UZI", "Magazine (.45)", "Knife","Grenade","Cigarrete Pack","Zippo","Mini-Pistol","9mm Magazine","Cancel")
	switch(src.product)
		if("Mini-UZI")
			var/price = 400
			var/product_path = /obj/item/weapon/gun/projectile/automatic/mini_uzi
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Karek Magazine (.380)")
			var/price = 35
			var/product_path = /obj/item/ammo_magazine/external/uzi380
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Knife")
			var/price = 15
			var/product_path = /obj/item/weapon/kitchen/utensil/knife
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Grenade")
			var/price = 100
			var/product_path = /obj/item/weapon/grenade/syndieminibomb/frag
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Cigarrete Pack")
			var/price = 20
			var/product_path = /obj/item/weapon/storage/fancy/cigarettes
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Zippo")
			var/price = 15
			var/product_path = /obj/item/weapon/flame/lighter/zippo
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Mini-Pistol")
			var/price = 90
			var/product_path = /obj/item/weapon/gun/projectile/automatic/pistol/ml23
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("9mm Magazine")
			var/price = 25
			var/product_path = /obj/item/ammo_magazine/external/mc9mm
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Cancel")
			return

/obj/machinery/innkeeper_terminal
	name = "Kitchen Terminal"
	desc = "<font color = 'green'><b>--PRICES--</b> \n Wine - 60 Obols \n Beer - 20 Obols \n Knife - 15 Obols \n Cognac - 40 Obols \n Milk - 20 Obols \n Rum - 30 Obols \n Vodka - 35 Obols</font>"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "heretic"
	var/obols = 20
	var/product

/obj/machinery/innkeeper_terminal/New()
	set_light(2, 2, 2.8, 1, "#5bc978")
	..()

/obj/machinery/innkeeper_terminal/attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
	if(istype(I,/obj/item/weapon/spacecash))
		src.obols += I:worth
		qdel(I)
		playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)

/obj/machinery/innkeeper_terminal/RightClick(mob/living/carbon/human/user as mob)
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
	if(src.obols)
		to_chat(user,"<i>The terminal has [src.obols] obols.</i>")
		var/withdraw = input("How much you want to withdraw | There is [src.obols] obols on the terminal.","terminal",src.obols)
		if(!withdraw)
			return
		if(withdraw > src.obols)
			to_chat(user, "There's not enough obols to withdraw that amount!")
		if(withdraw < 0)
			to_chat(user, "negro nem tente")
			usr << 'olha-o-macaco.ogg'
			return
		if(withdraw <= src.obols)
			to_chat(user,"<i>You withdraw [withdraw] from the terminal.</i>")
			playsound(src.loc, 'sound/effects/coin_m.ogg', 30, 0)
			spawn_money(withdraw,user.loc)
			src.obols -= withdraw

/obj/machinery/innkeeper_terminal/attack_hand(mob/living/carbon/human/user as mob)
	if(!user.wear_id)
		to_chat(user, "I don't have a ring, I can't use the [src]!")
		return
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
	if(src.obols)
		to_chat(user, "<i>The [src] has [src.obols] obols.</i>")
	src.product = input("Select a product / [src.obols] obols left in the machine.","[src]",src.product) in list("Wine", "Beer", "Knife","Cognac","Milk","Rum","Vodka","Cancel")
	switch(src.product)
		if("Wine")
			var/price = 60
			var/product_path = /obj/item/weapon/reagent_containers/glass/bottle/wine
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Beer")
			var/price = 20
			var/product_path = /obj/item/weapon/reagent_containers/glass/bottle/beer
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Cognac")
			var/price = 40
			var/product_path = /obj/item/weapon/reagent_containers/glass/bottle/cognac
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Milk")
			var/price = 20
			var/product_path = /obj/item/weapon/reagent_containers/food/drinks/milk
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Rum")
			var/price = 30
			var/product_path = /obj/item/weapon/reagent_containers/glass/bottle/rum
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Vodka")
			var/price = 35
			var/product_path = /obj/item/weapon/reagent_containers/glass/bottle/vodka
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user,"I can't afford it, [product] costs [price] obols!")
		if("Cancel")
			return

/obj/machinery/common_vendor
	name = "Vendor"
	desc = "<font color = 'green'><b>--PRICES--</b> \n  Bandages - 5 Obols \n Cigarrete - 5 Obols \n Lighter - 12 Obols \n Cigarrete Pack - 30 Obols</font>"
	icon = 'icons/obj/vending.dmi'
	icon_state = "snack"
	var/obols = 20
	var/product

/obj/machinery/common_vendor/New()
	set_light(2, 2, 2.8, 1, "#5bc978")
	..()

/obj/machinery/common_vendor/attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
	if(istype(I,/obj/item/weapon/spacecash))
		src.obols += I:worth
		qdel(I)
		playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)

/obj/machinery/common_vendor/RightClick(mob/living/carbon/human/user as mob)
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
	if(src.obols)
		usr << "<i>The [src] has [src.obols] obols.</i>"
		var/withdraw = input("How much you want to withdraw | There is [src.obols] obols on the [src].","[src]",src.obols)
		if(!withdraw)
			return
		if(withdraw < 0)
			usr << "negro nem tente"
			usr << 'olha-o-macaco.ogg'
			return
		if(withdraw > src.obols)
			usr << "There's not enough obols to withdraw that amount!"
		if(withdraw <= src.obols)
			usr << "<i>You withdraw [withdraw] from the [src].</i>"
			playsound(src.loc, 'sound/effects/coin_m.ogg', 30, 0)
			spawn_money(withdraw,user.loc)
			src.obols -= withdraw

/obj/machinery/common_vendor/attack_hand(mob/living/carbon/human/user as mob)
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
	if(src.obols)
		usr << "<i>The [src] has [src.obols] obols.</i>"
	src.product = input("Select a product / [src.obols] obols left in the machine.","[src]",src.product) in list("Bandages", "Cigarrete", "Lighter","Cigarrete Pack","Cancel")
	switch(src.product)
		if("Bandages")
			var/price = 5
			var/product_path = /obj/item/stack/medical/bruise_pack
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user, "I can't afford it, [product] costs [price] obols!")
		if("Cigarrete")
			var/price = 5
			var/product_path = /obj/item/clothing/mask/cigarette
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user, "I can't afford it, [product] costs [price] obols!")
		if("Lighter")
			var/price = 12
			var/product_path = /obj/item/weapon/flame/lighter
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user, "I can't afford it, [product] costs [price] obols!")
		if("Cigarrete Pack")
			var/price = 30
			var/product_path = /obj/item/weapon/storage/fancy/cigarettes
			if(src.obols >= price)
				to_chat(user, "You bought the [product]")
				src.obols -= price
				new product_path(user.loc)
			else
				to_chat(user, "I can't afford it, [product] costs [price] obols!")
		if("Cancel")
			return
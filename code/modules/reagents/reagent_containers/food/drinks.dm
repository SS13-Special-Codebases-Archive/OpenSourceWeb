////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks.dmi'
	icon_state = null
	drop_sound = 'drop_glass.ogg'
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	var/gulp_size = 5 //This is now officially broken ... need to think of a nice way to fix it.
	possible_transfer_amounts = list(5,10,25)
	volume = 50
	var/smerd = 1

	on_reagent_change()
		if (gulp_size < 5) gulp_size = 5
		else gulp_size = max(round(reagents.total_volume / 5), 5)

	attack_self(mob/user as mob)
		return

	attack(mob/M as mob, mob/user as mob, def_zone)
		var/datum/reagents/R = src.reagents
		var/fillevel = gulp_size

		if(!R.total_volume || !R)
			to_chat(user, "<span class='combatbold'>None of [src] left, oh no!</span>")
			return 0

		if(!canconsume(M, user))
			return 0

		if(M == user)
			if (M.zone_sel.selecting == "mouth")
				to_chat(M, "<span class='passive'>You swallow a gulp of [src].</span>")
				if(reagents.total_volume)
					reagents.reaction(M, INGEST)
					spawn(5)
						reagents.trans_to(M, gulp_size)
			else
				to_chat(M, "<span class='combatbold'>I can't use that, I must drink it with my mouth.</span>")
				return 0
			if(ishuman(M))
				var/mob/living/carbon/human/HH = M
				if(HH.royalty)
					if(smerd)
						HH.add_event("royalty", /datum/happiness_event/misc/realcup)
			playsound(M.loc,pick('glass_drink1.ogg','glass_drink2.ogg','glass_drink3.ogg','glass_drink4.ogg','glass_drink5.ogg'), rand(50,60), 0)
			return 1

		else if( istype(M, /mob/living/carbon/human) )

			for(var/mob/O in viewers(world.view, user))
				O.show_message("<span class='combatbold'>[user]</span> <span class='combat'>attempts to feed</span> <span class='combatbold'>[M]</span> <span class='combat'>[src].</span>", 1)
			if(!do_mob(user, M)) return
			for(var/mob/O in viewers(world.view, user))
				O.show_message("<span class='combatbold'>[user]</span> <span class='combat'>feeds</span> <span class='combatbold'>[M]</span> <span class='combat'>[src].</span>", 1)

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>")
			log_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents?.trans_to(M, gulp_size)

			if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
				var/mob/living/silicon/robot/bro = user
				bro.cell.use(30)
				var/refill = R.get_master_reagent_id()
				spawn(600)
					R.add_reagent(refill, fillevel)

			playsound(M.loc,pick('glass_drink1.ogg','glass_drink2.ogg','glass_drink3.ogg','glass_drink4.ogg','glass_drink5.ogg'), rand(50,60), 0)
			return 1

		return 0


	afterattack(obj/target, mob/user, proximity)
		if(!proximity) return

		if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "\blue You fill [src] with [trans] units of the contents of [target]."

		else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
			if(!reagents.total_volume)
				user << "\red [src] is empty."
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return



			var/datum/reagent/refill
			var/datum/reagent/refillName
			if(isrobot(user))
				refill = reagents.get_master_reagent_id()
				refillName = reagents.get_master_reagent_name()

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the solution to [target]."

			if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
				var/mob/living/silicon/robot/bro = user
				var/chargeAmount = max(30,4*trans)
				bro.cell.use(chargeAmount)
				user << "Now synthesizing [trans] units of [refillName]..."


				spawn(300)
					reagents.add_reagent(refill, trans)
					user << "Cyborg [src] refilled."

		return

	examine()
		set src in view()
		..()
		if (!(usr in range(0)) && usr!=src.loc) return
		if(!reagents || reagents.total_volume==0)
			usr << "\blue \The [src] is empty!"
		else if (reagents.total_volume<=src.volume/4)
			usr << "\blue \The [src] is almost empty!"
		else if (reagents.total_volume<=src.volume*0.66)
			usr << "\blue \The [src] is half full!"
		else if (reagents.total_volume<=src.volume*0.90)
			usr << "\blue \The [src] is almost full!"
		else
			usr << "\blue \The [src] is full!"


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = 4
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	flags = FPRINT | CONDUCT | TABLEPASS | OPENCONTAINER

/obj/item/weapon/reagent_containers/food/drinks/golden_cup/tournament_26_06_2011
	desc = "A golden cup. It will be presented to a winner of tournament 26 june and name of the winner will be graved on it."


///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/weapon/reagent_containers/food/drinks/milk
	name = "milk"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"
	New()
		..()
		reagents.add_reagent("milk", 50)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon = 'icons/obj/cooking.dmi'
	icon_state = "flour"
	item_state = "flour"
	New()
		..()
		reagents.add_reagent("flour", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/soymilk
	name = "SoyMilk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	New()
		..()
		reagents.add_reagent("soymilk", 50)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/coffee
	name = "Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	New()
		..()
		reagents.add_reagent("coffee", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/tea
	name = "Duke Purple Tea"
	desc = "An insult to Duke Purple is an insult to the Space Queen! Any proper gentleman will fight you, if you sully this tea."
	icon_state = "teacup"
	item_state = "coffee"
	New()
		..()
		reagents.add_reagent("tea", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/ice
	name = "Ice Cup"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"
	New()
		..()
		reagents.add_reagent("ice", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate
	name = "Dutch Hot Coco"
	desc = "Made in Space South America."
	icon_state = "hot_coco"
	item_state = "coffee"
	New()
		..()
		reagents.add_reagent("hot_coco", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/dry_ramen
	name = "Cup Ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	New()
		..()
		reagents.add_reagent("dry_ramen", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)


/obj/item/weapon/reagent_containers/food/drinks/sillycup
	name = "Paper Cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	New()
		..()
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)
	on_reagent_change()
		if(reagents.total_volume)
			icon_state = "water_cup"
		else
			icon_state = "water_cup_e"


//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/weapon/reagent_containers/food/drinks/shaker
	name = "Shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 100

/obj/item/weapon/reagent_containers/glass/flask
	name = "flask"
	desc = "A metal flask."
	icon_state = "flask"
	volume = 60
	smerd = FALSE

/obj/item/weapon/reagent_containers/glass/flask/inkvd
	name = "INKVD's Flask"
	desc = "A steel flask belonging to the inquisitor"
	icon_state = "inkvdflask"
	volume = 60
	smerd = FALSE

/obj/item/weapon/reagent_containers/glass/flask/detflask
	name = "Detective's Flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60

/obj/item/weapon/reagent_containers/glass/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60

/obj/item/weapon/reagent_containers/glass/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60

/obj/item/weapon/reagent_containers/food/drinks/mug/britcup
	name = "cup"
	desc = "A cup with the British flag emblazoned on it."
	icon_state = "britcup"
	volume = 30

/obj/item/weapon/reagent_containers/glass/wood
	name = "wooden mug"
	desc = "A homemade mug."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "wooden"
	volume = 30
	drop_sound = 'woodmugtable.ogg'
	smerd = 1

	update_icon()
		overlays.Cut()

		if(reagents.total_volume)
			var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

			var/percent = round((reagents.total_volume / volume) * 100)
			switch(percent)
				if(0 to 9) 	filling.icon_state = "[icon_state]10"
				if(10 to 24)	filling.icon_state = "[icon_state]25"
				if(25 to 49)	filling.icon_state = "[icon_state]50"
				if(50 to 74)	filling.icon_state = "[icon_state]75"
				if(75 to 90)	filling.icon_state = "[icon_state]80"
				if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

			filling.icon += mix_color_from_reagents(reagents.reagent_list)
			overlays += filling


/obj/item/weapon/reagent_containers/glass/goblet/silver
	name = "silver goblet"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "goblet_silver"
	volume = 30
	drop_sound = 'woodmugtable.ogg'
	item_worth = 20
	smerd = FALSE
	silver = TRUE

	update_icon()
		overlays.Cut()

		if(reagents.total_volume)
			var/image/filling = image('icons/obj/reagentfillings.dmi', src, "goblet10")

			var/percent = round((reagents.total_volume / volume) * 100)
			switch(percent)
				if(0 to 9) 	filling.icon_state = "goblet10"
				if(10 to 24)	filling.icon_state = "goblet25"
				if(25 to 49)	filling.icon_state = "goblet50"
				if(50 to 74)	filling.icon_state = "goblet75"
				if(75 to 90)	filling.icon_state = "goblet80"
				if(91 to INFINITY)	filling.icon_state = "goblet100"

			filling.icon += mix_color_from_reagents(reagents.reagent_list)
			overlays += filling


/obj/item/weapon/reagent_containers/glass/goblet/gold
	name = "gold goblet"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "goblet_gold"
	volume = 30
	drop_sound = 'woodmugtable.ogg'
	item_worth = 50
	smerd = FALSE

/obj/item/weapon/reagent_containers/glass/skull
	name = "skull cup"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "skullcup"
	volume = 30
	drop_sound = 'bone_drop.ogg'
	item_worth = 5

	update_icon()
		overlays.Cut()

		if(reagents.total_volume)
			var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]33")

			var/percent = round((reagents.total_volume / volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "[icon_state]33"
				if(10 to 19) 	filling.icon_state = "[icon_state]66"
				if(20 to INFINITY)	filling.icon_state = "[icon_state]100"

			filling.icon += mix_color_from_reagents(reagents.reagent_list)
			overlays += filling

/obj/item/weapon/reagent_containers/food/drinks/mug
	name = "cup"
	icon = 'icons/obj/cup.dmi'
	icon_state = "big"
	item_state = "coffee"

	mesa/icon_state = "mesa"
	lambda/icon_state = "lambda"
	nt/icon_state = "nt"
	power_b
		icon_state = "power_b"
		desc = "It has some words written on it 'Goodnight, sweet prince'"
	power_y
		icon_state = "power_y"
		desc = "property of Abu"
	med/icon_state = "med"
	med_b/icon_state = "med_b"
	soviet/icon_state = "soviet"
	creeper/icon_state = "creeper"
	cult/icon_state = "cult"
	no1/icon_state = "no1"
	death/icon_state = "death"
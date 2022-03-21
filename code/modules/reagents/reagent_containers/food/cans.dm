/obj/item/weapon/reagent_containers/food/drinks/cans
	var/canopened = 0

	attack_self(mob/user as mob)
		if (canopened == 0)
			playsound(src.loc,'sound/effects/canopen.ogg', rand(10,50), 1)
			to_chat(user, "<span class='passive'>You open the drink with an audible pop!</span>")
			canopened = 1
		else
			if(assemblystate == 2 && !active)
				to_chat(user, "<span class='passive>You turn on the [name]!</span>")
				active = 1

				det_time = rand(30,80)
				if(prob(1))
					det_time = 5 //Poor guy!
				else if(prob(4))
					det_time = 140 //This crap just fail- BOOM!

				if(iscarbon(user))
					var/mob/living/carbon/C = user
					C.throw_mode_on()
				spawn(det_time)
					try_to_explode()
			else ..()

	attack(mob/M as mob, mob/user as mob, def_zone)
		if (canopened == 0)
			to_chat(user, "<span class='passive'> You need to open the drink!</span>")
			return
		var/datum/reagents/R = src.reagents
		var/fillevel = gulp_size

		if(!R.total_volume || !R)
			to_chat(user, "<span class='passivebold'>None of [src] left, oh no!</span>")
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
				to_chat(M, "<span class='combat'>I can't use that, I must drink it with my mouth.</span>")
				return 0

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
					reagents.trans_to(M, gulp_size)

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

/*	examine()
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
			usr << "\blue \The [src] is full!"*/


//DRINKS

/obj/item/weapon/reagent_containers/food/drinks/cans/cola
	name = "Space Cola"
	desc = "Cola. in space."
	icon_state = "cola"
	New()
		..()
		reagents.add_reagent("cola", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	New()
		..()
		reagents.add_reagent("spacemountainwind", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko
	name = "Thirteen Loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	New()
		..()
		reagents.add_reagent("thirteenloko", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb
	name = "Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	New()
		..()
		reagents.add_reagent("dr_gibb", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/cans/starkist
	name = "Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"
	New()
		..()
		reagents.add_reagent("cola", 15)
		reagents.add_reagent("orangejuice", 15)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/cans/space_up
	name = "Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	New()
		..()
		reagents.add_reagent("space_up", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/cans/lemon_lime
	name = "Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	New()
		..()
		reagents.add_reagent("lemon_lime", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea
	name = "Vrisk Serket Iced Tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	New()
		..()
		reagents.add_reagent("icetea", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice
	name = "Grapel Juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "purple_can"
	New()
		..()
		reagents.add_reagent("grapejuice", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/cans/tonic
	name = "T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	New()
		..()
		reagents.add_reagent("tonic", 50)

/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater
	name = "Soda Water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	New()
		..()
		reagents.add_reagent("sodawater", 50)
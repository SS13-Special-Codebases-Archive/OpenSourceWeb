/obj/machinery/slotmachine
	name = "\improper One-Armed Migrant"
	desc = "Get stupid and win big prizes."
	icon = 'icons/obj/gamble.dmi'
	icon_state = "slotmachine"
	anchored = 1
	density = 1
	var/rolling = 0
	var/storedcash = 0 // money in the machine
	var/list/loser_list = list("Hard luck!","Try again!","Better luck next time!","Close one!")
	var/list/reels = list(5, 5, 5)


/obj/machinery/slotmachine/New()
	..()
	for(var/i=1, i <= length(reels), i++)
		reels[i] = rand(1,5)
	update_icon()

/obj/machinery/slotmachine/attackby(obj/item/I as obj, mob/user as mob)
	if(rolling)
		return
	if(istype(I,/obj/item/weapon/spacecash))
		src.storedcash += I:worth
		to_chat(user, "You insert [I] into [src].")
		playsound(src.loc, 'sound/effects/moeda.ogg', 100, 1, -5)
		qdel(I)

/obj/machinery/slotmachine/attack_hand(mob/living/user as mob)
	if(rolling)
		return
	if(storedcash > 0)
		spin()

/obj/machinery/slotmachine/update_icon()
	underlays.Cut() // underlays are barely used in baycode, why not?
	underlays += image("[reels[1]]", pixel_x = 2, pixel_y = 17)
	underlays += image("[reels[2]]", pixel_x = 11, pixel_y = 17)
	underlays += image("[reels[3]]", pixel_x = 20, pixel_y = 17)


/obj/machinery/slotmachine/proc/spin(mob/user)
	usr.visible_message("<span class='passive'>[user] pulls the handle of the slot machine.</span>", "<span class='passive'>You pull the handle of the slot machine.</span>", "You hear the various dings of a slot machine.")
	playsound(src.loc, 'sound/effects/gamble/slots_spin.ogg', 50, 1)
	rolling = 1
	spawn(30)
		rolling = 0

	while(rolling)
		for(var/i=1, i <= length(reels), i++)
			reels[i] = rand(1,5)
		update_icon()
		sleep(2)

	if(!rolling)
		for(var/i=1, i <= length(reels), i++)
			reels[i] = rand(1, 5)
			playsound(src.loc, 'sound/effects/gamble/slots_slot_stop1.ogg', 50, 1)
			update_icon()
			sleep(3)

	win_prize()

/obj/machinery/slotmachine/proc/win_prize()

	if((reels[1] == 1 && reels[2] == 1) || (reels[2] == 1 && reels[3] == 1)) // 2 heart
		spawn_money(storedcash*= 1,src.loc)
		storedcash = 0
		playsound(src.loc, 'sound/effects/gamble/slots_victory.ogg', 50, 1)
		src.fakesay("Free return! Try again!", say_verb = "beeps")
	else if(reels[1] == 1 && reels[2] == 1 && reels[3] == 1) // 3 heart
		spawn_money(storedcash*= 1.5,src.loc)
		storedcash = 0
		playsound(src.loc, 'sound/effects/gamble/slots_victory.ogg', 50, 1)
		src.fakesay("Winner!", say_verb = "beeps")

	else if(reels[1] == 2 && reels[2] == 2 && reels[3] == 2) // 3 cross
		spawn_money(storedcash*= 2,src.loc)
		storedcash = 0
		playsound(src.loc, 'sound/effects/gamble/slots_victory.ogg', 50, 1)
		src.fakesay("Winner!", say_verb = "beeps")
	else if(reels[1] == 3 && reels[2] == 3 && reels[3] == 3) // 3 gold
		spawn_money(storedcash*= 2.5,src.loc)
		storedcash = 0
		playsound(src.loc, 'sound/effects/gamble/slots_victory_big.ogg', 50, 1)
		src.fakesay("Big Winner!", say_verb = "beeps")

	else if(reels[1] == 4 && reels[2] == 4 && reels[3] == 4) // 3 face (skinless?)
		spawn_money(storedcash*= 3,src.loc)
		storedcash = 0
		playsound(src.loc, 'sound/effects/gamble/slots_victory_big.ogg', 50, 1)
		src.fakesay("Big Winner!", say_verb = "beeps")

	else if(reels[1] == 5 && reels[2] == 5 && reels[3] == 5) // 3 eagle (god save ravenheart)
		spawn_money(storedcash*= 4,src.loc)
		storedcash = 0
		playsound(src.loc, 'sound/effects/gamble/slots_victory_big.ogg', 50, 1)
		src.fakesay("JACKPOT!", say_verb = "beeps")

	else
		var/loser = pick(src.loser_list)
		src.fakesay(loser, say_verb = "beeps")
		playsound(src.loc, 'sound/effects/gamble/slots_lose.ogg', 50, 1)
		storedcash = 0
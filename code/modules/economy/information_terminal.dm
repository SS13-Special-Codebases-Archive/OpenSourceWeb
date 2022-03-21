
/obj/machinery/information_terminal
	name = "Information Terminal"
	desc = ""
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	var/normal_state = "atm"
	var/hacked_state = "hackedatm"
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	density = 0
	var/hacked = FALSE
	var/KILLSOMEONE = ""
	var/screenbroken = FALSE
	var/obols = 0
	var/product = null
	var/obol_type = "copper"
	var/whois = null
	var/list/announces = list()
	plane = 21

/obj/machinery/information_terminal/south
	pixel_y = -32
	New()
		..()
		var/matrix/M = matrix()
		M.Turn(180)
		src.transform = M

/obj/machinery/information_terminal/north
	pixel_y = 32

/obj/machinery/information_terminal/east
	pixel_x = 32
	New()
		..()
		var/matrix/M = matrix()
		M.Turn(90)
		src.transform = M

/obj/machinery/information_terminal/west
	pixel_x = -32
	New()
		..()
		var/matrix/M = matrix()
		M.Turn(-90)
		src.transform = M

/obj/machinery/information_terminal/New()
	set_light(3, 2, "#c0eaeb")
	vending_list.Add(src)
	repeat_announces()
	var/image/overlay = image('icons/obj/terminals.dmi',"opublic")
	overlay.plane = 21
	overlays += overlay
	..()

/obj/machinery/information_terminal/proc/repeat_announces()
	INICIO
	spawn(100)
		if(!length(announces))
			goto INICIO
			return
		var/lastannounce = announces[length(announces)]
		if(lastannounce)
			spawn(rand(600,3000))
				src.visible_message("<span class='examinebold'>\[Information Terminal\]</span> <span class='examine'>\'[lastannounce]\'</span>", 1)
				goto INICIO

/obj/machinery/information_terminal/proc/pusherize()
	src.screenbroken = TRUE
	src.icon_state = "pusheratm"
	src.overlays.Cut()
	var/image/overlay = image('icons/obj/terminals.dmi',"opublic2")
	overlay.plane = 21
	overlays += overlay
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.job == "Pusher")
			KILLSOMEONE = H.real_name

/obj/machinery/information_terminal/proc/despusherize()
	src.screenbroken = FALSE
	src.icon_state = "atm"
	src.overlays.Cut()
	var/image/overlay = image('icons/obj/terminals.dmi',"opublic")
	overlay.plane = 21
	overlays += overlay

/obj/machinery/information_terminal/MiddleClick(mob/living/carbon/human/user as mob)
	if(screenbroken && whois)
		to_chat(user, "I CANT I MUST KILL [whois]!")
		return
	if(!user.wear_id)
		to_chat(usr, "I don't have a ring, I can't use the terminal!")
		return
	if(screenbroken)
		to_chat(usr, "It's broken, I can't use the terminal.")
		return
	if(user.religion == "Thanati")
		playsound(src.loc, 'sound/effects/zzzt.ogg', 100, 1, -5)
		src.visible_message("\red <B>[user] hacks the terminal!</B>", 1)
		if(hacked)
			hacked = FALSE
			icon_state = normal_state

			src.overlays.Cut()
			var/image/overlay = image('icons/obj/terminals.dmi',"opublic")
			overlay.plane = 21
			overlays += overlay

		else
			hacked = TRUE
			icon_state = hacked_state
			src.overlays.Cut()
			var/image/overlay = image('icons/obj/terminals.dmi',"opublic3")
			overlay.plane = 21
			overlays += overlay
	else
		to_chat(usr, "I don't know how to fix this.")

/obj/machinery/information_terminal/attack_hand(mob/living/carbon/human/user as mob)
	var/obj/item/weapon/card/id/idcard = user.wear_id
	var/id_money = idcard.money_account.get_money()
	if(screenbroken)
		var/symb1 = ionnum()
		var/symb2 = ionnum()
		if(user.check_perk(/datum/perk/illiterate))
			to_chat(usr, "<B>[symb1] [symb2]</B>")
		else
			to_chat(usr, "<B>[symb1] KILL [KILLSOMEONE] [symb2]</B>")
		return
	if(!user.wear_id)
		to_chat(usr, "I don't have a ring, I can't use the terminal!")
		return
	if(hacked)
		playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 100, 0, -5)
		var/thanet_text = "Select a product / [id_money] obols left in the ring."
		if(user.check_perk(/datum/perk/illiterate))
			thanet_text = Illiterate(thanet_text,100)
		src.product = input(thanet_text,"THANET",src.product) in list("Mini-UZI", "Magazine (.45)", "Dagger","Grenade","Double-Barrel Shotgun","Shotgun Shell", "TNT Bundle", "TNT Stick","Cancel")
		var/treasury = treasuryworth.get_money()
		switch(src.product)
			if("Karek R90")
				var/price = 320
				var/product_path = /obj/item/weapon/gun/projectile/automatic/mini_uzi
				if(id_money >= price && price <= treasury)
					to_chat(usr, "You bought the [product]")
					if(idcard.money_account != treasuryworth)
						idcard.money_account.add_money(-price)
					treasuryworth.add_money(-price)
					new product_path(user.loc)
				else
					to_chat(usr, "I can't afford it, [product] costs [price] obols!")
			if("TNT Bundle")
				if(world.time < 1)
					to_chat(usr, "<span class='passive'>It's too early for buying.,It will be available in [round((6000-world.time)/600)] minutes.</span>")
					return 0
				var/price = 950
				var/product_path = /obj/item/weapon/flame/candle/tnt/bundle
				if(id_money >= price && price <= treasury)
					to_chat(usr, "You bought the [product]")
					if(idcard.money_account != treasuryworth)
						idcard.money_account.add_money(-price)
					treasuryworth.add_money(-price)
					new product_path(user.loc)
				else
					to_chat(usr, "I can't afford it, [product] costs [price] obols!")
			if("TNT Stick")
				if(world.time < 1)
					to_chat(usr, "<span class='passive'>It's too early for buying.,It will be available in [round((6000-world.time)/600)] minutes.</span>")
					return 0
				var/price = 95
				var/product_path = /obj/item/weapon/flame/candle/tnt/stick
				if(id_money >= price && price <= treasury)
					to_chat(usr, "You bought the [product]")
					if(idcard.money_account != treasuryworth)
						idcard.money_account.add_money(-price)
					treasuryworth.add_money(-price)
					new product_path(user.loc)
				else
					to_chat(usr, "I can't afford it, [product] costs [price] obols!")
			if("Karek Magazine (.380)")
				var/price = 25
				var/product_path = /obj/item/ammo_magazine/external/uzi380
				if(id_money >= price && price <= treasury)
					to_chat(usr, "You bought the [product]")
					if(idcard.money_account != treasuryworth)
						idcard.money_account.add_money(-price)
					treasuryworth.add_money(-price)
					new product_path(user.loc)
				else
					to_chat(usr, "I can't afford it, [product] costs [price] obols!")
			if("Dagger")
				var/price = 15
				var/product_path = /obj/item/weapon/kitchen/utensil/knife/dagger
				if(id_money >= price && price <= treasury)
					to_chat(usr, "You bought the [product]")
					if(idcard.money_account != treasuryworth)
						idcard.money_account.add_money(-price)
					treasuryworth.add_money(-price)
					new product_path(user.loc)
				else
					to_chat(usr, "I can't afford it, [product] costs [price] obols!")
			if("C-4")
				var/price = 200
				var/product_path = /obj/item/weapon/plastique/thanati
				if(id_money >= price && price <= treasury)
					to_chat(usr, "You bought the [product]")
					if(idcard.money_account != treasuryworth)
						idcard.money_account.add_money(-price)
					treasuryworth.add_money(-price)
					new product_path(user.loc)
				else
					to_chat(usr, "I can't afford it, [product] costs [price] obols!")
			if("Grenade")
				var/price = 80
				var/product_path = /obj/item/weapon/grenade/syndieminibomb/frag
				if(id_money >= price && price <= treasury)
					to_chat(usr, "You bought the [product]")
					if(idcard.money_account != treasuryworth)
						idcard.money_account.add_money(-price)
					treasuryworth.add_money(-price)
					new product_path(user.loc)
				else
					to_chat(usr, "I can't afford it, [product] costs [price] obols!")
			if("Double-Barrel Shotgun")
				var/price = 150
				var/product_path = /obj/item/weapon/gun/projectile/newRevolver/duelista/doublebarrel/sawnOff
				if(id_money >= price && price <= treasury)
					to_chat(usr, "You bought the [product]")
					if(idcard.money_account != treasuryworth)
						idcard.money_account.add_money(-price)
					treasuryworth.add_money(-price)
					new product_path(user.loc)
				else
					to_chat(usr, "I can't afford it, [product] costs [price] obols!")
			if("Shotgun Shell")
				var/price = 5
				var/product_path = /obj/item/stack/bullets/buckshot
				if(id_money >= price && price <= treasury)
					to_chat(usr, "You bought the [product]")
					if(idcard.money_account != treasuryworth)
						idcard.money_account.add_money(-price)
					treasuryworth.add_money(-price)
					new product_path(user.loc)
				else
					to_chat(usr, "I can't afford it, [product] costs [price] obols!")
			if("Cancel")
				return
		log_game("[usr.real_name]([usr.key]) has bought a [product] from an info terminal.")
	else if(user.check_perk(/datum/perk/illiterate))
		to_chat(usr, "<span class='combatbold'>I CAN'T READ!!!</span>")
	else
		var/msg = "<div class='firstdivskill'><div class='skilldiv'><hr class='linexd'>"
		msg += "[id_money ? "<span class='passive'>" : "<span class='combat'>"]• <b>Balance</b>: [id_money]</span>\n"
		msg += "[taxes ? "<span class='passive'>" : "<span class='combat'>"]• <b>Taxes</b>: [taxes]%</span>\n"
		msg += "[treasuryworth.get_money() ? "<span class='passive'>" : "<span class='combat'>"]• <b>Treasury</b>: [treasuryworth.get_money()]</span>\n"
		msg += "[gunban ? "<span class='combat'>" : "<span class='passive'>"]• <b>Firearms</b>: [gunban ? "Banned" : "Legal"]!</span>\n"
		msg += "[drugban ? "<span class='combat'>" : "<span class='passive'>"]• <b>Drugs</b>: [drugban ? "Banned" : "Legal"]!</span>\n"
		if(length(announces))
			msg += "<b>Baron's Decrees</b>: \n"
			for(var/A in src.announces)
				msg += "<span class='perks'>*[A]</span>\n"
		else
			msg += "No decrees yet.\n"
		to_chat(usr, msg)

/obj/machinery/information_terminal/RightClick(mob/living/carbon/human/user as mob)
	var/obj/item/weapon/card/id/idcard = user.wear_id
	var/id_money = idcard.money_account.get_money()
	if(screenbroken)
		var/symb1 = ionnum()
		var/symb2 = ionnum()
		if(user.check_perk(/datum/perk/illiterate))
			to_chat(usr, "<B>[symb1] [symb2]</B>")
		else
			to_chat(usr, "<B>[symb1] KILL [KILLSOMEONE] [symb2]</B>")
		return
	if(user.check_perk(/datum/perk/illiterate))
		to_chat(usr, "Hhhhhhhh Hhhhh : <b>[treasuryworth.get_money()] hhhhh</b>")
	else
		to_chat(usr, "Treasury Worth : <b>[treasuryworth.get_money()] obols</b>")
	if(!user.wear_id)
		to_chat(usr, "I don't have a ring, I can't use the terminal!")
		return
	if(hacked)
		if(user.religion == "Thanati")
			to_chat(usr, "Interesting.")
			return
		else
			to_chat(usr, "What the hell is this?!")
			return
	if(screenbroken)
		to_chat(usr, "It's broken, I can't use the terminal.")
		return
	if(istype(idcard, /obj/item/stolen))
		to_chat(user, "<span class='malfunction'>MY RING IS MISSING, IT'S BEEN STOLEN!</span>")
		user << 'sound/lfwbsounds/stolen.ogg'
		return
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 100, 0, -5)
	if(id_money)
		to_chat(user, "<i>My ring has [id_money] obols.</i>")
		var/infotext1 = "Information Terminal / You have [id_money] copper obols."
		var/infotext2 = "Select a obol type. Copper : 1, Silver : 4, Gold : 16"
		if(user.check_perk(/datum/perk/illiterate))
			infotext1 = Illiterate(infotext1,100)
			infotext2 = Illiterate(infotext2,100)
		src.obol_type = input(infotext2,infotext1,src.product) in list("Copper", "Silver", "Gold","Cancel")
		var/TRUEOBOLCHOICE
		switch(src.obol_type)
			if("Gold")
				TRUEOBOLCHOICE = "gold"
				playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)

			if("Silver")
				TRUEOBOLCHOICE = "silver"
				playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)
			if("Copper")
				TRUEOBOLCHOICE = "copper"
				playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)
			if("Cancel")
				return
		var/liquify = idcard.money_account.get_money()
		id_money = idcard.money_account.get_money()
		var/treasury_coins = treasuryworth.get_money()
		if(TRUEOBOLCHOICE == "silver")
			liquify = round(id_money / 4)
			treasury_coins /= 4
		else if(TRUEOBOLCHOICE == "gold")
			liquify = round(id_money / 16)
			treasury_coins /= 6
		var/withdrawtext = "How much you want to withdraw | There is [liquify] [TRUEOBOLCHOICE] obols on the ring."
		if(user.check_perk(/datum/perk/illiterate))
			withdrawtext = Illiterate(withdrawtext,100)
		var/withdraw = input(withdrawtext,"Information terminal", liquify)
		var/dist = get_dist(src,usr)
		if(!withdraw)
			return
		if(dist > 1)
			return
		liquify = idcard.money_account.get_money() //prevent cheating
		if(withdraw > liquify)
			to_chat(usr, "I don't have enough obols to withdraw that amount!")
			return
		if(withdraw > treasury_coins)
			to_chat(usr, "The treasury doesn't have enough obols!")
			return
		if(withdraw < 1 || (withdraw % 1))
			to_chat(usr, "negro nem tente")
			usr << 'olha-o-macaco.ogg'
			return
		if(withdraw <= liquify)
			if(TRUEOBOLCHOICE == "silver")
				to_chat(usr, "<i>You withdraw [withdraw] from the terminal.</i>")
				playsound(src.loc, 'sound/effects/coin_m.ogg', 100, 0, -5)
				spawn_money_silver(withdraw,user.loc)
				liquify = withdraw
				liquify = liquify * 4
				if(idcard.money_account != treasuryworth)
					idcard.money_account.add_money(-liquify)
				treasuryworth.add_money(-liquify)
			else if(TRUEOBOLCHOICE == "gold")
				to_chat(usr, "<i>You withdraw [withdraw] from the terminal.</i>")
				playsound(src.loc, 'sound/effects/coin_m.ogg', 100, 0, -5)
				spawn_money_gold(withdraw,user.loc)
				liquify = withdraw
				liquify = liquify * 16
				if(idcard.money_account != treasuryworth)
					idcard.money_account.add_money(-liquify)
				treasuryworth.add_money(-liquify)
			else
				to_chat(usr, "<i>You withdraw [withdraw] from the terminal.</i>")
				playsound(src.loc, 'sound/effects/coin_m.ogg', 100, 0, -5)
				spawn_money(withdraw,user.loc)
				liquify = withdraw
				if(idcard.money_account != treasuryworth)
					idcard.money_account.add_money(-liquify)
				treasuryworth.add_money(-liquify)
			log_game("[usr.real_name]([usr.key]) has withdrawn [liquify] [TRUEOBOLCHOICE] from the treasury(Current worth: [treasuryworth.get_money()]).")
	else
		to_chat(usr, "I have no obols on this ring.")

/obj/machinery/information_terminal/attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
	var/obj/item/weapon/card/id/idcard = user.wear_id
	if(!idcard)
		return
	if(istype(I,/obj/item/weapon/spacecash))
		var/obj/item/weapon/spacecash/C = I
		if(idcard.money_account != treasuryworth)
			idcard.money_account.add_money(C:singularvalue)
		treasuryworth.add_money(C:singularvalue)
		user.visible_message("<span class ='passivebold'>[user]</span> <span class='passive'>inserts a coin in \the [src]</span>", 1)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		C.worth -= C.singularvalue
		C.update_icon()
		if(C.worth < C.singularvalue)
			qdel(C)
		playsound(src.loc, 'sound/effects/moeda.ogg', 100, 1, -5)
	if(istype(I,/obj/item/weapon/fakecash))
		to_chat(user, "Attempt to insert fake obols into \the [src]! Your image has been captured and the Tiamats have been alerted.")
	if(istype(I, /obj/item/weapon/organ/head))
		var/obj/item/weapon/organ/head/H = I
		if(H.brainmob.job == "Pusher" && src.screenbroken)
			for(var/obj/machinery/information_terminal/IM in vending_list)
				IM.despusherize()

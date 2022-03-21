/obj/machinery/computer/meister
	name = "meister console"
	icon_state = "meister"
//	req_one_access = list(access_change_ids)

/obj/machinery/computer/meister/attack_hand(var/mob/user as mob)
	var/dat = " <META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'><Title>RAVENHEART</title></META> <style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: PTSANS;src: url(PTSANS.ttf);} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style> <style type='text/css'> @charset 'utf-8'; body {font-family: PTSANS;cursor: url('pointer.cur'), auto;} a {text-decoration:none;outline: none;border: none;margin:-1px;} a:focus{outline:none;} a:hover {color:#0d0d0d;background:#505055;outline: none;border: none;} a.active { text-decoration:none; color:#533333;} a.inactive:hover {color:#0d0d0d;background:#bb0000} a.active:hover {color:#bb0000;background:#0f0f0f} a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style> <body background bgColor=#0d0d0d text=#533333 alink=#777777 vlink=#777777 link=#777777> <style type='text/css'> body { font-family: 'Cond'; margin: 0; padding: 0; } #l { padding:10px; padding-left:20px; overflow-y: scroll; } #log { color: #a99; padding:30px; background-color: #222; } #r { position: fixed; top: 0; right: 0; width: 150px; background-color: #555; height: 100%; padding: 10px; } .rpo { color: #000; } # table { margin:10px; padding:10px; align:center; background-color: #222; border: 1px solid black; } table,tr,td { color: #666; } th { background-color: #555; color: #000; font-weight: bold; border-bottom: 2px solid #222; padding: 10px; } td { padding:5px; } tr:nth-child(even) { background: #111; } </style>"
	dat += "<BR><BR><DIV><div id ='l'><TABLE><TH>NAME</TH><TH>POSITION</TH><TH>LOCATION</TH><TH>ACCOUNT</TH><TH>OPERATIONS</TH>"
	if(!ticker)	return
	for(var/obj/item/weapon/card/id/ID in rings_account)
		if(ID.no_showing) continue
		if(ID.registered_name == "Unknown")	continue
		var/area/t = get_area(ID)
		var/money_in = ID.money_account.get_money()
		dat += "<TR><TD>[ID.registered_name]</TD><TD>[ID.assignment]</TD><TD>[t.name]</TD><TD>[money_in]</TD><TD><A href='?src=\ref[ID];choice=nullify'>Nullify</a><BR><A href='?src=\ref[ID];choice=addfund'>Add Funds</a><BR></TD></TR>"
	dat += "</TABLE><BR></div></div><div id = 'r'><BR><BR><a class='rpo' href='?src=\ref[src];choice=wage'>Give Wage</a><BR><a class ='rpo' href='?src=\ref[src];choice=recovercrown'>Recover the Crown</a><BR><a class='rpo' href='?src=\ref[src];choice=alarmoff'>Turn Off All Alarms</a><BR></div>"
	user << browse(dat, "window=id_com;size=700x520")
	//onclose(user, "id_com")

/obj/item/weapon/card/id/Topic(href, href_list)
	switch(href_list["choice"])
		if("nullify")
			if(money_account == treasuryworth)
				to_chat(usr, "<span class='combatbold'>[pick(nao_consigoen)] I can't do this to Baron's ring!</span>")
				return
			to_chat(usr, "[src.name] has been nullified ([src.rank])")
			log_game("[usr.real_name]([usr.key]) has nullified [src.name]'s funds.")
			money_account.set_money(0)
		if("addfund")
			if(money_account == treasuryworth)
				to_chat(usr, "<span class='combatbold'>[pick(nao_consigoen)] I can't do this to Baron's ring!</span>")
				return
			var/manyobols = input("How many obols in copper are they going to receive? [treasuryworth.get_money()] obols in Treasury!", "MEISTERY") as null|num
			if(manyobols <= 0)
				return
			if(manyobols <= 0)
				if(money_account.get_money() < manyobols)
					to_chat(usr, "The ring is empty!")
					return
			manyobols = clamp(manyobols,0,(treasuryworth.get_money())*10)
			log_game("[usr.real_name]([usr.key]) has added [manyobols] to [src.name]'s ring.")
			src.receivePayment(manyobols)

/obj/machinery/computer/meister/Topic(href, href_list)
	switch(href_list["choice"])
		if ("wage")
			var/list/wages = list("Maid","Marduk","Tiamat","Sheriff","Incarn","Mortus","Misero","Servant","Pusher")
			var/choice = input("Choose a job to receive their wage!", "MEISTERY") as null|anything in wages
			if(!choice)
				return
			var/manyobols = input("How many obols in copper are they going to receive? [treasuryworth.get_money()] obols in Treasury!", "MEISTERY") as null|num
			if(manyobols <= 0)
				return
			var/list/wagelist = list()
			for(var/obj/item/weapon/card/id/ID in rings)
				if(ID.rank != choice)	continue
				else
					wagelist.Add(ID)
			playsound(src.loc, 'console_interact7.ogg', 60, 0)
			to_chat(usr, "[manyobols] sent!")
			log_game("[usr.real_name]([usr.key]) has paid all [choice] a wage of [manyobols].")
			for(var/obj/item/weapon/card/id/ID in wagelist)
				ID.receivePayment(manyobols)
		if ("recovercrown")
			if(!fortCrown)
				to_chat(usr, "<span class='combatbold'>[pick(nao_consigoen)] The crown does not exist!</span>")
				return
			if(istype(fortCrown.loc, /mob/living))
				to_chat(usr, "<span class='combatbold'>[pick(nao_consigoen)] Someone is wearing the crown!</span>")
				return
			log_game("[usr.real_name]([usr.key]) has recovered the crown.")
			to_chat(usr, "<span class='passive'>Success</span>")
			playsound(src.loc, 'console_interact7.ogg', 60, 0)
			fortCrown.loc = src.loc
		if ("alarmoff")
			for(var/obj/machinery/emergency_room/E in emergency_rooms)
				if(E.activearea.alarm_toggled)
					E.activearea.alarm_toggled = FALSE
					E.icon_state = E.normal_state
					E.active = FALSE
					processing_objects.Remove(E)
			log_game("[usr.real_name]([usr.key]) has disabled the alarms.")
			to_chat(usr, "<span class='passive'>Success</span>")
			playsound(src.loc, 'console_interact7.ogg', 60, 0)

/obj/machinery/computer/meister/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/spacecash))
		var/obj/item/weapon/spacecash/C = W
		treasuryworth.add_money(C.worth)
		qdel(C)
		playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)

	if(istype(W, /obj/item/weapon/fakecash))
		to_chat(user, "<span class='combat'>Curse. It's fake!</span>")

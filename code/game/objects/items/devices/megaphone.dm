/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon_state = "megaphone"
	item_state = "radio"
	w_class = 1.0
	flags = FPRINT | TABLEPASS | CONDUCT

	var/spamcheck = 0
	var/emagged = 0
	var/insults = 0
	var/list/insultmsg = list("ÑÈÍÄÈÊÀÒ - ÑÈËÀ, ÍÒ - ÌÎÃÈËÀ!", "ÑÁ - ÏÈÄÎĞÀÑÛ!", "ÊÀÏÈÒÀÍ - ÃÎÍÄÎÍ!", "ÕÎÑ - ÕÓÅÑÎÑ!")

/obj/item/device/megaphone/attack_self(mob/living/user as mob)
	if (user.client)
		if(user.client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (muted)."
			return
	if(!ishuman(user))
		user << "\red You don't know how to use this!"
		return
	if(user.silent)
		return
	if(spamcheck)
		user << "\red Íå òàê áûñòğî, êîâáîé!"
		return

	var/message = sanitize(input(user, "Shout a message?", "Megaphone", null)  as text)
	if(!message)
		return
	message = capitalize(message)
	if ((src.loc == user && usr.stat == 0))
		if(emagged)
			if(insults)
				for(var/mob/O in (viewers(user)))
					O.show_message("<B>[user]</B> broadcasts, <FONT size=3>\"[pick(insultmsg)]\"</FONT>",2) // 2 stands for hearable message
				//insults--
			else
				user << "\red *BZZZZzzzzzt*"
		else
			for(var/mob/O in (viewers(user)))
				O.show_message("<B>[user]</B> broadcasts, <FONT size=3>\"[message]\"</FONT>",2) // 2 stands for hearable message

		spamcheck = 1
		spawn(20)
			spamcheck = 0
		return

/obj/item/device/megaphone/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/card/emag) && !emagged)
		user << "\red You overload \the [src]'s voice synthesizer."
		emagged = 1
		insults = 1//to prevent dickflooding
		return
	return
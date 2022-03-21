var/list/intercoms = list()

/obj/item/device/radio/intercom
	name = "station intercom"
	desc = "Talk through this."
	icon_state = "intercom"
	anchored = 1
	w_class = 4.0
	canhear_range = 2
	flags = FPRINT | CONDUCT | TABLEPASS | NOBLOODY
	var/number = 0
	var/anyai = 1
	var/mob/living/silicon/ai/ai = list()
	var/last_tick //used to delay the powercheck
	plane = 21

/obj/item/device/radio/intercom/kick_act()
	return

/obj/item/device/radio/intercom/north
	pixel_y = 22

/obj/item/device/radio/intercom/south
	pixel_y = -26

/obj/item/device/radio/intercom/west
	pixel_x = -26

/obj/item/device/radio/intercom/east
	pixel_x = 26

/obj/item/device/radio/intercom/New()
	..()
	processing_objects += src
	intercoms += src

/obj/item/device/radio/intercom/Destroy()
	processing_objects -= src
	intercoms -= src
	..()

/obj/item/device/radio/intercom/attack_ai(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/attack_paw(mob/user as mob)
	return src.attack_hand(user)


/obj/item/device/radio/intercom/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		//attack_self(user)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		if(broadcasting)
			to_chat(user, "<span class='passive'>BROADCASTING : OFF</span>")
			broadcasting = FALSE
		else
			to_chat(user, "<span class='passive'>BROADCASTING : ON</span>")
			broadcasting = TRUE

/obj/item/device/radio/intercom/RightClick(mob/user as mob)
	if(get_dist(src, user) > 1)
		return
	src.add_fingerprint(user)
	spawn (0)
		//attack_self(user)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		if(listening)
			to_chat(user, "<span class='passive'>LISTENING : OFF</span>")
			listening = FALSE
		else
			to_chat(user, "<span class='passive'>LISTENING : ON</span>")
			listening = TRUE

/obj/item/device/radio/intercom/receive_range(freq, level)
	if (!on)
		return -1
	if (!(src.wires & WIRE_RECEIVE))
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1
	if(freq == SYND_FREQ)
		if(!(src.syndie))
			return -1//Prevents broadcast of messages over devices lacking the encryption

	return canhear_range


/obj/item/device/radio/intercom/hear_talk(mob/M as mob, msg)
	if(!src.anyai && !(M in src.ai))
		return
	..()

/obj/item/device/radio/intercom/process()
	if(((world.timeofday - last_tick) > 30) || ((world.timeofday - last_tick) < 0))
		last_tick = world.timeofday

		if(!src.loc)
			on = 0
		else
			var/area/A = src.loc.loc
			if(!A || !isarea(A) || !A.master)
				on = 0
			else
				on = A.master.powered(EQUIP) // set "on" to the power status

		if(!on)
			icon_state = "intercom-p"
		else
			icon_state = "intercom"

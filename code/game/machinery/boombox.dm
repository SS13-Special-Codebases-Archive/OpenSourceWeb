
/obj/item/weapon/ghettobox/special
	name = "pocket ghettobox"
	desc = "A GUETTOOOOOOOOOOOOOOO!! BOX!"
	icon_state = "radiobailole"
	item_state = "boombox"
	w_class = 3
	var/mob/retard //current user
	var/retard_name
	var/writing = 0

/obj/item/weapon/ghettobox/special/attackby(obj/item/I, mob/user, params)
	if(coolboombox.Find(ckey(user.key)))
		..()
	else
		to_chat(user, "<span class='combat'>[pick(nao_consigoen)] I'm stuck!</span>")

/obj/item/weapon/ghettobox/special/update_icon()
	if(playing)
		icon_state = "radiobailole"
	else
		icon_state = "radiobailole"

/obj/item/weapon/ghettobox/special/RightClick(mob/user)
	var/dat = ""
	if(!coolboombox.Find(ckey(user.key)))
		to_chat(user, "<span class='combat'>[pick(nao_consigoen)] I'm stuck!</span>")
		return
	if(writing)
		dat += "Memory scan completed. <br>Writing from scan of [retard_name] mind... Please Stand By."
	if(casseta)
		to_chat(user, "<span class='warning'>There is already cassette inside.</span>")
		return
	else
		dat += "<A href='?src=\ref[src];write=1'>Write</A>"

	user << browse(dat, "window=musicwriter;size=200x100")
	onclose(user, "onclose")
	return

/obj/item/weapon/ghettobox/special/Topic(href, href_list)
	if(href_list["write"])
		if(!writing && !retard)
			writing = 1
			retard = usr
			retard_name = retard.name
			var/N = sanitize(input("Name of music") as text|null)
			//retard << "Please stand still while your data is uploading"
			if(N)
				var/sound/S = input("Your music file") as sound|null
				if(S)
					var/datum/turntable_soundtrack/T = new()
					var/obj/item/weapon/disk/music/disk = new()
					T.path = S
					T.f_name = copytext(N, 1, 2)
					T.name = copytext(N, 2)
					disk.data = T
					disk.name = "disk ([N])"
					disk.forceMove(src)
					casseta = disk
					disk.uploader_ckey = retard.ckey
					disk.sound_inside = S
					var/mob/M = usr
					if(istype(src, /obj/machinery/party/musicwriter/diabolic_machine))
						disk.bloqueado = 1
					message_admins("[M.real_name]([M.ckey]) uploaded <A HREF='?_src_=holder;listensound=\ref[S]'>sound</A> named as [N]. <A HREF='?_src_=holder;wipedata=\ref[disk]'>Wipe</A> data.")
			writing = 0
			retard = null
			retard_name = null


/obj/item/weapon/ghettobox
	name = "Ghettobox"
	icon = 'icons/obj/personal.dmi'
	icon_state = "boombox0"
	item_state = "boombox"
	desc = "A GUETTOOOOOOOOOOOOOOOOOOOOOOOOOOO!"
	var/obj/item/weapon/disk/music/casseta = null
	var/datum/sound_token/sound_token
	var/playing = 0
	var/sound_id
	w_class = 5
	force = 18
	force_wielded = 21
	force_unwielded = 18
	weight = 40

/obj/item/weapon/ghettobox/New()
	..()
	sound_id = "[type]_[sequential_id(type)]"


/obj/item/weapon/ghettobox/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/disk/music))
		if(casseta)
			to_chat(user, "<span class='warning'>There is already cassette inside.</span>")
			return
		user.drop_item(sound=0)
		I.forceMove(src)
		casseta = I
		visible_message("<span class='notice'>[user] insert cassette into [src].</span>")
		playsound(get_turf(src), 'sound/machines/bominside.ogg', 50, 1)
		return
	..()

/obj/item/weapon/ghettobox/update_icon()
	if(playing)
		icon_state = "boombox1"
	else
		icon_state = "boombox0"

/obj/item/weapon/ghettobox/MouseDrop(var/obj/over_object)
	if (!over_object || !(ishuman(usr)))
		return

	if (!(src.loc == usr))
		return

	switch(over_object.name)
		if("r_hand")
			eject()
		if("l_hand")
			eject()




/obj/item/weapon/ghettobox/proc/eject()
	if(!usr.canmove)
		return
	if(!casseta)
		to_chat(usr, "<span class='warning'>There is no cassette inside.</span>")
		return

	if(playing)
		StopPlaying()
	visible_message("<span class='notice'>[usr] ejects cassette from [src].</span>")
	playsound(get_turf(src), 'sound/machines/bominside.ogg', 50, 1)
	usr.put_in_hands(casseta)
	casseta = null

/obj/item/weapon/ghettobox/attack_self(mob/user)
	if(playing)
		StopPlaying()
		playsound(get_turf(src), 'sound/machines/bomclick.ogg', 50, 1)
		return
	else
		StartPlaying()
		playsound(get_turf(src), 'sound/machines/bomclick.ogg', 50, 1)


/obj/item/weapon/ghettobox/proc/StopPlaying()
	playing = 0
	update_icon()
	qdel(sound_token)

/obj/item/weapon/ghettobox/proc/StartPlaying()
	StopPlaying()
	if(isnull(casseta))
		return
	if(!casseta.sound_inside)
		return

	sound_token = sound_player.PlayLoopingSound(src, sound_id, casseta.sound_inside, volume = 40, range = 10, falloff = 3, prefer_mute = TRUE)
	playing = 1
	update_icon()
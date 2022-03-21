/obj/item/weapon/disk/music
	icon = 'icons/obj/personal.dmi'
	icon_state = "cassete"
	item_state = "card-id"
	w_class = 1.0

	var/datum/turntable_soundtrack/data
	var/uploader_ckey
	var/sound/sound_inside
	w_class = 1
	var/uploader_idiot
	var/current_side = 1
	var/sound/a_side
	var/sound/b_side
	var/bloqueado = 0

/obj/item/weapon/disk/music/attack_self(mob/user)
	. = ..()
	if(current_side == 1)
		sound_inside = b_side
		current_side = 2
		to_chat(user, "<span class='notice'>You flip the cassette over to the b-side.")
	else
		sound_inside = a_side
		current_side = 1
		to_chat(user, "<span class='notice'>You flip the cassette over to the a-side.")

/obj/item/weapon/disk/music/tape1/New()
	..()
	name = "\"Firethorn\'s Greatest Hits Vol.1\" magn-o-tape"
	a_side = 'sound/music/csrio.ogg'
	sound_inside = a_side

/obj/item/weapon/disk/music/tape2/New()
	..()
	name = "\"Firethorn\'s Greatest Hits Vol.2\" magn-o-tape"
	a_side = 'sound/music/soufoda.ogg'
	sound_inside = a_side

/obj/item/weapon/disk/music/tape3/New()
	..()
	name = "\"Firethorn\'s Greatest Hits Vol.3\" magn-o-tape"
	a_side = 'sound/music/rapdasarmas.ogg'
	sound_inside = a_side

/obj/machinery/party/musicwriter/diabolic_machine
	name = "Diabolic Machine of Truth"
	desc = "Spooky"
	icon = 'icons/obj/computer.dmi'
	icon_state = "diabolic"
	density = 1
	coin = 1000

/obj/machinery/party/musicwriter
	name = "Memories writer"
	icon = 'icons/obj/objects.dmi'
	icon_state = "writer_off"
	var/coin = 0
	//var/obj/item/weapon/disk/music/disk
	var/mob/retard //current user
	var/retard_name
	var/writing = 0
	anchored = 1

/obj/machinery/party/musicwriter/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/weapon/spacecash/c10))
		user.drop_item()
		qdel(O)
		coin++

/obj/machinery/party/musicwriter/attack_hand(mob/user)
	var/dat = ""
	if(writing)
		dat += "Memory scan completed. <br>Writing from scan of [retard_name] mind... Please Stand By."
	else if(!coin)
		dat += "Please insert a coin."
	else
		dat += "<A href='?src=\ref[src];write=1'>Write</A>"

	user << browse(dat, "window=musicwriter;size=200x100")
	onclose(user, "onclose")
	return

/obj/machinery/party/musicwriter/Topic(href, href_list)
	if(href_list["write"])
		if(!writing && !retard && coin)
			icon_state = "writer_on"
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
					disk.loc = src.loc
					disk.uploader_ckey = retard.ckey
					disk.sound_inside = S
					var/mob/M = usr
					if(istype(src, /obj/machinery/party/musicwriter/diabolic_machine))
						disk.bloqueado = 1
					message_admins("[M.real_name]([M.ckey]) uploaded <A HREF='?_src_=holder;listensound=\ref[S]'>sound</A> named as [N]. <A HREF='?_src_=holder;wipedata=\ref[disk]'>Wipe</A> data.")
			if(istype(src, /obj/machinery/party/musicwriter/diabolic_machine))
				icon_state = "diabolic"
			else
				icon_state = "writer_off"
			writing = 0
			coin -= 1
			retard = null
			retard_name = null

/obj/item/device/radio/beacon
	name = ""
	desc = ""
	icon_state = ""
	item_state = ""
	var/code = "electronic"
	origin_tech = "bluespace=1"

/obj/item/device/radio/beacon/hear_talk()
	return


/obj/item/device/radio/beacon/send_hear()
	return null


/obj/item/device/radio/beacon/verb/alter_signal(t as text)
	set name = "Alter Beacon's Signal"
	set category = "Object"
	set src in usr

	if ((usr.canmove && !( usr.restrained() )))
		src.code = t
	if (!( src.code ))
		src.code = "beacon"
	src.add_fingerprint(usr)
	return


/obj/item/device/radio/beacon/bacon //Probably a better way of doing this, I'm lazy.
	proc/digest_delay()
		spawn(600)
			qdel(src)


// SINGULO BEACON SPAWNER

/obj/item/device/radio/beacon/syndicate
	name = "suspicious beacon"
	desc = "A label on it reads: <i>Activate to have a singularity beacon teleported to your location</i>."
	origin_tech = "bluespace=1;syndicate=7"
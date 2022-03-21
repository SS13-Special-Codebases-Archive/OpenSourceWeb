var/keyCounter = 0
/obj/item/weapon/keycard
	name = "Keycard Room X"
	icon = 'icons/obj/items.dmi'
	icon_state = "keycard1"
	w_class = 2
	var/key = ""

/obj/item/weapon/keycard/New()
	..()
	keyCounter++
	key = "[keyCounter]"
	name = "Keycard Room #[key]"
	desc = "A keycard to open inn's rooms. This one has a tag #[key]"
	icon_state = "keycard[rand(1,2)]"

/obj/item/weapon/keycard/afterattack(atom/A, mob/user as mob, proximity) //i could've just done a for() i'm a retard holy fck
	if(!proximity) return
	if(istype(A, /obj/machinery/door/airlock/brothel/innkeep))
		var/obj/machinery/door/airlock/brothel/innkeep/AA = A
		if(AA.key == src.key)
			if(AA.locked)
				AA.locked = 0
				playsound(AA.loc, 'sound/airlock_boltswitch.ogg', 100, 1)
				AA.update_icon()
			else
				AA.locked = 1
				playsound(AA.loc, 'sound/airlock_boltswitch.ogg', 100, 1)
				AA.update_icon()
		return
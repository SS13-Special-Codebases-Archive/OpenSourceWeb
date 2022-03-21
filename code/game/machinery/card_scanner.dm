/obj/machinery/card_scanner
	name = "card scanner"
	icon = 'monitors.dmi'
	icon_state = "card_scanner"
	var/obj/machinery/door/my_door = null
	proc
		init_door()
			for(var/obj/machinery/door/D in orange(1,src))
				my_door = D
				my_door.my_scanner = src
				break

		del_door()
			my_door = null

	New()
		init_door()

	attackby(obj/item/I as obj, mob/user as mob)
		if(my_door)
			if(my_door.allowed(user))
				flick("card_scanner1",src)
				playsound(loc, 'sound/machines/console_success.ogg', 25, 1, -1)
				if(my_door.density)
					my_door.open()
				else
					my_door.close()
				return
			else
				flick("card_scanner0",src)
				playsound(loc, 'sound/machines/console_error.ogg', 25, 1, -1)
				return
		else
			playsound(loc, 'sound/machines/console_error.ogg', 25, 1, -1)
			user << "\red You don't think that this scanner will work..."
			return
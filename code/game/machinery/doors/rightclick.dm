/obj/machinery/door/airlock/RightClick(mob/living/carbon/human/user)

	if(user.get_active_hand() == null)

		if(usr.next_move >= world.time)
			return

		if(usr.stat == 1)
			return

		if(iszombie(user))
			return

		if(usr.restrained())
			return

		user.next_move = world.time + 2
		if(locked)
			if(allowed(user))
				locked = 0
				playsound(src.loc, 'sound/airlock_boltswitch.ogg', 100, 1)
				update_icon()
				return
		if(!locked)
			if(allowed(user))
				locked = 1
				playsound(src.loc, 'sound/airlock_boltswitch.ogg', 100, 1)
				update_icon()
				return
		else
			if(!allowed(user))
				flick("door_deny", src)
				playsound(src.loc, 'sound/webbers/airlock_deny2.ogg', 100, 1)
				return
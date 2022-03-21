/obj/machinery/door/airlock/transgates/ins
	name = "Gates"
	autoclose = 0
	locked = 0
	safe = 0
	var/PENES = 0

/obj/machinery/door/airlock/transgates/ins/RightClick(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.health < -10 || H.lying || H.handcuffed || H.stat == DEAD || H.death_door) 
		return

	for(var/obj/machinery/door/airlock/transgates/ins/B in range(3, src))
		if(!PENES)
			if(B.density)
				if(B.allowed(user))
					spawn(-1)
						B.open()
			else if(!B.density)
				if(B.allowed(user))
					spawn(-1)
						B.close()

/obj/machinery/door/airlock/transgates/ins/attack_hand()
	return 0

/obj/machinery/door/airlock/transgates/ins/_1
	icon = 'icons/life/tgate1.dmi'
	icon_state = "door_closed"

/obj/machinery/door/airlock/transgates/ins/_2
	icon = 'icons/life/tgate2.dmi'
	icon_state = "door_closed"

/obj/machinery/door/airlock/transgates/ins/_3
	icon = 'icons/life/tgate3.dmi'
	icon_state = "door_closed"


/obj/machinery/door/airlock/transgates/ins/Bumped()
	return 0

/obj/machinery/door/airlock/transgates/ins/attackby()
	return 0

/obj/machinery/door/airlock/transgates/ins/merchant
	name = "Gates"
	autoclose = 0
	locked = 0
	PENES = FALSE

/obj/machinery/door/airlock/transgates/ins/merchant/_1
	icon = 'icons/life/sgate1.dmi'
	icon_state = "door_closed"

/obj/machinery/door/airlock/transgates/ins/merchant/_2
	icon = 'icons/life/sgate2.dmi'
	icon_state = "door_closed"

/obj/machinery/door/airlock/transgates/ins/merchant/_3
	icon = 'icons/life/sgate3.dmi'
	icon_state = "door_closed"
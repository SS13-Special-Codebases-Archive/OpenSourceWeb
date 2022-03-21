/obj/machinery/key_card
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "keylock0"
	name = "airlock button"

	anchored = 1
	var/on = 1
	power_channel = ENVIRON

	var/airlock_tag = "captain"

/obj/machinery/key_card/update_icon()
	if(on)
		icon_state = "access_button_standby"
	else
		icon_state = "access_button_off"

/obj/machinery/key_card/attackby(obj/item/weapon/card/id/I, mob/user)
	add_fingerprint(usr)

	if(!istype(I))
		return 0

	for(var/obj/machinery/door/airlock/orbital/B in world)
		if(B.airlock_tag == src.airlock_tag)
			if(B.density)
				if(B.allowed(user))
					spawn(1)
						B.open()
				else
					flick("door_deny", src)
			else if(!B.density)
				if(B.allowed(user))
					spawn(1)
						B.close()

	flick("keylock1", src)


/obj/machinery/key_card/g/attackby()
	return 0

/obj/machinery/key_card/g/attack_hand(mob/user)
	for(var/obj/machinery/door/airlock/orbital/B in range(12,src))
		if(B.airlock_tag == src.airlock_tag)
			if(B.density)
				icon_state = "lever_big1"
				playsound(src.loc, 'sound/effects/lever.ogg', 25, 0)
				if(!B.broken)
					spawn(1)
						if(!B.broken)
							B.open()
			else if(!B.density)
				icon_state = "lever_big0"
				playsound(src.loc, 'sound/effects/lever.ogg', 25, 0)
				if(!B.broken)
					spawn(1)
						if(!B.broken)
							B.close()

/obj/machinery/key_card/g/gatein
	icon_state = "lever_big0"
	airlock_tag = "gatein"

/obj/machinery/key_card/g/gateex
	icon_state = "lever_big0"
	airlock_tag = "gateex"

/obj/machinery/key_card/g/magma
	name = "turret enabler"
	desc = "The Incarn uses this to burn out intruders or unwanted people."
	icon_state = "lever0"
	airlock_tag = "magma"

/obj/machinery/key_card/g/magma/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	for(var/obj/machinery/door/airlock/orbital/gates/magma/B in range(20, src))
		if(B.airlock_tag == src.airlock_tag)
			if(B.fechado)
				icon_state = "lever1"
				playsound(src.loc, 'sound/effects/lever.ogg', 25, 0)
				spawn(1)
					B.open()
			else if(!B.fechado)
				icon_state = "lever0"
				playsound(src.loc, 'sound/effects/lever.ogg', 25, 0)
				spawn(1)
					B.close()

/obj/machinery/key_card/g/magma/turret
	icon_state = "tur_control0"

/obj/machinery/key_card/g/magma/turret/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!mainTurret.on)
		mainTurret.on = 1
		icon_state = "tur_control1"
		playsound(src.loc, 'sound/webbers/metswitch.ogg', 80, 1)
	else
		mainTurret.on = 0
		icon_state = "tur_control0"
		playsound(src.loc, 'sound/webbers/metswitch.ogg', 80, 1)

/obj/machinery/key_card/g/Merc
	name = "Alavanca dos Portões"
	desc = "Used to open the keep gates."
	icon_state = "lever0"
	airlock_tag = "magma"

/obj/machinery/key_card/g/Merc/attack_hand(mob/user)
	for(var/obj/machinery/door/airlock/transgates/ins/merchant/B in range(20, src))
		if(B.density)
			icon_state = "lever1"
			playsound(src.loc, 'sound/effects/lever.ogg', 25, 0)
			spawn(1)
				B.open()
		else if(!B.density)
			icon_state = "lever0"
			playsound(src.loc, 'sound/effects/lever.ogg', 25, 0)
			spawn(1)
				B.close()

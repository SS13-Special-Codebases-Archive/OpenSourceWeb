// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/machinery/light_switch
	name = "light switch"
	desc = "It turns lights on and off. What are you, simple?"
	icon = 'icons/obj/power.dmi'
	icon_state = "light1"
	anchored = 1.0
	var/on = 1
	var/area/area = null
	var/otherarea = null
	//	luminosity = 1

/obj/machinery/light_switch/New()
	..()
	spawn(5)
		src.area = src.loc.loc

		if(otherarea)
			src.area = locate(text2path("/area/[otherarea]"))

		if(!name)
			name = "light switch ([area.name])"

		src.on = src.area.lightswitch
		updateicon()



/obj/machinery/light_switch/proc/updateicon()
	if(stat & NOPOWER)
		icon_state = "light-p"
	else
		if(on)
			icon_state = "light1"
		else
			icon_state = "light0"

/obj/machinery/light_switch/examine()
	set src in oview(1)
	if(usr && !usr.stat)
		to_chat(usr, "A light switch. It is [on? "on" : "off"].")


/obj/machinery/light_switch/attack_paw(mob/user)
	src.attack_hand(user)

/obj/machinery/light_switch/attack_hand(mob/user)

	on = !on

	for(var/area/A in area.master.related)
		A.lightswitch = on
		A.updateicon()

		for(var/obj/machinery/light_switch/L in A)
			L.on = on
			L.updateicon()

	playsound(src.loc, pick('sound/effects/lightswitch_1.ogg', 'sound/effects/lightswitch_2.ogg', 'sound/effects/lightswitch_3.ogg', 'sound/effects/lightswitch_4.ogg'), 80, 1)

	area.master.power_change()

/obj/machinery/light_switch/power_change()

	if(!otherarea)
		if(powered(LIGHT))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER

		updateicon()

/obj/machinery/light_switch/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	power_change()
	..(severity)
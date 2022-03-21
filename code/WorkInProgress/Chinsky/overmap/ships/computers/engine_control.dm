//Engine control and monitoring console

/obj/machinery/computer/engines
	name = "engines control console"
	icon_state = "engineeringcameras"
	circuit = "/obj/item/weapon/circuitboard/propulsion_control"
	var/state = "status"
	var/list/engines = list()
	var/obj/effect/map/ship/linked
	New()
		..()
		init_obj.Add(src)

/obj/machinery/computer/engines/initialize()
	linked = map_sectors["[z]"]
	if (linked)
		if (!linked.eng_control)
			linked.eng_control = src
//		testing("Engines console at level [z] found a corresponding overmap object '[linked.name]'.")
	else
		testing("Engines console at level [z] was unable to find a corresponding overmap object.")

	for(var/datum/ship_engine/E in linked.ship_engines)
		if ((E.zlevel in linked.ship_levels) && !(E in src.engines))
			src.engines += E

/obj/machinery/computer/engines/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		return

	if(!isAI(user))
		user.set_machine(src)

	ui_interact(user)

/obj/machinery/computer/engines/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		return

	var/data[0]
	data["state"] = state

	var/list/enginfo[0]
	for(var/datum/ship_engine/E in engines)
		var/list/rdata[0]
		rdata["eng_type"] = E.name
		rdata["eng_on"] = E.is_on()
		rdata["eng_thrust"] = E.get_thrust()
		rdata["eng_thrust_limiter"] = round(E.get_thrust_limit()*100)
		rdata["eng_status"] = E.get_status()
		rdata["eng_reference"] = "\ref[E]"
		enginfo.Add(list(rdata))

	data["engines_info"] = enginfo

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "engines_control.tmpl", "[linked.name] Engines Control", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/engines/Topic(href, href_list)
	if(..())
		return

	if(href_list["state"])
		state = href_list["state"]

	if(href_list["engine"])
		if(href_list["set_limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/newlim = input("Input new thrust limit (0..100)", "Thrust limit", E.get_thrust_limit()) as num
			var/limit = Clamp(newlim/100, 0, 1)
			if(E)
				E.set_thrust_limit(limit)

		if(href_list["limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/limit = Clamp(E.get_thrust_limit() + text2num(href_list["limit"]), 0, 1)
			if(E)
				E.set_thrust_limit(limit)

		if(href_list["toggle"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			if(E)
				E.toggle()

	add_fingerprint(usr)
	nanomanager.update_uis(src)

/obj/machinery/computer/engines/proc/burn()
	if(engines.len == 0)
		return 0
	var/res = 0
	for(var/datum/ship_engine/E in engines)
		res |= E.burn()
	return res

/obj/machinery/computer/engines/proc/get_total_thrust()
	for(var/datum/ship_engine/E in engines)
		. += E.get_thrust()


/obj/machinery/computer/engines/constructed
	New()
		..()
		initialize()

/obj/machinery/computer/engines/soviet
	icon_state = "engineeringcamerassoviet-er"
	var/error = 1

/obj/machinery/computer/engines/soviet/attack_hand(var/mob/user as mob)
	if(error)
		user << "<span class='warning'>Error! Requires a system reboot..</span>"
		return
	..()

/obj/machinery/computer/engines/soviet/attackby(obj/item/P as obj, mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(istype(P, /obj/item/device/multitool))
		user << "<span class='notice'>You start rebooting system..</span>"
		if(do_after(user, 50))
			error = 0
			icon_state = "engineeringcamerassoviet"
			user << "<span class='notice'>You successfully reboot system.</span>"

		else	user << "<span class='warning'>You cancel rebooting system!</span>"

	..()
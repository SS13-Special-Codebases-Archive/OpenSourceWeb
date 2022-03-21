//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31


/obj/machinery/computer/atmos_alert
	name = "Atmospheric Alert Computer"
	desc = "Used to access the ship's atmospheric sensors."
	circuit = "/obj/item/weapon/circuitboard/atmos_alert"
	icon_state = "alert:0"
	var/list/priority_alarms = list()
	var/list/minor_alarms = list()
	var/receive_frequency = 1437
	var/datum/radio_frequency/radio_connection
	var/alarms = list("Fire"=list(), "Atmosphere"=list())
	New()
		..()
		init_obj.Add(src)

/obj/machinery/computer/atmos_alert/initialize()
	..()
	set_frequency(receive_frequency)

/obj/machinery/computer/atmos_alert/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/zone = signal.data["zone"]
	var/severity = signal.data["alert"]

	if(!zone || !severity) return

	minor_alarms -= zone
	priority_alarms -= zone
	if(severity=="severe")
		priority_alarms += zone
	else if (severity=="minor")
		minor_alarms += zone
	update_icon()
	return


/obj/machinery/computer/atmos_alert/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, receive_frequency)
	receive_frequency = new_frequency
	radio_connection = radio_controller.add_object(src, receive_frequency, RADIO_ATMOSIA)


/obj/machinery/computer/atmos_alert/attack_hand(mob/user)
	if(..(user))
		return
	if(level_check()==0)	return
	user << browse(return_text(),"window=computer")
	user.set_machine(src)
	onclose(user, "computer")

/obj/machinery/computer/atmos_alert/process()
	if(..())
		src.updateDialog()

/obj/machinery/computer/atmos_alert/update_icon()
	..()
	if(stat & (NOPOWER|BROKEN))
		return
	if(priority_alarms.len)
		icon_state = "alert:2"

	else if(minor_alarms.len)
		icon_state = "alert:1"

	else
		icon_state = "alert:0"
	return


/obj/machinery/computer/atmos_alert/proc/return_text()
	var/priority_text
	var/minor_text

	if(priority_alarms.len)
		for(var/zone in priority_alarms)
			priority_text += "<FONT color='red'><B>[zone]</B></FONT>  <A href='?src=\ref[src];priority_clear=[ckey(zone)]'>X</A><BR>"
	else
		priority_text = "No priority alerts detected.<BR>"

	if(minor_alarms.len)
		for(var/zone in minor_alarms)
			minor_text += "<B>[zone]</B>  <A href='?src=\ref[src];minor_clear=[ckey(zone)]'>X</A><BR>"
	else
		minor_text = "No minor alerts detected.<BR>"

	var/output = {"<B>[name]</B><HR>
<B>Priority Alerts:</B><BR>
[priority_text]
<BR>
<HR>
<B>Minor Alerts:</B><BR>
[minor_text]
<BR>"}

	return output


/obj/machinery/computer/atmos_alert/Topic(href, href_list)
	if(..())
		return

	if(href_list["priority_clear"])
		var/removing_zone = href_list["priority_clear"]
		for(var/zone in priority_alarms)
			if(ckey(zone) == removing_zone)
				priority_alarms -= zone

	if(href_list["minor_clear"])
		var/removing_zone = href_list["minor_clear"]
		for(var/zone in minor_alarms)
			if(ckey(zone) == removing_zone)
				minor_alarms -= zone
	update_icon()
	return

// I hope this shit will work with this
/obj/machinery/computer/atmos_alert/proc/triggerAlarm(var/class, area/A, var/O, var/alarmsource)
	if(stat & (BROKEN|NOPOWER))
		return
	var/list/L = src.alarms[class]
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/sources = alarm[3]
			if (!(alarmsource in sources))
				sources += alarmsource
			return 1
	var/obj/machinery/camera/C = null
	var/list/CL = null
	if (O && istype(O, /list))
		CL = O
		if (CL.len == 1)
			C = CL[1]
	else if (O && istype(O, /obj/machinery/camera))
		C = O
	L[A.name] = list(A, (C) ? C : O, list(alarmsource))
	return 1

/obj/machinery/computer/atmos_alert/proc/cancelAlarm(var/class, area/A as area, obj/origin)
	if(stat & (BROKEN|NOPOWER))
		return
	var/list/L = src.alarms[class]
	var/cleared = 0
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/srcs  = alarm[3]
			if (origin in srcs)
				srcs -= origin
			if (srcs.len == 0)
				cleared = 1
				L -= I
	return !cleared

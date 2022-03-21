var/list/emergency_rooms = list()

/obj/machinery/emergency_room
	name = "Alarm button"
	desc = ""
	icon = 'icons/obj/monitors.dmi'
	icon_state = "ealarm0"
	var/normal_state = "ealarm0"
	var/active_state = "ealarm1"
	anchored = 1
	use_power = 1
	req_access = list(garrison)
	var/active = FALSE
	var/area/dunwell/station/activearea
	idle_power_usage = 10
	var/cooldown

/obj/machinery/emergency_room/New()
	..()
	activearea = get_area(src)
	emergency_rooms.Add(src)

/obj/machinery/emergency_room/process()
	..()
	if(active && !cooldown)
		playsound(src.loc, 'klaxon_alarm.ogg',50,0, 30, 30)
		cooldown = TRUE
		spawn(80)
			cooldown = FALSE

/obj/machinery/emergency_room/attack_hand(mob/living/carbon/human/user as mob)
	var/obj/item/device/radio/headset/bracelet/a = new /obj/item/device/radio/headset/bracelet(null)
	var/obj/item/weapon/card/id/idcard = user.wear_id
	if(user.handcuffed)
		return
	if(activearea.alarm_toggled)
		if(!user.wear_id)
			to_chat(user, "I have no ring to disable it!")
			return
		else
			for(var/req in req_access)
				if(!(req in idcard.access))
					to_chat(user, "You need Garrison access to unlock this!")
					return
				else
					to_chat(user, "You disable \the [src].")
					activearea.alarm_toggled = FALSE
					icon_state = normal_state
					active = FALSE
					processing_objects.Remove(src)
					return
	user.visible_message("<span class ='passivebold'>[user]</span> <span class='passive'>pushes \the [src]</span>", 1)
	icon_state = active_state
	a.autosay("Alert: An emergency alarm has been triggered in the [activearea.name]!", "Emergency")
	activearea.alarm_toggled = TRUE
	message_admins("[user.key] triggered a alarm.")
	playsound(src.loc, 'danger_alarm.ogg',80,0, 30, 30)
	active = TRUE
	spawn(20)
		processing_objects.Add(src)
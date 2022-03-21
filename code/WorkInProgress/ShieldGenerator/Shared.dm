/obj/machinery/shielding
	var/datum/shieldNetwork = null
	var/tmp/shieldnetnum = 0

/obj/machinery/shieldsbutton
	name = "Toggle Shields"
	icon = 'airlock_machines.dmi'
	icon_state = "access_button_standby"
	var/toggle = 0

	attack_hand(mob/user)
		if(!toggle)
			ShieldNetwork.startshields()
			icon_state = "access_button_standby"
			toggle = 1
		else
			ShieldNetwork.stopshields()
			toggle = 0
			icon_state = "access_button_standby"
		flick("access_button_cycle", src)
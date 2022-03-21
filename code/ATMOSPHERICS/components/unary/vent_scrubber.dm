/obj/machinery/atmospherics/unary/vent_scrubber
	icon = 'icons/obj/atmospherics/vent_scrubber.dmi'
	icon_state = "off"

	name = "Air Scrubber"
	desc = "Has a valve and pump attached to it"
	use_power = 1
	var/last_power_draw = 0

	level = 1

	var/area/initial_loc
	var/id_tag = null
	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/on = 0
	var/scrubbing = 1 //0 = siphoning, 1 = scrubbing
	var/list/scrubbing_gas = list("carbon_dioxide")
//	var/scrub_CO2 = 1
//	var/scrub_Toxins = 0
//	var/scrub_N2O = 0

	var/volume_rate = 120
	var/panic = 0 //is this scrubber panicked?

	var/area_uid
	var/radio_d_filter_out
	var/radio_d_filter_in
	New()
		init_obj.Add(src)
		initial_loc = get_area(loc)
		if (initial_loc.master)
			initial_loc = initial_loc.master
		area_uid = initial_loc.uid
		if (!id_tag)
			assign_uid()
			id_tag = num2text(uid)
		if(ticker && ticker.current_state == 3)//if the game is running
			src.initialize()
			src.broadcast_status()
		..()

	update_icon()
		if(node && on && !(stat & (NOPOWER|BROKEN)))
			if(scrubbing)
				icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]on"
			else
				icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]in"
		else
			icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]off"
		return

	proc
		set_frequency(new_frequency)
			radio_controller.remove_object(src, frequency)
			frequency = new_frequency
			radio_connection = radio_controller.add_object(src, frequency, radio_d_filter_in)

		broadcast_status()
			if(!radio_connection)
				return 0

			var/datum/signal/signal = new
			signal.transmission_method = 1 //radio signal
			signal.source = src
			signal.data = list(
				"area" = area_uid,
				"tag" = id_tag,
				"device" = "AScr",
				"timestamp" = world.time,
				"power" = on,
				"scrubbing" = scrubbing,
				"panic" = panic,
				"d_filter_co2" = ("carbon_dioxide" in scrubbing_gas),
				"d_filter_toxins" = ("plasma" in scrubbing_gas),
				"d_filter_n2o" = ("sleeping_agent" in scrubbing_gas),
				"sigtype" = "status"
			)
			if(!initial_loc.air_scrub_names[id_tag])
				var/new_name = "[initial_loc.name] Air Scrubber #[initial_loc.air_scrub_names.len+1]"
				initial_loc.air_scrub_names[id_tag] = new_name
				src.name = new_name
			initial_loc.air_scrub_info[id_tag] = signal.data
			radio_connection.post_signal(src, signal, radio_d_filter_out)

			return 1

	New()
		..()
		init_obj.Add(src)

	initialize()
		..()
		radio_d_filter_in = frequency==initial(frequency)?(RADIO_FROM_AIRALARM):null
		radio_d_filter_out = frequency==initial(frequency)?(RADIO_TO_AIRALARM):null
		if (frequency)
			set_frequency(frequency)

	process()
		..()
		if(stat & (NOPOWER|BROKEN))
			return
		if (!node)
			on = 0
		//broadcast_status()
		if(!on)
			return 0


		var/datum/gas_mixture/environment = loc.return_air()

		var/power_draw = -1
		if(scrubbing)
			//limit flow rate from turfs
			var/transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SCRUBBER_FLOWRATE/environment.volume)	//group_multiplier gets divided out here

			power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, active_power_usage)
		else //Just siphoning all air
		//limit flow rate from turfs
			var/transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SIPHON_FLOWRATE/environment.volume)	//group_multiplier gets divided out here

			power_draw = pump_gas(src, environment, air_contents, transfer_moles, active_power_usage)

		if (power_draw < 0)
			//update_use_power(0)
			use_power = 0	//don't force update. Sure, we will continue to use power even though we're not pumping anything, but it is easier on the CPU
			last_power_draw = 0
			last_flow_rate = 0
		else
			last_power_draw = handle_power_draw(power_draw)

		if(network)
			network.update = 1

		return 1
/* //unused piece of code
	hide(var/i) //to make the little pipe section invisible, the icon changes.
		if(on&&node)
			if(scrubbing)
				icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]on"
			else
				icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]in"
		else
			icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]off"
			on = 0
		return
*/

	receive_signal(datum/signal/signal)
		if(stat & (NOPOWER|BROKEN))
			return
		if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
			return 0

		if(signal.data["power"] != null)
			on = text2num(signal.data["power"])
		if(signal.data["power_toggle"] != null)
			on = !on

		if(signal.data["panic_siphon"]) //must be before if("scrubbing" thing
			panic = text2num(signal.data["panic_siphon"] != null)
			if(panic)
				on = 1
				scrubbing = 0
				volume_rate = 2000
			else
				scrubbing = 1
				volume_rate = initial(volume_rate)
		if(signal.data["toggle_panic_siphon"] != null)
			panic = !panic
			if(panic)
				on = 1
				scrubbing = 0
				volume_rate = 2000
			else
				scrubbing = 1
				volume_rate = initial(volume_rate)

		if(signal.data["scrubbing"] != null)
			scrubbing = text2num(signal.data["scrubbing"])
		if(signal.data["toggle_scrubbing"])
			scrubbing = !scrubbing

		var/list/toggle = list()

		if(!isnull(signal.data["co2_scrub"]) && text2num(signal.data["co2_scrub"]) != ("carbon_dioxide" in scrubbing_gas))
			toggle += "carbon_dioxide"
		else if(signal.data["toggle_co2_scrub"])
			toggle += "carbon_dioxide"

		if(!isnull(signal.data["tox_scrub"]) && text2num(signal.data["tox_scrub"]) != ("plasma" in scrubbing_gas))
			toggle += "plasma"
		else if(signal.data["toggle_tox_scrub"])
			toggle += "plasma"

		if(!isnull(signal.data["n2o_scrub"]) && text2num(signal.data["n2o_scrub"]) != ("sleeping_agent" in scrubbing_gas))
			toggle += "sleeping_agent"
		else if(signal.data["toggle_n2o_scrub"])
			toggle += "sleeping_agent"

		scrubbing_gas ^= toggle

		if(signal.data["init"] != null)
			name = signal.data["init"]
			return

		if(signal.data["status"] != null)
			spawn(2)
				broadcast_status()
			return //do not update_icon

//			log_admin("DEBUG \[[world.timeofday]\]: vent_scrubber/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
		spawn(2)
			broadcast_status()
		update_icon()
		return

	power_change()
		if(powered(power_channel))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER
		update_icon()

	attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
		if (!istype(W, /obj/item/weapon/wrench))
			return ..()
		if (!(stat & NOPOWER) && on)
			user << "\red You cannot unwrench this [src], turn it off first."
			return 1
		var/turf/T = src.loc
		if (level==1 && isturf(T) && T.intact)
			user << "\red You must remove the plating first."
			return 1
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
			user << "\red You cannot unwrench this [src], it too exerted due to internal pressure."
			add_fingerprint(user)
			return 1
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user << "\blue You begin to unfasten \the [src]..."
		if (do_after(user, 40))
			user.visible_message( \
				"[user] unfastens \the [src].", \
				"\blue You have unfastened \the [src].", \
				"You hear ratchet.")
			new /obj/item/pipe(loc, make_from=src)
			qdel(src)

/obj/machinery/atmospherics/unary/vent_scrubber/Destroy()
	if(initial_loc)
		initial_loc.air_scrub_info -= id_tag
		initial_loc.air_scrub_names -= id_tag
	..()
	return

/obj/machinery/atmospherics/unary/vent_scrubber/on
	on = 1

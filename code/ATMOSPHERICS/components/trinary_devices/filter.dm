obj/machinery/atmospherics/trinary/filter
	icon = 'icons/obj/atmospherics/filter.dmi'
	icon_state = "intact_off"
	density = 1

	name = "Gas filter"

	req_access = list(access_atmospherics)

	var/on = 0
	var/temp = null // -- TLE

	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_d_filter

	var/target_pressure = ONE_ATMOSPHERE

	var/filter_type = 0
/*
filter types:
-1: Nothing
 0: Carbon Molecules: Plasma Toxin, Oxygen Agent B
 1: Oxygen: Oxygen ONLY
 2: Nitrogen: Nitrogen ONLY
 3: Carbon Dioxide: Carbon Dioxide ONLY
 4: Sleeping Agent (N2O)
*/
	var/list/filtered_out = list()

	var/frequency = 0
	var/datum/radio_frequency/radio_connection

	proc
		set_frequency(new_frequency)
			radio_controller.remove_object(src, frequency)
			frequency = new_frequency
			if(frequency)
				radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

	New()
		..()
		init_obj.Add(src)
		switch(filter_type)
			if(0) //removing hydrocarbons
				filtered_out = list("plasma", "oxygen_agent_b")
			if(1) //removing O2
				filtered_out = list("oxygen")
			if(2) //removing N2
				filtered_out = list("nitrogen")
			if(3) //removing CO2
				filtered_out = list("carbon_dioxide")
			if(4)//removing N2O
				filtered_out = list("sleeping_agent")

		air1.volume = ATMOS_DEFAULT_VOLUME_d_filter
		air2.volume = ATMOS_DEFAULT_VOLUME_d_filter
		air3.volume = ATMOS_DEFAULT_VOLUME_d_filter

		if(radio_controller)
			initialize()
		..()

	update_icon()
		if(stat & NOPOWER)
			icon_state = "intact_off"
		else if(node2 && node3 && node1)
			icon_state = "intact_[on?("on"):("off")]"
		else
			icon_state = "intact_off"
			on = 0

		return

	power_change()
		var/old_stat = stat
		..()
		if(old_stat != stat)
			update_icon()

	process()
		..()
/*		if((stat & (NOPOWER|BROKEN)) || !on)
			update_use_power(0)	//usually we get here because a player turned a pump off - definitely want to update.
			last_flow_rate = 0
			return			//TODO Later - Guap6512
*/
		//Figure out the amount of moles to transfer
		var/transfer_moles = (set_flow_rate/air1.volume)*air1.total_moles

		var/power_draw = -1
		if (transfer_moles > MINUMUM_MOLES_TO_d_filter)
			power_draw = d_filter_gas(src, filtered_out, air1, air2, air3, transfer_moles, active_power_usage)

			if(network2)
				network2.update = 1

			if(network3)
				network3.update = 1

			if(network1)
				network1.update = 1

		if (power_draw < 0)
			//update_use_power(0)
			use_power = 0	//don't force update - easier on CPU
			last_flow_rate = 0
		else
			handle_power_draw(power_draw)

		return 1
	New()
		..()
		init_obj.Add(src)
	initialize()
		set_frequency(frequency)
		..()

	attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
		if (!istype(W, /obj/item/weapon/wrench))
			return ..()
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


obj/machinery/atmospherics/trinary/filter/attack_hand(user as mob) // -- TLE
	if(..())
		return

	if(!src.allowed(user))
		user << "\red Access denied."
		return

	var/dat
	var/current_filter_type
	switch(filter_type)
		if(0)
			current_filter_type = "Carbon Molecules"
		if(1)
			current_filter_type = "Oxygen"
		if(2)
			current_filter_type = "Nitrogen"
		if(3)
			current_filter_type = "Carbon Dioxide"
		if(4)
			current_filter_type = "Nitrous Oxide"
		if(-1)
			current_filter_type = "Nothing"
		else
			current_filter_type = "ERROR - Report this bug to the admin, please!"

	dat += {"
			<b>Power: </b><a href='?src=\ref[src];power=1'>[on?"On":"Off"]</a><br>
			<b>filtering: </b>[current_filter_type]<br><HR>
			<h4>Set filter Type:</h4>
			<A href='?src=\ref[src];filterset=0'>Carbon Molecules</A><BR>
			<A href='?src=\ref[src];filterset=1'>Oxygen</A><BR>
			<A href='?src=\ref[src];filterset=2'>Nitrogen</A><BR>
			<A href='?src=\ref[src];filterset=3'>Carbon Dioxide</A><BR>
			<A href='?src=\ref[src];filterset=4'>Nitrous Oxide</A><BR>
			<A href='?src=\ref[src];filterset=-1'>Nothing</A><BR>
			<HR><B>Desirable output pressure:</B>
			[src.target_pressure]kPa | <a href='?src=\ref[src];set_press=1'>Change</a>
			"}
/*
		user << browse("<HEAD><TITLE>[src.name] control</TITLE></HEAD>[dat]","window=atmo_filter")
		onclose(user, "atmo_filter")
		return

	if (src.temp)
		dat = text("<TT>[]</TT><BR><BR><A href='?src=\ref[];temp=1'>Clear Screen</A>", src.temp, src)
	//else
	//	src.on != src.on
*/
	user << browse("<HEAD><TITLE>[src.name] control</TITLE></HEAD><TT>[dat]</TT>", "window=atmo_filter")
	onclose(user, "atmo_filter")
	return

obj/machinery/atmospherics/trinary/filter/Topic(href, href_list) // -- TLE
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["filterset"])
		src.filter_type = text2num(href_list["filterset"])
	if (href_list["temp"])
		src.temp = null
	if(href_list["set_press"])
		var/new_pressure = input(usr,"Enter new output pressure (0-4500kPa)","Pressure control",src.target_pressure) as num
		src.target_pressure = max(0, min(4500, new_pressure))
	if(href_list["power"])
		on=!on
	src.update_icon()
	src.updateUsrDialog()
/*
	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			src.attack_hand(M)
*/
	return



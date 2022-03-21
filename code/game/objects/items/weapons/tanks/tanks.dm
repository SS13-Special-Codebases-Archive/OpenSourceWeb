#define TANK_MAX_RELEASE_PRESSURE (3*ONE_ATMOSPHERE)
#define TANK_DEFAULT_RELEASE_PRESSURE 24

/obj/item/weapon/tank
	name = "tank"
	icon = 'icons/obj/tank.dmi'
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BACK

	pressure_resistance = ONE_ATMOSPHERE*5

	force = 7.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4

	var/datum/gas_mixture/air_contents = null
	var/distribute_pressure = ONE_ATMOSPHERE
	var/integrity = 3
	var/volume = 70
	var/manipulated_by = null		//Used by _onclick/hud/screen_objects.dm internals to determine if someone has messed with our tank or not.
						//If they have and we haven't scanned it with the PDA or gas analyzer then we might just breath whatever they put in it.
/obj/item/weapon/tank/New()
	..()

	src.air_contents = new /datum/gas_mixture()
	src.air_contents.volume = volume //liters
	src.air_contents.temperature = T20C

	processing_objects.Add(src)
	return

/obj/item/weapon/tank/Destroy()
	if(air_contents)
		qdel(air_contents)

	processing_objects.Remove(src)

	..()

/obj/item/weapon/tank/examine()
	var/obj/icon = src
	if (istype(src.loc, /obj/item/assembly))
		icon = src.loc
	if (!in_range(src, usr))
		if (icon == src) usr << "\blue It's \a \icon[icon][src]! If you want any more information you'll need to get closer."
		return

	var/celsius_temperature = src.air_contents.temperature-T0C
	var/descriptive

	if (celsius_temperature < 20)
		descriptive = "cold"
	else if (celsius_temperature < 40)
		descriptive = "room temperature"
	else if (celsius_temperature < 80)
		descriptive = "lukewarm"
	else if (celsius_temperature < 100)
		descriptive = "warm"
	else if (celsius_temperature < 300)
		descriptive = "hot"
	else
		descriptive = "furiously hot"

	usr << "\blue \The \icon[icon][src] feels [descriptive]"

	return

/obj/item/weapon/tank/blob_act()
	if(prob(50))
		var/turf/location = src.loc
		if (!( istype(location, /turf) ))
			qdel(src)

		if(src.air_contents)
			location.assume_air(air_contents)

		qdel(src)

/obj/item/weapon/tank/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	var/obj/icon = src

	if (istype(src.loc, /obj/item/assembly))
		icon = src.loc

	if ((istype(W, /obj/item/device/analyzer)) && get_dist(user, src) <= 1)
		for (var/mob/O in viewers(user, null))
			O << "\red [user] has used [W] on \icon[icon] [src]"

		var/pressure = air_contents.return_pressure()
		manipulated_by = user.real_name			//This person is aware of the contents of the tank.
		var/total_moles = air_contents.total_moles

		user << "\blue Results of analysis of \icon[icon]"
		if (total_moles>0)
			user << "\blue Pressure: [round(pressure,0.1)] kPa"
			for(var/g in air_contents.gas)
				user << "\blue [gas_data.name[g]]: [(round(air_contents.gas[g] / total_moles) * 100)]%"
			user << "\blue Temperature: [round(air_contents.temperature-T0C)]&deg;C"
		else
			user << "\blue Tank is empty!"
		src.add_fingerprint(user)
	else if (istype(W,/obj/item/latexballon))
		var/obj/item/latexballon/LB = W
		LB.blow(src)
		src.add_fingerprint(user)

	if(istype(W, /obj/item/device/assembly_holder))
		bomb_assemble(W,user)

/obj/item/weapon/tank/attack_self(mob/user as mob)
	if (!(src.air_contents))
		return

	ui_interact(user)

/obj/item/weapon/tank/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)

	var/using_internal
	if(istype(loc,/mob/living/carbon))
		var/mob/living/carbon/location = loc
		if(location.internal==src)
			using_internal = 1

	// this is the data which will be sent to the ui
	var/data[0]
	data["tankPressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["releasePressure"] = round(distribute_pressure ? distribute_pressure : 0)
	data["defaultReleasePressure"] = round(TANK_DEFAULT_RELEASE_PRESSURE)
	data["maxReleasePressure"] = round(TANK_MAX_RELEASE_PRESSURE)
	data["valveOpen"] = using_internal ? 1 : 0

	data["maskConnected"] = 0
	if(istype(loc,/mob/living/carbon))
		var/mob/living/carbon/location = loc
		if(location.internal == src || (location.wear_mask && (location.wear_mask.flags & MASKINTERNALS)))
			data["maskConnected"] = 1

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "tanks.tmpl", "Tank", 500, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/item/weapon/tank/Topic(href, href_list)
	..()
	if (usr.stat|| usr.restrained())
		return 0
	if (src.loc != usr)
		return 0

	if (href_list["dist_p"])
		if (href_list["dist_p"] == "reset")
			src.distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
		else if (href_list["dist_p"] == "max")
			src.distribute_pressure = TANK_MAX_RELEASE_PRESSURE
		else
			var/cp = text2num(href_list["dist_p"])
			src.distribute_pressure += cp
		src.distribute_pressure = min(max(round(src.distribute_pressure), 0), TANK_MAX_RELEASE_PRESSURE)
	if (href_list["stat"])
		if(istype(loc,/mob/living/carbon))
			var/mob/living/carbon/location = loc
			if(location.internal == src)
				location.internal = null
				location.internals.icon_state = "internal0"
				usr << "\blue You close the tank release valve."
				if (location.internals)
					location.internals.icon_state = "internal0"
			else
				if(location.wear_mask && (location.wear_mask.flags & MASKINTERNALS))
					location.internal = src
					usr << "\blue You open \the [src] valve."
					if (location.internals)
						location.internals.icon_state = "internal1"
				else
					usr << "\blue You need something to connect to \the [src]."

	src.add_fingerprint(usr)
	return 1


/obj/item/weapon/tank/remove_air(amount)
	return air_contents.remove(amount)

/obj/item/weapon/tank/return_air()
	return air_contents

/obj/item/weapon/tank/assume_air(datum/gas_mixture/giver)
	air_contents.merge(giver)

	check_status()
	return 1

/obj/item/weapon/tank/proc/remove_air_volume(volume_to_return)
	if(!air_contents)
		return null

	var/tank_pressure = air_contents.return_pressure()
	if(tank_pressure < distribute_pressure)
		distribute_pressure = tank_pressure

	var/moles_needed = distribute_pressure*volume_to_return/(R_IDEAL_GAS_EQUATION*air_contents.temperature)

	return remove_air(moles_needed)

/obj/item/weapon/tank/process()
	//Allow for reactions
	air_contents.react()
	check_status()


/obj/item/weapon/tank/proc/check_status()
	//Handle exploding, leaking, and rupturing of the tank

	if(!air_contents)
		return 0

	var/pressure = air_contents.return_pressure()
	if(pressure > TANK_FRAGMENT_PRESSURE)
		if(!istype(src.loc,/obj/item/device/transfer_valve))
			message_admins("Explosive tank rupture! last key to touch the tank was [src.fingerprintslast].")
			log_game("Explosive tank rupture! last key to touch the tank was [src.fingerprintslast].")
		//world << "\blue[x],[y] tank is exploding: [pressure] kPa"
		//Give the gas a chance to build up more pressure through reacting
		air_contents.react()
		air_contents.react()
		air_contents.react()
		pressure = air_contents.return_pressure()
		var/range = (pressure-TANK_FRAGMENT_PRESSURE)/TANK_FRAGMENT_SCALE
		range = min(range, MAX_EXPLOSION_RANGE)		// was 8 - - - Changed to a configurable define -- TLE
		var/turf/epicenter = get_turf(loc)

		//world << "\blue Exploding Pressure: [pressure] kPa, intensity: [range]"

		explosion(epicenter, round(range*0.25), round(range*0.5), round(range), round(range*1.5))
		qdel(src)

	else if(pressure > TANK_RUPTURE_PRESSURE)
		//world << "\blue[x],[y] tank is rupturing: [pressure] kPa, integrity [integrity]"
		if(integrity <= 0)
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			T.assume_air(air_contents)
			playsound(src.loc, 'sound/effects/spray.ogg', 10, 1, -3)
			qdel(src)
		else
			integrity--

	else if(pressure > TANK_LEAK_PRESSURE)
		//world << "\blue[x],[y] tank is leaking: [pressure] kPa, integrity [integrity]"
		if(integrity <= 0)
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			var/datum/gas_mixture/leaked_gas = air_contents.remove_ratio(0.25)
			T.assume_air(leaked_gas)
		else
			integrity--

	else if(integrity < 3)
		integrity++


//Hydroponics tank and base code
/obj/item/weapon/watertank
	name = "backpack water tank"
	desc = "A S.U.N.S.H.I.N.E. brand watertank backpack with nozzle to water plants."
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "waterbackpack"
	item_state = "waterbackpack"
	w_class = 4.0
	slot_flags = SLOT_BACK
	slowdown = 1
	action_button_name = "Toggle Mister"

	var/obj/item/weapon/noz
	var/on = 0
	var/volume = 500


/obj/item/weapon/watertank/New()
	..()
	create_reagents(volume)
	noz = make_noz()
	return

/obj/item/weapon/watertank/examine()
	set src in usr
	..()
	for(var/datum/reagent/R in reagents.reagent_list)
		usr << "[round(R.volume)] units of [R.name] left."
	return

/obj/item/weapon/watertank/ui_action_click()
	if (usr.get_item_by_slot(slot_back) == src)
		toggle_mister()
	else
		usr << "<span class='notice'>The watertank needs to be on your back to use!</span>"
	return

/obj/item/weapon/watertank/verb/toggle_mister()
	set name = "Toggle Mister"
	set category = "Object"
	on = !on

	var/mob/living/carbon/human/user = usr
	if(on)
		//Detach the nozzle into the user's hands
		var/list/L = list("left hand" = slot_l_hand,"right hand" = slot_r_hand)
		if(!user.equip_in_one_of_slots(noz, L))
			on = 0
			user << "<span class='notice'>You need a free hand to hold the mister!</span>"
			return
		noz.loc = user
	else
		//Remove from their hands and put back "into" the tank
		remove_noz(user)
	return

/obj/item/weapon/watertank/proc/make_noz()
	return new /obj/item/weapon/reagent_containers/spray/mister(src)

/obj/item/weapon/watertank/equipped(mob/user, slot)
	if (slot != slot_back)
		remove_noz(user)

/obj/item/weapon/watertank/proc/remove_noz(mob/user)
	var/mob/living/carbon/human/M = user
	if(noz in get_both_hands(M))
		M.u_equip(noz)
	return

/obj/item/weapon/watertank/Destroy()
	if (on)
		var/H = get(noz, /mob)
		remove_noz(H)
	..()
	return

// This mister item is intended as an extension of the watertank and always attached to it.
// Therefore, it's designed to be "locked" to the player's hands or extended back onto
// the watertank backpack. Allowing it to be placed elsewhere or created without a parent
// watertank object will likely lead to weird behaviour or runtimes.
/obj/item/weapon/reagent_containers/spray/mister
	name = "water mister"
	desc = "A mister nozzle attached to a water tank."
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "mister"
	item_state = "mister"
	w_class = 4.0
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = list(25,50,100)
	volume = 500

	var/obj/item/weapon/watertank/tank

/obj/item/weapon/reagent_containers/spray/mister/New(parent_tank)
	..()
	if(check_tank_exists(parent_tank, src))
		tank = parent_tank
		reagents = tank.reagents	//This mister is really just a proxy for the tank's reagents
		loc = tank
	return

/obj/item/weapon/reagent_containers/spray/mister/dropped(mob/user as mob)
	user << "<span class='notice'>The mister snaps back onto the watertank!</span>"
	tank.on = 0
	loc = tank

/obj/item/weapon/reagent_containers/spray/mister/attack_self()
	return

/proc/check_tank_exists(parent_tank, var/mob/living/carbon/human/M, var/obj/O)
	if (!parent_tank || !istype(parent_tank, /obj/item/weapon/watertank))	//To avoid weird issues from admin spawns
		M.u_equip(O)
		qdel(0)
		return 0
	else
		return 1

//Janitor tank
/obj/item/weapon/watertank/janitor
	name = "backpack water tank"
	desc = "A janitorial watertank backpack with nozzle to clean dirt and graffiti."
	icon_state = "waterbackpackjani"
	item_state = "waterbackpackjani"

/obj/item/weapon/watertank/janitor/New()
	..()
	reagents.add_reagent("cleaner", 500)


/obj/item/weapon/reagent_containers/spray/mister/janitor
	name = "janitor spray nozzle"
	desc = "A janitorial spray nozzle attached to a watertank, designed to clean up large messes."
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "misterjani"
	item_state = "misterjani"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null

/obj/item/weapon/watertank/janitor/make_noz()
	return new /obj/item/weapon/reagent_containers/spray/mister/janitor(src)

/obj/item/weapon/reagent_containers/spray/mister/janitor/attack_self(var/mob/user)
	amount_per_transfer_from_this = (amount_per_transfer_from_this == 10 ? 5 : 10)
	user << "<span class='notice'>You [amount_per_transfer_from_this == 10 ? "remove" : "fix"] the nozzle. You'll now use [amount_per_transfer_from_this] units per spray.</span>"





//Atmos tank
/obj/item/weapon/watertank/atmos
	name = "backpack water tank"
	desc = "A backpack watertank with fire extinguisher nozzle, intended to fight fires. Shouldn't toxins have one of these?"
	icon_state = "waterbackpackatmos"
	item_state = "waterbackpackatmos"
	volume = 100

/obj/item/weapon/watertank/atmos/make_noz()
	return new /obj/item/weapon/extinguisher/mini/nozzle(src)

/obj/item/weapon/extinguisher/mini/nozzle
	name = "fire extinguisher nozzle"
	desc = "A fire extinguisher nozzle attached to a water tank."
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "misteratmos"
	item_state = "misteratmos"
	safety = 0
	var/obj/item/weapon/watertank/tank

/obj/item/weapon/extinguisher/mini/nozzle/New(parent_tank)
	if(check_tank_exists(parent_tank, src))
		tank = parent_tank
		reagents = tank.reagents
		max_water = tank.volume
		loc = tank
	return

/obj/item/weapon/extinguisher/mini/nozzle/dropped(mob/user as mob)
	user << "<span class='notice'>The nozzle snaps back onto the watertank!</span>"
	tank.on = 0
	loc = tank

/obj/item/weapon/extinguisher/mini/nozzle/attack_self()
	return
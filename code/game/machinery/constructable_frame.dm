//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "box_0"
	density = 1
	anchored = 1
	use_power = 0
	var/obj/item/weapon/circuitboard/circuit = null
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null
	var/state = 1

	// For pods
	var/list/connected_parts = list()
	var/pattern_idx=0


// unfortunately, we have to instance the objects really quickly to get the names
// fortunately, this is only called once when the board is added and the items are immediately GC'd
// and none of the parts do much in their constructors
/obj/machinery/constructable_frame/proc/update_namelist()
	if(!req_components)
		return

	req_component_names = new()
	for(var/tname in req_components)
		var/path = tname
		var/obj/O = new path()
		req_component_names[tname] = O.name

/obj/machinery/constructable_frame/proc/get_req_components_amt()
	var/amt = 0
	for(var/path in req_components)
		amt += req_components[path]
	return amt

// update description of required components remaining
/obj/machinery/constructable_frame/proc/update_req_desc()
	if(!req_components || !req_component_names)
		return

	var/hasContent = 0
	desc = "Requires"
	for(var/i = 1 to req_components.len)
		var/tname = req_components[i]
		var/amt = req_components[tname]
		if(amt == 0)
			continue
		var/use_and = i == req_components.len
		desc += "[(hasContent ? (use_and ? ", and" : ",") : "")] [amt] [amt == 1 ? req_component_names[tname] : "[req_component_names[tname]]\s"]"
		hasContent = 1

	if(!hasContent)
		desc = "Does not require any more components."
	else
		desc += "."

/obj/machinery/constructable_frame/machine_frame/proc/find_square()
	// This is fucking stupid but what the hell.

	// This corresponds to indicies from alldirs.
	//                         1      2      3     4     5          6          7          8
	// var/list/alldirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	var/valid_patterns=list(
		list(1,3,5), //SW - NORTH,EAST,NORTHEAST
		list(2,3,7), //NW - SOUTH,EAST,SOUTHEAST
		list(1,4,6), //SE - NORTH,WEST,NORTHWEST
		list(2,4,8)  //NE - SOUTH,WEST,SOUTHWEST
	)
	var/detected_parts[8]
	var/tally=0
	var/turf/T
	var/obj/machinery/constructable_frame/machine_frame/friend
	for(var/i=1;i<=8;i++)
		T=get_step(src.loc,alldirs[i])
		friend = locate() in T
		if(friend)
			detected_parts[i]=friend
			tally++
	// Need at least 3 connections to make a square
	if(tally<3)
		return
	// Find stuff in the patterns indicated
	for(var/i=1;i<=4;i++)
		var/list/scanidxs=valid_patterns[i]
		var/list/new_connected=list()
		var/allfound=1
		for(var/diridx in scanidxs)
			if(detected_parts[diridx]==null)
				allfound=0
				break
			new_connected.Add(detected_parts[diridx])
		if(allfound)
			connected_parts=new_connected
			pattern_idx=i
			return 1
	return 0

/obj/machinery/constructable_frame/machine_frame/attackby(obj/item/P as obj, mob/user as mob)
	if(P.crit_fail)
		user << "\red This part is faulty, you cannot add this to the machine!"
		return
	switch(state)
		if(1)
			if(istype(P, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = P
				if(C.amount >= 5)
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "\blue You start to add cables to the frame."
					if(do_after(user, 20))
						if(C)
							C.amount -= 5
							if(!C.amount) del(C)
							user << "\blue You add cables to the frame."
							state = 2
							icon_state = "box_1"
			else
				if(istype(P, /obj/item/weapon/wrench))
					playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
					user << "\blue You dismantle the frame"
					new /obj/item/stack/sheet/metal(src.loc, 5)
					qdel(src)
		if(2)
			if(istype(P, /obj/item/weapon/circuitboard))
				var/obj/item/weapon/circuitboard/B = P
				if(B.board_type == "machine")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "\blue You add the circuit board to the frame."
					circuit = P
					user.drop_item()
					P.loc = src
					icon_state = "box_2"
					state = 3
					components = list()
					req_components = circuit.req_components.Copy()
					for(var/A in circuit.req_components)
						req_components[A] = circuit.req_components[A]
					req_component_names = circuit.req_components.Copy()
					for(var/A in req_components)
						if(!ispath(A))
							A = text2path(A)
						var/obj/ct = new A() // have to quickly instantiate it get name
						req_component_names[A] = ct.name
					if(circuit.frame_desc)
						desc = circuit.frame_desc
					else
						update_req_desc()
					user << desc
				else
					user << "\red This frame does not accept circuit boards of this type!"
			else
				if(istype(P, /obj/item/weapon/wirecutters))
					playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
					user << "\blue You remove the cables."
					state = 1
					icon_state = "box_0"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
					A.amount = 5

		if(3)
			if(istype(P, /obj/item/weapon/crowbar))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				state = 2
				circuit.loc = src.loc
				circuit = null
				if(components.len == 0)
					user << "\blue You remove the circuit board."
				else
					user << "\blue You remove the circuit board and other components."
					for(var/obj/item/weapon/W in components)
						W.loc = src.loc
				desc = initial(desc)
				req_components = null
				components = null
				icon_state = "box_1"
			else if(istype(P, /obj/item/weapon/screwdriver))
				if(!get_req_components_amt())
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					var/obj/machinery/new_machine = new src.circuit.build_path(src.loc)
					new_machine.construction()
					for(var/obj/O in new_machine.component_parts)
						qdel(O)
					new_machine.component_parts = list()
					for(var/obj/O in src)
						O.loc = null
						new_machine.component_parts += O
					circuit.loc = null
					new_machine.RefreshParts()
					qdel(src)
			else if(istype(P, /obj/item/weapon/storage/part_replacer) && P.contents.len && get_req_components_amt())
				var/obj/item/weapon/storage/part_replacer/replacer = P
				var/list/added_components = list()
				var/list/part_list = list()

				//Assemble a list of current parts, then sort them by their rating!
				for(var/obj/item/weapon/stock_parts/co in replacer)
					part_list += co
				//Sort the parts. This ensures that higher tier items are applied first.
				part_list = sortTim(part_list, /proc/cmp_rped_sort)

				for(var/path in req_components)
					while(req_components[path] > 0 && (locate(path) in part_list))
						var/obj/item/part = (locate(path) in part_list)
						if(!part.crit_fail)
							added_components[part] = path
							replacer.remove_from_storage(part, src)
							req_components[path]--
							part_list -= part

				for(var/obj/item/weapon/stock_parts/part in added_components)
					components += part
					user << "<span class='notice'>[part.name] applied.</span>"
				replacer.play_rped_sound()

				update_req_desc()
				return
			else if(istype(P, /obj/item) && get_req_components_amt())
				for(var/I in req_components)
					if(!ispath(I))
						I = text2path(I)

					if(istype(P, I) && (req_components[I] > 0))
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
						if(istype(P, /obj/item/stack/cable_coil))
							var/obj/item/stack/cable_coil/CP = P
							if(CP.amount > 1)
								var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
								var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src)
								CC.amount = camt
								CC.update_icon()
								CP.use(camt)
								components += CC
								req_components[I] -= camt
								update_req_desc()
								break
						user.drop_item()
						P.loc = src
						components += P
						req_components[I]--
						update_req_desc()
						break
				user << desc
				if(P && P.loc != src && !istype(P, /obj/item/stack/cable_coil))
					user << "\red You cannot add that component to the machine!"


//Machine Frame Circuit Boards
/*Common Parts: Parts List: Ignitor, Timer, Infra-red laser, Infra-red sensor, t_scanner, Capacitor, Valve, sensor unit,
micro-manipulator, console screen, beaker, Microlaser, matter bin, power cells.
Note: Once everything is added to the public areas, will add m_amt and g_amt to circuit boards since autolathe won't be able
to destroy them and players will be able to make replacements.
*/
/obj/item/weapon/circuitboard/destructive_analyzer
	name = "Circuit board (Destructive Analyzer)"
	build_path = /obj/machinery/r_n_d/destructive_analyzer
	board_type = "machine"
	origin_tech = "magnets=2;engineering=2;programming=2"
	frame_desc = "Requires 1 Scanning Module, 1 Manipulator, and 1 Micro-Laser."
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1)

/obj/item/weapon/circuitboard/autolathe
	name = "Circuit board (Autolathe)"
	build_path = /obj/machinery/autolathe
	board_type = "machine"
	origin_tech = "engineering=2;programming=2"
	frame_desc = "Requires 3 Matter Bins, 1 Manipulator, and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 3,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/protolathe
	name = "Circuit board (Protolathe)"
	build_path = /obj/machinery/r_n_d/protolathe
	board_type = "machine"
	origin_tech = "engineering=2;programming=2"
	frame_desc = "Requires 2 Matter Bins, 2 Manipulators, and 2 Beakers."
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/reagent_containers/glass/beaker = 2)


/obj/item/weapon/circuitboard/circuit_imprinter
	name = "Circuit board (Circuit Imprinter)"
	build_path = /obj/machinery/r_n_d/circuit_imprinter
	board_type = "machine"
	origin_tech = "engineering=2;programming=2"
	frame_desc = "Requires 1 Matter Bin, 1 Manipulator, and 2 Beakers."
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/reagent_containers/glass/beaker = 2)

/obj/item/weapon/circuitboard/pacman
	name = "Circuit Board (PACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman
	board_type = "machine"
	origin_tech = "programming=3:powerstorage=3;plasmatech=3;engineering=3"
	frame_desc = "Requires 1 Matter Bin, 1 Micro-Laser, 2 Pieces of Cable, and 1 Capacitor."
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/capacitor = 1)

/obj/item/weapon/circuitboard/pacman/super
	name = "Circuit Board (SUPERPACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman/super
	origin_tech = "programming=3;powerstorage=4;engineering=4"

/obj/item/weapon/circuitboard/pacman/mrs
	name = "Circuit Board (MRSPACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman/mrs
	origin_tech = "programming=3;powerstorage=5;engineering=5"

/obj/item/weapon/circuitboard/rdserver
	name = "circuit Board (R&D Server)"
	build_path = /obj/machinery/r_n_d/server
	board_type = "machine"
	origin_tech = "programming=3"
	frame_desc = "Requires 2 pieces of cable, and 1 Scanning Module."
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/scanning_module = 1)

/obj/item/weapon/circuitboard/mechfab
	name = "circuit board (Exosuit Fabricator)"
	build_path = /obj/machinery/mecha_part_fabricator
	board_type = "machine"
	origin_tech = "programming=3;engineering=3"
	frame_desc = "Requires 2 Matter Bins, 1 Manipulator, 1 Micro-Laser and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/clonepod
	name = "circuit board (Clone Pod)"
	build_path = /obj/machinery/clonepod
	board_type = "machine"
	origin_tech = "programming=3;biotech=3"
	frame_desc = "Requires 2 Manipulator, 2 Scanning Module, 2 pieces of cable and 1 Console Screen."
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/scanning_module = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/clonescanner
	name = "circuit board (Cloning Scanner)"
	build_path = /obj/machinery/dna_scannernew
	board_type = "machine"
	origin_tech = "programming=2;biotech=2"
	frame_desc = "Requires 1 Scanning module, 1 Manipulator, 1 Micro-Laser, 2 pieces of cable and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 2)

/obj/item/weapon/circuitboard/biogenerator
	name = "circuit board (Biogenerator)"
	build_path = /obj/machinery/biogenerator
	board_type = "machine"
	origin_tech = "programming=3;biotech=2;materials=3"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)


/obj/item/weapon/circuitboard/chem_dispenser
	name = "circuit board (Portable Chem Dispenser)"
	build_path = /obj/machinery/chem_dispenser/constructable
	board_type = "machine"
	origin_tech = "materials=4;engineering=4;programming=4;plasmatech=3;biotech=3"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/cell = 1)

/obj/item/weapon/circuitboard/microwave
	name = "circuit board (Microwave)"
	build_path = /obj/machinery/microwave
	board_type = "machine"
	origin_tech = "programming=1"
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/mech_recharger
	name = "circuit board (Mechbay Recharger)"
	build_path = /obj/machinery/mech_bay_recharge_port
	board_type = "machine"
	origin_tech = "programming=3;powerstorage=4;engineering=4"
	req_components = list(
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/capacitor = 5)


// Telecomms circuit boards:

/obj/item/weapon/circuitboard/telecomms/receiver
	name = "circuit Board (Subspace Receiver)"
	build_path = /obj/machinery/telecomms/receiver
	board_type = "machine"
	origin_tech = "programming=4;engineering=3;bluespace=2"
	frame_desc = "Requires 1 Subspace Ansible, 1 Hyperwave filter, 2 Manipulators, and 1 Micro-Laser."
	req_components = list(
							/obj/item/weapon/stock_parts/subspace/ansible = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/micro_laser = 1)

/obj/item/weapon/circuitboard/telecomms/hub
	name = "Circuit Board (Hub Mainframe)"
	build_path = /obj/machinery/telecomms/hub
	board_type = "machine"
	origin_tech = "programming=4;engineering=4"
	frame_desc = "Requires 2 Manipulators, 2 Cable Coil and 2 Hyperwave filter."
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/subspace/filter = 2)

/obj/item/weapon/circuitboard/telecomms/relay
	name = "Circuit Board (Relay Mainframe)"
	build_path = /obj/machinery/telecomms/relay
	board_type = "machine"
	origin_tech = "programming=3;engineering=4;bluespace=3"
	frame_desc = "Requires 2 Manipulators, 2 Cable Coil and 2 Hyperwave filters."
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/subspace/filter = 2)

/obj/item/weapon/circuitboard/telecomms/bus
	name = "Circuit Board (Bus Mainframe)"
	build_path = /obj/machinery/telecomms/bus
	board_type = "machine"
	origin_tech = "programming=4;engineering=4"
	frame_desc = "Requires 2 Manipulators, 1 Cable Coil and 1 Hyperwave filter."
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1)

/obj/item/weapon/circuitboard/telecomms/processor
	name = "Circuit Board (Processor Unit)"
	build_path = /obj/machinery/telecomms/processor
	board_type = "machine"
	origin_tech = "programming=4;engineering=4"
	frame_desc = "Requires 3 Manipulators, 1 Hyperwave filter, 2 Treatment Disks, 1 Wavelength Analyzer, 2 Cable Coils and 1 Subspace Amplifier."
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 3,
							/obj/item/weapon/stock_parts/subspace/filter = 1,
							/obj/item/weapon/stock_parts/subspace/treatment = 2,
							/obj/item/weapon/stock_parts/subspace/analyzer = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/subspace/amplifier = 1)

/obj/item/weapon/circuitboard/telecomms/server
	name = "Circuit Board (Telecommunication Server)"
	build_path = /obj/machinery/telecomms/server
	board_type = "machine"
	origin_tech = "programming=4;engineering=4"
	frame_desc = "Requires 2 Manipulators, 1 Cable Coil and 1 Hyperwave filter."
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1)

/obj/item/weapon/circuitboard/telecomms/broadcaster
	name = "Circuit Board (Subspace Broadcaster)"
	build_path = /obj/machinery/telecomms/broadcaster
	board_type = "machine"
	origin_tech = "programming=4;engineering=4;bluespace=2"
	frame_desc = "Requires 2 Manipulators, 1 Cable Coil, 1 Hyperwave filter, 1 Ansible Crystal and 2 High-Powered Micro-Lasers. "
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1,
							/obj/item/weapon/stock_parts/subspace/crystal = 1,
							/obj/item/weapon/stock_parts/micro_laser/high = 2)

/obj/item/weapon/circuitboard/telesci_pad
	name = "circuit board (Telepad)"
	build_path = /obj/machinery/telepad
	board_type = "machine"
	origin_tech = "programming=4;engineering=3;materials=3;bluespace=4"
	frame_desc = "Requires 2 Bluespace crystal, 1 Cable Coil, 1 Capacitor and 1 Console screen. "
	req_components = list(
							/obj/item/weapon/stock_parts/bluespace_crystal = 2,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/chem_heater
	name = "circuit board (Chemical Heater)"
	build_path = /obj/machinery/chem_heater
	board_type = "machine"
	origin_tech = "materials=2;engineering=2"
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)


/obj/item/weapon/circuitboard/thermomachine
	name = "circuit board (Freezer)"
	desc = "Use screwdriver to switch between heating and cooling modes."
	build_path = /obj/machinery/atmospherics/unary/cold_sink/freezer
	board_type = "machine"
	origin_tech = "programming=3;plasmatech=3"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/thermomachine/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(build_path == /obj/machinery/atmospherics/unary/cold_sink/freezer)
			build_path = /obj/machinery/atmospherics/unary/heat_reservoir/heater
			name = "circuit board (Heater)"
			user << "<span class='notice'>You set the board to heating.</span>"
		else
			build_path = /obj/machinery/atmospherics/unary/cold_sink/freezer
			name = "circuit board (Freezer)"
			user << "<span class='notice'>You set the board to cooling.</span>"


/obj/item/weapon/circuitboard/clonepod
	name = "circuit board (Clone Pod)"
	build_path = /obj/machinery/clonepod
	board_type = "machine"
	origin_tech = "programming=3;biotech=3"
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/scanning_module = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)


/obj/item/weapon/circuitboard/engine
	name = "circuit board (Engine Nozzle)"
	build_path = /obj/machinery/atmospherics/unary/engine
	board_type = "machine"
	origin_tech = "programming=4;plasmatech=3"
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/weapon/stock_parts/matter_bin = 4)
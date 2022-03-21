//Config stuff
#define SUPPLY_DOCKZ 6          //Z-level of the Dock.
#define SUPPLY_STATIONZ 4       //Z-level of the Station.
#define SUPPLY_STATION_AREATYPE /area/supply/station //Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE /area/supply/dock	//Type of the supply shuttle area for dock

var/datum/controller/supply_shuttle/supply_shuttle = new()

var/list/mechtoys = list(
	/obj/item/toy/prize/ripley,
	/obj/item/toy/prize/fireripley,
	/obj/item/toy/prize/deathripley,
	/obj/item/toy/prize/gygax,
	/obj/item/toy/prize/durand,
	/obj/item/toy/prize/honk,
	/obj/item/toy/prize/marauder,
	/obj/item/toy/prize/seraph,
	/obj/item/toy/prize/mauler,
	/obj/item/toy/prize/odysseus,
	/obj/item/toy/prize/phazon
)

/area/supply/station //DO NOT TURN THE ul_Lighting STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "supply shuttle"
	icon_state = "shuttle3"
	luminosity = 1
	forced_ambience = list('sound/lfwbambimusic/atrementous-city.ogg', 'sound/lfwbambimusic/curvedblade.ogg', 'sound/lfwbambimusic/dustareallherbeauties.ogg', 'sound/fwambi/ravenheart7.ogg', 'sound/fwambi/happy_temple.ogg', 'sound/fwambi/many_torches.ogg')

/area/supply/dock //DO NOT TURN THE ul_Lighting STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "supply shuttle"
	icon_state = "shuttle3"
	luminosity = 1
	forced_ambience = list('sound/lfwbambimusic/atrementous-city.ogg', 'sound/lfwbambimusic/curvedblade.ogg', 'sound/lfwbambimusic/dustareallherbeauties.ogg', 'sound/fwambi/ravenheart7.ogg', 'sound/fwambi/happy_temple.ogg', 'sound/fwambi/many_torches.ogg')

//SUPPLY PACKS MOVED TO /code/defines/obj/supplypacks.dm

/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper Plastic flaps"
	desc = "I definitely cant get past those. No way."
	icon = 'icons/obj/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	density = 0
	anchored = 1
	layer = 4.1
	explosion_resistance = 5

/obj/structure/plasticflaps/CanPass(atom/A, turf/T)
	if(istype(A) && A.checkpass(PASSGLASS))
		return prob(60)

	var/obj/structure/stool/bed/B = A
	if (istype(A, /obj/structure/stool/bed) && B.buckled_mob)//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	else if(istype(A, /mob/living)) // You Shall Not Pass!
		var/mob/living/M = A
		if(!M.lying && !istype(M, /mob/living/carbon/monkey) && !istype(M, /mob/living/simple_animal/mouse) && !istype(M, /mob/living/simple_animal/hostile/giant_spider) && !istype(M, /mob/living/simple_animal/borer))  //If your not laying down, or a small creature, no pass.
			return 0
	return ..()

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(50))
				qdel(src)
		if (3)
			if (prob(5))
				qdel(src)

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "\improper Airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps."

	New() //set the turf below the flaps to block air
		var/turf/T = get_turf(loc)
		if(T)
			T.blocks_air = 1
		..()

	Destroy() //lazy hack to set the turf to allow air to pass if it's a simulated floor
		var/turf/T = get_turf(loc)
		if(T)
			if(istype(T, /turf/simulated/floor))
				T.blocks_air = 0
		..()

var/global/TaxUponSells = 20

/obj/machinery/computer/supplycomp
	name = "Bookmaking console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "supplycomp"
	circuit = "/obj/item/weapon/circuitboard/supplycomp"
	density = 0
	var/locked = FALSE
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/hacked = 0
	var/can_order_contraband = 0
	var/last_viewed_group = "categories"
	plane = 21

/obj/machinery/computer/ordercomp
	name = "Supply ordering console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "request"
	circuit = "/obj/item/weapon/circuitboard/ordercomp"
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/last_viewed_group = "categories"

/*
/obj/effect/marker/supplymarker
	icon_state = "X"
	icon = 'icons/misc/mark.dmi'
	name = "X"
	invisibility = 101
	anchored = 1
	opacity = 0
*/

/atom/var/item_worth = 0

/atom/proc/calc_worth()
	return

/datum/supply_order
	var/ordernum
	var/datum/supply_packs/object = null
	var/orderedby = null
	var/comment = null

/datum/controller/supply_shuttle
	processing = 1
	processing_interval = 300
	iteration = 0
	//supply points
	var/points = 50
	var/points_per_process = 0
	var/points_per_slip = 0
	var/points_per_crate = 0
	var/plasma_per_point = 0// 2 plasma for 1 point
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/supply_packs = list()
	//shuttle movement
	var/at_station = 0
	var/movetime = 600
	var/moving = 0
	var/eta_timeofday
	var/eta

	New()
		ordernum = rand(1,9000)

	//Supply shuttle ticker - handles supply point regenertion and shuttle travelling between centcomm and the station
	proc/process()
		for(var/typepath in (typesof(/datum/supply_packs) - /datum/supply_packs))
			var/datum/supply_packs/P = new typepath()
			supply_packs[P.name] = P

		spawn(0)
			set background = 1
			while(1)
				if(processing)
					iteration++
					points += points_per_process

					if(moving == 1)
						var/ticksleft = (eta_timeofday - world.timeofday)
						if(ticksleft > 0)
							eta = round(ticksleft/600,1)
						else
							eta = 0
							send()


				sleep(processing_interval)

	proc/send()
		var/area/from
		var/area/dest
		var/area/the_shuttles_way
		switch(at_station)
			if(1)
				from = locate(SUPPLY_STATION_AREATYPE)
				dest = locate(SUPPLY_DOCK_AREATYPE)
				the_shuttles_way = from
				at_station = 0
			if(0)
				from = locate(SUPPLY_DOCK_AREATYPE)
				dest = locate(SUPPLY_STATION_AREATYPE)
				the_shuttles_way = dest
				at_station = 1
				playsound(pick(dest?.contents), 'sound/webbers/docked.ogg', 100, 1)
		moving = 0

		//Do I really need to explain this loop?
		for(var/mob/living/unlucky_person in the_shuttles_way)
			unlucky_person.gib()

		from.move_contents_to(dest)

	//Check whether the shuttle is allowed to move
	proc/can_move()
		if(moving) return 0

		var/area/shuttle = locate(/area/supply/station)
		if(!shuttle) return 0

		if(forbidden_atoms_check(shuttle))
			return 0

		return 1

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
	proc/forbidden_atoms_check(atom/A)
		if(istype(A,/mob/living))
			return 1
		if(istype(A,/obj/item/weapon/disk/nuclear))
			return 1
		if(istype(A,/obj/machinery/nuclearbomb))
			return 1
		if(istype(A,/obj/item/device/radio/beacon))
			return 1

		for(var/i=1, i<=A.contents.len, i++)
			var/atom/B = A.contents[i]
			if(.(B))
				return 1

	//Sellin
	proc/sell()
		var/shuttle_at
		if(at_station)	shuttle_at = SUPPLY_STATION_AREATYPE
		else			shuttle_at = SUPPLY_DOCK_AREATYPE

		var/area/shuttle = locate(shuttle_at)
		if(!shuttle)	return


		for(var/atom/movable/MA in shuttle)
			if(MA.anchored)	continue

			// Must be in a crate!
			if(istype(MA,/obj/structure/closet) || istype(MA,/obj/structure/merchant_crates))
				//points += points_per_crate
				var/atom/LC
				if(istype(MA,/obj/structure/merchant_crates))
					LC = MA:storage_inside
				else
					LC = MA
				for(var/atom/A in LC)
					A.calc_worth() //used for batteries
					// Sell manifests
					if(A.item_worth)
						//points += A.item_worth
						if(taxes >= 1)
							/*var/itemdiscount = A.item_worth
							itemdiscount = (A.item_worth / 100) * taxes
							var/totalitemworth = A.item_worth
							totalitemworth -= itemdiscount
							points += totalitemworth
							treasuryworth.add_money(itemdiscount)*/
							points += A.item_worth
						else
							points += A.item_worth
					if(master_mode == "kingwill")
						ticker.mode:checkSellKing(A)
					// Sell plasma
			qdel(MA)

/*
		for(var/obj/MA in shuttle)
			if(!MA.anchored)
				if(MA.item_worth)
					var/itemdiscount = MA.item_worth
					itemdiscount %= taxes
					var/totalitemworth = MA.item_worth
					totalitemworth -= itemdiscount
					points += totalitemworth
					for(var/obj/effect/landmark/L in landmarks_list)
						if (L.name == "Treasury")
							spawn_money(itemdiscount,L.loc)*/
	//Buyin
	proc/buy()
		if(!shoppinglist.len) return

		var/shuttle_at
		if(at_station)	shuttle_at = SUPPLY_STATION_AREATYPE
		else			shuttle_at = SUPPLY_DOCK_AREATYPE

		var/area/shuttle = locate(shuttle_at)
		if(!shuttle)	return

		var/list/clear_turfs = list()

		for(var/turf/T in shuttle)
			var/cango = 1
			for(var/atom/A in T)
				if(istype(A, /atom/movable/lighting_overlay)) continue
				cango = 0
			if(T.density || cango)	continue
			clear_turfs += T

		var/random_loc = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[random_loc]
		clear_turfs.Cut(random_loc,random_loc+1)
		var/obj/structure/merchant_crates/A = new /obj/structure/merchant_crates(pickedloc)

		for(var/S in shoppinglist)
			if(!clear_turfs.len)	break

			var/datum/supply_order/SO = S
			var/datum/supply_packs/SP = SO.object

			//supply manifest generation begin
/*
			var/obj/item/weapon/paper/manifest/slip = new /obj/item/weapon/paper/manifest(A)
			slip.info = "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			slip.info +="Order #[SO.ordernum]<br>"
			slip.info +="Destination: [vessel_name]<br>"
			slip.info +="[supply_shuttle.shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			slip.info +="CONTENTS:<br><ul>"
*/
			//spawn the stuff, finish generating the manifest while you're at it
			if(SP.access)
				A:req_access = list()
				A:req_access += text2num(SP.access)

			/*var/list/contains
			if(istype(SP,/datum/supply_packs/randomised))
				var/datum/supply_packs/randomised/SPR = SP
				contains = list()
				if(SPR.contains.len)
					for(var/j=1,j<=SPR.num_contained,j++)
						contains += pick(SPR.contains)
			else
				contains = SP.contains*/

			for(var/typepath in SP.contains)
				if(!typepath)	continue
				if(A.storage_inside.contents.len >= A.storage_inside.storage_slots)
					random_loc = rand(1,clear_turfs.len)
					pickedloc = clear_turfs[random_loc]
					clear_turfs.Cut(random_loc,random_loc+1)
					A = new /obj/structure/merchant_crates(pickedloc)

				var/atom/B2 = new typepath(A.storage_inside)
				if(SP.amount && B2:amount) B2:amount = SP.amount
				//slip.info += "<li>[B2.name]</li>" //add the item to the manifest

			//manifest finalisation
			//slip.info += "</ul><br>"
			//slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"
		//	if (SP.contraband) slip.loc = null	//we are out of blanks for Form #44-D Ordering Illicit Drugs.

		supply_shuttle.shoppinglist.Cut()
		return

/obj/item/weapon/paper/manifest
	name = "Supply Manifest"


/obj/machinery/computer/ordercomp/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/ordercomp/attack_paw(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/supplycomp/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/supplycomp/attack_paw(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/ordercomp/attack_hand(var/mob/user as mob)
	if(..())
		return
	if(level_check()==0)	return
	user.set_machine(src)
	var/dat
	if(temp)
		dat = temp
	else
		dat += {"<BR><B>Supply shuttle</B><HR>
		Location: [supply_shuttle.moving ? "Moving to station ([supply_shuttle.eta] Mins.)":supply_shuttle.at_station ? "Station":"Dock"]<BR>
		<HR>Supply points: [supply_shuttle.points]<BR>
		<BR>\n<A href='?src=\ref[src];order=categories'>Request items</A><BR><BR>
		<A href='?src=\ref[src];vieworders=1'>View approved orders</A><BR><BR>
		<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR><BR>
		<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/ordercomp/Topic(href, href_list)
	if(..())
		return

	if( isturf(loc) && (in_range(src, usr) || istype(usr, /mob/living/silicon)) )
		usr.set_machine(src)

	if(href_list["order"])
		if(href_list["order"] == "categories")
			//all_supply_groups
			//Request what?
			last_viewed_group = "categories"
			temp = "<b>Supply points: [supply_shuttle.points]</b><BR>"
			temp += "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><HR><BR><BR>"
			temp += "<b>Select a category</b><BR><BR>"
			for(var/supply_group_name in all_supply_groups )
				temp += "<A href='?src=\ref[src];order=[supply_group_name]'>[supply_group_name]</A><BR>"
		else
			last_viewed_group = href_list["order"]
			temp = "<b>Supply points: [supply_shuttle.points]</b><BR>"
			temp += "<A href='?src=\ref[src];order=categories'>Back to all categories</A><HR><BR><BR>"
			temp += "<b>Request from: [last_viewed_group]</b><BR><BR>"
			for(var/supply_name in supply_shuttle.supply_packs )
				var/datum/supply_packs/N = supply_shuttle.supply_packs[supply_name]
				if(N.hidden || N.contraband || N.group != last_viewed_group) continue								//Have to send the type instead of a reference to
				temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: [N.cost]<BR>"		//the obj because it would get caught by the garbage

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
			return

		//Find the correct supply_pack datum
		var/datum/supply_packs/P = supply_shuttle.supply_packs[href_list["doorder"]]
		if(!istype(P))	return

		var/timeout = world.time + 600
		//var/reason = sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text)
		if(world.time > timeout)	return
		//if(!reason)	return

		var/idname = "*None Provided*"
		//var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			//idrank = H.get_assignment()
		else if(issilicon(usr))
			idname = usr.real_name

		supply_shuttle.ordernum++
/*
		var/obj/item/weapon/paper/reqform = new /obj/item/weapon/paper(loc)
		reqform.name = "Requisition Form - [P.name]"
		reqform.info += "<h3>[vessel_name] Supply Requisition Form</h3><hr>"
		reqform.info += "INDEX: #[supply_shuttle.ordernum]<br>"
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [replaceText(get_access_desc(P.access))]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += P.manifest
		reqform.info += "<hr>"
		reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon()	//Fix for appearing blank when printed.
*/
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_shuttle.ordernum
		O.object = P
		O.orderedby = idname
		supply_shuttle.requestlist += O

		temp = "Thanks for your request. The cargo team will process it as soon as possible.<BR>"
		temp += "<BR><A href='?src=\ref[src];order=[last_viewed_group]'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["vieworders"])
		temp = "Current approved orders: <BR><BR>"
		for(var/S in supply_shuttle.shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.orderedby] [SO.comment ? "([SO.comment])":""]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["viewrequests"])
		temp = "Current requests: <BR><BR>"
		for(var/S in supply_shuttle.requestlist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/supplycomp/attack_hand(var/mob/user as mob)
	if(level_check()==0)	return
	if(locked)
		to_chat(user, "<span class='combat'>Console is locked!</span>")
		return
	if(!allowed(user))
		user << "\red Access Denied."
		return

	if(..())
		return
	user.set_machine(src)
	post_signal("supply")
	var/dat = "<html><head><style> a{color:white; font-size: 125%; text-decoration: none;}a:hover{text-decoration: underline} body{font-size: 135%}</style><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f; text-align: center;'>"
	if (temp)
		dat = temp
	else
		dat += {"<html><head><title>Bookmaking Console</title>
		<body style='background-color:#0e0c0e; color: #43302f;'>
		<BR><B>Merchant Guild</B><HR>
		\nO Boat is [supply_shuttle.moving ? "coming to Firethorn ([supply_shuttle.eta] Mins.)":supply_shuttle.at_station ? "in Firethorn":"in City."]<BR>
		<HR>\nEm sua conta: [supply_shuttle.points] obols.<BR>\n<BR>
		[supply_shuttle.moving ? "\nBoat must be in the city to take orders.<BR>\n<BR>":supply_shuttle.at_station ? "\nThe Boat must be in the city to make orders.<BR>\n<BR>":"\n<A href='?src=\ref[src];order=categories'>Make Orders</A><BR>\n<BR>"]
		[supply_shuttle.moving ? "\nThe boat has already been called.<BR>\n<BR>":supply_shuttle.at_station ? "\n<A href='?src=\ref[src];send=1'>Send boat to the city.</A><BR>\n<BR>":"\n<A href='?src=\ref[src];send=1'>Send boat back to the fortress.</A><BR>\n<BR>"]
		\n<A href='?src=\ref[src];withdraw=1'>Withdraw obols</A><BR>\n<BR>
		\n<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR>\n<BR>
		\n<A href='?src=\ref[src];vieworders=1'>View orders</A><BR>\n<BR>
		\n<A href='?src=\ref[src];changetaxes=1'>Current Taxes upon Vendors: [TaxUponSells]%!</A><BR>\n<BR>
		\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=player_panel;size=600x600;can_close=1;can_resize=0;border=0;titlebar=1")
	onclose(user, "computer")
	return

/obj/machinery/computer/supplycomp/RightClick(mob/living/carbon/human/user as mob)
	if(ishuman(user) && user.wear_id)
		var/obj/item/weapon/card/id/idcard = user.wear_id
		if(!istype(idcard, /obj/item/weapon/card/id/qm)) return
		if(locked)
			locked = FALSE
			to_chat(user, "You have unlocked the console.")
		else
			locked = TRUE
			to_chat(user, "You have locked the console.")

/obj/machinery/computer/supplycomp/attackby(I as obj, user as mob)
	if(istype(I,/obj/item/weapon/card/emag) && !hacked)
		user << "\blue Special supplies unlocked."
		hacked = 1
		return
	if(istype(I,/obj/item/weapon/spacecash))
		supply_shuttle.points += I:worth
		qdel(I)
		playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)
		return

	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )
				new /obj/item/weapon/shard( loc )
				var/obj/item/weapon/circuitboard/supplycomp/M = new /obj/item/weapon/circuitboard/supplycomp( A )
				for (var/obj/C in src)
					C.loc = loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				qdel(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )
				var/obj/item/weapon/circuitboard/supplycomp/M = new /obj/item/weapon/circuitboard/supplycomp( A )
				if(can_order_contraband)
					M.contraband_enabled = 1
				for (var/obj/C in src)
					C.loc = loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				qdel(src)
	else
		attack_hand(user)
	return

/obj/machinery/computer/supplycomp/Topic(href, href_list)
	var/sounds = pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg')
	playsound(src.loc, sounds, 25, 1)
	if(!supply_shuttle)
		world.log << "## ERROR: Eek. The supply_shuttle controller datum is missing somehow."
		return
	if(..())
		return

	if(isturf(loc) && ( in_range(src, usr) || istype(usr, /mob/living/silicon) ) )
		usr.set_machine(src)

	//Calling the shuttle
	if(href_list["send"])
		if(!supply_shuttle.can_move())
			temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
			temp += "For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

		else if(supply_shuttle.at_station)
			supply_shuttle.moving = -1
			supply_shuttle.sell()
			supply_shuttle.send()
			temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
			temp += "The supply shuttle has departed.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		else
			supply_shuttle.moving = 1
			supply_shuttle.buy()
			supply_shuttle.eta_timeofday = (world.timeofday + supply_shuttle.movetime) % 864000
			temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
			temp += "The supply shuttle has been called and will arrive in [round(supply_shuttle.movetime/600,1)] minutes.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
			post_signal("supply")

	else if (href_list["order"])
		if(supply_shuttle.moving) return
		if(href_list["order"] == "categories")
			//all_supply_groups
			//Request what?
			last_viewed_group = "categories"
			temp = "<html><head><style> a{color:white; font-size: 125%; text-decoration: none;}a:hover{text-decoration: underline} body{font-size: 135%}</style><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f; text-align: center;'>"
			temp += "<b>Conta: [supply_shuttle.points]</b><BR>"
			temp += "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><HR><BR><BR>"
			temp += "<b>Select a category:</b><BR><BR>"
			for(var/supply_group_name in all_supply_groups )
				temp += "<A href='?src=\ref[src];order=[supply_group_name]'>[supply_group_name]</A><BR><BR>"
		else
			last_viewed_group = href_list["order"]
			temp = "<html><head><style> a{color:white; font-size: 125%; text-decoration: none;}a:hover{text-decoration: underline} body{font-size: 135%}</style><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f; text-align: center;'>"
			temp += "<b>Supply points: [supply_shuttle.points]</b><BR>"
			temp += "<A href='?src=\ref[src];order=categories'>Back to all categories</A><HR><BR><BR>"
			temp += "<b>Request from: [last_viewed_group]</b><BR><BR>"
			for(var/supply_name in supply_shuttle.supply_packs )
				var/datum/supply_packs/N = supply_shuttle.supply_packs[supply_name]
				if((N.hidden && !hacked) || (N.contraband && !can_order_contraband) || N.group != last_viewed_group || (N.is_weapon && gunban)) continue								//Have to send the type instead of a reference to
				temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Price: [cost_with_taxes(N)] obols<BR>"		//the obj because it would get caught by the garbage

		/*temp = "Supply points: [supply_shuttle.points]<BR><HR><BR>Request what?<BR><BR>"

		for(var/supply_name in supply_shuttle.supply_packs )
			var/datum/supply_packs/N = supply_shuttle.supply_packs[supply_name]
			if(N.hidden && !hacked) continue
			if(N.contraband && !can_order_contraband) continue
			temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: [N.cost]<BR>"    //the obj because it would get caught by the garbage
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"*/

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
			return

		//Find the correct supply_pack datum
		var/datum/supply_packs/P = supply_shuttle.supply_packs[href_list["doorder"]]
		if(!istype(P))	return

		var/timeout = world.time + 600
		//var/reason = sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text)
		if(world.time > timeout)	return
		//if(!reason)	return

		var/idname = "*None Provided*"
		//var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			//idrank = H.get_assignment()
		else if(issilicon(usr))
			idname = usr.real_name

		supply_shuttle.ordernum++
		/*var/obj/item/weapon/paper/reqform = new /obj/item/weapon/paper(loc)
		reqform.name = "Requisition Form - [P.name]"
		reqform.info += "<h3>[vessel_name] Supply Requisition Form</h3><hr>"
		reqform.info += "INDEX: #[supply_shuttle.ordernum]<br>"
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [replaceText(get_access_desc(P.access))]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += P.manifest
		reqform.info += "<hr>"
		reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon()*/	//Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_shuttle.ordernum
		O.object = P
		O.orderedby = idname
		supply_shuttle.requestlist += O

		temp = "<html><head><style> a{color:white; font-size: 125%; text-decoration: none;}a:hover{text-decoration: underline} body{font-size: 135%}</style><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f; text-align: center;'>"
		temp += "Order request placed.<BR>"
		temp += "<BR><A href='?src=\ref[src];order=[last_viewed_group]'>Back</A> | <A href='?src=\ref[src];mainmenu=1'>Main Menu</A> | <A href='?src=\ref[src];confirmorder=[O.ordernum]'>Confirm Order</A>"

	else if(href_list["confirmorder"])
		//Find the correct supply_order datum
		var/ordernum = text2num(href_list["confirmorder"])
		var/datum/supply_order/O
		var/datum/supply_packs/P
		temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
		temp += "Invalid Request"
		for(var/i=1, i<=supply_shuttle.requestlist.len, i++)
			var/datum/supply_order/SO = supply_shuttle.requestlist[i]
			if(SO.ordernum == ordernum)
				O = SO
				P = O.object
				var/cost_of_supply = cost_with_taxes(P)
				if(supply_shuttle.points >= cost_of_supply)
					supply_shuttle.requestlist.Cut(i,i+1)
					supply_shuttle.points -= cost_of_supply
					treasuryworth.add_money(cost_of_supply - P.cost)
					supply_shuttle.shoppinglist += O
					temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
					temp += "Thanks for your order.<BR>"
					temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
				else
					temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
					temp += "Not enough supply points.<BR>"
					temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
				break

	else if(href_list["withdraw"])
		playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
		if(supply_shuttle.points)
			usr << "<i>The terminal has [supply_shuttle.points] obols.</i>"
			var/obols_type = input("Terminal", "Select a obol type. Copper : 1, Silver : 4, Gold : 16") in list("Copper", "Silver", "Gold","Cancel")
			var/obols_div = 1
			if(obols_type == "Cancel")
				return
			else if(obols_type == "Silver")
				obols_div = 4

			else if(obols_type == "Gold")
				obols_div = 16

			var/withdraw = input("How much you want to withdraw | There is [round(supply_shuttle.points / obols_div)] [obols_type] obols in the terminal.","Terminal",supply_shuttle.points)
			if(!withdraw)
				return
			if(withdraw > round(supply_shuttle.points / obols_div))
				usr << "There's not enough obols to withdraw that amount!"
				return
			if(withdraw < 0)
				usr << "negro nem tente"
				usr << 'olha-o-macaco.ogg'
				return
			if(withdraw <= supply_shuttle.points)
				usr << "<i>You withdraw [withdraw] obols.</i>"
				playsound(src.loc, 'sound/effects/coin_m.ogg', 30, 0)
				switch(obols_type)
					if("Gold")
						spawn_money_gold(withdraw,usr.loc)
					if("Silver")
						spawn_money_silver(withdraw,usr.loc)
					if("Copper")
						spawn_money(withdraw,usr.loc)
				supply_shuttle.points -= withdraw * obols_div

	else if (href_list["vieworders"])
		temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
		temp += "Current approved orders: <BR><BR>"
		for(var/S in supply_shuttle.shoppinglist)
			var/datum/supply_order/SO = S
			temp += "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
			temp += "#[SO.ordernum] - [SO.object.name] approved by [SO.orderedby][SO.comment ? " ([SO.comment])":""]<BR>"// <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if(href_list["changetaxes"])
		playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
		var/input = sanitize_uni(input(usr, "Choose between 0 and 100 percent.", "Firethorn Decree", "") as num)
		if(input > 100 || input < 1)
			return
		TaxUponSells = input
		playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
/*
	else if (href_list["cancelorder"])
		var/datum/supply_order/remove_supply = href_list["cancelorder"]
		supply_shuttle_shoppinglist -= remove_supply
		supply_shuttle_points += remove_supply.object.cost
		temp += "Canceled: [remove_supply.object.name]<BR><BR><BR>"

		for(var/S in supply_shuttle_shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.orderedby][SO.comment ? " ([SO.comment])":""] <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
*/
	else if (href_list["viewrequests"])
		temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
		temp += "Current requests: <BR><BR>"
		for(var/S in supply_shuttle.requestlist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby]  [supply_shuttle.moving ? "":supply_shuttle.at_station ? "":"<A href='?src=\ref[src];confirmorder=[SO.ordernum]'>Approve</A> <A href='?src=\ref[src];rreq=[SO.ordernum]'>Remove</A>"]<BR>"

		temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
		temp += "<BR><A href='?src=\ref[src];clearreq=1'>Clear list</A>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["rreq"])
		var/ordernum = text2num(href_list["rreq"])
		temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
		temp += "Invalid Request.<BR>"
		for(var/i=1, i<=supply_shuttle.requestlist.len, i++)
			var/datum/supply_order/SO = supply_shuttle.requestlist[i]
			if(SO.ordernum == ordernum)
				supply_shuttle.requestlist.Cut(i,i+1)
				temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
				temp += "Request removed.<BR>"
				break
		temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["clearreq"])
		supply_shuttle.requestlist.Cut()
		temp = "<html><head><title>Console Mercante</title> <body style='background-color:#0e0c0e; color: #43302f;'>"
		temp += "List cleared.<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/supplycomp/proc/post_signal(var/command)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)

/obj/machinery/computer/supplycomp/proc/cost_with_taxes(var/datum/supply_packs/supply)
	var/C = supply.cost
	if(C == 0)
		return 0
	return round(C + ((C / 100) * taxes))




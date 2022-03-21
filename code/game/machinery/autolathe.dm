//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

var/global/list/autolathe_recipes = list( \
		/* screwdriver removed*/ \
		new /obj/item/weapon/reagent_containers/glass/bucket(), \
		new /obj/item/weapon/crowbar(), \
		new /obj/item/device/flashlight(), \
		new /obj/item/weapon/extinguisher(), \
		new /obj/item/device/multitool(), \
		new /obj/item/device/t_scanner(), \
		new /obj/item/weapon/weldingtool(), \
		new /obj/item/weapon/screwdriver(), \
		new /obj/item/weapon/wirecutters(), \
		new /obj/item/weapon/wrench(), \
		new /obj/item/clothing/head/welding(), \
		new /obj/item/weapon/stock_parts/console_screen(), \
		new /obj/item/weapon/airlock_electronics(), \
		new /obj/item/weapon/airalarm_electronics(), \
		new /obj/item/weapon/firealarm_electronics(), \
		new /obj/item/weapon/module/power_control(), \
		new /obj/item/stack/sheet/metal(), \
		new /obj/item/stack/sheet/glass(), \
		new /obj/item/stack/sheet/rglass(), \
		new /obj/item/stack/rods(), \
		new /obj/item/weapon/rcd_ammo(), \
		new /obj/item/weapon/kitchenknife(), \
		new /obj/item/weapon/surgery_tool/scalpel(), \
		new /obj/item/weapon/surgery_tool/circular_saw(), \
		new /obj/item/weapon/surgery_tool/surgicaldrill(),\
		new /obj/item/weapon/surgery_tool/retractor(),\
		new /obj/item/weapon/surgery_tool/cautery(),\
		new /obj/item/weapon/surgery_tool/hemostat(),\
		new /obj/item/weapon/reagent_containers/glass/beaker(), \
		new /obj/item/weapon/reagent_containers/glass/beaker/large(), \
		new /obj/item/weapon/reagent_containers/glass/beaker/vial(), \
		new /obj/item/weapon/reagent_containers/syringe(), \
		new /obj/item/ammo_casing/shotgun/blank(), \
		new /obj/item/ammo_casing/shotgun/beanbag(), \
		new /obj/item/ammo_casing/shotgun/improvised(), \
		new /obj/item/device/taperecorder(), \
		new /obj/item/device/assembly/igniter(), \
		new /obj/item/device/assembly/signaler(), \
		new /obj/item/device/radio/headset(), \
		new /obj/item/device/radio/off(), \
		new /obj/item/device/assembly/infra(), \
		new /obj/item/device/assembly/timer(), \
		new /obj/item/device/assembly/voice(), \
		new /obj/item/device/assembly/prox_sensor(), \
		new /obj/item/weapon/light/tube(), \
		new /obj/item/weapon/light/bulb(), \
		new /obj/item/weapon/camera_assembly(), \
	)

var/global/list/autolathe_recipes_hidden = list( \
		new /obj/item/weapon/flamethrower/full(), \
		new /obj/item/weapon/rcd(), \
		new /obj/item/device/radio/electropack(), \
		new /obj/item/weapon/weldingtool/largetank(), \
		new /obj/item/weapon/handcuffs(), \
		new /obj/item/ammo_magazine/box/a357(), \
		new /obj/item/ammo_casing/shotgun(), \
		new /obj/item/ammo_casing/shotgun/dart(), \
		/* new /obj/item/weapon/shield/riot(), */ \
	)

/obj/machinery/autolathe
	name = "\improper Autolathe"
	desc = "It produces items using metal and glass."
	icon_state = "autolathe"
	density = 1

	var/m_amount = 0.0
	var/max_m_amount = 150000.0
	var/g_amount = 0.0
	var/max_g_amount = 75000.0
	var/prod_coeff = 1

	var/operating = 0.0
	anchored = 1.0
	var/list/current_recipes = list()
	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/datum/wires/autolathe/wires

	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100
	var/busy = 0

	proc

		regular_win(mob/user as mob)
			var/dat = "<B>Metal Amount:</B> [m_amount] cm<sup>3</sup> (MAX: [max_m_amount])<BR>"
			dat += "<FONT color=blue><B>Glass Amount:</B></FONT> [g_amount] cm<sup>3</sup> (MAX: [max_g_amount])<HR>"

			for(var/obj/item/t in current_recipes)
				var/list/cost = get_cost(t)

				var/title = "[t.name] ([cost["metal"]] m /[cost["glass"]] g)"
				if (m_amount < cost["metal"] || g_amount < cost["glass"])
					dat += title + "<br>"
					continue
				dat += "<A href='?src=\ref[src];make=\ref[t]'>[title]</A>"
				if (istype(t, /obj/item/stack))
					var/obj/item/stack/S = t
					var/max_multiplier = min(S.max_amount, S.m_amt?round(m_amount/cost["metal"]):INFINITY, S.g_amt?round(g_amount/cost["glass"]):INFINITY)
					if (max_multiplier>1)
						dat += " |"
					if (max_multiplier>10)
						dat += " <A href='?src=\ref[src];make=\ref[t];multiplier=[10]'>x[10]</A>"
					if (max_multiplier>25)
						dat += " <A href='?src=\ref[src];make=\ref[t];multiplier=[25]'>x[25]</A>"
					if (max_multiplier>1)
						dat += " <A href='?src=\ref[src];make=\ref[t];multiplier=[max_multiplier]'>x[max_multiplier]</A>"
				dat += "<br>"
			user << browse("<HTML><HEAD><TITLE>Autolathe Control Panel</TITLE></HEAD><BODY><TT>[dat]</TT></BODY></HTML>", "window=autolathe_regular")
			onclose(user, "autolathe_regular")

		shock(mob/user, prb)
			if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
				return 0
			if(!prob(prb))
				return 0
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, src)
			s.start()
			if (electrocute_mob(user, get_area(src), src, 0.7))
				return 1
			else
				return 0

	interact(mob/user as mob)
		if(..())
			return
		if(src.shocked)
			src.shock(user,50)
		if(panel_open)
			user << browse("<HTML><HEAD><TITLE>Autolathe Wires</TITLE></HEAD><BODY><TT>[wires.GetInteractWindow()]</TT></BODY></HTML>", "window=autolathe_wires")
			return
		if(src.disabled)
			user << "\red You press the button, but nothing happens."
			return
		regular_win(user)
		return

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		if (stat)
			return 1
		if (busy)
			user << "\red The autolathe is busy. Please wait for completion of previous operation."
			return 1

		if(default_deconstruction_screwdriver(user, "autolathe_t", "autolathe", O))
			updateUsrDialog()
			return

		if(exchange_parts(user, O))
			return

		if (panel_open)
			if(istype(O, /obj/item/weapon/crowbar))
				if(m_amount >= 3750)
					var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal(src.loc)
					G.amount = round(m_amount / 3750)
				if(g_amount >= 3750)
					var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass(src.loc)
					G.amount = round(g_amount / 3750)
				default_deconstruction_crowbar(O)
				return 1
			else
				attack_hand(user)
				return 1

		if (src.m_amount + O.m_amt > max_m_amount)
			user << "\red The autolathe is full. Please remove metal from the autolathe in order to insert more."
			return 1
		if (src.g_amount + O.g_amt > max_g_amount)
			user << "\red The autolathe is full. Please remove glass from the autolathe in order to insert more."
			return 1
		if (O.m_amt == 0 && O.g_amt == 0)
			user << "\red This object does not contain significant amounts of metal or glass, or cannot be accepted by the autolathe due to size or hazardous materials."
			return 1

	/*	if (istype(O, /obj/item/weapon/grab) && src.hacked)
			var/obj/item/weapon/grab/G = O
			if (prob(25) && G.affecting)
				G.affecting.gib()
				m_amount += 50000
			return	*/

		var/amount = 1
		var/obj/item/stack/stack
		var/m_amt = O.m_amt
		var/g_amt = O.g_amt
		if (istype(O, /obj/item/stack))
			stack = O
			amount = stack.amount
			if (m_amt)
				amount = min(amount, round((max_m_amount-m_amount)/m_amt))
				flick("autolathe_o",src)//plays metal insertion animation
			if (g_amt)
				amount = min(amount, round((max_g_amount-g_amount)/g_amt))
				flick("autolathe_r",src)//plays glass insertion animation
			stack.use(amount)
		else
			usr.before_take_item(O)
			O.loc = src
		icon_state = "autolathe"
		busy = 1
		use_power(max(1000, (m_amt+g_amt)*amount/10))
		src.m_amount += m_amt * amount
		src.g_amount += g_amt * amount
		user << "You insert [amount] sheet[amount>1 ? "s" : ""] to the autolathe."
		if (O && O.loc == src)
			qdel(O)
		busy = 0
		src.updateUsrDialog()

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		user.set_machine(src)
		interact(user)


	Topic(href, href_list)
		if(..())
			return
		usr.set_machine(src)
		src.add_fingerprint(usr)
		if (!busy)
			if(href_list["make"])
				var/obj/template = locate(href_list["make"])
				var/multiplier = text2num(href_list["multiplier"])
				if (!multiplier) multiplier = 1

				if(check_can_build(template, multiplier))
					build(template, multiplier)
		else
			usr << "\red The autolathe is busy. Please wait for completion of previous operation."
		src.updateUsrDialog()
		return

	proc/check_can_build(var/obj/item/template, var/multiplier = 1)
		if(istype(template, /obj/item/stack))
			return (src.m_amount >= template.m_amt*multiplier && src.g_amount >= template.g_amt*multiplier)
		else
			return (src.m_amount >= template.m_amt/prod_coeff && src.g_amount >= template.g_amt/prod_coeff)


	proc/build(var/obj/item/template, var/multiplier = 1)
		var/power = max(2000, (template.m_amt+template.g_amt)*multiplier/5)
		busy = 1
		use_power(power)
		icon_state = "autolathe"
		flick("autolathe_n",src)
		spawn(16/prod_coeff)
			use_power(power)
			spawn(16/prod_coeff)
				var/obj/item/new_item = new template.type(get_turf(src))
				var/list/cost = get_cost(template, multiplier)
				ai_notice("[src.name] design [new_item.name]", src, "notice")
				if(istype(new_item, /obj/item/stack))
					if (multiplier>1)
						var/obj/item/stack/S = new_item
						S.amount = multiplier
				else
					new_item.m_amt = cost["metal"]
					new_item.g_amt = cost["glass"]
				m_amount -= cost["metal"]
				g_amount -= cost["glass"]
				busy = 0
				src.updateUsrDialog()

	proc/get_cost(var/obj/item/template, var/multiplier = 1)
		var/metal = template.m_amt
		var/glass = template.g_amt
		if(!istype(template, /obj/item/stack))
			metal /= prod_coeff
			glass /= prod_coeff
		else
			metal *= multiplier
			glass *= multiplier

		return list("metal" = round(metal), "glass" = round(glass))


/obj/machinery/autolathe/RefreshParts()
	..()
	var/tot_rating = 0
	prod_coeff = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		tot_rating += MB.rating
	tot_rating *= 25000
	max_m_amount = tot_rating * 2
	max_g_amount = tot_rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		prod_coeff += M.rating

/obj/machinery/autolathe/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/autolathe(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

	current_recipes = autolathe_recipes
	wires = new(src)


/obj/machinery/autolathe/proc/adjust_hacked(var/hack)
	hacked = hack

	if(hack)
		current_recipes = autolathe_recipes + autolathe_recipes_hidden
	else
		current_recipes = autolathe_recipes

	/*if(hack)
		for(var/datum/design/D in files.possible_designs)
			if((D.build_type & 4) && ("hacked" in D.category))
				files.known_designs += D
	else
		for(var/datum/design/D in files.known_designs)
			if("hacked" in D.category)
				files.known_designs -= D*/
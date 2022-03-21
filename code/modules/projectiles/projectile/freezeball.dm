obj/item/weapon/gun/energy/freezegun
	name = "Freezer gun"
	desc = "Special gun to freeze some badasses"
	icon = 'gun.dmi'
	icon_state = "freezegun"
	item_state = "freezegun"
	fire_sound = 'pulse3.ogg'
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	charge_cost = 500
	projectile_type = "/obj/item/projectile/freezeball"
	origin_tech = null
	var/charge_tick = 0

	New()
		..()
		processing_objects.Add(src)


	qdel()
		processing_objects.Remove(src)
		..()


	process()
		charge_tick++
		if(charge_tick < 4) return 0
		charge_tick = 0
		if(!power_supply) return 0
		power_supply.give(500)
		update_icon()
		return 1

/obj/item/projectile/freezeball
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"


	on_hit(var/atom/freezetg)
		icon = null
		freezemob(freezetg)

/obj/machinery/freezer/freezer_platform

/obj/structure/freezedmob
	name = "Pile of ice"
	icon = 'device.dmi'
	icon_state = "singlebath-bottom"
	desc = "Big pile of ice. Some aborigens at waterless planets can kill for ot"
	density = 1
	anchored = 0
	unacidable = 1//shouldnt I think
	var/health = 200
	var/ice = 150
	var/mob/living/occupant
	var/freeze_tick = 0
	var/datum/gas_mixture/incide_air
//	var/sighn_of_life = 0

	New()
		..()
		generate_air()
		processing_objects.Add(src)

	qdel()
		processing_objects.Remove(src)
		..()

	process() // soooo uglycode!
		if(!occupant)
			qdel(src)
		if(occupant.stat != 2)
			occupant:adjustOxyLoss(-4) // 4 critguys
			occupant.weakened= 2
			occupant.bodytemperature = 1
		if(ice<=200)
			freeze_tick++
			if(freeze_tick < 4) return 0
			freeze_tick = 0
			var/turf/location = src.loc //optimisation shit
			if (istype(location, /turf/space))
				ice += 25
				icecheck()
				return 1
			if (istype(location, /turf/unsimulated)) // possible centcomm or smth
				ice -= 9
				icecheck()
				return 1
			if (!istype(location, /turf/simulated))
				return 0
			var/datum/gas_mixture/environment = location.return_air()
			var/check = 0
			for(var/obj/machinery/freezer/freezer_platform/O in src.loc)
				if(O.on)
					check = 1
					if(ice <= 120)
						ice += min(120 - ice, 5)
					break
			if(!check)
				ice -= (environment.temperature-273)/2
			icecheck()

/obj/structure/freezedmob/return_air()
	return incide_air


/obj/structure/freezedmob/proc/generate_air()
	incide_air = new
	incide_air.temperature = 261
	incide_air.volume = 200
	incide_air.oxygen = O2STANDARD*incide_air.volume/(R_IDEAL_GAS_EQUATION*incide_air.temperature)
	incide_air.nitrogen = N2STANDARD*incide_air.volume/(R_IDEAL_GAS_EQUATION*incide_air.temperature)
	incide_air.update_values()
	return incide_air

/obj/structure/freezedmob/ex_act(severity)
	switch(severity)
		if (1)
			src.occupant.death()
			src.occupant.loc = src.loc
			src.occupant.freezed = 0
			src.occupant.gib()

			qdel(src)
		if (2)
			if (prob(50))
				src.health -= 15
				src.healthcheck()
		if (3)
			if (prob(50))
				src.health -= 5
				src.healthcheck()


/obj/structure/freezedmob/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.damage_type == BURN)
		ice -= Proj.damage
		..()
		src.icecheck()
	else
		health -= Proj.damage
		..()
		src.healthcheck()
	return


/obj/structure/freezedmob/blob_act()
	if (prob(75))
		src.occupant.death()
		src.occupant.loc = src.loc
		src.occupant.freezed = 0
		src.occupant.gib()

		qdel(src)


/obj/structure/freezedmob/meteorhit(obj/O as obj)
	src.occupant.death()
	src.occupant.loc = src.loc
	src.occupant.freezed = 0
	src.occupant.gib()
	qdel(src)


/obj/structure/freezedmob/proc/healthcheck()
	if (src.health <= 0)
		playsound(src, "shatter", 70, 1)
		src.occupant.death()
		src.occupant.loc = src.loc
		src.occupant.freezed = 0
		src.occupant.gib()
		qdel(src)
	else
		playsound(src.loc, 'Glasshit.ogg', 75, 1)
	return

/obj/structure/freezedmob/proc/icecheck()
	if (src.ice <= 0)
		playsound(src.loc, 'Welder2.ogg', 100, 1)
		var/mob/living/M = src.occupant
		src.occupant = null
		M.loc = src.loc
		M.canmove = 1
		M.weakened = 2
		M.freezed = 0
//		M.stat = src.sighn_of_life
		M.bodytemperature = 275
		if(M.stat != 2)
			if (!M.client)
				for(var/mob/dead/observer/ghost in world)
					if(ghost.mind.current == M && ghost.client)
						ghost.cancel_camera()
						ghost.reenter_corpse()
						break
		for(var/obj/item/I in src)
			I.loc = src.loc
		M.sdisabilities &= !DEAF
		src.occupant << "Thanks god, ice finally melted"
		qdel(src)
	else
		if(src.ice > 200)
			if(src.occupant.stat != 2)
				if(src.occupant.key)
					var/mob/dead/observer/ghost = new(src)
					ghost.key = src.occupant.key
					ghost.mind.current = src.occupant
					if(src.occupant.timeofdeath)
						ghost.timeofdeath = src.occupant.timeofdeath
					if (ghost.client)
						ghost.client.eye = ghost
				src.occupant.stat = 2
			src.ice = 200
	return

/obj/structure/freezedmob/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool) && W:welding)
		usr << text("\blue You melted some ice on [] with [].", src.name, W.name)
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] melted some ice on [] with []", usr, src.name, W.name)
		src.ice -= 20
		return
	src.health -= W.force
	src.healthcheck()
	..()
	return

/obj/structure/freezedmob/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/freezedmob/attack_hand(mob/user as mob)
	usr << text("\blue You kick the [].", src.name)
	for(var/mob/O in oviewers())
		if ((O.client && !( O.blinded )))
			O << text("\red [] kicks the []", usr, src.name)
	src.health -= 2
	healthcheck()
	return



proc/freezemob(mob/M as mob in world)
	M.canmove = 0
	M << "\red You fell how ice starts to cower your body"
	sleep(5)

	var /obj/structure/freezedmob/I = new /obj/structure/freezedmob( M.loc )
	M.freezed = 1
//	I.sighn_of_life = M.stat
	I.name = "Ice statue"
	I.desc = text("You can hardly recognize [] under the layer of ice", M.name)
	I.dir = M.dir
	if (M.lying)
		I.density = 0
	if (ishuman(M))
		var/mob/living/carbon/human/the_man = M
		the_man.silent = 1
		the_man.sdisabilities |= DEAF
		//var/icon/frozen_img = new/icon("icon" = 'empty', "icon_state" = "eyes_l", I.dir, 1)
		var/icon/frozen_img = new/icon(M.icon, M.icon_state, null, 1)
		for (var/image/block in the_man.get_overlays(M.lying))
			var/icon/temp = new/icon(block.icon)
			if(length(text("[]", block.icon)) < 4)
				frozen_img.Blend(icon(block.icon, block.icon_state, null, 1), ICON_OVERLAY)
			else
				for(var/a in temp.IconStates())
					if((a == block.icon_state)) //Time to laugh at me.
						//temp = icon(block.icon, block.icon_state, null, 1)
						frozen_img.Blend(icon(block.icon, block.icon_state, null, 1), ICON_OVERLAY)
						break
		frozen_img.Blend("#6495ED",ICON_MULTIPLY)
		frozen_img.SetIntensity(1.4)
		I.icon = frozen_img

	else
		var/icon/overlay
		overlay = new/icon(M.icon, M.icon_state, null, 1)
		overlay.Blend("#6495ED",ICON_MULTIPLY)
		overlay.SetIntensity(1.4)
		I.icon = overlay

/*	var/icon/mobpic = getFlatIcon(M, I.dir) //damn, not working. GOD WHY!?
	I.icon = mobpic*/
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = I
	M.loc = I
	M.weakened = 5 //dunno how make it true or falce, but mob shouldnt use hist equip while freezed
	I.occupant = M
	return 1

/mob/var/freezed = 0


/mob/living/carbon/human/proc/get_overlays(var/lying)
	var/list/wholebody
	if(!lying)
		wholebody += overlays_standing
	else
		wholebody += overlays_lying
	wholebody += overlays
	return wholebody

/obj/machinery/freezer/freezer_platform
	name = "Freezer platform"
	desc = "Freezing and unfreezing people."
	icon = 'freezer.dmi'
	icon_state = "freezer_pad"
	density = 0
	opacity = 0
	anchored = 1
	active_power_usage = 10
	idle_power_usage   = 2
	var/on = 0
	var/obj/machinery/computer/freezer/master = null
	New()
		..()
		use_power = 1
		//processing_objects.Add(src)

/obj/machinery/freezer/freezer_platform/proc/turn_power()
	if(stat & (BROKEN|NOPOWER))
		return 0
	if(!master)
		return 0
	if(src.use_power == 1)
		src.use_power = 2
		on = 1
	else if (src.use_power >= 2)
		src.use_power = 1
		on = 0
	return 0

/obj/machinery/freezer/freezer_platform/proc/Freezing()
	if(src.use_power < 2)
		return
	if(!master)
		return
	var/mob/living/M = null
	for(var/mob/living/O in src.loc)
		if(M != null)
			return 0
		else
			M = O
	if(!M)
		return 0
	if(M.lying || M.buckled)
		return 0
	freezemob(M)
	return 1

/obj/machinery/computer/freezer
	name = "Freezer Control Computer"
	desc = "Used to access the freezer pad."
	circuit = "/obj/item/weapon/circuitboard/atmos_alert"
	icon_state = "alert:0"
	var/obj/machinery/freezer/freezer_platform/slave = null


/obj/machinery/computer/freezer/initialize()
	..()
	sleep(10)
	slave = locate(/obj/machinery/freezer/freezer_platform,get_step(src, WEST))
	if(slave)
		slave.master = src

/obj/machinery/computer/freezer/attack_hand(mob/user)
	if(..(user))
		return
	user << browse(return_text(),"window=computer")
	user.set_machine(src)
	onclose(user, "computer")

/obj/machinery/computer/freezer/process()
	if(..())
		src.updateDialog()

/obj/machinery/computer/freezer/update_icon()
	..()
	if(stat & (NOPOWER|BROKEN) || !slave)
		return
	if(slave.on)
		icon_state = "alert:1"
	else
		icon_state = "alert:0"
	return


/obj/machinery/computer/freezer/proc/return_text()
	var/text
	if(!slave)
		text = "Has no slave."
		return text
	if(!slave.on)
		text = "<A href='?src=\ref[src];on=1'>Turn On</A><br>"
	else
		text = "<A href='?src=\ref[src];off=1'>Turn Off</A><br>"
		text += "<A href='?src=\ref[src];freezing=1'>Freezing</A><br>"
	return text

/obj/machinery/computer/freezer/Topic(href, href_list)
	if(href_list["off"])
		slave.turn_power()
	if(href_list["on"])
		slave.turn_power()
	if(href_list["freezing"])
		slave.Freezing()

/obj/machinery/computer/freezer/attack_ai(mob/user as mob)
		return

/obj/machinery/computer/freezer/attack_paw(mob/user as mob)
		return attack_hand(user)


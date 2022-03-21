var/list/area/dunwell_areas = list()

/obj/machinery/lifeweb/pillar
	name = "lifeweb machinery"
	icon = 'icons/obj/LW2Pillar.dmi'
	icon_state = "1"
	desc = ""
	density = 1
	anchored = 1

/obj/machinery/lifeweb/decor/New()
	icon_state = pick("1","2","3","4")
	..()

/obj/machinery/lifeweb/decor
	name = "lifeweb machinery"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "decor"
	desc = ""
	density = 1
	anchored = 1

/obj/machinery/lifeweb/ladder
	name = "lifeweb stairs"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "ladder"
	desc = ""
	density = 0
	anchored = 1

/obj/machinery/lifeweb/bath
	name = "lifeweb blood pool"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "lifeweb-bath"
	desc = ""
	density = 1
	anchored = 1

/obj/structure/stool/bed/chair/cross
	name = "cross"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "ecross"
	desc = ""
	density = 0
	anchored = 1

/obj/structure/stool/bed/chair/altar
	name = "lifeweb altar"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "altar"
	desc = ""
	density = 0
	anchored = 1

/obj/structure/stool/bed/chair/cross/manual_unbuckle(mob/user as mob)
	return

/mob/living/carbon/human/var/crosslocked

/obj/structure/stool/bed/chair/cross/buckle_mob(mob/living/carbon/human/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	for(var/obj/O in M.contents)
		if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/organ) || istype(O, /obj/item/weapon/storage/touchable/organ))
			continue
		else
			to_chat(user, "The victim needs to be fully naked.")
			return

	if (M.species.name == "Child")
		user << "It's a child, it doesn't fit!"
		return

	M.visible_message("<B>[M.name]</B> is locked on the [src] by [user]!")
	playsound(src.loc, pick('lw_sacrificed1.ogg','lw_sacrificed2.ogg','lw_sacrificed3.ogg','lw_sacrificed4.ogg'), 60, 0, -1)
	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	src.buckled_mob = M
	var/web_state = "web_m_s"
	var/icon/web_icon = new /icon('human.dmi', web_state)
	if(M.s_tone >= 0)
		web_icon.Blend(rgb(M.s_tone, M.s_tone, M.s_tone), ICON_ADD)
	else
		web_icon.Blend(rgb(-M.s_tone,  -M.s_tone,  -M.s_tone), ICON_SUBTRACT)
	M.icon = web_icon
	M.crosslocked = TRUE
	M.crossoverlay()
	src.add_fingerprint(user)

/obj/structure/stool/bed/chair/cross/unbuckle(mob/M as mob, mob/user as mob)
	return

/mob/living/carbon/human/proc/crossoverlay()
	var/icon/crossover = new/icon("icon" = 'icons/obj/LW2.dmi', "icon_state" = "ecross2")
	if(src.crosslocked)
		src.overlays += crossover
	else
		src.overlays -= crossover
// ALTAR DA LW
/obj/structure/stool/bed/chair/altar/manual_unbuckle(mob/user as mob)
	return

/obj/structure/stool/bed/chair/altar/buckle_mob(mob/living/carbon/human/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	if(M.contents != null && M.contents.len)
		user << "[M] needs to be fully naked!"
		return

	if (M.isChild())
		usr << "It's a child, it doesn't fit!"
		return

	if (M == usr)
		M << "I feel stupid."
		return
	else
		M.visible_message("<B>[M.name]</B> is locked on the [src]!")

	playsound(src.loc, pick('lw_sacrificed1.ogg','lw_sacrificed2.ogg','lw_sacrificed3.ogg','lw_sacrificed4.ogg'), 60, 0, -1)
	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	src.buckled_mob = M
	var/web_state = "web_m_s"
	var/icon/web_icon = new /icon('human.dmi', web_state)
	if(M.s_tone >= 0)
		web_icon.Blend(rgb(M.s_tone, M.s_tone, M.s_tone), ICON_ADD)
	else
		web_icon.Blend(rgb(-M.s_tone,  -M.s_tone,  -M.s_tone), ICON_SUBTRACT)
	M.icon = web_icon
	M.lifeweb_locked = TRUE
	M.lwoverlay()
	src.add_fingerprint(user)

/obj/structure/stool/bed/chair/altar/unbuckle(mob/M as mob, mob/user as mob)
	return

/obj/machinery/lifeweb/altarR
	name = "lifeweb altar"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "altarR"
	desc = ""
	density = 1
	anchored = 1

/obj/machinery/lifeweb/altarR/New()
	set_light(2, 2,"#eb0515")
	..()

/obj/machinery/lifeweb/altarL
	name = "lifeweb altar"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "altarL"
	desc = ""
	density = 1
	anchored = 1

/obj/machinery/lifeweb/altarL/New()
	set_light(2, 2,"#eb0515")
	..()

/obj/machinery/lifeweb/control
	name = "lifeweb control panel"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "lifeweb_control"
	desc = ""
	density = 1
	anchored = 1
	var/lwchoice
	var/draining

/mob/living/carbon/human/proc/lwoverlay()
	var/icon/overweb = new/icon("icon" = 'icons/obj/LW2.dmi', "icon_state" = "overweb")
	if(src.lifeweb_locked)
		src.overlays += overweb
	else
		src.overlays -= overweb
ecross2
/obj/machinery/lifeweb/control/attack_hand(mob/living/carbon/human/user as mob)
	playsound(src.loc, pick('lw_key.ogg','lw_key2.ogg'), 30, 0)
	src.lwchoice = input("LIFEWEB PANEL","LIFEWEB",src.lwchoice) in list("Release Victim","Toggle Draining","Check Status","Cancel")
	var/area/AffectedArea = get_area(src)
	switch(src.lwchoice)
		if("Release Victim")
			for(var/mob/living/carbon/human/H in AffectedArea)
				if(H.lifeweb_locked)
					playsound(H.loc, 'lw_free.ogg', 60, 0, -1)
					H.lifeweb_locked = FALSE
					H.lwoverlay()
					H.icon = H.stand_icon
					H.buckled = null
					H.anchored = initial(H.anchored)
					H.update_canmove()
					H = null
		if("Toggle Draining")
			for(var/mob/living/carbon/human/H in AffectedArea)
				if(H.lifeweb_locked)
					//var/blood_volume = round(H:vessel.get_reagent_amount("blood"))
					if(draining)
						draining = FALSE
						playsound(src.loc, 'lwButton.ogg', 60, 0, -1)
					else
						draining = TRUE
						playsound(src.loc, 'lwButton.ogg', 60, 0, -1)
		if("Check Status")
			for(var/mob/living/carbon/human/H in AffectedArea)
				if(H.lifeweb_locked)
					var/blood_volume = round(H:vessel.get_reagent_amount("blood"))
					var/blood_percent =  blood_volume / 560
					blood_percent *= 100
					if(blood_volume <= 500)
						user.show_message("\red <b>Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl")
					else if(blood_volume <= 336)
						user.show_message("\red <b>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl")
					else
						user.show_message("\blue Blood Level Normal: [blood_percent]% [blood_volume]cl")
		if("Cancel")
			return

/obj/machinery/lifeweb/control/New()
	..()
	var/icon/overweb = new/icon("icon" = 'icons/obj/LW2.dmi', "icon_state" = "lifeweb_control_o")
	overlays += overweb
	set_light(1, 1,"#ff3c00")
	for(var/area/A in world)
		if(istype(A, /area/dunwell))
			dunwell_areas += A

//BATTERY CHARGER
//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

obj/machinery/web_recharger
	name = "battery charger"
	icon = 'LW2.dmi'
	icon_state = "battery_station"
	anchored = 1
	use_power = 1
	density = 1
	var/active_area
	var/blood_usage = 0
	var/obj/item/weapon/charging = null
	var/powered = TRUE

obj/machinery/web_recharger/examine()
	set src in view(1)
	if(usr /*&& !usr.stat*/)
		if(charging)
			var/obj/item/weapon/cell/web/C = charging
			usr << "[desc]\n The charge meter reads [round(C.percent() )]%."

obj/machinery/web_recharger/attackby(obj/item/weapon/G as obj, mob/user as mob)
	if(istype(G, /obj/item/weapon/cell/web))
		if(charging)
			return

		// Checks to make sure he's not in space doing it, and that the area got proper power.
		user.drop_item()
		G.loc = src
		charging = G
		blood_usage = 5
		update_icon()
		src.icon_state = "battery_station_overlay"
		src.underlays += G

obj/machinery/web_recharger/attack_hand(mob/user as mob)
	add_fingerprint(user)
	var/obj/item/weapon/cell/web/C = charging

	if(charging)
		charging.update_icon()
		charging.loc = loc
		C.updateicon()
		charging = null
		blood_usage = 5
		update_icon()
		src.icon_state = "battery_station"
		src.underlays -= C
		src.underlays = null

obj/machinery/web_recharger/attack_paw(mob/user)
	return attack_hand(user)

obj/machinery/web_recharger/attack_tk(mob/user)
	var/obj/item/weapon/cell/web/C = charging

	if(charging)
		charging.update_icon()
		charging.loc = loc
		charging = null
		use_power = 1
		src.icon_state = "battery_station"
		src.underlays -= C
		src.underlays = null
		update_icon()

var/global/list/lifeweb_objects = list()

/obj/machinery/lifeweb/New()
	processing_objects.Add(src)
	lifeweb_objects.Add(src)

/obj/item/weapon/cell/web/proc/update_price()
	var/item_total
	item_total = item_worth + charge
	item_worth = item_total

/obj/machinery/web_recharger/proc/area_powercheck()
	for(var/area/dunwell/station/A in dunwell_areas)
		if(charging)
			var/obj/item/weapon/cell/web/C = charging
			if(C.charge <= 0)
				powered = FALSE
				if(!powered)
					for(var/obj/machinery/light/L in A)
						L.on = FALSE
						L.update()

			else if(C.charge >= 1)
				powered = TRUE
				if(powered)
					for(var/obj/machinery/light/L in A)
						L.on = TRUE
						L.update()
		else
			powered = FALSE
			for(var/obj/machinery/light/L in A)
				L.on = FALSE
				L.update()

obj/machinery/web_recharger/process()
	var/area/AffectedArea = get_area(src)
	for(var/obj/machinery/lifeweb/control/CONTROL in lifeweb_objects)
		if(charging && CONTROL.draining)
			if(istype(charging, /obj/item/weapon/cell/web))
				var/obj/item/weapon/cell/web/C = charging
				if(C.charge < C.maxcharge)
					for(var/mob/living/carbon/human/H in AffectedArea)
						if(H.lifeweb_locked)
							H.vessel.remove_reagent("blood",blood_usage)
							icon_state = "ob50"
							blood_usage = 7
							use_power(C.give(10))
							C.update_price()
				else
					icon_state = "ob100"
		else if(charging && !CONTROL.draining)
			if(istype(charging, /obj/item/weapon/cell/web))
				var/obj/item/weapon/cell/web/C = charging
				if(C.charge >= 1)
					use_power(C.give(-0.5))
					C.update_price()
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////CASO TENHA MUITO LAG, DESATIVE, APENAS EM URGÊNCIAS, COMENTE O CODE/////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
	/*for(var/area/dunwell/station/A in dunwell_areas)
		if(A.name == active_area)
			area_powercheck()*/
/////////////////////////////////////////////////////////////////////////////////////////////
//////////APENAS O PEDAÇO DE CODE ACIMA DEVE SER COMENTADO, O RESTO FUNCIONA SEM LAG/////////
/////////////////////////////////////////////////////////////////////////////////////////////
/obj/item/device/flashlight
	name = "flashlight"
	desc = "An expensive light source. Handheld and reliable."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flight0"
	w_class = 2
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	m_amt = 50
	g_amt = 20
	//icon_action_button = "action_flashlight"
	var/on = 0
	var/brightness_on = 3 //luminosity when on
	var/brightness_red = 3
	var/brightness_green = 3
	var/brightness_blue = 2
	dir = WEST
	var/obj/effect/effect/light/light_spot = null

	var/radiance_power = 2
	var/light_spot_power = 2
	var/light_spot_radius = 3

	var/light_spot_range = 3
	var/spot_locked = FALSE		//this flag needed for lightspot to stay in place when player clicked on turf, will reset when moved or turned

	var/light_direction

	New()
		..()
		init_obj.Add(src)

/obj/item/device/flashlight/attackby(var/obj/B, var/mob/user)
	if (istype(B, /obj/item/weapon/storage/toolbox))
		user << "<b>[src]</b> says, \"Are you silly? You can't insert this massive toolbox into flashlight.\""
		return

/obj/item/device/flashlight/initialize()
	..()
	if (on)
		icon_state = "[initial(icon_state)]-on"
		set_light(3, 3,"#f4fad4")
	else
		icon_state = initial(icon_state)
		set_light(0)

/mob/living/carbon/human/proc/update_flashlight(){
	if(istype(r_hand, /obj/item/device/flashlight)){
		var/obj/item/device/flashlight/F = r_hand

		F.update_brightness(src)
		if(F.on){
			F.calculate_dir()
		}
	}
	if(istype(l_hand, /obj/item/device/flashlight)){
		var/obj/item/device/flashlight/F = l_hand

		F.update_brightness(src)
		if(F.on){
			F.calculate_dir()
		}
	}
}

/obj/item/device/flashlight/proc/update_brightness(var/mob/user)
	if (on)
		icon_state = "[initial(icon_state)]-on"
		item_state = "flight1"
		set_light(3, 3,"#f4fad4")
		set_light(2,radiance_power)
		if(light_spot){
			var/turf/T = get_turf(src)
			if(light_spot.x == T.x && light_spot.y == T.y && light_spot.z == T.z){
				return
			}
		}
		qdel(light_spot)
		light_spot = new(get_turf(src),light_spot_radius, light_spot_power)
		light_spot.icon = 'icons/effects/64x64.dmi'
		light_spot.pixel_x = -16
		light_spot.pixel_y = -16
		light_spot.alpha = 120
		light_spot.layer = ABOVE_OBJ_LAYER
		processing_objects.Add(src)
		calculate_dir()
	else
		icon_state = initial(icon_state)
		item_state = "flight0"
		set_light(0)
		qdel(light_spot)
		processing_objects.Remove(src)

/obj/item/device/flashlight/on_enter_storage()
	if(on)
		icon_state = initial(icon_state)
		set_light(0)
		on = 0
		qdel(light_spot)
	..()
	return

/obj/item/device/flashlight/equipped()
	if(on)
		icon_state = initial(icon_state)
		set_light(0)
		on = 0
		qdel(light_spot)
	..()
	return

/obj/item/device/flashlight/attack_self(mob/user)
	if(!isturf(user.loc))
		user << "You cannot turn the light on while in this [user.loc]." //To prevent some lighting anomalities.
		return 0
	on = !on
	playsound(user.loc, 'sound/webbers/legacy_toggle_light.ogg', 50, 1)
	user.update_inv_r_hand()
	user.update_inv_l_hand()
	update_brightness(user)
	return 1

/obj/item/device/flashlight/afterattack(atom/A, mob/user)
	var/turf/T = get_turf(A)
	if(can_see(user,T) && light_spot_range >= get_dist(get_turf(src),T))
		if (!lightSpotPassable(T))
			T = get_step_towards(T,get_turf(src))
			if(!lightSpotPassable(T))
				return
		spot_locked = TRUE
		light_direction = get_dir(src,T)
		place_lightspot(T,Get_Angle(get_turf(src),T))

/obj/item/device/flashlight/attack(mob/living/M as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.zone_sel.selecting == "eyes")

		if(((CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		if(!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")	//don't have dexterity
			user << "<span class='notice'>You don't have the dexterity to do this!</span>"
			return

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			user << "<span class='notice'>You're going to need to remove that [(H.head && H.head.flags & HEADCOVERSEYES) ? "helmet" : (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) ? "mask": "glasses"] first.</span>"
			return

		if(M == user)	//they're using it on themselves
			if(!M.blinded)
				flick("flash", M.flash)
				M.visible_message("<span class='notice'>[M] directs [src] to \his eyes.</span>", \
									 "<span class='notice'>You wave the light in front of your eyes! Trippy!</span>")
			else
				M.visible_message("<span class='notice'>[M] directs [src] to \his eyes.</span>", \
									 "<span class='notice'>You wave the light in front of your eyes.</span>")
			return

		user.visible_message("<span class='notice'>[user] directs [src] to [M]'s eyes.</span>", \
							 "<span class='notice'>You direct [src] to [M]'s eyes.</span>")

		if(istype(M, /mob/living/carbon/human) || istype(M, /mob/living/carbon/monkey))	//robots and aliens are unaffected
			if(M.stat == DEAD || M.sdisabilities & BLIND)	//mob is dead or fully blind
				user << "<span class='notice'>[M] pupils does not react to the light!</span>"
			else if(XRAY in M.mutations)	//mob has X-RAY vision
				flick("flash", M.flash) //Yes, you can still get flashed wit X-Ray.
				user << "<span class='notice'>[M] pupils give an eerie glow!</span>"
			else	//they're okay!
				if(!M.blinded)
					flick("flash", M.flash)	//flash the affected mob
					user << "<span class='notice'>[M]'s pupils narrow.</span>"
	else
		return ..()


/obj/item/device/flashlight/pickup(mob/user)
	if(on)
		set_light(3, 3,"#f4fad4")
		calculate_dir()
		dir = WEST


/obj/item/device/flashlight/dropped(mob/user)
	if(on)
		set_light(3, 3,"#f4fad4")
	if(light_direction)
		set_dir(light_direction)

/obj/item/device/flashlight/Destroy()
	..()
	qdel(light_spot)


/obj/item/device/flashlight/proc/calculate_dir(var/turf/old_loc)
	if (istype(src.loc,/obj/item/weapon/storage) || istype(src.loc,/obj/structure/closet))
		return
	if (istype(src.loc,/mob/living))
		var/mob/living/L = src.loc
		set_dir(L.dir)
	else if (pulledby && old_loc)
		var/x_diff = src.x - old_loc.x
		var/y_diff = src.y - old_loc.y
		if (x_diff > 0)
			set_dir(EAST)
		else if (x_diff < 0)
			set_dir(WEST)
		else if (y_diff > 0)
			set_dir(NORTH)
		else if (y_diff < 0)
			set_dir(SOUTH)

/obj/item/device/flashlight/set_dir(new_dir)
	var/turf/NT = get_turf(src)	//supposed location for lightspot
	var/turf/L = get_turf(src)	//current location of flashlight in world
	var/hitSomething = FALSE
	light_direction = new_dir

	if (istype(src.loc,/obj/item/weapon/storage) || istype(src.loc,/obj/structure/closet))	//no point in finding spot for light if flashlight is inside container
		place_lightspot(NT)
		return

	switch(light_direction)
		if(NORTH)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x,L.y + i,L.z)
				if (lightSpotPassable(T))
					if(istype(T, /turf/space))
						break
					NT = T
				else
					hitSomething = TRUE
					break
		if(SOUTH)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x,L.y - i,L.z)
				if (lightSpotPassable(T))
					if(istype(T, /turf/space))
						break
					NT = T
				else
					hitSomething = TRUE
					break
		if(EAST)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x + i,L.y,L.z)
				if (lightSpotPassable(T))
					if(istype(T, /turf/space))
						break
					NT = T
				else
					hitSomething = TRUE
					break
		if(WEST)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x - i,L.y,L.z)
				if (lightSpotPassable(T))
					if(istype(T, /turf/space))
						break
					NT = T
				else
					hitSomething = TRUE
					break

	place_lightspot(NT, hitObstacle = hitSomething)

	if (!istype(src.loc,/mob/living))
		dir = new_dir

/obj/item/device/flashlight/proc/place_lightspot(var/turf/T, var/angle = null, var/hitObstacle = FALSE)
	if (light_spot && on && !istype(T, /turf/space))
		light_spot.forceMove(T)
		light_spot.icon_state = "nothing"
		light_spot.transform = initial(light_spot.transform)
		if (lightSpotPlaceable(T) && !hitObstacle)
			var/distance = get_dist(get_turf(src),T)
			switch(distance)
				if (1)
					light_spot.icon_state = "lightspot_vclose"
				if (2)
					light_spot.icon_state = "lightspot_close"
				if (3)
					light_spot.icon_state = "lightspot_medium"
				if (4)
					light_spot.icon_state = "lightspot_far"

		if(angle)
			light_spot.transform = turn(light_spot.transform, angle)
		else
			switch(light_direction)	//icon pointing north by default
				if(SOUTH)
					light_spot.transform = turn(light_spot.transform, 180)
				if(EAST)
					light_spot.transform = turn(light_spot.transform, 90)
				if(WEST)
					light_spot.transform = turn(light_spot.transform, -90)

/obj/item/device/flashlight/proc/lightSpotPassable(var/turf/T)
	if (is_opaque(T))
		return FALSE
	return TRUE

/obj/item/device/flashlight/proc/lightSpotPlaceable(var/turf/T)	//check if we can place icon there, light will be still applied
	for(var/obj/O in T)
		if(istype(O, /obj/structure/window))
			return FALSE
	return TRUE

/obj/item/device/flashlight/moved(mob/user, old_loc)
	spot_locked = FALSE
	calculate_dir(old_loc)

/obj/item/device/flashlight/entered_with_container()
	spot_locked = FALSE
	calculate_dir()

/obj/item/device/flashlight/container_dir_changed(new_dir)
	spot_locked = FALSE
	set_dir(new_dir)

/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = ""
	flags = FPRINT | TABLEPASS | CONDUCT
	brightness_red = 2
	brightness_green = 2
	brightness_blue = 2

/obj/item/device/flashlight/seclite
	name = "seclite"
	desc = "A robust flashlight used by security."
	icon_state = "seclite"
	item_state = "seclite"
	force = 10 // Not as good as a stun baton.
	attack_verb = list("beaten")
	hitsound = 'sound/weapons/genhit1.ogg'
	brightness_on = 5 // A little better than the standard flashlight.

// the desk lamps are a bit special
/obj/item/device/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	w_class = 4
	flags = FPRINT | TABLEPASS | CONDUCT
	m_amt = 0
	g_amt = 0
	on = 1


// green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"

	brightness_red = 2
	brightness_green = 5
	brightness_blue = 2



/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

// FLARES

/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red Nanotrasen issued flare. There are instructions on the side, it reads 'pull cord, make light'."
	w_class = 2.0
//	brightness_on = 7 // Pretty bright.
	icon_state = "flare"
	item_state = "flare"
	icon_action_button = null	//just pull it manually, neckbeard.
	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500

	brightness_red = 5
	brightness_green = 1
	brightness_blue = 1


/obj/item/device/flashlight/flare/New()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.
	..()

/obj/item/device/flashlight/flare/process()
	var/turf/pos = get_turf(src)
	if(pos)
		pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		processing_objects -= src

/obj/item/device/flashlight/flare/proc/turn_off()
	on = 0
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	if(ismob(loc))
		var/mob/U = loc
		update_brightness(U)
	else
		update_brightness(null)

/obj/item/device/flashlight/flare/attack(mob/living/M as mob, mob/living/user as mob)
	if(!isliving(M))
		return
	M.IgniteMob()
	..()


/obj/item/device/flashlight/flare/attack_self(mob/user)

	// Usual checks
	if(!fuel)
		user << "<span class='notice'>It's out of fuel.</span>"
		return
	if(on)
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message("<span class='notice'>[user] activates the flare.</span>", "<span class='notice'>You pull the cord on the flare, activating it!</span>")
		src.force = on_damage
		src.damtype = "fire"
		processing_objects += src


/obj/item/device/flashlight/seclite
	name = "seclite"
	desc = "A robust flashlight used by security."
	icon_state = "seclite"
	item_state = "seclite"
	force = 8 // Not as good as a stun baton.
	attack_verb = list("beaten")
	hitsound = 'sound/weapons/genhit1.ogg'
	// A little better than the standard flashlight.

	brightness_red = 4
	brightness_green = 4
	brightness_blue = 4
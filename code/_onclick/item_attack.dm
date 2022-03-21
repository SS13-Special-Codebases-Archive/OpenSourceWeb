
// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	return

// No comment
/atom/proc/attackby(obj/item/W, mob/user)
	return
/atom/movable/attackby(obj/item/W, mob/user)
	if(!(W.flags&NOBLUDGEON))
		visible_message("<span class='danger'>[src] has been hit by [user] with [W].</span>")

/mob/living/attackby(obj/item/I, mob/user)
	if(istype(I) && ismob(user))
		I.attack(src, user)

/obj/structure/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	..()

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return


/obj/item/proc/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	var/wait = 3
	if (!istype(M)) // not sure if this is the right thing...
		return
	if (depotenzia(M, user))
		return

	if (can_operate(M))        //Checks if mob is lying down on table for surgery
		if (do_surgery(M,user,src))
			return

	if(world.time <= next_attack_time)
		if(world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>The [src] is not ready to attack again!</span>")
		return 0

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
	log_attack("<font color='red'>[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>" )

	//spawn(1800)            // this wont work right
	//	M.lastattacker = null
	/////////////////////////

	var/power = force
	if(HULK in user.mutations)
		power *= 2

	wait += w_class
	if(force)
		user.adjustStaminaLoss(wait)

	next_attack_time = world.time + (weapon_speed_delay)

	if(istype(M, /mob/living/carbon/human))
		return M:attacked_by(src, user, def_zone)
	else
		switch(damtype)
			if("brute")

				M.take_organ_damage(power)
				if (prob(33)) // Added blood for whacking non-humans too
					var/turf/location = M.loc
					if (istype(location, /turf/simulated))
						location:add_blood_floor(M)
			if("fire")
				if (!(COLD_RESISTANCE in M.mutations))
					M.take_organ_damage(0, power)
					M << "Aargh it burns!"
		M.updatehealth()

	if (force && hitsound)//We want to make sure the hit actually goes through before we play any sounds.
		playsound(M, hitsound, 50, 1, -1)

	add_fingerprint(user)
	return 1


/atom/proc/storage_depth(atom/container) // Hi
	var/depth = 0
	var/atom/cur_atom = src

	while (cur_atom && !(cur_atom in container.contents))
		if (isarea(cur_atom))
			return -1
		if (istype(cur_atom.loc, /obj/item/weapon/storage))
			if(!istype(cur_atom.loc, /obj/item/weapon/storage/touchable))
				depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return -1	//inside something with a null loc.
	return depth

//Like storage depth, but returns the depth to the nearest turf
//Returns -1 if no top level turf (a loc was null somewhere, or a non-turf atom's loc was an area somehow).
/atom/proc/storage_depth_turf()
	var/depth = 0
	var/atom/cur_atom = src

	while (cur_atom && !isturf(cur_atom))
		if (isarea(cur_atom))
			return -1
		if (istype(cur_atom.loc, /obj/item/weapon/storage))
			if(!istype(cur_atom.loc, /obj/item/weapon/storage/touchable))
				depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return -1	//inside something with a null loc.
	return depth
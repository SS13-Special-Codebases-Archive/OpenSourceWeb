/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return 1
		if(ishuman(mover))
			if(istype(mover,/mob/living/carbon/alien))
				return 1
		return (!mover.density || !density || lying)
	else
		return (!mover.density || !density || lying)
	return

/client/proc/client_dir(input, direction=-1)
	return turn(input, direction*dir2angle(dir))

/client/Northeast()
	var/turf/controllerlocation = locate(1, 1, usr.z)
	if (istype(mob, /mob/dead/observer))
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if (controller.up)
				var/turf/T = locate(usr.x, usr.y, controller.up_target)
				mob.Move(T)
	else if (istype(mob, /mob/living/silicon/ai))
		AIMoveZ(UP, mob)
	else if(isobj(mob.loc))
		mob.loc:relaymove(mob,UP)
	else if(istype(mob, /mob/living/carbon))
		mob:swim_up()
	return


/client/Southeast()
	var/turf/controllerlocation = locate(1, 1, usr.z)
	if (istype(mob, /mob/dead/observer))
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if (controller.down)
				var/turf/T = locate(usr.x, usr.y, controller.down_target)
				mob.Move(T)
	else if (istype(mob, /mob/living/silicon/ai))
		AIMoveZ(DOWN, mob)
	else if(isobj(mob.loc))
		mob.loc:relaymove(mob,DOWN)
	else if(istype(mob, /mob/living/carbon))
		mob:swim_down()
	return


/client/Southwest()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.toggle_throw_mode()
	else
		usr << "\red This mob type cannot throw items."
	return


/client/Northwest()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(!C.get_active_hand())
			usr << "\red You have nothing to drop in your hand."
			return
		drop_item()
	else
		usr << "\red This mob type cannot drop items."
	return

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		usr << "\blue You are not pulling anything."
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set hidden = 1
	if(istype(mob, /mob/living/carbon))
		mob:swap_hand()
	if(istype(mob,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	return

/client/verb/swap_hand_hotkey()//For the hotkeys.
	set name = ".swap_hand"
	swap_hand()

/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return


/client/verb/toggle_throw_mode()
	set hidden = 1
	if(!istype(mob, /mob/living/carbon))
		return
	if (!mob.stat && isturf(mob.loc) && !mob.restrained())
		mob:toggle_throw_mode()
	else
		return


/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob))
		mob.drop_item_v()
	return


/client/Center()
	/* No 3D movement in 2D spessman game. dir 16 is Z Up
	if (isobj(mob.loc))
		var/obj/O = mob.loc
		if (mob.canmove)
			return O.relaymove(mob, 16)
	*/
	return


/atom/movable/Move(NewLoc, direct)
	if (direct & (direct - 1))
		if (direct & 1)
			if (direct & 4)
				if (step(src, NORTH))
					step(src, EAST)
				else
					if (step(src, EAST))
						step(src, NORTH)
			else
				if (direct & 8)
					if (step(src, NORTH))
						step(src, WEST)
					else
						if (step(src, WEST))
							step(src, NORTH)
		else
			if (direct & 2)
				if (direct & 4)
					if (step(src, SOUTH))
						step(src, EAST)
					else
						if (step(src, EAST))
							step(src, SOUTH)
				else
					if (direct & 8)
						if (step(src, SOUTH))
							step(src, WEST)
						else
							if (step(src, WEST))
								step(src, SOUTH)
	else
		var/atom/A = src.loc

		var/olddir = dir //we can't override this without sacrificing the rest of movable/New()
		update_client_hook(loc)
		. = ..()
		if(direct != olddir)
			dir = olddir
			set_dir(direct)

		src.move_speed = world.time - src.l_move_time
		src.l_move_time = world.time
		src.m_flag = 1
		if ((A != src.loc && A && A.z == src.z))
			src.last_move = get_dir(A, src.loc)

/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.dir = direct
		else
			mob.control_object.loc = get_step(mob.control_object,direct)
	return

/mob/var/next_movement = 0

/client/Move(n, direct)
	if(mob.stat == DEAD && !istype(mob, /mob/dead))
		return
	if (mob.next_movement - world.time >= world.tick_lag / 10)
		return max(world.tick_lag, (mob.next_movement - world.time) - world.tick_lag / 10)
	if(Process_Grab() == 1)
		return
	if(!mob.canmove && !istype(mob, /mob/dead))
		return
	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)
	if(isobj(mob.loc) || ismob(mob.loc))
		var/atom/O = mob.loc
		return O.relaymove(mob, direct)

	if(mob.restrained() && mob.pulledby && ishuman(mob.pulledby))
		var/mob/living/carbon/human/humano = mob.pulledby
		if(!humano.restrained() && humano.stat == 0 && humano.canmove && mob.Adjacent(humano))
			return to_chat(src, "I'm restrained, i cannot move!")
		else
			humano.stop_pulling()

	var/delay = max(mob.movement_delay(mob.dir, direct), world.tick_lag) // don't divide by zero
	if(isturf(mob.loc))
		var/glide = (world.icon_size / ceil(delay / world.tick_lag)) //* (world.tick_lag / CLIENTSIDE_TICK_LAG_SMOOTH))
		mob.glide_size = glide // dumb hack: some Move() code needs glide_size to be set early in order to adjust "following" objects
		mob.animate_movement = SLIDE_STEPS
		if(mob.druggy || mob.lying)
			glide = 4
		moving = 1

		if(locate(/obj/item/weapon/grab, mob))
			mob.next_movement = max(mob.next_movement, world.time + 3)
			var/list/L = mob.ret_grab()
			if(istype(L, /list))
				if(L.len == 2)
					L -= mob
					var/mob/M = L[1]
					if(M)
						if ((get_dist(mob, M) <= 1 || M.loc == mob.loc))
							var/turf/T = mob.loc
							step(mob, direct)
							if (isturf(M.loc))
								var/diag = get_dir(mob, M)
								if ((diag - 1) & diag)
								else
									diag = null
								if ((get_dist(mob, M) > 1 || diag))
									step(M, get_dir(M.loc, T))
				else
					for(var/mob/M in L)
						M.other_mobs = 1
						if(mob != M)
							M.animate_movement = 3
					for(var/mob/M in L)
						spawn( 0 )
							step(M, direct)
							return
						spawn( 1 )
							M.other_mobs = null
							M.animate_movement = 2
							return


		else if(mob.confused)
			step(mob, pick(cardinal))
		else
			step(mob, direct)
			mob.glide_size = glide // but Move will auto-set glide_size, so we need to override it again
		moving = 0

		if(mob.pulling && ishuman(mob))
			var/mob/living/carbon/human/H = mob
			if(isobj(mob.pulling))
				var/obj/O = mob.pulling
				if(O.heavy && !H.check_perk(/datum/perk/docker))
					H.adjustStaminaLoss(15-H.my_stats.st, 25-H.my_stats.st)
			mob.dir = turn(mob.dir, 180)
			mob.update_vision_cone()

		mob.next_movement = world.time + delay

/client/proc/Process_Grab()
	if(isliving(mob))
		var/mob/living/L = mob
		if(L.grabbed_by.len)
			for(var/obj/item/weapon/grab/G in L.grabbed_by)
				if(G.affecting != G.assailant)
					to_chat(mob, "You can't move!")
					return 1
	return 0

///Process_Incorpmove
///Called by client/Move()
///Allows mobs to run though walls
/client/proc/Process_Incorpmove(direct)
	var/turf/mobloc = get_turf(mob)
	if(!isliving(mob))
		return
	var/mob/living/L = mob
	switch(L.incorporeal_move)
		if(1)
			L.loc = get_step(L, direct)
			L.dir = direct
		if(2)
			if(prob(50))
				var/locx
				var/locy
				switch(direct)
					if(NORTH)
						locx = mobloc.x
						locy = (mobloc.y+2)
						if(locy>world.maxy)
							return
					if(SOUTH)
						locx = mobloc.x
						locy = (mobloc.y-2)
						if(locy<1)
							return
					if(EAST)
						locy = mobloc.y
						locx = (mobloc.x+2)
						if(locx>world.maxx)
							return
					if(WEST)
						locy = mobloc.y
						locx = (mobloc.x-2)
						if(locx<1)
							return
					else
						return
				L.loc = locate(locx,locy,mobloc.z)
				spawn(0)
					var/limit = 2//For only two trailing shadows.
					for(var/turf/T in getline(mobloc, L.loc))
						spawn(0)
							anim(T,L,'icons/mob/mob.dmi',,"shadow",,L.dir)
						limit--
						if(limit<=0)	break
			else
				spawn(0)
					anim(mobloc,mob,'icons/mob/mob.dmi',,"shadow",,L.dir)
				L.loc = get_step(L, direct)
			L.dir = direct
	return 1

///Process_Spacemove
///Called by /client/Move()
///For moving in space
///Return 1 for movement 0 for none
/mob/Process_Spacemove(var/movement_dir = 0)

	if(..())
		return 1

	var/atom/movable/dense_object_backup
	for(var/atom/A in orange(1, get_turf(src)))
		if(isarea(A))
			continue

		else if(isturf(A))
			var/turf/turf = A
			if(istype(turf,/turf/space))
				continue

			if(!turf.density && !mob_negates_gravity())
				continue

			return 1

		else
			var/atom/movable/AM = A
			if(AM == buckled) //Kind of unnecessary but let's just be sure
				continue
			if(AM.density)
				if(AM.anchored)
					if(istype(AM, /obj/item/projectile)) //"You grab the bullet and push off of it!" No
						continue
					return 1
				if(pulling == AM)
					continue
				dense_object_backup = AM

	if(movement_dir && dense_object_backup)
		if(dense_object_backup.newtonian_move(turn(movement_dir, 180))) //You're pushing off something movable, so it moves
			src << "<span class='info'>You push off of [dense_object_backup] to propel yourself.</span>"


		return 1
	return 0

/mob/proc/Process_Spaceslipping(var/prob_slip = 5)
	//Setup slipage
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.
	if(stat)
		prob_slip = 0  // Changing this to zero to make it line up with the comment.

	prob_slip = round(prob_slip)
	return(prob_slip)

/mob/proc/slip(var/s_amount, var/w_amount, var/obj/O, var/lube)
	return

/mob/proc/stumble(var/slip, var/slipped, var/custommessage)
	if(ismonster(src))	return
	if(buckled)	return
	if(resting)	return
	if(isliving(src) && src.m_intent == "run")
		if(custommessage)
			to_chat(src, "<span class='passive'>[custommessage]</span>")
		else
			if(slip)
				to_chat(src, "<span class='passive'>You slip on \the [slipped]</span>")
				src.confused += 3
				playsound(src.loc, 'sound/misc/slip.ogg', 50, 1)
			else
				to_chat(src, "<span class='passive'>You stumbled on \the [slipped]</span>")
		spawn(rand(3,5))
			src.resting = TRUE
			playsound(src.loc, pick('sound/effects/bodyfall1.ogg', 'sound/effects/bodyfall2.ogg'), 50, 1)
		return
	else
		return

/mob/proc/mob_has_gravity(turf/T)
	return has_gravity(src, T)

/mob/proc/mob_negates_gravity()
	return 0

/mob/proc/update_gravity()
	return

#define DO_MOVE(this_dir) var/final_dir = turn(this_dir, -dir2angle(dir)); Move(get_step(mob, final_dir), final_dir);

/client/verb/moveup()
	set name = ".moveup"
	set instant = 1
	DO_MOVE(NORTH)

/client/verb/movedown()
	set name = ".movedown"
	set instant = 1
	DO_MOVE(SOUTH)

/client/verb/moveright()
	set name = ".moveright"
	set instant = 1
	DO_MOVE(EAST)

/client/verb/moveleft()
	set name = ".moveleft"
	set instant = 1
	DO_MOVE(WEST)

#undef DO_MOVE
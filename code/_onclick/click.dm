/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
/mob/var/next_click	= 0

/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/

/atom/Click(location,control,params)
	usr.ClickOn(src, params)
/atom/DblClick(location,control,params)
	usr.DblClickOn(src,params)

/*
	Standard mob ClickOn()
	Handles exceptions: Buildmode, middle click, modified clicks, mech actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is recieving it.
	The most common are:
	* mob/UnarmedAttack(atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/attackby(item,user) - used only when adjacent
	* item/afterattack(atom,user,adjacent,params) - used both ranged and adjacent
	* mob/RangedAttack(atom,params) - used only ranged, only used for tk and laser eyes but could be changed
*/
/mob/proc/ClickOn( var/atom/A, var/params )
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["ctrl"] && modifiers["right"])
		CtrlRightClickOn(A)
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return
	if(modifiers["alt"] && modifiers["right"])
		AltRightClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["right"])
		RightClickOn(A)
		return

	if(lying && istype(A, /turf/) && !istype(A, /turf/space/))
		scramble(A)
		setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(stat || paralysis || stunned || weakened)
		return

	var/face = 0
	if(grabbed_by.len)
		for(var/x = 1; x <= grabbed_by.len; x++)
			if(grabbed_by[x])
				face = 1
				break;



	if(!face)
		face_atom(A)

	if(!canClick()) // in the year 2000...
		return

	if(istype(loc,/obj/mecha))
		if(!locate(/turf) in list(A,A.loc)) // Prevents inventory from being drilled
			return
		var/obj/mecha/M = loc
		return M.click_action(A,src)

	if(restrained())
		setClickCooldown(10)
		RestrainedClickOn(A)
		return

	if(in_throw_mode)
		throw_item(A)
		return

	var/obj/item/W = get_active_hand()

	if(W == A)
		next_move = world.time + 6
		W.attack_self(src)
		if(hand)
			update_inv_l_hand(0)
		else
			update_inv_r_hand(0)

		return

	var/sdepth = A.storage_depth(src)
	if((!isturf(A) && A == loc) || (sdepth != -1 && sdepth <= 1))
		if(W)
			var/resolved = A.attackby(W,src)
			if(!resolved && A && W)
				W.afterattack(A, src, 1, params) // 1 indicates adjacency
		else
			if(ismob(A)) // No instant mob attacking
				setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			UnarmedAttack(A, 1)

		return 1

	if(!isturf(loc)) // This is going to stop you from telekinesing from inside a closet, but I don't shed many tears for that
		return

	// Allows you to click on a box's contents, if that box is on the ground, but no deeper than that
	sdepth = A.storage_depth_turf()//should look here
	if(isturf(A) || isturf(A.loc) || (sdepth != -1 && sdepth <= 1))
		if(A.Adjacent(src)) // see adjacent.dm
			if(W)
				// Return 1 in attackby() to prevent afterattack() effects (when safely moving items for example)
				var/resolved = A.attackby(W,src)
				if(!resolved && A && W)
					W.afterattack(A, src, 1, params) // 1: clicking something Adjacent
			else
				if(ismob(A)) // No instant mob attacking
					setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				UnarmedAttack(A, 1)


			return
		else // non-adjacent click
			if(W)
				W.afterattack(A, src, 0, params) // 0: not Adjacent
			else
				RangedAttack(A, params)
	return 1

/mob/proc/setClickCooldown(var/timeout)
	next_move = max(world.time + timeout, next_move)

/mob/proc/canClick()
	if(next_move <= world.time)
		return 1
	return 0

// Default behavior: ignore double clicks, consider them normal clicks instead
/mob/proc/DblClickOn(var/atom/A, var/params)
	ClickOn(A,params)


/*
	Translates into attack_hand, etc.

	Note: proximity_flag here is used to distinguish between normal usage (flag=1),
	and usage when clicking on things telekinetically (flag=0).  This proc will
	not be called at ranged except with telekinesis.

	proximity_flag is not currently passed to attack_hand, and is instead used
	in human click code to allow glove touches only at melee range.
*/
/mob/proc/UnarmedAttack(var/atom/A, var/proximity_flag)
	return

/mob/proc/KickAttack(var/atom/A, var/proximity_flag)
	return


/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(var/atom/A, var/params)
	if(!mutations.len) return
	if((LASER in mutations) && a_intent == "harm")
		LaserEyes(A) // moved into a proc below
	else if(TK in mutations)
		switch(get_dist(src,A))
			if(0)
				;
			if(1 to 5) // not adjacent may mean blocked by window
				next_move += 2
			if(5 to 7)
				next_move += 5
			if(8 to tk_maxrange)
				next_move += 10
			else
				return
		A.attack_tk(src)
/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(var/atom/A)
	return

/*
	Middle click
	Only used for swapping hands
*/
/mob/proc/MiddleClickOn(var/atom/A)
	var/face = 0
	if(grabbed_by.len)
		for(var/x = 1; x <= grabbed_by.len; x++)
			if(grabbed_by[x])
				face = 1
				break;



	if(!face)
		face_atom(A)

	A.MiddleClick(src)
	return

/atom/proc/MiddleClick(var/mob/M)
	middle_click_intent_check(M)
	return


/mob/proc/RightClickOn(var/atom/A, var/proximity_flag)
	var/face = 0
	if(grabbed_by.len)
		for(var/x = 1; x <= grabbed_by.len; x++)
			if(grabbed_by[x])
				face = 1
				break;



	if(!face)
		face_atom(A)

	if(A.Adjacent(src))
		proximity_flag = 1
	if(proximity_flag > 0)
		if(istype(src, /mob/living/carbon/human) && istype(A.loc, /turf))
			var/mob/living/carbon/human/H = src
			if(H.combat_mode && H.combat_intent == I_DEFEND)
				H.do_combat_intent(I_DEFEND)
				return
		A.RightClick(src)

	else
		if(istype(src, /mob/living/carbon/human) && istype(A.loc, /turf) || istype(src, /mob/living/carbon/human) && istype(A.loc, /area))
			var/mob/living/carbon/human/H = src
			if(H.combat_mode && H.combat_intent == I_DEFEND)
				H.do_combat_intent(I_DEFEND)
				return
		if((istype(A, /mob/living) || istype(A, /obj/structure/oldways)) && istype(src, /mob/living/carbon/human))
			var/atom/user = A
			var/mob/living/carbon/human/H = src
			if(usr.next_move >= world.time)
				return
			H.next_move = world.time + 2
			if(!(user in view(1, H)))
				if(H.a_intent == "help" && H.get_active_hand() == null)
					if(istype(user, /mob/living/carbon/human/bumbot))
						spawn(rand(40, 45))
							user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>waves friendly at <span class='passivebold'>[H]</span><span class='passive'>.</span>")
					return src.visible_message("<span class='passivebold'>[H]</span> <span class='passive'>waves friendly at <span class='passivebold'>[user]</span><span class='passive'>.</span>")
				if(H.a_intent == "hurt")
					if(H.get_active_hand() == null)
						return src.visible_message("<span class='combatbold'>[H]</span><span class='combat'> threatens </span><span class='combatbold'>[user]</span> <span class='combat'>with his fists!</span>")
					var/obj/item/I = H.get_active_hand()
					if(istype(I, /obj/item/weapon/gun))
						var/obj/item/weapon/gun/G = I
						G.aim_at(user)
						return src.visible_message("<span class='combatbold'>[H]</span><span class='combat'> aims at [user] with <b>[I]</b>!</span>")
					return src.visible_message("<span class='combatbold'>[H]</span><span class='combat'> threatens [user] with <b>[I]</b>!</span>")


	return

/atom/proc/RightClick(var/mob/user)
	if(user.attackhand_rightclick())//se ele vai dar attackhand com a mao vazia
		src.attackhand_right(user)
	return

/atom/proc/attackhand_right(var/mob/user)
	return

/mob/proc/AltRightClickOn(var/atom/A)
	A.AltRightClick(src)
/*
/atom/proc/AltRightClick(var/mob/user)
	return
*/
/atom/proc/AltRightClick(var/mob/user)
	..()
	if(!istype(user))
		return
	if(user.lying)
		return
	user.visible_message("<span class='notice'>[user] peers into the distance.</span>")
	user.face_atom(src)
	user.do_zoom()
	return

/mob/proc/CtrlRightClickOn(var/atom/A)
	A.CtrlRightClick(src)

/atom/proc/CtrlRightClick(var/mob/user)
	..()
	if(!istype(user))
		return
	if(user.lying)
		return
	if(!user || !isturf(user.loc))
		return
	if(user.stat || user.restrained())
		return
	if(user.status_flags & FAKEDEATH)
		return
	if(user.next_move >= world.time)
		return
	var/tile = get_turf(src)
	if (!tile)
		return

	var/P = new /obj/effect/decal/point(tile)
	spawn (20)
		if(P)	qdel(P)

	user.face_atom(src)
	user.visible_message("<span class='examinebold'>[usr]</span><span class='examine'> points at</span><span class='examinebold'> [src].</span>")
	user.next_move = world.time + 20


// In case of use break glass
/*
/atom/proc/MiddleClick(var/mob/M as mob)
	return
*/

/obj/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] && istype(usr, /mob/living/carbon))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/turf/T = screen_loc2turf(screen_loc, get_turf(usr))
		if(T)
			T.Click(location, control, params)
	. = 1




/*
	Shift click
	For most mobs, examine.
	This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(var/atom/A)
	A.ShiftClick(src)
	return
/atom/proc/ShiftClick(var/mob/user)
	if(user.client && user.client.eye == user)
		examine()
		user.face_atom(src)
	return

/*
	Ctrl click
	For most objects, pull
*/
/mob/proc/CtrlClickOn(var/atom/A)
	A.CtrlClick(src)
	return
/atom/proc/CtrlClick(var/mob/user)
	return

/atom/movable/CtrlClick(var/mob/user)
	if(Adjacent(user))
		user.start_pulling(src)

/*
	Alt click
	Unused except for AI
*/
/mob/proc/AltClickOn(var/atom/A)
	A.AltClick(src)
	return

/atom/proc/AltClick(var/mob/user)
	var/turf/T = get_turf(src)
	if(T && T.Adjacent(user))
		if(user.listed_turf == T)
			user.listed_turf = null
		else
			user.listed_turf = T
			user.client.statpanel = T.name
	return

/*
	Misc helpers

	Laser Eyes: as the name implies, handles this since nothing else does currently
	face_atom: turns the mob towards what you clicked on
*/
/mob/proc/LaserEyes(atom/A)
	return

/mob/living/LaserEyes(atom/A)
	next_move = world.time + 6
	var/turf/T = get_turf(src)
	var/turf/U = get_turf(A)

	var/obj/item/projectile/beam/LE = new /obj/item/projectile/beam( loc )
	LE.icon = 'icons/effects/genetics.dmi'
	LE.icon_state = "eyelasers"
	playsound(usr.loc, 'sound/weapons/taser2.ogg', 75, 1)

	LE.firer = src
	LE.def_zone = get_organ_target()
	LE.original = A
	LE.current = T
	LE.yo = U.y - T.y
	LE.xo = U.x - T.x
	spawn( 1 )
		LE.process()

/mob/living/carbon/human/LaserEyes()
	if(nutrition>0)
		..()
		nutrition = max(nutrition - rand(1,5),0)
		handle_regular_hud_updates()
	else
		src << "\red You're out of energy!  You need food!"

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(var/atom/A)
	if(!A || !x || !y || !A.x || !A.y) return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) return
	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)	direction = NORTH
		else		direction = SOUTH
	else
		if(dx > 0)	direction = EAST
		else		direction = WEST
	if(direction != dir)
		if(facing_dir)
			facing_dir = direction
		facedir(direction)
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		var/datum/organ/external/head/E = H.get_organ("head")
		if(E && E.headwrenched)
			H.update_hair()
			H.update_inv_glasses()
			H.update_inv_head()

/mob/proc/scramble(var/atom/A)
	var/direction
	if(stat || buckled || paralysis || stunned || sleeping || (status_flags & FAKEDEATH) || restrained() || grabbed_by.len >= 1 || (weakened > 5))
		return
	if(!istype(src.loc, /turf/))
		return
	if(!A || !x || !y || !A.x || !A.y) return
	if(scrambling)
		return
	if(src.get_active_hand())
		if(r_hand)
			return
		if(l_hand)
			return
	if(!has_limbs)
		to_chat(src, "<i>You can't even move yourself - you have no limbs!</i>")
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.special == "wormcrawl")
			to_chat(src, "HALT! I'm not a worm!")
			return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) return

	if(abs(dx) < abs(dy))
		if(dy > 0)	direction = NORTH
		else		direction = SOUTH
	else
		if(dx > 0)	direction = EAST
		else		direction = WEST
	if(direction)
		if(src.nutrition > 150)
			scrambling = 1
			src.visible_message("<span class='combatbold'>[src]</span> <span class='combat'>crawls over the [A]!</span>")
			sleep(4)
			Move(get_step(src,direction))
			scrambling = 0
			dir = 2
			return
		if(istype(src, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = src
			if(H.last_dam > 50)
				scrambling = 1
				src.visible_message("<span class='combatbold'>[src]</span> <span class='combat'>crawls over the [A]!</span>")
				sleep(2)
				Move(get_step(src,direction))
				scrambling = 0
				dir = 2
				return
		else
			scrambling = 1
			src.visible_message("<span class='combatbold'>[src]</span> <span class='combat'>crawls over the [A]</span>!")
			sleep(4)
			Move(get_step(src,direction))
			scrambling = 0
			dir = 2
			return

/atom/proc/middle_click_intent_check(var/mob/living/carbon/human/M)
	if(usr.next_move >= world.time)
		return
	if(M.middle_click_intent == "kick")
		return kick_act(M)
	if(M.middle_click_intent == "jump")
		return jump_act(src, M)
	if(M.middle_click_intent == "bite")
		return bite_act(M)
	if(M.middle_click_intent == "steal")
		if(istype(M?.species, /datum/species/human/alien) && M.mind.alien && world.time > (M.mind.alien.last_spit + SPIT_DELAY))
			M.blood_squirt(300, M.loc, get_dir(M.loc, src), removesblood=0, acidblood=1, distance=5)
			playsound(M.loc, pick('sound/webbers/alien_combat1.ogg', 'sound/webbers/alien_combat2.ogg', 'sound/webbers/alien_combat3.ogg', 'sound/webbers/alien_combat4.ogg'), 100, 0)
			playsound(M.loc, 'sound/lfwbsounds/blood_splat.ogg', 100, 0)
			M.mind.alien.last_spit = world.time
			M.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
			return 1
		else
			return steal_act(M)
	else
		return clean_mmb(M)

/atom/proc/clean_mmb(mob/living/carbon/human/user)
	return

/atom/proc/stab_act(mob/living/carbon/human/user)
	return

/mob/living/carbon/human/stab_act(var/mob/living/carbon/human/user)


/mob/proc/attackhand_rightclick()
	if(!usr) return FALSE

	if(usr.next_move >= world.time)
		return FALSE

	if(usr.get_active_hand() != null)
		return FALSE

	usr.next_move = world.time + 20

	return 1

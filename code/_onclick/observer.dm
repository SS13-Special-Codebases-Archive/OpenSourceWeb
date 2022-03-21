/client/var/inquisitive_ghost = 1
/mob/dead/observer/verb/toggle_inquisition() // warning: unexpected inquisition
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"
	set category = "Wraith"
	if(!client) return
	client.inquisitive_ghost = !client.inquisitive_ghost
	if(client.inquisitive_ghost)
		src << "\blue You will now examine everything you click on."
	else
		src << "\blue You will no longer examine things you click on."

/mob/dead/observer/verb/ascend()
	set category = "Wraith"
	set name = "Ascend"

	if(in_hell)
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] I've been damned!</span>")
		return

	if(src.wraith_pain >= 30)
		var/mob/new_player/M = new /mob/new_player()
		if(!client)
			log_game("[usr.key] AM failed due to disconnect.")
			qdel(M)
			return

		M.key = key
		M.client.color = null
	else
		to_chat(src, "<spanclass='combat'>([wraith_pain]/30)</span><span class='combat'> Pain required.</span>")

/mob/dead/observer/verb/jaunt(var/mob/living/carbon/human/M in player_list)
	set category = "Wraith"
	set name = "Jaunt"

	if(in_hell)
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] I've been damned!</span>")
		return
	if(src.wraith_pain >= 5)
		if(can_reenter_corpse)
			can_reenter_corpse = FALSE
			to_chat(usr, "<span class='combatglow'>You throw your chances away.</span>")
		to_chat(src, "<spanclass='jogtowalk'>5 Pain lost.</span>")
		src.wraith_pain -= 5
		src.forceMove(M.loc)
	else
		to_chat(src, "<spanclass='combat'>([wraith_pain]/5)</span><span class='combat'> Pain required.</span>")

/mob/dead/observer/verb/gruespawn() // warning: unexpected inquisition
	set name = "GrueSpawn"
	set category = "Wraith"
	if(in_hell)
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] I've been damned!</span>")
		return
	var/turf/T = get_turf(src)
	var/area/A = get_area(T)
	if(A.luminosity || istype(A,/area/dunwell/realsurface) || istype(A, /area/shuttle/train))
		to_chat(src, "<spanclass='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> too bright!</span>")
		return
	if(src.wraith_pain >= 15)
		if(can_reenter_corpse)
			can_reenter_corpse = FALSE
			to_chat(usr, "<span class='combatglow'>You throw your chances away.</span>")
		to_chat(src, "<spanclass='jogtowalk'>15 Pain lost.</span>")
		src.wraith_pain -= 15
		new /mob/living/simple_animal/grue(src.loc)
		return
	else
		to_chat(src, "<spanclass='combat'>([wraith_pain]/15)</span><span class='combat'> Pain required.</span>")
		return


/*/mob/dead/observer/verb/ignition()
	set name = "Ignition"
	set category = "Wraith"
	if(in_hell)
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] I've been damned!</span>")
		return
	if(src.wraith_pain >= 30)
		if(can_reenter_corpse)
			can_reenter_corpse = FALSE
			to_chat(usr, "<span class='combatglow'>You throw your chances away.</span>")
		to_chat(src, "<spanclass='jogtowalk'>30 Pain lost.</span>")
		src.wraith_pain -= 30
		new /obj/structure/fire(src.loc)
		return
	else
		to_chat(src, "<spanclass='combat'>([wraith_pain]/30)</span><span class='combat'> Pain required.</span>")
		return*/

/mob/dead/observer/verb/intervene_dreams(msg as text)
	set name = "InterveneDreams"
	set category = "Wraith"
	if(in_hell)
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] I've been damned!</span>")
		return
	msg = sanitize(msg)
	if(!msg)	return
	var/turf/T = get_turf(src)
	for(var/mob/living/carbon/human/H in T.loc)
		if(H.stat == 1)
			to_chat(H, "<span class='passive'> <i>... [msg] ...</i></span>")
			if(prob(12))
				H << pick('dream1.ogg','dream2.ogg','dream3.ogg','dream4.ogg','dream5.ogg')

/mob/dead/observer/DblClickOn(var/atom/A, var/params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return
	if(in_hell)
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] I've been damned!</span>")
		return
	if(src.wraith_pain >= 1)
		if(istype(A,/obj/structure/fireplace) || istype(A, /obj/structure/torchwall))
			var/obj/structure/fireplace/F = A
			if(F.lit)
				F.turn_off()
				if(can_reenter_corpse)
					can_reenter_corpse = FALSE
					to_chat(usr, "<span class='combatglow'>You throw your chances away.</span>")
				to_chat(src, "<spanclass='jogtowalk'>1 Pain lost.</span>")
				src.wraith_pain -= 1
				return
			else
				return
		if(istype(A,/obj/machinery/light))
			var/obj/machinery/light/F = A
			if(F.on)
				F.flicker(rand(10,20))
				if(can_reenter_corpse)
					can_reenter_corpse = FALSE
					to_chat(usr, "<span class='combatglow'>You throw your chances away.</span>")
				to_chat(src, "<spanclass='jogtowalk'>1 Pain lost.</span>")
				src.wraith_pain -= 1
				return
			else
				return
	else
		to_chat(src, "<spanclass='combat'>([wraith_pain]/1)</span><span class='combat'> Pain required.</span>")
		return
/*
	if(can_reenter_corpse && mind && mind.current)
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse()						// (cloning scanner, body bag, closet, mech, etc)
			return									// seems legit.

	// Things you might plausibly want to follow
	if((ismob(A) && A != src) || istype(A,/obj/machinery/bot) || istype(A,/obj/machinery/singularity))
		ManualFollow(A)

	// Otherwise jump
	else
		following = null
		loc = get_turf(A)
*/
/mob/dead/observer/ClickOn(var/atom/A, var/params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return
	if(world.time <= next_move) return
	next_move = world.time + 8
	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/dead/observer/user as mob)
	if(user.client && user.client.inquisitive_ghost)
		examine()
	return

// ---------------------------------------
// And here are some good things for free:
// Now you can click through portals, wormholes, gateways, and teleporters while observing. -Sayu

/obj/machinery/teleport/hub/attack_ghost(mob/user as mob)
	var/atom/l = loc
	var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(l.x - 2, l.y, l.z))
	if(com.locked)
		user.loc = get_turf(com.locked)

/obj/effect/portal/attack_ghost(mob/user as mob)
	if(target)
		user.loc = get_turf(target)

/obj/machinery/gateway/centerstation/attack_ghost(mob/user as mob)
	if(awaygate)
		user.loc = awaygate.loc
	else
		user << "[src] has no destination."

/obj/machinery/gateway/centeraway/attack_ghost(mob/user as mob)
	if(stationgate)
		user.loc = stationgate.loc
	else
		user << "[src] has no destination."

// -------------------------------------------
// This was supposed to be used by adminghosts
// I think it is a *terrible* idea
// but I'm leaving it here anyway
// commented out, of course.
/*
/atom/proc/attack_admin(mob/user as mob)
	if(!user || !user.client || !user.client.holder)
		return
	attack_hand(user)

*/

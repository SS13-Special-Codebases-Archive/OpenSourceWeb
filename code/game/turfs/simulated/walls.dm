/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/walls.dmi'
	var/mineral = "metal"
	var/rotting = 0

	var/damage = 0
	var/damage_cap = 180 //Wall will break down to girders if damage reaches this point
	var/siegeblocked = FALSE // pra evitar que façam escada durante siege

	var/damage_overlay
	var/global/damage_overlays[8]

	var/max_temperature = 1800 //K, walls will take damage if they're next to a fire hotter than this
	var/climbable = FALSE
	var/turf_above = /turf/simulated/floor/lifeweb/stonedamaged

	layer = 2.01
	opacity = 1
	density = 1
	blocks_air = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	plane = 21
	var/walltype = "metal"
/*
/turf/simulated/wall/Destroy()
	for(var/obj/effect/E in src) if(E.name == "Wallrot") qdel(E)
	. = ..()
*/

/turf/simulated/wall/MouseDrop_T(mob/M as mob)
	..()
	if(M != usr) return
	if(!Adjacent(usr)) return
	if(ishuman(M))
		if(usr.get_active_hand())
			return

		var/turf/T = get_step(M, turn(M.dir, 180))
		if(T == src && ishuman(M))
			var/mob/living/carbon/human/H = M
			H.isLeaning = 1
			H.check_fov()
			switch(H.dir)
				if(SOUTH)
					H.pixel_y = 11
				if(NORTH)
					H.pixel_y = -11
				if(WEST)
					H.pixel_x = 11
				if(EAST)
					H.pixel_x = -11

		if(!climbable)
			to_chat(usr, "<span class='combatbold'>[pick(nao_consigoen)] I can't even imagine climbing this!</span>")
			return
		else
			var/mob/living/carbon/human/H = M
			var/list/rolled = roll3d6(H,SKILL_CLIMB,null)
			switch(rolled[GP_RESULT])
				if(GP_FAILED, GP_CRITFAIL)
					H.clinged_turf = null
					to_chat(H, "You failed to cling to \the [H.clinged_turf]")
					H.adjustStaminaLoss(rand(1,2))
				if(GP_SUCCESS, GP_CRITSUCCESS)
					H.clinged_turf = src
					to_chat(H, "You cling to \the [H.clinged_turf]")
					H.adjustStaminaLoss(rand(2,4))

/turf/simulated/floor/MouseDrop_T(mob/M as mob)
	..()
	if(M != usr) return
	if(!Adjacent(usr)) return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.clinged_turf)
			var/turf/T = H.clinged_turf
			if(do_after(H, 12-H.my_skills.GET_SKILL(SKILL_CLIMB)))
				var/list/L = list(SOUTHEAST, SOUTHWEST, NORTHEAST,NORTHWEST)
				var/dird = get_dir(H, T)
				switch(dird)
					if(EAST)
						L = list(NORTHEAST, SOUTHEAST)
					if(WEST)
						L = list(NORTHWEST, SOUTHWEST)
					if(SOUTH)
						L = list(SOUTHEAST, SOUTHWEST)
					if(NORTH)
						L = list(NORTHEAST, NORTHWEST)

				var/list/allowedTurfs = list() //THUX FEZ ESSA PORRA COM O TOBA E EU NAO VOU REFAZER
				for(var/dir in L)
					var/turf/TT = get_step(M, dir)
					allowedTurfs += TT
				if(src in allowedTurfs)
					H.x = x
					H.y = y
					H.z = z
					return
				if(get_dist(src, T) <= 1)
					H.clingmove(src)

/mob/living/carbon/human/proc/clingmove(var/atom/A)
	var/direction
	if(stat || buckled || paralysis || stunned || sleeping || (status_flags & FAKEDEATH) || restrained() || grabbed_by.len >= 1 || (weakened > 5))
		return
	if(!istype(src.loc, /turf/))
		return
	if(!A || !x || !y || !A.x || !A.y) return
	if(src.get_active_hand())
		if(r_hand)
			return
		if(l_hand)
			return
	if(scrambling)
		return
	if(!has_limbs)
		to_chat(src, "<i>You can't even move yourself - you have no limbs!</i>")
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) return

	if(abs(dx) < abs(dy))
		if(dy > 0)	direction = NORTH
		else		direction = SOUTH
	else
		if(dx > 0)	direction = EAST
		else		direction = WEST
	var/direction2 = get_dir(src, src.clinged_turf)
	playsound(src.loc, 'sound/effects/climb.ogg', 40, 1)
	src.adjustStaminaLoss(rand(4,8))
	if(direction)
		if(src.nutrition > 150)
			scrambling = 1
			Move(get_step(src,direction))
			scrambling = 0
			dir = 2
			src.dir = direction2
			return
		if(istype(src, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = src
			if(H.last_dam > 50)
				scrambling = 1
				Move(get_step(src,direction))
				scrambling = 0
				dir = 2
				src.dir = direction2
				return
		else
			scrambling = 1
			Move(get_step(src,direction))
			scrambling = 0
			dir = 2
			return

/turf/simulated/wall/ChangeTurf(var/newtype)
	for(var/obj/effect/E in src) if(E.name == "Wallrot") qdel(E)
	. = ..(newtype)

/turf/simulated/wall/Bumped(AM as mob)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM

		if(H.stat)
			return

		if(H.resting)
			return

		if(H.sleeping)
			return

		if(!H.canmove)
			return
		if(H.sprinting || H.confused)
			var/damage = 8
			H.apply_damage(damage + rand(-5,5), BRUTE, "head")
			H.apply_damage(damage + rand(-5,5), BRUTE, "r_chest")
			H:weakened = max(H:weakened,4)
			recoil(H)
			H.adjustStaminaLoss(rand(2,5))
			playsound(H.loc, 'sound/weapons/bite.ogg', 70, 0)
			step_away(H,src,1)
			H.sound2()
			H.sprinting = FALSE
			H.CU()
			if(prob(80))
				H.apply_effect(5, PARALYZE)
				visible_message("<span class='combatglow'><b>[H]</b> has been knocked unconscious!</span>")
				H.ear_deaf = max(H.ear_deaf,6)
				H.CU()
//Appearance

/turf/simulated/wall/examine()
	. = ..()

	if(istype(src, /turf/simulated/wall/r_wall/cave))
		return
	if(!damage)
		to_chat(usr, "<span class='notice'>It looks fully intact.</span>")
	else
		var/dam = damage / damage_cap
		if(dam <= 0.3)
			to_chat(usr, "<span class='warning'>It looks slightly damaged.</span>")
		else if(dam <= 0.6)
			to_chat(usr, "<span class='warning'>It looks moderately damaged.</span>")
		else
			to_chat(usr,  "<span class='danger'>It looks heavily damaged.</span>")

	if(rotting)
		to_chat(usr, "<span class='warning'>There is fungus growing on [src].</span>")

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

/turf/simulated/wall/proc/damage_overlay()
	var/image/img = image(icon = 'icons/turf/bholes.dmi', icon_state = pick("bhole1","bhole2","bhole3","bhole4"))
	img.pixel_x = rand(1,32)
	img.pixel_y = rand(1,32)
	src.overlays += img

//Damage

/turf/simulated/wall/proc/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()
		damage_overlay()
	return

/turf/simulated/wall/proc/update_damage()
	var/cap = damage_cap
	if(rotting)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()

	return
/*
/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	if(adj_temp > max_temperature)
		take_damage(rand(10, 20) * (adj_temp / max_temperature))

	return ..()
*/
/turf/simulated/wall/proc/dismantle_wall(devastated=0, explode=0)
	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

	new/obj/item/weapon/stone(src)
	new/obj/item/weapon/stone(src)
	new/obj/item/weapon/stone(src)
	new/obj/item/weapon/stone(src)
	ChangeTurf(/turf/simulated/floor/lifeweb/stonedamaged)

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(90))
				src.ChangeTurf(/turf/simulated/floor/lifeweb/stonedamaged)
			else
				src.ChangeTurf(/turf/simulated/floor/open)
			return
		if(2.0)
			if(prob(75))
				take_damage(rand(150, 250))
			else
				dismantle_wall(1,1)
		if(3.0)
			take_damage(rand(0, 250))
		else
	return

/turf/simulated/wall/blob_act()
	take_damage(rand(75, 125))
	return

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(!rotting)
		rotting = 1

		var/number_rots = rand(2,3)
		for(var/i=0, i<number_rots, i++)
			var/obj/effect/overlay/O = new/obj/effect/overlay( src )
			O.name = "Wallrot"
			O.desc = "Ick..."
			O.icon = 'icons/effects/wallrot.dmi'
			O.pixel_x += rand(-10, 10)
			O.pixel_y += rand(-10, 10)
			O.anchored = 1
			O.density = 1
			O.layer = 5
			O.mouse_opacity = 0

/turf/simulated/wall/proc/thermitemelt(mob/user as mob)
	if(mineral == "diamond")
		return
	var/obj/effect/overlay/O = new/obj/effect/overlay( src )
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = 1
	O.density = 1
	O.layer = 5

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "wall_thermite"
	user << "<span class='warning'>The thermite starts melting through the wall.</span>"

	spawn(100)
		if(O)	qdel(O)
//	F.sd_LumReset()		//TODO: ~Carn
	return

/turf/simulated/wall/meteorhit(obj/M as obj)
	if (prob(15) && !rotting)
		dismantle_wall()
	else if(prob(70) && !rotting)
		ChangeTurf(/turf/simulated/floor/plating)
	else
		ReplaceWithLattice()
	return 0

//Interactions

/turf/simulated/wall/attack_paw(mob/user as mob)
	if ((HULK in user.mutations))
		if (prob(40))
			to_chat(user, "\blue You smash through the wall.")
			usr.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			dismantle_wall(1)
			return
		else
			to_chat(user, "\blue You punch the wall.")
			take_damage(rand(25, 75))
			return

	return src.attack_hand(user)


/turf/simulated/wall/attack_animal(mob/living/M as mob)
	if(M.wall_smash)
		if (istype(src, /turf/simulated/wall/r_wall) && !rotting)
			M << text("\blue This wall is far too strong for you to destroy.")
			return
		else
			if (prob(40) || rotting)
				M << text("\blue You smash through the wall.")
				dismantle_wall(1)
				return
			else
				M << text("\blue You smash against the wall.")
				take_damage(rand(25, 75))
				return

	to_chat(M, "You push the wall but nothing happens!")
	return

/turf/simulated/wall/attackby(obj/item/weapon/W as obj, mob/user as mob)
	//get the user's location
	if( !istype(user.loc, /turf) )	return	//can't do this stuff whilst inside objects and such

	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if(G.aforgan.display_name == "chest")
			climbWallHelp(G.affecting, G.assailant)
		else
			if(istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
				if(G.assailant.zone_sel.selecting == "head" && !G.affecting.lying)
					if(ishuman(G.affecting))
						G.affecting.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been smashed on the floor by [G.assailant.name] ([G.assailant.ckey])</font>")
						G.assailant.attack_log += text("\[[time_stamp()]\] <font color='red'>Smashed [G.affecting.name] ([G.affecting.ckey]) on the floor.</font>")

						//log_admin("ATTACK: [G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a table.", 2)
						message_admins("ATTACK: [G.assailant] ([G.assailant.ckey])(<A HREF='?_src_=holder;adminplayerobservejump=\ref[G]'>JMP</A>) smashed [G.affecting] ([G.affecting.ckey]) on the floor.", 2)
						log_attack("[G.assailant] ([G.assailant.ckey]) smashed [G.affecting] ([G.affecting.ckey]) on a table.")

						var/mob/living/carbon/human/H = G.affecting
						var/datum/organ/external/affecting = H.get_organ("head")
						if(prob(25))
							affecting.take_damage(rand(25,35), 0)
							H.Weaken(2)
							if(prob(20)) // One chance in 20 to DENT THE TABLE
								affecting.take_damage(rand(8,15), 0) //Extra damage
								H.apply_effect(5, PARALYZE)
								visible_message("<span class='combatglow'><b>[H]</b>< has been knocked unconscious!</span>")
								H.ear_damage += rand(0, 3)
								H.ear_deaf = max(H.ear_deaf,6)
								H.CU()
								G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
								"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
								"\red You hear the nauseating crunch of bone and gristle on solid metal, the noise echoing through the room.")
							else if(prob(50))
								G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
								"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] bone and cartilage making a loud crunch!",\
								"\red You hear the nauseating crunch of bone and gristle on solid metal, the noise echoing through the room.")
							else
								G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
								"\red You smash \the [H]'s head on \the [src], [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] nose smashed and face bloodied!",\
								"\red You hear the nauseating crunch of bone and gristle on solid metal and the gurgling gasp of someone who is trying to breathe through their own blood.")
						else
							affecting.take_damage(rand(5,10), 0)
							G.assailant.visible_message("\red [G.assailant] smashes \the [H]'s head on \the [src]!",\
							"\red You smash \the [H]'s head on \the [src]!",\
							"\red You hear the nauseating crunch of bone and gristle on solid metal.")
						add_blood(G.affecting, 1) //Forced
						H.UpdateDamageIcon()
						H.updatehealth()
						var/mob/living/carbon/human/AS = G.assailant
						AS.adjustStaminaLoss(rand(6,15))
						playsound(H.loc, pick('sound/effects/gore/smash1.ogg','sound/effects/gore/smash2.ogg','sound/effects/gore/smash3.ogg'), 50, 1, -3)
						qdel(G)
	//DECONSTRUCTION
	if(user.a_intent == "hurt")
		if(W.force <= 5)
			return
		if(istype(W, /obj/item/weapon/grab))
			return
		visible_message("<span class='danger'>[src] has been hit by [user] with [W].</span>")
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		var/totaldamage = W.force/5
		if(!W.sharp && !W.edge)
			totaldamage = W.force/6
			W.damageItem("HARD")
		else
			totaldamage = W.force/8
			W.damageItem("HARD")
		take_damage(totaldamage)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.adjustStaminaLoss(rand(4,6))
			take_damage((H.my_stats.st+H.my_stats.ht)/6)
		playsound(src, pick('wallhit.ogg','wallhit2.ogg','wallhit3.ogg'), 80, 1)
		return

/turf/simulated/wall/attack_hand(mob/living/carbon/human/user as mob)
	if(src.z != user.z)
		return
	src.add_fingerprint(user)
	climbWall(user)


/*
/turf/simulated/wall/attack_hand(mob/living/carbon/human/user as mob)
	if(user.a_intent == "hurt" && user.my_stats.st >= 20)
		if(user.hand && user.organs_by_name["l_hand"].status != 64 )
			user.apply_damage(80, BRUTE,"l_hand")
			dismantle_wall(1)
			playsound(user.loc, "sound/effects/screamhulk.ogg", 80, 1)
		else if(!user.hand && user.organs_by_name["r_hand"].status != 64)
			user.apply_damage(80, BRUTE, "r_hand")
			dismantle_wall(1)
			playsound(user.loc, "sound/effects/screamhulk.ogg", 80, 1)
		else
			return
	else
		user << text("<b style='color:red'>I won't punch a wall!</b>")
*/
/turf/simulated/wall/bullet_act()
	..()
	if(istype(src, /turf/simulated/wall/stone))
		return
	var/som = pick('sound/projectilesnew/ric1.ogg', 'sound/projectilesnew/ric2.ogg', 'sound/projectilesnew/ric3.ogg', 'sound/projectilesnew/ric4.ogg')
	playsound(src, som, 300, 0)
	damage_overlay()
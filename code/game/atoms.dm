/atom
	layer = 2
	var/level = 2
	var/flags = FPRINT
	var/list/fingerprints
	var/list/fingerprintshidden
	var/fingerprintslast = null
	var/list/blood_DNA
	var/blood_color
	var/last_bumped = 0
	var/pass_flags = 0
	var/throwpass = 0
	var/lightEmitter = 0
	var/germ_level = 0 // The higher the germ level, the more germ on the atom.
	var/simulated = 1
	var/cleanable = FALSE
	var/slowdown_modifier
	var/flammable = 0 //If it's able to get on fire
	///Chemistry.
	var/datum/reagents/reagents = new()

	//var/chem_is_open_container = 0
	// replaced by OPENCONTAINER flags and atom/proc/is_open_container()
	///Chemistry.

	//Detective Work, used for the duplicate data points kept in the scanners
	var/list/original_atom
	var/list/filter_data
	var/temperature = T20C

/atom/proc/throw_impact(atom/hit_atom, var/speed)
	if(istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		//var/mob/living/carbon/human/H = src

		if(!istype(src, /obj/item)) // this is a big item that's being thrown at them~

			if(istype(M, /mob/living/carbon/human))
				var/armor_block = M:run_armor_check("chest", "melee", null, TRUE)
				M:apply_damage(rand(2,8), BRUTE, "chest", armor_block)

				visible_message("<span class='combatbold'>[M]</span> <span class='combat'>has been knocked down by the force of</span> <span class='combatbold'>[src]</span><span class='combat'>!</span>")
				M:apply_effect(rand(0,1), WEAKEN, armor_block)
				src:apply_effect(rand(0,1), WEAKEN, armor_block)

				M:UpdateDamageIcon()
			else
				M.take_organ_damage(rand(20,45))
		else if(src.vars.Find("throwforce"))
			M.hitby(src,speed)		//hitby will log the attack itself

//		log_attack("<font color='red'>[hit_atom] ([M.ckey]) was hit by [src] thrown by ([src.fingerprintslast])</font>")
//			//log_admin("ATTACK: [hit_atom] ([M.ckey]) was hit by [src] thrown by ([src.fingerprintslast])")
//			msg_admin_attack("[hit_atom] ([M.ckey])(<A HREF='?src=%admin_ref%;adminplayerobservejump=\ref[M]'>JMP</A>) was hit by [src] thrown by ([src.fingerprintslast])", 2)



	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.dir)
		O.hitby(src,speed)

	else if(isturf(hit_atom))
		var/turf/T = hit_atom
		if(T.density)
			spawn(2)
				step(src, turn(src.dir, 180))
			if(istype(src,/mob/living))
				var/mob/living/M = src
				playsound(loc, "trauma", 50, 1, -1)
				visible_message("[M] slams into the wall!")
				T.add_blood(src)
				M.take_organ_damage(20)
				if(prob(40))
					M.emote("scream")


/atom/proc/assume_air(datum/gas_mixture/giver)
	qdel(giver)
	return null

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/living/silicon/ai)) // WHYYYY
		return 1
	return

/atom/proc/on_reagent_change()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

// Convenience proc to see if a container is open for chemistry handling
// returns true if open
// false if closed
/atom/proc/is_open_container()
	return flags & OPENCONTAINER

/*//Convenience proc to see whether a container can be accessed in a certain way.

	proc/can_subract_container()
		return flags & EXTRACT_CONTAINER

	proc/can_add_container()
		return flags & INSERT_CONTAINER
*/


/atom/proc/meteorhit(obj/meteor as obj)
	return

/atom/proc/allow_drop()
	return 1

/atom/proc/CheckExit()
	return 1

/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/proc/emp_act(var/severity)
	return

/atom/proc/bullet_act(var/obj/item/projectile/Proj)
	return 0

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/*
 *	atom/proc/search_contents_for(path,list/d_filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *	   list/d_filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path,list/d_filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(d_filter_path)
			var/pass = 0
			for(var/type in d_filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,d_filter_path)
	return found




/*
Beam code by Gunbuddy

Beam() proc will only allow one beam to come from a source at a time.  Attempting to call it more than
once at a time per source will cause graphical errors.
Also, the icon used for the beam will have to be vertical and 32x32.
The math involved assumes that the icon is vertical to begin with so unless you want to adjust the math,
its easier to just keep the beam vertical.
*/
/atom/proc/Beam(atom/BeamTarget,icon_state="b_beam",icon='icons/effects/beam.dmi',time=50, maxdistance=10)
	//BeamTarget represents the target for the beam, basically just means the other end.
	//Time is the duration to draw the beam
	//Icon is obviously which icon to use for the beam, default is beam.dmi
	//Icon_state is what icon state is used. Default is b_beam which is a blue beam.
	//Maxdistance is the longest range the beam will persist before it gives up.
	var/EndTime=world.time+time
	while(BeamTarget&&world.time<EndTime&&get_dist(src,BeamTarget)<maxdistance&&z==BeamTarget.z)
	//If the BeamTarget gets deleted, the time expires, or the BeamTarget gets out
	//of range or to another z-level, then the beam will stop.  Otherwise it will
	//continue to draw.

		dir=get_dir(src,BeamTarget)	//Causes the source of the beam to rotate to continuosly face the BeamTarget.

		for(var/obj/effect/overlay/beam/O in orange(10,src))	//This section erases the previously drawn beam because I found it was easier to
			if(O.BeamSource==src)				//just draw another instance of the beam instead of trying to manipulate all the
				del O							//pieces to a new orientation.
		var/Angle=round(Get_Angle(src,BeamTarget))
		var/icon/I=new(icon,icon_state)
		I.Turn(Angle)
		var/DX=(32*BeamTarget.x+BeamTarget.pixel_x)-(32*x+pixel_x)
		var/DY=(32*BeamTarget.y+BeamTarget.pixel_y)-(32*y+pixel_y)
		var/N=0
		var/length=round(sqrt((DX)**2+(DY)**2))
		for(N,N<length,N+=32)
			var/obj/effect/overlay/beam/X=new(loc)
			X.BeamSource=src
			if(N+32>length)
				var/icon/II=new(icon,icon_state)
				II.DrawBox(null,1,(length-N),32,32)
				II.Turn(Angle)
				X.icon=II
			else X.icon=I
			var/Pixel_x=round(sin(Angle)+32*sin(Angle)*(N+16)/32)
			var/Pixel_y=round(cos(Angle)+32*cos(Angle)*(N+16)/32)
			if(DX==0) Pixel_x=0
			if(DY==0) Pixel_y=0
			if(Pixel_x>32)
				for(var/a=0, a<=Pixel_x,a+=32)
					X.x++
					Pixel_x-=32
			if(Pixel_x<-32)
				for(var/a=0, a>=Pixel_x,a-=32)
					X.x--
					Pixel_x+=32
			if(Pixel_y>32)
				for(var/a=0, a<=Pixel_y,a+=32)
					X.y++
					Pixel_y-=32
			if(Pixel_y<-32)
				for(var/a=0, a>=Pixel_y,a-=32)
					X.y--
					Pixel_y+=32
			X.pixel_x=Pixel_x
			X.pixel_y=Pixel_y
		sleep(3)	//Changing this to a lower value will cause the beam to follow more smoothly with movement, but it will also be more laggy.
					//I've found that 3 ticks provided a nice balance for my use.
	for(var/obj/effect/overlay/beam/O in orange(10,src)) if(O.BeamSource==src) del O


//All atoms
/atom/verb/examine()
	set name = "Examine"
	set category = "IC"
	set src in view(usr.client) //If it can be seen, it can be examined.
	//This reformat names to get a/an properly working on item descriptions when they are bloody
	var/f_name = "[src.name]."
	var/x_name = "a"
	var/obj/item/device/flashlight/FL = locate() in usr
	if (FL && FL.on && usr.stat != DEAD)
		FL.afterattack(src,usr)
	if(src.blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			x_name = "some "
		else
			x_name = "a "
		f_name += "<span class='combatglow'>blood-stained</span> <span class='uppertext'>[name]</span><span class='statustext'>!"
	if(!isobserver(usr))
		usr.visible_message("<span class='looksatbold'>[usr.name]</span> <span class='looksat'>looks at [src].</span>")
		if(get_dist(usr,src) > 5)//Don't get descriptions of things far away.
			to_chat(usr, "<span class='passivebold'>It's too far away to see clearly.</span>")
			return
	if(desc)
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			if(H.my_stats.it <= 5)
				var/randtext = pick("Yoh!","Doh!","Haha")
				to_chat(usr, "<span class='statustext'>That's [x_name] [f_name]</span>, [randtext]")
			else
				to_chat(usr, "<span class='statustext'>That's [x_name]</span> <span class='uppertext'>[f_name]</span>\n<span class='statustext'>[desc]</span>")
	else
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			if(H.my_stats.it <= 5)
				var/randtext = pick("Yoh!","Doh!","Haha")
				to_chat(usr, "<span class='statustext'>That's [x_name] [f_name]</span>, [randtext]")
			else
				to_chat(usr, "<span class='statustext'>That's [x_name]</span> <span class='uppertext'>[f_name]</span>")
 // tirei o icon e a caixa pq n tem isso no lwb :+1: -- izumi

/atom/proc/relaymove()
	return

/atom/proc/container_dir_changed(new_dir)
	return

/atom/proc/ex_act()
	return

/atom/proc/blob_act()
	return

/atom/proc/fire_act()
	return

/atom/proc/flame_act()
	return

/atom/proc/hitby(atom/movable/AM as mob|obj)
	return

/atom/proc/add_hiddenprint(mob/living/M as mob)
	if(isnull(M)) return
	if(isnull(M.key)) return
	if (!( src.flags ) & FPRINT)
		return
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if (!istype(H.dna, /datum/dna))
			return 0
		if (H.gloves)
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += text("\[[time_stamp()]\] (Wearing gloves). Real name: [], Key: []",H.real_name, H.key)
				src.fingerprintslast = H.key
			return 0
		if (!( src.fingerprints ))
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []",H.real_name, H.key)
				src.fingerprintslast = H.key
			return 1
	else
		if(src.fingerprintslast != M.key)
			src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []",M.real_name, M.key)
			src.fingerprintslast = M.key
	return

/atom/proc/add_fingerprint(mob/living/M as mob)
	if(isnull(M)) return
	if(isAI(M)) return
	if(isnull(M.key)) return
	if (!( src.flags ) & FPRINT)
		return
	if (ishuman(M))
		//Add the list if it does not exist.
		if(!fingerprintshidden)
			fingerprintshidden = list()

		//Fibers~
		add_fibers(M)

		//He has no prints!
		if (mFingerprints in M.mutations)
			if(fingerprintslast != M.key)
				fingerprintshidden += "(Has no fingerprints) Real name: [M.real_name], Key: [M.key]"
				fingerprintslast = M.key
			return 0		//Now, lets get to the dirty work.
		//First, make sure their DNA makes sense.
		var/mob/living/carbon/human/H = M
		if (!istype(H.dna, /datum/dna) || !H.dna.uni_identity || (length(H.dna.uni_identity) != 32))
			if(!istype(H.dna, /datum/dna))
				H.dna = new /datum/dna(null)
				H.dna.real_name = H.real_name
		H.check_dna()

		//Now, deal with gloves.
		if (H.gloves && H.gloves != src)
			if(fingerprintslast != H.key)
				fingerprintshidden += text("\[[]\](Wearing gloves). Real name: [], Key: []",time_stamp(), H.real_name, H.key)
				fingerprintslast = H.key
			H.gloves.add_fingerprint(M)

		//Deal with gloves the pass finger/palm prints.
		if(H.gloves != src)
			if(prob(75) && istype(H.gloves, /obj/item/clothing/gloves/latex))
				return 0
			else if(H.gloves && !istype(H.gloves, /obj/item/clothing/gloves/latex))
				return 0

		//More adminstuffz
		if(fingerprintslast != H.key)
			fingerprintshidden += text("\[[]\]Real name: [], Key: []",time_stamp(), H.real_name, H.key)
			fingerprintslast = H.key

		//Make the list if it does not exist.
		if(!fingerprints)
			fingerprints = list()

		//Hash this shit.
		var/full_print = md5(H.dna.uni_identity)

		// Add the fingerprints
		fingerprints[full_print] = full_print

		return 1
	else
		//Smudge up dem prints some
		if(fingerprintslast != M.key)
			fingerprintshidden += text("\[[]\]Real name: [], Key: []",time_stamp(), M.real_name, M.key)
			fingerprintslast = M.key

	//Cleaning up shit.
	if(fingerprints && !fingerprints.len)
		qdel(fingerprints)
	return


/atom/proc/transfer_fingerprints_to(var/atom/A)
	if(!istype(A.fingerprints,/list))
		A.fingerprints = list()
	if(!istype(A.fingerprintshidden,/list))
		A.fingerprintshidden = list()

	//skytodo
	//A.fingerprints |= fingerprints            //detective
	//A.fingerprintshidden |= fingerprintshidden    //admin
	if(fingerprints)
		A.fingerprints |= fingerprints.Copy()            //detective
	if(fingerprintshidden)
		A.fingerprintshidden |= fingerprintshidden.Copy()    //admin	A.fingerprintslast = fingerprintslast


//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/human/M as mob)
	if(flags & NOBLOODY) return 0
	.=1
	if (!( istype(M, /mob/living/carbon/human) ))
		return 0
	if (!istype(M.dna, /datum/dna))
		M.dna = new /datum/dna(null)
		M.dna.real_name = M.real_name
	M.check_dna()
	if (!( src.flags ) & FPRINT)
		return 0
	if(!blood_DNA || !istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()
	blood_color = "#A10808"
	if (M.species)
		blood_color = M.species.blood_color
	//adding blood to humans
	else if (istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		//if this blood isn't already in the list, add it
		if(blood_DNA[H.dna.unique_enzymes])
			return 0 //already bloodied with this blood. Cannot add more.
		blood_DNA[H.dna.unique_enzymes] = H.dna.b_type
		H.update_inv_gloves()	//handles bloody hands overlays and updating
		return 1 //we applied blood to the item
	return

/atom/proc/add_vomit_floor(mob/living/carbon/M as mob, var/toxvomit = 0)
	if( istype(src, /turf/simulated) )
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)

		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1,4)]"


/atom/proc/clean_blood()
	if(!simulated)
		return
	germ_level = 0
	blood_color = null
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return 1



/atom/proc/get_global_map_pos()
	if(!islist(global_map) || isemptylist(global_map)) return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x=1,cur_x<=global_map.len,cur_x++)
		y_arr = global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
//	world << "X = [cur_x]; Y = [cur_y]"
	if(cur_x && cur_y)
		return list("x"=cur_x,"y"=cur_y)
	else
		return 0

/atom/proc/checkpass(passflag)
	return pass_flags&passflag

/atom/proc/handle_fall()
	return

/atom/proc/CheckParts()
	return

/atom/proc/handle_slip()
	return
/atom/proc/set_dir(new_dir)
	if(ismob(src))
		var/mob/M = src

		for(var/obj/item/weapon/grab/G in M.grabbed_by)
			if(G.assailant == G.affecting)
				continue
			return


	var/old_dir = dir
	if(new_dir == old_dir)
		return FALSE
	dir = new_dir
	return TRUE

/atom/proc/kick_act(mob/living/carbon/human/user)
	if(istype(user.amulet, /obj/item/clothing/head/amulet/breaker))
		return
/*
	if(ismonster(src))
		to_chat(user, "TOO HEAVY")
		if(prob(20))
			to_chat(user, "<span class='danger'>OH SHIT! I LOST MY BALANCE!</span>")
			user.Weaken(1)
		return*/
	//They're not adjcent to us so we can't kick them. Can't kick in straightjacket or while being incapacitated (except lying), can't kick while legcuffed or while being locked in closet
	if(!Adjacent(user) || user.stat)
		return

	if(user.legcuffed)
		to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)] I'm stuck!</span>")
		return
	if(user.handcuffed)
		if(isliving(src))
			var/mob/living/L = src
			if(!L.lying)
				var/list/kickRollCuff = roll3d6(user,SKILL_UNARM,null)
				switch(kickRollCuff[GP_RESULT])
					if(GP_FAILED)
						user.visible_message("<span class='danger'>[user.name] loses \his balance while trying to kick \the [src].</span>", \
									"<span class='warning'> You lost your balance.</span>")
						user.Weaken(3)
						user.adjustStaminaLoss(rand(10,20))
						return
					if(GP_CRITFAIL)
						user.visible_message("<span class='danger'>[user.name] loses \his balance while trying to kick \the [src].</span>", \
									"<span class='warning'> You lost your balance.</span>")
						user.Weaken(6)
						user.adjustStaminaLoss(rand(30,40))
						return

	if(user.middle_click_intent == "kick")//We're in kick mode, we can kick.
		for(var/limbcheck in list(BP_L_LEG,BP_R_LEG))//But we need to see if we have legs.
			var/datum/organ/external/affecting = user.get_organ(limbcheck)
			if(affecting.status & ORGAN_DESTROYED)//Oh shit, we don't have have any legs, we can't kick.
				return 0

		user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
		return 1 //We do have legs now though, so we can kick.

/atom/proc/bite_act(mob/living/carbon/human/user)
	//They're not adjcent to us so we can't kick them. Can't kick in straightjacket or while being incapacitated (except lying), can't kick while legcuffed or while being locked in closet
	if(istype(user.amulet, /obj/item/clothing/head/amulet/breaker))
		return
	if(!Adjacent(user) || user.stat)
		return
	if(user.middle_click_intent == "bite")//We're in kick mode, we can kick.
		user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
		return 1 //We do have legs now though, so we can kick.

/atom/proc/steal_act(mob/living/carbon/human/user)
	if(!Adjacent(user) || user.stat)
		return
	if(user.middle_click_intent == "steal")
		user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
		return 1

/atom/proc/jump_act(atom/target, mob/living/carbon/human/user)
	//No jumping on the ground dummy && No jumping in space && No jumping in straightjacket or while being incapacitated (except handcuffs) && No jumping vhile being legcuffed or locked in closet

	if(user.clinged_turf)
		user.clinged_turf = null

	if(user.stat)
		return

	if(user.resting)
		return

	if(user.sleeping)
		return

	if(!user.canmove)
		return

	if(user.grabbed_by.len)
		for(var/x = 1; x <= user.grabbed_by.len; x++)
			if(user.grabbed_by[x])
				return
		/*
		if(istype(user.grabbed_by[1], /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = user.grabbed_by[1]

			if(ishuman(G?.assailant))
				var/mob/living/carbon/human/H = G.assailant

				var/baseProb = 25

				var/diff = H.my_stats.st - user.my_stats.st
				var/parsedDiff = diff * -1
				if(diff < 0)
					for(var/x = 0; x != parsedDiff; x++)
						baseProb += 5
				else
					for(var/x = 0; x != parsedDiff; x++)
						baseProb -= 5

				if(!prob(baseProb))
					return
		*/

	for(var/limbcheck in list(BP_L_LEG,BP_R_LEG))//But we need to see if we have legs.
		var/datum/organ/external/affecting = user.get_organ(limbcheck)
		if(affecting.status & ORGAN_DESTROYED)//Oh shit, we don't have have any legs, we can't jump.
			return

	//Nice, we can jump, let's do that then.
//	playsound(user, "sound/effects/jump_[user.gender == MALE ? "male" : "female"].ogg", 25)
	var/jump_safe = get_dist(user, target)
	if(user.species.name == "Zombie")
		playsound(user, pick('zombie_lounge.ogg','zombie_lounge2.ogg','zombie_lounge3.ogg','zombie_lounge4.ogg'), 25)
		user.canmove = 0
		spawn(10)
			user.canmove = 1
	if(user.species.name == "Alien")
		playsound(user, pick('alien_jump.ogg'), 50)
	else
		if(!april_fools)
			if(user.acrobat)
				if(user.gender == MALE)
					playsound(user, pick('sound/voice/trick1.ogg','sound/voice/trick2.ogg','sound/voice/trick3.ogg'), 80, 0, -5)
				else
					playsound(user, pick('sound/voice/trickf1.ogg','sound/voice/trickf2.ogg'), 80, 0, -5)
			else
				if(!ismonster(user))
					if(user.gender == MALE)
						playsound(user, 'sound/effects/jump_male.ogg', 100, 0, -5)
					else
						playsound(user, 'sound/effects/jump_female.ogg', 100, 0, -5)
		else
			playsound(user, 'worms_jump.ogg', 25)
			user.say("Hop!")
	user.jumping = TRUE
	user.sound2()
	if(user.acrobat)
		user.visible_message("<span class='graytextbold'>[user]</span> <span class='graytext'>shows a trick!</span>")

	else
		user.visible_message("<span class='graytextbold'>[user]</span> <span class='graytext'>jumps at the</span> <span class='graytextbold'>[target]</span><span class='graytext'>!</span>")

	if(user.species.name == "Midget" || user.species.name == "Child" || user.check_perk(/datum/perk/ref/jumper))
		user.adjustStaminaLoss(rand(10,20))
	else
		user.adjustStaminaLoss(rand(10,20))//Jumping is exhausting.

	var/list/rolled = roll3d6(user,SKILL_CLIMB,null)
	switch(rolled[GP_RESULT])
		if(GP_CRITFAIL)
			user.visible_message("<span class='crithit'>CRITICAL FAILURE!</span> <span class='hitbold'><b>[user]</b></span><span class='hit'> fails to jump!</span>")
			user.throw_at(target, 1, 0.5, user)
			user.adjustStaminaLoss(rand(5,10))
			user:weakened = max(user:weakened,4)
	if(user.carryingweight >= user.maxweight)
		if(user.my_stats.dx >= rand(13,15))
			user.throw_at(target, 2, 0.5, user)
			user.adjustStaminaLoss(rand(10,20))
			user:weakened = max(user:weakened,3)
			to_chat(user, "TOO HEAVY!")
		else
			user.throw_at(target, 1, 0.5, user)
			user.adjustStaminaLoss(rand(18,30))
			user:weakened = max(user:weakened,4)
			to_chat(user, "TOO HEAVY!")
	else
		if(user.my_stats.dx >= 20 || user.check_perk(/datum/perk/ref/jumper) || user.acrobat)
			if(user.acrobat)
				user.FusRoDah(5)
				user.throw_at(target, 4, 0.5, user)
			else
				user.throw_at(target, 5, 0.5, user)
		else
			user.throw_at(target, 2, 0.5, user)
	if(FAT in user.mutations)
		user.adjustStaminaLoss(rand(8,12))
	user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
	spawn(jump_safe)	user.jumping = FALSE

/obj/screen/text/atm

var/list/fonts = list('gothic.ttf', 'hando.ttf', 'type.ttf')

/client/MouseEntered(var/atom/a)
	if(mob && ishuman(mob))
		var/mob/living/carbon/human/H = mob
		if(H.combat_mode && H.facing_dir && H.follow_mouse)
			var/direction
			var/dx = a.x - mob.x
			var/dy = a.y - mob.y
			if(!dx && !dy) return

			if(abs(dx) < abs(dy))
				if(dy > 0)	direction = NORTH
				else		direction = SOUTH
			else
				if(dx > 0)	direction = EAST
				else		direction = WEST
			if(direction)
				H.facedir(direction)
				H.facing_dir = direction
		var/colorofText = "#999897"
		if(istype(a, /turf))
			colorofText = "#999897"
		if(istype(a, /obj))
			colorofText = "#b5b3b1"
		if(istype(a, /obj/item))
			colorofText = "#c9c7c5"
		if(istype(a, /mob/living))
			colorofText = "#04c918"
		if(a.mouse_opacity)  // i spread this out to make it more "readable"
			H.hovertext.maptext = "<center><br><br><br><span style=\"\
			color: [colorofText]; \
			\"><font face='Deutsch Gothic'>[a.name]\
			</font></span></center>"
		else
			H.hovertext.maptext = ""  // ui is blank, sad!

/atom/movable/proc/dropInto(var/atom/destination)
	while(istype(destination))
		var/atom/drop_destination = destination.onDropInto(src)
		if(!istype(drop_destination) || drop_destination == destination)
			return forceMove(destination)
		destination = drop_destination
	return forceMove(null)

/atom/proc/onDropInto(var/atom/movable/AM)
	return // If onDropInto returns null, then dropInto will forceMove AM into us.

/atom/movable/onDropInto(var/atom/movable/AM)
	return loc // If onDropInto returns something, then dropInto will attempt to drop AM there.

/atom/proc/fakesay(var/text = "", var/hex = "#add8e6", var/say_verb = "says")
	var/image/objchatimage = image('icons/mob/talk.dmi', src, "h2", layer)
	overlays += objchatimage

	visible_message("<span><span class='saybasic'><b style='color: [hex]'>[name]</b></span> <span class='sayverb'>[say_verb], </span>\"<span class='saybasic'>[text]</span></span>\"")
	spawn(15)
		overlays -= objchatimage

/obj/acid_act()
	..()
	spawn(rand(30,40))
		playsound(src.loc, pick('sound/webbers/acid1.ogg', 'sound/webbers/acid2.ogg', 'sound/webbers/acid3.ogg'), 100, 0)
		spawn(rand(30, 40))
			playsound(src.loc, pick('sound/webbers/acid1.ogg', 'sound/webbers/acid2.ogg', 'sound/webbers/acid3.ogg'), 100, 0)
			spawn(rand(30, 40))
				playsound(src.loc, pick('sound/webbers/acid1.ogg', 'sound/webbers/acid2.ogg', 'sound/webbers/acid3.ogg'), 100, 0)
				new/obj/item/ash(src.loc)
				qdel(src)

/obj/item/ash/acid_act()
	return

/obj/effect/decal/acid_act()
	return

/obj/effect/decal/acid_act()
	return

/obj/structure/stool/bed/chair/altar/acid_act()
	return

/obj/structure/stool/bed/chair/ThroneMid/acid_act()
	return

/obj/machinery/charon/acid_act()
	return

/obj/item/clothing/head/caphat/acid_act()
	return

/obj/structure/door_protect/acid_act()
	return

/obj/machinery/computer/supplycomp/acid_act()
	return

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/acid_act()
	return

/obj/structure/sign/signnew/web/church/sunofeternalnight/acid_act()
	return

/obj/multiz/stairs/acid_act()
	return

/obj/effect/regurgitator/acid_act()
	return

/obj/item/weapon/flame/candle/tnt/bundle/acid_act()
	explosion(src.loc, 2, 4, 6, 4)
	qdel(src)
	return

/obj/item/weapon/flame/candle/tnt/acid_act()
	explosion(src.loc, 1, 2, 2, 2)
	qdel(src)
	return

/obj/item/weapon/cell/crap/acid_act()
	explosion(src.loc, 1, 1, 1, 1)
	qdel(src)
	return

/obj/item/weapon/gun/energy/taser/leet/flame_act()
	explosion(src.loc, 1, 1, 1, 1)
	qdel(src)
	return


/obj/item/weapon/flame/candle/tnt/bundle/flame_act()
	explosion(src.loc, 2, 4, 6, 4)
	qdel(src)
	return

/obj/item/weapon/flame/candle/tnt/flame_act()
	explosion(src.loc, 1, 2, 2, 2)
	qdel(src)
	return

/obj/item/weapon/cell/crap/flame_act()
	explosion(src.loc, 1, 1, 1, 1)
	qdel(src)
	return

/obj/item/weapon/gun/energy/taser/leet/flame_act()
	explosion(src.loc, 1, 1, 1, 1)
	qdel(src)
	return



/obj/machinery/computerVendor/acid_act()
	for(var/obj/AA in src.contents)
		AA.loc = src.loc
		src.contents -= AA
	return

/obj/structure/lifeweb/statue/acid_act()
	new/obj/item/weapon/stone(src.loc)
	new/obj/item/weapon/stone(src.loc)
	new/obj/item/weapon/stone(src.loc)
	return

/obj/machinery/nuclearbomb/acid_act()
	return

/obj/item/weapon/disk/nuclear/acid_act()
	return

/obj/machinery/chem_master/holy_altar/acid_act()
	playsound(src.loc, 'sound/misc/altar.ogg', 100, 1)
	var/obj/machinery/light/L = locate(/obj/machinery/light) in view(7, src)
	if(L)
		L.flicker()
	return

/obj/machinery/door/airlock/orbital/gates/magma/trap_door/acid_act()

/atom/proc/acid_act()
	var/icon/I = new /icon(icon, icon_state)
	I.Blend(new /icon('icons/effects/effects.dmi', rgb(255,255,255)),ICON_ADD) //fills the icon_state with white (except where it's transparent)
	I.Blend(new /icon('icons/effects/effects.dmi', "acid"),ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
	var/image/imagem = image(I)
	overlays += imagem
	playsound(src.loc, pick('sound/webbers/acid1.ogg', 'sound/webbers/acid2.ogg', 'sound/webbers/acid3.ogg'), 100, 0)
	return
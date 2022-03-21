/mob/living/carbon/human
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "body_m_s"
	var/list/hud_list = list()
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE|LONG_GLIDE
//	var/datum/species/species //Contains icon generation and language information, set during New().
	var/outsider = 0
	var/royalty = 0
	var/mini_war = FALSE  // Var only for mini war
	var/embedded_flag	  //To check if we've need to roll for damage on movement while an item is imbedded in us.
	var/futa = FALSE
	plane = 10
	flammable = 1
	countsDensity = 0

/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

/mob/living/carbon/human/skrell/New()
	h_style = "Skrell Male Tentacles"
	set_species("Skrell")
	..()

/mob/living/carbon/human/tajaran/New()
	h_style = "Tajaran Ears"
	set_species("Tajaran")
	..()

/mob/living/carbon/human/unathi/New()
	h_style = "Unathi Horns"
	set_species("Unathi")
	..()

/mob/living/carbon/human/unathi/New()
	h_style = "blue IPC screen"
	set_species("Machine")
	..()

/mob/living/carbon/human/vox/New()
	h_style = "Short Vox Quills"
	set_species("Vox")
	..()

/mob/living/carbon/human/diona/New()
	set_species("Diona")
	..()

/mob/living/carbon/human/machine/New()
	set_species("Machine")
	..()

/mob/living/carbon/human/proc/microbomb_soulbreaker()
	to_chat(src, "<b>you have a microexplosive in your head, you have 10 minutes to complete your mission.</b>")
	spawn(25 MINUTES)
		for(var/obj/machinery/computer/sellbreaker/S in world)
			if(!S.allpointsgathered)
				if(src.stat != DEAD)
					if(src.client)
						src.client.ChromieWinorLoose(src.client, -1)
					visible_message("<span class='bname'>[src]</span> lets out a beep as \his microexplosive goes off!")
					playsound(src, 'newBuzzer.ogg', 100, 1, 1)
					explosion(src.loc,2,4,6,4)

/mob/living/carbon/human/New(var/new_loc, var/new_species = null)
	combat_music = 'ravenheart_combat1.ogg'
	disguise_number = rand(1,length(player_list))
	if(!dna)
		dna = new /datum/dna(null)
		// Species name is handled by set_species()

	if(!species)
		if(new_species)
			set_species(new_species)
		else
			set_species()

	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src
	//src.client.color = null

	if(!dna)
		dna = new /datum/dna(null)

	for(var/i=0;i<8;i++) // 2 for medHUDs and 5 for secHUDs
		hud_list += image('icons/mob/hud.dmi', src, "hudunknown")

	..()

	if(dna)
		dna.real_name = real_name

	prev_gender = gender // Debug for plural genders
	make_blood()
	bladder = rand(0,100)
	bowels = rand(0, 100)
	potenzia = roll("3d6+5")
	resistenza = (prob(80) ? rand(150, 300) : pick(rand(10, 100), rand(350,600)))
	init_skills()
	init_stats()
	add_teeth()
	bodyhair()
	create_pain_threshold()
	add_fingers()
	add_nose_ears()
	if(gender == FEMALE && f_style)
		f_style = NULL
		regenerate_icons()
	if(key)
		old_key = src?.client?.key

/mob/living/carbon/human/Bump(atom/movable/AM as mob|obj, yes)
	if ((!( yes ) || now_pushing))
		return
	now_pushing = 1
	if (ismob(AM))
		var/mob/tmob = AM
		if(ishuman(tmob))
			var/mob/living/carbon/human/H = tmob
			if(H.isLeaning)
				loc = H.loc
				now_pushing = 0
				return
		if( istype(tmob, /mob/living/carbon) && prob(10) )
			src.spread_disease_to(AM, "Contact")
//BubbleWrap - Should stop you pushing a restrained person out of the way

		if(istype(tmob, /mob/living/carbon/human))

			for(var/mob/M in range(tmob, 1))
				if(tmob.pinned.len ||  ((M.pulling == tmob && ( tmob.restrained() && !( M.restrained() ) && M.stat == 0)) || locate(/obj/item/weapon/grab, tmob.grabbed_by.len)) )
					if ( !(world.time % 5) )
						to_chat(src, "[tmob] is restrained, you cannot push past")
					now_pushing = 0
					return
				if( tmob.pulling == M && ( M.restrained() && !( tmob.restrained() ) && tmob.stat == 0) )
					if ( !(world.time % 5) )
						to_chat(src, "[tmob] is restraining [M], you cannot push past")
					now_pushing = 0
					return

		//BubbleWrap: people in handcuffs are always switched around as if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
		//if((tmob.a_intent == "help" || tmob.restrained()) && (a_intent == "help" || src.restrained()) && tmob.canmove && canmove) // mutual brohugs all around!
		if(tmob.restrained() || src.restrained())
			//var/turf/oldloc = loc
			//loc = tmob.loc
			//tmob.loc = oldloc
			now_pushing = 0
			return
		if(ishuman(AM))
			var/mob/living/carbon/human/humanmob = AM
			if(statcheck(humanmob?.my_stats.st, 9, null, tmob))
				if(humanmob.combat_mode)
					if(prob(70+humanmob.my_stats.st))
						visible_message("<span class='bname'>[src]</span> tries to push <span class='bname'>[AM]</span>")
						now_pushing = 0
						return
				else
					if(prob(25))
						visible_message("<span class='bname'>[src]</span> tries to push <span class='bname'>[AM]</span>")
						now_pushing = 0
						return

		if(istype(tmob, /mob/living/carbon/human) && (FAT in tmob.mutations))
			if(prob(40) && !(FAT in src.mutations))
				src << "\red <B>You fail to push [tmob]'s fat ass out of the way.</B>"
				now_pushing = 0
				return
		if(tmob.r_hand && istype(tmob.r_hand, /obj/item/weapon/shield/riot))
			if(prob(99))
				now_pushing = 0
				return
		if(tmob.l_hand && istype(tmob.l_hand, /obj/item/weapon/shield/riot))
			if(prob(99))
				now_pushing = 0
				return
		if(!(tmob.status_flags & CANPUSH))
			now_pushing = 0
			return

		tmob.LAssailant = src

	else
		now_pushing = 0

	spawn(0)
		..()
		if (!istype(AM, /atom/movable))
			return
		if (!AM.anchored)
			var/t = get_dir(src, AM)
			if (istype(AM, /obj/structure/window))
				if(AM:ini_dir == NORTHWEST || AM:ini_dir == NORTHEAST || AM:ini_dir == SOUTHWEST || AM:ini_dir == SOUTHEAST)
					for(var/obj/structure/window/win in get_step(AM,t))
						now_pushing = 0
						return
			step(AM, t)
		now_pushing = 0
		return
	return

/mob/living/carbon/human/ex_act(severity)
	CU()
	film_grain2?.blend_mode = 3
	film_grain2?.alpha = 255
	spawn(400)
		film_grain2?.blend_mode = 4
		film_grain2?.alpha = 190

	make_dizzy(600)

	var/shielded = 0
	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			b_loss += 500
			if (!prob(getarmor(null, "bomb")))
				gib()
				return
			else
				var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(target, 200, 4)
			//return
//				var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
				//user.throw_at(target, 200, 4)

		if (2.0)
			if (!shielded)
				b_loss += 60

			b_loss += 60

			for(var/datum/organ/external/E in organs)
				if(prob(150-src.my_stats.ht*10))
					E.fracture()

			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/1.5
				f_loss = f_loss/1.5

			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 30
				ear_deaf += 120
			if (prob(70) && !shielded)
				Paralyse(10)

		if(3.0)
			b_loss += 30
			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/2
			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 15
				ear_deaf += 60
			if (prob(50) && !shielded)
				Paralyse(10)
			for(var/datum/organ/external/E in organs)
				if(prob(110-src.my_stats.ht*10))
					E.fracture()

	var/update = 0

	// focus most of the blast on one organ
	var/datum/organ/external/take_blast = pick(organs)
	update |= take_blast.take_damage(b_loss * 0.9, f_loss * 0.9, used_weapon = "Explosive blast")

	// distribute the remaining 10% on all limbs equally
	b_loss *= 0.1
	f_loss *= 0.1

	var/weapon_message = "Explosive Blast"

	for(var/datum/organ/external/temp in organs)
		switch(temp.name)
			if("head")
				update |= temp.take_damage(b_loss * 0.2, used_weapon = weapon_message)
			if("mouth")
				update |= temp.take_damage(b_loss * 0.3, used_weapon = weapon_message)
			if("face")
				update |= temp.take_damage(b_loss * 0.4, used_weapon = weapon_message)
			if("vitals")
				update |= temp.take_damage(b_loss * 0.4, used_weapon = weapon_message)
			if("chest")
				update |= temp.take_damage(b_loss * 0.4, used_weapon = weapon_message)
			if("l_arm")
				update |= temp.take_damage(b_loss * 0.05, used_weapon = weapon_message)
			if("r_arm")
				update |= temp.take_damage(b_loss * 0.05, used_weapon = weapon_message)
			if("l_leg")
				update |= temp.take_damage(b_loss * 0.05, used_weapon = weapon_message)
			if("r_leg")
				update |= temp.take_damage(b_loss * 0.05, used_weapon = weapon_message)
			if("r_foot")
				update |= temp.take_damage(b_loss * 0.05, used_weapon = weapon_message)
			if("l_foot")
				update |= temp.take_damage(b_loss * 0.05, used_weapon = weapon_message)
			if("r_arm")
				update |= temp.take_damage(b_loss * 0.05, used_weapon = weapon_message)
			if("l_arm")
				update |= temp.take_damage(b_loss * 0.05, used_weapon = weapon_message)
	if(update)	UpdateDamageIcon()


/mob/living/carbon/human/blob_act()
	if(stat == 2)	return
	show_message("\red The blob attacks you!")
	var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
	var/datum/organ/external/affecting = get_organ(ran_zone(dam_zone))
	apply_damage(rand(30,40), BRUTE, affecting, run_armor_check(affecting, "melee"))
	return

/mob/living/carbon/human/meteorhit(O as obj)
	for(var/mob/M in viewers(src, null))
		if ((M.client && !( M.blinded )))
			M.show_message("\red [src] has been hit by [O]", 1)
	if (health > 0)
		var/datum/organ/external/affecting = get_organ(pick("chest", "chest", "chest", "head"))
		if(!affecting)	return
		if (istype(O, /obj/effect/immovablerod))
			if(affecting.take_damage(101, 0))
				UpdateDamageIcon()
		updatehealth()
	return


/mob/living/carbon/human/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		if(attempt_dodge(src, M) && src.c_intent == "dodge" && canmove && !src.sleeping && src.stat == 0)
			do_dodge()
			return
		if(attempt_parry(src, M) && src.c_intent == "parry" && !src.sleeping  && canmove && src.stat == 0)
			do_parry(src, M)
			return
		for(var/mob/O in viewers(src, null))
			O.show_message("<span class='hitbold'>[M]</span> <span class='hit'>[M.attacktext]</span> <span class='hitbold'>[src]</span><span class='hit'>!</span>", 1)
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/datum/organ/external/affecting = get_organ(ran_zone(dam_zone))
		var/armor = run_armor_check(affecting, "melee", M.deals_blunt)
		apply_damage(damage, BRUTE, affecting, armor)
		if(armor >= 2)	return


/mob/living/carbon/human/proc/is_loyalty_implanted(mob/living/carbon/human/M)
	for(var/L in M.contents)
		if(istype(L, /obj/item/weapon/implant/loyalty))
			for(var/datum/organ/external/O in M.organs)
				if(L in O.implants)
					return 1
	return 0

/mob/living/carbon/human/proc/is_mentor_implanted(mob/living/carbon/human/M)
	for(var/L in M.contents)
		if(istype(L, /obj/item/weapon/implant/mentor))
			for(var/datum/organ/external/O in M.organs)
				if(L in O.implants)
					return 1
	return 0

/mob/living/carbon/human/restrained()
	if (handcuffed)
		return 1
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0



/mob/living/carbon/human/var/co2overloadtime = null
/mob/living/carbon/human/var/temperature_resistance = T0C+75


/mob/living/carbon/human/show_inv(mob/user as mob)
	if(istype(src, /mob/living/carbon/human/monster))
		return
	user.set_machine(src)
	var/dat = {"<META http-equiv="X-UA-Compatible" content="IE=edge" charset="UTF-8"> <Title>Inventory</title> <style type="text/css"> body {font-family: Times; cursor: url('http://lfwb.ru/Icons/pointer.cur'), auto;} a {text-decoration:none;outline: none;border: none;margin:-1px;} a:focus{outline:none;} a:hover {color:#0d0d0d;background:#505055;outline: none;border: none;} a.active { text-decoration:none; color:#533333;} a.inactive:hover {color:#0d0d0d;background:#bb0000} a.active:hover {color:#bb0000;background:#0f0f0f} a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style> <body background bgColor=#0d0d0d text=#862525 alink=#777777 vlink=#777777 link=#777777>
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Mask:</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "<small>Nothing</small>")]</A>
	<BR><B>Neck:</B> <A href='?src=\ref[src];item=amulet'>[(amulet ? amulet : "<small>Nothing</small>")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "<small>Nothing</small>")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "<small>Nothing</small>")]</A>
	<BR><B>Gloves:</B> <A href='?src=\ref[src];item=gloves'>[(gloves ? gloves : "<small>Nothing</small>")]</A>
	<BR><B>Glasses:</B> <A href='?src=\ref[src];item=eyes'>[(glasses ? glasses : "<small>Nothing</small>")]</A>
	<BR><B>Left Ear:</B> <A href='?src=\ref[src];item=l_ear'>[(l_ear ? l_ear : "<small>Nothing</small>")]</A>
	<BR><B>Right Ear:</B> <A href='?src=\ref[src];item=r_ear'>[(r_ear ? r_ear : "<small>Nothing</small>")]</A>
	<BR><B>Helmet:</B> <A href='?src=\ref[src];item=head'>[(head ? head : "<small>Nothing</small>")]</A>
	<BR><B>Boots:</B> <A href='?src=\ref[src];item=shoes'>[(shoes ? shoes : "<small>Nothing</small>")]</A>
	<BR><B>Belt:</B> <A href='?src=\ref[src];item=belt'>[(belt ? belt : "<small>Nothing</small>")]</A>
	<BR><B>Clothes:</B> <A href='?src=\ref[src];item=uniform'>[(w_uniform ? w_uniform : "<small>Nothing</small>")]</A>
	<BR><B>(Exo)Suit:</B> <A href='?src=\ref[src];item=suit'>[(wear_suit ? wear_suit : "<small>Nothing</small>")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "<small>Nothing</small>")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR><B>Back II:</B> <A href='?src=\ref[src];item=back2'>[(back2 ? back2 : "<small>Nothing</small>")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR><B>ID:</B> <A href='?src=\ref[src];item=id'>[(wear_id ? wear_id : "<small>Nothing</small>")]</A>
	<BR><B>Suit Storage:</B> <A href='?src=\ref[src];item=s_store'>[(s_store ? s_store : "<small>Nothing</small>")]</A>
	<BR><B>Left Wrist:</B> <A href='?src=\ref[src];item=wrist_l'>[(wrist_l ? wrist_l : "<small>Nothing</small>")]</A>
	<BR><B>Right Wrist:</B> <A href='?src=\ref[src];item=wrist_r'>[(wrist_r ? wrist_r : "<small>Nothing</small>")]</A>
	<BR>[(handcuffed ? text("<A href='?src=\ref[src];item=handcuff'>Handcuffed</A>") : text("<A href='?src=\ref[src];item=handcuff'>Not Handcuffed</A>"))]
	<BR>[(legcuffed ? text("<A href='?src=\ref[src];item=legcuff'>Legcuffed</A>") : text(""))]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=splints'>Remove Splints</A>
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=Inventory;size=340x480;border=1;"))
	onclose(user, "Inventory")
	return

// called when something steps onto a human
// this could be made more general, but for now just handle mulebot
/mob/living/carbon/human/Crossed(var/atom/movable/AM)
	var/obj/machinery/bot/mulebot/MB = AM
	if(istype(MB))
		MB.RunOver(src)

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(var/if_no_id = "", var/if_no_job = "")
	var/obj/item/device/pda/pda = wear_id
	var/obj/item/weapon/card/id/id = wear_id
	if(istype(wear_id, /obj/item/device/pda))
		if (pda.id && istype(pda.id, /obj/item/weapon/card/id))
			. = pda.id.assignment
		else
			. = pda.ownjob
	else if (istype(wear_id, /obj/item/weapon/card/id))
		. = id.assignment
	else
		return if_no_id
	if (!.)
		. = if_no_job
	return

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(var/if_no_id = "Unknown")
	var/obj/item/device/pda/pda = wear_id
	var/obj/item/weapon/card/id/id = wear_id
	if (istype(pda))
		if (pda.id)
			. = pda.id.registered_name
		else
			. = pda.owner
	else if (istype(id))
		. = id.registered_name
	else
		return if_no_id
	return

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
	if(istype(src.wear_id,/obj/item/stolen))
		return
	var/obj/item/weapon/card/id/idcard = src.wear_id
	if( wear_mask && (wear_mask.flags_inv&HIDEFACE) )	//Wearing a mask which hides our face, use id-name if possible
		if(wear_id)
			return "[idcard.assignment]"
		else
			return get_id_name("Unknown")
	if( head && (head.flags_inv&HIDEFACE) )
		if(wear_id)
			return "[idcard.assignment]"
		else
			return get_id_name("Unknown")
	if(stealth || brothelstealth)
		return get_id_name("R a t")		//MODO STEALTH
	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if(nickname && face_name != "Unknown")
		var/regex/R = regex("(^\\S+) (.*$)") //Get all words (\w+) that have an end of line ($).  Should pick off last names
		R.Find(face_name)
		var/FName
		var/SName
		FName = R.group[1]
		SName = R.group[2]
		face_name = "[FName] \'[nickname]\' [SName]"
	if(id_name && (id_name != face_name))
		return "[face_name]"
	return face_name

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when polyacided or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name()
	var/datum/organ/external/face/F = get_organ("face")
	if( !F || F.disfigured || (F.status & ORGAN_DESTROYED) || !real_name || (HUSK in mutations) )	//disfigured. use id-name if possible
		return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(var/if_no_id = "Unknown")
	. = if_no_id
	if(istype(wear_id,/obj/item/device/pda))
		var/obj/item/device/pda/P = wear_id
		return P.owner
	if(wear_id)
		var/obj/item/weapon/card/id/I = wear_id.GetID()
		if(I)
			return I.registered_name
	return

//gets ID card object from special clothes slot or null.
/mob/living/carbon/human/proc/get_idcard()
	if(wear_id)
		return wear_id.GetID()

//Added a safety check in case you want to shock a human mob directly through electrocute_act.
/mob/living/carbon/human/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/safety = 0, var/faisca = FALSE)

	if(faisca)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		Jitter(10)

	if(!safety)
		if(gloves)
			var/obj/item/clothing/gloves/G = gloves
			siemens_coeff = G.siemens_coefficient
	return ..(shock_damage,source,siemens_coeff)


/mob/living/carbon/human/Topic(href, href_list)
	if (href_list["refresh"])
		if((machine)&&(in_range(src, usr)))
			show_inv(machine)

	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)

	if ((href_list["item"] && !( usr.stat ) && usr.canmove && !( usr.restrained() ) && in_range(src, usr) && ticker)) //if game hasn't started, can't make an equip_e
		var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
		O.source = usr
		O.target = src
		O.item = usr.get_active_hand()
		O.s_loc = usr.loc
		O.t_loc = loc
		O.place = href_list["item"]
		requests += O
		spawn( 0 )
			O.process()
			return

	if (href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		I.examine()

	if (href_list["lookmob"])
		var/mob/M = locate(href_list["lookmob"])
		M.examine()
/*
	if (href_list["flavor_change"])
		switch(href_list["flavor_change"])
			if("done")
				src << browse(null, "window=flavor_changes")
				return
			if("general")
				var/msg = rhtml_encode_paper(input(usr,"Update the general description of your character. This will be shown regardless of clothing, and may include OOC notes and preferences.","Flavor Text",rhtml_decode_paper(flavor_texts[href_list["flavor_change"]])) as message)
				if(msg != null)
					msg = sanitize(copytext(msg, 1, MAX_MESSAGE_LEN))
					msg = rhtml_encode_paper(msg)
				flavor_texts[href_list["flavor_change"]] = msg
				return
			else
				var/msg = rhtml_encode_paper(input(usr,"Update the flavor text for your [href_list["flavor_change"]].","Flavor Text",sanitize_uni(rhtml_decode_paper(flavor_texts[href_list["flavor_change"]]))) as message)
				if(msg != null)
					msg = sanitize(copytext(msg, 1, MAX_MESSAGE_LEN))
					msg = rhtml_encode_paper(msg)
				flavor_texts[href_list["flavor_change"]] = msg
				set_flavor()
				return
*/

	///////Interactions!!///////
	if(href_list["interaction"])

		if (usr.stat == DEAD || usr.stat == UNCONSCIOUS || usr.restrained())
			return

		//CONDITIONS
		var/mob/living/carbon/human/H = usr
		var/mob/living/carbon/human/P = H.partner
		if (!(P in view(H.loc)))
			return
		var/datum/organ/external/temp = H.organs_by_name["r_hand"]
		var/hashands = (temp && temp.is_usable())
		if (!hashands)
			temp = H.organs_by_name["l_hand"]
			hashands = (temp && temp.is_usable())
		temp = P.organs_by_name["r_hand"]
		var/hashands_p = (temp && temp.is_usable())
		if (!hashands_p)
			temp = P.organs_by_name["l_hand"]
			hashands = (temp && temp.is_usable())
		temp = H.organs_by_name["head"]
		var/mouthfree = !(H.wear_mask && temp)
		temp = P.organs_by_name["head"]
		var/mouthfree_p = !(P.wear_mask && temp)
		var/haspenis = H.has_penis()//(src.client.ckey in futa) || H.has_penis()//(H.gender == MALE && H.potenzia > -1 && H.species.genitals))
		var/haspenis_p = P.has_penis()//(src.client.ckey in futa) || P.has_penis()//(H.gender == MALE && H.potenzia > -1 && H.species.genitals))
		var/hasvagina = (H.gender == FEMALE && H.species.genitals && !H.has_penis() && !H.isFemboy())
		var/hasvagina_p = (P.gender == FEMALE && P.species.genitals && !P.has_penis() && !P.isFemboy())
		var/hasanus_p = P.species.anus
		var/isnude = H.is_nude()
		var/isnude_p = P.is_nude()
		var/ya = "&#1103;"


		if (href_list["interaction"] == "bow")
			H.visible_message("<span class='examinebold'>[H]</span> <span class='examine'>bows before</span> <span class='examinebold'>[P].</span>")
			if (istype(P.loc, /obj/structure/closet) && P.loc == H.loc)
				P.visible_message("<span class='examinebold'>[H]</span> <span class='examine'>bows before</span> <span class='examinebold'>[P].</span>")


		else if (href_list["interaction"] == "pet")
			if(((!istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<span class='passivebold'>[H]</span> <span class='passive'>[pick("pets", "pats")]</span> <span class='passivebold'>[P].</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='passivebold'>[H]</span> <span class='passive'>[pick("pets", "pats")]</span> <span class='passivebold'>[P].</span>")

		else if (href_list["interaction"] == "give")
			if(Adjacent(P))
				if (((!istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
					H.give(P)

		else if (href_list["interaction"] == "kiss")
			if( ((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && mouthfree && mouthfree_p  && (H.species.flags & HAS_LIPS) && (P.species.flags & HAS_LIPS))
				if(H.wear_mask && H.wear_mask.flags & MASKCOVERSMOUTH)
					to_chat(H, "<span class='combat'>[pick(nao_consigoen)] my mask is in the way!</span>")
					return
				if (H.lust == 0)
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>kisses</span> <span class='erpbold'>[P]</span>")
					if (istype(P.loc, /obj/structure/closet))
						P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>kisses</span> <span class='erpbold'>[P]</span>")
					if (H.lust < 5)
						H.lust = 5
				else
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>kisses</span> <span class='erpbold'>[P]</span>")
				if(H?.mind?.succubus)
					if(!P.check_event(H.real_name))
						to_chat(P, "<span class='horriblestate' style='font-size: 200%;'><b><i>I NEED TO FUCK [H]!</i></b></span>")
						P.my_stats.st -= 3
						P.my_stats.dx -= 3
					H.succubus_mood(P)
				if(H.gender == FEMALE)
					if(P.gender == MALE || P.gender == FEMALE && P.has_penis() || P.isFemboy())
						if(P.vice == "Addict (Kisses)")
							P.clear_event("vice")
							P.viceneed = 0
				if(H.has_penis())
					if(P.gender == FEMALE)
						if(P.vice == "Addict (Kisses)")
							P.clear_event("vice")
							P.viceneed = 0
				var/sound_path
				switch(H.lust)
					if(0 to 20)
						sound_path = "honk/sound/new/ACTIONS/MOUTH/KISS/"
					if(20 to INFINITY)
						sound_path = "honk/sound/new/ACTIONS/MOUTH/FRENCH_KISS/"
				var/sound = pick(flist("[sound_path]"))
				playsound(loc, "[sound_path][sound]", 50, 1, -1)
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>kisses</span> <span class='erpbold'>[P]</span>")
			else if (mouthfree)
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>blows</span> <span class='erpbold'>[P]</span> <span class='erp'>a kiss</span>")

		else if (href_list["interaction"] == "lick")
			if( ((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && mouthfree && mouthfree_p)
				if (H.lust == 0)
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[H.gender == FEMALE ? "ëèçíóëà" : "ëèçíóë"]</span> <span class='erpbold'>[P]</span> <span class='erp'>â ùåêó.</span>")
					if (istype(P.loc, /obj/structure/closet))
						P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>[H.gender == FEMALE ? "ëèçíóëà" : "ëèçíóë"]</span> <span class='erpbold'>[P]</span> <span class='erp'>â ùåêó.</span>")
					if (H.lust < 5)
						H.lust = 5
				else
					H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>îñîáî òùàòåëüíî [H.gender == FEMALE ? "ëèçíóëà" : "ëèçíóë"]</span> <span class='erpbold'>[P].</span>")
					if (istype(P.loc, /obj/structure/closet))
						P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>îñîáî òùàòåëüíî [H.gender == FEMALE ? "ëèçíóëà" : "ëèçíóë"]</span> <span class='erpbold'>[P].</span>")

		else if (href_list["interaction"] == "hug")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<span class='passivebold'>[H]</span> <span class='passive'>hugs</span> <span class='passivebold'>[P]</span><span class='passive'>.</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='passivebold'>[H]</span> <span class='passive'>hugs</span> <span class='passivebold'>[P]</span><span class='passive'>.</span>")
				playsound(loc, 'honk/sound/interactions/hug.ogg', 50, 1, -1)

		else if (href_list["interaction"] == "cheer")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<B>[H]</B> cheers <B>[P]</B> on.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> cheers <B>[P]</B> on.")

		else if (href_list["interaction"] == "five")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<B>[H]</B> high fives <B>[P]</B>.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> high fives <B>[P]</B>.")
				playsound(loc, 'honk/sound/interactions/slap.ogg', 50, 1, -1)

		else if (href_list["interaction"] == "handshake")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands && hashands_p)
				H.visible_message("<B>[H]</B> shakes <B>[P]</B>'s hand.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> shakes <B>[P]</B>'s hand.")
			else
				H.visible_message("<B>[H]</B> extends [H.gender == MALE ? "his" : "her"] hand to <B>[P]</B>.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> extends [H.gender == MALE ? "his" : "her"] hand to <B>[P]</B>.")

		else if (href_list["interaction"] == "wave")
			if (!(Adjacent(P)) && hashands)
				H.visible_message("<B>[H]</B> waves at <B>[P]</B>.")
			else
				H.visible_message("<B>[H]</B> waves [H.gender == MALE ? "his" : "her"] stump at <B>[P]</B>.")


		else if (href_list["interaction"] == "slap")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>slaps</span> <span class='combatbold'>[P]</span> <span class='combat'>across the face!</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>slaps</span> <span class='combatbold'>[P]</span> <span class='combat'>across the face!</span>")
				playsound(loc, 'honk/sound/interactions/slap.ogg', 50, 1, -1)
				P.flash_weaker_pain()
				if (P.stamina_loss < 5)
					P.stamina_loss += 5

		else if (href_list["interaction"] == "fuckyou")
			if(hashands)
				H.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>gives</span> <span class='combatbold'>[P]</span> <span class='combat'>the finger!</span>")
				if (istype(P.loc, /obj/structure/closet) && P.loc == H.loc)
					P.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>gives</span> <span class='combatbold'>[P]</span> <span class='combat'>the finger!</span>")

		else if (href_list["interaction"] == "knock")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>knocks</span> <span class='combatbold'>[P]</span> <span class='combat'>upside the head!</span>")//Knocks?("<span class='danger'>[H] äàåò [P] ïîäçàòûëüíèê!</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>knocks</span> <span class='combatbold'>[P]</span> <span class='combat'>upside the head!</span>")
				playsound(loc, 'sound/weapons/throwtap.ogg', 50, 1, -1)
				if (P.stamina_loss < 5)
					P.stamina_loss += 5


		else if (href_list["interaction"] == "spit")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && mouthfree)
				H.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>spits at</span> <span class='combatbold'>[P]!</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>spits at</span> <span class='combatbold'>[P]!</span>")

		else if (href_list["interaction"] == "threaten")
			if(hashands)
				H.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>threatens</span> <span class='combatbold'>[P]</span> <span class='combat'>with a fist!</span>")
				if (istype(P.loc, /obj/structure/closet) && H.loc == P.loc)
					P.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>threatens</span> <span class='combatbold'>[P]</span> <span class='combat'>with a fist!</span>")

		else if (href_list["interaction"] == "tongue")
			if(mouthfree)
				H.visible_message("<span class='danger'>[H] sticks their tongue out at [P]!</span>")
				if (istype(P.loc, /obj/structure/closet) && H.loc == P.loc)
					P.visible_message("<span class='danger'>[H] sticks their tongue out at [P]</span>")

		else if (href_list["interaction"] == "assslap")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hasanus_p && hashands)
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>slaps</span> <span class='erpbold'>[P]</span> <span class='erp'>right on the ass!</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>slaps</span> <span class='erpbold'>[P]</span> <span class='erp'>right on the ass!</span>")
				playsound(loc, 'honk/sound/interactions/slap.ogg', 50, 1, -1)
				P.flash_weakest_pain()
				H.lust += rand(0.1,0.5)
				P.lust += rand(0.1,0.5)
				if (P.stamina_loss < 10)
					P.stamina_loss += 5

		else if (href_list["interaction"] == "squeezebreast")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>squeezes</span> <span class='erpbold'>[P]</span> <span class='erp'>'s breasts!</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='erpbold'>[H]</span> <span class='erp'>squeezes</span> <span class='erpbold'>[P]</span> <span class='erp'>'s breasts!</span>")
				if (P.stamina_loss < 10)
					P.stamina_loss += 5
				H.lust += rand(0.1,0.5)
				P.lust += rand(0.1,0.5)

		else if (href_list["interaction"] == "pull")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands && !H.restrained() && P.species.name == "Tajaran")
				if (prob(30))
					H.visible_message("<span class='danger'>[H] ä¸ðãàåò [P] çà õâîñò!</span>")
					if (istype(P.loc, /obj/structure/closet))
						P.visible_message("<span class='danger'>[H] ä¸ðãàåò [P] çà õâîñò!</span>")
					if (P.stamina_loss < 5)
						P.stamina_loss += 5
				else
					H.visible_message("<B>[H]</B> ïûòàåòñ[ya] ïîéìàòü <B>[P]</B> çà õâîñò!")
					if (istype(P.loc, /obj/structure/closet))
						P.visible_message("<B>[H]</B> ïûòàåòñ[ya] ïîéìàòü <B>[P]</B> çà õâîñò!")

		else if (href_list["interaction"] == "vaglick")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && isnude_p && mouthfree && hasvagina_p)
				H.fuck(H, P, "vaglick")

		else if (href_list["interaction"] == "ballsuck")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && isnude_p && mouthfree && haspenis_p)
				H.fuck(H, P, "ballsuck")

		else if (href_list["interaction"] == "fingering")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && isnude_p && hashands && hasvagina_p)
				H.fuck(H, P, "fingering")

		else if (href_list["interaction"] == "blowjob")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && isnude_p && mouthfree && haspenis_p)
				H.fuck(H, P, "blowjob")

		else if (href_list["interaction"] == "handjob")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && isnude_p && haspenis_p)
				H.fuck(H, P, "handjob")

		else if (href_list["interaction"] == "anal")
			if(get_dist(H,P) <= 1 && isnude_p && isnude && haspenis && hasanus_p)
				if (H.erpcooldown == 0)
					if (H.potenzia > 0)
						H.fuck(H, P, "anal")
				else
					var/message = pick("it's not erect...")//, "Êàê-òî íåò æåëàíè[ya]...", "×òî-òî íå îõîòà...", "Íåò, íå ñåé÷àñ.")
					to_chat(H, message)
		else if (href_list["interaction"] == "vaginal")
			if (get_dist(H,P) <= 1 && isnude_p && isnude && haspenis && hasanus_p)
				if (H.erpcooldown == 0)
					if (H.potenzia > 0)
						H.fuck(H, P, "vaginal")
				else
					var/message = pick("It's not erect...")//"Íå õî÷åòñ[ya] ìíå...", "Êàê-òî íåò æåëàíè[ya]...", "×òî-òî íå îõîòà...", "Íåò, íå ñåé÷àñ.")
					to_chat(H, message)

		else if (href_list["interaction"] == "oral")
			if (get_dist(H,P) <= 1 && isnude && mouthfree_p && haspenis)
				if (H.erpcooldown == 0)
					if (H.potenzia > 0)
						H.fuck(H, P, "oral")
				else
					var/message = pick("It's not erect...")//"Íå õî÷åòñ[ya] ìíå...", "Êàê-òî íåò æåëàíè[ya]...", "×òî-òî íå îõîòà...", "Íåò, íå ñåé÷àñ.")
					to_chat(H, message)

		else if (href_list["interaction"] == "mount")
			if (get_dist(H,P) <= 1 && isnude && isnude_p && haspenis_p && hasvagina)
/*				if (P.lust <= 0)
					var/message = pick("It's not up...")//"Èíñòðóìåíò íå ïåðåâåäåí â ðàáî÷åå ñîñòî[ya]íèå...", "Ó íåãî åùå íå âñòàë...", "À îí ëåæèò...", "Íèêàê íå íàñàäèòüñ[ya]...")
					H << message*/
				if(P.erpcooldown == 0)
					H.fuck(H, P, "mount")
				else
					var/message = pick("You have no lust now.")//"Íå õî÷åòñ[ya] ìíå...", "Êàê-òî íåò æåëàíè[ya]...", "×òî-òî íå îõîòà...", "Íåò, íå ñåé÷àñ.")
					to_chat(H, "<span class='erp'>[message]</span>")



	..()
	return


///eyecheck()
///Returns a number between -1 to 2
/mob/living/carbon/human/eyecheck()
	var/number = 0

	if(!species.has_organ["eyes"]) //No eyes, can't hurt them.
		return 2

	if(internal_organs_by_name["eyes"]) // Eyes are fucked, not a 'weak point'.
		var/datum/organ/internal/I = internal_organs_by_name["eyes"]
		if(I.status & ORGAN_CUT_AWAY)
			return 2
	else
		return 2

	if(istype(src.head, /obj/item/clothing/head/welding))
		if(!src.head:up)
			number += 2
	if(istype(src.head, /obj/item/clothing/head/helmet/space))
		number += 2
	if(istype(src.glasses, /obj/item/clothing/glasses/thermal))
		number -= 1
	if(istype(src.glasses, /obj/item/clothing/glasses/sunglasses))
		number += 1
	if(istype(src.glasses, /obj/item/clothing/glasses/welding))
		var/obj/item/clothing/glasses/welding/W = src.glasses
		if(!W.up)
			number += 2
	return number


/mob/living/carbon/human/IsAdvancedToolUser()
	return species.has_fine_manipulation

/mob/living/carbon/human/SpeciesCanConsume()
	if(src.species.flags & IS_SYNTHETIC)
		return 0
	else
		return 1 // Humans can eat, drink, and be forced to do so

/mob/living/carbon/human/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask || src.head || src.shoes || src.w_uniform || src.wear_suit || src.glasses || src.l_ear || src.r_ear || src.gloves || src.wrist_r || src.wrist_l || src.amulet)))
		return 1

	if( (src.l_hand && !src.l_hand.abstract) || (src.r_hand && !src.r_hand.abstract) )
		return 1

	return 0


/mob/living/carbon/human/proc/check_dna()
	dna.check_integrity(src)
	return

/mob/living/carbon/human/get_species()

	if(!species)
		set_species()

	if(dna && dna.mutantrace == "golem")
		return "Animated Construct"

	return species.name

/mob/living/carbon/human/proc/play_xylophone()
	if(!src.xylophone)
		visible_message("\red [src] begins playing his ribcage like a xylophone. It's quite spooky.","\blue You begin to play a spooky refrain on your ribcage.","\red You hear a spooky xylophone melody.")
		var/song = pick('sound/effects/xylophone1.ogg','sound/effects/xylophone2.ogg','sound/effects/xylophone3.ogg')
		playsound(loc, song, 50, 1, -1)
		xylophone = 1
		spawn(1200)
			xylophone=0
	return

/mob/living/carbon/human/proc/vomit()

	if(species.flags & IS_SYNTHETIC)
		return //Machines don't throw up.

	if(is_dreamer(src))
		return

	if(!lastpuke)
		lastpuke = 1
		to_chat(src, "<spawn class='pukes'>You feel nauseous...")
		if(resisting_disgust)
			to_chat(src, "<spawn class='pukes'>You managed to hold it back")
			return
		spawn(150)	//15 seconds until second warning
			to_chat(src, "<spawn class='pukes'>You feel like you are about to throw up!")
			if(resisting_disgust)
				to_chat(src, "<spawn class='pukes'>You managed to hold it back")
				return
			spawn(100)	//and you have 10 more for mad dash to the bucket
				if(resisting_disgust)
					to_chat(src, "<spawn class='pukes'>You managed to hold it back")
					return
				src.visible_message("<span class='pukebold'>[src]</span> <span class='pukes'>throws up!</span>","<span class='pukes'>You throw up!</span>")
				playsound(loc, 'sound/voice/vomit.ogg', 60, 1)
				src.hygiene = -400
				src.CU()
				src.stuttering += rand(1,3)
				add_event("hygiene", /datum/happiness_event/hygiene/vomitted)

				var/turf/location = loc
				if (istype(location, /turf/simulated))
					location.add_vomit_floor(src, 1)

				nutrition -= rand(20, 30)
				adjustToxLoss(-3)
				spawn(350)	//wait 35 seconds before next volley
					lastpuke = 0

/mob/living/carbon/human/proc/morph()
	set name = "Morph"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mMorph in mutations))
		src.verbs -= /mob/living/carbon/human/proc/morph
		return

	var/new_facial = input("Please select facial hair color.", "Character Generation",rgb(r_facial,g_facial,b_facial)) as color
	if(new_facial)
		r_facial = hex2num(copytext(new_facial, 2, 4))
		g_facial = hex2num(copytext(new_facial, 4, 6))
		b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation",rgb(r_hair,g_hair,b_hair)) as color
	if(new_facial)
		r_hair = hex2num(copytext(new_hair, 2, 4))
		g_hair = hex2num(copytext(new_hair, 4, 6))
		b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation",rgb(r_eyes,g_eyes,b_eyes)) as color
	if(new_eyes)
		r_eyes = hex2num(copytext(new_eyes, 2, 4))
		g_eyes = hex2num(copytext(new_eyes, 4, 6))
		b_eyes = hex2num(copytext(new_eyes, 6, 8))

	var/new_tone = input("Please select skin tone level: 1-255 (1=albino, 35=caucasian, 150=black, 255='very' black)", "Character Generation", "[35-s_tone]")  as text

	if (!new_tone)
		new_tone = 35
	s_tone = max(min(round(text2num(new_tone)), 255), 1)
	s_tone =  -s_tone + 35

	// hair
	var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	var/list/hairs = list()

	// loop through potential hairs
	for(var/x in all_hairs)
		var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
		hairs.Add(H.name) // add hair name to hairs
		qdel(H) // delete the hair after it's all done

	var/new_style = input("Please select hair style", "Character Generation",h_style)  as null|anything in hairs

	// if new style selected (not cancel)
	if (new_style)
		h_style = new_style

	// facial hair
	var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	var/list/fhairs = list()

	for(var/x in all_fhairs)
		var/datum/sprite_accessory/facial_hair/H = new x
		fhairs.Add(H.name)
		qdel(H)

	new_style = input("Please select facial style", "Character Generation",f_style)  as null|anything in fhairs

	if(new_style)
		f_style = new_style

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			gender = MALE
		else
			gender = FEMALE
	regenerate_icons()
	check_dna()

	visible_message("\blue \The [src] morphs and changes [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] appearance!", "\blue You change your appearance!", "\red Oh, god!  What the hell was that?  It sounded like flesh getting squished and bone ground into a different shape!")

/mob/living/carbon/human/proc/remotesay()
	set name = "Project mind"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mRemotetalk in src.mutations))
		src.verbs -= /mob/living/carbon/human/proc/remotesay
		return
	var/list/creatures = list()
	for(var/mob/living/carbon/h in world)
		creatures += h
	var/mob/target = input ("Who do you want to project your mind to ?") as null|anything in creatures
	if (isnull(target))
		return

	var/say = input ("What do you wish to say")
	if(mRemotetalk in target.mutations)
		target.show_message("\blue You hear [src.real_name]'s voice: [say]")
	else
		target.show_message("\blue You hear a voice that seems to echo around the room: [say]")
	usr.show_message("\blue You project your mind into [target.real_name]: [say]")
	for(var/mob/dead/observer/G in world)
		G.show_message("<i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i>")

/mob/living/carbon/human/proc/remoteobserve()
	set name = "Remote View"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		remoteview_target = null
		reset_view(0)
		return

	if(!(mRemote in src.mutations))
		remoteview_target = null
		reset_view(0)
		src.verbs -= /mob/living/carbon/human/proc/remoteobserve
		return

	if(client.eye != client.mob)
		remoteview_target = null
		reset_view(0)
		return

	var/list/mob/creatures = list()

	for(var/mob/living/carbon/h in world)
		var/turf/temp_turf = get_turf(h)
		if((temp_turf.z != 1 && temp_turf.z != 5) || h.stat!=CONSCIOUS) //Not on mining or the station. Or dead
			continue
		creatures += h

	var/mob/target = input ("Who do you want to project your mind to ?") as mob in creatures

	if (target)
		remoteview_target = target
		reset_view(target)
	else
		remoteview_target = null
		reset_view(0)

/mob/living/carbon/human/proc/get_visible_gender()
	if(wear_suit && wear_suit.flags_inv & HIDEJUMPSUIT && ((head && head.flags_inv & HIDEMASK) || wear_mask))
		return NEUTER
	return gender

/mob/living/carbon/human/proc/increase_germ_level(n)
	if(gloves)
		gloves.germ_level += n
	else
		germ_level += n

/mob/living/carbon/human/revive()
	add_teeth()
	bodyhair()
	add_fingers()
	create_pain_threshold()
	add_nose_ears()
	for (var/datum/organ/external/O in organs)
		O.status &= ~ORGAN_BROKEN
		O.status &= ~ORGAN_BLEEDING
		O.status &= ~ORGAN_SPLINTED
		O.status &= ~ORGAN_CUT_AWAY
		O.status &= ~ORGAN_ATTACHABLE
		if (!O.amputated)
			O.status &= ~ORGAN_DESTROYED
			O.destspawn = 0
		O.wounds.Cut()
		O.heal_damage(1000,1000,1,1)

	var/datum/organ/external/face/F = organs_by_name["face"]
	F.disfigured = 0

	if(species && !(species.flags & NO_BLOOD))
		vessel.add_reagent("blood",560-vessel.total_volume)
		fixblood()

	for (var/obj/item/weapon/organ/head/H in world)
		if(H.brainmob)
			if(H.brainmob.real_name == src.real_name)
				if(H.brainmob.mind)
					H.brainmob.mind.transfer_to(src)
					qdel(H)

	for(var/datum/organ/internal/I in internal_organs)
		I.damage = 0

	for (var/datum/disease/virus in viruses)
		virus.cure()
	for (var/ID in virus2)
		var/datum/disease2/disease/V = virus2[ID]
		V.cure(src)

	..()
/mob/living/carbon/human/proc/is_lung_ruptured()
	var/datum/organ/internal/lungs/L = internal_organs_by_name["lungs"]
	return L && L.is_bruised()


/mob/living/carbon/human/proc/add_teeth()
	var/datum/organ/external/mouth/U = locate() in organs
	if(istype(U))
		U.teeth_list.Cut() //Clear out their mouth of teeth
		var/obj/item/stack/teeth/T = new species.teeth_type(U)
		U.max_teeth = T.max_amount //Set max teeth for the head based on teeth spawntype
		T.amount = T.max_amount
		U.teeth_list += T

/mob/living/carbon/human/proc/create_pain_threshold()
	for(var/datum/organ/external/E in organs)
		E.create_pain_threshold()

/mob/living/carbon/human/proc/add_nose_ears()
	var/datum/organ/external/head/H = locate() in organs
	if(istype(H))
		var/obj/item/weapon/organ/ear/right/R = new
		var/obj/item/weapon/organ/ear/left/L = new
		var/obj/item/weapon/organ/nose/N = new
		H.nose = N
		H.ears.Add(R)
		H.ears.Add(L)


/mob/living/carbon/human/proc/add_fingers() //botar dedo nas maos, sim e tudo manual
	var/datum/organ/external/hand/r_hand/R = locate() in organs
	if(istype(R))
		R.fingers.Cut()
		var/obj/item/weapon/organ/finger/thumb/T1 = new
		var/obj/item/weapon/organ/finger/index/I2 = new
		var/obj/item/weapon/organ/finger/middle/M3 = new
		var/obj/item/weapon/organ/finger/ring/R4 = new
		var/obj/item/weapon/organ/finger/little/L5 = new
		R.fingers.Add(T1)
		R.fingers.Add(I2)
		R.fingers.Add(M3)
		R.fingers.Add(R4)
		R.fingers.Add(L5)
	var/datum/organ/external/hand/l_hand/L = locate() in organs
	if(istype(L))
		L.fingers.Cut()
		var/obj/item/weapon/organ/finger/thumb/T6 = new
		var/obj/item/weapon/organ/finger/index/I7 = new
		var/obj/item/weapon/organ/finger/middle/M8 = new
		var/obj/item/weapon/organ/finger/ring/R9 = new
		var/obj/item/weapon/organ/finger/little/L10 = new
		L.fingers.Add(T6)
		L.fingers.Add(I7)
		L.fingers.Add(M8)
		L.fingers.Add(R9)
		L.fingers.Add(L10)
	var/datum/organ/external/foot/l_foot/L_PE = locate() in organs
	if(istype(L_PE))
		L_PE.fingers.Cut()
		var/obj/item/weapon/organ/finger/big_toe/T11 = new
		var/obj/item/weapon/organ/finger/index_toe/I12 = new
		var/obj/item/weapon/organ/finger/middle_toe/M13 = new
		var/obj/item/weapon/organ/finger/ring_toe/R14 = new
		var/obj/item/weapon/organ/finger/little_toe/L15 = new
		L_PE.fingers.Add(T11)
		L_PE.fingers.Add(I12)
		L_PE.fingers.Add(M13)
		L_PE.fingers.Add(R14)
		L_PE.fingers.Add(L15)
	var/datum/organ/external/foot/r_foot/R_PE = locate() in organs
	if(istype(R_PE))
		R_PE.fingers.Cut()
		var/obj/item/weapon/organ/finger/big_toe/T16 = new
		var/obj/item/weapon/organ/finger/index_toe/I17 = new
		var/obj/item/weapon/organ/finger/middle_toe/M18 = new
		var/obj/item/weapon/organ/finger/ring_toe/R19 = new
		var/obj/item/weapon/organ/finger/little_toe/L20 = new
		R_PE.fingers.Add(T16)
		R_PE.fingers.Add(I17)
		R_PE.fingers.Add(M18)
		R_PE.fingers.Add(R19)
		R_PE.fingers.Add(L20)

/mob/living/carbon/human/proc/rupture_lung()
	var/datum/organ/internal/lungs/L = internal_organs_by_name["lungs"]

	if(L && !L.is_bruised())
		src.custom_pain("<span class='combat'>You feel a stabbing pain in your chest!</span>", 1)
		L.damage = L.min_bruised_damage

/*
/mob/living/carbon/human/verb/simulate()
	set name = "sim"
	set background = 1

	var/damage = input("Wound damage","Wound damage") as num

	var/germs = 0
	var/tdamage = 0
	var/ticks = 0
	while (germs < 2501 && ticks < 100000 && round(damage/10)*20)
		diary << "VIRUS TESTING: [ticks] : germs [germs] tdamage [tdamage] prob [round(damage/10)*20]"
		ticks++
		if (prob(round(damage/10)*20))
			germs++
		if (germs == 100)
			world << "Reached stage 1 in [ticks] ticks"
		if (germs > 100)
			if (prob(10))
				damage++
				germs++
		if (germs == 1000)
			world << "Reached stage 2 in [ticks] ticks"
		if (germs > 1000)
			damage++
			germs++
		if (germs == 2500)
			world << "Reached stage 3 in [ticks] ticks"
	world << "Mob took [tdamage] tox damage"
*/
//returns 1 if made bloody, returns 0 otherwise

/mob/living/carbon/human/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0
	//if this blood isn't already in the list, add it
	if(blood_DNA[M.dna.unique_enzymes])
		return 0 //already bloodied with this blood. Cannot add more.
	blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	hand_blood_color = blood_color
	src.update_inv_gloves()	//handles bloody hands overlays and updating
	verbs += /mob/living/carbon/human/proc/bloody_doodle
	return 1 //we applied blood to the item

/mob/living/carbon/human/clean_blood(var/clean_feet)
	.=..()
	if(clean_feet && !shoes && istype(feet_blood_DNA, /list) && feet_blood_DNA.len)
		feet_blood_color = null
		qdel(feet_blood_DNA)
		update_inv_shoes(1)
		return 1

/mob/living/carbon/human/proc/get_visible_implants(var/class = 0)
	class = 0
	var/list/visible_implants = list()
	for(var/datum/organ/external/organ in src.organs)
		for(var/obj/item/weapon/O in organ.implants)
			if(!istype(O,/obj/item/weapon/implant) && O.w_class > class)
				visible_implants += O

	return(visible_implants)

/mob/living/carbon/human/proc/handle_embedded_objects()

	for(var/datum/organ/external/organ in src.organs)
		if(organ.status & ORGAN_SPLINTED) //Splints prevent movement.
			continue
		for(var/obj/item/weapon/O in organ.implants)
			if(!istype(O,/obj/item/weapon/implant) && prob(5)) //Moving with things stuck in you could be bad.
				// All kinds of embedded objects cause bleeding.
				var/msg = null
				switch(rand(1,3))
					if(1)
						msg ="<span class='warning'>A spike of pain jolts your [organ.display_name] as you bump [O] inside.</span>"
					if(2)
						msg ="<span class='warning'>Your movement jostles [O] in your [organ.display_name] painfully.</span>"
					if(3)
						msg ="<span class='warning'>[O] in your [organ.display_name] twists painfully as you move.</span>"
				src << msg

				organ.take_damage(rand(1,3), 0, 0)
				if(!(organ.status & ORGAN_ROBOT)) //There is no blood in protheses.
					organ.status |= ORGAN_BLEEDING
					src.adjustToxLoss(rand(1,3))
/*
/mob/living/carbon/human/verb/check_pulse()
	set category = "Object"
	set name = "Check pulse"
	set desc = "Approximately count somebody's pulse. Requires you to stand still at least 6 seconds."
	set src in view(1)
	var/self = 0

	if(usr.stat == 1 || usr.restrained() || !isliving(usr)) return

	if(usr == src)
		self = 1
	if(!self)
		usr.visible_message("<span class='passivebold'>[usr]</span> <span class='passivebold'>kneels down, puts \his hand on</span> <span class='passivebold'>[src]</span><span class='passive'>'s wrist and begins counting their pulse.</span>",\
		"<span class='passive'>You begin counting</span> <span class='passivebold'>[src]</span><span class='passive'>'s pulse.</span>")
	else
		usr.visible_message("\blue [usr] begins counting their pulse.",\
		"You begin counting your pulse.")
	if(do_after(usr, 20))
		if(!src.pulse)
			to_chat(usr, "<span class='combatbold'> [src] has no pulse!</span>")
			return
		else
			to_chat(usr, "<span class='passive'> [self ? "Your" : "[src]'s"] pulse is [src.get_pulse(GETPULSE_HAND)].")
*/
/mob/living/carbon/human/proc/check_pulse(var/mob/living/checker)
	set hidden = 0
	set category = "Object"
	set name = "Checkpulse"
	set desc = "Approximately count somebody's pulse. Requires you to stand still at least 6 seconds."
	set src in view(1)
	var/self = 0

	if(checker.stat == 1 || checker.restrained() || !isliving(checker)) return

	if(checker == src)
		self = 1
	if(!self)
		checker.visible_message("<span class='passivebold'>[checker]</span> <span class='passivebold'>kneels down, puts \his hand on</span> <span class='passivebold'>[src]</span><span class='passive'>'s wrist and begins counting their pulse.</span>",\
		"<span class='passive'>You begin counting</span> <span class='passivebold'>[src]</span><span class='passive'>'s pulse.</span>")
	else
		checker.visible_message("\blue [checker] begins counting their pulse.",\
		"You begin counting your pulse.")
	if(do_after(checker, 20))
		if(!src.pulse || isVampire)
			to_chat(checker, "<span class='combatbold'> [src] has no pulse!</span>")
			return
		else
			to_chat(checker, "<span class='passive'> [self ? "Your" : "[src]'s"] pulse is [src.get_pulse(GETPULSE_HAND)].")

/mob/living/carbon/human/proc/set_species(var/new_species, var/default_colour)

	if(new_species == "Skeleton" && ismonster(src))
		return
	if(!dna)
		if(!new_species)
			new_species = "Human"
	else
		if(!new_species)
			new_species = dna.species
		else
			dna.species = new_species

	if(species)

		if(species.name && species.name == new_species)
			return
		if(species.language)
			remove_language(species.language)

		if(species.default_language)
			remove_language(species.default_language)

		// Clear out their species abilities.
		species.remove_inherent_verbs(src)

	species = all_species[new_species]

	if(species)
		species.create_organs(src)

	if(species && species.language)
		add_language(species.language)

	if(species && species.default_language)
		add_language(species.default_language)

	species.handle_post_spawn(src)

	create_pain_threshold()

	bodyhair()

	add_teeth()

	add_fingers()

	add_nose_ears()

	spawn(0)
		regenerate_icons()
		vessel.add_reagent("blood",560-vessel.total_volume)
		fixblood()

	if(species)
		return 1
	else
		return 0


/mob/living/carbon/human/proc/bloody_doodle()
	set category = "IC"
	set name = "Write in blood"
	set desc = "Use blood on your hands to write a short message on the floor or a wall, murder mystery style."

	if (src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if (!bloody_hands)
		verbs -= /mob/living/carbon/human/proc/bloody_doodle

	if (src.gloves)
		src << "<span class='warning'>Your [src.gloves] are getting in the way.</span>"
		return

	var/turf/simulated/T = src.loc
	if (!istype(T)) //to prevent doodling out of mechs and lockers
		src << "<span class='warning'>You cannot reach the floor.</span>"
		return

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	if (direction != "Here")
		T = get_step(T,text2dir(direction))
	if (!istype(T))
		src << "<span class='warning'>You cannot doodle there.</span>"
		return

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		src << "<span class='warning'>There is no space to write on!</span>"
		return

	var/max_length = bloody_hands * 30 //tweeter style

	var/message = stripped_input(src,"Write a message. It cannot be longer than [max_length] characters.","Blood writing", "")

	if (message)
		var/used_blood_amount = round(length(message) / 30, 1)
		bloody_hands = max(0, bloody_hands - used_blood_amount) //use up some blood

		if (length(message) > max_length)
			message += "-"
			src << "<span class='warning'>You ran out of blood to write with!</span>"

		var/obj/effect/decal/cleanable/blood/writing/W = PoolOrNew(/obj/effect/decal/cleanable/blood/writing, T)
		W.basecolor = (hand_blood_color) ? hand_blood_color : "#A10808"
		W.update_icon()
		W.message = message
		W.add_fingerprint(src)

/mob/living/carbon/human/proc/exam_self()
//	set name = "Examine Self"
//	set category = "IC"



	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = usr
		var/msg
		if(!stat)
			msg = "<div class='firstdiv'><div class='box'><span class='uppertext'>I'm still alive. I can carry [maxweight] kgs.\n Encumbrance:[weight_state]</span>\n"
		if(stat == DEAD)
			msg = "<div class='firstdiv'><div class='box'><span class='uppertext'>I'm dead.</span>\n"
		else
			if(sleeping || stat == UNCONSCIOUS)
				msg = "<div class='firstdiv'><div class='box'><span class='uppertext'>I'm unconscious. I can carry [maxweight] kgs. \n Encumbrance:[weight_state]</span>\n"
			if(stat == UNCONSCIOUS && last_dam >= 100)
				msg = "<div class='firstdiv'><div class='box'><span class='uppertext'>I'm dying.</span>\n"

		for(var/datum/organ/external/org in H.organs)
			var/list/status = list()
			var/hurts = org.painLW

			if(!reagents.has_reagent("dentrine") || !reagents.has_reagent("morphine"))
				switch(hurts)
					if(1 to 15)
						status += "<span class='lpexamine'><small>pain</small></span>"
					if(15 to 25)
						status += "<span class='lpexamine'>Pain</span>"
					if(25 to 45)
						status += "<span class='magentatext'><big>PAIN</big></span>"
					if(45 to INFINITY)
						status += "<span class='magentatextbig'><big><big>PAIN</big></big></span>"

			if(org.has_finger)
				var/list/L = org.get_fucked_up()
				for(var/x in L)
					status += x

			if(org.status & ORGAN_DESTROYED)
				status += "<span class='missingnew'><big>MISSING</big></span>"
			if(org.status & ORGAN_MUTATED)
				status += "<span class='magentatext'>MISSHAPEN</span>"
			if(org.germ_level >= 1)
				status += "<span class='redtext'>FESTERING</span>"
			if(org.status & ORGAN_BLEEDING)
				status += "<span class='redtext'>BLEEDING</span>"
			if(org.status & ORGAN_BROKEN)
				status += "<span class='redtext'>FRACTURE</span>"
			if(org.status & ORGAN_SPLINTED)
				status += "<span class='passivebold'>SPLINTED</span>"
				status -= "<span class='redtext'>FRACTURE</span>"
			if(org.status & ORGAN_DEAD)
				status += "<span class='redtext'>NECROSIS</span>"
			if(org.status & ORGAN_ARTERY)
				status += "<span class='magentatext'>ARTERY</span>"
			if(org.cripple_left > 0)
				status += "<span class='magentatext'>CRIPPLED</span>"
			if(org.status & ORGAN_CUT_AWAY)
				status += "<span class='magentatext'>UNCONNECTED</span>"
			if(org.status & ORGAN_TENDON)
				status += "<span class='magentatext'>TENDON</span>"
			if(!org.is_usable())
				status += "<span class='missingnew'>UNUSABLE</span>"
			if(istype(org, /datum/organ/external/head))
				var/datum/organ/external/head/HEADD = org
				if(HEADD.brained)
					status += "<span class='magentatext'>CRACK</span>"
			if(status.len)
				msg += "<span class='statustext'>¤ [capitalize(org.display_name)]: [english_listt(status)]</span>\n"
			else
				msg += "<span class='statustext'>¤ [capitalize(org.display_name)]: OK</span>\n"

		to_chat(src, "[msg]</div></div>", 10)

		if((SKELETON in H.mutations) && (!H.w_uniform) && (!H.wear_suit))
			H.play_xylophone()

/mob/living/carbon/human/has_brain()
	if(internal_organs_by_name["brain"])
		var/datum/organ/internal/brain = internal_organs_by_name["brain"]
		if(brain && istype(brain))
			return 1
	return 0

/mob/living/carbon/human/has_brain()
	if(internal_organs_by_name["brain"])
		var/datum/organ/internal/brain = internal_organs_by_name["brain"]
		if(brain && istype(brain))
			return 1
	return 0

/mob/living/carbon/human/has_eyes()
	if(internal_organs_by_name["eyes"])
		var/datum/organ/internal/eyes = internal_organs_by_name["eyes"]
		if(eyes && istype(eyes) && !eyes.status & ORGAN_CUT_AWAY)
			return 1
	return 0

/mob/living/carbon/human/print_flavor_text()
	var/list/equipment = list(src.head,src.wear_mask,src.glasses,src.w_uniform,src.wear_suit,src.gloves,src.shoes)
	var/head_exposed = 1
	var/face_exposed = 1
	var/eyes_exposed = 1
	var/torso_exposed = 1
	var/arms_exposed = 1
	var/legs_exposed = 1
	var/hands_exposed = 1
	var/feet_exposed = 1

	for(var/obj/item/clothing/C in equipment)
		if(C.body_parts_covered & HEAD)
			head_exposed = 0
			face_exposed = 0
			eyes_exposed = 0
/*		if(C.body_parts_covered & FACE)
			face_exposed = 0
		if(C.body_parts_covered & EYES)
			eyes_exposed = 0*/
		if(C.body_parts_covered & UPPER_TORSO)
			torso_exposed = 0
		if(C.body_parts_covered & ARMS)
			arms_exposed = 0
		if(C.body_parts_covered & HANDS)
			hands_exposed = 0
		if(C.body_parts_covered & LEGS)
			legs_exposed = 0
		if(C.body_parts_covered & FEET)
			feet_exposed = 0

	flavor_text = flavor_texts["general"]
	flavor_text += "\n\n"
	for (var/T in flavor_texts)
		if(flavor_texts[T] && flavor_texts[T] != "")
			if((T == "head" && head_exposed) || (T == "face" && face_exposed) || (T == "eyes" && eyes_exposed) || (T == "torso" && torso_exposed) || (T == "arms" && arms_exposed) || (T == "hands" && hands_exposed) || (T == "legs" && legs_exposed) || (T == "feet" && feet_exposed))
				flavor_text += sanitize(flavor_texts[T])
				flavor_text += "\n\n"
	return ..()


/mob/living/carbon/human/proc/expose_brain()
	var/datum/organ/external/head/H = get_organ("head")
	if(H)
		H.brained=1
		update_hair()
		update_body()

/mob/living/carbon/human/proc/unexpose_brain()
	var/datum/organ/external/head/H = get_organ("head")
	if(H)
		H.brained=0
		update_hair()
		update_body()
/mob/living/carbon/human/proc/has_penis()
	if(species.genitals && !mutilated_genitals && potenzia > -1)
		if(gender == FEMALE)
			if(futa || src.isFemboy())
				return 1
			else
				return 0
		else if(gender == MALE)
			return 1
	else return 0

/mob/living/carbon/human/proc/mutilate_genitals()
	if(!mutilated_genitals)
		potenzia = -1
		mutilated_genitals = 1
		return 1

/mob/living/carbon/human/verb/lookup_hotkey()//For the hotkeys.
	set name = ".lookup"
	lookup()

/mob/living/carbon/human/verb/lookup()
	set name = "Look Up"
	set desc = "If you want to know what's above."
	set category = "IC"

	if(!sleeping)
		var/turf/controllerlocation = locate(1, 1, src.z)
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if(controller.up)
				var/turf/above = locate(src.x, src.y, controller.up_target)
				if(istype(above, /turf/simulated/floor/open))
					if(!looking_up)
						looking_up = TRUE
						src.client.eye = above
						to_chat(src, "<span class='passive'>You look up and see a open space, maybe I can climb it.</span>")
					else
						src.client.eye = src
						looking_up = FALSE
						src.reset_view()
				else
					to_chat(src, "<span class='jogtowalk'><i>You raise your head and look at the ceiling. Thousands of spiteful eyes glare at you from above.</i></span>")
					src.client.eye = src
					looking_up = FALSE
					src.reset_view()

/mob/living/carbon/human/verb/hidee()
	set name = "Hide"
	set desc = "If you want to hide from enemies."
	set category = "IC"

	if(isturf(loc))
		var/turf/T = loc
		if(T.get_lumcount() <= 0.2)
			src.alpha = 70
			hasalpha = 1

/mob/proc/do_zoom()
	var/do_normal_zoom = TRUE
	if(!zoomed)
		if(lying)
			return
		if(do_normal_zoom)
			var/_x = 0
			var/_y = 0
			switch(dir)
				if (NORTH)
					_y = 7
				if (EAST)
					_x = 7
				if (SOUTH)
					_y = -7
				if (WEST)
					_x = -7
			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				H.zoomed = TRUE
				H.check_fov()
				H.hide_cone()
				animate(client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, time = 2, easing = SINE_EASING)
				set_face_dir(dir)//Face what we're zoomed in on.
	else
		if(do_normal_zoom)
			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				animate(client, pixel_x = 0, pixel_y = 0, time = 2, easing = SINE_EASING)
				H.show_cone()
				set_face_dir(FALSE)//Reset us back to normal.
		zoomed = FALSE
/mob/living/carbon/human/proc/reset_zoom()
	animate(client, pixel_x = 0, pixel_y = 0, time = 2, easing = SINE_EASING)
	zoomed = FALSE

/mob/living/carbon/human/RightClick(mob/living/carbon/human/user)
	var/intent = user.a_intent
	var/datum/organ/external/affectedorgan = src.get_organ(user.zone_sel.selecting)
	var/list/allowedCheckPulse = list("right hand", "right arm", "left arm", "left hand")
	if(intent == "hurt")
		do_combat_rmb(user)
		return
	if(intent == "help" && allowedCheckPulse.Find(affectedorgan.display_name))
		src.check_pulse(user)
		return
	if(!user.combat_mode && intent == "help" )
		give(src)
		return
	var/datum/organ/external/affecting = src.get_organ(user.zone_sel.selecting)
	if(intent == "grab" && affecting.bandaged)
		if(stat) return
		if(handcuffed) return
		affecting.bandaged.loc = src.loc
		user.put_in_hands(affecting.bandaged)
		affecting.bandaged = null
		UpdateBandageIcon()
	else
		..()

/mob/living/carbon/human/proc/combatfail(var/failchance, var/meleereq)
	if(src.m_intent != "walk")
		if(prob(5+src.my_skills.GET_SKILL(SKILL_MELEE)+src.my_stats.dx))
			return
	else
		if(prob(60+src.my_skills.GET_SKILL(SKILL_MELEE)+src.my_stats.dx))
			return

/mob/living/carbon/human/proc/god_text()
	switch(religion)
		if("Thanati")
			return "Overlord"
		if("Allah")
			return "Allah"
		if("Old Ways")
			if(!src?.old_ways?.god)
				return "Gods"
			else
				return src.old_ways.god
		else
			return "God"

/mob/living/carbon/human/proc/firstvictimCheck()
	if(!firstvictim && !firstvictimlastword)
		firstvictim = src.real_name
		firstvictimlastword = src.last_said
	return

/mob/living/carbon/human/rejuvenate(var/no_blood = FALSE)
	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	SetParalysis(0)
	SetStunned(0)
	SetWeakened(0)
	setStaminaLoss(0)

	// shut down ongoing problems
	radiation = 0
	bodytemperature = T20C
	sdisabilities = 0
	disabilities = 0

	// fix blindness and deafness
	blinded = 0
	eye_blind = 0
	eye_blurry = 0
	ear_deaf = 0
	ear_damage = 0
	heal_overall_damage(getBruteLoss(), getFireLoss())
	ExtinguishMob()

	// restore all of a human's blood
	if(!no_blood)
		if(ishuman(src))
			var/mob/living/carbon/human/human_mob = src
			human_mob.restore_blood()

	// fix all of our organs
	restore_all_organs()
	add_fingers()
	add_nose_ears()

	// remove the character from the list of the dead
	if(stat == 2)
		dead_mob_list -= src
		living_mob_list += src
		tod = null

	// restore us to conciousness
	var/datum/organ/internal/heart/HE = src.internal_organs_by_name["heart"]
	if(HE)
		HE.stopped_working = 0
	undeath_door()
	stat = CONSCIOUS
	sleeping = 0

	// make the icons look correct
	regenerate_icons()

	return

mob/living/carbon/human/proc/display_job()
	if(assignment)
		return assignment
	return job

mob/living/carbon/human/Destroy()
	.=..()
	if(src.old_key && src.old_job)
		var/datum/showlads_holder/S = new()
		S.name = "[src.real_name]"
		S.job = "[src.old_job]"
		S.key = "[src.old_key]"
		if(src.old_key && src.religion == "Thanati")
			S.thanati = TRUE

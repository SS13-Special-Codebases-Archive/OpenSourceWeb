/obj/item/proc/eyestab(mob/living/carbon/M as mob, mob/living/carbon/user as mob)

	var/mob/living/carbon/human/H = M
	if(istype(H) && ( \
			(H.head && H.head.flags & HEADCOVERSEYES) || \
			(H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || \
			(H.glasses && H.glasses.flags & GLASSESCOVERSEYES) \
		))
		// you can't stab someone in the eyes wearing a mask!
		user << "\red You're going to need to remove the eye covering first."
		return

	var/mob/living/carbon/monkey/Mo = M
	if(istype(Mo) && ( \
			(Mo.wear_mask && Mo.wear_mask.flags & MASKCOVERSEYES) \
		))
		// you can't stab someone in the eyes wearing a mask!
		user << "\red You're going to need to remove the eye covering first."
		return

	if(!M.has_eyes())
		user << "\red You cannot locate any eyes on [M]!"
		return

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)") //BS12 EDIT ALG

	src.add_fingerprint(user)
	//if((CLUMSY in user.mutations) && prob(50))
	//	M = user
		/*
		M << "\red You stab yourself in the eye."
		M.sdisabilities |= BLIND
		M.weakened += 4
		M.adjustBruteLoss(10)
		*/
	if(M != user)
		for(var/mob/O in (viewers(M) - user - M))
			O.show_message("\red [M] has been stabbed in the eye with [src] by [user].", 1)
		M << "\red [user] stabs you in the eye with [src]!"
		user << "\red You stab [M] in the eye with [src]!"
	else
		user.visible_message( \
			"\red [user] has stabbed themself with [src]!", \
			"\red You stab yourself in the eyes with [src]!" \
		)
	if(istype(M, /mob/living/carbon/human))
		var/datum/organ/internal/eyes/eyes = H.internal_organs_by_name["eyes"]
		eyes.damage += rand(3,4)
		if(eyes.damage >= eyes.min_bruised_damage)
			if(M.stat != 2)
				if(eyes.robotic <= 1) //robot eyes bleeding might be a bit silly
					M << "\red Your eyes start to bleed profusely!"
			if(prob(50))
				if(M.stat != 2)
					M << "\red You drop what you're holding and clutch at your eyes!"
					M.drop_item()
				M.eye_blurry += 10
				M.Paralyse(1)
				M.Weaken(4)
			if (eyes.damage >= eyes.min_broken_damage)
				if(M.stat != 2)
					M << "\red You go blind!"
		var/datum/organ/external/affecting = M:get_organ("head")
		if(affecting.take_damage(7))
			M:UpdateDamageIcon()
	else
		M.take_organ_damage(7)
	M.eye_blurry += rand(3,4)
	return

/*************************************
 	   INTERNAL ORGAN STABS
*************************************/

/obj/item/proc/stab(mob/living/carbon/M as mob, mob/living/carbon/user as mob)

	var/get_damage = src.force-src.force/3
	var/mob/living/carbon/human/H = M
	var/datum/organ/internal/target_o = H.internal_organs_by_name[pick("liver", "lungs", "heart")]

	if(istype(H) && ( \
			(H.wear_suit && H.wear_suit.body_parts_covered & LOWER_TORSO) || \
			(H.wear_suit && H.wear_suit.heat_protection & LOWER_TORSO) \
		))
		// you can't stab someone wearing an armor!
		for(var/mob/O in (viewers(M) - user - M))
			O.show_message("\red <b>[user] tried to stab [M] in the chest with [src], but the attack was deflected by the [M]'s [H.wear_suit.name]!</b>", 1)
		M << "\red <b>[user] tried to stab you in the chest with [src], but the attack was deflected by the your [H.wear_suit.name]!</b>"
		user << "\red <b>You tried to stab [M] in the chest with [src], but the attack was deflected by the [M]'s [H.wear_suit.name]!</b>"
		return

	if(istype(M, /mob/living/carbon/alien))//N     slimes don't have a heart!
		return

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Stabbed [M.name] ([M.ckey]) with [src] (INTENT: [uppertext(user.a_intent)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Stabbed by [user.name] ([user.ckey]) with [src] (INTENT: [uppertext(user.a_intent)])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) stabbed [M.name] ([M.ckey]) with [src] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)") //BS12 EDIT ALG

	src.add_fingerprint(user)

	if(target_o.damage + get_damage >= target_o.min_broken_damage)
		if(M != user)
			for(var/mob/O in (viewers(M) - user - M))
				O.show_message("\red <b>[user] has stabbed [M] in the the chest with [src], tearing apart the [target_o]!</b>", 1)
			M << "\red <b>[user] stabs you in the chest with [src], tearing apart the [target_o]!</b>"
			user << "\red <b>You stab [M] in the chest with [src], tearing apart the [target_o]!</b>"
		else
			user.visible_message( \
				"\red [user] has stabbed themself in their chest with [src], tearing apart the [target_o]!", \
				"\red You stab yourself in your chest with [src], tearing apart the [target_o]!" \
								)
	else
		if(M != user)
			for(var/mob/O in (viewers(M) - user - M))
				O.show_message("\red <b>[user] has stabbed [M] in the chest with [src], bruising the [target_o]!</b>", 1)
			M << "\red <b>[user] stabs you in the chest with [src], bruising the [target_o]!</b>"
			user << "\red <b>You stab [M] in the chest with [src], bruising the [target_o]!</b>"
		else
			user.visible_message( \
				"\red [user] has stabbed themself in their chest with [src], bruising the [target_o]!", \
				"\red You stab yourself in the chest with [src], bruising the [target_o]!" \
								)

	if(istype(M, /mob/living/carbon/human))
		target_o.process()
		target_o.damage += get_damage
//		if(!(heart.status & ORGAN_ROBOT)) //There is no blood in protheses.
//			heart.status |= ORGAN_BLEEDING
		M << "\red You feel [src] move inside you"
		if(target_o.damage >= target_o.min_bruised_damage)
			if(prob(50))
				if(M.stat != 2)
					M << "\red You drop what you're holding and clutch at your chest!"
					M.drop_item()
				M.eye_blurry += 5
				M.Paralyse(3)
				M.Weaken(5)
		var/datum/organ/external/affecting = M:get_organ("chest")
		if(!(affecting.status & ORGAN_ROBOT)) //There is no blood in protheses.
			affecting.status |= ORGAN_BLEEDING
			affecting.createwound( CUT, src.force )
			if(prob(40))
				affecting.implants += src
				for(var/mob/O in (viewers(M)))
					O.show_message("<span class='danger'>\The [src] sticks deep in the wound!</span>", 1)
				H.verbs += /mob/proc/yank_out_object
				src.add_blood(H)
				if(ismob(src.loc))
					var/mob/living/E = src.loc
					E.drop_item()
				src.loc = M
			M:UpdateDamageIcon()
	else
		M.take_organ_damage(8)
	return
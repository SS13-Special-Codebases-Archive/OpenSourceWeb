/mob/living/carbon/human/verb/hug()
	set name = "Hug"
	set src in oview(1,usr)
	if(!isliving(src) || !isliving(usr))
		return
	if(emote_cooldown > 0)
		return
	emote_cooldown += 3
	src.visible_message("<span class='examinebold'>[usr]</span><span class='examine'> hugs </span><span class='examinebold'> \the [src]</span>")
	if(ishuman(src))
		src.add_event("hug", /datum/happiness_event/hug)
	if(istype(src, /mob/living/carbon/human/monster/arellit))
		var/mob/living/carbon/human/monster/arellit/A = src
		A.tame_attempt(usr)

/mob/living/carbon/human/verb/spitonsomeone()
	set name = "SpitOnSomeone"
	set src in oview(1,usr)
	if(!isliving(src) || !isliving(usr))
		return
	if(emote_cooldown > 0)
		return
	emote_cooldown += 3
	src.visible_message("<span class='examinebold'>[usr]</span><span class='examine'> spits on </span><span class='examinebold'>[src]</span>")
	playsound(src.loc, 'sound/voice/spit.ogg', 50, 0, -1)

/mob/living/carbon/human/verb/bow()
	set name = "Bow"
	set src in oview(9,usr)
	if(!isliving(src) || !isliving(usr))
		return
	if(emote_cooldown > 0)
		return
	emote_cooldown += 3
	src.visible_message("<span class='examinebold'>[usr]</span><span class='examine'> bows to </span><span class='examinebold'>[src]</span>")
	if(ishuman(src))
		if(src.royalty)
			src.add_event("respect", /datum/happiness_event/respect)

/mob/living/carbon/human/verb/kiss()
	set name = "Kiss"
	set src in oview(1,usr)
	if(!isliving(src) || !isliving(usr))
		return
	if(emote_cooldown > 0)
		return
	if(src.wear_mask && src.wear_mask.flags & MASKCOVERSMOUTH)
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] my mask is in the way!</span>")
		return
	emote_cooldown += 3
	var/mob/living/carbon/human/H = usr
	var/textKiss = "feet"
	if(src.shoes)
		textKiss = "shoes"
	if(H.zone_sel.selecting == "l_foot" || H.zone_sel.selecting == "r_foot" || ((!src.resting || !src.lying) && (usr.resting || usr.lying)))
		src.visible_message("<span class='examinebold'>[usr]</span><span class='examine'> kisses </span><span class='examinebold'>[src]</span><span class='examine'>'s [textKiss]</span>")
		if(ishuman(src))
			if(src.royalty)
				src.add_event("respect", /datum/happiness_event/respect)
	else
		if(H.zone_sel.selecting == "r_hand" || H.zone_sel.selecting == "l_hand")
			src.visible_message("<span class='examinebold'>[usr]</span><span class='examine'> kisses </span><span class='examinebold'>[src]</span><span class='examine'>'s hand</span>")
		else
			src.visible_message("<span class='examinebold'>[usr]</span><span class='examine'> kisses </span><span class='examinebold'>[src]</span>")
			playsound(src.loc, 'sound/voice/kiss.ogg', 40, 0, -1)
			if(H?.mind?.succubus)
				if(!src.check_event(H.real_name))
					to_chat(src, "<span class='horriblestate' style='font-size: 200%;'><b><i>I NEED TO FUCK [H]!</i></b></span>")
					src.my_stats.st -= 3
					src.my_stats.dx -= 3
				H.succubus_mood(src)
			if(H.gender == FEMALE)
				if(src.gender == MALE || src.gender == FEMALE && src.has_penis() || src.isFemboy())
					if(src.vice == "Addict (Kisses)")
						src.clear_event("vice")
						src.viceneed = 0
			if(H.has_penis())
				if(src.gender == FEMALE)
					if(src.vice == "Addict (Kisses)")
						src.clear_event("vice")
						src.viceneed = 0
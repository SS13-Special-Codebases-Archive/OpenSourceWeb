/mob/proc/flash_pain()
	flick("pain", pain)

/mob/proc/flash_weak_pain()
	flick("weak_pain", pain)

/mob/proc/flash_weaker_pain()
	flick("weaker_pain", pain)

/mob/proc/flash_weakest_pain()
	flick("weakest_pain", pain)

/mob/proc/flash_integralist_pain()
	flick("integralist_pain", pain)

mob/var/list/pain_stored = list()
mob/var/last_pain_message = ""
mob/var/next_pain_time = 0
mob/var/next_pain_time_custom = 0
mob/var/last_pain_message_custom = ""

// partname is the name of a body part
// amount is a num from 1 to 100
mob/living/carbon/proc/pain(var/partname, var/amount, var/force, var/burning = 0)
	if(stat >= 2) return
	if(iszombie(src)) return
	if(ismonster(src)) return
	if(ishuman(src))
		var/mob/living/carbon/human/HH = src
		if(HH.consyte)
			return
	if(status_flags & STATUS_NO_PAIN) return
	if(species && species.flags & NO_PAIN) return

	if(reagents.has_reagent("paracetamol"))
		return
	if(reagents.has_reagent("tramadol"))
		return
	if(reagents.has_reagent("dentrine"))
		return
	if(reagents.has_reagent("oxycodone"))
		return
	if(reagents.has_reagent("morphine"))
		return
	if(analgesic)
		return
	if(world.time < next_pain_time && !force)
		return
	if(amount > 10 && istype(src,/mob/living/carbon/human))
		if(src:paralysis)
			src:paralysis = max(0, src:paralysis-round(amount/10))
	if(amount > 50 && prob(amount / 5))
		src:drop_item()
	var/msg
	if(burning)
		switch(amount)
			if(1 to 10)
				flash_weakest_pain()
				msg = "<span class='combatglow'>My [partname] burns.</span>"
			if(10 to 20)
				flash_weaker_pain()
				msg = "<span class='combatglow'>My [partname] burns!</span>"
				if(prob(5))
					emote("agonyscream")
			if(20 to 30)
				flash_weak_pain()
				msg = "<span class='combatglow'>My [partname] burns badly!</span>"
				if(prob(10))
					emote("agonyscream")
			if(30 to 10000)
				flash_pain()
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					msg = "<span class='combatbold'><b>OH [uppertext(H.god_text())]! My [partname] is on fire!</b></span>"
				else
					msg = "<span class='combatbold'><b>OH GOD! My [partname] is on fire!</b></span>"
				if(prob(70))
					emote("agonyscream")
	else
		switch(amount)
			if(1 to 10)
				flash_weakest_pain()
				msg = "<span class='bname'><small>My [partname] hurts.</small></span>"
			if(10 to 20)
				flash_weaker_pain()
				msg = "<span class='bname'><small>My [partname] hurts.</small></span>"
			if(20 to 30)
				flash_weak_pain()
				msg = "<span class='bname'>My [partname] hurts badly!</span>"
			if(30 to 10000)
				flash_pain()
				if(istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					msg = "<span class='combatbold'>[pick("OH [uppertext(H.god_text())]!","WHAT A PAIN!")] My [partname]!</span>"
				else
					msg = "<span class='combatbold'>[pick("OH GOD!","WHAT A PAIN!")] My [partname]!</span>"
				if(prob(amount) && prob(20))
					emote("agonyscream")
				if(ishuman(src) && src.client)
					if(prob(15))
						var/mob/living/carbon/human/H = src
						H.blur(1,50)
						to_chat(src, "You shiver in pain.")
						if(src.gender == MALE)
							playsound(src.loc, pick('painb.ogg','painb2.ogg','painb3.ogg','painb4.ogg','painb5.ogg','painb6.ogg','painb7.ogg','painb8.ogg'), 75, 0, -1)

	if(msg && (msg != last_pain_message || prob(10)))
		last_pain_message = msg
		to_chat(src, msg)
	next_pain_time = world.time + (100 - amount)


// message is the custom message to be displayed
// flash_strength is 0 for weak pain flash, 1 for strong pain flash
mob/living/carbon/human/proc/custom_pain(var/message, var/flash_strength)
	if(stat >= 1) return
	if(iszombie(src)) return
	if(ismonster(src)) return

	if(species && species.flags & NO_PAIN) return
	if(status_flags & STATUS_NO_PAIN) return

	if(reagents.has_reagent("tramadol"))
		return
	if(reagents.has_reagent("oxycodone"))
		return
	if(analgesic)
		return
	var/msg = "<b>[message]</b>"
	if(flash_strength >= 1)
		msg = "<font size=3><b>[message]</b></font>"

	// Anti message spam checks
	if(msg && ((msg != last_pain_message_custom) || (world.time >= next_pain_time_custom)))
		last_pain_message_custom = msg
		to_chat(src, msg)
	next_pain_time_custom = world.time + 100

mob/living/carbon/human/proc/handle_pain()
	// not when sleeping

	if(species && species.flags & NO_PAIN) return
	if(status_flags & STATUS_NO_PAIN) return

	if(stat >= 2) return
	if(iszombie(src)) return
	if(reagents.has_reagent("dentrine"))
		return
	if(reagents.has_reagent("tramadol"))
		return
	if(reagents.has_reagent("oxycodone"))
		return
	if(analgesic)
		return

	var/maxdam = 0
	var/datum/organ/external/damaged_organ = null

	if(organs.len)
		for(var/datum/organ/external/E in organs)
			// amputated limbs don't cause pain
			if(E.amputated) continue
			if(E.status & ORGAN_DEAD) continue
			if(E.status & ORGAN_ROBOT) continue		//Prothesis limbs now also don't cause pain
			var/dam = E.painLW
			// make the choice of the organ depend on damage,
			// but also sometimes use one of the less damaged ones
			if(dam > maxdam && (maxdam == 0 || prob(70)) )
				damaged_organ = E
				maxdam = dam
		if(damaged_organ)
			pain(damaged_organ.display_name, maxdam, 0)

	if(internal_organs.len)
		// Damage to internal organs hurts a lot.
		for(var/datum/organ/internal/I in internal_organs)
			if(I.damage > 2) if(prob(2))
				var/organ_name_capitalized
				organ_name_capitalized = uppertext(I.name)
				src.custom_pain("<span class='hugepain'>MY [organ_name_capitalized] HURTS!</span>", 1)

	var/toxDamageMessage = null
	var/toxMessageProb = 1
	switch(getToxLoss())
		if(1 to 5)
			toxMessageProb = 1
			toxDamageMessage = "<span class='lowpain'>My body stings slightly.</span>"
		if(6 to 10)
			toxMessageProb = 2
			toxDamageMessage = "<span class='lowpain'>My whole body hurts a little.</span>"
		if(11 to 15)
			toxMessageProb = 2
			toxDamageMessage = "<span class='lowpain'>My whole body hurts.</span>"
		if(15 to 25)
			toxMessageProb = 3
			toxDamageMessage = "<span class='lowpain'>My whole body hurts badly.</span>"
		if(26 to INFINITY)
			toxMessageProb = 5
			toxDamageMessage = "<span class='lowpain'>My body aches all over.</span>"
	switch(getHalLoss())
		if(1 to 15)
			flash_weakest_pain()
			if(prob(25))
				emote("agonypain")
				Weaken(3)
				Stun(5)
				halloss -= 5
		if(16 to 30)
			flash_weaker_pain()
			if(prob(50))
				emote("agonypain")
				Weaken(3)
				Stun(4)
				halloss -= 10
		if(31 to 45)
			flash_weak_pain()
			if(prob(75))
				emote("agonypain")
				Weaken(5)
				Stun(5)
				halloss -= 15
		if(46 to INFINITY)
			flash_pain()
			if(prob(100))
				emote("agonypain")
				Weaken(15)
				Stun(7)
				halloss -= 20

	if(toxDamageMessage && prob(toxMessageProb))
		src.custom_pain(toxDamageMessage, getToxLoss() >= 15)

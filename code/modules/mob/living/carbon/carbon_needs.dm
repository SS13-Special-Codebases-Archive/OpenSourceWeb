/mob/living/carbon/proc/print_happiness()
	var/msg = "<div class='firstdivmood'><div class='moodbox'>"
	msg += "<hr class='linexd'>"
	for(var/i in events)
		var/datum/happiness_event/event = events[i]
		msg += event.description
	if(!msg || !events.len)
		msg += "<span class='passiveglow'>I feel indifferent.</span>\n"

	msg += "<hr class='linexd'>"
	to_chat(src, "[msg]</div></div>")

/mob/living/carbon/human/print_happiness()
	var/msg = "<div class='firstdivmood'><div class='moodbox'>"
	var/zodiacdesc = ""
	msg += "<hr class='linexd'>"
	msg += "<span class='moodboxtext'>My name is</span><span class='[mind.say_color]'>[src.real_name]</span>\n"
	/*if(dom_hand == "Right-handed")
		msg += "<span class='moodboxtext'>I'm right-handed.</span>"
	else if (dom_hand == "Left-handed")
		msg += "<span class='moodboxtext'>I'm left-handed.</span>"
	else if (src.dom_hand == "Ambidextrous")
		msg += "I'm ambidextrous."*/ // dom_hand does nothing but i'm leaving this here for the future,remind RiotMigrant to add ambidextrous special when Foe finishes combat
	msg += "<span class='moodboxtext'>My blood type: [src.dna.b_type]. </span>"
	if(src.potenzia <=10 && src.has_penis())
		msg += "<span class='moodboxtext'>My size: small.</span>"
	else if(src.potenzia <=20 && src.has_penis())
		msg += "<span class='moodboxtext'>My size: regular.</span>"
	else if (src.potenzia >20 && src.has_penis())
		msg += "<span class='moodboxtext'>My size: large.</span>" 
	if(src.outsider && src.province && src.province != "Wanderer")
		msg += "<span class='moodboxtext'>I come from <b>[src.province]</b></span>\n"
	msg += "<br>"
	msg += "<br>"
	if(src.favorite_beverage == "Blood" || src.favorite_beverage == "Water")
		msg += "<span class='moodboxtext'>I don't have a favorite beverage.</span>"
	else
		msg += "<span class='moodboxtext'>My favorite beverage: [src.favorite_beverage]<br>"
	if(src.special)
		msg += "<span class='combat'><i>\"[src.specialdesc]\"</i></span><br>"
	switch(zodiac)
		if("Aranea")
			zodiacdesc = "(Manipulation, Lust, Stealth)"
		if("Vulpes")
			zodiacdesc = "(Contest, Risk, Selfishness)"
		if("Numis")
			zodiacdesc = "(Curiosity, Wit, Changeability)"
		if("Cygnus")
			zodiacdesc = "(Pride, Generosity, Artistry)"
		if("Gryllus")
			zodiacdesc = "(Labor, Help, Criticism)"
		if("Centaurus")
			zodiacdesc = "(Fun, Adventure, Honesty)"
		if("Sisyphus")
			zodiacdesc = "(Discipline, Power, Perseverance)"
		if("Fulgurri")
			zodiacdesc = "(Progress, Originality, Independence)"
		if("Phantom")
			zodiacdesc = "(Kindness, Escapism, Dependence)"
		if("Noctua")
			zodiacdesc = "(Diplomacy, Sophistication, Caution)"
		if("Rocca")
			zodiacdesc = "(Safety, Consistency, Equanimity)"
		if("Apis")
			zodiacdesc = "(Family, Protection, Care)"
	msg += "<span class='moodboxtext'>My age: [src.age]. My Sign: <span class='graytextbold'>[src.zodiac]</span> <span class='moodboxtext'>[zodiacdesc].</span><br>"
	msg += "<br>"
	if(src.vice)
		msg += "<span class='moodboxtext'>My vice: [src.vice]</span>"
	else
		msg += "<span class='moodboxtext'>I</span> <span class='graytextbold'>don't</span> <span class='moodboxtext'>have vices.</span>"
	msg += "<hr class='linexd'>"

	if(ismonster(src) || iszombie(src) || isVampire || src.mind.changeling)
		if(client)
			msg += "<span class='combatglow'><b>My soul is black. Humanity is alien to me.</b></span>\n"
	else
		for(var/i in events)
			var/datum/happiness_event/event = events[i]
			msg += "[event.description]"
		if(!msg || !events.len)
			msg += "<span class='passiveglow'>I feel indifferent.</span>\n"

	msg += "<hr class='linexd'>"
	to_chat(src, "[msg]</div></div>", 7)

/mob/living/carbon/proc/update_happiness()
	if(client && mind)
		if(ismonster(src) || iszombie(src) || isVampire || src.mind.changeling)
			mood_icon.icon_state = "pressure-1"
			return
	var/old_happiness = happiness
	var/old_icon = null
	if(mood_icon)
		old_icon = mood_icon.icon_state
	happiness = 0
	for(var/i in events)
		var/datum/happiness_event/event = events[i]
		happiness += event.happiness

	switch(happiness)
		if(-5000000 to MOOD_LEVEL_SAD4)
			if(mood_icon)
				mood_icon.icon_state = "pressure9"

		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			if(mood_icon)
				mood_icon.icon_state = "pressure8"

		if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
			if(mood_icon)
				mood_icon.icon_state = "pressure7"

		if(MOOD_LEVEL_SAD2 to MOOD_LEVEL_SAD1)
			if(mood_icon)
				mood_icon.icon_state = "pressure6"

		if(MOOD_LEVEL_SAD1 to MOOD_LEVEL_HAPPY1)
			if(mood_icon)
				mood_icon.icon_state = "pressure0"

		if(MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2)
			if(mood_icon)
				mood_icon.icon_state = "pressure0"

		if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
			if(mood_icon)
				mood_icon.icon_state = "pressure0"

		if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
			if(mood_icon)
				mood_icon.icon_state = "pressure0"

		if(MOOD_LEVEL_HAPPY4 to INFINITY)
			if(mood_icon)
				mood_icon.icon_state = "pressure0"

	if(old_icon && old_icon != mood_icon.icon_state)
		if(old_happiness > happiness)
			to_chat(src, "<span class='combatglow'>My mood gets worse.</span>")
		else
			to_chat(src, "<span class='passiveglow'>My mood gets better.</span>")

/mob/proc/flash_sadness()
	if(prob(2))
		flick("sadness",moodscreen)
		var/spoopysound = pick('sound/effects/badmood1.ogg','sound/effects/badmood2.ogg','sound/effects/badmood3.ogg','sound/effects/badmood4.ogg')
		sound_to(src, spoopysound)

var/list/SADLIST = list(0.3,0.3,0.3,0,\
			 			 0.3,0.3,0.3,0,\
						 0.3,0.3,0.3,0,\
						 0.0,0.0,0.0,1,)

var/list/HAPPYLIST = list( 1, 0, 0, 0,\
						 0, 1.1, 0, 0,\
					 	 0, 0, 1, 0,\
	 	 				 0, 0, 0, 1)

/mob/living/carbon/proc/handle_happiness()
	if(ticker?.eof?.id == "bluepoison")
		if(src.happiness <= MOOD_LEVEL_SAD1)
			adjustToxLoss(rand(0.2,3))
	if(iszombie(src) || isVampire)
		moodscreen?.icon_state = "blank"
		return
	if(src.mind)
		if(src.mind.changeling)
			moodscreen?.icon_state = "blank"
			return
	switch(happiness)
		if(-5000000 to MOOD_LEVEL_SAD4)
			flash_sadness()
			if(moodscreen)
				animate(moodscreen, alpha = 255, time = 10)
		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			flash_sadness()
			if(moodscreen)
				animate(moodscreen, alpha = 200, time = 10)
		if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
			flash_sadness()
			if(moodscreen)
				animate(moodscreen, alpha = 120, time = 10)
		if(MOOD_LEVEL_SAD2 to MOOD_LEVEL_SAD1)
			if(moodscreen)
				animate(moodscreen, alpha = 40, time = 10)
		if(MOOD_LEVEL_SAD1 to MOOD_LEVEL_NEUTRAL)
			if(moodscreen)
				animate(moodscreen, alpha = 0, time = 10)
		if(MOOD_LEVEL_NEUTRAL to MOOD_LEVEL_HAPPY1)
			if(moodscreen)
				animate(moodscreen, alpha = 0, time = 10)
		if(MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2)
			if(moodscreen)
				animate(moodscreen, alpha = 0, time = 10)
		if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
			if(moodscreen)
				animate(moodscreen, alpha = 0, time = 10)
		if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
			if(moodscreen)
				animate(moodscreen, alpha = 0, time = 10)
		if(MOOD_LEVEL_HAPPY4 to INFINITY)
			if(moodscreen)
				animate(moodscreen, alpha = 0, time = 10)


/mob/living/carbon/proc/add_precreated_event(category, var/datum/happiness_event/the_event) //Like below expect used for editing events during runtime.
	if(events[category])
		var/datum/happiness_event/event_check = events[category]
		if(the_event.type != event_check?.type)
			clear_event(category)
			return .()
		else
			return 0 //Don't have to update the event.

	events[category] = the_event
	update_happiness()
	if(the_event.timeout)
		spawn(the_event.timeout)
			clear_event(category)

/mob/living/carbon/proc/add_event(category, type) //Category will override any events in the same category, should be unique unless the event is based on the same thing like hunger.
	var/datum/happiness_event/the_event
	if(events[category])
		the_event = events[category]
		if(the_event?.type != type)
			clear_event(category)
			return .()
		else
			return 0 //Don't have to update the event.
	else
		the_event = new type()

	events[category] = the_event
	update_happiness()

	if(the_event.timeout)
		spawn(the_event.timeout)
			clear_event(category)

/mob/living/carbon/proc/check_event(category)
	if(category in events)
		return 1
	else
		return 0

/mob/living/carbon/proc/clear_event(category)
	var/datum/happiness_event/event = events[category]
	if(!event)
		return 0

	events -= category
	qdel(event)
	update_happiness()

/mob/living/carbon/proc/handle_hygiene()
	adjust_hygiene(-HYGIENE_FACTOR)
	var/image/smell = image('icons/effects/life/effects.dmi', "smell")//This is a hack, there has got to be a safer way to do this but I don't know it at the moment.
	switch(hygiene)
		if(HYGIENE_LEVEL_NORMAL to INFINITY)
			add_event("hygiene", /datum/happiness_event/hygiene/clean)
			overlays -= smell
		if(HYGIENE_LEVEL_DIRTY to HYGIENE_LEVEL_NORMAL)
			clear_event("hygiene")
			overlays -= smell
		if(0 to HYGIENE_LEVEL_DIRTY)
			overlays -= smell
			overlays += smell
			add_event("hygiene", /datum/happiness_event/hygiene/smelly)

/mob/living/carbon/human/handle_hygiene()
	adjust_hygiene(-HYGIENE_FACTOR)
	switch(hygiene)
		if(HYGIENE_LEVEL_NORMAL to INFINITY)
			add_event("hygiene", /datum/happiness_event/hygiene/clean)
			remove_smelly()
		if(HYGIENE_LEVEL_DIRTY to HYGIENE_LEVEL_NORMAL)
			clear_event("hygiene")
			remove_smelly()
		if(0 to HYGIENE_LEVEL_DIRTY)
			add_smelly()
			add_event("hygiene", /datum/happiness_event/hygiene/smelly)


/mob/living/carbon/proc/adjust_hygiene(var/amount)
	var/old_hygiene = hygiene
	if(amount>0)
		hygiene = min(hygiene+amount, HYGIENE_LEVEL_CLEAN)

	else if(old_hygiene)
		hygiene = max(hygiene+amount, 0)

/mob/living/carbon/proc/set_hygiene(var/amount)
	if(amount >= 0)
		hygiene = min(HYGIENE_LEVEL_CLEAN, amount)


/mob/living/carbon/human/say(var/message, var/customVerbs = null)

	var/verb = "says"
	var/alt_name = ""
	var/message_range = world.view
	var/italics = 0

	if(client)
		if(client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (Muted)."
			return

	message =  trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(stat == 2)
		return say_dead(message)

	if(iszombie(src))
	/*
		if (message && !(copytext_char(message, 1, 3) == ":z"))
			if (copytext_char(message, 1, 2) == "*" && !stat)
				return emote(copytext_char(message, 2))
			else
				emote(pick("z_roar","z_shout","z_mutter"))
				return*/
		if(message)
			if(prob(15))
				message = pick("...Brains...", "...Meaaat...", "...Brains..")
			else
				emote(pick("z_roar","z_shout","z_mutter"))
				return

	var/message_mode = parse_message_mode(message, "headset")

	if(copytext_char(message,1,2) == "*")
		return emote(copytext_char(message,2))

	if(copytext_char(message,1,2) == "+")
		return whisper_say(copytext_char(message,2))
	//if(copytext_char(message,1,6) == "poison*")
	//	verb = "<font color='green'>poisons</font>"
/*
	if(name != GetVoice())
		alt_name = "(as [get_id_name("Unknown")])"
*/
	//parse the radio code and consume it
	if (message_mode)
		if (message_mode == "headset")
			message = copytext_char(message,2)	//it would be really nice if the parse procs could do this for us.
		else
			message = copytext_char(message,3)

	var/datum/organ/external/affecting = get_organ("throat")
	//parse the language code and consume it
	var/datum/language/speaking = parse_language(message)
	if(speaking)
		message = copytext_char(message,3)
	else if(species.default_language)
		speaking = all_languages[species.default_language]

	var/ending = copytext_char(message, length(message))
	if (speaking)
		// This is broadcast to all mobs with the language,
		// irrespective of distance or anything else.
		if(speaking.flags & HIVEMIND)
			speaking.broadcast(src,trim(message))
			return
		//If we've gotten this far, keep going!
		verb = speaking.get_spoken_verb(ending)
	else
		if(ending=="!")
			message = "<span class='commsbold'>[message]</span>"
			verb = say_quote("<span class='commsbold'>[message]</span>", speaking)
			to_chat(usr, message)
			to_chat(src, message)
		if(ending=="?")
			verb="asks"

	if (istype(wear_mask, /obj/item/clothing/mask/muzzle))
		return

	var/datum/organ/external/mouth = get_organ("mouth")
	if(mouth.status & ORGAN_DESTROYED)
		to_chat(src, "<span class='combatbold'>I have a little problem with my mouth!</span>")
		return

	if(grabbed_by.len)
		for(var/x = 1; x <= grabbed_by.len; x++)
			if(grabbed_by[x])
				if(istype(grabbed_by[x], /obj/item/weapon/grab))
					var/obj/item/weapon/grab/G = grabbed_by[x]

					if(G.aforgan.display_name == "mouth")
						to_chat(src, "<span class='combatbold'>Something is holding your mouth!</span>")
						playsound(src.loc, pick('sound/voice/headinhands01.ogg', 'sound/voice/headinhands02.ogg', 'sound/voice/headinhands03.ogg', 'sound/voice/headinhands04.ogg' , 'sound/voice/headinhands05.ogg', 'sound/voice/headinhands06.ogg' ,'sound/voice/headinhands07.ogg' ,'sound/voice/headinhands08.ogg'), 50, 0, -1)
						return

	message = capitalize(trim(message))
	if(affecting.hasVocal && affecting.VocalTorn)
		message = NoChords(message, 100)

	if(province == "Salar" || h_style == "Forelock")
		message = salarTalk(message)

	if(province == "Wei-Ji Burrows" || voicetype == "gink")
		message = ginkTalk(message)

	if(speech_problem_flag)
		var/list/handle_r = handle_speech_problems(message)
		message = handle_r[1]
		verb = handle_r[2]
		speech_problem_flag = handle_r[3]

	if(!message || stat)
		return

	var/list/obj/item/used_radios = new

	switch (message_mode)
		if("headset")
			if(l_ear && istype(l_ear,/obj/item/device/radio))
				var/obj/item/device/radio/R = l_ear
				R.talk_into(src,message,null,verb,speaking)
				used_radios += l_ear
			else if(r_ear && istype(r_ear,/obj/item/device/radio))
				var/obj/item/device/radio/R = r_ear
				R.talk_into(src,message,null,verb,speaking)
				used_radios += r_ear
			else if(wrist_r && istype(wrist_r,/obj/item/device/radio/headset/bracelet))
				if(stuttering)
					if(ending != "!")
						message = stutter(message)
						verb = pick("stammers","stutters")
					else
						message = "<span class='saybold'>[message]</span>"
						verb = pick("stammers loudly","stutters loudly")
				var/obj/item/device/radio/R = wrist_r
				R.talk_into(src,message,null,verb,speaking)
				used_radios += wrist_r
			else if(wrist_l && istype(wrist_l,/obj/item/device/radio/headset/bracelet))
				if(stuttering)
					if(ending != "!")
						message = stutter(message)
						verb = pick("stammers","stutters")
					else
						message = "<span class='saybold'>[message]</span>"
						verb = pick("stammers loudly","stutters loudly")
				var/obj/item/device/radio/R = wrist_l
				R.talk_into(src,message,null,verb,speaking)
				used_radios += wrist_l



		if("right ear")
			var/obj/item/device/radio/R
			var/has_radio = 0
			if(r_ear && istype(r_ear,/obj/item/device/radio))
				R = r_ear
				has_radio = 1
			if(r_hand && istype(r_hand, /obj/item/device/radio))
				R = r_hand
				has_radio = 1
			if(has_radio)
				R.talk_into(src,message,null,verb,speaking)
				used_radios += R


		if("left ear")
			var/obj/item/device/radio/R
			var/has_radio = 0
			if(l_ear && istype(l_ear,/obj/item/device/radio))
				R = l_ear
				has_radio = 1
			if(l_hand && istype(l_hand,/obj/item/device/radio))
				R = l_hand
				has_radio = 1
			if(has_radio)
				R.talk_into(src,message,null,verb,speaking)
				used_radios += R

		if("intercom")
			for(var/obj/item/device/radio/intercom/I in view(1, null))
				I.talk_into(src, message, verb, speaking)
				used_radios += I
		if("whisper")
			whisper_say(message, speaking, alt_name)
			return
		else
			if(message_mode)
				if(l_ear && istype(l_ear,/obj/item/device/radio))
					l_ear.talk_into(src,message, message_mode, verb, speaking)
					used_radios += l_ear
				else if(r_ear && istype(r_ear,/obj/item/device/radio))
					r_ear.talk_into(src,message, message_mode, verb, speaking)
					used_radios += r_ear
				else if(wrist_l && istype(wrist_l,/obj/item/device/radio))
					wrist_l.talk_into(src,message, message_mode, verb, speaking)
					used_radios += wrist_l
				else if(wrist_r && istype(wrist_r,/obj/item/device/radio))
					wrist_r.talk_into(src,message, message_mode, verb, speaking)
					used_radios += wrist_r


	var/sound/speech_sound
	var/sound_vol
	if(species.speech_sounds && prob(species.speech_chance))
		speech_sound = sound(pick(species.speech_sounds))
		sound_vol = 50

	if(customVerbs)
		verb = customVerbs
	//speaking into radios
	if(used_radios.len)
		italics = 1
		message_range = 1

		for(var/mob/living/M in hearers(5, src))
			if(M != src)
				M.show_message("<span class='passivebold'>[src]</span> <span class='passive'>talks into the bracelet</span>")
			if (speech_sound)
				sound_vol *= 0.5

	sound2()
	if(findtext(message,"gmyza"))
		for(var/mob/living/carbon/human/M in hearers(9, src))
			if(M != src)
				M.add_event("gmyza",/datum/happiness_event/gmyza)
			else
				M.clear_event("gmyza")

	if(findtext(message,"copetti"))
		for(var/mob/living/carbon/human/M in hearers(9, src))
			if(M != src)
				M.add_event("gmyza",/datum/happiness_event/copetti)
			else
				M.clear_event("gmyza")
	if(src.old_ways.god == "Xom")
		..("[pick(xomPhrases)]", speaking, verb, alt_name, italics, message_range, speech_sound, sound_vol)	//ohgod we should really be passing a datum here.
	else
		..("[message]", speaking, verb, alt_name, italics, message_range, speech_sound, sound_vol)	//ohgod we should really be passing a datum here.

/mob/living/carbon/human/proc/forcesay(var/append)
	if(stat == CONSCIOUS)
		if(client)
			var/virgin = 1	//has the text been modified yet?
			var/temp = winget(client, "saybox", "text")
			if(length(temp) > 5)	//case sensitive means

				temp = replacetext(temp, ";", "")	//general radio

				if(findtext(trim_left(temp), ":", 6, 7))	//dept radio
					temp = copytext_char(trim_left(temp), 8)
					virgin = 0

				if(virgin)
					temp = copytext_char(trim_left(temp), 6)	//normal speech
					virgin = 0

				while(findtext(trim_left(temp), ":", 1, 2))	//dept radio again (necessary)
					temp = copytext_char(trim_left(temp), 3)

				if(findtext(temp, "*", 1, 2))	//emotes
					return
				temp = copytext_char(trim_left(temp), 1, rand(5,8))

				var/trimmed = trim_left(temp)
				if(length(trimmed))
					if(append)
						temp += append

					say(temp)
				winset(client, "saybox", "text=[null]")

/mob/living/carbon/human/say_understands(var/mob/other,var/datum/language/speaking = null)

	if(has_brain_worms()) //Brain worms translate everything. Even mice and alien speak.
		return 1

	if(species.can_understand(other))
		return 1

	//These only pertain to common. Languages are handled by mob/say_understands()
	if (!speaking)
		if (istype(other, /mob/living/carbon/alien/diona))
			if(other.languages.len >= 2) //They've sucked down some blood and can speak common now.
				return 1
		if (istype(other, /mob/living/silicon))
			return 1
		if (istype(other, /mob/living/carbon/brain))
			return 1

	//This is already covered by mob/say_understands()
	//if (istype(other, /mob/living/simple_animal))
	//	if((other.universal_speak && !speaking) || src.universal_speak || src.universal_understand)
	//		return 1
	//	return 0

	return ..()


/mob/living/carbon/human/verb/disguiseVoice()
	set name = "disguiseVoice"
	set background = 1
	if(disguising_voice)
		to_chat(src, "You're no longer trying to disguise your voice.")
		disguising_voice = FALSE
	else
		to_chat(src, "You're now trying to disguise your voice.")
		disguising_voice = TRUE

/mob/living/carbon/human/var/truthcooldown = 0
/mob/living/carbon/human/proc/tellTheTruth()
	set name = "tellTheTruth"
	set background = 1
	if(truthcooldown)
		return
	say(pick(bumquotes))
	truthcooldown = 1
	spawn(12)
		truthcooldown = FALSE

/mob/living/carbon/human/GetVoice()
	if(istype(src.wear_mask, /obj/item/clothing/mask/gas/voice))
		var/obj/item/clothing/mask/gas/voice/V = src.wear_mask
		if(V.vchange)
			return V.voice
		else
			return name
	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
	if(GetSpecialVoice())
		return GetSpecialVoice()
	if(stealth || brothelstealth)
		return "R a t"
	if(disguising_voice)
		return "[ageAndGender2Desc(src.age, src.gender)] #[disguise_number]"
	return real_name

/mob/living/carbon/human/proc/SetSpecialVoice(var/new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice

/mob/living/carbon/human/proc/handle_speech_problems(var/message)
	var/list/returns[3]
	var/verb = "says"
	var/handled = 0
	if(silent)
		message = ""
		handled = 1
	if(sdisabilities & MUTE)
		message = ""
		handled = 1
	if(wear_mask)
		if(istype(wear_mask, /obj/item/clothing/mask/horsehead))
			var/obj/item/clothing/mask/horsehead/hoers = wear_mask
			if(hoers.voicechange)
//				if(mind && mind.changeling && department_radio_keys[copytext_char(message, 1, 3)] != "changeling")
				message = pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
				verb = pick("whinnies","neighs", "says")
				handled = 1

	if((HULK in mutations) && health >= 25 && length(message))
		message = "[uppertext(message)]!!!"
		verb = pick("yells","roars","hollers")
		handled = 1
/*	if(slurring)
		message = slur(message)
		verb = pick("stammers","stutters")		//Bydlocoded it into living/say.dm
		handled = 1
*/
	var/braindam = getBrainLoss()
	if(braindam >= 60)
		handled = 1
		if(prob(braindam/4))
			message = stutter(message)
			verb = pick("stammers", "stutters")
		if(prob(braindam))
			message = uppertext(message)
			verb = pick("yells like an idiot","says rather loudly")

	returns[1] = message
	returns[2] = verb
	returns[3] = handled

	return returns

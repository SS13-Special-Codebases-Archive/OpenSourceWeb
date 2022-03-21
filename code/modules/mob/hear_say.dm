// At minimum every mob has a hear_say proc.
/mob/var/comic_sans = FALSE

/mob/proc/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol, var/ending = copytext_char(message, length(message)))
	if(!client)
		return

	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		if(H.mrlonely && !speaker == H)
			return
	if(speaker && !speaker.client && istype(src,/mob/dead/observer) && client.prefs.toggles & CHAT_GHOSTEARS && !speaker in view(src))
			//Does the speaker have a client?  It's either random stuff that observers won't care about (Experiment 97B says, 'EHEHEHEHEHEHEHE')
			//Or someone snoring.  So we make it where they won't hear it.
		return

	//make sure the air can transmit speech - hearer's side
	var/turf/T = get_turf(src)
	if (T)
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment)? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE && get_dist(speaker, src) > 1)
			return

		if (pressure < ONE_ATMOSPHERE*0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
			italics = 1
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

	if(sleeping || stat == 1)
		hear_sleep(message)
		return

	//var/style = "body"

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.flags & NONVERBAL))
		if (!speaker || (src.sdisabilities & BLIND || src.blinded) || !(speaker in view(src)))
			message = stars(message)

	if(!say_understands(speaker,language))
		if(istype(speaker,/mob/living/simple_animal))
			var/mob/living/simple_animal/S = speaker
			message = pick(S.speak)
		else
			message = stars(message)

	/*if(language)
		style = language.colour*/

	var/speaker_name = speaker.name
	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()

	if(italics)
		message = "<i>[message]</i>"

	var/track = null

	if(sdisabilities & DEAF || ear_deaf)
		if(speaker == src)
			return
			//to_chat(src , "<span class='warning'>You cannot hear yourself speak!</span>")
		else
			return
			//to_chat(src , "<span class='name'>[speaker_name]</span>[alt_name] talks but you cannot hear \him.")
	else
		if(speaker.comic_sans)
			to_chat(src , "<p style=\"font-family: 'Comic Sans MS', cursive, sans-serif; display: inline\"><span class='say'><span class='[speaker.mind.say_color]'>[speaker_name]</span>[alt_name] [track]<span class='sayverb'>[verb],</span> <span class='saybasic'>\"[message]\"</span></p>")
		else
			if(src.voicetype == "strong" || src.voicetype == "noble" && src.gender == "male")
				if(ending != "!")
					if(prob(15))
						to_chat(src , "<span class='say'><span class='[speaker.mind.say_color]'>[speaker_name]</span>[alt_name] [track]<span class='saybigger'><i>[verb],</i></span> <span class='saybigger'>\"[message]\"</span>")
						return
			to_chat(src , "<span class='say'><span class='[speaker.mind.say_color]'>[speaker_name]</span>[alt_name] [track]<span class='sayverb'>[verb],</span> <span class='saybasic'>\"[message]\"</span>")
		if (speech_sound && (get_dist(speaker, src) <= world.view && src.z == speaker.z))
			var/turf/source = speaker? get_turf(speaker) : get_turf(src)
			src.playsound_local(source, speech_sound, sound_vol, 1)
		for(var/obj/item/device/cellphone/PHONE in range(src,1))
			if(PHONE.rimcard?.in_call)
				if(PHONE.rimcard?.called_who)
					to_chat(PHONE.rimcard.called_who.Phone.loc, "[icon2html(PHONE, PHONE.rimcard.called_who.Phone.loc)]<span class='say'><font color='green'>Caller</font></span> <span class='sayverb'><i><font color='green'>[verb],</font></i></span> <span class='saybasic'><font color='green'>\"[message]\"</font></span>")
				if(PHONE.rimcard?.called_by)
					to_chat(PHONE.rimcard.called_by.Phone.loc, "[icon2html(PHONE, PHONE.rimcard.called_by.Phone.loc)]<span class='say'><font color='green'>Caller</font></span> <span class='sayverb'><i><font color='green'>[verb],</font></i></span> <span class='saybasic'><font color='green'>\"[message]\"</font></span>")

/mob/proc/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="")

	if(!client)
		return

	if(!istype(src, /mob/dead/observer/))
		playsound(loc, "radio", 25, 1, -1)//They won't always be able to read the message, but the sound will play regardless.

	if(sleeping || stat==1) //If unconscious or sleeping
		hear_sleep(message)
		return

	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		if(H.mrlonely && !speaker == H)
			return

	var/track = null

	var/style = "body"

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.flags & NONVERBAL))
		if (!speaker || (src.sdisabilities & BLIND || src.blinded) || !(speaker in view(src)))
			message = stars(message)

	if(!say_understands(speaker,language))
		if(istype(speaker,/mob/living/simple_animal))
			var/mob/living/simple_animal/S = speaker
			message = pick(S.speak)
		else
			message = stars(message)

	if(language)
		style = language.colour

	if(hard_to_hear)
		message = stars(message)

	var/speaker_name = speaker.name

	if(vname)
		speaker_name = vname

	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		if(H.voice)
			speaker_name = H.voice

	if(hard_to_hear)
		speaker_name = "unknown"

	var/changed_voice

	if(istype(src, /mob/living/silicon/ai) && !hard_to_hear)
		var/jobname // the mob's "job"
		var/mob/living/carbon/human/impersonating //The crewmember being impersonated, if any.

		if (ishuman(speaker))
			var/mob/living/carbon/human/H = speaker

			if((H.wear_id && istype(H.wear_id,/obj/item/weapon/card/id/syndicate)) && (H.wear_mask && istype(H.wear_mask,/obj/item/clothing/mask/gas/voice)))

				changed_voice = 1
				var/mob/living/carbon/human/I = locate(speaker_name)

				if(I)
					impersonating = I
					jobname = impersonating.get_assignment()
				else
					jobname = "Unknown"
			else
				jobname = H.get_assignment()

		else if (iscarbon(speaker)) // Nonhuman carbon mob
			jobname = "No id"
		else if (isAI(speaker))
			jobname = "AI"
		else if (isrobot(speaker))
			jobname = "Cyborg"
		else if (istype(speaker, /mob/living/silicon/pai))
			jobname = "Personal AI"
		else
			jobname = "Unknown"

		if(changed_voice)
			if(impersonating)
				track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[impersonating]'>[speaker_name] ([jobname])</a>"
			else
				track = "[speaker_name] ([jobname])"
		else
			track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[speaker]'>[speaker_name] ([jobname])</a>"

	if(istype(src, /mob/dead/observer))
		if(speaker_name != speaker.real_name && !isAI(speaker)) //Announce computer and various stuff that broadcasts doesn't use it's real name but AI's can't pretend to be other mobs.
			speaker_name = "[speaker.real_name] ([speaker_name])"
		//track = "[speaker_name] (<a href='byond://?src=\ref[src];track=\ref[speaker]'>follow</a>)"

	var/frases_dreamer = ""
	if(ishuman(src) && is_dreamer(src) && speaker_name != src.name)
		var/file_US = file2text('code/game/gamemodes/dreamer/RadioTrocadoUS.txt')
		frases_dreamer = pick(splittext(file_US, "\n"))

	if(sdisabilities & DEAF || ear_deaf)
		if(prob(20))
			to_chat(src, "<span class='warning'>You feel your headset vibrate but can hear nothing from it!</span>")
	else if(track)
		to_chat(src, "[part_a][track][part_b][verb], <span class=\"[style]\">\"[message][frases_dreamer]\"</span></span></span>")
	else
		to_chat(src, "[part_a][speaker_name][part_b][verb], <span class=\"[style]\">\"[message][frases_dreamer]\"</span></span></span>")

/mob/proc/hear_signlang(var/message, var/verb = "gestures", var/datum/language/language, var/mob/speaker = null)
	if(!client)
		return

	if(say_understands(speaker, language))
		message = "<B>[src]</B> [verb], \"[message]\""
	else
		message = "<B>[src]</B> [verb]."

	if(src.status_flags & PASSEMOTES)
		for(var/obj/item/mob_holder/H in src.contents)
			H.show_message(message)
		for(var/mob/living/M in src.contents)
			M.show_message(message)
	src.show_message(message)

/mob/proc/hear_sleep(var/message)
	var/heard = ""
	if(prob(1))
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = text2list(message, " ")
		var/R = rand(1, messages.len)
		var/heardword = messages[R]
		if(copytext_char(heardword,1, 1) in punctuation)
			heardword = copytext_char(heardword,2)
		if(copytext_char(heardword,-1) in punctuation)
			heardword = copytext_char(heardword,1,length(heardword))
		heard = "<span class = 'passivesmaller'>...You hear something about...</span><span class='passiveboldsmaller'>[heardword]</span>"

	else
		heard = "<span class = 'passivesmaller'>...<i>You almost hear someone talking</i>...</span>"

	to_chat(src, heard)

/mob/proc/say()
	return

/mob/verb/whisper()
	set name = "Whisper"
	set category = "IC"
	return

/mob/verb/focussay()
	set name = "focussay"
	if(!client)
		return

	winset(client, "outputwindow.saybox", "focus=true")
	set_typing_indicator(0)

/mob/living/carbon/human
	var/image/chatIcon //TALVEZ ISSO SEJA CAGADO MAS FODASE NAO VOU PROCURAR O DO SS13

/mob/living/carbon/human/proc/update_saychat()
	overlays_standing[40] = null
	if(!client) return
	if(stat != CONSCIOUS) return
	if(sleeping) return

	var/T = winget(client, "outputwindow.saybox", "text")
	var/ending = copytext_char(T, length(T))
	if(!ending) return

	var/icontogo = "typing"
	switch(ending)
		if("?")
			icontogo = "h1"
		if("!")
			icontogo = "h2"

	chatIcon = image(icon = 'icons/mob/talk.dmi', loc = src, icon_state = icontogo, layer = layer, dir = dir)
	overlays_standing[40] = chatIcon

	spawn(10)
		overlays_standing[40] = null

/mob/living/carbon/human/New()
	..()
	spawn while(!bot)
		sleep(40)
		update_saychat()

client/var/say_focus = FALSE
/mob/verb/setfocus(focus as num)
	client?.say_focus = focus

/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"
	usr.say(message)
	if(!client || client.say_focus)
		return
	set_typing_indicator(0)
	winset(client, "mapwindow.map", "focus=true")

/mob/living/carbon/human/say_verb(message as text)
	..()
	var/mob/living/carbon/human/H = src
	H.update_saychat()



/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"

	message = trim(sanitize(message))

	set_typing_indicator(0)

	if(use_me)
		usr.emote("me",usr.emote_type,message)
	else
		usr.emote(message)

/mob/proc/say_dead(var/message)
	var/name = src.real_name
	//var/alt_name = ""

	if(!src.client.holder)
		if(!dsay_allowed)
			src << "\red Deadchat is globally muted"
			return

	if(client && !(client.prefs.toggles & CHAT_DEAD))
		usr << "\red You have deadchat muted."
		return

	if(mind && mind.name)
		name = "[mind.name]"
	else
		name = real_name

	var/rendered = "<span class='bname'>[name]</span> <i>[pick("moans","whines","laments","blubbers")],</i> \"[message]\""

	for(var/mob/M in range(src,9))
		if(istype(M, /mob/new_player))
			continue
		if(M.client && M.stat == DEAD && (M.client.prefs.toggles & CHAT_DEAD))
			to_chat(M, rendered)
			continue
	for(var/mob/M in player_list)
		if(M.client && M.client.holder && (M.client.prefs.toggles & CHAT_DEAD) ) // Show the message to admins/mods with deadchat toggled on
			to_chat(M, rendered)	//Admins can hear deadchat, if they choose to, no matter if they're blind/deaf or not.


	return

/mob/proc/say_understands(var/mob/other,var/datum/language/speaking = null)

	if (src.stat == 2)		//Dead
		return 1

	//Universal speak makes everything understandable, for obvious reasons.
	else if(src.universal_speak || src.universal_understand)
		return 1

	//Languages are handled after.
	if (!speaking)
		if(!other)
			return 1
		if(other.universal_speak)
			return 1
		if(isAI(src) && ispAI(other))
			return 1
		if (istype(other, src.type) || istype(src, other.type))
			return 1
		return 0

	//Language check.
	for(var/datum/language/L in src.languages)
		if(speaking.name == L.name)
			return 1

	return 0

/*
   ***Deprecated***
   let this be handled at the hear_say or hear_radio proc
   This is left in for robot speaking when humans gain binary channel access until I get around to rewriting
   robot_talk() proc.
   There is no language handling build into it however there is at the /mob level so we accept the call
   for it but just ignore it.
*/

/mob/proc/say_quote(var/message, var/datum/language/speaking = null)
	var/verb = "says"
	var/ending = copytext_char(message, length(message))
	if(ending=="!")
		verb=pick("exclaims","shouts","yells")
	else if(ending=="?")
		verb="asks"
	return verb


/mob/proc/emote(var/act, var/type, var/message)
	if(act == "me")
		return custom_emote(type, message)

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/mob/proc/say_test(var/text)
	var/ending = copytext_char(text, length(text))
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

//parses the message mode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the message mode string or null for no message mode.
//standard mode is the mode returned for the special ';' radio code.
/mob/proc/parse_message_mode(var/message, var/standard_mode="headset")
	if(length(message) >= 1 && copytext_char(message,1,2) == ";")
		return standard_mode

	if(length(message) >= 2)
		var/channel_prefix = copytext_char(message, 1 ,3)
		return department_radio_keys[channel_prefix]

	return null

//parses the language code (e.g. :j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise null.
/mob/proc/parse_language(var/message)
	if(length(message) >= 2)
		var/language_prefix = lowertext(copytext_char(message, 1 ,3))
		var/datum/language/L = language_keys[language_prefix]
		if (can_speak(L))
			return L

	return null

#define TYPING_INDICATOR_LIFETIME 30 * 10	//grace period after which typing indicator disappears regardless of text in chatbar

mob/var/hud_typing = 0 //set when typing in an input window instead of chatline
mob/var/typing
mob/var/last_typed
mob/var/last_typed_time

var/global/image/typing_indicator

/mob/proc/set_typing_indicator(var/state)

	if(!typing_indicator)
		typing_indicator = image('icons/mob/talk.dmi', null, "typing", MOB_LAYER + 1)
		typing_indicator.appearance_flags = RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|RESET_ALPHA

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.sdisabilities & MUTE || H.silent)
			overlays -= typing_indicator
			return

	if(client)
		if((client.prefs.toggles & SHOW_TYPING) || stat != CONSCIOUS)
			overlays -= typing_indicator
		else
			if(state)
				if(!typing)
					overlays += typing_indicator
					typing = 1
			else
				if(typing)
					overlays -= typing_indicator
					typing = 0
			return state

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	set_typing_indicator(1)
	hud_typing = 1
	var/message = input("","say (text)") as null|text
	hud_typing = 0
	set_typing_indicator(0)
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	set_typing_indicator(1)
	hud_typing = 1
	var/message = input("","me (text)") as null|text
	hud_typing = 0
	set_typing_indicator(0)
	if(message)
		me_verb(message)

/mob/verb/create_indicator()
	set name = ".create_indicator"
	set hidden = 1

	set_typing_indicator(1)

/mob/verb/destroy_indicator()
	set name = ".destroy_indicator"
	set hidden = 1
	set_typing_indicator(0)
	setfocus(0)

/mob/proc/handle_typing_indicator()
	if(client)
		if(!(client.prefs.toggles & SHOW_TYPING) && !hud_typing)
			var/temp = winget(client, "input", "text")

			if (temp != last_typed)
				last_typed = temp
				last_typed_time = world.time

			if (world.time > last_typed_time + TYPING_INDICATOR_LIFETIME)
				set_typing_indicator(0)
				return
			if(length(temp) > 5 && findtext(temp, "Say \"", 1, 7))
				set_typing_indicator(1)
			else if(length(temp) > 3 && findtext(temp, "Me ", 1, 5))
				set_typing_indicator(1)

			else
				set_typing_indicator(0)
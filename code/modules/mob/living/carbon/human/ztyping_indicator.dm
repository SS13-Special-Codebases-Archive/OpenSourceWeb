/mob/living/carbon/human/set_typing_indicator(var/state)

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
					overlays_standing[TYPINGINDICATOR_LAYER] = null
					overlays_standing[TYPINGINDICATOR_LAYER] = typing_indicator
					typing = 1
					update_icons()
			else
				if(typing)
					overlays_standing[TYPINGINDICATOR_LAYER] = null
					typing = 0
					update_icons()
			return state
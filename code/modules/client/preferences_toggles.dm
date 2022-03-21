//toggles

/client/verb/toggletitlemusic()
	set name = "LobbyMusic"
	set category = "Preferences"
	set desc = "Toggles hearing the GameLobby music"
	prefs.toggles ^= SOUND_LOBBY
	prefs.save_preferences()
	if(prefs.toggles & SOUND_LOBBY)
		to_chat(src, "You will now hear music in the game lobby.")
		if(istype(mob, /mob/new_player))
			playtitlemusic()
	else
		to_chat(src, "You will no longer hear music in the game lobby.")
		if(istype(mob, /mob/new_player))
			src << sound(null, repeat = 0, wait = 0, volume = prefs?.music_volume, channel = 1) // stop the jamsz

/client/verb/togglemidis()
	set name = "Midis"
	set category = "Preferences"
	set desc = "Toggles hearing sounds uploaded by admins"
	prefs.toggles ^= SOUND_MIDI
	prefs.save_preferences()
	if(prefs.toggles & SOUND_MIDI)
		to_chat(src,  "You will now hear any sounds uploaded by admins.")
		var/sound/break_sound = sound(null, repeat = 0, wait = 0, channel = 777)
		break_sound.priority = 250
		src << break_sound	//breaks the client's sound output on channel 777
	else
		to_chat(src, "You will no longer hear sounds uploaded by admins; any currently playing midis have been disabled.")
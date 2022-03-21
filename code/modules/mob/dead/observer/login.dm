/mob/dead/observer/Login()
	..()
	client.color = NOIRLIST
	add_overlay_wraith()
	src << sound(pick('ghosted1.ogg','geist.ogg','ghosted4.ogg','ghosted2.ogg'), repeat = 0, wait = 0, volume =  src?.client?.prefs?.music_volume, channel = 12)
	heartporcao()
	updatePig()
	startPig()
	if(ticker && ticker.current_state == GAME_STATE_PLAYING && master_mode == "inspector")
		to_chat(src, "\n<div class='firstdivmood'><div class='moodbox'><span class='graytext'>You may join as the Inspector or his bodyguard.</span>\n<span class='feedback'><a href='?src=\ref[src];acao=joininspectree'>1. I want to.</a></span>\n<span class='feedback'><a href='?src=\ref[src];acao=nao'>2. I'll pass.</a></span></div></div>")

/mob/living/carbon/human/Login()
	..()
	clear_fullscreen("ghost")
	src << sound(null, repeat = 0, wait = 0, volume =  0, channel = 9) // remove the ambience
	var/area/A = get_area(src)
	if(A.forced_ambience)
		var/sound/S = sound(pick(A.forced_ambience), repeat=1, wait=0, channel=9, volume=src?.client?.prefs?.music_volume)
		src << S
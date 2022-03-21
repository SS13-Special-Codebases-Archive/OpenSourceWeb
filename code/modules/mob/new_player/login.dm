/var/obj/effect/lobby_image = new/obj/effect/lobby_image()
var/interquote = pick("I hate this place and I would do anything to get out of here, may the great lord have mercy on us.",
"All pigs must die.", "There are no angels in Heaven; they're all down here.","Build your wings on the way down.","I'm a coward, stick your knife in me.",
"Happiness makes death a threat.","Three can keep a secret, if two of them are dead.","Conscious meat. Loving meat. Dreaming meat.",
"Be happy that it happened, not sad that it ends","This world is a machine! A Machine for Pigs! Fit only for the slaughtering of pigs!",
"I am begging you. You made me. You are my Creator, my Father. You cannot destroy me!","I have you now, creature. I will destroy you.",
"It is over. It is time to end this madness.","He who makes a beast of himself removes himself from the pain of being human.")
var/brquote = pick("Odeio este lugar e faria qualquer coisa para sair daqui, que o grande senhor tenha misericórdia de nós.",
"Todos os porcos devem morrer.", "Não há anjos no céu; eles estão todos aqui em baixo.", "Construa suas asas ao descer.", "Sou um covarde, enfie sua faca em mim." ,
"A morte é apenas uma ameaça por causa da felicidade.", "Três podem guardar um segredo, se dois deles estiverem mortos.", "Carne consciente. Carne que ama. Carne dos sonhos.",
"Fiquem felizes com o que aconteceu, não tristes que isso acabe", "Este mundo é uma máquina! Uma Máquina para Porcos! Destina-se apenas ao abate de porcos!",
"Eu estou te implorando. Você me fez. Você é meu Criador, meu Pai. Você não pode me destruir!", "Eu tenho você agora, criatura. Eu vou destruir você.",
"Acabou. É hora de acabar com essa loucura.", "Aquele que faz de si mesmo um animal afasta-se da dor de ser humano.")
/obj/effect/lobby_image
	name = "Farweb"
	desc = "Theatre of pain."
	icon = 'icons/misc/fullscreen.dmi'
	icon_state = "title"
	screen_loc = "WEST,SOUTH"
	plane = 300

/obj/effect/lobby_grain
	name = "Grain"
	desc = "Theatre of pain."
	icon = 'icons/misc/fullscreen.dmi'
	icon_state = "grain"
	screen_loc = "WEST,SOUTH"
	mouse_opacity = 0
	layer = MOB_LAYER+6
	plane = 300

/obj/effect/lobby_image/New()
	if(master_mode == "holywar")
		icon_state = "holywar"
	else
		icon_state = "title"
	overlays += /obj/effect/lobby_grain
	desc = vessel_name()

/mob/new_player/Login()
	..()
	if(ticker?.current_state != GAME_STATE_PLAYING)
		for(var/mob/new_player/N in mob_list)
			to_chat(N, "⠀<span class='passivebold'>[capitalize(usr.key)] joined the game.</span>")
	var/list/locinfo = client?.get_loc_info()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	winset(src, null, "mainwindow.title='Farweb'")//Making it so window is named what it's named.
	if(join_motd)
		if(guardianlist.Find(ckey(src.client.key)))
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='guardianlobby'>Guardian</span>")
		else if(src.client in admins)
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='adminlobby'>[src.client.holder.rank]</span>")
		else if(comradelist.Find(ckey(src.client.key)))
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='comradelobby'>Comrade</span>")
		else if(villainlist.Find(ckey(src.client.key)))
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='villainlobby'>Villain</span>")
		else if(pigpluslist.Find(ckey(src.client.key)))
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='graytextbold'>Experienced Pig</span>")
		else
			to_chat(src, "Welcome, <span class='graytextbold'>[capitalize(usr.ckey)]</span>! Your reliability level: <span class='graytextbold'>Pig</span>")
		to_chat(src, "Press <a href='?src=\ref[src];action=f12'>F12</a> find your death!")
		to_chat(src, "Map of the week:</span> <span class='bname'><i>[currentmaprotation]</i></span>")
		to_chat(src, "Country: <span class='bname'>[capitalize(locinfo["country"])]</span>")
		to_chat(src, "<span class='lobby'>Farweb</span>   <span class='lobbyy'>Story #[story_id]</span>")
		to_chat(src, "<span class='bname'><b>Interzone:</span></b> <i>\"[interquote]\"</i>")
	if(ticker && ticker.current_state == GAME_STATE_PLAYING && master_mode == "inspector")
		to_chat(src, "\n<div class='firstdivmood'><div class='moodbox'><span class='graytext'>You may join as the Inspector or his bodyguard.</span>\n<span class='feedback'><a href='?src=\ref[src];acao=joininspectree'>1. I want to.</a></span>\n<span class='feedback'><a href='?src=\ref[src];acao=nao'>2. I'll pass.</a></span></div></div>")


	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	if(length(newplayer_start))
		loc = pick(newplayer_start)
	else
		loc = locate(1,1,1)
	lastarea = loc

	//unlock_medal("First Timer", 0, "Welcome!", "easy")

	sight |= SEE_TURFS
	player_list |= src
	client.screen += lobby_image

/*
	var/list/watch_locations = list()
	for(var/obj/effect/landmark/landmark in landmarks_list)
		if(landmark.tag == "landmark*new_player")
			watch_locations += landmark.loc

	if(watch_locations.len>0)
		loc = pick(watch_locations)
*/
	new_player_panel()
	spawn(40)
		if(client)
			client.playtitlemusic()

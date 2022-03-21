/*************************
**************************/

mob/living/carbon/var
	image/turfimage
	is_dreaming = 0
	dreams_tick = 0

/turf/simulated/floor/var
	may_dreamer_see = 1

/turf/simulated/floor/open //Openspace buga com image por cima
	may_dreamer_see = 0


mob/living/carbon/proc/handle_dreamer()
	if(is_dreaming) return
	is_dreaming = 1
	if(client && mind && mind.special_role == "Waker")
		if(mind.special_role_dreamer_wakeup)
			spawn(0) handle_dreamer_waking_up()
		if(combat_mode)
			spawn(0)
				handle_dreamer_screenshake()
		if(dreams_tick == 2)
			dreams_tick = 0
		if(dreams_tick == 1)
			dreams_tick++
		if(dreams_tick == 0)
			dreams_tick++
		if(prob(1) && prob(40))
			handle_dreamer_mob_hallucination()

		if(prob(1))
			overlay_fullscreen("dreamer", /obj/screen/fullscreen/dreamer, rand(1,8))
			var/sweetdreams = pick('sound/lfwbsounds/comic1.ogg', 'sound/lfwbsounds/comic2.ogg', 'sound/lfwbsounds/comic3.ogg', 'sound/lfwbsounds/comic4.ogg')
			playsound_local(src, sweetdreams, 200)
			spawn(10)
				clear_fullscreen("dreamer")
			emote("scream")
			src.drop_l_hand()
			src.drop_r_hand()
		for(var/turf/simulated/floor/F in view(src,world.view)) /***************CHAO FICAR SE MEXENDO*****************/
			if(prob(40))
				if(dreams_tick == 1 && F.may_dreamer_see == 1)
					var/image/turfimagefloor
					turfimagefloor = image(F.icon, F, "[F.icon_state]", "[F.layer]")
					client.images += turfimagefloor
					var/_y = rand(-6, 6)
					if(_y > 0)
						for(var/position = 0; position < _y; position++)
							animate(turfimagefloor, pixel_y = _y, 20)
					if(_y < 0)
						for(var/position = 0; position > _y; position--)
							animate(turfimagefloor, pixel_y = _y, 20)
				if(dreams_tick == 2 && F.may_dreamer_see == 1)
					for(var/turfimagefloor in client.images)
						animate(turfimagefloor, pixel_y = 0, 20)
					spawn(20)
						client.images = null

		for(var/turf/simulated/wall/W in view(src,world.view)) /***************BOSTA NAS PAREDE*****************/
			if(prob(40))
				var/image/turfimagewall
				turfimagewall = image('icons/effects/pooeffect.dmi', W, "floor[rand(1,8)]", "[W.layer]")
				client.images += turfimagewall
				var/_y = rand(0, 4)
				for(var/position = 0; position < _y; position++)
					turfimagewall.pixel_y = position


		for(var/obj/O in view(src, world.view)) /***************OBJETOS FALANDO, ETA CODING, MAS FUNCIONA PERFEITAMENTE*****************/
			if(prob(0.1))
				O = pick(O)
				var/Onomatopeia = rand(0, 1)
				var/frases_dreamer = pick("<span class='saybasic'>Um, dois, três, quatro...</span>", "<span class='saybasic'>Você é puro lixo.</span>", "<span class='saybasic'>Lembre-se.</span>", "<span class='saybasic'>Trey Liam?</span>", "<span class='saybasic'>Trey Liam.</span>", "<span class='saybasic'>Este é o seu nome.</span>")
				var/ending_d = copytext(frases_dreamer, length(frases_dreamer)) // Ending das frases estabelecidas
				var/ending_l = copytext(last_said, length(last_said)) //
				var/icone_to_go = null
				if(Onomatopeia == 0) //0 ele pega frase existente
					var/hasgone = 0
					if(ending_d == "!")
						icone_to_go = "h2"
						hasgone = 1
						to_chat(src, "<span class='[src.mind.say_color]'>[capitalize(O.name)]</span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'><b>[frases_dreamer]</b></span>\"")
					if(ending_d == "?")
						icone_to_go = "h1"
						hasgone = 1
						to_chat(src, "<span class='[src.mind.say_color]'>[capitalize(O.name)]</span> <span class='sayverb'>asks, </span>\"<span class='saybasic'>[frases_dreamer]</span>\"")
					else
						if(hasgone)
							is_dreaming = 0
							return
						icone_to_go = "h0"
						to_chat(src, "<span class='[src.mind.say_color]'>[capitalize(O.name)]</span> <span class='sayverb'>says, </span>\"<span class='saybasic'>[frases_dreamer]</span>\"")
				if(Onomatopeia == 1) //last word do cara
					if(last_said == null)
						is_dreaming = 0
						return
					if(ending_l == "!")
						icone_to_go = "h2"
						to_chat(src, "<span class='[src.mind.say_color]'>[capitalize(O.name)]</span> <span class='sayverb'>exclaims, </span>\"<span class='saybasic'>[last_said]</span>\"")
					if(ending_l == "?")
						icone_to_go = "h1"
						to_chat(src, "<span class='[src.mind.say_color]'>[capitalize(O.name)]</span> <span class='sayverb'>asks, </span>\"<span class='saybasic'>[last_said]</span>\"")
					else
						icone_to_go = "h0"
						to_chat(src, "<span class='[src.mind.say_color]'>[capitalize(O.name)]</span> <span class='sayverb'>says, </span>\"<span class='saybasic'>[last_said]</span>\"")

				var/image/objchatimage
				objchatimage = image('icons/mob/talk.dmi', O, "[icone_to_go]", "[O.layer]")
				client.images += objchatimage
				var/HallSounds = pick('sound/lfwbsounds/hall_appear1.ogg', 'sound/lfwbsounds/hall_appear2.ogg', 'sound/lfwbsounds/hall_appear3.ogg')
				playsound_local(src, HallSounds, 70)
	is_dreaming = 0


/mob/living/carbon/proc/handle_dreamer_screenshake()
	if(!client)
		return
	var/client/C = client
	var/shakeit = 0
	while(shakeit < 10)
		shakeit++
		var/intensity = 1 //i tried rand(1,2) but even that was 2 intense
		animate(C, pixel_y = (pixel_y + intensity), time = intensity)
		sleep(intensity)
		animate(C, pixel_y = (pixel_y - intensity), time = intensity)
		sleep(intensity)

/mob/living/carbon/proc/handle_dreamer_mob_hallucination()
	var/mob_msg = pick("É A MÃE!", "Eu tenho que ME APRESSAR!", "Estão VINDO!","Estão PRÓXIMOS!", "ELE DE NOVO NÃO!!")
	var/turf/turfie
	var/list/turf/turfies = list()
	for(var/turf/torf in view(src))
		turfies += torf
	if(length(turfies))
		turfie = pick(turfies)
	if(!turfie)
		return
	var/hall_type = pick("mom", "M3", "deepone")
	if(mob_msg == "É A MÃE!")
		hall_type = "mom"
	var/image/I = image('icons/life/dreamer_mobs.dmi', turfie, hall_type, FLOAT_LAYER, get_dir(turfie, src))

	src.client.images += I
	to_chat(src, "\n<span class='itsmom'>[mob_msg]</span>\n")
	sleep(5)
	var/AttackSounds = pick('sound/lfwbsounds/hall_attack.ogg', 'sound/lfwbsounds/hall_attack2.ogg', 'sound/lfwbsounds/hall_attack3.ogg', 'sound/lfwbsounds/hall_attack4.ogg')
	playsound_local(get_turf(src), AttackSounds, 100, 0)
	var/chase_tiles = 7
	var/chase_wait_per_tile = rand(3,5)
	var/caught_dreamer = FALSE
	while(chase_tiles > 0)
		turfie = get_step(turfie, get_dir(turfie, src))
		if(turfie)
			src.client.images -= I
			qdel(I)
			I = image('icons/life/dreamer_mobs.dmi', turfie, hall_type, FLOAT_LAYER, get_dir(turfie, src))
			src.client.images += I
			if(turfie == get_turf(src))
				caught_dreamer = TRUE
				sleep(chase_wait_per_tile)
				break
		chase_tiles--
		sleep(chase_wait_per_tile)
	src.client.images -= I
	if(!QDELETED(I))
		qdel(I)
	if(caught_dreamer)
		src.Weaken(5)
		var/IHTOMEI = pick('sound/lfwbsounds/hall_pain.ogg')// ok isso nao faz o menor sentido
		playsound_local(get_turf(src), IHTOMEI, 100, 0)
		flash_pain()

/mob/living/carbon/proc/handle_waking_up_floor(var/turf/simulated/floor/T)
	if(!T)
		return
	var/image/I = image('icons/turf/floors.dmi', T, pick("rcircuitanim", "gcircuitanim"), T.layer+0.1, T.dir)
	src.client?.images += I
	var/offset = pick(-1, 1)
	var/disappearfirst = 30
	animate(I, pixel_y = (pixel_y + offset), time = disappearfirst)
	sleep(disappearfirst)
	var/disappearsecond = 30
	animate(I, pixel_y = (pixel_y - offset), time = disappearsecond)
	sleep(disappearsecond)
	src.client?.images -= I
	qdel(I)

/mob/living/carbon/proc/handle_dreamer_waking_up()
	if(!client)
		return
	var/list/turf/simulated/floor/floorlist = list()
	for(var/turf/simulated/floor/F in view(src))
		if(prob(15))
			floorlist += F
	for(var/F in floorlist)
		spawn(0)
			handle_waking_up_floor(F)

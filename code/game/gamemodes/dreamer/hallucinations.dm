/mob/living/carbon/human/var
	dreamer_dreaming = FALSE
	waking_up = FALSE
	list/seenwonders = list()

/mob/living/carbon/human/proc/handle_dreamer()
	if(fakeDREAMER && combat_mode)
		spawn(0)
			INVOKE_ASYNC(src, .proc/handle_dreamer_screenshake)
	if(src && istype(src) && is_dreamer(src))
		if(combat_mode || waking_up)
			spawn(0)
				INVOKE_ASYNC(src, .proc/handle_dreamer_screenshake)
		INVOKE_ASYNC(src, .proc/handle_dreamer_hallucinations)
		if(src.nutrition < 399)
			src.nutrition = 400
		if(src.hidratacao < THIRST_LEVEL_FILLED)
			src.hidratacao = THIRST_LEVEL_FILLED
		src.becoming_zombie = 0
		switch(src.happiness)
			if(MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2)
				src.happiness = MOOD_LEVEL_HAPPY2
				src.update_happiness()
		if(waking_up)
			INVOKE_ASYNC(src, .proc/handle_dreamer_waking_up)

/mob/living/carbon/human/proc/handle_dreamer_hallucinations()
	if(dreamer_dreaming) return
	if(!is_dreamer(src)) return
	dreamer_dreaming = TRUE

	if(prob(1))
		handle_screen_dreamer()

	if(prob(1) && prob(27))
		handle_dreamer_mob_hallucination()

	if(prob(16))
		handle_dreamer_talking()

	if(prob(2.4))
		handle_radio()

	var/list/turf/simulated/floor/floorlist = list()
	var/list/turf/simulated/wall/walllist = list()

	for(var/turf/simulated/floor/F in view(src))
		if(prob(21) && F.may_dreamer_see)
			floorlist.Add(F)

	for(var/turf/simulated/wall/W in view(src))
		if(prob(20))
			walllist.Add(W)

	for(var/F in floorlist)
		INVOKE_ASYNC(src, .proc/handle_dreamer_floor, F)

	for(var/W in walllist)
		INVOKE_ASYNC(src, .proc/handle_dreamer_wall, W)

	dreamer_dreaming = FALSE

/mob/living/carbon/human/proc/handle_dreamer_floor(turf/simulated/floor/T)
	if(!T || !src.client)
		return
	var/image/I = image(T.icon, T, T.icon_state, T.layer, T.dir)
	src.client?.images += I
	var/offset = pick(-3,-2, -1, 1, 2, 3)
	var/disappearfirst = (rand(10, 30) * abs(offset))
	animate(I, pixel_y = (I.pixel_y + offset), time = disappearfirst)
	sleep(disappearfirst)
	var/disappearsecond = (rand(10, 30) * abs(offset))
	animate(I, pixel_y = (I.pixel_y - offset), time = disappearsecond)
	sleep(disappearsecond)
	src.client?.images -= I
	qdel(I)

/mob/living/carbon/human/proc/handle_dreamer_wall(turf/simulated/wall/W)
	if(!W || !src.client)
		return
	var/image/I = image('icons/effects/pooeffect.dmi', W, "floor[rand(1,8)]", "[W.layer]")
	src.client?.images += I
	var/offset = pick(-1, 1, 2)
	var/disappearfirst = rand(20, 40)
	animate(I, pixel_y = (I.pixel_y + offset), time = disappearfirst)
	sleep(disappearfirst)
	var/disappearsecond = rand(20, 40)
	animate(I, pixel_y = (I.pixel_y - offset), time = disappearsecond)
	sleep(disappearsecond)
	src.client?.images -= I
	qdel(I)

/mob/living/carbon/human/proc/handle_screen_dreamer(var/som = 1)
	if(prob(10))
		emote("scream")
		if(prob(10))
			src.drop_l_hand()
			src.drop_r_hand()

	overlay_fullscreen("dreamer", /obj/screen/fullscreen/dreamer, rand(1,8))

	var/Laughhalo = pick('sound/lfwbsounds/comic1.ogg', 'sound/lfwbsounds/comic2.ogg', 'sound/lfwbsounds/comic3.ogg', 'sound/lfwbsounds/comic4.ogg')
	var/scaryhalo = pick('sound/lfwbsounds/littlescary.ogg', 'sound/lfwbsounds/littlescary2.ogg')
	var/random = rand(1,2)
	if(random == 1 && prob(80))
		if(som)
			playsound_local(src, Laughhalo, 80)
		spawn(rand(10, 20))
			clear_fullscreen("dreamer")
	else
		var/Freefire = rand(10, 20)
		spawn(Freefire)
			clear_fullscreen("dreamer")
			spawn(10)
				overlay_fullscreen("dreamer", /obj/screen/fullscreen/dreamer, rand(1,8))
				spawn(10)
					clear_fullscreen("dreamer")
		if(som)
			playsound_local(src, scaryhalo, 80)

/mob/living/carbon/proc/handle_dreamer_screenshake()
	if(!client)
		return
	var/client/C = client
	var/shakeit = 0
	while(shakeit < 20)
		shakeit++
		var/intensity = 1 //i tried rand(1,2) but even that was 2 intense
		animate(C, pixel_y = (pixel_y + intensity), time = 0.5)
		sleep(0.5)
		animate(C, pixel_y = (pixel_y - intensity), time = 0.5)
		sleep(0.5)

/mob/living/carbon/proc/handle_dreamer_mob_hallucination()
	var/mob_msg = list()
	mob_msg = pick("It's mom!", "I have to HURRY UP!", "They are close! Theyareclose!", "You're mine.", "Hide!")
	var/turf/turfie
	var/list/turf/turfies = list()
	for(var/turf/torf in view(src))
		turfies += torf
	if(length(turfies))
		turfie = pick(turfies)
	if(!turfie)
		return
	var/hall_type = pick("mom", "M3", "deepone")
	if(mob_msg == "É A MÃE!" || mob_msg == "It's mom!")
		hall_type = "mom"
	var/image/I = image('icons/life/dreamer_mobs.dmi', turfie, hall_type, FLOAT_LAYER, get_dir(turfie, src))

	src.client.images += I
	to_chat(src, "\n<span class='itsmom'>[mob_msg]</span>\n\n")
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

/mob/living/carbon/human/proc/handle_dreamer_talking()
	var/list/objetos = list()
	for(var/obj/E in view(src, world.view)) /***************OBJETOS FALANDO, ETA CODING, MAS FUNCIONA PERFEITAMENTE*****************/
		if(istype(E.loc, /turf))
			objetos.Add(E)
	if(objetos.len)
		var/obj/O = pick(objetos)
		var/Onomatopeia = rand(0, 1)

		var/file_US = file2text('code/game/gamemodes/dreamer/Frases_dreamerUS.txt')
		var/frases_dreamer = null

		if(!waking_up)
			frases_dreamer = pick(splittext(file_US, "\n"))
		else
			frases_dreamer = pick("It's time to wake up.")

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
					return
				icone_to_go = "h0"
				to_chat(src, "<span class='[src.mind.say_color]'>[capitalize(O.name)]</span> <span class='sayverb'>says, </span>\"<span class='saybasic'>[frases_dreamer]</span>\"")
		if(Onomatopeia == 1) //last word do cara
			if(last_said == null)
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
		sleep(20)
		client.images -= objchatimage

/mob/living/carbon/human/proc/handle_dreamer_waking_up()
	if(!src.client)
		return
	var/list/turf/simulated/floor/floorlist = list()
	for(var/turf/simulated/floor/F in view(src))
		if(prob(15))
			floorlist += F
	for(var/F in floorlist)
		INVOKE_ASYNC(src, .proc/handle_waking_up_floor, F)

/mob/living/carbon/human/proc/handle_waking_up_floor(turf/simulated/floor/T)
	if(!T)
		return
	var/image/I = image('icons/life/floors.dmi', T, pick("bar2", "bar2r"), T.layer+0.1, T.dir)
	src.client?.images += I
	var/offset = pick(-1, 1)
	var/disappearfirst = 30
	animate(I, pixel_y = (I.pixel_y + offset), time = disappearfirst)
	sleep(disappearfirst)
	var/disappearsecond = 30
	animate(I, pixel_y = (I.pixel_y - offset), time = disappearsecond)
	sleep(disappearsecond)
	src.client?.images -= I
	qdel(I)

/mob/living/carbon/human/proc/handle_radio()
	var/list/humanosnegros = list()

	var/file_US = file2text('code/game/gamemodes/dreamer/RadioDreamerUS.txt')

	var/frases_dreamer = null

	for(var/mob/living/carbon/human/H in mob_list)
		if(H == src)
			continue
		if(ismonster(H))
			continue
		if(H.stat == DEAD) //morto nao fala fica cinzado ai lixo
			continue
		humanosnegros.Add(H)

	frases_dreamer = pick(splittext(file_US, "\n"))

	if(prob(11))
		var/list/JUDAS = pick("[uppertext(src.real_name)], SHOW ME A WONDER!", "[src.real_name], has killed someone!")
		var/mob/living/carbon/human/H = pick(humanosnegros)
		var/obj/item/device/radio/headset/bracelet/a = new /obj/item/device/radio/headset/bracelet(null)
		var/part_a = "<span class='comms'><span class='commsname'>[H.name]"
		var/part_b = "</span> [icon2html(a, src)]\[[H.job]\]</b> <span class='message'>[JUDAS]"
		var/part_c = "</span></span>"
		var/ending = copytext(JUDAS, length(JUDAS)) // Ending das frases estabelecidas
		if(ishuman(src))
			if (ending != "!")
				var/ageAndGender = ageAndGender2Desc(H.age, H.gender)
				part_b = "</span> [icon2html(a, src)]<span class='commsbold'>\[[H.job]\  [ageAndGender]]</span> <span class='message'>says, \"[JUDAS]\"" // Tweaked for security headsets -- TLE
			else if (ending == "!")
				var/ageAndGender = ageAndGender2Desc(H.age, H.gender)
				var/verbage = pick("shouts", "yells")
				part_b = "</span> [icon2html(a, src)]<span class='commsbold'>\[[H.job]\  [ageAndGender]]</span> <span class='commsbold'>[verbage], \"[JUDAS]\""

		to_chat(src, part_a + part_b + part_c)
		src << 'sound/lfwbsounds/radio_chatter.ogg'
		return

	if(humanosnegros.len)
		var/mob/living/carbon/human/H = pick(humanosnegros)
		var/obj/item/device/radio/headset/bracelet/a = new /obj/item/device/radio/headset/bracelet(null)

		var/part_a = "<span class='comms'><span class='commsname'>[H.real_name]"
		var/part_b = "</span> [icon2html(a, src)]\[[H.job]\]</b> <span class='message'>[frases_dreamer]"
		var/part_c = "</span></span>"
		var/ending = copytext(frases_dreamer, length(frases_dreamer)) // Ending das frases estabelecidas
		if(ishuman(src))
			if (ending != "!")
				var/ageAndGender = ageAndGender2Desc(H.age, H.gender)
				part_b = "</span> [icon2html(a, src)]<span class='commsbold'>\[[H.job]\  [ageAndGender]]</span> <span class='message'>says, \"[frases_dreamer]\"" // Tweaked for security headsets -- TLE
			else if (ending == "!")
				var/ageAndGender = ageAndGender2Desc(H.age, H.gender)
				var/verbage = pick("shouts", "yells")
				part_b = "</span> [icon2html(a, src)]<span class='commsbold'>\[[H.job]\  [ageAndGender]]</span> <span class='commsbold'>[verbage], \"[frases_dreamer]\""

		to_chat(src, part_a + part_b + part_c)
		src << 'sound/lfwbsounds/radio_chatter.ogg'

/mob/living/carbon/human/proc/Loucura()
	if(!client) return

	var/obj/screen/Death = new
	Death.icon = 'icons/life/screen1legacy.dmi'
	Death.icon_state = "health7"
	Death.screen_loc = "1,1 to 15,15"
	src.client.screen.Add(Death)
	src << 'sound/lfwbsounds/psybi.ogg'
	animate(Death, alpha = 25, time = 2)
	sleep(2)
	animate(Death, alpha = 255, time = 3)
	sleep(3)
	animate(Death, alpha = 25, time = 2)
	sleep(2)
	animate(Death, alpha = 255, time = 3)
	sleep(3)

	animate(Death, alpha = 25, time = 3)
	sleep(3)
	animate(Death, alpha = 255, time = 2)
	sleep(2)
	animate(Death, alpha = 25, time = 3)
	sleep(3)
	animate(Death, alpha = 255, time = 2)
	sleep(2)

	src << 'sound/lfwbsounds/wonder_secret_known.ogg'

	sleep(15)

	handle_screen_dreamer(0)

	sleep(15)

	qdel(Death)
	src << 'sound/lfwbsounds/rebirth.ogg'

	starringlist += "[capitalize(src.ckey)] "

	src.consyte = 0
	src.mind.special_role = "Waker"
	src.combat_music = 'sound/lfwbsounds/bloodlust1.ogg'
	src.my_skills.CHANGE_SKILL(SKILL_MELEE, 10)
	src.my_skills.CHANGE_SKILL(SKILL_RANGE, rand(1,2))
	src.vice = "Graphomaniac"
	src.my_stats.st = rand(19,24)
	src.my_stats.dx = rand(16,20)
	src.my_stats.ht = rand(17,19)
	src.verbs += /mob/living/carbon/human/proc/dreamer
	src.updatePig()
	src.status_flags |= STATUS_NO_PAIN
	var/datum/antagonist/dreamer/M = new()
	src.mind.antag_datums = M

	to_chat(src,"<span class='dreamershitfuckcomicao1'>I remember now!</span>")
	to_chat(src,"<span class='dreamershitfuckcomicao1'>They're all from another WORLD, ANOTHER life!</span>")
	to_chat(src,"<span class='dreamershitfuckcomicao1'>I MUST CUT MY BONDS, ONLY BENEATH THE SKIN DOES THE TRUTH LAY!</span>")
	to_chat(src,"<span class='dreamershitfuckcomicao1'>Dream #1: FOLLOWING my HEART shall be the WHOLE of the law.</span>")
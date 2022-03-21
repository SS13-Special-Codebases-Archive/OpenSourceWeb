var/EndRoundMusicGAMEMODE = 0
var/starringlist = ""

/datum/antagonist/dreamer
	var/name = "Dreamer"
	//NIGGACAAAAT
	var/hearts_seen
	var/sum_total
	var/key1
	var/key2
	var/key3
	var/key4
	//NIGGAAAHH
	var/heart_key1
	var/heart_key2
	var/heart_key3
	var/heart_key4

	//FODASE SE E NEGRO CODING CARALHOOOOOOOOOOO

/datum/antagonist/dreamer/New()
	. = ..()
	set_keys()

/datum/antagonist/dreamer/proc
	set_keys()
		var/list/alphabet = list("A", "B", "C","D", "E", "F","G", "H", "I","J", "K", "L","M", "N", "O","P", "Q", "R","S", "T", "U","V", "W", "X","Y", "Z")
		key1 = text2num("[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]")
		key2 = text2num("[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]")
		key3 = text2num("[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]")
		key4 = text2num("[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]")
		heart_key1 = "I[pick(alphabet)][pick(alphabet)][pick(alphabet)]"
		heart_key2 = "I[pick(alphabet)][pick(alphabet)][pick(alphabet)]"
		heart_key3 = "I[pick(alphabet)][pick(alphabet)][pick(alphabet)]"
		heart_key4 = "I[pick(alphabet)][pick(alphabet)][pick(alphabet)]"
		sum_total = key1 + key2 + key3 + key4

/datum/antagonist/dreamer/proc/agony(mob/living/carbon/human/M)
	if(!istype(M))
		return
	var/sound/im_sick = sound('sound/lfwbsounds/dreamt.ogg', repeat=1,channel=12, volume=100)
	M.playsound_local(get_turf(M), im_sick, 200)
	M.overlay_fullscreen("dream", /obj/screen/fullscreen/dreamer, 1)
	M.clear_fullscreen("dream")
	M.overlay_fullscreen("wakeup", /obj/screen/fullscreen/dreamer/waking_up, 1)
	M.waking_up = TRUE

/datum/antagonist/dreamer/proc/wake_up(mob/living/carbon/M)

	to_chat(M, "<span class='saybasic'>..............</span><span class='dreamershitbutitsbigasfuck'>It couldn't be.</span>")

	var/mob/living/carbon/human/new_character = new(pick(latejoin))
	EndRoundMusicGAMEMODE = 1
	new_character.real_name = "Trey Liam"
	new_character.age = rand(AGE_MIN, 50)
	new_character.r_hair = rand(0,255)
	new_character.g_hair = rand(0,255)
	new_character.b_hair = rand(0,255)
	new_character.h_style = random_hair_style()
	new_character.r_facial = rand(0,255)
	new_character.g_facial = rand(0,255)
	new_character.b_facial = rand(0,255)
	new_character.f_style = random_facial_hair_style()
	new_character.r_eyes = rand(0,255)
	new_character.g_eyes = rand(0,255)
	new_character.b_eyes = rand(0,255)
	new_character.s_tone = random_skin_tone()
	new_character.clear_fullscreen("wakeup")
	if(dreamerspawn)
		new_character.forceMove(dreamerspawn)
	for(var/obj/structure/stool/bed/chair/C in new_character.loc)
		C.buckle_mob(new_character)
	new_character.key = M.key
	new_character.mind.key = M.key
	new_character.client.ChromieWinorLoose(new_character.client, 10)
	new_character.mind.farwebcompletionantagonist = 1
	new_character.mind.special_role = "Waker"
	for(var/mob/ME in player_list)
		if(ME.client)
			var/sound/killer_win = sound('sound/lfwbsounds/killer_win.ogg', 0, 0, 12, 100)
			ME << killer_win
	new_character.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/black(new_character), slot_shoes)
	new_character.equip_to_slot_or_del(new /obj/item/clothing/under/psych(new_character), slot_w_uniform)
	new_character.equip_to_slot_or_del(new /obj/item/clothing/head/VR(new_character), slot_head)

	qdel(M)
	new_character.sleeping = 10
	sleep(15)
	to_chat(new_character, "<span class='saybasic'>...</span> <span class='dreamershitbutitsbigasfuck'>WHERE AM I?</span> <span class='saybasic'>...</span>")
	sleep(30)
	to_chat(new_character, "<span class='dreamershitfuckcomicao1'>... The Fortress? No... it doesn't exist ...</span>")
	sleep(30)
	to_chat(new_character, "<span class='dreamershitfuckcomicao1'>... I'm on TNC Maya trade vessel ...</span>")
	sleep(30)
	to_chat(new_character, "<span class='dreamershitfuckcomicao1'>... My name is Trey. Trey Liam, a second class pilot. ...</span>")
	sleep(30)
	to_chat(new_character, "<span class='dreamershitfuckcomicao1'>... The engine... a breakdown. We're drifting in open space for twenty years. ...</span>")
	sleep(30)
	to_chat(new_character, "<span class='dreamershitfuckcomicao1'>... There is no hope left. Only the cyberspace deck helps me to doze off. ...</span>")
	sleep(30)
	to_chat(new_character, "<span class='dreamershitfuckcomicao1'>... What have I done?! ...</span>")
	sleep(60)
	new_character.emote("opens his eyes.")
	new_character.vomit()

	ticker.declare_completion()

	spawn(50)
		callHook("roundend")
		if (ticker.mode.station_was_nuked)
			if(!ticker.delay_end)
				to_chat(world,"<b>Story ended, [ticker.restart_timeout/10] seconds for the next story</b>")
		else
			if(!ticker.delay_end)
				to_chat(world,"<b>Story ended, [ticker.restart_timeout/10] seconds for the next story</b>")

		if(!ticker.delay_end)
			sleep(ticker.restart_timeout)
			if(!ticker.delay_end)
				to_chat(world, "The fortress has been abandoned.")
				world.Reboot()
			else
				to_chat(world,"\blue <B>An admin has delayed the round end</B>")
		else
			to_chat(world,"\blue <B>An admin has delayed the round end</B>")
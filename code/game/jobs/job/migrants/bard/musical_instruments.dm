#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

/obj/item/weapon/musical_instrument
	desc = ""
	icon = 'icons/obj/musician.dmi'
	var/datum/sound_token/sound_token
	var/list/music_list = list()
	var/mob/living/carbon/human/player
	var/music_quality = 0
	var/music_fail
	var/playing = FALSE
	var/sound_id
	var/difficulty = 0

/obj/item/weapon/musical_instrument/New()
	..()
	sound_id = "[type]_[sequential_id(type)]"

/obj/item/weapon/musical_instrument/attack_self(mob/user)

	if(playing)
		StopPlaying()
		return
	else
		if(!ishuman(user))
			to_chat(src, "<span class='combat'>Only humans can play it!</span>")
			return

		var/mob/living/carbon/human/H = user

		var/music_name = input(H, "Which music i should play?", "Music") in music_list
		if(H.l_hand && H.r_hand)
			to_chat(H, "<span class='combat'>I need two hands to play it!</span>")
			return
		var/list/roll_result = roll3d6(H, SKILL_MUSIC, difficulty * -1, FALSE)
		switch(roll_result[GP_RESULT])
			if(GP_CRITSUCCESS)
				H.visible_message("<span class='passivebold'>\the [H] begins to play \the [src] masterfully!</span>")
				StartPlaying(H, music_list[music_name], 2)

			if(GP_SUCCESS)
				H.visible_message("<span class='passive'>\the [H] begins to play \the [src].</span>")
				StartPlaying(H, music_list[music_name], 1)

			if(GP_FAILED, GP_CRITFAIL)
				H.visible_message("<span class='combat'>\the [H] begins to play \the [src] poorly.</span>")
				if(roll_result[GP_RESULT] == GP_CRITFAIL)
					H.add_event("failed", /datum/happiness_event/misc/ivefailed)
				StartPlaying(H, music_fail, 0)

		return



/obj/item/weapon/musical_instrument/process()

	if(!ishuman(src.loc))
		StopPlaying()
		return

	if(src.loc != player)
		StopPlaying()
		return

	if((player.l_hand && player.r_hand) || ((player.l_hand != src) && (player.r_hand != src))) //Checnkin if all hands are full, or our instrument isn't in the hands.
		StopPlaying()
		return

	var/datum/happiness_event/music_mood
	switch(music_quality)
		if(2)	music_mood = /datum/happiness_event/song/perfect
		if(1)	music_mood = /datum/happiness_event/song/good
		if(0)	music_mood = /datum/happiness_event/song/bad


	for(var/mob/living/carbon/human/M in view(7, player))
		if(M.check_event("song")) continue
		M.add_event("song", music_mood)



/obj/item/weapon/musical_instrument/proc/StopPlaying()
	playing = FALSE
	music_quality = initial(music_quality)
	player = null
	processing_objects.Remove(src)
	update_icon()
	qdel(sound_token)

/obj/item/weapon/musical_instrument/proc/StartPlaying(var/mob/living/carbon/human/H, var/music, var/quality = 1)
	StopPlaying()
	if(!music) return
	if(!ishuman(H)) return

	player = H
	sound_token = sound_player.PlayLoopingSound(src, sound_id, music, volume = 40, range = 7, falloff = 3, prefer_mute = TRUE)
	playing = TRUE
	music_quality = quality
	processing_objects.Add(src)
	update_icon()

/obj/item/weapon/musical_instrument/baliset
	name = "baliset"
	attack_verb = list("smashed")
	hitsound = 'sound/weapons/bali_hit.ogg'
	icon_state = "baliset"
	item_state = "baliset"
	force = 10
	w_class = 2
	slot_flags = SLOT_BACK
	difficulty = 1
	item_worth = 50
	music_fail = 'sound/music/instruments/bard_fail.ogg'
	music_list = list("1" = 'sound/music/instruments/bard1.ogg', "2" = 'sound/music/instruments/bard2.ogg', "3" = 'sound/music/instruments/bard3.ogg', \
	"4" = 'sound/music/instruments/bard4.ogg', "5" = 'sound/music/instruments/bard5.ogg')

/obj/item/weapon/musical_instrument/baliset/balalaika
	name = "balalaika"
	icon_state = "balalaika"
	item_state = "balalaika"
	music_list = list("1" = 'sound/music/instruments/balalaika1.ogg')
	difficulty = 2
	item_worth = 5000

/obj/item/weapon/musical_instrument/baliset/guitar
	name = "guitar"
	icon_state = "guitar"
	music_fail = 'sound/music/instruments/g5.ogg'
	music_list = list("1" = 'sound/music/instruments/g1.ogg', "2" = 'sound/music/instruments/g2.ogg', "3" = 'sound/music/instruments/g3.ogg', \
	"4" = 'sound/music/instruments/g4.ogg', "5" = 'sound/music/instruments/g6.ogg', "6" = 'sound/music/instruments/g7.ogg')

/obj/item/weapon/musical_instrument/bayan
	name = "accordion"
	attack_verb = list("smashed")
	icon_state = "bayan"
	item_state = "bayan"
	force = 10
	w_class = 3
	difficulty = 2
	item_worth = 100
	music_fail = 'sound/music/instruments/b6.ogg'
	music_list = list("1" = 'sound/music/instruments/b1.ogg', "2" = 'sound/music/instruments/b2.ogg', "3" = 'sound/music/instruments/b3.ogg', \
	"4" = 'sound/music/instruments/b4.ogg', "5" = 'sound/music/instruments/b5.ogg', "6" = 'sound/music/instruments/b7.ogg', "7" = 'sound/music/instruments/b8.ogg')
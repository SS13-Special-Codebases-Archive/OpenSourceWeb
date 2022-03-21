/mob/living/carbon/human/verb/combat_mode()
	set name = "CombatModeToggle"
	set instant = 1
	set hidden = 1
	var/mob/living/carbon/human/H = usr
	if(special == "hardconcentrate")
		if(prob(40))
			return
	H.toggle_combat_mode()

/mob/living/carbon/human/verb/toggle_combat_mode()
	set hidden = 1
	var/mob/living/carbon/human/H = usr
	if(H.combat_mode)
		H.combat_mode = 0
		H.combat_mode_icon.icon_state = "cmbt0"
		H << 'sound/webbers/ui_toggleoff.ogg'
		H << sound(null, repeat = 0, wait = 0, volume = src?.client?.prefs?.music_volume, channel = 12)
		H.my_stats.pr -= 2
		var/list/sounds_list = H.client.SoundQuery()
		for(var/playing_sound in sounds_list)
			var/sound/found = playing_sound
			if(found.channel == 9)
				found.volume = src?.client?.prefs?.music_volume
				found.status = SOUND_UPDATE
				H << found
		if(src.wear_mask)
			if(istype(wear_mask,/obj/item/clothing/mask/gas/church))
				var/obj/item/clothing/mask/gas/church/G = wear_mask
				G.icon_state = G.off_state
				G.item_state = G.off_state
				H.update_inv_head(0)
				H.update_inv_wear_mask(0)
	else
		H.combat_mode = 1
		H.combat_mode_icon.icon_state = "cmbt1"
		H << 'sound/webbers/ui_toggle.ogg'
		H.my_stats.pr += 2
		var/area/A = get_area(src)
		if(src.wear_mask)
			if(istype(wear_mask,/obj/item/clothing/mask/gas/church))
				var/obj/item/clothing/mask/gas/church/G = wear_mask
				G.icon_state = G.on_state
				G.item_state = G.on_state
				H.update_inv_head(0)
				H.update_inv_wear_mask(0)


		var/list/sounds_list = H.client.SoundQuery()
		for(var/playing_sound in sounds_list)
			var/sound/found = playing_sound
			if(found.channel == 9)
				found.volume = 0
				found.status = SOUND_UPDATE
				H << found

		var/sound/S = sound(pick('suspense1.ogg','suspense2.ogg','suspense3.ogg','suspense4.ogg','suspense5.ogg','suspense6.ogg','suspense7.ogg','suspense8.ogg'), repeat = 1, wait = 0, volume = src?.client?.prefs?.music_volume, channel = 12)
		S.environment = A.sound_env

		if(is_dreamer(H))
			S = sound('sound/lfwbsounds/bloodlust1.ogg', repeat = 1, wait = 0, volume = src?.client?.prefs?.music_volume, channel = 12)
		else if(H.religion == "Thanati")
			S = sound('suspense_thanati.ogg', repeat = 1, wait = 0, volume = src?.client?.prefs?.music_volume, channel = 12)
		else if(H.job == "Jester")
			S = sound('jester_combat.ogg', repeat = 1, wait = 0, volume = src?.client?.prefs?.music_volume, channel = 12)
		else if(H.mind.changeling)
			S = sound('sound/lfwbsounds/they_combat.ogg', repeat = 1, wait = 0, volume = src?.client?.prefs?.music_volume, channel = 12)
		else if(H.combat_musicoverlay)
			S = sound(H.combat_musicoverlay, repeat = 1, wait = 0, volume = src?.client?.prefs?.music_volume, channel = 12)
		else
			S = sound(pick('suspense1.ogg','suspense2.ogg','suspense3.ogg','suspense4.ogg','suspense5.ogg','suspense6.ogg','suspense7.ogg','suspense8.ogg'), repeat = 1, wait = 0, volume = src?.client?.prefs?.music_volume, channel = 12)

		if(april_fools)
			playsound(src.loc, 'worm_attack.ogg', 60, 0, -1)
			src.say("Atacar!")

		H << S

/mob/living/carbon/human/proc/handle_sprint()
	if(sprinting)
		adjustStaminaLoss(2)

/mob/living/carbon/human/Life()
	..()
	if(!combat_mode)
		if(resting)
			adjustStaminaLoss(-2)
		else
			adjustStaminaLoss(-1)

/mob/living/proc/cantsee()
	for(var/mob/living/carbon/human/H in view(7, src))
		if(!H.client)
			return
		if(!src.client)
			return
		if(src in H.hidden_mobs)
			return 1
		else
			return 0

/mob/proc/surrender()//Surrending. I need to put this in a different file.
	if(stat == CONSCIOUS )
		visible_message("<p style='font-size:20px'><span class='passivebold'>[src] surrenders!</span></p>")
		resting = 1
		playsound(src, 'sound/effects/surrender.ogg', 90, 0)
		var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
		animation.pixel_y = 16
		animation.icon_state = "blank"
		animation.icon = 'icons/life/screen1.dmi'
		animation.master = src
		flick(animation, "attention")
		//Weaken(5) // This is enabled however to give people an incentive not to fake surrender
		spawn(50)
			qdel(animation)

/mob/proc/mob_rest()
	if(resting && !stunned && !weakened && (can_stand || buckled))//The incapacitated proc includes resting for whatever fucking stupid reason I hate SS13 code so fucking much.
		visible_message("<span class='passivebold'>[usr]</span> <span class='passive'>is trying to get up.</span> ")
		if(do_after(src, 15))
			resting = 0
			update_vision_cone()
		return

	else if(!resting)
		resting = 1
		update_transform()
		sleep(10)
		playsound(src, "bodyfall", 50, 1)
		visible_message("<span class='passivebold'>[usr]</span> <span class='passive'>falls over.</span> ")
		update_transform()
		//if(ishuman(src))
			//var/mob/living/carbon/human/H = src
			//H.update_bloody_wounds()

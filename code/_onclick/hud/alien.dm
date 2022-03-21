/datum/hud/proc/alien_hud()

	src.adding = list(  )
	src.other = list(  )
	src.hotkeybuttons = list() //These can be disabled for hotkey usersx

	var/obj/screen/using

	using = new /obj/screen()
	using.name = "act_intent"
	using.dir = SOUTHWEST
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.icon_state = mymob.a_intent
	using.screen_loc = "16,3"
	using.layer = 20
	src.adding += using
	action_intent = using


	using = new /obj/screen() //Right hud bar
	using.dir = SOUTH
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.screen_loc = "EAST+1,SOUTH to EAST+1,NORTH"
	using.layer = 18
	adding += using

	using = new /obj/screen()
	using.name = "mov_intent"
	using.dir = SOUTHWEST
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.icon_state = (mymob.m_intent == "run" ? "running" : "walking")
	using.screen_loc = "16,9"
	using.layer = 20
	src.adding += using
	move_intent = using

	mymob.nutrition_icon = new /obj/screen()
	mymob.nutrition_icon.icon = 'icons/mob/screen1_alien.dmi'
	mymob.nutrition_icon.icon_state = "hunger0"
	mymob.nutrition_icon.name = "hunger"
	mymob.nutrition_icon.screen_loc = ui_nutrition

	using = new /obj/screen()
	using.name = "resist"
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.icon_state = "act_resist"
	using.screen_loc = ui_resist
	using.layer = 19
	src.adding += using

	mymob.blind = new /obj/screen()
	mymob.blind.icon = 'icons/mob/screen1.dmi'
	mymob.blind.icon_state = "blackanimate"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1 to 15,15"
	mymob.blind.mouse_opacity = 0
	mymob.blind.layer = 0

	mymob.rest = new /obj/screen()
	mymob.rest.name = "rest"
	mymob.rest.icon = 'icons/mob/screen1_alien.dmi'
	mymob.rest.icon_state = "rest[mymob.resting]"
	mymob.rest.screen_loc = ui_toxin

	mymob.flash = new /obj/screen()
	mymob.flash.icon = 'icons/mob/screen1_Midnight.dmi'
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.mouse_opacity = 0
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.layer = 17

	mymob.combat_mode_icon = new /obj/screen()
	mymob.combat_mode_icon.icon = 'icons/mob/screen1_alien.dmi'
	mymob.combat_mode_icon.icon_state = "cmbt0"
	mymob.combat_mode_icon.name = "combat mode"
	mymob.combat_mode_icon.screen_loc = "16,7"

	mymob.pullin = new /obj/screen()
	mymob.pullin.icon = 'icons/mob/screen1_alien.dmi'
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = "16,8"

	mymob.eye_fix = new /obj/screen()//STAMINA
	mymob.eye_fix.icon = 'icons/mob/screen1_alien.dmi'
	mymob.eye_fix.icon_state = "fixed_e0"
	mymob.eye_fix.name = "eyefix"
	mymob.eye_fix.screen_loc = "16,6"

	mymob.actions1 = new /obj/screen()
	mymob.actions1.icon = 'icons/mob/screen1_alien.dmi'
	mymob.actions1.icon_state = "actions"
	mymob.actions1.name = "actions1"
	mymob.actions1.screen_loc = "16,11"
	src.hotkeybuttons += mymob.actions1

	mymob.moreactions = new /obj/screen()
	mymob.moreactions.icon = 'icons/mob/screen1_alien.dmi'
	mymob.moreactions.icon_state = "moreactions"
	mymob.moreactions.name = "moreactions"
	mymob.moreactions.screen_loc = "16,13"
	src.hotkeybuttons += mymob.moreactions

	mymob.film_grain2 = new()
	mymob.film_grain2.icon = 'icons/mob/screen1_alien.dmi'
	mymob.film_grain2.icon_state = "noise"
	mymob.film_grain2.screen_loc = ui_entire_screen
	mymob.film_grain2.blend_mode = 4
	mymob.film_grain2.alpha = 190
	mymob.film_grain2.layer = 0
	mymob.film_grain2.mouse_opacity = 0
	mymob.film_grain2.blend_mode = 4

	mymob.zone_sel = new /obj/screen/zone_sel( null )
	mymob.zone_sel.icon = 'icons/life/zone_sel.dmi'
	mymob.zone_sel.screen_loc = ui_zonesel
	mymob.zone_sel.overlays.Cut()
	mymob.zone_sel.overlays += image('icons/life/zone_sel.dmi', "[mymob.zone_sel.selecting]")
	if(ishuman(mymob)) //larva uses also uses this hud
		mymob.fov = new /obj/screen/fov()
		mymob.fov_mask = new /obj/screen/fov_mask()
		mymob.fov_mask_two = new /obj/screen/fov_mask_two()

	var/mob/living/carbon/human/H = mymob
	H.hovertext = new /obj/screen/text/atm
	H.hovertext.maptext = ""
	H.hovertext.maptext_height = 100
	H.hovertext.maptext_width = 480
	H.hovertext.screen_loc = "CENTER-7, CENTER+7"

	mymob.client.screen = null

	mymob.client.screen += list(mymob.fov, mymob.fov_mask, mymob.fov_mask_two, mymob.eye_fix, mymob.film_grain2,mymob.actions1, mymob.moreactions,mymob.nutrition_icon, mymob.pullin, mymob.combat_mode_icon, mymob.rest, mymob.zone_sel, mymob.flash, mymob.blind) //, mymob.hands, mymob.rest, mymob.sleep, mymob.mach )
	mymob.client.screen += src.adding + src.other
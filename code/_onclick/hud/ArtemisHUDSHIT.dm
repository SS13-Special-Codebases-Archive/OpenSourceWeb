/mob/living/carbon/human/var/artemisdone = FALSE
/mob/living/carbon/human/proc/DoArtemis()
	if(!artemisdone)
		for(var/obj/screen/S in ArtemiSHITO)
			S.icon = 'icons/life/screen1legacy.dmi'
		for(var/obj/screen/S in hud_used.adding)
			S.icon = 'icons/life/screen1legacy.dmi'
		src.background.icon = 'icons/life/screen6.dmi'
		artemisdone = TRUE
		src.combat_popup.icon_state = "cstyle2"
		src.combat_popup.icon = 'icons/life/screen2.dmi'
		for(var/obj/screen_controller/S in src.client.screen)
			S.filters = filter(type="color",color= list(1,0,0,0, 0,1,0,0, 0,0,1.2,0, 0,0,0,1, 0,0,0,0),space=FILTER_COLOR_HSL)

/mob/proc/Do_OLDHUD() // Snowflake
	for(var/obj/screen/S in ArtemiSHITO)
		S.icon = 'icons/life/screen1_older.dmi'
	for(var/obj/screen/S in hud_used.adding)
		S.icon = 'icons/life/screen1_older.dmi'
	eye_fix.screen_loc = "16, 6"
	awake.screen_loc = "16, 2"
	rest.screen_loc = "16, 1"
	src.combat_popup.icon_state = "cstyle"
	src.combat_popup.icon = initial(src.combat_popup.icon)
	for(var/obj/screen_controller/S in src.client.screen)
		S.filters = filter(type="color",color=list(1,0,0, 0,1.2,0, 0,0,1, 0,0,0),space=FILTER_COLOR_HSL)
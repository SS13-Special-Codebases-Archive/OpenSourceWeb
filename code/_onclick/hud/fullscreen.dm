/mob/Login()
	..()
	reload_fullscreen()

/mob
	var/list/screens = list()

/mob/proc/set_fullscreen(condition, screen_name, screen_type, arg)
	condition ? overlay_fullscreen(screen_name, screen_type, arg) : clear_fullscreen(screen_name)

/mob/proc/overlay_fullscreen(category, type, severity)
	var/obj/screen/fullscreen/screen = screens[category]

	if(screen)
		if(screen.type != type)
			clear_fullscreen(category, FALSE)
			screen = null
		else if(!severity || severity == screen.severity)
			return null

	if(!screen)
		screen = new type()

	screen.icon_state = "[initial(screen.icon_state)][severity]"
	screen.severity = severity

	screens[category] = screen
	if(client)
		client.screen += screen
	return screen

/mob/proc/clear_fullscreen(category, animated = 10)
	var/obj/screen/fullscreen/screen = screens[category]
	if(!screen)
		return

	screens -= category

	if(animated)
		spawn(0)
			animate(screen, alpha = 0, time = animated)
			sleep(animated)
			if(client)
				client.screen -= screen
			qdel(screen)
	else
		if(client)
			client.screen -= screen
		qdel(screen)

/mob/proc/clear_fullscreens()
	for(var/category in screens)
		clear_fullscreen(category)

/mob/proc/hide_fullscreens()
	if(client)
		for(var/category in screens)
			client.screen -= screens[category]

/mob/proc/reload_fullscreen()
	if(client)
		for(var/category in screens)
			if(ishuman(src) && category == "ghost") //prevention
				continue
			client.screen |= screens[category]

/obj/screen/fullscreen
	icon_state = "default"
	screen_loc = "CENTER-7,CENTER-7"
	plane = 30
	mouse_opacity = 0
	var/severity = 0
	var/allstate = 0 //shows if it should show up for dead people too

/obj/screen/fullscreen/Destroy()
	severity = 0
	return ..()

/obj/screen/fullscreen/brute
	icon_state = "brutedamageoverlay"
	layer = 15

/obj/screen/fullscreen/oxy
	icon_state = "oxydamageoverlay"
	layer = 15

/obj/screen/fullscreen/crit
	icon_state = "passage"
	layer = CRIT_LAYER

/obj/screen/fullscreen/blind
	icon = 'icons/mob/screen1.dmi'
	icon_state = "blackanimate"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	layer = BLIND_LAYER

/obj/screen/fullscreen/blackout
	icon = 'icons/mob/screen1.dmi'
	icon_state = "black"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	layer = BLIND_LAYER

/obj/screen/fullscreen/impaired
	icon_state = "impairedoverlay"
	layer = IMPAIRED_LAYER

/obj/screen/fullscreen/blurry
	icon = 'icons/mob/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "blurry"

/obj/screen/fullscreen/flash
	icon = 'icons/mob/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"

/obj/screen/fullscreen/flash/noise
	icon_state = "noise"

/obj/screen/fullscreen/high
	icon = 'icons/mob/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "druggy"

/obj/screen/fullscreen/jumpscarekick
	icon = 'icons/mob/jumpscarekick.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "creepy"
	plane = 30
	layer = 30

/obj/screen/fullscreen/noise
	icon = 'icons/effects/static.dmi'
	icon_state = "1 light"
	screen_loc = ui_entire_screen
	layer = FULLSCREEN_LAYER
	alpha = 127

/obj/screen/fullscreen/fadeout
	icon = 'icons/mob/screen1.dmi'
	icon_state = "black"
	screen_loc = ui_entire_screen
	layer = FULLSCREEN_LAYER
	alpha = 0
	allstate = 1

/obj/screen/fullscreen/fadeout/New()
	. = ..()
	animate(src, alpha = 255, time = 10)

/obj/screen/fullscreen/scanline
	icon = 'icons/effects/static.dmi'
	icon_state = "scanlines"
	screen_loc = ui_entire_screen
	alpha = 50
	layer = FULLSCREEN_LAYER

/obj/screen/fullscreen/fishbed
	icon_state = "fishbed"
	allstate = 1

/obj/screen/fullscreen/pain
	icon_state = "brutedamageoverlay6"
	alpha = 0

/datum/hud
	var/obj/screen/fullscreen/dreamer/dreamer
	var/obj/screen/fullscreen/DOB/DOB

/obj/screen/fullscreen/dreamer
	icon = 'icons/effects/dreamer.dmi'
	icon_state = "hall"
	plane = 30
	layer = 30
	var/waking_up = FALSE
	alpha = 180

/obj/screen/fullscreen/surface
	icon = 'icons/mob/hide.dmi'
	icon_state = "pooreyes"
	plane = 30
	layer = 30
	alpha = 210

/obj/screen/fullscreen/dreamer/waking_up
	icon_state = "wake_up"

/obj/screen/fullscreen/wraithoverlay
	icon = 'icons/effects/wraith.dmi'
	icon_state = "ghost"
	plane = 30
	layer = 30

/obj/screen/fullscreen/screamer_overlay
	icon = 'icons/effects/wraith.dmi'
	icon_state = "ghost"
	plane = 30
	layer = 30
	blend_mode = 3

/obj/screen/fullscreen/spacehero
	icon = 'icons/effects/fullscreen_overlay.dmi'
	icon_state = "space"
	plane = 30
	layer = 30

/obj/screen/fullscreen/DOB
	icon = 'icons/effects/fullscreen_overlay.dmi'
	icon_state = "dobnogore"
	plane = 30
	layer = 30
	alpha = 190
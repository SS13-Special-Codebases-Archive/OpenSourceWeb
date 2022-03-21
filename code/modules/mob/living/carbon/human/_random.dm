var/global/list/cornerdirs = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

/obj/effect/overlay/temp
	anchored = 1
	plane = ABOVE_HUMAN_PLANE
	mouse_opacity = 0
	var/duration = 10
	var/randomdir = TRUE

/obj/effect/overlay/temp/New()
	if(randomdir)
		dir = pick(cardinal)

	flick("[icon_state]", src) //Because we might be pulling it from a pool, flick whatever icon it uses so it starts at the start of the icon's animation.

	spawn(duration)
		qdel(src)

/obj/effect/overlay/temp/dir_setting/bloodsplatter
	icon = 'icons/effects/blood.dmi'
	duration = 5
	randomdir = FALSE
	layer = 6
	plane = 0
	color = "#C80000"
	var/splatter_type = "splatter"

/obj/effect/overlay/temp/dir_setting/bloodsplatter/New(loc, set_dir, blood_color)
	if(blood_color)
		color = blood_color
	if(set_dir in cornerdirs)
		icon_state = "[splatter_type][pick(1, 2, 6)]"
	else
		icon_state = "[splatter_type][pick(3, 4, 5)]"
	..()
	var/target_pixel_x = 0
	var/target_pixel_y = 0
	switch(set_dir)
		if(NORTH)
			target_pixel_y = 16
		if(SOUTH)
			target_pixel_y = -16
			layer = BASE_MOB_LAYER + 0.1
		if(EAST)
			target_pixel_x = 16
		if(WEST)
			target_pixel_x = -16
		if(NORTHEAST)
			target_pixel_x = 16
			target_pixel_y = 16
		if(NORTHWEST)
			target_pixel_x = -16
			target_pixel_y = 16
		if(SOUTHEAST)
			target_pixel_x = 16
			target_pixel_y = -16
			layer = BASE_MOB_LAYER + 0.1
		if(SOUTHWEST)
			target_pixel_x = -16
			target_pixel_y = -16
			layer = BASE_MOB_LAYER + 0.1
	animate(src, pixel_x = target_pixel_x, pixel_y = target_pixel_y, alpha = 0, time = duration)

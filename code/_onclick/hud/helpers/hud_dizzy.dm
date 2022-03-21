/client/var
	var/list/usingPlanes = list()

/obj/lighting_plane
	screen_loc = "1,1"
	plane = 25

	blend_mode = 4
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	// use 20% ambient lighting; be sure to add full alpha
	mouse_opacity = 0    // nothing on this plane is mouse-visible

/obj/screen_controller
	appearance_flags = PLANE_MASTER
	plane = 0
	screen_loc = "CENTER"
	render_target = "all"

/obj/render_controller
	appearance_flags = PLANE_MASTER
	plane = 10
	screen_loc = "CENTER"
	render_source = "all"
	mouse_opacity = 0

///obj/screen_controller/New()
//	add_filter("cor", 3, list("type" = "color", color=aspX, space=FILTER_COLOR_HSL))
//	add_filter("shadow", 4, list("type" = "drop_shadow", x=0, y=2, size=4, color = "#04080FAA"))

/mob/living/carbon/human/Life()
	..()
	if (client?.usingPlanes?.len > 1)
		return
	for(var/obj/screen_controller/S in client?.screen)
		client?.usingPlanes += S
	for(var/obj/blur_planemaster/B in client?.screen)
		client?.usingPlanes += B
	for(var/obj/screen/plane_master/P in client?.screen)
		client?.usingPlanes += P
	for(var/obj/lighting_plane/LP in client?.screen)
		client?.usingPlanes += LP
	for(var/obj/I in client?.usingPlanes)
		if(istype(I, /obj/blur_planemaster)) continue
		if(istype(I, /obj/lighting_plane)) continue
		//I.add_filter("cur", 1, list("type" = "bloom", size = 0.1, offset =0.2, alpha =55))
		//I.add_filter("cur", 1, list("type" = "blur", size = 0.4))
		//if(istype(I, /obj/screen/plane_master)) continue
		//I.add_filter("cor", 3, list("type" = "color", color=aspX, space=FILTER_COLOR_HSL))
		//I.add_filter("shadow", 4, list("type" = "drop_shadow", x=0, y=2, size=4, color = "#04080FAA"))

/mob/add_filter_effects()
	if(!client) return
	var/obj/screen_controller/p0 = new
	var/obj/blur_planemaster/p_1 = new
	var/obj/screen_controller/p2 = new
	var/obj/screen/plane_master/shadowcasting/p3 = new
	var/obj/screen_controller/p4 = new
	var/obj/screen_controller/p5 = new

	var/obj/screen/plane_master/vision_cone_target/VC = new //ALWAYS DEFINE THIS, WEIRD SHIT HAPPENS OTHERWISE
	var/obj/screen/plane_master/vision_cone/primary/mob = new//creating new masters to remove things from vision.
	var/obj/lighting_plane/lighting = new

	p0.plane = 0
	p0.render_target = "all"
	p_1.plane = -10
	p_1.render_target = "all-1"
	p2.plane = 15
	p2.render_target = "all2"
	p3.plane = SHADOWCASTING_PLANE
	p3.add_filter("turf_blocker", 5, list("type" = "alpha", render_source="all4", flags=MASK_INVERSE))
	p3.render_target = "all3"
	p4.plane = 21
	p4.render_target = "all4"
	p5.plane = 22
	p5.render_target = "all5"
	p5.add_filter("shadowcaster", 5, list("type" = "alpha", render_source="all3", flags=MASK_INVERSE))

	mob.plane = 10
	mob.render_target = "mob"


	//height
	p_1.add_filter("blur", 4, list("type" = "blur", size=1))
	//p6.add_filter("bloom", 5, list("type" = "bloom", threshold = "#f27d0c", size = 6, offset = 10, alpha = 100))

	client.screen.Add(p0, p_1, p2, p3, p4, p5, VC, mob, lighting)

/proc/screen_thingo_plane(var/obj/A, var/_x = 1.35, var/_y = 1.12)
	set waitfor = 0
	var/matrix/M = matrix()
	animate(A, transform = M.Scale(_x, _y), time = 3)
	sleep(3)
	animate(A, transform = null, time = 3)
	sleep(3)

/proc/screen_thingo_plane_alpha(var/obj/A)
	set waitfor = 0
	A.icon_state = "dark64"
	animate(A, alpha = 255, time = 3)
	sleep(3)
	animate(A, alpha = null, time = 3)
	sleep(3)

/proc/screen_loop(var/obj/A, var/intensity = 15, var/_x = 1.35, var/_y = 1.12)
	set waitfor = 0
	for(var/x = 0, x <= intensity, x++)
		screen_thingo_plane(A, _x, _y)
		sleep(6)

/proc/screen_loop_alpha(var/obj/A, var/intensity = 15)
	set waitfor = 0
	for(var/x = 0, x <= intensity, x++)
		screen_thingo_plane_alpha(A)
		if(x == intensity)
			A.icon_state = "dark128"
		sleep(6)

/mob/living/carbon/human/
	var/planerotated = FALSE

/mob/living/carbon/human/proc/rotate_plane(var/firefear = 0)
	set waitfor = 0
	if(planerotated)
		return
	if(src?.job == "Inquisitor" && Inquisitor_Type == "Fanatic")
		return
	planerotated = TRUE




	for(var/obj/I in client?.usingPlanes)
		screen_loop(I)

	if(moodscreen)
		screen_loop_alpha(moodscreen)
	//visible_message("<font color ='#649568'><b>[src]</b> sua frio em desespero.")
	to_chat(src, "<font color ='#649568'>Cold sweat drips down your face!</font>")
	if(firefear)
		src << 'red_fear.ogg'
	else if (src.gender == MALE)
		playsound(src.loc, pick('sound/voice/maletired1.ogg','sound/voice/maletired2.ogg','sound/voice/maletired3.ogg'), 90, 0, -1)
	else
		playsound(src.loc, pick('sound/voice/femtired1.ogg','sound/voice/femtired2.ogg','sound/voice/femtired3.ogg','sound/voice/femtired4.ogg'), 90, 0, -1)
	heart_beat_loop()

	planerotated = FALSE

/mob/living/carbon/human/proc/heart_beat()
	sleep(3)
	src << 'sound/voice/heartbeat_scared.ogg'

/mob/living/carbon/human/proc/blur(var/blurintensity = 1, var/time = 50)
	if(!client)
		return

	for(var/obj/I in client?.usingPlanes)
		if(I.plane == -10) continue //shitcode but if it's blur plane, don't blur it more.
		if(I.plane == 18) continue //shitcode but if it's SHADOWCASTING plane, don't blur it more.
		I.add_filter("blur", 20, list("type" = "blur"))
		var/filter = I.get_filter("blur")
		screen_blur(filter, blurintensity, time)
		spawn(time)
			I?.remove_filter("blur")

/proc/screen_blur(var/filter, var/size=1, time=50)
	set waitfor = 0
	animate(filter, size=1, time=50)


/mob/living/carbon/human/proc/heart_beat_loop(intensity = 15)
	for(var/x = 0, x <= intensity, x++)
		heart_beat()
		sleep(4)


/*
/mob/living/carbon/human/verb/rotate_coiso()
	set name = "Rotate Coiso"
	set waitfor = 0
	var/COISOX = rand(10, 25)/10
	var/COISOY = rand(10, 15)/10
	for(var/obj/light_controller/L in usr.client.screen)
		screen_loop(L, 10, COISOX, COISOY)
	for(var/obj/screen_controller/S in usr.client.screen)
		screen_loop(S, 10, COISOX, COISOY)

*/
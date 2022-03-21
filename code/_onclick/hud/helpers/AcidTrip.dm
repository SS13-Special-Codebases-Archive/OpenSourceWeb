//ACID TRIP BOLADAO

/obj/acid_tripper
	name = "Nigg nigg"
	mouse_opacity = 0
	icon = 'acidtrip.dmi'
	icon_state = "col2"
	plane = 16

/obj/texto
	name = "SUP MY NIGGA!"

/obj/texto/proc/Become(text="SOU NEGO", var/_y = 22, var/_x=-222, var/alphe = 255, var/planee = initial(src.plane))
	src.maptext = "<center><br><br><span style=\"\
			color: #04c918; \
			\"><font face='Deutsch Gothic'>[text]\
			</font></span></center>"
	src.maptext_height = 100
	src.maptext_width = 480
	src.maptext_y = _y
	src.maptext_x = _x
	src.alpha = alphe
	src.plane = planee
	screen_loc = "center"


/mob/living/carbon/human/proc/AcidTrip()
	set waitfor = 0
	src << 'sound/music/lsod.ogg'

	var/obj/acid_tripper/A = new
	var/obj/texto/T = new
	src.client.screen.Add(A)
	src.client.screen.Add(T)
	A.screen_loc = "CENTER"
	A.blend_mode = 4
	var/matrix/M = matrix()
	M.Translate(-1, 0)
	A.transform = M
	A.transform *= 11
	A.alpha = 190
	A.add_filter("bluzada", 30, list("type"="angular_blur", size=10))
	A.add_filter("blurzada", 30, list("type"="radial_blur", size=0.3))
	T.Become("[src.real_name]")


	for(var/obj/I in client?.usingPlanes)
		I.add_filter("acidtrip", 10, list("type" = "wave"))
		var/filtro = I.get_filter("acidtrip")
		acidTrippado(filtro)

/mob/living/carbon/human/proc/removeAcid()
	set waitfor = 0
	for(var/obj/acid_tripper/A in src?.client?.screen)
		src.client.screen -= A
		qdel(A)
	for(var/obj/texto/T in src?.client?.screen)
		src.client.screen -= T
		qdel(T)
	for(var/obj/I in client?.usingPlanes)
		I.remove_filter("acidtrip")

/proc/acidTrippado(var/filtro)
	while(1)
		var/time1= rand(15,25)
		animate(filtro, x=0, y=rand(90,140), size=1.5, offset=0, time=time1)
		sleep(time1)
		animate(filtro, x=0, y=rand(40, 70), size=0, time=5)
		sleep(5)

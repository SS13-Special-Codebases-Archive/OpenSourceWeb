/obj/proc/zoom_loop(var/mob/M)
	set waitfor = 0
	for(var/i; i<= 40, i++)
		zoom_in_out()
		sleep(200)
		if(i == 11)
			for(var/obj/I in M?.client?.usingPlanes)
				I.remove_filter("cor")
				I.transform = null
			break

/obj/proc/zoom_in_out()
	set waitfor = 0
	var/FinalValue = 1.25
	var/matrix/M = matrix()
	animate(src, transform = M.Scale(FinalValue, FinalValue), time = 100, easing = SINE_EASING)
	sleep(100)
	animate(src, transform = null, time = 100)
	sleep(100)

/mob/proc/so_high()
	if(!client) return
	for(var/obj/I in client?.usingPlanes)
		var/static/list/col_filter_blue = list(1,0,0,0, 0,1,0,0, 0,0,1.2,0, 0,0,0,1, 0.000,0,0,0)
		I.add_filter("cor", 20, list("type" = "color", "color" = col_filter_blue))
		I.zoom_loop(src)
/obj/proc/cocainum(var/filter)
	set waitfor = 0
	var/static/list/col_filter_brancaco = list(6,0,0,0, 0,6,0,0, 0,0,6,0, 0,0,0,1, 0.000,0,0,0)
	var/static/list/col_filter_brancaco2 = list(1.5,0,0,0, 0,1.5,0,0, 0,0,1.5,0, 0,0,0,1, 0.000,0,0,0)
	animate(filter, color = col_filter_brancaco, time = 10)
	sleep(10)
	animate(filter, color = null, time = 10)
	sleep(10)
	animate(filter, color = col_filter_brancaco2, time = 10)

/obj/proc/cocainum_shake()
	set waitfor = 0
	var/matrix/M = matrix()
	var/time = 0.5
	animate(src, transform = M.Translate(1, 0), time = time, easing = SINE_EASING)
	sleep(time)
	animate(src, transform = M.Translate(-1, 0), time = time, easing = SINE_EASING)
	sleep(time)
	animate(src, transform = null, time = time, easing = SINE_EASING)
	sleep(time)

/obj/proc/cocainum_shake_loop(var/mob/M)
	set waitfor = 0
	for(var/i; i<= 2000, i++)
		cocainum_shake()
		sleep(1.5)

/mob/proc/COCAINA()
	set waitfor = 0
	if(!client) return
	for(var/obj/screen_controller/S in client?.screen)
		S.add_filter("cor", 20, list("type" = "color", "color" = list(1.8,0,0,0, 0,1.8,0,0, 0,0,1.8,0, 0,0,0,1, 0.000,0,0,0)))
		var/filter = S.get_filter("cor")
		S.cocainum(filter)
		S.cocainum_shake_loop()
/obj/structure/pendulum
	name = "pendulum clock"
	desc = "A pendulum clock. Tick, tack."
	icon = 'icons/obj/miscobjs.dmi'
	icon_state = "pclock"
	density = 1
	anchored = 1
	var/time_till_click_clack = 7
	var/tick_tack = 0

/obj/structure/pendulum/process()
	tick_tack++
	if(tick_tack >= time_till_click_clack)
		playsound(src, 'sound/webbers/clock_ticking.ogg', 70, wait=1, repeat=0)
		tick_tack = initial(tick_tack)

/obj/structure/pendulum/New()
	processing_objects.Add(src)
	..()

/obj/structure/pendulum/Destroy()
	processing_objects.Remove(src)
	..()


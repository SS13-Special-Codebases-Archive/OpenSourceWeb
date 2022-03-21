/mob/living/carbon/human/var
	hasfilter = FALSE

	var/list/LISTSCRR = list(1,0,0, 0,1.9,0, 0,0,1, 0,0,0)


/mob/living/carbon/human/Life()
	..()
	if(src.DeadEyes)
		client?.color = "#a4b5fc"
	else
		if(!hasfilter)
			var/tmp/obj/screen_controller/S = new
			S.filters = filter(type="color",color=src.LISTSCRR,space=FILTER_COLOR_HSV)
			src.client.screen.Add(S)
			hasfilter = TRUE

/obj/screen
	appearance_flags = NO_CLIENT_COLOR

/turf/simulated/floor/open
	appearance_flags = NO_CLIENT_COLOR
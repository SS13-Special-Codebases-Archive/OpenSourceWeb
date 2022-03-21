

var/list/LISTSCRRDEADEYE = list(0.77, 0,0 , 0,\
			 					0, 1, 0, 0,\
								0, 0, 0.77, 0,\
								0, 0, 0, 1)

//var/list/LISTSCRR = rgb(191, 207, 188)

var/list/LISTSCRR = list( 1, 0, 0, 0,\
						 0, 1.1, 0, 0,\
					 	 0, 0, 1, 0,\
	 	 				 0, 0, 0, 1)

/mob/living/carbon/human/Life()
	..()
	if(src.DeadEyes)
		client?.color = "#a4b5fc"
	else
		client?.color = LISTSCRR

/obj/screen
	appearance_flags = NO_CLIENT_COLOR

/turf/simulated/floor/open
	appearance_flags = NO_CLIENT_COLOR
var/list/BasicList = list( 1, 0, 0, 0,\
						 0, 1, 0, 0,\
					 	 0, 0, 1, 0,\
	 	 				 0, 0, 0, 1)


/mob/living/carbon/human/Life()
	. = ..()
	if(client && istype(client) && !iszombie(src) && !isskeleton(src) && stat != DEAD)
		animate(client, color = BasicList, time = 1)

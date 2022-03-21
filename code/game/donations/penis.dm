/mob/living/carbon/human/New()
	..()
	if(!client)
		return
	if(thirtycm.Find(ckey))
		potenzia = rand(30, 32)
//XD
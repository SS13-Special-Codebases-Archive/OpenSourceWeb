/*
/mob/living/carbon
	var/mob/living/carbon/friend

/mob/living/carbon/RightClick(mob/M as mob, mob/user as mob)
	var/mob/living/carbon/H = usr
	H.friend = src
	if(H.a_intent == "help")
		H.give()
*/

/mob/living/carbon/RightClick(mob/user)
	var/mob/living/carbon/H = usr
	if(H.a_intent == "grab")
		if(/mob/proc/yank_out_object in verbs)
			src.yank_out_object(H)
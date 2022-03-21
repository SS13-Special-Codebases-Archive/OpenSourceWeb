#define NULL null
#define elif else if

/mob/living/carbon/human/proc/empty_active_hand()
	if(get_active_hand() == null)
		return 1
	else
		return 0
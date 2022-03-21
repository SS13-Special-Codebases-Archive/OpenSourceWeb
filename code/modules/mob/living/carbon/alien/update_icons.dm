/mob/living/carbon/alien/regenerate_icons()
	overlays = list()
	update_icons()

/mob/living/carbon/alien/update_icons()
	if(stat == DEAD)
		icon_state = "[initial(icon_state)]2"

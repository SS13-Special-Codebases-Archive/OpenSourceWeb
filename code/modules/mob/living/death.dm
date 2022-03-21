/mob/living
	death(gibbed)
		if (!gibbed)
			update_canmove()
			reset_hud_vision()

		if(!ishuman(src))
			sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO
    	// Save the time of death to the mind
		tod = worldtime2text()
		if(mind)
			mind.store_memory("Time of death: [tod]", 0)

		return ..(gibbed)
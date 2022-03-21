/mob/new_player/Logout()
	ready = 0
	if(ticker.migrants_inwave.Find(src.client))
		ticker.migrants_inwave.Remove(src.client)
	..()
	if(!spawning)//Here so that if they are spawning and log out, the other procs can play out and they will have a mob to come back to.
		key = null//We null their key before deleting the mob, so they are properly kicked out.
		qdel(src)
	return
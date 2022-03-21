/mob/dead/observer/Logout()
	..()
	if(latepartied)
		latepartied = FALSE
		latepartynum -= 1
	if(latepartied_list.Find(src))
		latepartied_list.Remove(src)
	spawn(0)
		if(src && !key)	//we've transferred to another mob. This ghost should be deleted.
			qdel(src)

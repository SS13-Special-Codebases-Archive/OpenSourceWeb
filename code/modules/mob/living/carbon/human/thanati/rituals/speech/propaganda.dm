/proc/propaganda(var/text = null, var/mob/user, var/turf/C)
	for(var/obj/item/weapon/paper/P in C)
		if(!P.info)
			return
		if(P.usedThanati)
			return

		log_game("[user.real_name]/[user.key] PROPAGANDA: [P.info]")
		for(var/mob/living/carbon/human/H in mob_list)
			var/obj/item/weapon/paper/propaganda/T = new
			T.info = P.info
			T.loc = H.loc
		P.usedThanati = 1
		return 1
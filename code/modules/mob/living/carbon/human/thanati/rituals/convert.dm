/proc/convert(var/text = null, var/mob/usr, var/turf/C)
	for(var/mob/living/carbon/human/H in C.contents)

		if(H == usr && H.religion == "Thanati")
			var/list/A = list()
			playsound(C, 'sigil.ogg', 100)
			for(var/obj/effect/decal/cleanable/thanati/C/THANATI in world)
				if(THANATI.x == usr.x && THANATI.y == usr.y && THANATI.z == usr.z)
					continue
				A.Add(THANATI)
			var/atom/ATOMO = pick(A)
			usr.x = ATOMO.x
			usr.y = ATOMO.y
			usr.z = ATOMO.z
			playsound(ATOMO	, 'sigil.ogg', 100)
			return

		if(H.religion == "Thanati")
			return
		if(H.religion == "Allah") // Hashim asks, "What have I done?"; Hashim calls for Tzchernobog!
			return
		if(!H.client)
			return
		if(H != usr)
			return
		switch(H.job)
			if("Incarn")
				H.client.ChromieWinorLoose(H.client, -1)
			if("Inquisitor")
				H.client.ChromieWinorLoose(H.client , -5)
			if("Bishop" || "Priest")
				H.client.ChromieWinorLoose(H.client, -10)
		to_chat(H, "Your mind is filled with thoughts that you once saw as heretics, giving you an overwhelming desire to glorify the overlord.")
		H.religion = "Thanati"
		log_game("[H.real_name]([H?.key]) has been converted to Thanati by [usr]([usr?.key]).")
		H.praiselord()
		return
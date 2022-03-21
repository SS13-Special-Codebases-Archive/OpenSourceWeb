/proc/malignant(var/text = null, var/mob/usr, var/turf/C)
	for(var/mob/living/carbon/human/H in C.contents)
		if(H==usr) continue
		var/obj/item/tzchernobog/T = locate() in H.organ_storage.contents
		if(T)
			H.zombify()
			if(H.client)
				to_chat(H, "You're now [usr]'s servant.")
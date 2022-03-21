/proc/thecall(var/text = null, var/mob/usr, var/turf/C)
    for(var/obj/item/weapon/photo/P in C.contents)
        for(var/mob/living/carbon/human/H in P.info)
            if(H.pulledThanati)
                return
            if(istype(H.amulet, /obj/item/clothing/head/amulet/holy/cross))
                return
            H.x = C.x
            H.y = C.y
            H.z = C.z
            H.rotate_plane()
            return 1
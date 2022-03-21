/proc/falseTarget(var/text = null, var/mob/usr, var/turf/C)
    for(var/obj/item/weapon/photo/P in C.contents)
        for(var/mob/living/carbon/human/H in P.info)
            if(istype(H.amulet, /obj/item/clothing/head/amulet/holy/cross))
                return
            H.falsetarget = 1
            to_chat(usr, "<i><b>Falsified.</b></i>")
/proc/armorOfFaith(var/text = null, var/mob/usr, var/turf/C)
    for(var/obj/item/clothing/suit/storage/thanati/thanati/A in C.contents)
        if(A.contents)
            new /obj/item/clothing/suit/storage/thanati/thanatiblack/maskincluded(C)
        else
            new /obj/item/clothing/suit/storage/thanati/thanatiblack(C)
        qdel(A)
        to_chat(usr, "<b>The robes darken, transforming into something more strong.</b>")


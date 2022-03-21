/proc/grandGathering(var/text = null, var/mob/usr, var/turf/C)
    for(var/mob/living/carbon/human/H in player_list)
        if(H.religion == "Thanati")
            if(istype(H.amulet, /obj/item/clothing/head/amulet/holy/cross)) // don't wear the cross thanati :troll:
                return
            if(usr)
                return
            H.visible_message("<b>[H] disappears!</b>", "You vanish!", "You feel different.")
            H.x = C.x
            H.y = C.y
            H.z = C.z
            to_chat(H, "<b>GATHER!</b>")
            return 1
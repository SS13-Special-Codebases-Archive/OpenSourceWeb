/proc/becomeMonster(var/text = null, var/mob/usr, var/turf/C)
    for(var/mob/living/carbon/human/monster/G in C.contents)
        if(usr?.mind)
            G.rejuvenate()
            usr.mind.transfer_to(G)
            return 1
        return 0
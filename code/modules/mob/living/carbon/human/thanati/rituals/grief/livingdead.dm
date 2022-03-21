var/global/livingDead = 0

/proc/livingDead(var/text = null, var/mob/usr, var/turf/C)
    if(livingDead)
        return
    if(!player_list.len)
        return
    for(var/mob/living/carbon/human/H in world)
        if(H.species.name == "Zombie")
            H.my_stats.st = 20 + rand(2, 5)
    to_chat(usr, "Screamers are coming...")
    livingDead = 1


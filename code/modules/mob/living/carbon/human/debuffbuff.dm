/mob/living/carbon/human
    var/list/buffs = list()

/mob/living/carbon/human/proc/dbuff(var/stat = "st", var/numb = 0, var/id = null, var/hidden = FALSE)
    if(!id) id = "[rand(0, 2000)]";
    var/list/N = list(id, stat, numb, hidden)

    for(var/list/L in buffs)
        if(L[1] == N[1])
            L = N
            return

    buffs.Add(list(id, stat, numb, hidden))

/mob/living/carbon/human/proc/rmvdbuff(var/id = null)
    if(!id) return

    for(var/x = 1; x != buffs.len; x++)
        if(buffs[x][1] == id)
            buffs -= buffs[x][1]
            return 1
    return

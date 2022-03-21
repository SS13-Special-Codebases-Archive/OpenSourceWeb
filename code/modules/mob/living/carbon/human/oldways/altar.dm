/obj/structure/rack/lwtable/altar
    name = "altar"
    icon = 'icons/mining.dmi'
    icon_state = "pagan_altar"

/obj/item/dropped()
    ..()
    pixel_x = rand(-9, 10)
    pixel_y = rand(-9, 10)

    if(!ishuman(usr))
        return
    if(!loc?.contents.len)
        return
    for(var/obj/structure/rack/lwtable/altar/LW in loc.contents)
        var/mob/living/carbon/human/H = usr
        for(var/direction in cardinal)
            var/turf/T = get_step(src, direction)
            for(var/obj/structure/oldways/S in T.contents)
                if(!H.old_ways.god)
                    return

                H.old_ways.piety += item_worth
                sacrificedItem = 1
                return 1
        return 1
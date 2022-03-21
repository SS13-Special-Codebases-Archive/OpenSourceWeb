/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"
	heavy = FALSE

/obj/structure/closet/coffin/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/coffin/Entered(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.buried = TRUE
	..()

/obj/structure/closet/coffin/Exited(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.in_stasis = 0
		H.buried = FALSE
	. = ..()

/obj/structure/closet/coffin/wood
	name = "Wooden coffin"
	icon_state = "woodencoffin"
	icon_closed = "woodencoffin"
	icon_opened = "woodencoffin_open"

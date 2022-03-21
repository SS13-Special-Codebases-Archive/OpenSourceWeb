/obj/structure/statue
	name = "statue"
	desc = "A statue."
	icon = 'icons/obj/bigstatutess.dmi'
	layer = MOB_LAYER+1

	plane = 15
	var/health = 5000
	opacity = 0
	density = 0
	anchored = 1
	var/width = 2

/obj/structure/statue/Destroy()
	for(var/obj/structure/xd in range(1,src))
		qdel(src)

/obj/structure/statue/statueb
	icon_state = "statue_btop"

/obj/structure/statue/statuebbottom
	icon_state = "statue_bbottom"


/obj/structure/statue/statuej
	icon_state = "statue_jtop"

/obj/structure/statue/statuejbottom
	icon_state = "statue_jbottom"

/obj/structure/statue/statuerahl
	icon_state = "statue_rahltop"

/obj/structure/statue/statuerahlbottom
	icon_state = "statue_rahlbottom"

/obj/structure/statuespooky
	name = "statue"
	desc = "A statue."
	icon = 'icons/obj/statues_spooky.dmi'
	layer = MOB_LAYER+1
	opacity = 0
	density = 0
	anchored = 1
	plane = 22

/obj/structure/statuespooky/angel_cool
	icon_state = "angel_cool"

/obj/structure/statuespooky/openhelmet_guy
	icon_state = "openhelmet_guy"

/obj/structure/statuespooky/creepy
	icon_state = "creepy"

/obj/structure/statuespooky/cooldecal
	icon_state = "cooldecal"

/obj/structure/statuespooky/pilar1
	icon_state = "pilar1"

/obj/structure/statuespooky/pilar2
	icon_state = "pilar2"

/obj/structure/statuespooky/pillar
	icon = 'icons/obj/pillar.dmi'
	icon_state = "pillar"

/obj/structure/statuespooky/angel_right
	icon_state = "AngelRight"

/obj/structure/statuespooky/angel_left
	icon_state = "AngelLeft"

/obj/structure/statuespooky/defender
	icon_state = "defender"

/obj/structure/leviathan_statue
	name = "statue"
	desc = "A statue."
	icon_state = "entrance"
	icon = 'icons/effects/96x96.dmi'
	layer = MOB_LAYER+1

	var/health = 5000
	opacity = 0
	density = 0
	anchored = 1
	var/width = 2
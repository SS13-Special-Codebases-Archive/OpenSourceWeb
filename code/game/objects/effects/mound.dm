/obj/effect/mound
	name = "mound"
	desc = "A mound of dirt."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/obj/objects.dmi'
	icon_state = "mound"

/obj/effect/mound/Crossed(mob/living/carbon/human/M as mob|obj)
	if(isliving(M))
		M.canmove = 0
		M.pixel_y = 16
		spawn(5)
			M.canmove = 1

/obj/effect/mound/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/shovel))
		visible_message("<span class='notice'>\The [user] starts removing \the [src]</span>")
		playsound(src, 'sound/effects/dig_shovel.ogg', 50, 1)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(do_after(user,40))
			playsound(src, 'sound/effects/empty_shovel.ogg', 50, 1)
			qdel(src)

/obj/structure/rock
	name = "rock"
	desc = "A mount of rock."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/obj/decals.dmi'
	icon_state = "rock1"
	breakable = TRUE

/obj/structure/rock/New()
	..()
	dir = pick(alldirs)

/obj/structure/rock/Crossed(mob/living/carbon/human/M as mob|obj)
	if(isliving(M))
		M.canmove = 0
		M.pixel_y = 6
		spawn(5)
			M.canmove = 1
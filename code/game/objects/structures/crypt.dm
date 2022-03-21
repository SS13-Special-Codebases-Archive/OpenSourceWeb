/obj/structure/morgueslab
	name = "morgue"
	desc = "A morgue."
	icon = 'icons/obj/miscobjs.dmi'
	icon_state = "morgue0"
	opacity = 0
	density = 1
	anchored = 1

/obj/structure/morgueslab/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user as mob)
	if (C == user)
		user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>lays on the morgue slab.</span>","<span class='passive'>I climb on the morgue slab.</span>")
	else
		visible_message("<span class='combatbold'>[C]</span> <span class='combat'>has been laid on the morgue slab by</span> <span class='combatbold'>[user]</span><span class='combat'>.</span>", 3)
	if (C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.resting = 1
	C.loc = src.loc
	for(var/obj/O in src)
		O.loc = src.loc
	src.add_fingerprint(user)

/obj/structure/morgueslab/attackby(obj/item/weapon/W as obj, mob/living/carbon/user as mob)
	if (istype(W, /obj/item/weapon/grab))
		if(iscarbon(W:affecting))
			take_victim(W:affecting,usr)
			qdel(W)
			return
	user.drop_item()
	if(W && W.loc)
		W.loc = src.loc
	return

/obj/structure/morgueplate
	name = "morgue plate"
	desc = "A morgue."
	icon = 'icons/obj/miscobjs.dmi'
	icon_state = "mplate0"
	opacity = 0
	density = 0
	anchored = 1
	plane = 21

/obj/structure/morgueplate/attackby(obj/item/weapon/W as obj, mob/living/carbon/user as mob)
	playsound(src.loc, 'sound/lfwbsounds/obj_stone_generic_switch_enter_01.ogg', 100, 1)
	if (istype(W, /obj/item/weapon/chisel))
		if(do_after(user, 20))
			icon_state = "mplate1"
			for(var/mob/living/carbon/human/H in range(1))
				var/obj/structure/morgueplate/M = locate() in H.loc
				if(M)
					H.buried = TRUE
					src.name = "Aqui Jaz [H.real_name]"
					src.desc = "Corpo de [H.real_name]"
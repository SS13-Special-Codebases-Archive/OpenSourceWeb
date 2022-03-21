/*
/obj/item/weapon/toolbox_hole
	name = "toolbox with holes"
	icon = 'icons/obj/assemblies/toolbox_hole.dmi'
	desc = "A toolbox with two holes in it's top and bottom."
	icon_state = "tbx_b"
	item_state = "toolbox_blue"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 3.0
	throwforce = 4.0
	throw_speed = 1
	throw_range = 7
	w_class = 4.0
	attack_verb = list("robusted")

	New()
		..()
		if (src.type == /obj/item/weapon/toolbox_hole)
			world << "BAD: [src] ([src.type]) spawned at [src.x] [src.y] [src.z]"
			qdel(src)


/obj/item/weapon/toolbox_hole/blue
	icon_state = "tbx_b"
	item_state = "toolbox_blue"

/obj/item/weapon/toolbox_hole/yellow
	icon_state = "tbx_y"
	item_state = "toolbox_yellow"

/obj/item/weapon/toolbox_hole/red
	icon_state = "tbx_r"
	item_state = "toolbox_red"
*/




/*
/obj/item/weapon/toolbox_hole/attackby(var/obj/T, mob/user as mob)
	if(istype(T, /obj/item/stack/rods))
		if(src.type == /obj/item/weapon/toolbox_hole/blue/)
*/
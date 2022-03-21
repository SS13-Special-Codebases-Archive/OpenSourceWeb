/obj/item/weapon/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 7
	w_class = 4.0
	origin_tech = "combat=1"
	attack_verb = list("robusted")

	New()
		..()
		if (src.type == /obj/item/weapon/storage/toolbox)
			world << "BAD: [src] ([src.type]) spawned at [src.x] [src.y] [src.z]"
			qdel(src)

/obj/item/weapon/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"

	New()
		..()
		new /obj/item/weapon/crowbar/red(src)
		new /obj/item/weapon/extinguisher/mini(src)
		if(prob(50))
			new /obj/item/device/flashlight(src)
		else
			new /obj/item/device/flashlight/flare(src)
		new /obj/item/device/radio(src)

/obj/item/weapon/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"

	New()
		..()
		new /obj/item/weapon/screwdriver(src)
		new /obj/item/weapon/wrench(src)
		new /obj/item/weapon/weldingtool(src)
		new /obj/item/weapon/crowbar(src)
		new /obj/item/device/analyzer(src)
		new /obj/item/weapon/wirecutters(src)


/obj/item/weapon/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"

	New()
		..()
		var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
		new /obj/item/weapon/screwdriver(src)
		new /obj/item/weapon/wirecutters(src)
		new /obj/item/device/t_scanner(src)
		new /obj/item/weapon/crowbar(src)
		new /obj/item/stack/cable_coil(src,30,color)
		new /obj/item/stack/cable_coil(src,30,color)
		if(prob(5))
			new /obj/item/clothing/gloves/yellow(src)
		else
			new /obj/item/stack/cable_coil(src,30,color)

/obj/item/weapon/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = "combat=1;syndicate=1"
	force = 7.0

	New()
		..()
		var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
		new /obj/item/weapon/screwdriver(src)
		new /obj/item/weapon/wrench(src)
		new /obj/item/weapon/weldingtool(src)
		new /obj/item/weapon/crowbar(src)
		new /obj/item/stack/cable_coil(src,30,color)
		new /obj/item/weapon/wirecutters(src)
		new /obj/item/device/multitool(src)

/*
/obj/item/weapon/storage/toolbox/attackby(var/obj/T, mob/user as mob)
	if(src.type == /obj/item/weapon/storage/toolbox/mechanical/)
		if(istype(T, /obj/item/stack/tile/plasteel))
			if(src.contents.len >= 1)
				user << "<span class='notice'>They wont fit in as there is already stuff inside.</span>"
				return
			if(user.s_active)
				user.s_active.close(user)
			qdel(T)
			var/obj/item/weapon/toolbox_tiles/B = new /obj/item/weapon/toolbox_tiles
			user.put_in_hands(B)
			user << "<span class='notice'>You add the tiles into the empty toolbox. They protrude from the top.</span>"
			user.drop_from_inventory(src)
			qdel(src)
	if(istype(T,/obj/item/weapon/surgery_tool/surgicaldrill))
		if(src.contents.len >= 1)
			user << "<span class='notice'>The [src] can not be drilled as there are some objects inside.</span>"
			return
		if(src.type == /obj/item/weapon/storage/toolbox/mechanical/)
			var/obj/item/weapon/toolbox_hole/blue/B = new /obj/item/weapon/toolbox_hole/blue
			user.put_in_hands(B)
			user << "<span class='notice'>You drill two holes in [src], in it's top and it's bottom.</span>"
			user.drop_from_inventory(src)
			qdel(src)
		if(src.type == /obj/item/weapon/storage/toolbox/electrical/)
			var/obj/item/weapon/toolbox_hole/blue/B = new /obj/item/weapon/toolbox_hole/yellow
			user.put_in_hands(B)
			user << "<span class='notice'>You drill two holes in [src], in it's top and it's bottom.</span>"
			user.drop_from_inventory(src)
			qdel(src)
		if(src.type == /obj/item/weapon/storage/toolbox/emergency/)
			var/obj/item/weapon/toolbox_hole/blue/B = new /obj/item/weapon/toolbox_hole/red
			user.put_in_hands(B)
			user << "<span class='notice'>You drill two holes in [src], in it's top and it's bottom.</span>"
			user.drop_from_inventory(src)
			qdel(src)
*/
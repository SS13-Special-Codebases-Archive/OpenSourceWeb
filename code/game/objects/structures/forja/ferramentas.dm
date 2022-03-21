/obj/item/weapon/sledgehammer
	name = "sledgehammer"
	icon_state = "sledgehammer"
	item_state = "sledge"
	force = 8
	w_class = 5
	throwforce = 10
	force_wielded = 38
	force_unwielded = 8
	parry_chance = -10
	weight = 34
	hitsound= 'sound/weapons/club.ogg'
	wielded_icon = "sledge-wielded"
	can_be_smelted_to = /obj/item/weapon/ore/refined/lw/ironlw

/obj/item/weapon/carverhammer
	name = "carver hammer"
	icon_state = "carverhammer"
	item_state = "hammer"
	force = 18
	force_wielded = 22
	desc = "Carve your way."
	w_class = 2
	throwforce = 10
	parry_chance = 1
	slot_flags = SLOT_BELT
	weight = 3

/obj/item/weapon/chisel
	name = "chisel"
	icon = 'icons/obj/items.dmi'
	icon_state = "chisel"
	item_state = "chisel"
	force = 8
	w_class = 1
	sharp = 1
	throwforce = 10
	parry_chance = 1
	weight = 1

/obj/item/weapon/alicate
	name = "tongs"
	desc = "Steel pliers used by blacksmiths to be able to hold hot metals."
	icon_state = "tongs"
	item_state = "crowbar"
	w_class = 3
	slot_flags = SLOT_BELT
	force = 5
	weight = 1

/obj/item/weapon/alicate/update_icon()
	if(contents.len && istype(contents, subtypesof(/obj/item/weapon/ore/refined/lw)))
		var/obj/item/weapon/ore/refined/lw/lw = safepick(contents)
		if(lw.temperatura)
			icon_state = "tongs_ingot1"
		else
			icon_state = "tongs_ingot0"
	else
		icon_state = "tongs"
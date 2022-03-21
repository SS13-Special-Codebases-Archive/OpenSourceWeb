/obj/structure/merchant_crates
	name = "crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "securecrate"
	density = 1
	heavy = TRUE
	var/locked = TRUE
	var/icon_opened = "securecrateopen"
	var/icon_closed = "securecrate"
	var/obj/item/weapon/storage/touchable/storage_inside

/obj/structure/merchant_crates/New()
	..()
	storage_inside = new /obj/item/weapon/storage/touchable(src)

/obj/structure/merchant_crates/Destroy()
	qdel(storage_inside)
	..()

/obj/structure/merchant_crates/attack_hand(mob/living/carbon/human/user as mob)
	if(locked)
		to_chat(user, "<span class='combat'>Crate is locked.</span>")
		return
	else
		storage_inside.orient2hud(user)
		storage_inside.show_to(user)
	..()


/obj/structure/merchant_crates/RightClick(mob/living/carbon/human/user as mob)
	if(ishuman(user) && user.wear_id)
		var/obj/item/weapon/card/id/idcard = user.wear_id
		if(!(req_access & idcard.access)) return
		if(locked)
			locked = FALSE
			playsound(src.loc, 'iron_crate_open.ogg', 40, 1, -3)
			update_icon()
		else
			locked = TRUE
			playsound(src.loc, 'iron_crate_close.ogg', 40, 1, -3)
			update_icon()

/obj/structure/merchant_crates/update_icon()
	if(locked)	icon_state = "securecrate"
	else	icon_state = "securecrateopen"

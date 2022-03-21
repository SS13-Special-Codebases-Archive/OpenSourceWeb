/obj/item/weapon/fishing_rod
	name = "fishing rod"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "fishingrod0"
	item_state = "fishingrod"
	var/worms
	slot_flags = SLOT_BELT
	w_class = 4

/obj/item/weapon/fishing_rod/update_icon()
	if(!worms)
		icon_state = "fishingrod0"
	else
		icon_state = "fishingrod1"

/obj/item/weapon/fishing_rod/attackby(I as obj, user as mob)
	if(worms)
		return
	if(istype(I,/obj/item/weapon/reagent_containers/food/snacks/worms))
		var/obj/item/weapon/reagent_containers/food/snacks/worms/W = I
		if(W.bitesize <= 1)
			qdel(W)
		else
			if(!worms)
				worms = 1
				W.bitesize -= 1
				src.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>puts a worm in \the [src]'s hook</span>")
				src.update_icon()
				W.update_icon()

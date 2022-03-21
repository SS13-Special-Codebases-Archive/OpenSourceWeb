//Items labled as 'trash' for the trash bag.
//TODO: Make this an item var or something...

//Added by Jack Rost
/obj/item/trash
	icon = 'icons/obj/trash.dmi'
	w_class = 1.0
	desc = "This is rubbish."
	raisins
		name = "trash"
		icon_state= "4no_raisins"
	candy
		name = "trash"
		icon_state= "candy"
	cheesie
		name = "trash"
		icon_state = "cheesie_honkers"
	chips
		name = "trash"
		icon_state = "chips"
	popcorn
		name = "trash"
		icon_state = "popcorn"
	sosjerky
		name = "trash"
		icon_state = "sosjerky"
	syndi_cakes
		name = "trash"
		icon_state = "syndi_cakes"
	waffles
		name = "trash"
		icon_state = "waffles"
	plate
		name = "trash"
		icon_state = "stool"
	snack_bowl
		name = "trash"
		icon_state	= "candy2"
	pistachios
		name = "trash"
		icon_state = "pistachios_pack"
	semki
		name = "trash"
		icon_state = "semki_pack"
	tray
		name = "trash"
		icon_state = "tray"
	candle
		name = "candle"
		icon = 'icons/obj/candle.dmi'
		icon_state = "candle4"

/obj/item/trash/attack(mob/M as mob, mob/living/user as mob)
	return

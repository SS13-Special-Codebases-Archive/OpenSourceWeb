/obj/item/clothing/mask/balaclava
	name = "balaclava"
	icon_state = "balaclava"
	item_state = "balaclava"
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2
	var/cut_open = FALSE

/obj/item/clothing/mask/balaclava/attackby(obj/item/W as obj, mob/user as mob)
	if(W.sharp && !cut_open)
		if (do_after(user, 20))
			cut_open = TRUE
			to_chat(user, "You cut a hole in \the [src]")
			icon_state = "balaclava-o"
			item_state = "balaclava-o"
	else
		..()

/obj/item/clothing/mask/chicken
	name = "chicken suit head"
	desc = "Bkaw!"
	icon_state = "chickenhead"
	item_state = "chickensuit"
	flags = FPRINT | TABLEPASS | BLOCKHAIR
	siemens_coefficient = 2.0
	flags_inv = HIDEFACE

/obj/item/clothing/mask/balaclava/tactical
	name = "green balaclava"
	desc = "Designed to both hide identities and keep your face comfy and warm."
	icon_state = "swatclava"
	item_state = "balaclava"
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2

/obj/item/clothing/mask/luchador
	name = "Luchador Mask"
	desc = "Worn by robust fighters, flying high to defeat their foes!"
	icon_state = "luchag"
	item_state = "luchag"
	flags = FPRINT|TABLEPASS|BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2
	siemens_coefficient = 3.0

/obj/item/clothing/mask/luchador/tecnicos
	name = "Tecnicos Mask"
	desc = "Worn by robust fighters who uphold justice and fight honorably."
	icon_state = "luchador"
	item_state = "luchador"

/obj/item/clothing/mask/luchador/rudos
	name = "Rudos Mask"
	desc = "Worn by robust fighters who are willing to do anything to win."
	icon_state = "luchar"
	item_state = "luchar"
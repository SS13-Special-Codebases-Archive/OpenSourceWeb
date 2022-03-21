/obj/item
	var/neck_use = FALSE

/obj/item/clothing/head/amulet/scarf
	name = "scarf"
	desc = "A piece of fabric to keep your neck warm."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "lscarf"
	item_state = "lscarf"
	neck_use = TRUE
	item_worth = 5

/obj/item/clothing/head/amulet/collar
	name = "spiked collar"
	desc = "Punk."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "spiked_collar"
	item_state = "spiked_collar"
	neck_use = TRUE
	body_parts_covered = THROAT
	item_worth = 5
	armor = list(melee = 40)

/obj/item/clothing/head/amulet/breaker
	name = "slave collar"
	desc = "A collar that disables the user."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "collar"
	item_state = "collar"
	neck_use = TRUE
	item_worth = 5
	w_class = 1.0


/obj/item/clothing/head/amulet/goldeneck
	name = "gold chain"
	desc = "Show off your bling."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "gchain"
	item_state = "gchain"
	neck_use = TRUE
	item_worth = 5

/obj/item/clothing/head/amulet/lechery
	name = "grey amulet"
	desc = "It has bite marks."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "meda1"
	item_state = "wolf1"
	neck_use = TRUE
	item_worth = 30

/obj/item/clothing/head/amulet/lechery/bite_act(mob/M as mob)
	. = ..()
	var/mob/living/carbon/human/H = M
	if((get_dist(src,M) >= 2) && loc != M)
		return
	H.visible_message("<span class='bname'>⠀[H]</span> bites \the [src]!</span>")
	H.erpcooldown = 0
	H.resistenza = 200

/obj/item/clothing/head/amulet/holy/cross
	name = "cross"
	desc = "A holy amulet to wear around your neck."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "cross"
	item_state = "cross"
	neck_use = TRUE
	item_worth = 18
	equipped(mob/M)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.religion == LEGAL_RELIGION)
				H.add_event("godsave", /datum/happiness_event/misc/godsave)

/obj/item/clothing/head/amulet/holy/cross/copper
	name = "copper cross"
	desc = "A holy amulet to wear around your neck."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "ccross"
	item_state = "ccross"
	item_worth = 20

/obj/item/clothing/head/amulet/holy/cross/gcopper
	name = "gold cross"
	desc = "A holy amulet to wear around your neck."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "gcross"
	item_state = "gcross"
	item_worth = 120

/obj/item/clothing/head/amulet/holy/cross/old
	name = "ancient cross"
	desc = "A holy amulet to wear around your neck."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "oldcross"
	item_state = "cross"
	item_worth = 8

/obj/item/clothing/head/amulet/epitrachelion
	name = "epitrachelion"
	desc = "The symbol of bishophood."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "epitrachelion"
	item_state = "epitrachelion"
	neck_use = TRUE
	item_worth = 70

/obj/item/clothing/head/amulet/ticket
	name = "Ticket to the Vinfort"
	desc = "I'm lucky."
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "documents"
	item_worth = 20
	w_class = 1.0
	neck_use = TRUE
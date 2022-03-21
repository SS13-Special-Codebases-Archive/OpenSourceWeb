/obj/item/weapon/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 7
	w_class = 3
	origin_tech = "combat=4"
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	weapon_speed_delay = 20
	can_be_smelted_to = /obj/item/weapon/ore/refined/lw/ironlw

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (OXYLOSS)

/obj/item/weapon/gavelhammer
	name = "gavel"
	icon_state = "gavel"
	icon = 'icons/obj/items.dmi'
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	force = 1
	w_class = 3

/obj/item/weapon/gavelplatform
	name = "platform"
	icon = 'icons/obj/items.dmi'
	icon_state = "platform"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 1
	w_class = 3
	var/cooldown


/obj/item/weapon/gavelplatform/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/gavelhammer))
		if(cooldown)
			to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)] I can't yet!</span>")
			return
		cooldown = TRUE
		spawn(50)
			cooldown = FALSE
		playsound(src.loc, 'sound/weapons/gavel.ogg', 110, 1, -5)
		visible_message("<p style='font-size:20px'><span class='passivebold'>[user] hits the gavel!</span></p>")
	else
		..()

/obj/item/weapon/key
	name = "key"
	icon_state = "key1"
	icon = 'icons/obj/items.dmi'
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 0
	w_class = 2
	drop_sound = 'keydrop.ogg'
	drawsound = 'keyring_up.ogg'
	var/key_lock = ""

/obj/item/weapon/key/New()
	..()
	icon_state = pick("key1", "key2")

/obj/item/weapon/key/residencesONE
	key_lock = "residencesONE"

/obj/item/weapon/key/residencesTWO
	key_lock = "residencesTWO"

/obj/item/weapon/key/residencesHUMP
	key_lock = "residencesHUMP"

/obj/item/weapon/key/residencesHUMP/New()
	..()
	icon_state = "key3"
/obj/item/combatsheath
	name = "knife sheath"
	desc = "a sheath used to store knifes."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "combat_sh0"
	item_state = "dagger"
	wrist_use = TRUE

/obj/item/combatsheath/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.sheathiconknife && src.contents.len == 0)
		user.drop_item(sound = 0)
		src.contents += W
		src.icon_state = W.sheathiconknife
		playsound(src, W.equip_sound, 50, 1)


/obj/item/combatsheath/MouseDrop(var/obj/over_object)
	var/mob/user = usr
	switch(over_object.name)
		if("r_hand")
			user.drop_from_inventory(src)
			user.put_in_r_hand(src)
		if("l_hand")
			user.drop_from_inventory(src)
			user.put_in_l_hand(src)

/obj/item/combatsheath/attack_hand(mob/user as mob)
	if(src.contents && src.loc == user)
		var/obj/item/weapon/W = safepick(src.contents)
		src.icon_state = "combat_sh0"
		if(W)
			playsound(src, W.drawsound, 50, 1)
			user.visible_message("<span class='combatbold'>[user]</span> <span class='combat'>grabs a weapon.</span>")
			user.put_in_hands(W)
			return
	..()

/obj/item/combatsheath/Censor/New()
	src.contents += new/obj/item/weapon/kitchen/utensil/knife/combatrue
	src.icon_state = "combat_sh1"


/obj/item/daggerssheath
	name = "dagger sheath"
	desc = "a sheath used to store knifes."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dagger_sheath0"
	item_state = "dagger"
	wrist_use = TRUE

/obj/item/daggerssheath/iron/New()
	src.contents += new/obj/item/weapon/kitchen/utensil/knife/dagger
	src.icon_state = "dagger_sheath1"

/obj/item/daggerssheath/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.sheathicondagger && src.contents.len == 0)
		user.drop_item(sound = 0)
		src.contents += W
		src.icon_state = W.sheathicondagger
		playsound(src, W.equip_sound, 50, 1)


/obj/item/daggerssheath/MouseDrop(var/obj/over_object)
	var/mob/user = usr
	switch(over_object.name)
		if("r_hand")
			user.drop_from_inventory(src)
			user.put_in_r_hand(src)
		if("l_hand")
			user.drop_from_inventory(src)
			user.put_in_l_hand(src)

/obj/item/daggerssheath/attack_hand(mob/user as mob)
	if(src.contents && src.loc == user)
		var/obj/item/weapon/W = safepick(src.contents)
		src.icon_state = "dagger_sheath0"
		if(W)
			playsound(src, W.drawsound, 50, 1)
			user.visible_message("<span class='combatbold'>[user]</span> <span class='combat'>grabs a weapon.</span>")
			user.put_in_hands(W)
			return
	..()


/obj/item/sheath
	name = "sword sheath"
	desc = "a sheath used to store swords"
	icon = 'icons/obj/weapons.dmi'
	item_state = "sheath0"
	icon_state = "sword_sh0"
	slot_flags = SLOT_BACK | SLOT_BELT

/obj/item/sheath/sabre/New()
	src.contents += new/obj/item/weapon/claymore/sabre
	src.icon_state = "sword_sh3"
	src.item_state = "sheath1"

/obj/item/sheath/claymore/New()
	src.contents += new/obj/item/weapon/claymore
	src.icon_state = "sword_sh1"
	src.item_state = "sheath1"

/obj/item/sheath/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.sheathicon && src.contents.len == 0)
		user.drop_item(sound = 0)
		src.contents += W
		src.icon_state = W.sheathicon
		item_state = "sheath1"
		playsound(src, W.equip_sound, 50, 1)

/obj/item/sheath/MouseDrop(var/obj/over_object)
	var/mob/user = usr
	switch(over_object.name)
		if("r_hand")
			user.drop_from_inventory(src)
			user.put_in_r_hand(src)
		if("l_hand")
			user.drop_from_inventory(src)
			user.put_in_l_hand(src)

/obj/item/sheath/attack_hand(mob/user as mob)
	if(src.contents && src.loc == user)
		var/obj/item/weapon/W = safepick(src.contents)
		src.icon_state = "sword_sh0"
		src.item_state = "sheath0"
		if(W)
			playsound(src, W.drawsound, 50, 1)
			user.visible_message("<span class='combatbold'>[user]</span> <span class='combat'>grabs a weapon.</span>")
			user.put_in_hands(W)
			return
	..()
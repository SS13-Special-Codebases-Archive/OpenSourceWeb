/obj/item/stack/bullets
	name = "bullets"
	desc = "It's a stack of bullets"
	singular_name = "bullet"
	icon = 'icons/obj/ammo.dmi'
	icon_state = null
	var/bullet_state = null
	max_amount = 5
	var/stacktype
	flags = FPRINT | TABLEPASS
	w_class = 1.0

/obj/item/stack/bullets/New()
	//if(isnum(amount))
	//	amount = amount
	amount = amount
	update_icon()

/obj/item/stack/bullets/afterattack(var/obj/item/I as obj, mob/user as mob, proximity)
	update_icon()
	if(amount <= 0)
		Destroy()


/obj/item/stack/bullets/attack_self(var/mob/user)
	var/take_amount = input(user, "How many?:", "Character Name")  as num|null
	if(take_amount && take_amount < amount)
		amount -= take_amount
		var/obj/item/stack/bullets/new_stack = new src.type
		new_stack.amount = take_amount
		new_stack.update_icon()
		src.update_icon()
		if(user.put_in_inactive_hand(new_stack))
			to_chat(user, "<span class='notice'>You remove [take_amount] from the [new_stack.name]</span>")
			new_stack.update_icon()
			src.update_icon()
			user.put_in_inactive_hand(new_stack)
		else
			new_stack.dropInto(user.loc)
			new_stack.update_icon()
			src.update_icon()
			user.put_in_active_hand(new_stack)

		update_icon()

/obj/item/stack/bullets/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/take_amount = input(user, "How many?:", "Character Name")  as num|null
		if(take_amount && take_amount < amount)
			amount -= take_amount
			var/obj/item/stack/bullets/new_stack = new src.type
			new_stack.amount = take_amount
			new_stack.update_icon()
			src.update_icon()
			if(user.put_in_inactive_hand(new_stack))
				to_chat(user, "<span class='notice'>You remove [take_amount] from the [new_stack.name]</span>")
				new_stack.update_icon()
				src.update_icon()
				user.put_in_inactive_hand(new_stack)
			else
				new_stack.dropInto(user.loc)
				new_stack.update_icon()
				src.update_icon()
				user.put_in_active_hand(new_stack)

			update_icon()

	else
		..()
	return

/obj/item/stack/bullets/update_icon()
	icon_state = "[initial(bullet_state)][amount]"

/obj/item/stack/bullets/buckshot
	name = "buckshot shells"
	desc = "It's a stack of buckshot"
	singular_name = "buckshot"
	icon_state = "g1"
	bullet_state = "g"
	max_amount = 8
	amount = 1
	stacktype = /obj/item/ammo_casing/shotgun

/obj/item/stack/bullets/buckshot/three/New()
	amount = 3
	update_icon()

/obj/item/stack/bullets/buckshot/eight/New()
	amount = 8
	update_icon()

/obj/item/stack/bullets/Newduelista
	name = ".357 rounds"
	desc = "It's a stack of .357 rounds"
	singular_name = "round"
	icon_state = "s1"
	bullet_state = "s"
	max_amount = 15
	amount = 1
	stacktype = /obj/item/ammo_casing/a357/Newduelista

/obj/item/stack/bullets/Newduelista/three/New()
	amount = 3
	update_icon()

/obj/item/stack/bullets/Newduelista/five/New()
	amount = 5
	update_icon()

/obj/item/stack/bullets/rifle
	name = "7.62 rounds"
	desc = "It's a stack of 7.62 rounds"
	singular_name = "round"
	icon_state = "r1"
	bullet_state = "r"
	max_amount = 9
	amount = 1
	stacktype = /obj/item/ammo_casing/a762

/obj/item/stack/bullets/rifle/nine/New()
	amount = 9
	update_icon()
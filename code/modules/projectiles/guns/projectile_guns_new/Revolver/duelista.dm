/obj/item/weapon/gun/projectile/newRevolver/duelista
	name = "Neoclassic Duelista"
	desc = "A single shot revolver."
	icon = 'icons/obj/gunnew.dmi'
	icon_state = "duelista"
	item_state = "smallgun"
	caliber = ".357"
	w_class = 3.0
	fire_sound = "oldpistol"
	load_shell_sound = "revolver_load"
	mag_type = /obj/item/ammo_magazine/internal/cylinder/Newduelista
	maxAmmoSprite = 1

/obj/item/weapon/gun/projectile/newRevolver/update_icon()
	if(open)
		if(magazine && magazine.contents.len)
			var/numero = magazine.contents.len
			if(magazine.contents.len == 0)
				numero = 0
			if(magazine.contents.len >= maxAmmoSprite)
				numero = maxAmmoSprite

			icon_state = "[initial(icon_state)]_open[numero]"
		else
			icon_state = "[initial(icon_state)]_open0"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/gun/projectile/newRevolver/duelista/proc/toggle(mob/user)
	if(!open)
		open = 1
		update_icon()
		playsound(src.loc, opensound, 75, 1)
		user.sound2()
		user.next_move = world.time + 6

	else
		open = 0
		update_icon()
		playsound(src.loc, closesound, 75, 1)
		user.sound2()
		user.next_move = world.time + 6

/obj/item/weapon/gun/projectile/newRevolver/duelista/attack_self(mob/user)
	if(is_jammed)
		unjam(user)
		return

	toggle(user)

/obj/item/weapon/gun/projectile/newRevolver/duelista/unjam(mob/M)
	if(is_jammed)
		M.visible_message("<span class='combatbold'>[M]</span> <span class='combat'>is trying to unjam</span> <span class='combatbold'>[src]!</span>")
		if(do_after(M, 15))
			is_jammed = 0
			playsound(src.loc, unjam_sound, 50, 1)
			playsound(src.loc, unload_sound, 50, 0)
			while(get_ammo() > 0)
				var/obj/item/ammo_casing/CB
				CB = magazine.get_round()
				chambered = null
				if(CB && !istype(CB, /obj/item/ammo_casing/none))
					CB.loc = get_turf(src.loc)
					CB.update_icon()
			magazine.on_empty()
			update_icon()
			M.next_move = world.time + 6
			toggle(M)
			return
		else
			return

/obj/item/weapon/gun/projectile/newRevolver/duelista/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, pointblank=0, reflex = 0)//TODO: go over this
	if(open)	return
	..()

/obj/item/weapon/gun/projectile/newRevolver/MouseDrop(var/obj/over_object)
	var/mob/user = usr

	if (!over_object || !(ishuman(usr)))
		return

	if (!(src.loc == usr))
		return

	if(!open)
		return

	switch(over_object.name)
		if("r_hand")
			if(get_ammo() > 0)
				user.visible_message("<span class='combatbold'>[user.name]</span><span class='combat'> unloads [src]!</span>")
				playsound(src.loc, unload_sound, 50, 0)
				while(get_ammo() > 0)
					var/obj/item/ammo_casing/CB
					CB = magazine.get_round()
					chambered = null
					if(CB && !istype(CB, /obj/item/ammo_casing/none))
						CB.loc = get_turf(src.loc)
						CB.update_icon()
						user.put_in_hands(CB)

				magazine.on_empty()

		if("l_hand")
			if(get_ammo() > 0)
				user.visible_message("<span class='combatbold'>[user.name]</span><span class='combat'> unloads [src]!</span>")
				playsound(src.loc, unload_sound, 50, 0)
				while(get_ammo() > 0)
					var/obj/item/ammo_casing/CB
					CB = magazine.get_round()
					chambered = null
					if(CB && !istype(CB, /obj/item/ammo_casing/none))
						CB.loc = get_turf(src.loc)
						CB.update_icon()
						user.put_in_hands(CB)

				magazine.on_empty()

	update_icon()
	return
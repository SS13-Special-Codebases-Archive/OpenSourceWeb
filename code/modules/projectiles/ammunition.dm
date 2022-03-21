/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "s-casing"
	flags = FPRINT | CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 1
	w_class = 1.0
	var/caliber = ""					//Which kind of guns it can be loaded into
	var/projectile_type					//The bullet type to create when New() is called
	var/obj/item/projectile/BB = null 	//The loaded bullet

	New()
		..()
		if(projectile_type)
			BB = new projectile_type(src)
		update_icon()

	update_icon()
		pixel_x = rand(-10, 10)
		pixel_y = rand(-10, 10)
		dir = pick(alldirs)
		icon_state = "[initial(icon_state)][BB ? "-live" : ""]"
		desc = "[initial(desc)][BB ? "" : " This one is spent"]"

	proc/on_fired()
		return

//Boxes of ammo
/obj/item/ammo_magazine
	name = "ammo magazine"
	icon_state = "357"
	origin_tech = "combat=2"
	icon = 'icons/obj/ammo.dmi'
	flags = FPRINT | CONDUCT
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	m_amt = 50000
	throwforce = 2
	w_class = 1.0
	throw_speed = 4
	throw_range = 10
	var/caliber
	var/list/stored_ammo = list()
	var/ammo_type = /obj/item/ammo_casing
	var/max_ammo = 7
	var/multiple_sprites = 0

	New()
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new ammo_type(src)

	examine()
		..()
		to_chat(usr, "There are [ammo_count()] shell\s left!")

	update_icon()
		switch(multiple_sprites)
			if(1) // Ammo len
				icon_state = "[initial(icon_state)]-[ammo_count()]"
			if(2) // Binary
				icon_state = "[initial(icon_state)][ammo_count() ? "" : "-0"]"
			if(3) // Round by 2
				icon_state = "[initial(icon_state)]-[round(ammo_count(), 2)]"
			if(4) // Round by 3
				icon_state = "[initial(icon_state)]-[round(ammo_count(), 3)]"
			if(5) // Round by 10, for REALLY BIG mags
				icon_state = "[initial(icon_state)]-[round(ammo_count(), 10)]"
	attackby(var/obj/item/A as obj, mob/user as mob)
		var/num_loaded = 0

		if(istype(A, /obj/item/ammo_magazine))
			var/obj/item/ammo_magazine/AM = A
			for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
				if(give_round(AC))
					AM.stored_ammo -= AC
					num_loaded++
				else break
			AM.update_icon()

		if(istype(A, /obj/item/ammo_casing))
			var/obj/item/ammo_casing/AC = A
			if(give_round(AC))
				user.drop_item()
				AC.loc = src
				num_loaded++

		if(num_loaded)
			if(num_loaded > 1)
				to_chat(user, "<span class='notice'>You load [num_loaded] shell\s into \the [src]!</span>")
			else
				to_chat(user, "<span class='notice'>You load a shell into \the [src]!</span>")
			update_icon()

	attack_self(mob/user as mob)
		var/obj/item/ammo_casing/A = get_round()
		if(A)
			A.loc = user.loc
			to_chat(user, "<span class='notice'>You remove a shell from \the [src]!</span>")
			update_icon()


	proc/give_round(var/obj/item/ammo_casing/A)
		if(istype(A))
			if(stored_ammo.len < max_ammo && A.caliber == caliber)
				stored_ammo += A
				A.loc = src
				return 1
		return 0

	proc/on_empty()
		return

//Behavior for magazines
	proc/ammo_count()
		return stored_ammo.len

	proc/get_round(var/keep = 0)
		if(!stored_ammo.len)
			return null
		else
			var/b = stored_ammo[stored_ammo.len]
			stored_ammo -= b
			if(keep)
				stored_ammo.Insert(1,b)
			else
				update_icon()
			return b
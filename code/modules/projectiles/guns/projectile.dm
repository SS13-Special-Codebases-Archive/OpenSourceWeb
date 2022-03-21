/obj/item/weapon/gun/projectile
	desc = "A gun."
	name = "gun"
	icon_state = "revolver"
	caliber = ".357"
	origin_tech = "combat=2;materials=2"
	w_class = 3.0
	m_amt = 1000
	var/load_shell_sound = null
	var/obj/item/ammo_magazine/magazine
	var/stacktype
	var/spenttype
	var/obj/item/ammo_casing/chambered
	var/mag_type = /obj/item/ammo_magazine/internal/cylinder


/obj/item/weapon/gun/projectile/New()
	..()
	magazine = new mag_type(src)
	update_icon()
	return

/obj/item/weapon/gun/projectile/proc/chamber_round()
	if(chambered || !magazine)
		return 0
	else
		var/obj/item/ammo_casing/round = magazine.get_round()
		update_icon()
		if(istype(round))
			chambered = round
			chambered.loc = src
			return 1
	return 0


/obj/item/weapon/gun/projectile/process_chambered()
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(isnull(AC) || !istype(AC))
		return 0
	AC.loc = get_turf(src) //Eject casing onto ground.
	playsound(get_turf(src), pick('casingfall1.ogg','casingfall2.ogg','casingfall3.ogg'), 50, 1)
	chambered = null
	chamber_round()

	AC.on_fired()

	if(AC.BB)
		in_chamber = AC.BB //Load projectile into chamber.
		AC.BB.loc = src //Set projectile loc to gun.
		AC.BB = null
		AC.update_icon()
		return 1
	AC.update_icon()
	return 0


/obj/item/weapon/gun/projectile/attackby(var/obj/item/A as obj, mob/user as mob, var/show_msg = 1)
	if(istype(A, mag_type) && !magazine)
		user.drop_item(sound = 0)
		magazine = A
		magazine.loc = src
		user.visible_message("<span class='combatbold'>[user.name]</span><span class='combat'> reloads [src]!</span>")
		playsound(src.loc, reload_sound, 120, 0)
		chamber_round()
		A.update_icon()
		update_icon()
		return 1

	else if(istype(magazine, /obj/item/ammo_magazine/internal))
		var/num_loaded = 0
		if(istype(src, /obj/item/weapon/gun/projectile/newRevolver))
			var/obj/item/weapon/gun/projectile/newRevolver/N = src
			if(!N.open)
				return
		if(istype(A, /obj/item/ammo_magazine))
			var/obj/item/ammo_magazine/AM = A
			for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
				if(magazine.give_round(AC))
					AM.stored_ammo -= AC
					num_loaded++
				else break
			AM.update_icon()
			user.visible_message("<span class='combatbold'>[user.name]</span><span class='combat'> reloads [src]!</span>")
			playsound(src.loc, reload_sound, 120, 0)


		if(istype(A, /obj/item/ammo_casing))
			var/obj/item/ammo_casing/AC = A
			if(magazine.give_round(AC))
				user.drop_item(sound = 0)
				AC.loc = magazine
				num_loaded++
				AC.update_icon()
				playsound(src.loc, load_shell_sound, 70, 0)

		if(istype(A,/obj/item/stack/bullets))
			var/obj/item/stack/bullets/bullet_stack = A
			A = new bullet_stack.stacktype()
			var/obj/item/AC = null
			AC = new bullet_stack.stacktype()
			bullet_stack.update_icon()
			A.update_icon()
			AC.update_icon()
			if(magazine.give_round(AC))
				bullet_stack.use(1)
				playsound(src.loc, load_shell_sound, 70, 0)
				bullet_stack?.update_icon()
				//A.update_icon()
				AC.loc = magazine
				num_loaded++

		if(num_loaded)
			if(show_msg)
				if(num_loaded > 1)
					to_chat(user, "<span class='notice'>You load [num_loaded] shell\s into \the [src]!</span>")
				else
					to_chat(user, "<span class='notice'>You load a shell into \the [src]!</span>")
			update_icon()
			chamber_round()
		return num_loaded


	return 0

/obj/item/weapon/gun/projectile/attack_self(mob/user)
	if(is_jammed)
		unjam(user)
	if(!istype(src, /obj/item/weapon/gun/projectile/revolver) || !istype(src, /obj/item/weapon/gun/projectile/newRevolver))
		if(chamber_round())
			user.visible_message("<span class='combatbold'>[user.name]</span><span class='combat'> cocks [src]!</span>")
			playsound(src, cocksound, 80, 0)

/obj/item/weapon/gun/projectile/MouseDrop(var/obj/over_object)
	var/mob/user = usr

	if (!over_object || !(ishuman(usr)))
		return

	if (!(src.loc == usr))
		return

	switch(over_object.name)
		if("r_hand")
			if(istype(magazine, /obj/item/ammo_magazine/external))
				magazine.loc = get_turf(src.loc)
				user.put_in_hands(magazine)
				magazine.update_icon()
				magazine = null
				user.visible_message("<span class='combatbold'>[user.name]</span><span class='combat'> unloads [src]!</span>")
				playsound(src.loc, unload_sound, 50, 0)
			else if(istype(magazine, /obj/item/ammo_magazine/internal))
				var/num_unloaded = 0
				user.visible_message("<span class='combatbold'>[user.name]</span><span class='combat'> unloads [src]!</span>")
				playsound(src.loc, unload_sound, 50, 0)
				while(get_ammo() > 0)
					var/obj/item/ammo_casing/CB
					CB = magazine.get_round()
					chambered = null
					if(CB && !istype(CB, /obj/item/ammo_casing/none))
						CB.loc = get_turf(src.loc)
						CB.update_icon()
						num_unloaded++

				magazine.on_empty()

				if (num_unloaded > 1)
					user << "<span class = 'notice'>You unload [num_unloaded] shell\s from [src]!</span>"
				else if(num_unloaded == 1)
					user << "<span class = 'notice'>You unload a shell from [src]!</span>"
		if("l_hand")
			if(istype(magazine, /obj/item/ammo_magazine/external))
				magazine.loc = get_turf(src.loc)
				user.put_in_hands(magazine)
				magazine.update_icon()
				magazine = null
				user.visible_message("<span class='combatbold'>[user.name]</span><span class='combat'> unloads [src]!</span>")
				playsound(src.loc, unload_sound, 50, 0)
			else if(istype(magazine, /obj/item/ammo_magazine/internal))
				var/num_unloaded = 0
				user.visible_message("<span class='combatbold'>[user.name]</span><span class='combat'> unloads [src]!</span>")
				playsound(src.loc, unload_sound, 50, 0)
				while(get_ammo() > 0)
					var/obj/item/ammo_casing/CB
					CB = magazine.get_round()
					chambered = null
					if(CB && !istype(CB, /obj/item/ammo_casing/none))
						CB.loc = get_turf(src.loc)
						CB.update_icon()
						num_unloaded++

				magazine.on_empty()

				if (num_unloaded > 1)
					user << "<span class = 'notice'>You unload [num_unloaded] shell\s from [src]!</span>"
				else if(num_unloaded == 1)
					user << "<span class = 'notice'>You unload a shell from [src]!</span>"
	update_icon()
	return

/obj/item/weapon/gun/projectile/examine()
	..()
	usr << "Has [get_ammo()] round\s remaining."
	return

/obj/item/weapon/gun/projectile/proc/get_ammo(var/countchambered = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count()
	return boolets
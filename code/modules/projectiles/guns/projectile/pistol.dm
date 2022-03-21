/obj/item/weapon/gun/projectile/automatic/pistol/toggle_fire()
	set hidden = 1
	return

/*obj/item/weapon/gun/projectile/automatic/pistol/glock
	name = "glock"
	desc = "A old Glock 17 pistol. Uses 9mm rounds"
	icon_state = "glock"
	force = 14.0
	mag_type = /obj/item/ammo_magazine/external/mc9mm

/obj/item/weapon/gun/projectile/automatic/pistol/glock/New()
	..()
	qdel(magazine)
	magazine = new /obj/item/ammo_magazine/external/mc9mm/extended(src)*/



/obj/item/weapon/gun/projectile/automatic/pistol
	name = "\improper TSP-12 pistol"
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol"
	w_class = 2
	silenced = 0
	origin_tech = "combat=3;materials=2"
	mag_type = /obj/item/ammo_magazine/external/mc9mm

/obj/item/weapon/gun/projectile/automatic/pistol/ml23
	name = "\improper ML-23"
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol1"
	w_class = 2
	silenced = 0
	origin_tech = "combat=2;materials=2;syndicate=2"
	mag_type = /obj/item/ammo_magazine/external/mc9mm
	fire_sound = 'sound/weapons/Gunshot2.ogg'
	item_worth = 80
	jam_chance = 5


/obj/item/weapon/gun/projectile/automatic/pistol/jester
	name = "BB Pistol"
	desc = ""
	icon = 'icons/obj/gun.dmi'
	icon_state = "jester"
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/sm45/rubber
	fire_sound = 'sound/lfwbsounds/Gunshot2.ogg'
	reload_sound = 'sound/lfwbsounds/bigpistol_reload.ogg'
	unload_sound = 'sound/lfwbsounds/bigpistol_unload.ogg'
	safetysound = 'sound/lfwbsounds/safety2.ogg'
	jam_chance = 8
	force = 20

/obj/item/weapon/gun/projectile/automatic/pistol/magnum66/old
	jam_chance = 15

/obj/item/weapon/gun/projectile/automatic/pistol/magnum66
	name = "Magnum 66"
	desc = ""
	icon = 'icons/obj/gun.dmi'
	icon_state = "magnum"
	item_state = "bigpistol"
	w_class = 2.0
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/sm45
	fire_sound = 'sound/lfwbsounds/Gunshot2.ogg'
	reload_sound = 'sound/lfwbsounds/bigpistol_reload.ogg'
	unload_sound = 'sound/lfwbsounds/bigpistol_unload.ogg'
	safetysound = 'sound/lfwbsounds/safety2.ogg'
	jam_chance = 8
	force = 20


/obj/item/weapon/gun/projectile/automatic/pistol/magnum66/screamer23
	name = "Screamer 23"
	desc = ""
	icon = 'icons/obj/gun.dmi'
	icon_state = "screamer23"
	item_state = "bigpistol"
	w_class = 2.0
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/sm45/pusher/full
	fire_sound = 'sound/weapons/Gunshot_m9.ogg'
	jam_chance = 13

/obj/item/weapon/gun/projectile/automatic/pistol/magnum66/screamer23/pusher
	jam_chance = 15
	durability = 70
	mag_type = /obj/item/ammo_magazine/external/sm45/pusher

/obj/item/weapon/gun/projectile/automatic/pistol/magnum66/mother
	name = "W93 Mother"
	desc = ""
	icon = 'icons/obj/gun.dmi'
	icon_state = "mother"
	item_state = "bigpistol"
	w_class = 2.0
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/m357
	fire_sound = 'sound/weapons/motherfire.ogg'
	jam_chance = 5


/obj/item/weapon/gun/projectile/automatic/pistol/ml23/gold
	name = "\improper Gold ML-23"
	icon_state = "gpistol"
	item_worth = 150

/obj/item/weapon/gun/projectile/automatic/pistol/attack_hand(mob/user as mob)
	if(loc == user)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			user << "<span class='notice'>You unscrew [silenced] from [src].</span>"
			user.put_in_hands(silenced)
			var/obj/item/weapon/silencer/S = silenced
			fire_sound = S.oldsound
			silenced = 0
			w_class = 2
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/automatic/pistol/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			user << "<span class='notice'>You'll need [src] in your hands to do that.</span>"
			return
		user.drop_item()
		user << "<span class='notice'>You screw [I] onto [src].</span>"
		silenced = I	//dodgy?
		var/obj/item/weapon/silencer/S = I
		S.oldsound = fire_sound
		fire_sound = 'sound/weapons/Gunshot_silenced.ogg'
		w_class = 3
		I.loc = src		//put the silencer into the gun
		update_icon()
		return
	..()

/obj/item/weapon/gun/projectile/automatic/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][silenced ? "-silencer" : ""][chambered ? "" : "-e"][chambered && !safety ? "0" : "1"]"
	if(silenced)
		icon_state = "[initial(icon_state)]-silencer"
		return
	else if(magazine)
		icon_state = "[initial(icon_state)]"
		if(!safety)
			icon_state = "[initial(icon_state)]0"
		else
			icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]-e"
	return


/obj/item/weapon/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/gun.dmi'
	icon_state = "silencer"
	w_class = 2
	var/oldsound = 0 //Stores the true sound the gun made before it was silenced

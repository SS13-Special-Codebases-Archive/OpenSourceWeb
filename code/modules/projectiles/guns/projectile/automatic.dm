/obj/item/weapon/gun/projectile/automatic //Hopefully someone will find a way to make these fire in bursts or something. --Superxpdude
	name = "submachine gun"
	desc = "A lightweight, fast firing gun. Uses 9mm rounds."
	icon_state = "saber"	//ugly
	w_class = 3.0
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_magazine/external/msmg9mm
	var/alarmed = 0
	var/mode = 0
	jam_chance = 5
	cocksound = 'sound/lfwbsounds/rifle_cock.ogg'
	recoil_type = 2

/obj/item/weapon/gun/projectile/automatic/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "-[magazine.max_ammo]" : ""][chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)
	if(mode)
		..()
		should_sound = 0
		sleep(1)
		..()
		sleep(1)
		..()
		should_sound = 1
	else
		..()

/obj/item/weapon/gun/projectile/automatic/verb/toggle_fire()
	set name = "Toggle Firing Mode"
	set category = "Object"
	if(mode)
		mode = 0
		usr << "<span class='notice'>The [src] will now fire single shots.</span>"
	else
		mode = 1
		usr << "<span class='notice'>The [src] will now fire bursts.</span>"
	playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)

/obj/item/weapon/gun/projectile/automatic/attackby(var/obj/item/A as obj, mob/user as mob)
	if(..() && chambered)
		alarmed = 0

/obj/item/weapon/gun/projectile/automatic/grinder
	name = "Grinder"
	desc = " Fully automatic carbine. Uses 7.62 caliber rounds."
	icon_state = "grinder"
	item_state = "biggun"
	wielded_icon = "biggun-wielded"
	w_class = 3.0
	recoil = 1.25
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_magazine/external/grinder
	fire_sound = "grinder"
	item_worth = 320
	jam_chance = 3
	weight = 8

/obj/item/weapon/gun/projectile/automatic/grinder/old
	name = "Old Grinder"
	icon_state = "oldgrinder"
	item_state = "oldgrinder"
	wielded_icon = "oldgrinder-wielded"
	item_worth = 100
	jam_chance = 50

/obj/item/weapon/gun/projectile/automatic/new_rifle
	name = "WRONG"

/obj/item/weapon/gun/projectile/automatic/new_rifle/update_icon()
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

/obj/item/weapon/gun/projectile/automatic/new_rifle/pulse_rifle
	name = "Kpfw-6 Ausf"
	desc = "An experimental automatic rifle that belongs to the past."
	icon_state = "kpfw"
	item_state = "kpfw"
	wielded_icon = "kpfw-wielded"
	w_class = 3.0
	recoil = 1.25
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_magazine/external/kpfw
	fire_sound = "kpfw"
	item_worth = 642
	jam_chance = 3
	weight = 3
	mode = 1

/obj/item/weapon/gun/projectile/automatic/new_rifle/lakko
	name = "CTT4&3 Autorifle"
	desc = "Experimental rifle designed by old corporations with all purposes."
	icon_state = "lakko"
	item_state = "biggun"
	wielded_icon = "biggun-wielded"
	w_class = 3.0
	recoil = 1.25
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_magazine/external/ctt
	fire_sound = "coolgunsound"
	item_worth = 642
	jam_chance = 3
	weight = 3
	mode = 0

/obj/item/weapon/gun/projectile/automatic/new_rifle/kabal
	name = "Kabal 45"
	desc = "Good old .45 submachine gun."
	icon_state = "kabal45"
	item_state = "kabal45"
	wielded_icon = "kabal-wielded"
	w_class = 3.0
	recoil = 1.25
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_magazine/external/drum_kabal
	fire_sound = "kabal"
	safetysound = 'sound/weapons/guns/kabal_safety.ogg'
	reload_sound = 'sound/weapons/guns/kabal_insert.ogg'
	unload_sound = 'sound/weapons/guns/kabal_remove.ogg'
	item_worth = 250
	jam_chance = 3
	weight = 3
	mode = 1

/obj/item/weapon/gun/projectile/automatic/new_rifle/thanatikabal
	name = "Kabal 45"
	desc = "Maranax pallex!"
	icon_state = "kabal45"
	item_state = "kabal45"
	wielded_icon = "kabal-wielded"
	w_class = 3.0
	recoil = 1.5
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_magazine/external/drum_thanatikabal
	fire_sound = "thanatikabal"
	safetysound = 'sound/weapons/guns/kabal_safety.ogg'
	reload_sound = 'sound/weapons/guns/kabal_insert.ogg'
	unload_sound = 'sound/weapons/guns/kabal_remove.ogg'
	item_worth = 250
	jam_chance = 3
	weight = 3
	mode = 1

/obj/item/weapon/gun/projectile/automatic/mini_uzi
	name = "Karek R90"
	desc = "A personal favourite of gangbangers and terrorists alike."
	icon_state = "mini-uzi"
	item_state = "smg"
	w_class = 3.0
	origin_tech = "combat=5;materials=2;syndicate=8"
	mag_type = /obj/item/ammo_magazine/external/uzi380
	fire_sound = 'smg_fire.ogg'
	item_worth = 300
	jam_chance = 15
	recoil = 1.25
	weight = 4

/obj/item/weapon/gun/projectile/automatic/carbine
	name = "\improper Talon M12A4"
	desc = "A Talon, lightweight, fully-automatical carbine."
	icon_state = "carbine"
	item_state = "biggun"
	wielded_icon = "biggun-wielded"
	w_class = 3.0
	slot_flags = SLOT_BACK
	origin_tech = "combat=5;materials=2"
	fire_sound = 'Gunshot3.ogg'
	mag_type = /obj/item/ammo_magazine/external/mag556
	item_worth = 350
	recoil = 1.35
	weight = 8
	mode = 1
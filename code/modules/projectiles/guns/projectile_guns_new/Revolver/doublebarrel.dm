/obj/item/weapon/gun/projectile/newRevolver/duelista/doublebarrel
	name = "Double Barrel"
	desc = "A double shot shotgun."
	icon_state = "double"
	item_state = "bbgun"
	wielded_icon = "bbgun-wielded"
	caliber = ".12"
	w_class = 4.0
	slot_flags = SLOT_BACK
	force = 10
	fire_sound = 'Shotgun2.ogg'
	load_shell_sound = 'shotgun_reload.ogg'
	opensound = 'shotgun_break.ogg'
	mag_type = /obj/item/ammo_magazine/internal/cylinder/doublebarrel
	maxAmmoSprite = 2

/obj/item/weapon/gun/projectile/newRevolver/duelista/doublebarrel/sawnOff
	name = "Sawn-Off Double Barrel Shotgun"
	desc = "A double shot shotgun. But sawn off."
	icon_state = "sawed"
	item_state = "sawed"
	wielded_icon = "sawed"
	slot_flags = SLOT_BELT
	w_class = 3.0
	jam_chance = 5
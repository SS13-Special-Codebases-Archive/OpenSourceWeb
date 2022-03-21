/obj/item/ammo_magazine/box/a357
	name = "ammo box (.357)"
	desc = "A box of .357 ammo."
	icon_state = "357"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357
	max_ammo = 7
	multiple_sprites = 1


/obj/item/ammo_magazine/box/c38
	name = "speed loader (.38)"
	icon_state = "38"
	caliber = ".38"
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/box/c38/e
	ammo_type = /obj/item/ammo_casing/c38/e


/obj/item/ammo_magazine/box/a418
	name = "ammo box (.418)"
	desc = "A box of .418 ammo."
	icon_state = "418"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a418
	max_ammo = 7
	multiple_sprites = 1


/obj/item/ammo_magazine/box/a666
	name = "ammo box (.666)"
	desc = "A box of .666 ammo."
	icon_state = "666"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a666
	max_ammo = 7
	multiple_sprites = 1


/obj/item/ammo_magazine/box/c9mm
	name = "ammo box (9mm)"
	desc = "A box of 9mm ammo."
	icon_state = "9mm"
	caliber = "9mm"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_magazine/box/mag545
	name = "bullet clip (5.45)"
	desc = "A clip of 5.45 ammo for russian rifles."
	icon_state = "5.45mag"
	caliber = "5.45"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/mag545
	max_ammo = 30


/obj/item/ammo_magazine/box/c45
	name = "ammo box (.45)"
	desc = "A box of .45 ammo."
	icon_state = "9mm"
	caliber = ".45"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 30


/*
 * SHOTGUN AMMO BOXES
 */

/obj/item/ammo_magazine/box/shotgun
	name = "slug box"
	icon_state = "gbox"
	caliber = ".12"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 8
	multiple_sprites = 1

	update_icon()
		icon_state = "[initial(icon_state)]-0"
		overlays.Cut()
		var/i = 0
		for(var/obj/item/ammo_casing/shotgun/AC in stored_ammo)
			i++
			overlays += icon('icons/obj/ammo.dmi', "[AC.icon_state]-[i]")


/obj/item/ammo_magazine/box/shotgun/dart
	name = "darts box"
	icon_state = "blbox"
	ammo_type = /obj/item/ammo_casing/shotgun/dart

/obj/item/ammo_magazine/box/shotgun/stun
	name = "stunshells box"
	icon_state = "stunbox"
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell

/obj/item/ammo_magazine/box/shotgun/bean
	name = "beanbag box"
	icon_state = "bbox"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
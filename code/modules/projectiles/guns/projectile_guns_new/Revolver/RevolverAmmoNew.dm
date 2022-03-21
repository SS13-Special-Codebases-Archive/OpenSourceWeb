/obj/item/ammo_magazine/internal/cylinder/Newduelista
	name = "duelista ammo"
	max_ammo = 0
	ammo_type = /obj/item/ammo_casing/a357/Newduelista
	cylinders = 1

/obj/item/ammo_casing/a357/Newduelista
	desc = "A .357 bullet casing."
	caliber = ".357"
	projectile_type = /obj/item/projectile/bullet/Newduelista
	icon = 'icons/obj/ammo.dmi'
	icon_state = "dummy"

/obj/item/projectile/bullet/Newduelista
	damage = 65
	weaken = 0
	stutter = 40
	agony = 50

/obj/item/ammo_magazine/internal/cylinder/doublebarrel
	name = "shotgun ammo"
	max_ammo = 0
	ammo_type = /obj/item/ammo_casing/shotgun
	caliber = ".12"
	cylinders = 2

/obj/item/ammo_magazine/internal/cylinder/harat
	name = "harat ammo"
	max_ammo = 0
	caliber = ".380"
	ammo_type = /obj/item/ammo_casing/a380/harat
	cylinders = 7

/obj/item/ammo_casing/a380/harat
	desc = "A .380 round."
	caliber = ".380"
	projectile_type = /obj/item/projectile/bullet/harat
	icon = 'icons/obj/ammo.dmi'
	icon_state = "dummy"

/obj/item/projectile/bullet/harat
	damage = 38
	weaken = 0
	stutter = 40
	agony = 20

/obj/item/stack/bullets/Harat
	name = ".380 rounds"
	desc = "It's a stack of .380 rounds"
	singular_name = "round"
	icon_state = "mh1"
	bullet_state = "mh"
	max_amount = 15
	amount = 1
	stacktype = /obj/item/ammo_casing/a380/harat

/obj/item/stack/bullets/Richter
	name = ".44 rounds"
	desc = "It's a stack of .44 rounds"
	singular_name = "round"
	icon_state = "h1"
	bullet_state = "h"
	max_amount = 15
	amount = 1
	stacktype = /obj/item/ammo_casing/c44

/obj/item/stack/bullets/Richter/six/New()
	amount = 6
	update_icon()

/obj/item/stack/bullets/Harat/seven/New()
	amount = 7
	update_icon()

/obj/item/stack/bullets/Neoclassic
	name = ".38 rounds"
	desc = "It's a stack of .38 rounds"
	singular_name = "round"
	icon_state = "n1"
	bullet_state = "n"
	max_amount = 15
	amount = 1
	stacktype = /obj/item/ammo_casing/c38/e

/obj/item/stack/bullets/Neoclassic/seven/New()
	amount = 7
	update_icon()

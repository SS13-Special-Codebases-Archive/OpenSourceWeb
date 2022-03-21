/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = ".357"
	projectile_type = /obj/item/projectile/bullet

/obj/item/ammo_casing/a357/duelista
	desc = "A .357 bullet casing."
	caliber = ".357"
	projectile_type = /obj/item/projectile/bullet/duelista

/obj/item/ammo_casing/a50
	desc = "A .50AE bullet casing."
	caliber = ".50"
	projectile_type = /obj/item/projectile/bullet

/obj/item/ammo_casing/a418
	desc = "A .418 bullet casing."
	caliber = ".357"
	projectile_type = /obj/item/projectile/bullet/suffocationbullet


/obj/item/ammo_casing/a75
	desc = "A .75 bullet casing."
	caliber = ".75"
	projectile_type = /obj/item/projectile/bullet/gyro


/obj/item/ammo_casing/a666
	desc = "A .666 bullet casing."
	caliber = ".357"
	projectile_type = /obj/item/projectile/bullet/cyanideround


/obj/item/ammo_casing/c38
	desc = "A .38 rubber bullet casing."
	caliber = ".38"
	projectile_type = /obj/item/projectile/bullet/weakbullet

/obj/item/ammo_casing/c38/e
	desc = "A .38 bullet casing."
	projectile_type = /obj/item/projectile/bullet/midbullet

/obj/item/ammo_casing/c44
	desc = "A .44 bullet casing."
	caliber = ".44"
	projectile_type = /obj/item/projectile/bullet/midbullet


/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/weakbullet

/obj/item/ammo_casing/mag545
	desc = "A 5.45 bullet casing."
	caliber = "5.45"
	projectile_type = /obj/item/projectile/bullet/midbullet2

/obj/item/ammo_casing/mag556
	desc = "A 5.56 bullet casing."
	caliber = "5.56"
	projectile_type = /obj/item/projectile/bullet/midbullet2

/obj/item/ammo_casing/mag556rub
	desc = "A 5.56 bullet casing."
	caliber = "5.56"
	projectile_type = /obj/item/projectile/bullet/rubber

/obj/item/ammo_casing/c9mm/extra
	desc = "A 9mm bullet casing."
	projectile_type = /obj/item/projectile/bullet/midbullet

/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/midbullet

/obj/item/ammo_casing/c45rub
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/rubber


/obj/item/ammo_casing/a12mm
	desc = "A 12mm bullet casing."
	caliber = "12mm"
	projectile_type = /obj/item/projectile/bullet/midbullet

/obj/item/ammo_casing/none
	name = "dirty hack casing"
	desc = "A there-is-no-shell, for use in revolvers."

/obj/item/ammo_casing/shotgun
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	caliber = ".12"
	projectile_type = /obj/item/projectile/bullet/shotgun
	m_amt = 12500

	update_icon()
		desc = "[initial(desc)][BB ? "" : " This one is spent"]"
		overlays = list()
		if(!BB)
			icon_state = "gshell-1"

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	projectile_type = ""
	m_amt = 250


/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A weak beanbag shell."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/weakbullet
	m_amt = 500


/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "A stunning shell."
	icon_state = "stunshell"
	projectile_type = /obj/item/projectile/bullet/stunshot
	m_amt = 2500


/obj/item/ammo_casing/shotgun/dart
	name = "shotgun dart"
	desc = "A dart for use in shotguns."
	icon_state = "blshell" //someone, draw the icon, please.
	projectile_type = /obj/item/projectile/bullet/dart
	m_amt = 7500
	New()
		..()
		flags |= NOREACT
		create_reagents(50)

	attackby()
		return

	on_fired()
		if(BB)
			if(reagents && BB.reagents)
				reagents.trans_to(BB, reagents.total_volume)
				reagents.delete()

/obj/item/ammo_casing/shotgun/dartpreloaded
	name = "shotgun dart"
	desc = "A dart for use in shotguns."
	icon_state = "blshell" //someone, draw the icon, please.
	projectile_type = /obj/item/projectile/bullet/dart
	m_amt = 7500

/obj/item/ammo_casing/shotgun/dartpreloaded/metalfoam
	projectile_type = /obj/item/projectile/bullet/dart/metalfoam

/obj/item/ammo_casing/a762
	desc = "A 7.62 bullet casing."
	caliber = ".762"
	projectile_type = /obj/item/projectile/bullet/princess

/obj/item/ammo_casing/a556
	desc = "A 5.56 bullet casing."
	caliber = ".5.56"
	projectile_type = /obj/item/projectile/bullet/a556

/obj/item/ammo_casing/shotgun/improvised
	name = "improvised shell"
	desc = "An extremely weak shotgun shell with multiple small pellets made out of metal shards."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/weakbullet
	m_amt = 250
//	pellets = 5
//	variance = 0.8

/obj/item/ammo_casing/energy/kinetic
	projectile_type = /obj/item/projectile/kinetic
//	select_name = "kinetic"

/obj/item/ammo_casing/a45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/fire

/obj/item/ammo_casing/t45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/a45
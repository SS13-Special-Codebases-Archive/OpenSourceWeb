////////////////INTERNAL MAGAZINES//////////////////////
/obj/item/ammo_magazine/internal
	desc = "Oh god, this shouldn't be here!"


/obj/item/ammo_magazine/internal/shot
	name = "pump shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun
	caliber = ".12"
	max_ammo = 4

/obj/item/ammo_magazine/internal/princ
	name = "princess internal magazine"
	ammo_type = /obj/item/ammo_casing/a762
	caliber = ".762"
	max_ammo = 9

/obj/item/ammo_magazine/internal/shot/com
	name = "combat shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	max_ammo = 8

/obj/item/ammo_magazine/internal/cylinder
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = ".357"
	var/cylinders = 6
	max_ammo = 6

	New()
		..()
		check_cylinders()

	give_round(var/obj/item/ammo_casing/A)
		if(istype(A) && A.caliber == caliber)
			for(var/i = stored_ammo.len, i >= 1, i--)
				if(istype(stored_ammo[i], /obj/item/ammo_casing/none))
					stored_ammo[i] = A
					A.loc = src
					return 1
		return 0

	on_empty()
		check_cylinders()

	proc/check_cylinders()
		var/ecylinders = cylinders - stored_ammo.len
		if(ecylinders)
			for(var/i = 1, i <= ecylinders, i++)
				stored_ammo += new /obj/item/ammo_casing/none()

	ammo_count(var/countempties = 1)
		var/boolets = 0
		for(var/i = 1, i <= stored_ammo.len, i++)
			var/obj/item/ammo_casing/bullet = stored_ammo[i]
			if(!bullet.BB && !countempties)
				continue
			if(istype(bullet, /obj/item/ammo_casing/none))
				continue
			boolets++
		return boolets

	proc/spin()
		var/amt = rand(cylinders*2, cylinders*4)
		for(var/i = 1, i <= amt, i++)
			get_round(1)


/obj/item/ammo_magazine/internal/cylinder/duelista
	name = "duelista ammo"
	max_ammo = 1
	ammo_type = /obj/item/ammo_casing/a357/duelista
	cylinders = 1

/obj/item/ammo_magazine/internal/cylinder/rus357
	name = "russian revolver cylinder"
	cylinders = 6
	max_ammo = 1

/obj/item/ammo_magazine/internal/cylinder/rev38
	name = "detective revolver cylinder"
	ammo_type = /obj/item/ammo_casing/c38/e
	caliber = ".38"
	cylinders = 7
	max_ammo = 0

/obj/item/ammo_magazine/internal/cylinder/rev44
	name = "taurus revolver cylinder"
	ammo_type = /obj/item/ammo_casing/c44
	caliber = ".44"
	cylinders = 6
	max_ammo = 0

/obj/item/ammo_magazine/internal/dualshot
	name = "double-barrel shotgun internal magazine" // Yep, this is a cylinder.
	desc = "This doesn't even exist!"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	caliber = ".12"
	max_ammo = 2

/obj/item/ammo_magazine/internal/improvised
	name = "improvised shotgun internal magazine"
	desc = "This doesn't even exist"
	ammo_type = /obj/item/ammo_casing/shotgun/improvised
	caliber = ".12"
	max_ammo = 1

/obj/item/weapon/gun/projectile/newRevolver
	name = "gun"
	desc = "A gun. It looks a pretty terrible gun."
	icon = 'icons/obj/gunnew.dmi'
	icon_state = "duelista"
	caliber = ".357"
	w_class = 3.0
	jam_chance = 15
	safety = 0
	has_safety = 0
	var/maxAmmoSprite = 1
	var/open = 0
	var/opensound = 'sound/lfwbsounds/duelista_open.ogg'
	var/closesound = 'sound/lfwbsounds/duelista_close.ogg'

/obj/item/weapon/gun/projectile/newRevolver/chamber_round()
	if (chambered || !magazine)
		return
	else if (magazine.ammo_count())
		chambered = magazine.get_round(1)
	return

/obj/item/weapon/gun/projectile/newRevolver/process_chambered()
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(isnull(AC) || !istype(AC))
		return 0
	chambered = null
	chamber_round()

	AC.on_fired()

	if(AC.BB)
		in_chamber = AC.BB //Load projectile into chamber.
		AC.BB.loc = src //Set projectile loc to gun.
		AC.BB = null
		return 1

	AC.update_icon()
	return 0

/obj/item/weapon/gun/projectile/newRevolver/get_ammo(var/countchambered = 0, var/countempties = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/weapon/gun/projectile/newRevolver/proc/spin()
	set name = "Spin Chamber"
	set category = "Object"
	set desc = "Click to spin your revolver's chamber."

	var/mob/M = usr

	if(src && !M.stat && in_range(M,src) && istype(magazine, /obj/item/ammo_magazine/internal/cylinder))
		var/obj/item/ammo_magazine/internal/cylinder/C = magazine
		C.spin()
		chambered = null
		chamber_round()
		M.visible_message("<span class='combatbold'>[M]</span><span class='combat'> spins [src]'s chamber.</span>")
		playsound(src, 'sound/lfwbsounds/revolver_spin.ogg', 60, 1)
		return 1
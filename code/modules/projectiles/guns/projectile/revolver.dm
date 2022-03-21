/obj/item/weapon/gun/projectile/revolver
	desc = "A classic revolver. Uses .357 ammo"
	name = "revolver"
	icon_state = "revolver"
	item_state = "smallgun"
	mag_type = /obj/item/ammo_magazine/internal/cylinder
	jam_chance = 0
	fire_sound = 'sound/weapons/revolver1.ogg'
	safety = 0
	has_safety = 0

/obj/item/weapon/gun/projectile/revolver/duelista
	name = "Duelista"
	icon_state = "duelista"
	item_worth = 150
	mag_type = /obj/item/ammo_magazine/internal/cylinder/duelista

/obj/item/weapon/gun/projectile/revolver/chamber_round()
	if (chambered || !magazine)
		return
	else if (magazine.ammo_count())
		chambered = magazine.get_round(1)
	return

/obj/item/weapon/gun/projectile/revolver/verb/spin()
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

/obj/item/weapon/gun/projectile/revolver/process_chambered()
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

/obj/item/weapon/gun/projectile/revolver/get_ammo(var/countchambered = 0, var/countempties = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/weapon/gun/projectile/revolver/examine()
	..()
	usr << "[get_ammo(0,0)] of those are live rounds."

/obj/item/weapon/gun/projectile/revolver/detective
	desc = "A cheap Martian knock-off of a Smith & Wesson Model 10. Uses .38-Special rounds."
	name = "revolver"
	icon_state = "detective"
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_magazine/internal/cylinder/rev38


/obj/item/weapon/gun/projectile/revolver/detective/special_check(var/mob/living/carbon/human/M)
	if(magazine.caliber == initial(magazine.caliber))
		return 1
	if(prob(5))
		M << "<span class='danger'>[src] blows up in your face!</span>"
		M.take_organ_damage(0,20)
		M.drop_item()
		qdel(src)
		return 0
	return 1

/obj/item/weapon/gun/projectile/revolver/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Click to rename your gun."

	var/mob/M = usr
	var/input = stripped_input(M,"What do you want to name the gun?", ,"", 20)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		M << "You name the gun [input]. Say hello to your new friend."
		return 1
/*
/obj/item/weapon/gun/projectile/revolver/detective/verb/reskin_gun()
	set name = "Reskin gun"
	set category = "Object"
	set desc = "Click to reskin your gun."

	var/mob/M = usr
	var/list/options = list()
	options["The Original"] = "detective"
	options["Leopard Spots"] = "detective_leopard"
	options["Black Panther"] = "detective_panther"
	options["Gold Trim"] = "detective_gold"
//	options["The Peacemaker"] = "detective_peacemaker"
	options["Nipper"] = "detective_nipper"
	var/choice = input(M,"What do you want to skin the gun to?","Reskin Gun") in options

	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		M << "Your gun is now skinned as [choice]."
		return 1
*/
/obj/item/weapon/gun/projectile/revolver/detective/attackby(var/obj/item/A as obj, mob/user as mob)
	..()
	if(istype(A, /obj/item/weapon/screwdriver))
		if(magazine.caliber == ".38")
			user << "<span class='notice'>You begin to reinforce the barrel of [src].</span>"
			if(magazine.ammo_count())
				afterattack(user, user)	//you know the drill
				user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>[src] goes off in your face!</span>")
				return
			if(do_after(user, 30))
				if(magazine.ammo_count())
					user << "<span class='notice'>You can't modify it!</span>"
					return
				magazine.caliber = ".357"
				desc = "The barrel and chamber assembly seems to have been modified."
				user << "<span class='warning'>You reinforce the barrel of [src]! Now it will fire .357 rounds.</span>"
		else
			user << "<span class='notice'>You begin to revert the modifications to [src].</span>"
			if(magazine.ammo_count())
				afterattack(user, user)	//and again
				user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>[src] goes off in your face!</span>")
				return
			if(do_after(user, 30))
				if(magazine.ammo_count())
					user << "<span class='notice'>You can't modify it!</span>"
					return
				magazine.caliber = ".38"
				desc = initial(desc)
				user << "<span class='warning'>You remove the modifications on [src]! Now it will fire .38 rounds.</span>"



/obj/item/weapon/gun/projectile/revolver/mateba
	name = "mateba"
	desc = "When you absolutely, positively need a 10mm hole in the other guy. Uses .357 ammo."	//>10mm hole >.357
	icon_state = "mateba"
	origin_tech = "combat=2;materials=2"
	fire_sound = "revolver"
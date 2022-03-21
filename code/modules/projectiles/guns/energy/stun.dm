
/obj/item/weapon/gun/energy/taser
	name = "taser gun"
	desc = "A small, low capacity gun used for non-lethal takedowns."
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 100
	projectile_type = "/obj/item/projectile/energy/electrode3"
	cell_type = "/obj/item/weapon/cell/crap"
	safety = FALSE

/obj/item/weapon/gun/energy/taser/leet
	name = "Isaac-HH"
	desc = "Specially designed taser gun with detacheble battery."
	icon_state = "taser_h"
	item_state = "gun"
	cell_type = "/obj/item/weapon/cell/crap"
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 200
	projectile_type = "/obj/item/projectile/energy/electrode2"
	unloadsound = 'sound/lfwbcombatuse/energy_unload.ogg'
	reloadsound = 'sound/lfwbcombatuse/energy_reload.ogg'
	emptysound = 'sound/lfwbcombatuse/empty_energy.ogg'
	startsunloaded = 1

	attack_self(mob/user as mob)
		if(is_jammed)
			unjam(user)

	MouseDrop(var/obj/over_object)
		var/mob/user = usr
		switch(over_object.name)
			if("r_hand")
				if(power_supply)
					power_supply.loc = get_turf(src.loc)
					user.put_in_hands(power_supply)
					user.visible_message("<span class='combatbold'>[user.name]</span> <span class='combat'>unloads [src].</span>")
					playsound(src, src.unloadsound, 25, 0)
					power_supply.updateicon()
					power_supply = null
					src.update_icon()
				else
					to_chat(usr, "<span class='combat'><i>It has no cell!</i></span>")
			if("l_hand")
				if(power_supply)
					power_supply.loc = get_turf(src.loc)
					user.put_in_hands(power_supply)
					user.visible_message("<span class='combatbold'>[user.name]</span> <span class='combat'>unloads [src].</span>")
					playsound(src, src.unloadsound, 25, 0)
					power_supply.updateicon()
					power_supply = null
					src.update_icon()
				else
					to_chat(usr, "<span class='combat'><i>It has no cell!</i></span>")

	update_icon()
		if(power_supply)
			var/ratio = power_supply.charge / power_supply.maxcharge
			ratio = round(ratio, 0.25) * 100
			icon_state = "[initial(icon_state)][ratio]"
		else
			icon_state = "[initial(icon_state)]u"

	examine()
		..()
		if(!power_supply)
			to_chat(usr, "<span class='combat'>It has no battery!</span>")
		return

	attackby(var/obj/item/A, var/mob/user)
		if(istype(A, /obj/item/weapon/cell/crap) && !power_supply)
			user.drop_item(sound = 0)
			power_supply = A
			power_supply.loc = src
			user.visible_message("<span class='combatbold'>[user.name]</span> <span class='combat'>reloads [src]!</span>")
			playsound(src, src.reloadsound, 25, 0)
			var/obj/item/weapon/cell/crap/C = A			//I didn't know how to do it without hardcoded type
			C.updateicon()
			update_icon()
		else
			..()
			return

/obj/item/weapon/gun/energy/taser/leet/sparq
	name = "Sparq beam"
	jam_chance = 0 // VAI TOMAR NO CU COMICAO, TASER NÃO DÁ JAMMMMMMMMMMMMM
	explode_chance = 1
	is_exploding = 0
	desc = "A pseudo-taser designed to administer pain. Lots of pain."
	icon_state = "sparq"
	item_state = "smallgun"
	fire_sound = "sparq"
	cell_type = "/obj/item/weapon/cell/crap/sparq"
	projectile_type = "/obj/item/projectile/energy/sparq"
	reloadsound = 'sound/weapons/pain_reload.ogg'
	unloadsound = 'sound/weapons/pain_unload.ogg'
	recoil = 0
	charge_cost = 100
	no_trigger_guard = TRUE

/obj/item/weapon/gun/energy/taser/leet/noctis
	name = "Noctis-09"
	jam_chance = 0 // VAI TOMAR NO CU COMICAO, TASER NÃO DÁ JAMMMMMMMMMMMMM
	explode_chance = 1
	is_exploding = 0
	projectile_type = "/obj/item/projectile/energy/electrode"
	desc = "An ancient less-lethal, now repurposed for use by agents of the INKVD."
	icon_state = "noctis"
	item_state = "noctis"
	reloadsound = 'sound/lfwbcombatuse/noctis_reload.ogg'
	unloadsound = 'sound/lfwbcombatuse/noctis_unload.ogg'
	recoil = 0
	charge_cost = 200


/obj/item/weapon/gun/energy/taser/leet/maulet
	name = "Maulet P2R"
	jam_chance = 0 // VAI TOMAR NO CU COMICAO, TASER NÃO DÁ JAMMMMMMMMMMMMM
	explode_chance = 1
	is_exploding = 0
	icon_state = "maulet"
	cell_type = "/obj/item/weapon/cell/crap"
	projectile_type = "/obj/item/projectile/energy/electrode3"
	recoil = 0

/obj/item/weapon/gun/energy/taser/leet/legax
	name = "Legax Gravpulser"
	desc = "An experimental handcannon with a catch."
	jam_chance = 0 // VAI TOMAR NO CU COMICAO, TASER NÃO DÁ JAMMMMMMMMMMMMM
	explode_chance = 2
	is_exploding = 0
	icon_state = "gravpulser"
	item_state = "gravcutter"
	cell_type = "/obj/item/weapon/cell/crap"
	fire_sound = "gravpulser"
	projectile_type = "/obj/item/projectile/energy/legax"
	recoil = 0
	charge_cost = 300

/obj/item/weapon/gun/energy/taser/leet/laser
	name = "6B-Lasgun"
	desc = "A meaty pistol, posing as a laser gun."
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	w_class = 3.0
	m_amt = 2000
	origin_tech = "combat=3;magnets=2"
	projectile_type = "/obj/item/projectile/energy/laser"

/obj/item/weapon/gun/energy/taser/leet/laser/New()
	..()
	var/obj/item/weapon/cell/crap/leet/L = new(src)
	power_supply = L
	power_supply.loc = src

/obj/item/weapon/gun/energy/taser/leet/legax/attack_self(mob/living/user)
	. = ..()
	if(user.r_hand == src || user.l_hand == src)
		if(projectile_type == "/obj/item/projectile/energy/legax")
			to_chat(user, "[icon2html(src, usr)]<span class='passivebold'>NEW MODE: WEAK.</span>")
			projectile_type = "/obj/item/projectile/energy/legax/weak"
			playsound(user, 'sound/items/safety.ogg', 50, 1)
			charge_cost = 150
		else
			to_chat(user, "[icon2html(src, usr)]<span class='passivebold'>NEW MODE: SERIOUS.</span>")
			projectile_type = "/obj/item/projectile/energy/legax"
			playsound(user, 'sound/items/safety.ogg', 50, 1)
			charge_cost = 300
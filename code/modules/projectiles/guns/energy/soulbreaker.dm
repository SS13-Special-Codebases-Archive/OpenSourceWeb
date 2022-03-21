/obj/item/weapon/gun/energy/taser/MERCY
	name = "MERCY stunner beam"
	desc = "Feita especialmente com bateria soltavel."
	icon_state = "stunner"
	item_state = "stunrifle"
	wielded_icon = "stunner-wielded"
	fire_sound = 'sound/effects/stunner.ogg'
	cell_type = "/obj/item/weapon/cell/crap"
	projectile_type = "/obj/item/projectile/energy/stunner"
	charge_cost = 0
	jam_chance = 0
	recoil = 0
	var/mode = 1

/obj/item/weapon/gun/energy/taser/MERCY/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)
	if(mode)
		..()
		sleep(1)
		..()
		sleep(1)
		..()
	else
		..()

/obj/item/weapon/gun/energy/taser/MERCY/soulbreaker
	name = "MERCY Stunner Rifle"
	desc = "Designed by TNC in the year 2590. Specially to detain people."
	mode = 1
	item_worth = 250
	slot_flags = SLOT_BACK

/obj/item/weapon/gun/energy/taser/MERCY/pistol
	name = "MERCY Stunner Pistol"
	desc = "Designed by TNC in the year 2590. Specially to detain people."
	icon_state = "stunnerpistol"
	item_state = "stunner"
	wielded_icon = "stunner"
	mode = 0
	slot_flags = SLOT_BELT
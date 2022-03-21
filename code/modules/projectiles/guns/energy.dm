/obj/item/weapon/gun/energy
	icon_state = "energy"
	item_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun."
	fire_sound = 'sound/weapons/taser2.ogg'

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 100 //How much energy is needed to fire.
	var/cell_type = "/obj/item/weapon/cell"
	var/projectile_type = "/obj/item/projectile/beam/practice"
	var/modifystate
	var/nomodifystate = 0
	var/startsunloaded = 0
	jam_chance = 0

	emp_act(severity)
		power_supply.use(round(power_supply.charge / severity))
		update_icon()
		..()


	New()
		..()
		if(startsunloaded)
			return 0
		if(cell_type)
			power_supply = new cell_type(src)
		else
			power_supply = new(src)
		power_supply.give(power_supply.maxcharge)
		return


	process_chambered()
		if(in_chamber)	return 1
		if(!power_supply)	return 0
		if(!power_supply.use(charge_cost))	return 0
		if(!projectile_type)	return 0
		in_chamber = new projectile_type(src)
		return 1


	update_icon()
		var/ratio = power_supply.charge / power_supply.maxcharge
		ratio = round(ratio, 0.25) * 100
		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else if(nomodifystate == 1)
			icon_state = "[initial(icon_state)]"
		else
			icon_state = "[initial(icon_state)][ratio]"

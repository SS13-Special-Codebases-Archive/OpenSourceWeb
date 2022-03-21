/obj/item/weapon/pinpointer/compass
	name = "space compass"
	desc = "A rather helpful device, can save your ass from being lost. It shows the direction of the nearest large vessel."
	var/set_shipname = "NSV Luna"

	attack_self()
		if(!active)
			active = 1
			workdisk()
			usr << "\blue You activate the space compass"
		else
			active = 0
			icon_state = "pinoff"
			usr << "\blue You deactivate the space compass"

	workdisk()
		if(!active) return
		var/z_level = src.z
		var/obj/effect/map/ship/Ship = locate("ship_[set_shipname]")
		if(!istype(src.loc, /turf))
			z_level = src.loc.z
			if(!istype(src.loc.loc, /turf))			//Shitty, but it's needed for pods.
				z_level = src.loc.loc.z

		if(z_level in Ship.ship_levels)
			icon_state = "pinondirect"
		else
			var/obj/effect/map/M = map_sectors["[z_level]"]

			dir = get_dir(M,Ship)
			switch(get_dist(src,the_disk))
				if(0)
					icon_state = "pinondirect"
				if(1 to 3)
					icon_state = "pinonclose"
				if(4 to 8)
					icon_state = "pinonmedium"
				if(8 to INFINITY)
					icon_state = "pinonfar"

		spawn(5) .()
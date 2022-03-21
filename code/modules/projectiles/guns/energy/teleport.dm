/obj/item/weapon/gun/energy/teleport_gun
	name = "teleport gun"
	desc = "A hacked together combination of a taser and a handheld teleportation unit."
	icon_state = "taser_h"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 250
	projectile_type = "/obj/item/projectile/energy/teleshot"
	origin_tech = "combat=3;magnets=3;bluespace=3"

	var/obj/item/teletarget = null

/obj/item/weapon/gun/energy/teleport_gun/attack_self(mob/user as mob)
	var/list/L = list()
	for(var/obj/machinery/teleport/hub/R in world)
		var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
		if (istype(com, /obj/machinery/computer/teleporter) && com.locked)
			if(R.icon_state == "tele1")
				L["[com.id] (Active)"] = com.locked
			else
				L["[com.id] (Inactive)"] = com.locked
	L["None (Dangerous)"] = null
	var/t1 = input(user, "Please select a teleporter to lock in on.", "Teleporter Gun") in L
	if (user.equipped() != src || user.stat || user.restrained())
		return
	var/T = L[t1]
	teletarget = T
	usr << "\blue Teleportation hub selected!"
	src.add_fingerprint(user)
	return

/obj/item/weapon/gun/energy/teleport_gun/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/bluespace_crystal))
		var/obj/item/weapon/bluespace_crystal/C = A
		power_supply.charge += charge_cost*(C.blink_range/4)
		power_supply.maxcharge += charge_cost*(C.blink_range/4)
		user << "<span class='notice'>You add [C] to [src]'s crystal array.</span>"
		update_icon()
	else
		..()


/obj/item/projectile/energy/teleshot
	nodamage = 1
	name = "teleshot"

/obj/item/projectile/energy/teleshot/on_hit(var/atom/A, var/blocked = 0)
	var/failchance = 5
	var/obj/item/target = null

	if(istype(shot_from, /obj/item/weapon/gun/energy/teleport_gun))
		var/obj/item/weapon/gun/energy/teleport_gun/T = shot_from
		target = T.teletarget
		failchance = 100 - T.reliability

	if(target == null)
		var/list/turfs = list()
		for(var/turf/T in orange(10, get_turf(src)) )
			if(T.x>(world.maxx-4) || T.x<4)	continue	//putting them at the edge is dumb
			if(T.y>(world.maxy-4) || T.y<4)	continue
			turfs += T
		if(turfs.len)
			target = pick(turfs)

	if(!target)
		qdel(src)
		return

	if(A)
		var/turf/T = get_turf(A)
		for(var/atom/movable/M in T)
			if(istype(M, /obj/effect)) //sparks don't teleport
				continue
			if (M.anchored)
				continue
			if (istype(M, /atom/movable))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, M)
				s.start()
				if(prob(failchance)) //oh dear a problem, put em in deep space
					do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), pick(3,4,5)), 0)
				else
					do_teleport(M, target, 1)
	qdel(src)
/datum/stopped_time
	var/no_garbage = null
	New(atom/victim)
		..()
		no_garbage = src //Prevents GC from deleting the datum
		var/const/minute = 60
		var/time = 0
		for (var/i=0,i<10,i++)
			time += rand()*minute
		time = round(2 * time)
		if (prob(2))
			time = 0
		if (victim)
			if (isobj(victim) && victim in processing_objects)
				processing_objects.Remove(victim)
				if (time)
					spawn(time)
						processing_objects.Add(victim)
						victim:process()
						qdel(src)
			if (ismob(victim) && victim in mob_list)
				mob_list.Remove(victim)
				if (time)
					spawn(time)
						mob_list.Add(victim)
						victim:Life()
						qdel(src)
			if (istype(victim, /obj/machinery) && victim in machines)
				machines.Remove(victim)
				if (time)
					spawn(time)
						machines.Add(victim)
						victim:process()
						qdel(src)

/obj/item/weapon/time_space_crystal
	name = "Bluespace crystal with holes and cracks"
	desc = {"
This crystal is a bluespace crystal with anomalous properties. It will \"stop\" time for whatever it bumped into upon hit.
The target won't have any continuous processes working but will be able to \"record\" received changes. When time start going again those changes will be received at once.
Time will be \"stopped\" usually for about a minute, however it's proved to be random ranging from seconds to infinity in some cases.
Use it carefully as it is quite fragile.
These things have been banned for distortion of space-time continuum and therefore are illegal and known to belong to Syndicate."}
	icon = 'icons/obj/telescience.dmi'
	icon_state = "bluespace_crystal"
	origin_tech = "bluespace=7;materials=5;syndicate=2"

/obj/item/weapon/time_space_crystal/New()
	..()
	pixel_x = rand(-15, 15)
	pixel_y = rand(-15, 15)

/obj/item/weapon/time_space_crystal/afterattack(atom/victim)
	viewers(5, src) << "\red [src] is crushed against [victim] by [usr]"
	new /datum/stopped_time(victim)
	victim << "\red \bold You feel yourself weird"
	..()
	qdel(src)


/obj/item/weapon/time_space_crystal/throw_impact(atom/victim)
	viewers(5, src) << "\red [src.name] hits the [victim] and shatters!"
	new /datum/stopped_time(victim)
	victim << "\red \bold  You feel yourself weird"
	..()
	qdel(src)

/obj/item/weapon/time_space_crystal/attack_self(mob/user)
	user << "\blue You crush the [src]"
	viewers(2, src) << "\red [user] crushed the [src]"
	new /datum/stopped_time(user)
	user << "\red \bold  You feel yourself weird"
	..()
	qdel(src)
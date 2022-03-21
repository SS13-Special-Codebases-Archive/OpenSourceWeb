/obj/item/weapon/gun/syringe
	name = "syringe gun"
	desc = "A spring loaded rifle designed to fit syringes, used to incapacitate unruly patients from a distance."
	icon_state = "syringegun"
	item_state = "syringegun"
	w_class = 3
	throw_speed = 2
	throw_range = 10
	force = 4
	m_amt = 2000
	clumsy_check = 0
	fire_sound = 'sound/items/syringeproj.ogg'
	var/list/syringes = list()
	var/max_syringes = 1

/obj/item/weapon/gun/syringe/process_chambered()
	if(!syringes.len) return 0

	var/obj/item/weapon/reagent_containers/syringe/S = syringes[1]

	if(!S) return 0

	in_chamber = new /obj/item/projectile/bullet/dart/syringe(src)
	S.reagents.trans_to(in_chamber, S.reagents.total_volume)
	in_chamber.name = S.name
	syringes.Remove(S)

	qdel(S)
	return 1

/obj/item/weapon/gun/syringe/examine()
	..()
	usr << "Can hold [max_syringes] syringe\s. Has [syringes.len] syringe\s remaining."
	return

/obj/item/weapon/gun/syringe/attack_self(mob/living/user as mob)
	if(!syringes.len)
		user << "<span class='notice'>[src] is empty.</span>"
		return 0

	var/obj/item/weapon/reagent_containers/syringe/S = syringes[syringes.len]

	if(!S) return 0
	S.loc = user.loc

	syringes.Remove(S)
	user << "<span class = 'notice'>You unload [S] from \the [src]!</span>"

	return 1

/obj/item/weapon/gun/syringe/attackby(var/obj/item/A as obj, mob/user as mob, var/show_msg = 1)
	if(istype(A, /obj/item/weapon/reagent_containers/syringe))
		if(syringes.len < max_syringes)
			user.drop_item()
			user << "<span class='notice'>You load [A] into \the [src]!</span>"
			syringes.Add(A)
			A.loc = src
			return 1
		else
			usr << "<span class='notice'>[src] cannot hold more syringes.</span>"
	return 0

/obj/item/weapon/gun/syringe/rapidsyringe
	name = "rapid syringe gun"
	desc = "A modification of the syringe gun design, using a rotating cylinder to store up to six syringes."
	icon_state = "rapidsyringegun"
	max_syringes = 6

/obj/item/projectile/bullet/dart
	name = "dart"
	icon_state = "cbbolt"
	damage = 6

	New()
		..()
		flags |= NOREACT
		create_reagents(50)

	on_hit(var/atom/target, var/blocked = 0)
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/M = target
			reagents.trans_to(M, reagents.total_volume)
		else
			flags &= ~NOREACT
			reagents.handle_reactions()
		return 1

/obj/item/projectile/bullet/dart/metalfoam
	New()
		..()
		reagents.add_reagent("aluminium", 15)
		reagents.add_reagent("foaming_agent", 5)
		reagents.add_reagent("pacid", 5)

/obj/item/projectile/bullet/dart/syringe
	name = "syringe"
	icon_state = "syringe"

/obj/effect/syringe_gun_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	anchored = 1
	density = 0

	New()
		var/datum/reagents/R = new/datum/reagents(15)
		reagents = R
		R.my_atom = src
/obj/structure/grille
	desc = "A flimsy lattice of metal rods, with screws to secure it to the floor."
	name = "grille"
	icon = 'icons/obj/structures.dmi'
	icon_state = "grille"
	density = 1
	anchored = 1
	break_sounds = list('sound/effects/n_grille_hit.ogg', 'sound/effects/n_grille_hit2.ogg', 'sound/effects/n_grille_hit3.ogg')
	breakable = TRUE
	flags = FPRINT | CONDUCT
	pressure_resistance = 5*ONE_ATMOSPHERE
	drops = list()
	layer = 2.8

	explosion_resistance = 5
	var/destroyed = 0
	var/dire = EAST //FOR GRILLE/L
	var/icon_destroyed = "brokengrille"

/obj/structure/grille/reinforced
	name = "reinforced grille"
	desc = "A flimsy lattice of metal rods, with screws to secure it to the floor."
	throwpass = 1
	plane = 15

/obj/structure/grille/reinforced/bars
	name = "barras de metal"
	desc = "Um monte de pedaços de ferro presos ao chão."
	icon_state = "bars"
	icon_destroyed = "barsbroken"
	throwpass = 1
	layer = MOB_LAYER+1
	dire = SOUTH

/obj/structure/grille/reinforced/bars/east
	dire = EAST


/obj/structure/grille/reinforced/bars/west
	dire = WEST

/obj/structure/grille/reinforced/bars/north
	dire = NORTH

/obj/structure/grille/reinforced/l
	name = "reinforced grille"
	icon_state = "grillex"
	desc = "A flimsy lattice of metal rods, with screws to secure it to the floor."
	layer = MOB_LAYER+1
	dir = SOUTH
	icon_destroyed = "brokengrillex"


/obj/structure/grille/reinforced/l/southeast

/obj/structure/grille/reinforced/l/south
	dire = SOUTH


/obj/structure/grille/reinforced/l/north
	dire = NORTH

/obj/structure/grille/reinforced/l/west
	dire = WEST

/obj/structure/grille/reinforced/l/south/cemetary
	name = "Cemetary Grille"
	icon_destroyed = "cemeterybroken"
	icon_state = "cemetery"
	dire = SOUTH


/obj/structure/grille/reinforced/bars/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item))
		return 1
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(get_dir(loc, target) == dir || get_dir(loc, target) == dire) //Make sure looking at appropriate border
		if(air_group) return 0
		return !density
	else
		return 1

/obj/structure/grille/reinforced/bars/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(istype(mover,/obj/item))
		return 1
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(get_dir(loc, target) == dir || get_dir(loc, target) == dire)
		return !density
	else
		return 1




/obj/structure/grille/reinforced/l/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item))
		return 1
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(get_dir(loc, target) == dir || get_dir(loc, target) == dire) //Make sure looking at appropriate border
		if(air_group) return 0
		return !density
	else
		return 1

/obj/structure/grille/reinforced/l/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(istype(mover,/obj/item))
		return 1
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(get_dir(loc, target) == dir || get_dir(loc, target) == dire)
		return !density
	else
		return 1

/obj/structure/grille/ex_act(severity)
	qdel(src)

/obj/structure/grille/blob_act()
	qdel(src)

/obj/structure/grille/meteorhit(var/obj/M)
	qdel(src)


/obj/structure/grille/Bumped(atom/user)
	if(ismob(user))
		shock(user, 70)
		if(iszombie(user))
			src.attack_hand(user)
		return ..()


/obj/structure/grille/attack_paw(mob/user as mob)
	attack_hand(user)

/obj/structure/grille/attack_hand(mob/user as mob)
	if(!user)
		return playsound(loc, pick('sound/effects/n_grille_hit.ogg', 'sound/effects/n_grille_hit2.ogg', 'sound/effects/n_grille_hit3.ogg'), 80, 1)
	playsound(loc, pick('sound/effects/n_grille_hit.ogg', 'sound/effects/n_grille_hit2.ogg', 'sound/effects/n_grille_hit3.ogg'), 80, 1)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			hitstake -= rand(1,2)
			user.visible_message("<span class='warning'>[user] mangles [src].</span>", \
					 "<span class='warning'>You mangle [src].</span>", \
					 "You hear twisting metal.")

	if(shock(user, 70))
		return
	if(iszombie(usr))			//If it's a zombie
		user.visible_message("<span class='danger'>[user] [pick("bangs on","slashes against")] the [src.name]!</span>", \
						 "<span class='warning'>You bang on the [src.name].</span>", \
						 "You hear twisting metal.")
		hitstake -= rand(2,3)
		update_hits()
		return
	if(HULK in user.mutations)		//Or hulk
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message("<span class='danger'>[user] tears the [src.name] apart!</span>", \
						 "<span class='warning'>You tear the [src.name] apart.</span>", \
						 "You hear a sound of twisting metal followed by a crack.")
		hitstake -= 1
		update_hits()
		return
	else
		hitstake -= 1
		user.visible_message("<span class='warning'>[user] kicks [src].</span>", \
						 "<span class='warning'>You kick [src].</span>", \
						 "You hear twisting metal.")
		update_hits()
		return

	playsound(loc, pick('sound/effects/n_grille_hit.ogg', 'sound/effects/n_grille_hit2.ogg', 'sound/effects/n_grille_hit3.ogg'), 80, 1)
	user.visible_message("<span class='warning'>[user] smashes against [src].</span>", \
						 "<span class='warning'>You smash against [src].</span>", \
						 "You hear twisting metal.")

	hitstake -= 1
	update_hits()
	return

/obj/structure/grille/attack_animal(var/mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)	return

	playsound(loc, pick('sound/effects/n_grille_hit.ogg', 'sound/effects/n_grille_hit2.ogg', 'sound/effects/n_grille_hit3.ogg'), 80, 1)
	M.visible_message("<span class='warning'>[M] smashes against [src].</span>", \
					  "<span class='warning'>You smash against [src].</span>", \
					  "You hear twisting metal.")

	hitstake -= 1
	update_hits()
	return


/obj/structure/grille/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover) && mover.checkpass(PASSGRILLE))
		return 1
	else
		if(istype(mover, /obj/item/projectile))
			return prob(30)
		else
			return !density

/obj/structure/grille/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	hitstake -= round(Proj.damage*0.2)
	update_hits()
	return 0

/obj/structure/grille/update_hits()
	if(hitstake >= hits)
		if(!destroyed)
			if(istype(src, /obj/structure/grille/reinforced/l/south || /obj/structure/grille/reinforced/l/southeast))
				dir = null
				dire = null
				density = 0
				destroyed = 1
				if(icon_destroyed)
					icon_state = icon_destroyed
			if(istype(src, /obj/structure/grille/reinforced/bars))
				dir = null
				dire = null
				density = 0
				destroyed = 1
				if(icon_destroyed)
					icon_state = icon_destroyed
			else
				icon_state = icon_destroyed
				density = 0
				destroyed = 1

		else
			if(hitstake <= hits + 6)
				destroy()
				return
	return

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user as mob, prb)
	if(!anchored || destroyed)		// anchored/destroyed grilles are never connected
		return 0
	if(!prob(prb))
		return 0
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return 0
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			return 1
		else
			return 0
	return 0

/obj/structure/grille/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!destroyed)
		if(exposed_temperature > T0C + 1500)
			hitstake -= 1
			update_hits()
	..()
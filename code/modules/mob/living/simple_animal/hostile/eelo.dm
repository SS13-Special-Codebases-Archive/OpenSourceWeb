/mob/living/simple_animal/hostile/retaliate/eelo
	name = "Eelo"
	desc = "What the hell is this?!"
	icon = 'icons/mob/critter.dmi'
	speak_emote = list("gibbers")
	icon_state = "strygh"
	icon_living = "strygh"
	icon_dead = "strygh-dead"
	health = 80
	maxHealth = 80
	melee_damage_lower = 5
	melee_damage_upper = 9
	speak_chance = 1
	robust_searching = 1
	move_to_delay = 5
	speak_chance = 0
	attacktext = "claws"
	destroy_surroundings = 0
	search_objects = 0
	attack_sound = 'sound/effects/strygh_attack_01.ogg'
	faction = "creature"
	speed = 7
	a_intent = "harm"
	stance = HOSTILE_STANCE_ATTACK


/mob/living/simple_animal/hostile/retaliate/eelo/Move()
	..()
	if(stat != 0)
		return
	if(prob(10))
		playsound(src, pick('sound/effects/strygh_life1.ogg','sound/effects/strygh_life2.ogg'), 25, 0, -1)
	if(prob(50))
		playsound(src, 'chameleon_step.ogg', 25, 0, -1)

/mob/living/simple_animal/hostile/retaliate/eelo/Found(mob/living/carbon)
	..()
	//playsound(src, pick('strygh_spot.ogg','strygh_spot2.ogg'), 15, 0, -1)

/mob/living/simple_animal/hostile/retaliate/eelo/Retaliate()
	..()
	//src.visible_message("<span class='combatbold'> [src]</span> <span class='combat'>looks alert.</span>")

/mob/living/simple_animal/hostile/retaliate/eelo/ListTargets()
	return view(10, src) - src

/mob/living/simple_animal/hostile/retaliate/eelo/attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
	if(istype(O, /obj/item/stack/medical))

		if(stat != DEAD)
			var/obj/item/stack/medical/MED = O
			if(health < maxHealth)
				if(MED.amount >= 1)
					adjustBruteLoss(-MED.heal_brute)
					MED.amount -= 1
					if(MED.amount <= 0)
						qdel(MED)
					for(var/mob/M in viewers(src, null))
						if ((M.client && !( M.blinded )))
							M.show_message("\blue [user] applies the [MED] on [src]")
		else
			user << "\blue this [src] is dead, medical items won't bring it back to life."
	if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(istype(O, /obj/item/weapon/kitchenknife) || istype(O, /obj/item/weapon/butch) || istype(O, /obj/item/weapon/kitchen/utensil/knife))
			new meat_type (get_turf(src))
			new meat_type (get_turf(src))
			new meat_type (get_turf(src))
			new leather_type (get_turf(src))
			new leather_type (get_turf(src))
			//del(src)
			gib(src)
	else
		if(O.force)
			var/damage = O.force
			if (O.damtype == HALLOSS)
				damage = 0
			adjustBruteLoss(damage)
			for(var/mob/M in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message("<span class='hitbold'>[src]</span> <span class='hit>'has been attacked with the [O] by</span> <span class='hitbold'>[user]</span><span class='hit'>!</span> ")
					playsound(src, O.hitsound, 25, 0, -1)
		else
			to_chat(user, "<span class='combat'>This weapon is ineffective, it does no damage.</span>")
			for(var/mob/M in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message("<span class='passivebold'>[user]</span> <span class='passive'>gently taps</span><span class='passive'>[src]</span> <span class='passive'>with the [O].</span>")
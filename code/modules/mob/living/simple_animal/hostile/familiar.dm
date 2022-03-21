/mob/living/simple_animal/hostile/retaliate/familiar
	name = "Familiar"
	desc = "What the hell is this?!"
	icon = 'icons/monsters/critter.dmi'
	icon_state = "familliar"
	speak_emote = list("gibbers")
	icon_living = "familliar"
	icon_dead = "familliar2"
	health = 85
	maxHealth = 85
	melee_damage_lower = 0
	melee_damage_upper = 0
	move_to_delay = 14
	break_stuff_probability = 0
	harm_intent_damage = 35
	speak_chance = 1
	robust_searching = 0
	speak = list("Help!")
	attacktext = "punches"
	destroy_surroundings = 0
	search_objects = 0
	attack_sound = 'fam_att.ogg'
	faction = "creature"
	speed = 25
	a_intent = "harm"
	wall_smash = 0
	status_flags = CANPUSH
	stat_attack = 1
	stance = HOSTILE_STANCE_ATTACK

/mob/living/simple_animal/hostile/retaliate/familiar/ListTargets()
	return view(12, src) - src

/mob/living/simple_animal/hostile/retaliate/familiar/Retaliate()
	..()
	src.visible_message("\red [src] looks angry.")

/mob/living/simple_animal/hostile/retaliate/familiar/movement_delay()
	var/tally = 25
	return tally+config.animal_delay

/mob/living/simple_animal/hostile/retaliate/familiar/AttackingTarget()
	..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		for(var/obj/item/weapon/stone/S in view(10, src))
			sleep(10)
			S.throw_at(H, 9, 0.5, S)
			if(prob(5))
				playsound(src.loc, attack_sound, 50, 0, -1)

/mob/living/simple_animal/hostile/retaliate/familiar/attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
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
					M.show_message("\red \b [src] has been attacked with the [O] by [user]. ")
					playsound(src, O.hitsound, 25, 0, -1)
		else
			usr << "\red This weapon is ineffective, it does no damage."
			for(var/mob/M in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message("\red [user] gently taps [src] with the [O]. ")
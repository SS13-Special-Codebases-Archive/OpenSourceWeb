/mob/living/simple_animal/hostile/retaliate/graga
	name = "Graga"
	desc = "What the hell is this?!"
	icon = 'icons/monsters/critter.dmi'
	icon_state = "graga"
	speak_emote = list("gibbers")
	icon_living = "graga"
	deals_blunt = 1
	icon_dead = "graga2"
	health = 450
	maxHealth = 450
	melee_damage_lower = 145
	melee_damage_upper = 145
	move_to_delay = 15
	break_stuff_probability = 100
	speak_chance = 1
	robust_searching = 0
	speak = list("AHHHHHHHRR!","GRRRRRRRRRR!")
	attacktext = "punches"
	destroy_surroundings = 2
	search_objects = 0
	attack_sound = 'sound/effects/graga_attack6.ogg'
	faction = "creature"
	speed = 25
	a_intent = "harm"
	wall_smash = 1
	status_flags = CANPUSH
	stat_attack = 1
	stance = HOSTILE_STANCE_ATTACK
	item_worth = 300

/mob/living/simple_animal/hostile/retaliate/graga/New()
	src.name = "[pick("Copetti", "Gutus", "Nenem", "Toby", "Bidu", "Mel", "Negresco")]"
	if(src.name == "Negresco")
		src.color = "#A52A2A"
	..()

/mob/living/simple_animal/hostile/retaliate/graga/Move()
	if(stat != 0)
		return
	var/selectedSound = pick('sound/effects/graga_life1.ogg', 'sound/effects/graga_life2.ogg', 'sound/effects/graga_life3.ogg')
	var/stepSound = pick('sound/effects/graga_step1.ogg', 'sound/effects/graga_step2.ogg')
	playsound(src.loc, stepSound, 50, 0, -1)
	if(prob(5))
		visible_message("<b class='danger'><h3>[pick("AHHHHHH", "UHHHHHHH", "HGHHHH")]<h3></b>")
		playsound(src.loc, selectedSound, 50, 1, -1)
	for(var/mob/living/carbon/human/H in view(world.view, src))
		shake_camera(H, 1, 1)
	return ..()

/mob/living/simple_animal/hostile/retaliate/graga/ListTargets()
	return view(12, src) - src

/mob/living/simple_animal/hostile/retaliate/graga/Retaliate()
	..()
	// src.visible_message("<span class='combatbold'>[src]</span> <span class='combat'>looks alert.</span>")
/*
/mob/living/simple_animal/hostile/retaliate/graga/movement_delay()
	var/tally = 0
	return tally + 8
*/
/mob/living/simple_animal/hostile/retaliate/graga/movement_delay()
	var/tally = 25 //Incase I need to add stuff other than "speed" later
	return tally+config.animal_delay

/mob/living/simple_animal/hostile/retaliate/graga/AttackingTarget()
	..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/edgeTurf = get_edge_target_turf(src, src.dir)
		H.throw_at(edgeTurf, 4,	 2)
		var/chosenOrgan = pick(H?.organs_by_name)
		H.apply_damage(500, BRUTE, chosenOrgan)
		return H

/mob/living/simple_animal/hostile/retaliate/graga/attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
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
					M.show_message("<span class='hitbold'>[src]</span> <span class='hit'>has been attacked with the [O] by</span> <span class='hitbold'>[user]</span><span class='hit'>.</span> ")
					playsound(src, O.hitsound, 25, 0, -1)
		else
			to_chat(usr, "<span class='combatbold'>This weapon is ineffective, it does no damage.</span>")
			for(var/mob/M in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message("<span class='combatbold'>[user]</span> <span class='combat'>gently taps</span> <span class='combatbold'>[src]</span> <span class='combat'>with the [O].</span> ")
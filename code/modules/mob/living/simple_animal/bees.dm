
/mob/living/simple_animal/bee
	name = "bees"
	icon = 'icons/obj/lw_bees.dmi'
	icon_state = "swarm"
	icon_dead = "swarm"
	var/turf/target_turf
	var/mob/target_mob
	var/obj/structure/bee_hive/hive
	var/spawn_time = 0
	var/time_to_live = 600 // 1 minute
	var/max_distance = 3
	var/calmdown = 0
	speed = -8
	pass_flags = PASSTABLE
	density = 0
	anchored = 1	//  don't get pushed around

/mob/living/simple_animal/bee/New()
	spawn_time = world.time
	..()

/mob/living/simple_animal/bee/Destroy()
	if(hive)
		hive.child_bee = null
		hive.mob_targeted = null
	..()

/mob/living/simple_animal/bee/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 1

/mob/living/simple_animal/bee/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return

/mob/living/simple_animal/bee/Life()
	..()
	if((max_distance <= get_step(src, get_dir(src, hive))) || !(target_mob in view(src, 7)))
		if((spawn_time + time_to_live) <= world.time)
			qdel(src)
			return
	if(calmdown)
		calmdown -= 1

	else if(stat == CONSCIOUS)
		playsound(src.loc, 'sound/webbers/swarm_loop.ogg', 70, wait=1, repeat=0)
		var/mob/living/carbon/human/M = target_mob
		if(M in view(1,src)) // Can I see my target?
			var/obj/item/clothing/worn_suit = M.wear_suit
			var/obj/item/clothing/worn_helmet = M.head
			var/list/target_zones = M.organs_by_name - M.internal_organs_by_name
			var/list/head_zone = list("face" = M.organs_by_name["face"], "mouth" = M.organs_by_name["mouth"], "throat" = M.organs_by_name["throat"], "head" = M.organs_by_name["head"])
			if(istype(worn_suit,/obj/item/clothing/suit/space) || istype(worn_suit,/obj/item/clothing/suit/bio_suit))
				target_zones &= head_zone
			if(istype(worn_helmet,/obj/item/clothing/head/helmet/space) || istype(worn_helmet,/obj/item/clothing/head/bio_hood))
				target_zones &= ~head_zone
			if(M.stat == CONSCIOUS && !iszombie(M)) // Try to sting! If you're not moving, think about stinging.
				var/target_zone = pick(target_zones)
				if(target_zone)
					var/datum/organ/external/affected = M.get_organ(target_zone)
					affected.add_pain(10)
					M.confused = max(pick(1, 2), M.confused)
					if(prob(33))
						var/sound_play = pick('bee_attack1.ogg','bee_attack2.ogg','bee_attack3.ogg')
						playsound(src.loc, sound_play, 100, 1)
					if(prob(25))
						to_chat(M, "<span class='combatbold'>The [src] stings [M]!</span>")

		if(target_mob)
			if(iszombie(target_mob))
				target_mob = null
			if(target_mob in view(7,src))
				target_turf = get_turf(target_mob)
				wander = 0

			else // My target's gone! But I might still be pissed! You there. You look like a good stinging target!
				for(var/mob/living/carbon/human/G in view(src,7))
					if(iszombie(G) || G.check_perk(/datum/perk/bee_queen))
						continue
					target_mob = G
					break

		if(target_turf)
			if (!(DirBlocked(get_step(src, get_dir(src,target_turf)),get_dir(src,target_turf)))) // Check for windows and doors!
				Move(get_step(src, get_dir(src,target_turf)))

/mob/living/simple_animal/bee/attack_hand(mob/user as mob)
	if(user.a_intent != "help" || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.check_perk(/datum/perk/bee_queen))
		H.visible_message("<span class='passive'>[H] pets [src].</span>")
		calmdown = rand(7, 10)
	else
		return
/mob/living/carbon/human/movement_delay(var/actualDir, var/goingTo)
	var/tally = ..()
	//if(!has_gravity(src))
	//	return -1	//It's hard to be slowed down in space by... anything
	if(status_flags & GOTTAGOFAST) return -1

	if(species.slowdown)
		tally = species.slowdown

	if (istype(loc, /turf/space)) return -1 // It's hard to be slowed down in space by... anything

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	if (buckled && istype(buckled, /obj/structure/stool/bed/chair/wheelchair))
		return 3

//	if(reagents.has_reagent("morphine")) return -1

//	if(reagents.has_reagent("nuka_cola")) return -1


	tally += painTally()

	if(wear_suit)
		tally += wear_suit.slowdown

	if(sprinting && my_stats)
		tally -= (my_stats.spd / 10) * 2

	if(facing_dir && special != "weirdgait" && shouldTally(actualDir, goingTo))
		tally += 0.6

	if(special == "needhurry")
		tally += 0.5

	if(druggy)
		tally += 0.5

	if(pulling)
		tally += 0.5
		if(istype(pulling, /obj))
			var/obj/O = pulling
			if(O.heavy && !check_perk(/datum/perk/docker))
				tally += 2.2

	if(weight_state)
		if(weight_state == WEIGHT_LIGHT)
			tally += 0.4
		if(weight_state == WEIGHT_MEDIUM)
			tally += 0.8
		if(weight_state == WEIGHT_HEAVY)
			tally += 1.2

	if(shoes)
		tally += shoes.slowdown

	if(stamina_loss >= 75)
		tally += 2

//	if (bodytemperature < 283.222)
//		tally += (283.222 - bodytemperature) / 10 * 1.75

	if(mRun in mutations)
		tally = 0

	return tally

/proc/shouldTally(var/myDir, var/GoingToDir)//the older wasnt working
	if(myDir == NORTH)
		if(GoingToDir == SOUTH)
			return 0
		if(GoingToDir == NORTH)
			return 0
		else
			return 1
	if(myDir == SOUTH)
		if(GoingToDir == NORTH)
			return 0
		if(GoingToDir == SOUTH)
			return 0
		else
			return 1
	if(myDir == EAST)
		if(GoingToDir == WEST)
			return 0
		if(GoingToDir == EAST)
			return 0
		else
			return 1
	if(myDir == WEST)
		if(GoingToDir == EAST)
			return 0
		if(GoingToDir == WEST)
			return 0
		else
			return 1


/mob/living/carbon/human/Process_Spacemove(var/movement_dir = 0)
	//Can we act
	if(!canmove && !has_gravity(src))	return 0

	//Do we have a working jetpack
	if(istype(back, /obj/item/weapon/tank/jetpack) && isturf(loc)) //Second check is so you can't use a jetpack in a mech
		var/obj/item/weapon/tank/jetpack/J = back
		if((movement_dir || J.stabilization_on) && J.allow_thrust(0.01, src))
			return 1
	//Do we have working magboots
	if(istype(shoes, /obj/item/clothing/shoes/magboots))
		var/obj/item/clothing/shoes/magboots/B = shoes
		if((B.flags & NOSLIP) && istype(src.loc,/turf/simulated/floor)/* && (!has_gravity(src.loc))*/)
			return 1
	//If no working jetpack or magboots then use the other checks
	if(..())	return 1
	return 0


/mob/living/carbon/human/Process_Spaceslipping(var/prob_slip = 5)
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.
	if(stat)
		prob_slip = 0 // Changing this to zero to make it line up with the comment, and also, make more sense.
	if(istype(shoes) && shoes.negates_gravity())
		prob_slip = 0
	//Do we have magboots or such on if so no slip
	if(istype(shoes, /obj/item/clothing/shoes/magboots) && (shoes.flags & NOSLIP))
		prob_slip = 0

	//Check hands and mod slip
	if(!l_hand)	prob_slip -= 2
	else if(l_hand.w_class <= 2)	prob_slip -= 1
	if (!r_hand)	prob_slip -= 2
	else if(r_hand.w_class <= 2)	prob_slip -= 1

	prob_slip = round(prob_slip)
	return(prob_slip)

/mob/living/carbon/human/slip(var/s_amount, var/w_amount, var/obj/O, var/lube)
	if(isobj(shoes) && (shoes.flags&NOSLIP) && !(lube&GALOSHES_DONT_HELP))
		return 0
	.=..()

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!.)
		if(mob_negates_gravity())
			. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return shoes && shoes.negates_gravity()

/mob/living/carbon/human/Move(NewLoc, direct)
	if(clinged_turf)
		if(get_dist(src, clinged_turf) > 1)
			src.clinged_turf = null

	for(var/organ_name in list("l_foot","r_foot","l_leg","r_leg"))
		if(resting || lying || buckled){
			break;
		}
		var/datum/organ/external/E = get_organ(organ_name)
		if(!E || (E.status & ORGAN_DESTROYED) || !E.is_usable())
			to_chat(src, "YOU CAN'T MOVE!")
			src.mob_rest()
			return
		else if(E.status & ORGAN_BROKEN || !E.is_usable())
			to_chat(src, "YOU CAN'T MOVE!")
			src.mob_rest()
			return
	..()

	var/shallReset = 1
	if(loc:liquid)
		src?:loc?:liquid?:update_atoms()
		update_fluid_icon(loc:liquid:depth, loc:liquid:color)
		shallReset = 0
	if(istype(loc, /turf/simulated/floor/open))
		var/turf/simulated/floor/open/O = loc
		if(O:floorbelow:liquid)
			update_fluid_icon(O:floorbelow:liquid:depth, O:floorbelow:liquid:color)
			shallReset = 0
	if(shallReset)
		update_fluid_icon(0, null)

	update_flashlight()
	for(var/obj/item/weapon/grab/G in grabbed_by)
		if(G.assailant == G.affecting)
			continue
		if(lastDir)
			dir = lastDir
			return

	if(prob(1) && prob(1) && prob(50))
		if(src.belt && istype(src.belt, /obj/item/weapon/claymore))
			var/obj/item/weapon/claymore/C = src.belt
			src.drop_from_inventory(C)
		if(src.s_store && istype(src.s_store, /obj/item/weapon/claymore))
			var/obj/item/weapon/claymore/C = src.s_store
			src.drop_from_inventory(C)

	if(client && client.lfwbopen)
		if(!(/obj/machinery/lifeweb/control in view(1, src)))
			client.CloseLfwbC(0)

	if(src.combat_mode && src.combat_intent == I_DEFEND)
		adjustStaminaLoss(0.3)

	reset_view()
	if(legcuffed && !lying)
		if(prob(50))
			src.stumble(1,src.legcuffed)
	if(handcuffed && !lying)
		if(prob(1))
			src.stumble(1,src.handcuffed)
/*	if(lockpickingObj)
		lockpickingObj.LockBASEs.DestroyFAKE()*/
	if(shoes)
		if(!lying)
			if(loc == NewLoc)
				if(!has_gravity(loc))
					return
	if (src.football && src.football.owner == src)
		src.football.update_movement()
	if (buckled && istype(buckled, /obj/structure/stool/bed/chair/wheelchair))
		buckled.dir = src.dir
		buckled.forceMove(src.loc)
	if(sprinting)
		if(FAT in src.mutations)
			src.adjustStaminaLoss(rand(2,5))
		else
			src.adjustStaminaLoss(rand(1,3))
	if(weight_state == WEIGHT_MEDIUM)
		src.adjustStaminaLoss(1)
	if(weight_state == WEIGHT_HEAVY)
		src.adjustStaminaLoss(rand(1,2))
	var/datum/organ/external/head/E = get_organ("head")
	if(E && E.headwrenched)
		update_hair()
		update_inv_glasses()
		update_inv_head()
		update_body()
		UpdateDamageIcon()


/mob/living/carbon/human/proc/togglesprint() // If you call this proc outside of hotkeys or clicking the HUD button, I'll be disappointed in you.
	if(sprinting)
		src.sprint_icon.icon_state = "sprint0"
		src << 'sound/webbers/ui_toggleoff.ogg'
		sprinting = FALSE
	else
		src.sprint_icon.icon_state = "sprint1"
		src << 'sound/webbers/ui_toggle.ogg'
		sprinting = TRUE
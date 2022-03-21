//figado
/datum/organ/internal/liver
	name = "liver"
	parent_organ = "vitals"
	removed_type = /obj/item/weapon/reagent_containers/food/snacks/organ/liver

	process()

		..()

		if(is_bruised())
			if(prob(25))
				owner.emote("vomit")
		else if(is_broken())
			if(prob(25))
				owner.emote("vomit")

		if (germ_level > INFECTION_LEVEL_ONE)
			if(prob(1))
				owner << "\red Your skin itches."
		if (germ_level > INFECTION_LEVEL_TWO)
			if(prob(1))
				spawn owner.vomit()

		if(owner.life_tick % PROCESS_ACCURACY == 0)

			//High toxins levels are dangerous
			if(owner.getToxLoss() >= 60 && !owner.reagents.has_reagent("charcoal"))
				//Healthy liver suffers on its own
				if (src.damage < min_broken_damage)
					src.damage += 0.2 * PROCESS_ACCURACY
				//Damaged one shares the fun
				else
					var/datum/organ/internal/O = pick(owner.internal_organs)
					if(O)
						O.damage += 0.2  * PROCESS_ACCURACY

			//Detox can heal small amounts of damage
			if (src.damage && src.damage < src.min_bruised_damage && owner.reagents.has_reagent("charcoal"))
				src.damage -= 0.2 * PROCESS_ACCURACY

			if(src.damage < 0)
				src.damage = 0

			// Get the effectiveness of the liver.
			var/d_filter_effect = 3
			if(is_bruised())
				d_filter_effect -= 1
			if(is_broken())
				d_filter_effect -= 2

			// Do some reagent d_filtering/processing.
			for(var/datum/reagent/R in owner.reagents.reagent_list)
				// Damaged liver means some chemicals are very dangerous
				// The liver is also responsible for clearing out alcohol and toxins.
				// Ethanol and all drinks are bad.K
				if(istype(R, /datum/reagent/ethanol))
					if(d_filter_effect < 3)
						owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
					owner.reagents.remove_reagent(R.id, R.metabolization_rate*d_filter_effect)
				// Can't cope with toxins at all
				else if(istype(R, /datum/reagent/toxin))
					if(d_filter_effect < 3)
						owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)
					owner.reagents.remove_reagent(R.id, REAGENTS_METABOLISM*d_filter_effect)

/datum/organ/internal/liver/mechanize()
	new /datum/organ/internal/liver/robotic(owner)
	return

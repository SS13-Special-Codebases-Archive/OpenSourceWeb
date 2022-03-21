//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!
#define HUMAN_MAX_OXYLOSS 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
#define HUMAN_CRIT_MAX_OXYLOSS ( (last_tick_duration) /5) //The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 100HP to get through, so (1/3)*last_tick_duration per second. Breaths however only happen every 4 ticks.

#define HEAT_DAMAGE_LEVEL_1 3 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 6 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 9 //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 3.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 5 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 3 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 6 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 9 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 3.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 5 //Amount of damage applied when the current breath's temperature passes the 120K point

#define RADIATION_SPEED_COEFFICIENT 0.1

#define FIRE_DAMAGE 20

/mob/living/carbon/human
	var/oxygen_alert = 0
	var/plasma_alert = 0
	var/co2_alert = 0
	var/fire_alert = 0
	var/pressure_alert = 0
	var/prev_gender = null // Debug for plural genders
	var/temperature_alert = 0
	var/in_stasis = 0


/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = 1

	if (monkeyizing)	return
	if(!loc)			return	// Fixing a null error that occurs when the mob isn't found in the world -- TLE

	..()

	/*
	//This code is here to try to determine what causes the gender switch to plural error. Once the error is tracked down and fixed, this code should be deleted
	//Also delete var/prev_gender once this is removed.
	if(prev_gender != gender)
		prev_gender = gender
		if(gender in list(PLURAL, NEUTER))
			message_admins("[src] ([ckey]) gender has been changed to plural or neuter. Please record what has happened recently to the person and then notify coders. (<A HREF='?_src_=holder;adminmoreinfo=\ref[src]'>?</A>)  (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?priv_msg=\ref[src]'>PM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[src]'>JMP</A>)")
	*/
	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	blinded = null
	fire_alert = 0 //Reset this here, because both breathe() and handle_environment() have a chance to set it.
	emote_cooldown = max(emote_cooldown - 1, 0)
	if(erpcooldown > 1)
		erpcooldown -= rand(1,2)
	//GAMBIARRACODING TALVEZ NAO FUNFE!!
	if(!can_stand && !buckled)
		src.resting = TRUE
		src.lying = TRUE
	if(istype(src.amulet, /obj/item/clothing/head/amulet/breaker))
		src.resting = TRUE
		src.lying = TRUE
		src.canmove = FALSE
	//TODO: seperate this out
	// update the current life tick, can be used to e.g. only do something every 4 ticks
	life_tick++
	var/datum/gas_mixture/environment = loc.return_air()

	in_stasis = istype(loc, /obj/structure/closet/body_bag/cryobag) && loc:opened == 0
	if(in_stasis) loc:used++

	voice = GetVoice()

	handle_zombify()

	update_fire()

	check_kg()

	if(species?.name == "Zombie" || species?.name == "Skeleton")
		reagents.add_reagent("tramadol", 30)
		if(prob(20))
			emote(pick("z_roar","z_shout","z_mutter"))
	//if(src.throwing == 0 && istype(src.loc, /turf/simulated/floor/open)) // PUTA QUE PARIU THUX

	if(mind && mind.special_role == "Waker")
		if(stat != DEAD)
			halloss = 0
			setHalLoss(0)

	if(hasalpha)
		if(isturf(loc))
			var/turf/T = src.loc
			if(T.get_lumcount() <= 0.2)
				return
			alpha = 255
			hasalpha = 0

	if(april_fools)
		if(prob(25))
			playsound(src.loc, pick('worm_speech3.ogg','worm_speech2.ogg', 'worm_speech1.ogg', 'worm_speech4.ogg'), 60, 0, -1)

	if(src.species && src.species.name == "Alien")
		stamina_loss = 0
		overlay_fullscreen("ghost", /obj/screen/fullscreen/screamer_overlay, 3)
		for(var/mob/living/carbon/human/H in view(7, src))
			if(src?.loc?:luminosity && !H?.StingerSeen?.Find(src))
				H.StingerSeen.Add(src)
				playsound(H, pick('alien_encounter.ogg','alien_encounter2.ogg'), 60, 1)

	handle_knock()

	pain_handler()

	update_surgery()

	if(beingaimedby) // it used to lag and never go out i odnt know why
		spawn(10 SECONDS)
			if(beingaimedby)
				beingaimedby = null
				src.remove_aim()

	if(istype(buckled, /mob/living/carbon/human))
		var/mob/living/carbon/human/A = buckled

		if(A.lying || A.stat)
			src.buckled = null
			src.update_canmove()
			src = null

			src.mob_rest()

	if(!stat && stat != DEAD)
		stat = 0
		blinded = FALSE
	else if(stat && stat != DEAD)
		stat = 1
		blinded = TRUE

	if(!sleeping && stat != DEAD)
		stat = 0

	//No need to update all of these procs if the guy is dead.
	if(stat != DEAD && !in_stasis)

		//Updates the number of stored chemicals for powers
		handle_changeling()

		handle_dreamer() // Ele skippa se nao for dreamer

		if(isVampire)
			handle_vampire()
/*
		if(client && master_mode == "holywar" || client && master_mode == "minimig")
			update_all_team_icons()

		if(client && issiege && siegesoldier)
			update_all_siege_icons()

		if(client && iszombie(src))
			update_all_zombie_icons()
*/
		//Mutations and radiation
		handle_mutations_and_radiation()

		//Chemicals in the body
		handle_chemicals_in_body()

		//Disabilities
		handle_disabilities()

		//Random events (vomiting etc)
		handle_random_events()

		handle_virus_updates()

		//stuff in the stomach
		handle_stomach()

		updateshock()

		handle_lust()

		handle_pain()

		my_stats.spd = (my_stats.dx + my_stats.ht) / 4


		if(nutrition_icon)
			nutrition_icon.overlays.Cut()
			var/image/I = new('icons/life/screen1.dmi', "V[disgust_level]")
			if(disgust_level >= 10)
				src.vomit()
				disgust_level = 9
			disgust_level = max(0, disgust_level-1)
			nutrition_icon.overlays.Add(I)

		handle_medical_side_effects()

		handle_vice()
		if(Lifewebbed)
			if(job != "Mortus" && job != "Archmortus")
				blur()

		handle_reflect()

		if(dizziness & slurring)
			var/image/drunk = image('icons/mob/mob.dmi', "drunk")
			if(dizziness >= 1 || slurring >= 1)
				overlays += drunk
			else
				overlays -= drunk

		CheckStamina()

		if(bodytemperature <= 180.505)
			if(prob((40-src.my_stats.im) / 2))
				src.contract_disease(new /datum/disease/cold,1,0)

		//update_fov_check()
		if(special == "weirdgait")
			if(!facing_dir)
				set_face_dir()

/*		if(special == "scaredark")
			var/turf/T = src.loc
			if(T.get_lumcount() < LIGHTING_SOFT_THRESHOLD)
				if(prob(80))
					rotate_plane()
				if(prob(35))
					to_chat(src, "<span class='bname'>TOO DARK!!!</span>")
*/
		if(client && mind)
			if(ismonster(src) || iszombie(src) || isVampire || src.mind.changeling)
				mood_icon.icon_state = "pressure-1"
		//DESATIVADO POR SER INSTAVEL
		//CheckChemsBuff()

		if(ear_deaf && !deaf_loop)
			sound_to(src, sound('sound/effects/ear_ring.ogg', repeat = 1, wait = 0, volume = 35, channel = 4))
			deaf_loop = TRUE

		if(!ear_deaf)
			sound_to(src, sound(null, repeat = 1, wait = 0, volume = 70, channel = 4))
			deaf_loop = FALSE

	if(stat == DEAD || iszombie(src))
		time_since_death += 2
		handle_decay()

	handle_stasis_bag()

	handle_statuses()

	//Check if we're on fire
	handle_fire()

	//handle_drowning()

	//Tirar pain dos orgao
	handle_painLW()

	//Handle temperature/pressure differences between body and environment
	handle_environment(environment)

	//Status updates, death etc.
	UpdateLuminosity()
	handle_regular_status_updates()		//TODO: optimise ~Carn
	update_canmove()

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	handle_regular_hud_updates()

	handle_blood_pools()

	handle_cripple()

	pulse = handle_pulse()

	prepareLeave()
	// Grabbing
	if(grabbed_by.len)
		for(var/obj/item/weapon/grab/G in src)
			G.process()

	if(druggy)
		if(prob(2))
			to_chat(src, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>[pick("OH OH OH!", "OH [capitalize(god_text())]!", "ARGH!", "GOODNESS GRACIOUS!")]</span>")

	if(iszombie(src))
//		if(healths)		healths.icon_state = "health7"	//DEAD healthmeter
		sight |= SEE_MOBS
		see_invisible = 15
		see_in_dark = 100
		halloss = 0
		setHalLoss(0)


		blinded = 0
		sleeping = 0
		src.reagents.add_reagent("dentrine",3000)
		overlay_fullscreen("ghost", /obj/screen/fullscreen/screamer_overlay, 3)

	if(istype(src?.species, /datum/species/human/alien))
//		if(healths)		healths.icon_state = "health7"	//DEAD healthmeter
		sight |= SEE_MOBS
		see_invisible = 15
		see_in_dark = 100
		halloss = 0
		setHalLoss(0)


		blinded = 0
		sleeping = 0
		overlay_fullscreen("ghost", /obj/screen/fullscreen/screamer_overlay, 3)


	if(isskeleton(src))
		see_invisible = 15
		see_in_dark = 100
		halloss = 0
		setHalLoss(0)

		src.reagents.add_reagent("dentrine",3000)
		overlay_fullscreen("ghost", /obj/screen/fullscreen/screamer_overlay, 3)

	if(src.isVampire && src.DeadEyes)
		see_invisible = 15
		see_in_dark = 100


// Calculate how vulnerable the human is to under- and overpressure.
// Returns 0 (equals 0 %) if sealed in an undamaged suit, 1 if unprotected (equals 100%).
// Suitdamage can modifiy this in 10% steps.
/mob/living/carbon/human/proc/get_pressure_weakness()

	var/pressure_adjustment_coefficient = 1 // Assume no protection at first.

	if(wear_suit && (wear_suit.flags & STOPSPRESSUREDMAGE) && head && (head.flags & STOPSPRESSUREDMAGE)) // Complete set of pressure-proof suit worn, assume fully sealed.
		pressure_adjustment_coefficient = 0

		// Handles breaches in your space suit. 10 suit damage equals a 100% loss of pressure protection.
		if(istype(wear_suit,/obj/item/clothing/suit/space))
			var/obj/item/clothing/suit/space/S = wear_suit
			if(S.can_breach && S.damage)
				pressure_adjustment_coefficient += S.damage * 0.1

	pressure_adjustment_coefficient = min(1,max(pressure_adjustment_coefficient,0)) // So it isn't less than 0 or larger than 1.

	return pressure_adjustment_coefficient

// Calculate how much of the enviroment pressure-difference affects the human.
/mob/living/carbon/human/calculate_affecting_pressure(var/pressure)
	var/pressure_difference

	// First get the absolute pressure difference.
	if(pressure < ONE_ATMOSPHERE) // We are in an underpressure.
		pressure_difference = ONE_ATMOSPHERE - pressure

	else //We are in an overpressure or standard atmosphere.
		pressure_difference = pressure - ONE_ATMOSPHERE

	if(pressure_difference < 5) // If the difference is small, don't bother calculating the fraction.
		pressure_difference = 0

	else
		// Otherwise calculate how much of that absolute pressure difference affects us, can be 0 to 1 (equals 0% to 100%).
		// This is our relative difference.
		pressure_difference *= get_pressure_weakness()

	// The difference is always positive to avoid extra calculations.
	// Apply the relative difference on a standard atmosphere to get the final result.
	// The return value will be the adjusted_pressure of the human that is the basis of pressure warnings and damage.
	if(pressure < ONE_ATMOSPHERE)
		return ONE_ATMOSPHERE - pressure_difference
	else
		return ONE_ATMOSPHERE + pressure_difference

/mob/living/carbon/human

	proc/handle_disabilities()
		if(iszombie(src))
			return
		if (disabilities & EPILEPSY)
			if ((prob(1) && paralysis < 1))
				src << "\red You have a seizure!"
				for(var/mob/O in viewers(src, null))
					if(O == src)
						continue
					O.show_message(text("\red <B>[src] starts having a seizure!"), 1)
				Paralyse(10)
				Jitter(1000)
		if (disabilities & COUGHING)
			if ((prob(5) && paralysis <= 1))
				drop_item()
				spawn( 0 )
					emote("cough")
					return
		if (disabilities & TOURETTES)
			speech_problem_flag = 1
			if ((prob(10) && paralysis <= 1))
				Stun(10)
				spawn( 0 )
					switch(rand(1, 3))
						if(1)
							visible_message("<span class='combatbold'>[src]</span><span class='combat'>twitches.</span>")
						if(2 to 3)
							say("[prob(50) ? ";" : ""][pick("�����", "�����", "�����", "���", "������", "�����", "������", "��ب� �����", "����Ψ��", "����", "������", "��� ������", "������� ������", "��� �����", "�� ����� ���")]")
					var/old_x = pixel_x
					var/old_y = pixel_y
					pixel_x += rand(-2,2)
					pixel_y += rand(-1,1)
					sleep(2)
					pixel_x = old_x
					pixel_y = old_y
					return
		if (disabilities & NERVOUS)
			speech_problem_flag = 1
			if (prob(10))
				stuttering = max(10, stuttering)
		// No. -- cib
		/*if (getBrainLoss() >= 60 && stat != 2)
			if (prob(3))
				switch(pick(1,2,3))
					if(1)
						say(pick("IM A PONY NEEEEEEIIIIIIIIIGH", "without oxigen blob don't evoluate?", "CAPTAINS A COMDOM", "[pick("", "that faggot traitor")] [pick("joerge", "george", "gorge", "gdoruge")] [pick("mellens", "melons", "mwrlins")] is grifing me HAL;P!!!", "can u give me [pick("telikesis","halk","eppilapse")]?", "THe saiyans screwed", "Bi is THE BEST OF BOTH WORLDS>", "I WANNA PET TEH monkeyS", "stop grifing me!!!!", "SOTP IT#"))
					if(2)
						say(pick("FUS RO DAH","fucking 4rries!", "stat me", ">my face", "roll it easy!", "waaaaaagh!!!", "red wonz go fasta", "FOR TEH EMPRAH", "lol2cat", "dem dwarfs man, dem dwarfs", "SPESS MAHREENS", "hwee did eet fhor khayosss", "lifelike texture ;_;", "luv can bloooom", "PACKETS!!!"))
					if(3)
						emote("drool")
		*/

		if(stat != 2)
			var/rn = rand(0, 200)
			if(getBrainLoss() >= 5)
				if(0 <= rn && rn <= 3)
					custom_pain("Your head feels numb and painful.")
			if(getBrainLoss() >= 15)
				if(4 <= rn && rn <= 6) if(eye_blurry <= 0)
					src << "\red It becomes hard to see for some reason."
					eye_blurry = 10
			if(getBrainLoss() >= 35)
				if(7 <= rn && rn <= 9) if(hand && equipped())
					src << "\red Your hand won't respond properly, you drop what you're holding."
					drop_item()
			if(getBrainLoss() >= 50)
				if(10 <= rn && rn <= 12) if(!lying)
					src << "\red Your legs won't respond properly, you fall down."
					resting = 1

	proc/handle_stasis_bag()
		// Handle side effects from stasis bag
		if(in_stasis)
			// First off, there's no oxygen supply, so the mob will slowly take brain damage
			adjustBrainLoss(0.1)

			// Next, the method to induce stasis has some adverse side-effects, manifesting
			// as cloneloss
			adjustCloneLoss(0.1)

	proc/handle_mutations_and_radiation()

		if(iszombie(src))
			druggy = 0
			weakened = 0
			paralysis = 0
			oxyloss = 0
			if(l_hand)
				if(!istype(l_hand, /obj/item/weapon/grab))
					drop_from_inventory(l_hand)
			if(r_hand)
				if(!istype(r_hand, /obj/item/weapon/grab))
					drop_from_inventory(r_hand)

			return
		if(istype(src?.species, /datum/species/human/alien))
			druggy = 0
			weakened = 0
			paralysis = 0
			oxyloss = 0
			if(l_hand)
				if(!istype(l_hand, /obj/item/weapon/grab))
					drop_from_inventory(l_hand)
			if(r_hand)
				if(!istype(r_hand, /obj/item/weapon/grab))
					drop_from_inventory(r_hand)
			return

		if(species && species?.flags & IS_SYNTHETIC) //Robots don't suffer from mutations or radloss.
			return

		if(getFireLoss())
			if((COLD_RESISTANCE in mutations) || (prob(1)))
				heal_organ_damage(0,1)

		// DNA2 - Gene processing.
		// The HULK stuff that was here is now in the hulk gene.
		for(var/datum/dna/gene/gene in dna_genes)
			if(!gene.block)
				continue
			if(gene.is_active(src))
				speech_problem_flag = 1
				gene.OnMobLife(src)

		radiation = Clamp(radiation,0,100)

		if (radiation)
			var/datum/organ/internal/diona/nutrients/rad_organ = locate() in internal_organs
			if(rad_organ && !rad_organ.is_broken())
				var/rads = radiation/25
				radiation -= rads
				nutrition += rads
				adjustBruteLoss(-(rads))
				adjustOxyLoss(-(rads))
				adjustToxLoss(-(rads))
				updatehealth()
				return

			var/damage = 0
			radiation -= 1 * RADIATION_SPEED_COEFFICIENT
			if(prob(25))
				damage = 1

			if (radiation > 50)
				damage = 1
				radiation -= 1 * RADIATION_SPEED_COEFFICIENT
				if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT))
					radiation -= 5 * RADIATION_SPEED_COEFFICIENT
					src << "<span class='warning'>You feel weak.</span>"
					Weaken(3)
					if(!lying)
						emote("collapse")
				if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT) && species?.name == "Human") //apes go bald
					if((h_style != "Bald" || f_style != "Shaved" ))
						src << "<span class='warning'>Your hair falls out.</span>"
						h_style = "Bald"
						f_style = "Shaved"
						update_hair()

			if (radiation > 75)
				radiation -= 1 * RADIATION_SPEED_COEFFICIENT
				damage = 3
				if(prob(5))
					take_overall_damage(0, 5 * RADIATION_SPEED_COEFFICIENT, used_weapon = "Radiation Burns")
				if(prob(1))
					src << "<span class='warning'>You feel strange!</span>"
					adjustCloneLoss(5 * RADIATION_SPEED_COEFFICIENT)
					emote("gasp")

			if(damage)
				adjustToxLoss(damage * RADIATION_SPEED_COEFFICIENT)
				updatehealth()
				if(organs.len)
					var/datum/organ/external/O = pick(organs)
					if(istype(O)) O.add_autopsy_data("Radiation Poisoning", damage)
	proc/breathe()
		if(reagents.has_reagent("lexorin")) return
		if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell)) return
		if(species && (species?.flags & NO_BREATHE || species?.flags & IS_SYNTHETIC)) return

		var/datum/gas_mixture/environment = loc.return_air()
		var/datum/gas_mixture/breath

		// HACK NEED CHANGING LATER
		if(death_door && !reagents.has_reagent("epinephrine"))
			losebreath++

		if(!in_stasis) // MASK BREATH SOUND EFFECT, REMOVE IF ERROR
			handle_gas_mask_sound()
			..()

		if(losebreath>0) //Suffocating so do not take a breath
			losebreath--
			if (prob(10)) //Gasp per 10 ticks? Sounds about right.
				spawn emote("gasp")
			if(istype(loc, /obj/))
				var/obj/location_as_object = loc
				location_as_object.handle_internal_lifeform(src, 0)
		else
			//First, check for air from internal atmosphere (using an air tank and mask generally)
			breath = get_breath_from_internal(BREATH_VOLUME) // Super hacky -- TLE
			//breath = get_breath_from_internal(0.5) // Manually setting to old BREATH_VOLUME amount -- TLE

			//No breath from internal atmosphere so get breath from location
			if(!breath)
				if(isobj(loc))
					var/obj/location_as_object = loc
					breath = location_as_object.handle_internal_lifeform(src, BREATH_MOLES)
				else if(isturf(loc))
					var/breath_moles = 0
					/*if(environment.return_pressure() > ONE_ATMOSPHERE)
						// Loads of air around (pressure effect will be handled elsewhere), so lets just take a enough to fill our lungs at normal atmos pressure (using n = Pv/RT)
						breath_moles = (ONE_ATMOSPHERE*BREATH_VOLUME/R_IDEAL_GAS_EQUATION*environment.temperature)
					else*/
						// Not enough air around, take a percentage of what's there to model this properly
					breath_moles = environment.total_moles*BREATH_PERCENTAGE

					breath = loc.remove_air(breath_moles)

					if(istype(wear_mask, /obj/item/clothing/mask) && breath)
						var/obj/item/clothing/mask/M = wear_mask
						var/datum/gas_mixture/d_filtered = M.d_filter_air(breath)
						loc.assume_air(d_filtered)

					if(!is_lung_ruptured())
						if(!breath || breath.total_moles < BREATH_MOLES / 5 || breath.total_moles > BREATH_MOLES * 5)
							if(prob(5))
								rupture_lung()

					// Handle d_filtering
					var/block = 0
					if(wear_mask)
						if(wear_mask.flags & BLOCK_GAS_SMOKE_EFFECT)
							block = 1
					if(glasses)
						if(glasses.flags & BLOCK_GAS_SMOKE_EFFECT)
							block = 1
					if(head)
						if(head.flags & BLOCK_GAS_SMOKE_EFFECT)
							block = 1

					if(!block)

						for(var/obj/effect/effect/smoke/chem/smoke in view(1, src))
							if(smoke.reagents.total_volume)
								smoke.reagents.reaction(src, INGEST)
								spawn(5)
									if(smoke)
										smoke.reagents.copy_to(src, 10) // I dunno, maybe the reagents enter the blood stream through the lungs?
								break // If they breathe in the nasty stuff once, no need to continue checking

			else //Still give containing object the chance to interact
				if(istype(loc, /obj/))
					var/obj/location_as_object = loc
					location_as_object.handle_internal_lifeform(src, 0)

		handle_breath(breath)

		if(breath)
			loc.assume_air(breath)

			//spread some viruses while we are at it
			if (virus2.len > 0)
				if (prob(10) && get_infection_chance(src))
//					log_debug("[src] : Exhaling some viruses")
					for(var/mob/living/carbon/M in view(1,src))
						src.spread_disease_to(M)


	proc/get_breath_from_internal(volume_needed)
		if(internal)
			if (!contents.Find(internal))
				internal = null
			if (!wear_mask || !(wear_mask.flags & MASKINTERNALS) )
				internal = null
			if(internal)
				return internal.remove_air_volume(volume_needed)
			else if(internals)
				internals.icon_state = "internal0"
		return null


	proc/handle_breath(datum/gas_mixture/breath)
		if(status_flags & GODMODE)
			return
		if(mNobreath in src.mutations)
			return
		if(src.holding_breath)
			adjustOxyLoss(0.1)
			failed_last_breath = 1
			oxygen_alert = max(oxygen_alert, 1)
			return
		/*
		if(can_drown() && loc.is_flooded(lying))
			adjustOxyLoss(4)//If you are suiciding, you should die a little bit faster
			failed_last_breath = 1
			oxygen_alert = max(oxygen_alert, 1)
			if(prob(40))
				to_chat(src, "I CAN'T BREATHE!")
			return 0
		*/
		if(src.my_stats.it <= 1)
			adjustOxyLoss(4)//If you are suiciding, you should die a little bit faster
			failed_last_breath = 1
			oxygen_alert = max(oxygen_alert, 1)
			if(prob(40))
				to_chat(src, "HOW DO I BREATHE?!")
			return 0
		if(!breath || (breath.total_moles == 0) || suiciding)
			if(suiciding)
				adjustOxyLoss(2)//If you are suiciding, you should die a little bit faster
				failed_last_breath = 1
				oxygen_alert = max(oxygen_alert, 1)
				return 0
			if(!death_door)
				adjustOxyLoss(HUMAN_MAX_OXYLOSS)
				failed_last_breath = 1
			else
				adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)
				failed_last_breath = 1

			oxygen_alert = max(oxygen_alert, 1)

			return 0

		var/safe_pressure_min = 16 // Minimum safe partial pressure of breathable gas in kPa

		// Lung damage increases the minimum safe pressure.
		if(species && species?.has_organ["lungs"])
			var/datum/organ/internal/lungs/L = internal_organs_by_name["lungs"]
			if(!L)
				safe_pressure_min = INFINITY //No lungs, how are you breathing?
			else if(L.is_broken())
				safe_pressure_min *= 1.5
			else if(L.is_bruised())
				safe_pressure_min *= 1.25

		var/safe_exhaled_max = 10
		var/safe_toxins_max = 0.005
		var/SA_para_min = 1
		var/SA_sleep_min = 5
		var/inhaled_gas_used = 0

		var/breath_pressure = (breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

		var/inhaling
		var/poison
		var/exhaling

		var/breath_type
		var/poison_type
		var/exhale_type

		var/failed_inhale = 0
		var/failed_exhale = 0

		if(species)
			if(species?.breath_type)
				breath_type = species?.breath_type
		else
			breath_type = "oxygen"
		inhaling = breath.gas[breath_type]

		if(species?.poison_type)
			poison_type = species?.poison_type
		else
			poison_type = "plasma"
		poison = breath.gas[poison_type]

		if(species?.exhale_type)
			exhale_type = species?.exhale_type
			exhaling = breath.gas[exhale_type]
		else
			exhaling = 0

		var/inhale_pp = (inhaling/breath.total_moles)*breath_pressure
		var/toxins_pp = (poison/breath.total_moles)*breath_pressure
		var/exhaled_pp = (exhaling/breath.total_moles)*breath_pressure

		// Not enough to breathe
		if(inhale_pp < safe_pressure_min)
			if(prob(20))
				spawn(0) emote("gasp")

			var/ratio = inhale_pp/safe_pressure_min
			// Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!)
			adjustOxyLoss(max(HUMAN_MAX_OXYLOSS*(1-ratio), 0))
			failed_inhale = 1

			oxygen_alert = max(oxygen_alert, 1)
		else
			// We're in safe limits
			oxygen_alert = 0

		inhaled_gas_used = inhaling/6

		breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards

		if(exhale_type)
			breath.adjust_gas_temp(exhale_type, inhaled_gas_used, bodytemperature, update = 0) //update afterwards

			// Too much exhaled gas in the air
			if(exhaled_pp > safe_exhaled_max)
				if (!co2_alert|| prob(15))
					var/word = pick("extremely dizzy","short of breath","faint","confused")
					src << "<span class='danger'>You feel [word].</span>"

				adjustOxyLoss(HUMAN_MAX_OXYLOSS)
				co2_alert = 1
				failed_exhale = 1

			else if(exhaled_pp > safe_exhaled_max * 0.7)
				if (!co2_alert || prob(1))
					var/word = pick("dizzy","short of breath","faint","momentarily confused")
					src << "<span class='warning>You feel [word].</span>"

				//scale linearly from 0 to 1 between safe_exhaled_max and safe_exhaled_max*0.7
				var/ratio = 1.0 - (safe_exhaled_max - exhaled_pp)/(safe_exhaled_max*0.3)

				//give them some oxyloss, up to the limit - we don't want people falling unconcious due to CO2 alone until they're pretty close to safe_exhaled_max.
				if (getOxyLoss() < 50*ratio)
					adjustOxyLoss(HUMAN_MAX_OXYLOSS)
				co2_alert = 1
				failed_exhale = 1

			else if(exhaled_pp > safe_exhaled_max * 0.6)
				if (prob(0.3))
					var/word = pick("a little dizzy","short of breath")
					src << "<span class='warning>You feel [word].</span>"

			else
				co2_alert = 0

		// Too much poison in the air.
		if(toxins_pp > safe_toxins_max)
			var/ratio = (poison/safe_toxins_max) * 10
			if(reagents)
				reagents.add_reagent("toxin", Clamp(ratio, MIN_TOXIN_DAMAGE, MAX_TOXIN_DAMAGE))
				breath.adjust_gas(poison_type, -poison/6, update = 0) //update after
			plasma_alert = max(plasma_alert, 1)
		else
			plasma_alert = 0

		// If there's some other shit in the air lets deal with it here.
		if(breath.gas["sleeping_agent"])
			var/SA_pp = (breath.gas["sleeping_agent"] / breath.total_moles) * breath_pressure

			// Enough to make us paralysed for a bit
			if(SA_pp > SA_para_min)

				// 3 gives them one second to wake up and run away a bit!
				Paralyse(3)

				// Enough to make us sleep as well
				if(SA_pp > SA_sleep_min)
					sleeping = min(sleeping+2, 10)

			// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
			else if(SA_pp > 0.15)
				if(prob(20))
					spawn(0) emote(pick("giggle", "laugh"))
			breath.adjust_gas("sleeping_agent", -breath.gas["sleeping_agent"]/6, update = 0) //update after

		// Were we able to breathe?
		if (failed_inhale || failed_exhale)
			failed_last_breath = 1
		else
			failed_last_breath = 0
			adjustOxyLoss(-5)

		// Hot air hurts :(
		if( (breath.temperature < species?.cold_level_1 || breath.temperature > species?.heat_level_1) && !(COLD_RESISTANCE in mutations))

			if(breath.temperature < species?.cold_level_1)
				if(prob(20))
					src << "<span class='danger'>You feel your face freezing and icicles forming in your lungs!</span>"
			else if(breath.temperature > species?.heat_level_1)
				if(prob(20))
					src << "<span class='danger'>You feel your face burning and a searing heat in your lungs!</span>"

			switch(breath.temperature)
				if(-INFINITY to species?.cold_level_3)
					apply_damage(COLD_GAS_DAMAGE_LEVEL_3, BURN, "head", used_weapon = "Excessive Cold")
					fire_alert = max(fire_alert, 1)
				if(species?.cold_level_3 to species?.cold_level_2)
					apply_damage(COLD_GAS_DAMAGE_LEVEL_2, BURN, "head", used_weapon = "Excessive Cold")
					fire_alert = max(fire_alert, 1)
				if(species?.cold_level_2 to species?.cold_level_1)
					apply_damage(COLD_GAS_DAMAGE_LEVEL_1, BURN, "head", used_weapon = "Excessive Cold")
					fire_alert = max(fire_alert, 1)
				if(species?.heat_level_1 to species?.heat_level_2)
					apply_damage(HEAT_GAS_DAMAGE_LEVEL_1, BURN, "head", used_weapon = "Excessive Heat")
					fire_alert = max(fire_alert, 2)
				if(species?.heat_level_2 to species?.heat_level_3)
					apply_damage(HEAT_GAS_DAMAGE_LEVEL_2, BURN, "head", used_weapon = "Excessive Heat")
					fire_alert = max(fire_alert, 2)
				if(species?.heat_level_3 to INFINITY)
					apply_damage(HEAT_GAS_DAMAGE_LEVEL_3, BURN, "head", used_weapon = "Excessive Heat")
					fire_alert = max(fire_alert, 2)

			//breathing in hot/cold air also heats/cools you a bit
			var/temp_adj = breath.temperature - bodytemperature
			if (temp_adj < 0)
				temp_adj /= (BODYTEMP_COLD_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed
			else
				temp_adj /= (BODYTEMP_HEAT_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed

			var/relative_density = breath.total_moles / (MOLES_CELLSTANDARD * BREATH_PERCENTAGE)
			temp_adj *= relative_density

			if (temp_adj > BODYTEMP_HEATING_MAX) temp_adj = BODYTEMP_HEATING_MAX
			if (temp_adj < BODYTEMP_COOLING_MAX) temp_adj = BODYTEMP_COOLING_MAX
			//world << "Breath: [breath.temperature], [src]: [bodytemperature], Adjusting: [temp_adj]"
			bodytemperature += temp_adj


		breath.update_values()
		return 1

	proc/handle_environment(datum/gas_mixture/environment)

		if(!environment)
			return

		//Stuff like the xenomorph's plasma regen happens here.
		species?.handle_environment_special(src)

		//Moved pressure calculations here for use in skip-processing check.
		var/pressure = environment.return_pressure()
		var/adjusted_pressure = calculate_affecting_pressure(pressure)

		//Check for contaminants before anything else because we don't want to skip it.
		for(var/g in environment.gas)
			if(gas_data.flags[g] & XGM_GAS_CONTAMINANT && environment.gas[g] > gas_data.overlay_limit[g] + 1)
				pl_effects()
				break

		if(!on_fire)
			var/loc_temp = T0C
			if(istype(loc, /obj/mecha))
				var/obj/mecha/M = loc
				loc_temp =  M.return_temperature()
			else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
				loc_temp = loc:air_contents.temperature
			else
				loc_temp = environment.temperature

			if(adjusted_pressure < species?.warning_high_pressure && adjusted_pressure > species?.warning_low_pressure && abs(loc_temp - bodytemperature) < 20 && bodytemperature < species?.heat_level_1 && bodytemperature > species?.cold_level_1)
				pressure_alert = 0
				return // Temperatures are within normal ranges, fuck all this processing. ~Ccomp

			//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection
			var/temp_adj = 0
			if(loc_temp < bodytemperature)			//Place is colder than we are
				var/thermal_protection = get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
				if(thermal_protection < 1)
					temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR)	//this will be negative
			else if (loc_temp > bodytemperature)			//Place is hotter than we are
				var/thermal_protection = get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
				if(thermal_protection < 1)
					temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)

			//Use heat transfer as proportional to the gas density. However, we only care about the relative density vs standard 101 kPa/20 C air. Therefore we can use mole ratios
			var/relative_density = environment.total_moles / MOLES_CELLSTANDARD
			temp_adj *= relative_density

			if (temp_adj > BODYTEMP_HEATING_MAX) temp_adj = BODYTEMP_HEATING_MAX
			if (temp_adj < BODYTEMP_COOLING_MAX) temp_adj = BODYTEMP_COOLING_MAX

//			world << "Environment: [loc_temp], [src]: [bodytemperature], Adjusting: [temp_adj]"

			bodytemperature += temp_adj
		if(on_fire)
			take_overall_damage(0, FIRE_DAMAGE, 0, 0, used_weapon = "FIRE")
		// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
		if(bodytemperature > species?.heat_level_1)
			//Body temperature is too hot.
			fire_alert = max(fire_alert, 1)
			if(status_flags & GODMODE)	return 1	//godmode
			switch(bodytemperature)
				if(species?.heat_level_1 to species?.heat_level_2)
					take_overall_damage(0, HEAT_DAMAGE_LEVEL_1, 0, 0, used_weapon = "High Body Temperature")
					fire_alert = max(fire_alert, 2)
				if(species?.heat_level_2 to species?.heat_level_3)
					take_overall_damage(0, HEAT_DAMAGE_LEVEL_2, 0, 0, used_weapon = "High Body Temperature")
					fire_alert = max(fire_alert, 2)
				if(species?.heat_level_3 to INFINITY)
					take_overall_damage(0, HEAT_DAMAGE_LEVEL_3, 0, 0, used_weapon = "High Body Temperature")
					fire_alert = max(fire_alert, 2)

		else if(bodytemperature < species?.cold_level_1)
			fire_alert = max(fire_alert, 1)
			if(status_flags & GODMODE)	return 1	//godmode
			if(!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
				switch(bodytemperature)
					if(species?.cold_level_2 to species?.cold_level_1)
						take_overall_damage(0, COLD_DAMAGE_LEVEL_1, 0, 0, used_weapon = "Low Body Temperature")
						fire_alert = max(fire_alert, 1)
					if(species?.cold_level_3 to species?.cold_level_2)
						take_overall_damage(0, COLD_DAMAGE_LEVEL_2, 0, 0, used_weapon = "Low Body Temperature")
						fire_alert = max(fire_alert, 1)
					if(-INFINITY to species?.cold_level_3)
						take_overall_damage(0, COLD_DAMAGE_LEVEL_3, 0, 0, used_weapon = "Low Body Temperature")
						fire_alert = max(fire_alert, 1)

		// Account for massive pressure differences.  Done by Polymorph
		// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!
		if(status_flags & GODMODE)	return 1	//godmode

		if(species && adjusted_pressure >= species?.hazard_high_pressure)
			var/pressure_damage = min( ( (adjusted_pressure / species?.hazard_high_pressure) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE)
			take_overall_damage(brute=pressure_damage, used_weapon = "High Pressure")
			pressure_alert = 2
		else if(adjusted_pressure >= species?.warning_high_pressure)
			pressure_alert = 1
		else if(adjusted_pressure >= species?.warning_low_pressure)
			pressure_alert = 0
		else if(adjusted_pressure >= species?.hazard_low_pressure)
			pressure_alert = -1
		else
			if( !(COLD_RESISTANCE in mutations))
				take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")
				if(getOxyLoss() < 55) // 11 OxyLoss per 4 ticks when wearing internals;    unconsciousness in 16 ticks, roughly half a minute
					adjustOxyLoss(4)  // 16 OxyLoss per 4 ticks when no internals present; unconsciousness in 13 ticks, roughly twenty seconds
				pressure_alert = -2
			else
				pressure_alert = -1

		return

///FIRE CODE
	handle_fire()
		if(..())
			return
		var/thermal_protection = get_heat_protection(30000) //If you don't have fire suit level protection, you get a temperature increase
		if((1 - thermal_protection) > 0.0001)
			bodytemperature += BODYTEMP_HEATING_MAX
		return
//END FIRE CODE

	/*
	proc/adjust_body_temperature(current, loc_temp, boost)
		var/temperature = current
		var/difference = abs(current-loc_temp)	//get difference
		var/increments// = difference/10			//find how many increments apart they are
		if(difference > 50)
			increments = difference/5
		else
			increments = difference/10
		var/change = increments*boost	// Get the amount to change by (x per increment)
		var/temp_change
		if(current < loc_temp)
			temperature = min(loc_temp, temperature+change)
		else if(current > loc_temp)
			temperature = max(loc_temp, temperature-change)
		temp_change = (temperature - current)
		return temp_change
	*/

	proc/stabilize_temperature_from_calories()
		var/body_temperature_difference = 310.15 - bodytemperature
		if (abs(body_temperature_difference) < 0.01)
			return //fuck this precision
		switch(bodytemperature)
			if(-INFINITY to 260.15) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
				if(nutrition >= 2) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
					nutrition -= 1
					hidratacao -= 2
				var/recovery_amt = max((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
//				log_debug("Cold. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
				bodytemperature += recovery_amt
			if(260.15 to 360.15)
				var/recovery_amt = body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
//				log_debug("Norm. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
				bodytemperature += recovery_amt
			if(360.15 to INFINITY) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
				//We totally need a sweat system cause it totally makes sense...~
				var/recovery_amt = min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers
//				log_debug("Hot. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
				bodytemperature += recovery_amt

	//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, UPPER_TORSO, LOWER_TORSO, etc. See setup.dm for the full list)
	proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
		var/thermal_protection_flags = 0
		//Handle normal clothing
		if(head)
			if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= head.heat_protection
		if(wear_suit)
			if(wear_suit.max_heat_protection_temperature && wear_suit.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= wear_suit.heat_protection
		if(w_uniform)
			if(w_uniform.max_heat_protection_temperature && w_uniform.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= w_uniform.heat_protection
		if(shoes)
			if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= shoes.heat_protection
		if(gloves)
			if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= gloves.heat_protection
		if(wear_mask)
			if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= wear_mask.heat_protection

		return thermal_protection_flags

	proc/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
		var/thermal_protection_flags = get_heat_protection_flags(temperature)

		var/thermal_protection = 0.0
		if(thermal_protection_flags)
			if(thermal_protection_flags & HEAD)
				thermal_protection += THERMAL_PROTECTION_HEAD
			if(thermal_protection_flags & UPPER_TORSO)
				thermal_protection += THERMAL_PROTECTION_UPPER_TORSO
			if(thermal_protection_flags & LOWER_TORSO)
				thermal_protection += THERMAL_PROTECTION_LOWER_TORSO
			if(thermal_protection_flags & LEG_LEFT)
				thermal_protection += THERMAL_PROTECTION_LEG_LEFT
			if(thermal_protection_flags & LEG_RIGHT)
				thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
			if(thermal_protection_flags & FOOT_LEFT)
				thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
			if(thermal_protection_flags & FOOT_RIGHT)
				thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
			if(thermal_protection_flags & ARM_LEFT)
				thermal_protection += THERMAL_PROTECTION_ARM_LEFT
			if(thermal_protection_flags & ARM_RIGHT)
				thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
			if(thermal_protection_flags & HAND_LEFT)
				thermal_protection += THERMAL_PROTECTION_HAND_LEFT
			if(thermal_protection_flags & HAND_RIGHT)
				thermal_protection += THERMAL_PROTECTION_HAND_RIGHT


		return min(1,thermal_protection)

	//See proc/get_heat_protection_flags(temperature) for the description of this proc.
	proc/get_cold_protection_flags(temperature)
		var/thermal_protection_flags = 0
		//Handle normal clothing

		if(head)
			if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= head.cold_protection
		if(wear_suit)
			if(wear_suit.min_cold_protection_temperature && wear_suit.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= wear_suit.cold_protection
		if(w_uniform)
			if(w_uniform.min_cold_protection_temperature && w_uniform.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= w_uniform.cold_protection
		if(shoes)
			if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= shoes.cold_protection
		if(gloves)
			if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= gloves.cold_protection
		if(wear_mask)
			if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= wear_mask.cold_protection

		return thermal_protection_flags

	proc/get_cold_protection(temperature)

		if(COLD_RESISTANCE in mutations)
			return 1 //Fully protected from the cold.

		temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
		var/thermal_protection_flags = get_cold_protection_flags(temperature)

		var/thermal_protection = 0.0
		if(thermal_protection_flags)
			if(thermal_protection_flags & HEAD)
				thermal_protection += THERMAL_PROTECTION_HEAD
			if(thermal_protection_flags & UPPER_TORSO)
				thermal_protection += THERMAL_PROTECTION_UPPER_TORSO
			if(thermal_protection_flags & LOWER_TORSO)
				thermal_protection += THERMAL_PROTECTION_LOWER_TORSO
			if(thermal_protection_flags & LEG_LEFT)
				thermal_protection += THERMAL_PROTECTION_LEG_LEFT
			if(thermal_protection_flags & LEG_RIGHT)
				thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
			if(thermal_protection_flags & FOOT_LEFT)
				thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
			if(thermal_protection_flags & FOOT_RIGHT)
				thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
			if(thermal_protection_flags & ARM_LEFT)
				thermal_protection += THERMAL_PROTECTION_ARM_LEFT
			if(thermal_protection_flags & ARM_RIGHT)
				thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
			if(thermal_protection_flags & HAND_LEFT)
				thermal_protection += THERMAL_PROTECTION_HAND_LEFT
			if(thermal_protection_flags & HAND_RIGHT)
				thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

		return min(1,thermal_protection)

	/*
	proc/add_fire_protection(var/temp)
		var/fire_prot = 0
		if(head)
			if(head.protective_temperature > temp)
				fire_prot += (head.protective_temperature/10)
		if(wear_mask)
			if(wear_mask.protective_temperature > temp)
				fire_prot += (wear_mask.protective_temperature/10)
		if(glasses)
			if(glasses.protective_temperature > temp)
				fire_prot += (glasses.protective_temperature/10)
		if(ears)
			if(ears.protective_temperature > temp)
				fire_prot += (ears.protective_temperature/10)
		if(wear_suit)
			if(wear_suit.protective_temperature > temp)
				fire_prot += (wear_suit.protective_temperature/10)
		if(w_uniform)
			if(w_uniform.protective_temperature > temp)
				fire_prot += (w_uniform.protective_temperature/10)
		if(gloves)
			if(gloves.protective_temperature > temp)
				fire_prot += (gloves.protective_temperature/10)
		if(shoes)
			if(shoes.protective_temperature > temp)
				fire_prot += (shoes.protective_temperature/10)

		return fire_prot

	proc/handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
		if(nodamage)
			return
		//world <<"body_part = [body_part], exposed_temperature = [exposed_temperature], exposed_intensity = [exposed_intensity]"
		var/discomfort = min(abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)

		if(exposed_temperature > bodytemperature)
			discomfort *= 4

		if(mutantrace == "plant")
			discomfort *= TEMPERATURE_DAMAGE_COEFFICIENT * 2 //I don't like magic numbers. I'll make mutantraces a datum with vars sometime later. -- Urist
		else
			discomfort *= TEMPERATURE_DAMAGE_COEFFICIENT //Dangercon 2011 - now with less magic numbers!
		//world <<"[discomfort]"

		switch(body_part)
			if(HEAD)
				apply_damage(2.5*discomfort, BURN, "head")
			if(UPPER_TORSO)
				apply_damage(2.5*discomfort, BURN, "chest")
			if(LEGS)
				apply_damage(0.6*discomfort, BURN, "l_leg")
				apply_damage(0.6*discomfort, BURN, "r_leg")
			if(ARMS)
				apply_damage(0.4*discomfort, BURN, "l_arm")
				apply_damage(0.4*discomfort, BURN, "r_arm")
	*/

	proc/handle_chemicals_in_body()

		if(reagents && !(species && species?.flags & IS_SYNTHETIC)) //Synths don't process reagents.
			var/alien = 0 //Not the best way to handle it, but neater than checking this for every single reagent proc.
			if(species && species?.name == "Diona")
				alien = 1
			else if(species && species?.name == "Vox")
				alien = 2
			reagents.metabolize(src,alien)

		var/total_plasmaloss = 0
		for(var/obj/item/I in src)
			if(I.contaminated)
				total_plasmaloss += vsc.plc.CONTAMINATION_LOSS
		if(status_flags & GODMODE)	return 0	//godmode
		adjustToxLoss(total_plasmaloss)

		// nutrition decrease
		if (nutrition > 0 && stat != 2 && !iszombie(src) && !isVampire)
			nutrition = max (0, nutrition - HUNGER_FACTOR)

		if (hidratacao > 0 && stat != 2 && !iszombie(src) && !isVampire)
			hidratacao = max (0, hidratacao - THIRST_FACTOR)




		if (drowsyness)
/*			var/image/drunk = image('icons/mob/mob.dmi', "drunk")
			if(drowsyness >= 1)
				overlays += drunk
			else
				overlays -= drunk*/
			drowsyness--
			eye_blurry = max(2, eye_blurry)
			if (prob(5))
				sleeping += 1
				Paralyse(5)

		confused = max(0, confused - 1)
		// decrement dizziness counter, clamped to 0
		if(resting)
			dizziness = max(0, dizziness - 15)
			jitteriness = max(0, jitteriness - 15)
		else
			dizziness = max(0, dizziness - 8)
			jitteriness = max(0, jitteriness - 3)

		if(!(species?.flags & IS_SYNTHETIC)) handle_trace_chems()

		updatehealth()
		CheckStamina()
		handle_sprint()
		handle_happiness()
		handle_hygiene()

		return //TODO: DEFERRED

	proc/handle_regular_status_updates()
		if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
			silent = 0
		else				//ALIVE. LIGHTS ARE ON
			updatehealth()	//TODO
			if(!in_stasis)
				handle_organs(0)
				handle_blood()
				if(isVampire)
					src.vessel.remove_reagent("blood",0.4)

			if((species && species?.has_organ["brain"] && !has_brain()))
				if(!iszombie(src))
					death()
					silent = 0
					return 1
				else if((species?.has_organ["brain"] && !has_brain()))
					death()
					silent = 0
					return 1
			// the analgesic effect wears off slowly
			analgesic = max(0, analgesic - 1)

			if(halloss > 100)
				if(species && species?.flags && NO_PAIN) return
				if(status_flags & STATUS_NO_PAIN) return
				if(is_dreamer(src)) return
				if(src.consyte) return
				to_chat(src, "<span class='malfunction'>You're in too much pain to keep going...</span>")
				visible_message("<span class='combatbold'>[src]</span> <span class='combat'>gives in to pain!</span>", 1)
				call_sound_emote("agonypain")
				Weaken(8)
				setHalLoss(99)

			//UNCONSCIOUS. NO-ONE IS HOME
			if( (getOxyLoss() > 50) || ((death_door) && (!zombie)) )
				Paralyse(3)

				/* Done by handle_breath()
				if( health <= 20 && prob(1) )
					spawn(0)
						emote("gasp")
				if(!reagents.has_reagent("epinephrine"))
					adjustOxyLoss(1)*/

			if(hallucination)
				if(hallucination >= 20)
					if(prob(3))
						fake_attack(src)
					if(!handling_hal)
						spawn handle_hallucinations() //The not boring kind!

				if(hallucination<=2)
					hallucination = 0
					halloss = 0
				else
					hallucination -= 2

			else
				for(var/atom/a in hallucinations)
					if(client && mind && mind.special_role != "Waker")
						del a
			if(paralysis)
				AdjustParalysis(-1)
				blinded = 1
				stat = UNCONSCIOUS
				if(halloss > 0)
					adjustHalLoss(-3)
			else if(sleeping)
				speech_problem_flag = 1
				handle_dreams()
				if(tryingtosleep || death_door)
					adjustHalLoss(-3)
					adjustToxLoss(-1)
				if (mind)
					if((mind.active && client != null) || immune_to_ssd) //This also checks whether a client is connected, if not, sleep is not reduced.
						//sleeping = max(sleeping-1, 0)
						if(tryingtosleep)
							sleeping = 5
						else
							AdjustSleeping(-1)
				blinded = 1
				stat = UNCONSCIOUS
				if( prob(2) && health && !hal_crit )
					spawn(2)
						emote("snore")
			else if(resting)
				if(halloss > 0)
					adjustHalLoss(-3)
			//CONSCIOUS
			else
				stat = CONSCIOUS
				if(halloss > 0)
					adjustHalLoss(-1)

			if(embedded_flag && !(life_tick % 10))
				var/list/E
				E = get_visible_implants(0)
				if(!E.len)
					embedded_flag = 0

			//Eyes
			if(!species?.has_organ["eyes"]) // Presumably if a species has no eyes, they see via something else.
				eye_blind =  0
				blinded =    0
				eye_blurry = 0
			else if(!has_eyes() && (species && species?.name != "Skeleton"))           // Eyes cut out? Permablind.
				eye_blind =  1
				blinded =    1
				eye_blurry = 1
			else if(sdisabilities & BLIND)	//disabled-blind, doesn't get better on its own
				blinded = 1
			else if(eye_blind)			//blindness, heals slowly over time
				eye_blind = max(eye_blind-1,0)
				blinded = 1
			else if(istype(glasses, /obj/item/clothing/glasses/sunglasses/blindfold))	//resting your eyes with a blindfold heals blurry eyes faster
				eye_blurry = max(eye_blurry-3, 0)
				blinded = 1
			else if( istype(head, /obj/item/clothing/head/blackbag))
				eye_blurry = max(eye_blurry-3, 0)
				blinded = 1
			else if(eye_blurry)	//blurry eyes heal slowly
				eye_blurry = max(eye_blurry-1, 0)

			//Ears
			if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
				ear_deaf = max(ear_deaf, 1)
			else if(ear_deaf)			//deafness, heals slowly over time
				ear_deaf = max(ear_deaf-1, 0)
			else if(istype(l_ear, /obj/item/clothing/ears/earmuffs) || istype(r_ear, /obj/item/clothing/ears/earmuffs))	//resting your ears with earmuffs heals ear damage faster
				ear_damage = max(ear_damage-0.15, 0)
				ear_deaf = max(ear_deaf, 1)
			else if(ear_damage < 25)	//ear damage heals slowly under this threshold. otherwise you'll need earmuffs
				ear_damage = max(ear_damage-0.05, 0)

			//Other
			//handle_statuses() //DESCOMENTAR SE DAR ERRADO RESIDENT SLEEPER

			// Increase germ_level regularly
			if(prob(40))
				germ_level += 1
			// If you're dirty, your gloves will become dirty, too.
			if(gloves && germ_level > gloves.germ_level && prob(10))
				gloves.germ_level += 1
		return 1

	proc/handle_regular_hud_updates()
		if(!client)	return 0

		for(var/image/hud in client.images)
			if(copytext(hud.icon_state,1,4) == "hud") //ugly, but icon comparison is worse, I believe
				client.images.Remove(hud)

		client.screen.Remove(global_hud.blurry, global_hud.druggy, global_hud.vimpaired, global_hud.darkMask, global_hud.g_dither, global_hud.r_dither, global_hud.gray_dither, global_hud.lp_dither)

		update_action_buttons()

		if(damageoverlay)
			if(damageoverlay.overlays)
				damageoverlay.overlays = list()

		if (rest && rest.icon_state)
			rest.icon_state = "rest[resting]"

		if(nutrition_icon)
			nutrition_icon.overlays.Cut()
			var/image/I = new('icons/life/screen1.dmi', "V[disgust_level]")
			if(disgust_level >= 10)
				src.vomit()
				disgust_level = 9
			disgust_level = max(0, disgust_level-1)
			nutrition_icon.overlays.Add(I)

		if(stat == UNCONSCIOUS)
			//Critical damage passage overlay
			//if(health <= 0)
				//var/image/I
				//I = null
/*
				switch(health)
					if(-20 to -10)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage1")
					if(-30 to -20)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage2")
					if(-40 to -30)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage3")
					if(-50 to -40)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage4")
					if(-60 to -50)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage5")
					if(-70 to -60)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage6")
					if(-80 to -70)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage7")
					if(-90 to -80)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage8")
					if(-95 to -90)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage9")
					if(-INFINITY to -95)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage10")*/

		//else
			//Oxygen damage overlay
			//if(oxyloss)
				//var/image/I
				//I = null
/*
				switch(oxyloss)
					if(10 to 20)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay1")
					if(20 to 25)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay2")
					if(25 to 30)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay3")
					if(30 to 35)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay4")
					if(35 to 40)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay5")
					if(40 to 45)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay6")
					if(45 to INFINITY)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay7")
*/

			//Fire and Brute damage overlay (BSSR)
			var/hurtdamage = src.getBruteLoss() + src.getFireLoss() + damageoverlaytemp
			damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
			if(hurtdamage)
				var/image/I
				if(species && species?.flags & NO_PAIN) return
				switch(hurtdamage)
//					if(10 to 25)
//						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay1")
/*
					if(10 to 40)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay2")
					if(40 to 55)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay3")
					if(55 to 70)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay4")
					if(70 to 85)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay5")
					if(85 to INFINITY)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay6")
*/
					if(35 to 40)
						I = image("icon" = 'icons/mob/screen1_full2.dmi', "icon_state" = "brutedamageoverlay2")
					if(40 to 55)
						I = image("icon" = 'icons/mob/screen1_full2.dmi', "icon_state" = "brutedamageoverlay3")
					if(55 to 70)
						I = image("icon" = 'icons/mob/screen1_full2.dmi', "icon_state" = "brutedamageoverlay4")
					if(70 to 85)
						I = image("icon" = 'icons/mob/screen1_full2.dmi', "icon_state" = "brutedamageoverlay5")
					if(85 to INFINITY)
						I = image("icon" = 'icons/mob/screen1_full2.dmi', "icon_state" = "brutedamageoverlay6")
				damageoverlay.overlays += I

		if(stamina_ui)
			if(isVampire)
				var/blood_volume = round(src:vessel.get_reagent_amount("blood"))
				var/blood_percent =  blood_volume / 560
				blood_percent *= 100
				stamina_ui.name = "Blood Bar"
				switch(blood_percent)
					if(95 to INFINITY)	stamina_ui.icon_state = "v12"
					if(90 to 95)	stamina_ui.icon_state = "v11"
					if(85 to 90)	stamina_ui.icon_state = "v10"
					if(75 to 85)	stamina_ui.icon_state = "v9"
					if(65 to 75)	stamina_ui.icon_state = "v8"
					if(55 to 65)	stamina_ui.icon_state = "v7"
					if(45 to 55)	stamina_ui.icon_state = "v6"
					if(35 to 45)	stamina_ui.icon_state = "v5"
					if(25 to 35)	stamina_ui.icon_state = "v4"
					if(15 to 25)	stamina_ui.icon_state = "v3"
					if(10 to 15)	stamina_ui.icon_state = "v2"
					if( 5 to 10)	stamina_ui.icon_state = "v1"
					if( 0 to 5)		stamina_ui.icon_state = "v0"
			else
				switch(stamina_loss)
					if(100 to INFINITY)		stamina_ui.icon_state = "stamina0"
					if(90 to 100)			stamina_ui.icon_state = "stamina1"
					if(80 to 90)			stamina_ui.icon_state = "stamina2"
					if(70 to 80)			stamina_ui.icon_state = "stamina3"
					if(60 to 70)			stamina_ui.icon_state = "stamina4"
					if(50 to 60)			stamina_ui.icon_state = "stamina5"
					if(40 to 50)			stamina_ui.icon_state = "stamina6"
					if(30 to 40)			stamina_ui.icon_state = "stamina7"
					if(20 to 30)			stamina_ui.icon_state = "stamina8"
					if(10 to 20)			stamina_ui.icon_state = "stamina9"
					else					stamina_ui.icon_state = "stamina10"

			if(stamina_cap && stamina_cap <= 16)
				var/image/I = image(stamina_ui.icon, icon_state = "overfatigue[stamina_cap]")
				stamina_ui.overlays = list(I)
			else
				stamina_ui.overlays = list()

		if( stat == DEAD )
			see_in_dark = 8
			if(!druggy)		see_invisible = SEE_INVISIBLE_LEVEL_TWO
			if(healths)		healths.icon_state = "health7"	//DEAD healthmeter
/*			if(client)
				if(client.view != world.view)
					if(locate(/obj/item/weapon/gun/energy/sniperrifle, contents))
						var/obj/item/weapon/gun/energy/sniperrifle/s = locate() in src
						if(s.zoom)
							s.zoom()*/

		else
			sight &= ~(SEE_TURFS|SEE_MOBS|SEE_OBJS)
			see_in_dark = species?.darksight
			see_invisible = see_in_dark>2 ? SEE_INVISIBLE_LEVEL_ONE : SEE_INVISIBLE_LIVING

			if(XRAY in mutations)
				sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
				see_in_dark = 8
				if(!druggy)		see_invisible = SEE_INVISIBLE_LEVEL_TWO

			if(iszombie(src))
//				if(healths)		healths.icon_state = "health7"	//DEAD healthmeter
				sight |= SEE_MOBS
				see_in_dark = 4

			if(src.ishunting)
				sight |= SEE_MOBS
				if(prob(5))
					sight &= ~SEE_MOBS
					ishunting = 0

			if(glasses)
				var/obj/item/clothing/glasses/G = glasses
				if(istype(G))
					see_in_dark += G.darkness_view
					if(G.vision_flags)
						sight |= G.vision_flags
						if(!druggy)
							see_invisible = SEE_INVISIBLE_MINIMUM

	/* HUD shit goes here, as long as it doesn't modify sight flags */
	// The purpose of this is to stop xray and w/e from preventing you from using huds -- Love, Doohl

				if(istype(glasses, /obj/item/clothing/glasses/sunglasses/sechud))
					var/obj/item/clothing/glasses/sunglasses/sechud/O = glasses
					if(O.hud)		O.hud.process_hud(src)
					if(!druggy)		see_invisible = SEE_INVISIBLE_LIVING
				else if(istype(glasses, /obj/item/clothing/glasses/hud))
					var/obj/item/clothing/glasses/hud/O = glasses
					O.process_hud(src)
					if(!druggy)
						see_invisible = SEE_INVISIBLE_LIVING

			else if(!seer)
				see_invisible = SEE_INVISIBLE_LIVING

			if(healths)
				if(reagents.has_reagent("dentrine") || reagents.has_reagent("morphine") || reagents.has_reagent("heroin") || reagents.has_reagent("oxycodone") || (status_flags & STATUS_NO_PAIN && !isVampire))
					if(src.gender == FEMALE)
						healths.icon_state = "fhealthd"
					else
						healths.icon_state = "healthd"
				else
					switch(hal_screwyhud)
						if(1)	healths.icon_state = "health6"
						if(2)	healths.icon_state = "health7"
						else
							//switch(health - halloss)
							if(src.gender == FEMALE)
								if(death_door)
									healths.icon_state = "fhealthx"
								if(isVampire)
									healths.icon_state = "health7"
								else
									switch(100 - ((species && species?.flags & NO_PAIN & !IS_SYNTHETIC) ? 0 : choque))
										if(100 to INFINITY)		healths.icon_state = "fhealth0"
										if(80 to 100)			healths.icon_state = "fhealth1"
										if(60 to 80)			healths.icon_state = "fhealth2"
										if(40 to 60)			healths.icon_state = "fhealth3"
										if(20 to 40)			healths.icon_state = "fhealth4"
										if(0 to 20)				healths.icon_state = "fhealth5"
										else					healths.icon_state = "fhealth6"
							else
								if(isVampire)
									healths.icon_state = "health7"
								if(death_door)
									healths.icon_state = "healthx"
								else
									switch(100 - ((species && species?.flags & NO_PAIN & !IS_SYNTHETIC) ? 0 : choque))
										if(100 to INFINITY)		healths.icon_state = "health0"
										if(80 to 100)			healths.icon_state = "health1"
										if(60 to 80)			healths.icon_state = "health2"
										if(40 to 60)			healths.icon_state = "health3"
										if(20 to 40)			healths.icon_state = "health4"
										if(0 to 20)				healths.icon_state = "health5"
										else					healths.icon_state = "health6"
				if(iszombie(src) || zombie)
					if(src.gender == FEMALE)
						healths.icon_state = "fhealth7"
					else
						healths.icon_state = "health7"

			if(nutrition_icon)
				if(isVampire)
					nutrition_icon.icon_state = "hunger2"
				else
					switch(nutrition)
						if(450 to INFINITY)				nutrition_icon.icon_state = "hunger0"
						if(350 to 450)					nutrition_icon.icon_state = "hunger0"
						if(250 to 350)					nutrition_icon.icon_state = "hunger1"
						if(150 to 250)					nutrition_icon.icon_state = "hunger1"
						else							nutrition_icon.icon_state = "hunger1"
				if(mind?.alien)
					if(world.time > (mind?.alien?.last_egg + EGG_DELAY))
						nutrition_icon.icon_state = "hunger1"
					else
						nutrition_icon.icon_state = "hunger0"


			if(awake)
				if(sleeping == 0 && stat == 0)
					if(awake.icon_state != "sleep0")
						if(gender == FEMALE)
							emote("opens her eyes.")
						else
							emote("opens his eyes.")
						eye_closed = 0
					awake.icon_state = "sleep0"
					awake.overlays.Cut()
					if(eye_closed == TRUE)
						awake.overlays += image('icons/life/screen1.dmi', "eyeso")
				else
					if(!tryingtosleep)
						awake.icon_state = "sleep2"
						awake.overlays.Cut()
						awake.overlays += image('icons/life/screen1.dmi', "eyeso")
					else
						if(sleeping >= 2 || stat != 0 || eye_closed)
							if(awake.icon_state != "sleep1")
								if(gender == FEMALE)
									emote("closes her eyes.")
								else
									emote("closes his eyes.")

							awake.icon_state = "sleep1"
							awake.overlays.Cut()
							awake.overlays += image('icons/life/screen1.dmi', "eyeso")

			if(pressure)
				pressure.icon_state = "pressure[pressure_alert]"

			if(pullin)
				if(pulling)								pullin.icon_state = "pull1"
				else									pullin.icon_state = "pull0"
//			if(rest)	//Not used with new UI
//				if(resting || lying || sleeping)		rest.icon_state = "rest1"
//				else									rest.icon_state = "rest0"
			if(toxin)
				if(hal_screwyhud == 4 || plasma_alert)	toxin.icon_state = "tox1"
				else									toxin.icon_state = "tox0"
			if(oxygen)
				if(hal_screwyhud == 3 || oxygen_alert)	oxygen.icon_state = "oxy1"
				else									oxygen.icon_state = "oxy0"
			if(fire)
				if(fire_alert)							fire.icon_state = "fire[fire_alert]" //fire_alert is either 0 if no alert, 1 for cold and 2 for heat.
				else									fire.icon_state = "fire0"

			if(bodytemp)
				switch(bodytemperature) //310.055 optimal body temp
					if(370 to INFINITY)		bodytemp.icon_state = "temp4"
					if(350 to 370)			bodytemp.icon_state = "temp3"
					if(335 to 350)			bodytemp.icon_state = "temp2"
					if(320 to 335)			bodytemp.icon_state = "temp1"
					if(300 to 320)			bodytemp.icon_state = "temp0"
					if(295 to 300)			bodytemp.icon_state = "temp-1"
					if(280 to 295)			bodytemp.icon_state = "temp-2"
					if(260 to 280)			bodytemp.icon_state = "temp-3"
					else					bodytemp.icon_state = "temp-4"

			if(blind)
				if(blinded || eye_closed || sleeping || stat == UNCONSCIOUS || eye_blind)
					client?.screen += global_hud?.blind//blind.layer = 18
				else
					client?.screen -= global_hud?.blind//blind.layer = 0


			handle_hud_vision()
			if(disabilities & NEARSIGHTED)	//this looks meh but saves a lot of memory by not requiring to add var/prescription
				if(glasses)					//to every /obj/item
					var/obj/item/clothing/glasses/G = glasses
					if(!G.prescription)
						client.screen += global_hud.vimpaired
					else
						client.screen -= global_hud.vimpaired
				else
					client.screen += global_hud.vimpaired

			if(eye_blurry)			client.screen += global_hud.blurry
			if(druggy)				client.screen += global_hud.druggy

			var/masked = 0

			if( istype(head, /obj/item/clothing/head/welding) || istype(head, /obj/item/clothing/head/helmet/space/unathi))
				var/obj/item/clothing/head/welding/O = head
				if(!O.up && tinted_weldhelh)
					client.screen += global_hud.darkMask
					masked = 1

			if(!masked && istype(glasses, /obj/item/clothing/glasses/welding) )
				var/obj/item/clothing/glasses/welding/O = glasses
				if(!O.up && tinted_weldhelh)
					client.screen += global_hud.darkMask

			if((istype(wear_mask, /obj/item/clothing/mask/gas) && !istype(wear_mask, /obj/item/clothing/mask/gas/swat) && !istype(wear_mask, /obj/item/clothing/mask/gas/syndicate)) || istype(glasses, /obj/item/clothing/glasses/night))
				client.screen += global_hud.g_dither
				for(var/obj/I in client?.usingPlanes)


					if(istype(I, /obj/blur_planemaster)) continue
					I.add_filter("bloom", 12, list("type" = "bloom", size=2, offset=0,alpha=255))
			else
				for(var/obj/I in client?.usingPlanes)


					if(istype(I, /obj/blur_planemaster)) continue
					I.remove_filter("bloom")

			if ((istype(glasses, /obj/item/clothing/glasses/thermal) && !istype(glasses, /obj/item/clothing/glasses/thermal/syndi)) || istype(glasses, /obj/item/clothing/glasses/hud/security) || istype(wear_mask, /obj/item/clothing/mask/gas/swat) || istype(wear_mask, /obj/item/clothing/mask/gas/syndicate))
				client.screen += global_hud.r_dither

			if (istype(glasses, /obj/item/clothing/glasses/sunglasses) || istype(head, /obj/item/clothing/head/helmet/riot))
				client.screen += global_hud.gray_dither

			if (istype(glasses, /obj/item/clothing/glasses/meson) || istype(glasses, /obj/item/clothing/glasses/thermal/syndi))
				client.screen += global_hud.lp_dither


			if(machine)
				if(!machine.check_eye(src))		reset_view(null)
			else
				var/isRemoteObserve = 0
				if((mRemote in mutations) && remoteview_target)
					if(remoteview_target.stat==CONSCIOUS)
						isRemoteObserve = 1
				if(!looking_up && !isRemoteObserve && client && !client.adminobs)
					remoteview_target = null
					reset_view(null)
		return 1

	proc/handle_random_events()
		// Puke if toxloss is too high
		if(!stat)
			if (getToxLoss() >= 45 && nutrition > 20)
				vomit()

		if(istype(head, /obj/item/clothing/head/helmet/soulbreaker) && religion != "Allah")
			src.rotate_plane()

		//0.1% chance of playing a scary sound to someone who's in complete darkness
//		if(isturf(loc) && rand(1,1000) == 1)
//			var/turf/currentTurf = loc
//			if(!currentTurf.lighting_lumcount)
//				playsound_local(src,pick(scarySounds),50, 1, -1)

	proc/handle_virus_updates()
		if(status_flags & GODMODE)	return 0	//godmode
		if(bodytemperature > 406)
			for(var/datum/disease/D in viruses)
				D.cure()
			for (var/ID in virus2)
				var/datum/disease2/disease/V = virus2[ID]
				V.cure(src)

		for(var/obj/effect/decal/cleanable/blood/B in view(1,src))
			if(B && B.virus2 && !isnull(B.virus2) && length(B.virus2))
				for (var/ID in B?.virus2)
					var/datum/disease2/disease/V = B?.virus2[ID]
					infect_virus2(src,V)

		for(var/obj/effect/decal/cleanable/mucus/M in view(1,src))
			if(M.virus2.len)
				for (var/ID in M.virus2)
					var/datum/disease2/disease/V = M.virus2[ID]
					infect_virus2(src,V)

		for (var/ID in virus2)
			var/datum/disease2/disease/V = virus2[ID]
			if(isnull(V)) // Trying to figure out a runtime error that keeps repeating
				CRASH("virus2 nulled before calling activate()")
			else
				V.activate(src)
			// activate may have deleted the virus
			if(!V) continue

			// check if we're immune
			if(V.antigen & src.antibodies)
				V.dead = 1

		return

	proc/handle_stomach()
		spawn(0)
			var/datum/organ/internal/stomach/Stomach = src.internal_organs_by_name[pick("stomach")]
			if(Stomach)
				for(var/mob/living/M in Stomach.stomach_contents)
					if(M.loc != src)
						Stomach.stomach_contents.Remove(M)
						continue
					if(istype(M, /mob/living/carbon) && stat != 2)
						if(M.stat == 2)
							M.death(1)
							Stomach.stomach_contents.Remove(M)
							qdel(M)
							continue
						if(air_master.current_cycle%3==1)
							if(!(M.status_flags & GODMODE))
								M.adjustBruteLoss(5)
							nutrition += 10
		handle_excrement()

		if(hidratacao > THIRST_LEVEL_MEDIUM)
			clear_event("thirst")

		if(hidratacao < THIRST_LEVEL_MEDIUM)
			switch(hidratacao)
				if(THIRST_LEVEL_THIRSTY to THIRST_LEVEL_MEDIUM)
					add_event("thirst", /datum/happiness_event/nutrition/bitthirsty)
					if(prob(2))
						to_chat(src, "<span class='hungerasterisks'>*</span><span class='hunger'><i>I'm a bit thirsty.</i></span><span class='hungerasterisks'>*</span>")
				if(150 to THIRST_LEVEL_THIRSTY)
					add_event("thirst", /datum/happiness_event/nutrition/thirsty)
					if(prob(2))
						to_chat(src, "<span class='hungerasterisks'>*</span><span class='hunger'><i>I'm thirsty.</i></span><span class='hungerasterisks'>*</span>")
				if(150 to THIRST_LEVEL_DEHYDRATED)

					if(prob(2))
						to_chat(src, "<span class='hungerasterisks'>*</span><span class='hunger'><i>I'm **REALLY** thirsty.</i></span><span class='hungerasterisks'>*</span>")

					else if(prob(2) && prob(10)) //5% chance of being weakened

						Weaken(1)
						to_chat(src, "<span class='hungerasterisks'>*</span><span class='hunger'><i>I can't stand this thirst...</i></span><span class='hungerasterisks'>*</span>")

				if(THIRST_LEVEL_DEHYDRATED to -INFINITY)
					add_event("thirst", /datum/happiness_event/nutrition/dehydrated)

					if(prob(5))
						to_chat(src, "<span class='hungerasterisks'>*</span><span class='hunger'><i>You are extremely thirsty.</i></span><span class='hungerasterisks'>*</span>")
						//Weaken(2)
					if(prob(4) && prob(10))
						src.sleeping += 3

		if(nutrition > 275 && !iszombie(src) && !isVampire)
			clear_event("hunger")

		if(nutrition < 400 && !iszombie(src) && !isVampire)
			clear_event("stuffed")

		if(nutrition < 275 && !iszombie(src) && !isVampire) //Nutrition is below 100 = starvation
			//When you're starving, the rate at which oxygen damage is healed is reduced by 80% (you only restore 1 oxygen damage per life tick, instead of 5)

			switch(nutrition)
				if(400 to 550)
					add_event("stuffed", /datum/happiness_event/nutrition/wellfed)

				if(220 to 275)
					add_event("hunger", /datum/happiness_event/nutrition/bithungry)
					if(sleeping) return

					if(prob(2))
						to_chat(src, "<span class='hungerasterisks'>*</span><span class='hunger'><i>You're a bit hungry.</i></span><span class='hungerasterisks'>*</span>")
				if(150 to 220) //60-80
					add_event("hunger", /datum/happiness_event/nutrition/bithungry)
					if(sleeping) return

					if(prob(2))
						to_chat(src, "<span class='hungerasterisks'>*</span><span class='hunger'><i>You feel hunger.</i></span><span class='hungerasterisks'>*</span>")
						playsound(src, pick('hungry1.ogg','hungry2.ogg','hungry3.ogg','hungry4.ogg'), 40, 1, -5)
				if(100 to 150) //30-60
					add_event("hunger", /datum/happiness_event/nutrition/hungry)
					if(sleeping) return

					if(prob(2))
						to_chat(src, "<span class='hungerasterisks'>*</span><span class='hunger'><i>You feel really hungry.</i></span><span class='hungerasterisks'>*</span>")
						if(prob(45))
							playsound(src, pick('hungry1.ogg','hungry2.ogg','hungry3.ogg','hungry4.ogg'), 40, 1, -5)

					else if(prob(2) && prob(10)) //5% chance of being weakened

						if(prob(45))
							playsound(src, pick('hungry1.ogg','hungry2.ogg','hungry3.ogg','hungry4.ogg'), 40, 1, -5)
						if(prob(10))
							Weaken(2)
							src.sleeping += 3
						to_chat(src, "<span class='hungerasterisks'>*</span><span class='hunger'><i>I can't stand this hunger...</i></span><span class='hungerasterisks'>*</span>")

				if(1 to 100) //5-30, 5% chance of weakening and 1-230 oxygen damage. 5% chance of a seizure. 10% chance of dropping item
					add_event("hunger", /datum/happiness_event/nutrition/starving)
					if(sleeping) return

					if(prob(5) && prob(50))

						to_chat(src, "<span class='hungerasterisks'>*</span><span class='hunger'><i>You are STARVING.</i></span><span class='hungerasterisks'>*</span>")
						if(prob(45))
							playsound(src, pick('hungry1.ogg','hungry2.ogg','hungry3.ogg','hungry4.ogg'), rand(20,30), 1)
						if(prob(25))
							Weaken(2)

				if(-INFINITY to 1) //Fuck the whole body up at this point

					if(prob(10))
						to_chat(src, "<span class='hungerasterisks'>*</span><span class='hunger'><i>You are STARVING.</i></span><span class='hungerasterisks'>*</span>")
						if(prob(25))
							Weaken(2)
						if(prob(45))
							playsound(src, pick('hungry1.ogg','hungry2.ogg','hungry3.ogg','hungry4.ogg'), rand(20,30), 1)
	proc/handle_changeling()
		if(mind && mind.changeling)
			mind.changeling.regenerate()
	proc/handle_pulse()

		if(life_tick % 5) return pulse	//update pulse every 5 life ticks (~1 tick/sec, depending on server load)

		if(species && species?.flags & NO_BLOOD) return PULSE_NONE //No blood, no pulse.

		if(stat == DEAD)
			coldbreath = FALSE
			return PULSE_NONE	//that's it, you're dead, nothing can influence your pulse

		if(iszombie(src))
			return PULSE_NONE

		var/temp = PULSE_NORM
		coldbreath = TRUE

		if(round(vessel.get_reagent_amount("blood")) <= BLOOD_VOLUME_BAD)	//how much blood do we have
			temp = PULSE_THREADY	//not enough :(

		if(status_flags & FAKEDEATH)
			temp = PULSE_NONE		//pretend that we're dead. unlike actual death, can be inflienced by meds

		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.id in bradycardics)
				if(temp <= PULSE_THREADY && temp >= PULSE_NORM)
					temp--
					break		//one reagent is enough
								//comment out the breaks to make med effects stack
		for(var/datum/reagent/R in reagents.reagent_list)				//handles different chems' influence on pulse
			if(R.id in tachycardics)
				if(temp <= PULSE_FAST && temp >= PULSE_NONE)
					temp++
					break
		for(var/datum/reagent/R in reagents.reagent_list) //To avoid using fakedeath
			if(R.id in heartstopper)
				temp = PULSE_NONE
				break
		for(var/datum/reagent/R in reagents.reagent_list) //Conditional heart-stoppage
			if(R.id in cheartstopper)
				if(R.volume >= R.overdose_threshold)
					temp = PULSE_NONE
					break

		return temp


	proc/handle_decay()
		var/decaytime = world.time - timeofdeath

		if(species?.flags & IS_SYNTHETIC)
			return

		if(decaytime <= 2400 && decaylevel == 0) //10 minutes for decaylevel1 -- stinky
			return

		if(decaytime > 3000 && decaytime <= 4800 || decaylevel == 1)//20 minutes for decaylevel2 -- bloated and very stinky
			decaylevel = 1

		if(decaytime > 4800 && decaytime <= 6000 || decaylevel == 2)//30 minutes for decaylevel3 -- rotting and gross
			decaylevel = 2
			if(!istype(loc,/obj/item/bodybag) && !istype(loc,/obj/structure/closet/coffin))
				if(!buried)
					if(prob(40))
						new /obj/effect/effect/smoke/bad(src.loc)
						/*if(prob(8))
							new /mob/living/simple_animal/maggot(src.loc)*/
			else
				return

		if(decaytime > 6000 && decaytime <= 7200 || decaylevel == 3)//45 minutes for decaylevel4 -- skeleton
			decaylevel = 3
			if(!istype(loc,/obj/item/bodybag) && !istype(loc,/obj/structure/closet/coffin))
				if(!buried)
					if(prob(65))
						new /obj/effect/effect/smoke/bad(src.loc)
						/*if(prob(4))
							new /mob/living/simple_animal/maggot(src.loc)*/
			else
				return

		if(decaytime > 7800)
			decaylevel = 4
			makeSkeleton()
			return //No puking over skeletons, they don't smell at all!


		for(var/mob/living/carbon/human/H in range(decaylevel, src))
			if(prob(10))
				if(airborne_can_reach(get_turf(src), get_turf(H)))
					if(istype(loc,/obj/item/bodybag))
						return
					if(H.stat >= 2)
						continue
					var/obj/item/clothing/mask/M = H.wear_mask
					if(M && (M.flags & BLOCK_GAS_SMOKE_EFFECT))
						return
					if(iszombie(H) || isVampire)
						return
					if(H.vice == "Necrophile")
						return
					if(H.job == "Misero")
						return
					if(H.job == "Mortus")
						return
					if(H.job == "Serpent")
						return
					if(H.job == "Esculap")
						return
					if(H.special == "avantgarde")
						return
					if(H.holding_breath)
						return
					if(H.resisting_disgust)
						return
					to_chat(H, "<spawn class='ifeelsick'>You smell something foul..")
					H.add_event("disgust", /datum/happiness_event/disgust/verygross)
					H.disgust_level += 4


	proc/handle_smelly_things()
		var/obj/item/clothing/mask/M = src.wear_mask
		if(M && (M.flags & BLOCK_GAS_SMOKE_EFFECT))
			return
		if(iszombie(src) || isVampire)
			return
		if(vice == "Necrophile")
			return
		if(job == "Misero")
			return
		if(job == "Mortus")
			return
		if(job == "Serpent")
			return
		if(job == "Esculap")
			return
		if(src.resisting_disgust)
			return
		if(special == "avantgarde")
			return
		if(src.holding_breath)
			return
		if(/obj/effect/decal/cleanable/poo in range(5, src))
			if(prob(2))
				to_chat(src, "<spawn class='ifeelsick'>Something smells like shit...")
				vomit()
				add_event("disgust", /datum/happiness_event/disgust/verygross)
				if(prob(50))
					vomit()

		for(var/obj/item/weapon/reagent_containers/food/snacks/poo/P in range(5, src))
			if(istype(P.loc, /obj/machinery/disposal) || istype(P.loc, /obj/item/weapon/storage/bag))
				return
			if(wear_mask)
				return
			if(iszombie(src) || isVampire)
				return
			if(vice == "Necrophile")
				return
			if(job == "Misero")
				return
			if(job == "Mortus")
				return
			if(job == "Serpent")
				return
			if(job == "Esculap")
				return
			if(src.resisting_disgust)
				return
			if(src.holding_breath)
				return
			if(special == "avantgarde")
				return
			if(prob(6))
				to_chat(src, "<spawn class='ifeelsick'>Something smells like shit...")
				vomit()
				add_event("disgust", /datum/happiness_event/disgust/verygross)
				if(prob(50))
					vomit()


/mob/living/carbon/human/handle_silent()
	if(..())
		speech_problem_flag = 1
	return silent

/mob/living/carbon/human/handle_slurring()
	if(..())
		speech_problem_flag = 1
	return slurring

/mob/living/carbon/human/handle_stunned()
	if(..())
		speech_problem_flag = 1
	return stunned

/mob/living/carbon/human/handle_stuttering()
	if(..())
		speech_problem_flag = 1
	return stuttering

/mob/living/carbon/human/proc/handle_gas_mask_sound()
	var/mask_sound = 'sound/tank_breathe.ogg'
	//var/soundcooldown = world.time
	if(istype(wear_mask, /obj/item/clothing/mask/breath) || istype(wear_mask, /obj/item/clothing/mask/gas))
		if(internal)
			playsound(src, mask_sound, rand(50,60), 1)

/mob/living/carbon/human/proc/handle_artery()
	for(var/datum/organ/external/E in organs)
		if(E.status & ORGAN_ARTERY)
			if(world.time >= E.whenstopartery)
				E.status &= ~ORGAN_ARTERY
				src.UpdateArteryIcon()
				E.whenstopartery = -1
				to_chat(src, "My [E.display_name] feels better.")

/mob/living/carbon/human/proc/handle_blood_pools()
	if(resting && vessel.get_reagent_amount("blood") && stat != 2)//check if human is laying and has blood, i dont know if this is the right way to check for laying
		for(var/datum/organ/external/org in organs)
			if(org.status & ORGAN_ARTERY) // check if bleeding, i dont know if there is another way to do it maybe without the loop
				if(isturf(loc))
					var/obj/effect/decal/cleanable/bloodpool/B = locate(/obj/effect/decal/cleanable/bloodpool) in loc
					drip(15)
					if(!B)
						for(var/obj/effect/decal/cleanable/blood/drop in loc)
							qdel(drop)
						B = PoolOrNew(/obj/effect/decal/cleanable/bloodpool, loc)
						..()
						return 0
					else
						return 0

/mob/living/carbon/human/proc/handle_cripple()
	for(var/datum/organ/external/org in organs)
		if(org.cripple_left > 0)
			org.cripple_left = max(0, org.cripple_left-2)

#undef HUMAN_MAX_OXYLOSS
#undef HUMAN_CRIT_MAX_OXYLOSS
//////////////////////////////////////////////
//////////DESATIVADO / INSTAVEL  /////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
/mob/living/carbon/human/proc/CheckChemsBuff()
	if(reagents.has_reagent("mentats"))
		src.my_stats.it = src.my_stats.initit+5
		if(!reagents.has_reagent("gelabine"))
			src.my_stats.dx = src.my_stats.initdx-5

	else if(reagents.has_reagent("buffout"))
		src.my_stats.st = src.my_stats.initst+4
		if(!reagents.has_reagent("gelabine"))
			src.my_stats.it = src.my_stats.initit-4
	else if(reagents.has_reagent("dentrine"))
		if(!reagents.has_reagent("gelabine"))
			src.my_stats.dx = src.my_stats.initdx-6
	else if(reagents.has_reagent("oxycodone"))
		if(!reagents.has_reagent("gelabine"))
			src.my_stats.ht = src.my_stats.initht-8
	else if(reagents.has_reagent("dob"))
		if(!reagents.has_reagent("gelabine"))
			src << sound('gabbro.ogg', repeat = 1, wait = 1, volume = 80, channel = 30)
			src.overlay_fullscreen("dob", /obj/screen/fullscreen/DOB, 1)
			src.canmove = FALSE
			src.resting = TRUE
			src.lying = TRUE
			return
	else
		src.my_stats.st = src.my_stats.initst
		src.my_stats.dx = src.my_stats.initdx
		src.my_stats.it = src.my_stats.initit
		src.my_stats.ht = src.my_stats.initht
		src.clear_fullscreen("dob")
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 30)
		return

/mob/living/carbon/human/proc/prepareLeave()
	if(!client && !ismonster(src) && !new_keyed && stat != DEAD && !bot)
		logout_time += 1
		if((!sleeping || !buckled?.can_leave) && !istype(src:species, /datum/species/human/alien))
			return
		if(logout_time >= 195)
			new_keyed = "NONE"
			var/time_passed = world.time
			var/list/mob/dead/observer/candidates = list()
			var/mob/dead/observer/theghost = null
			for(var/mob/dead/observer/G in player_list)
				spawn(0)
					G << 'console_interact7.ogg'
					switch(alert(G,"Do you want to play as [src.real_name] ([src.key]) as [src.job]","Please answer in 30 seconds!","Yes","No"))
						if("Yes")
							if((world.time-time_passed)>300)
								return
							candidates += G
						if("No")
							return
						else
							return
			spawn(300)
				for(var/mob/dead/observer/G in candidates)
					if(!G.key || G.key == src.key || G.ckey == src.ckey)
						candidates.Remove(G)
				if(candidates.len)
					theghost = pick(candidates)
					key_changed_list.Add("[src.real_name] <span class='bname'>([src.key]</span> -> <span class='bname'>[theghost.key]</span>)")
					var/mob/dead/observer/ghost = new/mob/dead/observer(src,1)
					ghost.ckey = src.ckey
					src.ckey = theghost.ckey
					src.new_keyed = theghost.key
					qdel(theghost)
					animate(src.client, color = null, time = 20)
					src.clear_fullscreen("ghost")
					src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 12)
					src << sound(null, repeat = 0, wait = 0, volume =  0, channel = 9) // remove the ambience
					var/area/A = get_area(src)
					if(A.forced_ambience)
						var/sound/S = sound(pick(A.forced_ambience), repeat=1, wait=0, channel=9, volume=src?.client?.prefs?.music_volume)
						src << S
					src.logout_time = 0
				else
					new_keyed = null
					logout_time = 0
	else
		logout_time = 0

/****************************************************
				BLOOD SYSTEM
****************************************************/
//Blood levels
var/const/BLOOD_VOLUME_SAFE = 501
var/const/BLOOD_VOLUME_OKAY = 250
var/const/BLOOD_VOLUME_BAD = 150
var/const/BLOOD_VOLUME_SURVIVE = 50

/mob/living/carbon/human/var/datum/reagents/vessel	//Container for blood and BLOOD ONLY. Do not transfer other chems here.
/mob/living/carbon/human/var/var/pale = 0			//Should affect how mob sprite is drawn, but currently doesn't.

//Initializes blood vessels
/mob/living/carbon/human/proc/make_blood()

	if(vessel)
		return

	vessel = new/datum/reagents(600)
	vessel.my_atom = src

	if(species && species.flags & NO_BLOOD) //We want the var for safety but we can do without the actual blood.
		return

	vessel.add_reagent("blood",560)
	spawn(1)
		fixblood()

//Resets blood data
/mob/living/carbon/human/proc/fixblood()
	if(species)
		for(var/datum/reagent/blood/B in vessel.reagent_list)
			if(B.id == "blood")
				B.data = list(	"donor"=src,"viruses"=null,"species"=species.name,"blood_DNA"=dna.unique_enzymes,"blood_colour"= species.blood_color,"blood_type"=dna.b_type,	\
								"resistances"=null,"trace_chem"=null, "virus2" = null, "antibodies" = null)
				B.color = B.data["blood_colour"]

// Takes care blood loss and regeneration
/mob/living/carbon/human/proc/handle_blood()

	if(species && species.flags & NO_BLOOD)
		return
	if(iszombie(src))
		return
	if(stat != DEAD && bodytemperature >= 170)	//Dead or cryosleep people do not pump the blood.

		var/blood_volume = round(vessel.get_reagent_amount("blood"))

		//Blood regeneration if there is some space
		if(blood_volume < 560 && blood_volume && !isVampire)
			var/datum/reagent/blood/B = locate() in vessel.reagent_list //Grab some blood
			if(B) // Make sure there's some blood at all
				if(B.data["donor"] != src) //If it's not theirs, then we look for theirs
					for(var/datum/reagent/blood/D in vessel.reagent_list)
						if(D.data["donor"] == src)
							B = D
							break
				if(nutrition > 399 && hidratacao > 449)
					B.volume += 1.8

				if(nutrition > 250 && hidratacao > 300)
					B.volume += 0.5

				if(nutrition > 150 && hidratacao > 200)
					B.volume += 0.1

				B.volume += 0.1 // regenerate blood VERY slowly
				if(mRegen in src.mutations)
					B.volume += 1
				if (reagents.has_reagent("nutriment"))	//Getting food speeds it up
					B.volume += 0.4
					reagents.remove_reagent("nutriment", 0.1)
				if (reagents.has_reagent("iron"))	//Hematogen candy anyone?
					B.volume += 0.8
					reagents.remove_reagent("iron", 0.1)

		// Damaged heart virtually reduces the blood volume, as the blood isn't
		// being pumped properly anymore.
		if(species && species.has_organ["heart"] && !isVampire)
			var/datum/organ/internal/heart/heart = internal_organs_by_name["heart"]

			if(!heart)
				blood_volume = 0
			else if(heart.damage > 1 && heart.damage < heart.min_bruised_damage)
				blood_volume *= 0.8
			else if(heart.damage >= heart.min_bruised_damage && heart.damage < heart.min_broken_damage)
				blood_volume *= 0.6
			else if(heart.damage >= heart.min_broken_damage && heart.damage < INFINITY)
				blood_volume *= 0.3

		//Effects of bloodloss
		switch(blood_volume)
			if(BLOOD_VOLUME_SAFE to 10000)
				if(pale)
					pale = 0
					update_body()
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				if(!isVampire)
					if(!pale)
						pale = 1
						update_body()
						var/word = pick("dizzy","woosey","faint")
						to_chat(src, "\red You feel [word]")
					if(prob(1))
						var/word = pick("dizzy","woosey","faint")
						to_chat(src,"\red You feel [word]")
					if(oxyloss < 20)
						oxyloss += 3
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				if(!isVampire)
					if(!pale)
						pale = 1
						update_body()
					eye_blurry += 6
					if(oxyloss < 50)
						oxyloss += 10
					oxyloss += 1
					if(prob(15))
						Paralyse(rand(1,2))
						var/word = pick("dizzy","woosey","faint")
						to_chat(src,"\red You feel extremely [word]")
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
				if(isVampire)
					if(!pale)
						pale = 1
						update_body()
					/*if(prob(3) && !sleeping){
						sleeping = rand(1, 3)
					}
					if(prob(6))
						var/word = pick("dizzy","woosey","faint")
						to_chat(src,"\red You feel extremely [word]")
				else
					oxyloss += 5
					toxloss += 3
					if(prob(15) && !sleeping){
						sleeping = rand(10, 15)
					}
					if(prob(15))
						var/word = pick("dizzy","woosey","faint")
						to_chat(src,"\red You feel extremely [word]")*/

		// Without enough blood you slowly go hungry.
		if(blood_volume < BLOOD_VOLUME_SAFE)
			if(nutrition >= 300)
				nutrition -= 10
			else if(nutrition >= 200)
				nutrition -= 3

		//Bleeding out
		var/blood_max = 0
		var/list/do_spray = list()
		for(var/datum/organ/external/temp in organs)
			if(!(temp.status & ORGAN_BLEEDING || temp.status & ORGAN_ARTERY) || temp.status & ORGAN_ROBOT)
				continue
			for(var/datum/wound/W in temp.wounds) if(W.bleeding())
				blood_max += W.damage / 40
			if (temp.open)
				blood_max += 4  //Yer stomach is cut open
			if(temp.status & ORGAN_ARTERY)
				temp.whenstopartery = world.time + 600
				blood_max += rand(6, 7)
				if(temp.artery_name == "carotid artery")
					blood_max += rand(6, 7)
				do_spray += "[temp.artery_name]"

		if(world.time >= next_blood_squirt && istype(loc, /turf) && do_spray.len)
			visible_message("<span class='combatbold'>[src]</span><span class='combat'>'s [pick(do_spray)] squirts blood!</span>")
			playsound(src, 'sound/lfwbsounds/blood_splat.ogg', 100, 0)
			if(!ismonster(src) && !iszombie(src))
				for(var/mob/living/carbon/human/HHH in range(src,9))
					if(!HHH.terriblethings)
						HHH.add_event("terriblething", /datum/happiness_event/disgust/terriblethings)
			// It becomes very spammy otherwise. Arterial bleeding will still happen outside of this block, just not the squirt effect.
			next_blood_squirt = world.time + 100
			var/turf/sprayloc = get_turf(src)
			blood_max -= src.drip(ceil(blood_max/3), sprayloc)
			if(blood_max > 0)
				blood_max -= src.blood_squirt(blood_max, sprayloc)
				if(blood_max > 0)
					src.drip(blood_max, get_turf(src))

		drip(blood_max)

//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/human/proc/drip(var/amt as num, var/tar, var/ddir, var/removesblood=1)

	if(species && species.flags & NO_BLOOD) //TODO: Make drips come from the reagents instead.
		return

	if(!amt)
		return

	if(stat == DEAD)
		return

	if(removesblood)
		vessel.remove_reagent("blood",amt)
	blood_splatter(src,src)

	blood_splatterr(tar, src, (ddir && ddir>0), spray_dir = ddir)

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to the container, preserving all data in it.
/mob/living/carbon/proc/take_blood(obj/item/weapon/reagent_containers/container, var/amount)

	var/datum/reagent/B = get_blood(container.reagents)
	if(!B) B = new /datum/reagent/blood
	B.holder = container
	B.volume += amount

	//set reagent data
	B.data["donor"] = src
	if (!B.data["virus2"])
		B.data["virus2"] = list()
	B.data["virus2"] |= virus_copylist(src.virus2)
	B.data["antibodies"] = src.antibodies
	B.data["blood_DNA"] = copytext(src.dna.unique_enzymes,1,0)
	if(src.resistances && src.resistances.len)
		if(B.data["resistances"])
			B.data["resistances"] |= src.resistances.Copy()
		else
			B.data["resistances"] = src.resistances.Copy()
	B.data["blood_type"] = copytext(src.dna.b_type,1,0)

	// Putting this here due to return shenanigans.
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		B.data["blood_colour"] = H.species.blood_color
		B.color = B.data["blood_colour"]

	var/list/temp_chem = list()
	for(var/datum/reagent/R in src.reagents.reagent_list)
		temp_chem += R.id
		temp_chem[R.id] = R.volume
	B.data["trace_chem"] = list2params(temp_chem)
	return B

//For humans, blood does not appear from blue, it comes from vessels.
/mob/living/carbon/human/take_blood(obj/item/weapon/reagent_containers/container, var/amount)

	if(species && species.flags & NO_BLOOD)
		return null

	if(vessel.get_reagent_amount("blood") < amount)
		return null

	. = ..()
	vessel.remove_reagent("blood",amount) // Removes blood if human

//Transfers blood from container ot vessels
/mob/living/carbon/proc/inject_blood(obj/item/weapon/reagent_containers/container, var/amount)
	var/datum/reagent/blood/injected = get_blood(container.reagents)
	if (!injected)
		return
	var/list/sniffles = virus_copylist(injected.data["virus2"])
	for(var/ID in sniffles)
		var/datum/disease2/disease/sniffle = sniffles[ID]
		infect_virus2(src,sniffle,1)
	if (injected.data["antibodies"] && prob(5))
		antibodies |= injected.data["antibodies"]
	var/list/chems = list()
	chems = params2list(injected.data["trace_chem"])
	for(var/C in chems)
		src.reagents.add_reagent(C, (text2num(chems[C]) / 560) * amount)//adds trace chemicals to owner's blood
	reagents.update_total()

	container.reagents.remove_reagent("blood", amount)

//Transfers blood from container ot vessels, respecting blood types compatability.
/mob/living/carbon/human/inject_blood(obj/item/weapon/reagent_containers/container, var/amount)

	var/datum/reagent/blood/injected = get_blood(container.reagents)

	if(species && species.flags & NO_BLOOD)
		reagents.add_reagent("blood", amount, injected.data)
		reagents.update_total()
		return

	var/datum/reagent/blood/our = get_blood(vessel)

	if (!injected || !our)
		return
	if(blood_incompatible(injected.data["blood_type"],our.data["blood_type"]))//,injected.data["species"],our.data["species"]) )
		reagents.add_reagent("toxin",amount * 0.5)
		reagents.update_total()
	else
		vessel.add_reagent("blood", amount, injected.data)
		vessel.update_total()
	..()

//Gets human's own blood.
/mob/living/carbon/proc/get_blood(datum/reagents/container)
	var/datum/reagent/blood/res = locate() in container.reagent_list //Grab some blood
	if(res) // Make sure there's some blood at all
		if(res.data["donor"] != src) //If it's not theirs, then we look for theirs
			for(var/datum/reagent/blood/D in container.reagent_list)
				if(D.data["donor"] == src)
					return D
	return res

proc/blood_incompatible(donor,receiver)//,donor_species,receiver_species)
	if(!donor || !receiver) return 0
/*
	if(donor_species && receiver_species)
		if(donor_species != receiver_species)
			return 1
*/
	var/donor_antigen = copytext(donor,1,length(donor))
	var/receiver_antigen = copytext(receiver,1,length(receiver))
	var/donor_rh = (findtext(donor,"+")>0)
	var/receiver_rh = (findtext(receiver,"+")>0)

	if(donor_rh && !receiver_rh) return 1
	switch(receiver_antigen)
		if("A")
			if(donor_antigen != "A" && donor_antigen != "O") return 1
		if("B")
			if(donor_antigen != "B" && donor_antigen != "O") return 1
		if("O")
			if(donor_antigen != "O") return 1
		//AB is a universal receiver.
	return 0

proc/blood_splatter(var/target,var/datum/reagent/blood/source,var/large)

	var/obj/effect/decal/cleanable/blood/B
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter

	var/turf/T = get_turf(target)
	playsound(T, pick('sound/effects/gore/blood1.ogg','sound/effects/gore/blood2.ogg','sound/effects/gore/blood3.ogg','sound/effects/gore/blood4.ogg','sound/effects/gore/blood5.ogg','sound/effects/gore/blood6.ogg'), 10, 1)

	if(istype(source,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = source
		source = M.get_blood(M.vessel)
	else if(istype(source,/mob/living/carbon/monkey))
		var/mob/living/carbon/monkey/donor = source
		if(donor.dna)
			source = new()
			source.data["blood_DNA"] = donor.dna.unique_enzymes
			source.data["blood_type"] = donor.dna.b_type

	// Are we dripping or splattering?
	if(!large)

		// Only a certain number of drips can be on a given turf.
		var/list/drips = list()
		var/list/drip_icons = list("1","2","3","4","5")

		for(var/obj/effect/decal/cleanable/blood/drip/drop in T)
			drips += drop
			drip_icons.Remove(drop.icon_state)

		// If we have too many drips, remove them and spawn a proper blood splatter.
		if(drips.len >= 5)
			//TODO: copy all virus data from drips to new splatter?
			for(var/obj/effect/decal/cleanable/blood/drip/drop in drips)
				qdel(drop)
		else
			decal_type = /obj/effect/decal/cleanable/blood/drip

	// Find a blood decal or create a new one.
	B = locate(decal_type) in T
	var/obj/effect/decal/cleanable/bloodpool/pool
	pool = locate(/obj/effect/decal/cleanable/bloodpool) in T
	var/obj/item/weapon/reagent_containers/glass/G = locate() in T
	if(!B && !pool)
		if(G && !G.reagents.total_volume != G.reagents.maximum_volume && ishuman(source))
			var/datum/reagent/blood/BB
			var/mob/living/carbon/human/H = source.data["donor"]
			BB = H.take_blood(G,5)
			if(BB)
				G.reagents.reagent_list += BB
				G.reagents.update_total()
				G.on_reagent_change()
				G.reagents.handle_reactions()

		B = PoolOrNew(decal_type, T)
	else if(istype(B, /obj/effect/decal/cleanable/blood/drip) && !pool)
		if(G && !G.reagents.total_volume != G.reagents.maximum_volume)

			var/datum/reagent/blood/BB
			var/mob/living/carbon/human/H = source.data["donor"]
			BB = H.take_blood(G,5)
			if(B)
				G.reagents.reagent_list += BB
				G.reagents.update_total()
				G.on_reagent_change()
				G.reagents.handle_reactions()

		B = PoolOrNew(decal_type, T)

	// If there's no data to copy, call it quits here.
	if(!source)
		return B

	if(!B)
		return

	// Update appearance.
	if(source.data["blood_colour"])
		B.basecolor = source.data["blood_colour"]
		B.update_icon()
		if(source.data["species"] == "Alien")
			B.color = source.data["blood_colour"]

	// Update blood information.
	if(source.data["blood_DNA"])
		B.blood_DNA = list()
		if(source.data["blood_type"])
			B.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
		else
			B.blood_DNA[source.data["blood_DNA"]] = "O+"

	// Update virus information. //Looks like this is out of date.
	//for(var/datum/disease/D in source.data["viruses"])
	//	var/datum/disease/new_virus = D.Copy(1)
	//	source.viruses += new_virus
	//	new_virus.holder = B
	if(source.data["virus2"])
		B.virus2 = virus_copylist(source.data["virus2"])

	return B


#define BLOOD_SPRAY_DISTANCE 2
/mob/living/carbon/human/proc/blood_squirt(var/amt, var/turf/sprayloc, var/spraydir, var/removesblood=1, var/acidblood=0, var/distance = BLOOD_SPRAY_DISTANCE)
	if(amt <= 0 || !istype(sprayloc))
		return
	if(!spraydir)
		spraydir = pick(alldirs)
	amt = ceil(amt/BLOOD_SPRAY_DISTANCE)
	var/bled = 0
	spawn(0)
		for(var/i = 1 to distance)
			sprayloc = get_step(sprayloc, spraydir)
			if(!istype(sprayloc) || sprayloc.density)
				break
			var/hit_mob
			for(var/thing in sprayloc)
				var/atom/A = thing
				if(!A.simulated)
					continue
				if(acidblood)
					A.acid_act()
				if(ishuman(A))
					var/mob/living/carbon/human/H = A
					var/place = ran_zone(zone_sel.selecting)
					if(!H.lying)
						H.bloody_body(src)
						H.bloody_hands(src)
						var/blinding = FALSE
						if(place == BP_HEAD OR place == "face" OR place == BP_MOUTH)
							blinding = TRUE
							for(var/obj/item/I in list(H.head, H.glasses, H.wear_mask))
								if(I && (I.body_parts_covered & EYES))
									blinding = FALSE
									break
						if(blinding)
							H.eye_blurry = max(H.eye_blurry, 10)
							H.eye_blind = max(H.eye_blind, 5)
							to_chat(H, "<span class='danger'>You are blinded by a spray of blood!</span>")
						else
							to_chat(H, "<span class='danger'>You are hit by a spray of blood!</span>")
						hit_mob = TRUE
						if(acidblood)
							H.apply_damage(rand(50, 55), BURN, place)
							H.emote(pick("agonypain", "agonyscream"),1, null, 0)
				if(hit_mob || !A.CanPass(src, sprayloc))
					break
			drip(amt, sprayloc, spraydir, removesblood)
			bled += amt
			if(hit_mob) break
			sleep(1)
	return bled
#undef BLOOD_SPRAY_DISTANCE

proc/blood_splatterr(var/target,var/datum/reagent/blood/source,var/large,var/spray_dir)

	var/obj/effect/decal/cleanable/blood/B
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter
	var/turf/T = get_turf(target)

	if(istype(source,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = source
		source = M.get_blood(M.vessel)

	// Are we dripping or splattering?
	var/list/drips = list()
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/decal/cleanable/blood/drip/drop in T)
		qdel(drop)
	if(!large && drips.len < 3)
		decal_type = /obj/effect/decal/cleanable/blood/drip

	// Find a blood decal or create a new one.
	B = locate(decal_type) in T
	if(!B)
		B = PoolOrNew(decal_type, T)

	var/obj/effect/decal/cleanable/blood/drip/drop = B
	if(istype(drop) && drips && drips.len && !large)
		drop.overlays |= drips


	// If there's no data to copy, call it quits here.
	if(!source)
		return B

	// Update appearance.
	if(source.data["blood_colour"])
		B.basecolor = source.data["blood_colour"]
		B.update_icon()
		if(source.data["species"] == "Alien")
			B.color = source.data["blood_colour"]
	if(spray_dir)
		B.icon_state = "squirt"
		B.color = "#A10808"
		if(source.data["species"] == "Alien")
			B.color = source.data["blood_colour"]
		B.dir = spray_dir

	// Update blood information.
	if(source.data["blood_DNA"])
		B.blood_DNA = list()
		if(source.data["blood_type"])
			B.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
		else
			B.blood_DNA[source.data["blood_DNA"]] = "O+"

	// Update virus information.
	if(source.data["virus2"])
		B.virus2 = virus_copylist(source.data["virus2"])

	B.invisibility = 0
	return B
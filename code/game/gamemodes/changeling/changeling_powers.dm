//Restores our verbs. It will only restore verbs allowed during lesser (monkey) form if we are not human
/mob/proc/make_changeling()
	if(!mind)				return
	if(!mind.changeling)	mind.changeling = new /datum/changeling(gender)
	verbs += /datum/changeling/proc/EvolutionMenu

	add_language("Changeling")

	var/lesser_form = !ishuman(src)
	var/mob/living/carbon/human/H = src
	if(ishuman(src))
		H.my_skills.CHANGE_SKILL(SKILL_CLIMB, 10)
		H.terriblethings = TRUE

	if(!powerinstances.len)
		for(var/P in powers)
			powerinstances += new P()

	// Code to auto-purchase free powers.
	for(var/datum/power/changeling/P in powerinstances)
		if(!P.genomecost) // Is it free?
			if(!(P in mind.changeling.purchasedpowers)) // Do we not have it already?
				mind.changeling.purchasePower(mind, P.name, 0)// Purchase it. Don't remake our verbs, we're doing it after this.

	for(var/datum/power/changeling/P in mind.changeling.purchasedpowers)
		if(P.isVerb)
			if(lesser_form && !P.allowduringlesserform)	continue
			if(!(P in src.verbs))
				src.verbs += P.verbpath
	mind.changeling.absorbed_dna |= dna
	return 1

//removes our changeling verbs
/mob/proc/remove_changeling_powers()
	if(!mind || !mind.changeling)	return
	for(var/datum/power/changeling/P in mind.changeling.purchasedpowers)
		if(P.isVerb)
			verbs -= P.verbpath


//Helper proc. Does all the checks and stuff for us to avoid copypasta
/mob/proc/changeling_power(var/required_chems=0, var/required_dna=0, var/max_genetic_damage=100, var/max_stat=0)

	if(!src.mind)		return
	if(!iscarbon(src))	return

	var/datum/changeling/changeling = src.mind.changeling
	if(!changeling)
		world.log << "[src] has the changeling_transform() verb but is not a changeling."
		return

	if(src.stat > max_stat)
		to_chat(src, "<span class='warning'>We are incapacitated.</span>")
		return

	if(changeling.absorbed_dna.len < required_dna)
		src << "<span class='warning'>We require at least [required_dna] samples of compatible DNA.</span>"
		return

	if(changeling.chem_charges < required_chems)
		src << "<span class='warning'>We require at least [required_chems] units of chemicals to do that!</span>"
		return

	if(changeling.geneticdamage > max_genetic_damage)
		to_chat(src, "<span class='warning'>Our geneomes are still reassembling. We need time to recover first.</span>")
		return

	return changeling

//Used to dump the languages from the changeling datum into the actual mob.
/mob/proc/changeling_update_languages(var/updated_languages)

	languages = list()
	for(var/language in updated_languages)
		languages += language

	//This isn't strictly necessary but just to be safe...
	add_language("Changeling")

	return
/*
//Used to switch species based on the changeling datum.
/mob/proc/changeling_change_species()

	set category = "Changeling"
	set name = "Change Species (5)"

	var/mob/living/carbon/human/H = src
	if(!istype(H))
		src << "<span class='warning'>We may only use this power while in humanoid form.</span>"
		return

	var/datum/changeling/changeling = changeling_power(5,1,0)
	if(!changeling)	return

	if(changeling.absorbed_species.len < 2)
		src << "<span class='warning'>We do not know of any other species genomes to use.</span>"
		return

	var/S = input("Select the target species: ", "Target Species", null) as null|anything in changeling.absorbed_species
	if(!S)	return

	domutcheck(src, null)

	changeling.chem_charges -= 5
	changeling.geneticdamage = 30

	src.visible_message("<span class='warning'>[src] transforms!</span>")

	src.verbs -= /mob/proc/changeling_change_species
	H.set_species(S,1) //Until someone moves body colour into DNA, they're going to have to use the default.

	spawn(10)
		src.verbs += /mob/proc/changeling_change_species
		src.regenerate_icons()

	changeling_update_languages(changeling.absorbed_languages)
	feedback_add_details("changeling_powers","TR")

	return 1
*/

//Absorbs the victim's DNA making them uncloneable. Requires a strong grip on the victim.
//Doesn't cost anything as it's the most basic ability.
/mob/proc/changeling_absorb_dna()
	set category = "Changeling"
	set name = "AbsorbDNA"

	var/datum/changeling/changeling = changeling_power(0,0,100)
	if(!changeling)	return

	var/obj/item/weapon/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(src, "<span class='warning'>We must be grabbing a creature in our active hand to assimilate them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T))
		to_chat(src, "<span class='warning'>[T] is not compatible with our biology.</span>")
		return

	if(ismonster(T) || iszombie(T) || T.isVampire)
		to_chat(src, "<span class='warning'>[T] is not compatible with our biology.</span>")
		return

	if(T.stat == DEAD)
		to_chat(src, "<span class='warning'>[T] is dead!</span>")
		return


	if(NOCLONE in T.mutations)
		to_chat(src, "<span class='warning'>This creature's DNA is ruined beyond useability!</span>")
		return

	if(!G.state == GRAB_KILL)
		to_chat(src, "<span class='warning'>We must have a tighter grip to absorb this creature.</span>")
		return

	if(tentaclesexposed == FALSE)
		to_chat(src, "<span class='warning'>We need to expose our tentacles!</span>")
		return

	if(changeling.isabsorbing)
		to_chat(src, "<span class='warning'>We are already absorbing!</span>")
		return

	changeling.isabsorbing = 1
	for(var/stage = 1, stage<=3, stage++)
		switch(stage)
			if(1)
				playsound(src.loc, 'sound/effects/changeling_walk.ogg', 20, 0, -1)
				to_chat(src, "<span class='notice'>This creature is compatible. We must hold still.</span>")
			if(2)
				playsound(src.loc, 'sound/effects/changeling_hunt.ogg', 20, 0, -1)
				to_chat(src, "<span class='notice'>We extend a proboscis.</span>")
				src.visible_message("<span class='warning'>[src] extends a proboscis!</span>")
			if(3)
				playsound(src.loc, 'sound/effects/stabchang.ogg', 20, 0, -1)
				to_chat(src, "<span class='notice'>We stab [T] with the proboscis.</span>")
				src.visible_message("<span class='danger'>[src] stabs [T] with the proboscis!</span>")
				to_chat(T, "<span class='danger'>You feel a sharp stabbing pain!</span>")
				var/datum/organ/external/affecting = T.get_organ(src.zone_sel.selecting)
				if(affecting.take_damage(39,0,1,"large organic needle"))
					T:UpdateDamageIcon()
					continue

		if(!do_mob(src, T, 140))
			to_chat(src, "<span class='warning'>Our absorption of [T] has been interrupted!</span>")
			changeling.isabsorbing = 0
			return

	to_chat(src, "<span class='notice'>We have absorbed [T]!</span>")
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.absorbedP += 1
	playsound(src.loc, pick('sound/effects/changeling_suck1.ogg','sound/effects/changeling_suck2.ogg','sound/effects/changeling_suck3.ogg'), 50, 0, -1)
	src.visible_message("<span class='danger'>[src] sucks the fluids from [T]!</span>")
	to_chat(T, "<span class='danger'>You have been absorbed by a they!</span>")

	T.dna.real_name = T.real_name //Set this again, just to be sure that it's properly set.
	changeling.absorbed_dna |= T.dna
	if(src.nutrition < 400) src.nutrition = min((src.nutrition + T.nutrition), 400)
	changeling.chem_charges += 10
	changeling.geneticpoints += 2

	if(T.mind && T.mind.changeling)
		if(T.mind.changeling.absorbed_dna)
			for(var/dna_data in T.mind.changeling.absorbed_dna)	//steal all their loot
				if(dna_data in changeling.absorbed_dna)
					continue
				changeling.absorbed_dna += dna_data
				changeling.absorbedcount++
			T.mind.changeling.absorbed_dna.len = 1

		if(T.mind.changeling.purchasedpowers)
			for(var/datum/power/changeling/Tp in T.mind.changeling.purchasedpowers)
				if(Tp in changeling.purchasedpowers)
					continue
				else
					changeling.purchasedpowers += Tp

					if(!Tp.isVerb)
						call(Tp.verbpath)()
					else
						src.make_changeling()

		changeling.chem_charges += T.mind.changeling.chem_charges
		changeling.geneticpoints += T.mind.changeling.geneticpoints
		T.mind.changeling.chem_charges = 0
		T.mind.changeling.geneticpoints = 0
		T.mind.changeling.absorbedcount = 0

	changeling.absorbedcount++
	changeling.isabsorbing = 0

	for(var/obj/item/W in T)
		T.drop_from_inventory(W)
	T.death(0)
	T.Drain()
	T.TheyCage()
	playsound(T, 'sound/lfwbsounds/they_absorb.ogg', 100, 1)
	return 1

/mob/living/carbon/human/proc/TheyCage()
	new/obj/structure/theycage(src.loc)
	gib(src)

/obj/structure/theycage
	name = "Meat"
	icon = 'icons/monsters/critter.dmi'
	icon_state = "floater"
	var/not_open = TRUE
	var/usable

/obj/structure/theycage/New()
	..()
	spawn(600)
		src.visible_message("<span class='warning'>[src] begins to shake!</span>")
		usable = TRUE
		icon_state = "floaterx"
		makeThey()

/obj/structure/theycage/proc/makeThey()
	var/list/mob/dead/observer/candidates = list()
	var/mob/dead/observer/theghost = null
	var/time_passed = world.time
	for(var/mob/dead/observer/G in player_list)
		spawn(0)
			G << 'console_interact7.ogg'
			switch(alert(G, "Do you want to become one of THEM?","Please answer in 30 seconds!","Yes","No"))
				if("Yes")
					if((world.time-time_passed)>300)//If more than 30 game seconds passed.
						return
					candidates += G
				if("No")
					return
				else
					return

	sleep(300)
	if(candidates.len <= 0)
		spawn(300)
			makeThey()
		return
	if(candidates.len)
		shuffle(candidates)
		for(var/mob/i in candidates)
			if(!i || !i.client) continue //Dont bother removing them from the list since we only grab one wizard

			theghost = i
			break

	if(theghost)
		var/mob/living/carbon/human/new_character = makeBodyThey(theghost)
		if(theghost.latepartied)
			theghost.latepartied = FALSE
			latepartynum -= 1
		new_character.mind.make_They()
		new_character.client.color = null
		new_character.updatePig()
		log_game("[new_character.real_name]([new_character?.key]) is now a THEY(spawned from theycage).")
		qdel(src)
		return TRUE

	return FALSE

/obj/structure/theycage/proc/makeBodyThey(var/mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
	if(!G_found || !G_found.key)	return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new(pick(latejoin))//The mob being spawned.

	new_character.gender = pick(MALE,FEMALE)

	var/datum/preferences/A = new()
	A.randomize_appearance_for(new_character)
	if(new_character.gender == MALE)
		new_character.real_name = "[pick(first_names_male)] [pick(last_names)]"
	else
		new_character.real_name = "[pick(first_names_female)] [pick(last_names)]"
	new_character.name = new_character.real_name
	new_character.age = rand(17,45)

	new_character.dna.ready_dna(new_character)
	new_character.key = G_found.key
	new_character.client.color = null
	new_character << sound(null, repeat = 0, wait = 0, volume = 0, channel = 12)

	return new_character

//Change our DNA to that of somebody we've absorbed.
/mob/verb/extend_tentacles()
	set category = "Changeling"
	set name = "ExtendTentacles"
	var/mob/living/carbon/human/H = src
	if(!H?.mind?.changeling)
		return
	if(H.tentaclesexposed == TRUE)
		playsound(H.loc, 'sound/effects/changeling_hunt.ogg', 50, 0, -1)
		H.visible_message("<span class='warning'>[H] hides tentacles!</span>")
		H.tentaclesexposed = FALSE
		H.my_stats.st -= 1
		H.my_stats.dx -= 3
		H.overlays_standing[2] = null
		var/image/standing = null
		H.overlays_standing[2] = standing
		H.update_icons()
		return
	else
		playsound(H.loc, 'sound/effects/changeling_walk.ogg', 50, 0, -1)
		H.visible_message("<span class='warning'>[H] exposes tentacles!</span>")
		H.tentaclesexposed = TRUE
		H.my_stats.st += 1
		H.my_stats.dx += 3
		H.overlays_standing[2] = null
		var/image/standing = overlay_image('icons/mob/mob.dmi', "theytentacle")
		if(H?.my_stats?.st > 10)
			standing = overlay_image('icons/mob/mob.dmi', "3floater")
		else
			if(H.gender == FEMALE)
				standing = overlay_image('icons/mob/mob.dmi', "1floater")
			else
				standing = overlay_image('icons/mob/mob.dmi', "2floater")
		H.overlays_standing[2] = standing
		H.update_icons()
		return
	return

/mob/verb/changhunt()
	set category = "Changeling"
	set name = "Hunt"
	if(!ishuman(src)) return
	var/mob/living/carbon/human/H = src
	if(H.ishunting)
		playsound(H.loc, 'sound/effects/changeling_walk.ogg', 50, 0, 1)
		sight |= SEE_MOBS
		H.ishunting = 0
	else
		playsound(H.loc, 'sound/effects/changeling_walk.ogg', 50, 0, 1)
		sight &= ~SEE_MOBS
		H.ishunting = 1

/mob/verb/infestweb()
	set category = "Changeling"
	set name = "infest"
	if(!ishuman(src)) return
	var/mob/living/carbon/human/H = src
	if(H.absorbedP >= 3)
		for(var/obj/machinery/lifeweb/pillar/left/L in view(1, H))
			playsound(H.loc, 'sound/effects/changeling_walk.ogg', 50, 0, 1)
			if(do_after(H, 50))
				L.overlays += image('icons/effects/things.dmi', "[rand(2,5)]")
				for(var/obj/machinery/lifeweb/pillar/P in view(7, H))
					P.overlays += image('icons/effects/things2.dmi', "[rand(1,2)]")
				world << pick('sound/lfwbsounds/they_contact1.ogg', 'sound/lfwbsounds/they_contact2.ogg', 'sound/lfwbsounds/they_contact3.ogg', 'sound/lfwbsounds/they_contact4.ogg')
				for(var/mob/living/carbon/human/HH in mob_list)
					if(HH.mind.changeling)
						HH.reagents.add_reagent("dentrine",2000)
	else
		to_chat(H, "<span class='combat'>[pick(nao_consigoen)] I need to absorb atleast three people.</span>")

/obj/effect/lump
	name = "Lump"
	desc = "I Better stay away from that thing."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/mob/critter.dmi'
	icon_state = "lump1"

/obj/effect/lump/Crossed(mob/living/carbon/human/M as mob|obj)
	if(ismonster(M))
		return
	if(M?.mind?.changeling)
		return
	if(ishuman(M))
		var/obj/item/clothing/mask/MA = M.wear_mask
		if(MA && (MA.flags & BLOCK_GAS_SMOKE_EFFECT))
			playsound(M, pick('sound/lfwbsounds/lump_active.ogg', 'sound/lfwbsounds/lump_active2.ogg'), 100, 1)
			qdel(src)
			return
		if(prob(90))
			M.apply_damage(rand(1, 2), OXY);
			M.vomit()
		M.Weaken(10)
		M.flash_pain()
		playsound(M, pick('sound/lfwbsounds/lump_active.ogg', 'sound/lfwbsounds/lump_active2.ogg'), 100, 1)
		qdel(src)

/mob/verb/lump()
	set category = "Changeling"
	set name = "Lump"
	if(!ishuman(src)) return
	var/mob/living/carbon/human/H = src
	if(!H?.mind?.changeling)
		return
	var/datum/changeling/changeling = H.mind.changeling
	if(world.time > (changeling.last_lump + changeling.lump_delay))
		changeling.last_lump = world.time
		if(!H.wear_suit && !H.w_uniform)
			if(do_after(H, 40))
				playsound(H, pick('sound/lfwbsounds/lump_spawn.ogg', 'sound/lfwbsounds/lump_spawn2.ogg'), 100, 1)
				new/obj/effect/lump(src.loc)
		else
			to_chat(H, "<span class='combat'>[pick(nao_consigoen)] I need to be naked.</span>")
	else
		to_chat(H, "<span class='combat'>[pick(nao_consigoen)] I need to wait longer!</span>")
		return

/mob/verb/learn()
	set category = "Changeling"
	set name = "Learnch"
	if(!ishuman(src)) return
	var/mob/living/carbon/human/H = src
	for(var/mob/living/carbon/human/Other in view(1, H))
		if(Other == H)
			continue
		if(do_after(H, 50))
			if(Other.mind.changeling && Other.tentaclesexposed)
				for(var/skill in Other.my_skills.skills_holder)
					var/learn_value = Other.my_skills.GET_SKILL(skill)
					if(learn_value > H.my_skills.GET_SKILL(skill))
						H.my_skills.CHANGE_SKILL(skill, learn_value)

				playsound(H, 'sound/lfwbsounds/they_learn.ogg', 100, 1)
				return
		to_chat(H, "<span class='combat'>[pick(nao_consigoen)] I must stand still.</span>")



/mob/proc/changeling_transform()
	set category = "Changeling"
	set name = "Transform (5)"

	var/datum/changeling/changeling = changeling_power(5,1,0)
	if(!changeling)	return

	var/list/names = list()
	for(var/datum/dna/DNA in changeling.absorbed_dna)
		names += "[DNA.real_name]"

	var/S = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!S)	return

	var/datum/dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	changeling.chem_charges -= 5
	src.visible_message("<span class='warning'>[src] transforms!</span>")
	changeling.geneticdamage = 30
	src.dna = chosen_dna
	src.real_name = chosen_dna.real_name
	src.flavor_text = ""
	src.UpdateAppearance()
	domutcheck(src, null)

	src.verbs -= /mob/proc/changeling_transform
	spawn(10)	src.verbs += /mob/proc/changeling_transform

	return 1

//Transform into a monkey.
/mob/proc/changeling_lesser_form()
	set category = "Changeling"
	set name = "Lesser Form (1)"

	var/datum/changeling/changeling = changeling_power(1,0,0)
	if(!changeling)	return

	if(src.has_brain_worms())
		src << "<span class='warning'>We cannot perform this ability at the present time!</span>"
		return

	var/mob/living/carbon/C = src
	changeling.chem_charges--
	C.remove_changeling_powers()
	C.visible_message("<span class='warning'>[C] transforms!</span>")
	changeling.geneticdamage = 30
	C << "<span class='warning'>Our genes cry out!</span>"

	//TODO replace with monkeyize proc
	var/list/implants = list() //Try to preserve implants.
	for(var/obj/item/weapon/implant/W in C)
		implants += W

	C.monkeyizing = 1
	C.canmove = 0
	C.icon = null
	C.overlays.Cut()
	C.invisibility = 101

	var/atom/movable/overlay/animation = new /atom/movable/overlay( C.loc )
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src
	flick("h2monkey", animation)
	sleep(48)
	qdel(animation)

	var/mob/living/carbon/monkey/O = new /mob/living/carbon/monkey(src)
	O.dna = C.dna
	C.dna = null

	for(var/obj/item/W in C)
		C.drop_from_inventory(W)
	for(var/obj/T in C)
		qdel(T)

	O.loc = C.loc
	O.name = "monkey ([copytext(md5(C.real_name), 2, 6)])"
	O.setToxLoss(C.getToxLoss())
	O.adjustBruteLoss(C.getBruteLoss())
	O.setOxyLoss(C.getOxyLoss())
	O.adjustFireLoss(C.getFireLoss())
	O.stat = C.stat
	O.a_intent = "hurt"
	for(var/obj/item/weapon/implant/I in implants)
		I.loc = O
		I.implanted = O

	C.mind.transfer_to(O)

	O.make_changeling(1)
	O.verbs += /mob/proc/changeling_lesser_transform
	qdel(C)
	return 1


//Transform into a human
/mob/proc/changeling_lesser_transform()
	set category = "Changeling"
	set name = "Transform (1)"

	var/datum/changeling/changeling = changeling_power(1,1,0)
	if(!changeling)	return

	var/list/names = list()
	for(var/datum/dna/DNA in changeling.absorbed_dna)
		names += "[DNA.real_name]"

	var/S = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!S)	return

	var/datum/dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	var/mob/living/carbon/C = src

	changeling.chem_charges--
	C.remove_changeling_powers()
	C.visible_message("<span class='warning'>[C] transforms!</span>")
	C.dna = chosen_dna

	var/list/implants = list()
	for (var/obj/item/weapon/implant/I in C) //Still preserving implants
		implants += I

	C.monkeyizing = 1
	C.canmove = 0
	C.icon = null
	C.overlays.Cut()
	C.invisibility = 101
	var/atom/movable/overlay/animation = new /atom/movable/overlay( C.loc )
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src
	flick("monkey2h", animation)
	sleep(48)
	qdel(animation)

	for(var/obj/item/W in src)
		C.u_equip(W)
		if (C.client)
			C.client.screen -= W
		if (W)
			W.loc = C.loc
			W.dropped(C)
			W.layer = initial(W.layer)

	var/mob/living/carbon/human/O = new /mob/living/carbon/human( src )
	if (C.dna.GetUIState(DNA_UI_GENDER))
		O.gender = FEMALE
	else
		O.gender = MALE
	O.dna = C.dna
	C.dna = null
	O.real_name = chosen_dna.real_name

	for(var/obj/T in C)
		qdel(T)

	O.loc = C.loc

	O.UpdateAppearance()
	domutcheck(O, null)
	O.setToxLoss(C.getToxLoss())
	O.adjustBruteLoss(C.getBruteLoss())
	O.setOxyLoss(C.getOxyLoss())
	O.adjustFireLoss(C.getFireLoss())
	O.stat = C.stat
	for (var/obj/item/weapon/implant/I in implants)
		I.loc = O
		I.implanted = O

	C.mind.transfer_to(O)
	O.make_changeling()

	qdel(C)
	return 1


//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/mob/proc/changeling_fakedeath()
	set category = "Changeling"
	set name = "RegenerativeStasis"

	var/datum/changeling/changeling = changeling_power(20,1,100,DEAD)
	if(!changeling)	return
	var/mob/living/carbon/human/C = src

	to_chat(src, "<span class='notice'>Time to do this again.</span>")

	C.status_flags |= FAKEDEATH		//play dead
	C.sleeping = 300
	C.resting = 1
	C.update_canmove()
	C.remove_changeling_powers()
	C.emote("gasp")
	C.tod = worldtime2text()

	spawn(rand(200,300))
		if(changeling)
			// charge the changeling chemical cost for stasis
			changeling.chem_charges -= 20

			// remove our fake death flag
			C.status_flags &= ~(FAKEDEATH)

			// restore us to health
			C.rejuvenate()
			var/datum/organ/internal/heart/HE = C.internal_organs_by_name["heart"]
			if(HE)
				HE.stopped_working = 0
			// let us move again
			C.update_canmove()

			C.revive()

			// re-add out changeling powers
			C.make_changeling()

			// sending display messages
			C.sleeping = 0
			to_chat(C, "<span class='notice'>We have regenerated.</span>")
			C.visible_message("<span class='warning'>[src] appears to wake from the dead, having healed all wounds.</span>")


	return 1


//Boosts the range of your next sting attack by 1
/mob/proc/changeling_boost_range()
	set category = "Changeling"
	set name = "Ranged Sting (10)"
	set desc="Your next sting ability can be used against targets 2 squares away."

	var/datum/changeling/changeling = changeling_power(10,0,100)
	if(!changeling)	return 0
	changeling.chem_charges -= 10
	src << "<span class='notice'>Your throat adjusts to launch the sting.</span>"
	changeling.sting_range = 2
	src.verbs -= /mob/proc/changeling_boost_range
	spawn(5)	src.verbs += /mob/proc/changeling_boost_range
	return 1


//Recover from stuns.
/mob/proc/changeling_unstun()
	set category = "Changeling"
	set name = "Epinephrine Sacs (45)"
	set desc = "Removes all stuns"

	var/datum/changeling/changeling = changeling_power(45,0,100,UNCONSCIOUS)
	if(!changeling)	return 0
	changeling.chem_charges -= 45

	var/mob/living/carbon/human/C = src
	C.stat = 0
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.lying = 0
	C.update_canmove()

	src.verbs -= /mob/proc/changeling_unstun
	spawn(5)	src.verbs += /mob/proc/changeling_unstun
	return 1


//Speeds up chemical regeneration
/mob/proc/changeling_fastchemical()
	src.mind.changeling.chem_recharge_rate *= 2
	return 1

//Increases macimum chemical storage
/mob/proc/changeling_engorgedglands()
	src.mind.changeling.chem_storage += 25
	return 1


//Prevents AIs tracking you but makes you easily detectable to the human-eye.
/mob/proc/changeling_digitalcamo()
	set category = "Changeling"
	set name = "Toggle Digital Camoflague"
	set desc = "The AI can no longer track us, but we will look different if examined.  Has a constant cost while active."

	var/datum/changeling/changeling = changeling_power()
	if(!changeling)	return 0

	var/mob/living/carbon/human/C = src
	if(C.digitalcamo)	C << "<span class='notice'>We return to normal.</span>"
	else				C << "<span class='notice'>We distort our form to prevent AI-tracking.</span>"
	C.digitalcamo = !C.digitalcamo

	spawn(0)
		while(C && C.digitalcamo && C.mind && C.mind.changeling)
			C.mind.changeling.chem_charges = max(C.mind.changeling.chem_charges - 1, 0)
			sleep(40)

	src.verbs -= /mob/proc/changeling_digitalcamo
	spawn(5)	src.verbs += /mob/proc/changeling_digitalcamo
	return 1


//Starts healing you every second for 10 seconds. Can be used whilst unconscious.
/mob/proc/changeling_rapidregen()
	set category = "Changeling"
	set name = "Rapid Regeneration (30)"
	set desc = "Begins rapidly regenerating.  Does not effect stuns or chemicals."

	var/datum/changeling/changeling = changeling_power(30,0,100,UNCONSCIOUS)
	if(!changeling)	return 0
	src.mind.changeling.chem_charges -= 30

	var/mob/living/carbon/human/C = src
	spawn(0)
		for(var/i = 0, i<10,i++)
			if(C)
				C.adjustBruteLoss(-10)
				C.adjustToxLoss(-10)
				C.adjustOxyLoss(-10)
				C.adjustFireLoss(-10)
				sleep(10)

	src.verbs -= /mob/proc/changeling_rapidregen
	spawn(5)	src.verbs += /mob/proc/changeling_rapidregen
	return 1

// HIVE MIND UPLOAD/DOWNLOAD DNA

var/list/datum/dna/hivemind_bank = list()

/mob/proc/changeling_hiveupload()
	set category = "Changeling"
	set name = "Hive Channel (10)"
	set desc = "Allows you to channel DNA in the airwaves to allow other changelings to absorb it."

	var/datum/changeling/changeling = changeling_power(10,1)
	if(!changeling)	return

	var/list/names = list()
	for(var/datum/dna/DNA in changeling.absorbed_dna)
		if(!(DNA in hivemind_bank))
			names += DNA.real_name

	if(names.len <= 0)
		src << "<span class='notice'>The airwaves already have all of our DNA.</span>"
		return

	var/S = input("Select a DNA to channel: ", "Channel DNA", null) as null|anything in names
	if(!S)	return

	var/datum/dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	changeling.chem_charges -= 10
	hivemind_bank += chosen_dna
	src << "<span class='notice'>We channel the DNA of [S] to the air.</span>"
	return 1

/mob/proc/changeling_hivedownload()
	set category = "Changeling"
	set name = "Hive Absorb (20)"
	set desc = "Allows you to absorb DNA that is being channeled in the airwaves."

	var/datum/changeling/changeling = changeling_power(20,1)
	if(!changeling)	return

	var/list/names = list()
	for(var/datum/dna/DNA in hivemind_bank)
		if(!(DNA in changeling.absorbed_dna))
			names[DNA.real_name] = DNA

	if(names.len <= 0)
		src << "<span class='notice'>There's no new DNA to absorb from the air.</span>"
		return

	var/S = input("Select a DNA absorb from the air: ", "Absorb DNA", null) as null|anything in names
	if(!S)	return
	var/datum/dna/chosen_dna = names[S]
	if(!chosen_dna)
		return

	changeling.chem_charges -= 20
	changeling.absorbed_dna += chosen_dna
	src << "<span class='notice'>We absorb the DNA of [S] from the air.</span>"
	return 1

// Fake Voice

/mob/proc/changeling_mimicvoice()
	set category = "Changeling"
	set name = "Mimic Voice"
	set desc = "Shape our vocal glands to form a voice of someone we choose. We cannot regenerate chemicals when mimicing."


	var/datum/changeling/changeling = changeling_power()
	if(!changeling)	return

	if(changeling.mimicing)
		changeling.mimicing = ""
		src << "<span class='notice'>We return our vocal glands to their original location.</span>"
		return

	var/mimic_voice = input("Enter a name to mimic.", "Mimic Voice", null) as text
	if(!mimic_voice)
		return

	changeling.mimicing = mimic_voice

	src << "<span class='notice'>We shape our glands to take the voice of <b>[mimic_voice]</b>, this will stop us from regenerating chemicals while active.</span>"
	src << "<span class='notice'>Use this power again to return to our original voice and reproduce chemicals again.</span>"

	spawn(0)
		while(src && src.mind && src.mind.changeling && src.mind.changeling.mimicing)
			src.mind.changeling.chem_charges = max(src.mind.changeling.chem_charges - 1, 0)
			sleep(40)
		if(src && src.mind && src.mind.changeling)
			src.mind.changeling.mimicing = ""
	//////////
	//STINGS//	//They get a pretty header because there's just so fucking many of them ;_;
	//////////

/mob/proc/sting_can_reach(mob/M as mob, sting_range = 1)
	if(M.loc == src.loc) return 1 //target and source are in the same thing
	if(!isturf(src.loc) || !isturf(M.loc)) return 0 //One is inside, the other is outside something.
	if(AStar(src.loc, M.loc, /turf/proc/AdjacentTurfs, /turf/proc/Distance, sting_range)) //If a path exists, good!
		return 1
	return 0

//Handles the general sting code to reduce on copypasta (seeming as somebody decided to make SO MANY dumb abilities)
/mob/proc/changeling_sting(var/required_chems=0, var/verb_path)
	var/datum/changeling/changeling = changeling_power(required_chems)
	if(!changeling)								return

	var/list/victims = list()
	for(var/mob/living/carbon/C in oview(changeling.sting_range))
		victims += C
	var/mob/living/carbon/T = input(src, "Who will we sting?") as null|anything in victims

	if(!T) return
	if(!(T in view(changeling.sting_range))) return
	if(!sting_can_reach(T, changeling.sting_range)) return
	if(!changeling_power(required_chems)) return

	changeling.chem_charges -= required_chems
	changeling.sting_range = 1
	src.verbs -= verb_path
	spawn(10)	src.verbs += verb_path

	src << "<span class='notice'>We stealthily sting [T].</span>"
	if(!T.mind || !T.mind.changeling)	return T	//T will be affected by the sting
	T << "<span class='warning'>You feel a tiny prick.</span>"
	return


/mob/proc/changeling_lsdsting()
	set category = "Changeling"
	set name = "Hallucination Sting (15)"
	set desc = "Causes terror in the target."

	var/mob/living/carbon/T = changeling_sting(15,/mob/proc/changeling_lsdsting)
	if(!T)	return 0
	spawn(rand(300,600))
		if(T)	T.hallucination += 400
	return 1

/mob/proc/changeling_silence_sting()
	set category = "Changeling"
	set name = "Silence sting (10)"
	set desc="Sting target"

	var/mob/living/carbon/T = changeling_sting(10,/mob/proc/changeling_silence_sting)
	if(!T)	return 0
	T.silent += 30
	return 1

/mob/proc/changeling_blind_sting()
	set category = "Changeling"
	set name = "Blind sting (20)"
	set desc="Sting target"

	var/mob/living/carbon/T = changeling_sting(20,/mob/proc/changeling_blind_sting)
	if(!T)	return 0
	T << "<span class='danger'>Your eyes burn horrificly!</span>"
	T.disabilities |= NEARSIGHTED
	spawn(300)	T.disabilities &= ~NEARSIGHTED
	T.eye_blind = 10
	T.eye_blurry = 20
	return 1

/mob/proc/changeling_deaf_sting()
	set category = "Changeling"
	set name = "Deaf sting (5)"
	set desc="Sting target:"

	var/mob/living/carbon/T = changeling_sting(5,/mob/proc/changeling_deaf_sting)
	if(!T)	return 0
	T << "<span class='danger'>Your ears pop and begin ringing loudly!</span>"
	T.sdisabilities |= DEAF
	spawn(300)	T.sdisabilities &= ~DEAF
	return 1

/mob/proc/changeling_paralysis_sting()
	set category = "Changeling"
	set name = "Paralysis sting (30)"
	set desc="Sting target"

	var/mob/living/carbon/T = changeling_sting(30,/mob/proc/changeling_paralysis_sting)
	if(!T)	return 0
	T << "<span class='danger'>Your muscles begin to painfully tighten.</span>"
	T.Weaken(20)
	return 1

/mob/proc/changeling_transformation_sting()
	set category = "Changeling"
	set name = "Transformation sting (40)"
	set desc="Sting target"

	var/datum/changeling/changeling = changeling_power(40)
	if(!changeling)	return 0



	var/list/names = list()
	for(var/datum/dna/DNA in changeling.absorbed_dna)
		names += "[DNA.real_name]"

	var/S = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!S)	return

	var/datum/dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	var/mob/living/carbon/T = changeling_sting(40,/mob/proc/changeling_transformation_sting)
	if(!T)	return 0
	if((HUSK in T.mutations) || (!ishuman(T) && !ismonkey(T)))
		src << "<span class='warning'>Our sting appears ineffective against its DNA.</span>"
		return 0
	T.visible_message("<span class='warning'>[T] transforms!</span>")
	T.dna = chosen_dna
	T.real_name = chosen_dna.real_name
	T.UpdateAppearance()
	domutcheck(T, null)
	return 1

/mob/proc/changeling_unfat_sting()
	set category = "Changeling"
	set name = "Unfat sting (5)"
	set desc = "Sting target"

	var/mob/living/carbon/T = changeling_sting(5,/mob/proc/changeling_unfat_sting)
	if(!T)	return 0
	T << "<span class='danger'>you feel a small prick as stomach churns violently and you become to feel skinnier.</span>"
	T.nutrition -= 100
	if(FAT in T.mutations)
		T.mutations.Remove(FAT)
		T.update_icons()
	return 1

/mob/proc/changeling_DEATHsting()
	set category = "Changeling"
	set name = "Death Sting (40)"
	set desc = "Causes spasms onto death."

	var/mob/living/carbon/T = changeling_sting(40,/mob/proc/changeling_DEATHsting)
	if(!T)	return 0
	T << "<span class='danger'>You feel a small prick and your chest becomes tight.</span>"
	T.silent = 10
	T.Paralyse(10)
	T.Jitter(1000)
	if(T.reagents)	T.reagents.add_reagent("lexorin", 40)
	return 1

/mob/proc/changeling_extract_dna_sting()
	set category = "Changeling"
	set name = "Extract DNA Sting (40)"
	set desc="Stealthily sting a target to extract their DNA."

	var/datum/changeling/changeling = null
	if(src.mind && src.mind.changeling)
		changeling = src.mind.changeling
	if(!changeling)
		return 0

	var/mob/living/carbon/T = changeling_sting(40, /mob/proc/changeling_extract_dna_sting)
	if(!T)	return 0

	T.dna.real_name = T.real_name
	changeling.absorbed_dna |= T.dna

	return 1
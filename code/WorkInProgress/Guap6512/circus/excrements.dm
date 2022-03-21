/*#####SHIT AND PISS#####*/

//####DEFINES####
/mob
	var/bladder = 0
	var/bowels = 0

//#####DECALS#####




/obj/effect/decal/cleanable/poo
	name = "poo stain"
	desc = "Well that sinks."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/effects/pooeffect.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7", "floor8")
	var/dried = 0
	cleanable = 1

/obj/effect/decal/cleanable/poo/old/New()
	dried = TRUE
	..()

/obj/effect/decal/cleanable/poo/Crossed(AM as mob|obj)
	if(iscarbon(AM))
		var/mob/living/carbon/M = AM
		if(prob(5))
			M.stumble(1,src)
	else
		return

/obj/effect/decal/cleanable/poo/New()
	icon = 'icons/effects/pooeffect.dmi'
	icon_state = pick(src.random_icon_states)
	processing_objects.Add(src)
	for(var/obj/effect/decal/cleanable/poo/shit in src.loc)
		if(shit != src)
			qdel(shit)
	spawn(2400)
		dried = 1
		processing_objects.Remove(src)
		name = "dried poo stain"
		desc = "It's a dried poo stain..."


/obj/effect/decal/cleanable/poo/tracks
	icon_state = "tracks"
	random_icon_states = null

/obj/effect/decal/cleanable/poo/drip
	name = "drips of poo"
	desc = "It's brown."
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/pooeffect.dmi'
	icon_state = "drip1"
	random_icon_states = list("drip1", "drip2", "drip3", "drip4", "drip5")

//This proc is really deprecated.
/*/obj/effect/decal/cleanable/poo/proc/streak(var/list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			if (i > 0)
				new /obj/effect/decal/cleanable/poo(src.loc)
			if (step_to(src, get_step(src, direction), 0))
				break
*/

/obj/effect/decal/cleanable/poo/Crossed(AM as mob|obj, var/forceslip = 0)
	if (istype(AM, /mob/living/carbon) && src.dried == 0)
		var/mob/living/carbon/M = AM
		if (M.m_intent == "walk")
			return

		if(prob(5))
			M.slip("poo")

//These aren't needed for now.
///obj/effect/decal/cleanable/poo/tracks/Crossed(AM as mob|obj)
//	return

//obj/effect/decal/cleanable/poo/drip/Crossed(AM as mob|obj)
//	return

/obj/effect/decal/cleanable/urine
	name = "urine stain"
	desc = "Someone couldn't hold it.."
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/pooeffect.dmi'
	icon_state = "pee1"
	random_icon_states = list("pee1", "pee2", "pee3")
	var/dried
	cleanable = 1

/obj/effect/decal/cleanable/urine/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M =	AM

		for(var/obj/item/weapon/shield/generator/G in M.contents)
			if(G.active)
				G.failure(M)

		if((!dried) && prob(5))
			M.stumble(1,src)

/obj/effect/decal/cleanable/urine/New()
	icon_state = pick(random_icon_states)
	//spawn(10) src.reagents.add_reagent("urine",5)

	spawn(800)
		dried = 1
		name = "dried urine stain"
		desc = "That's a dried crusty urine stain. Fucking janitors."
	..()

//#####REAGENTS#####

//SHIT
/datum/reagent/poo
	name = "poo"
	id = "poo"
	description = "It's poo."
	reagent_state = LIQUID
	color = "#643200"


/datum/reagent/poo/on_mob_life(var/mob/living/M)
	if(!M)
		M = holder.my_atom

	M.adjustToxLoss(0.1)
	holder.remove_reagent(src.id, 0.2)
	..()
	return


/datum/reagent/poo/reaction_turf(var/turf/T)
	new /obj/effect/decal/cleanable/poo(T)

/datum/reagent/urine
	name = "urine"
	id = "urine"
	description = "It's pee."
	reagent_state = LIQUID
	color = COLOR_YELLOW
	var/dried = 0

/datum/reagent/urine/on_mob_life(var/mob/living/M)
	if(!M)
		M = holder.my_atom

	M.adjustToxLoss(0.1)
	holder.remove_reagent(src.id, 0.2)
	..()
	return

/obj/item/weapon/reagent_containers/food/snacks/poo
	name = "poo"
	desc = "A chocolately surprise!"
	icon = 'icons/obj/poop.dmi'
	icon_state = "poop2"
	item_state = "poop"
	New()
		..()
		icon_state = pick("poop1", "poop2", "poop3", "poop4", "poop5", "poop6", "poop7")
		reagents.add_reagent("poo", 10)
		bitesize = 3
		processing_objects.Add(src)

	throw_impact(atom/hit_atom)
		//..()
		//if(reagents.total_volume)
		//	src.reagents.handle_reactions()
		playsound(src.loc, "sound/effects/squishy.ogg", 40, 1)
		processing_objects.Remove(src)
		var/turf/T = src.loc
		if(!istype(T, /turf/space))
			new /obj/effect/decal/cleanable/poo(T)
		qdel(src)
		..()
//#####BOTTLES#####

//PISS
/obj/item/weapon/reagent_containers/glass/bottle/urine
	name = "urine bottle"
	desc = "A small bottle. Contains urine."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	New()
		..()
		reagents.add_reagent("urine", 30)


//#####LIFE PROCS#####

//poo and pee counters. This is called in human/handle_stomach.
/mob/living/carbon/human/proc/handle_excrement()
	if(bowels <= 0)
		bowels = 0
	if(bladder <= 0)
		bladder = 0

	if(bowels >= 250)
		switch(bowels)
			if(250 to 400)
				if(prob(5))
					to_chat(src, "<span class='graytextsmaller'>I need to use the bathroom.</span>")
			if(400 to 450)
				if(prob(5))
					to_chat(src, "<span class='graytextboldnotoutlined'>I really need to use the bathroom!</span>")
			if(450 to 500)
				if(prob(2))
					handle_shit()
				else if(prob(10))
					to_chat(src, "<span class='graytextbold'>I'm about to shit myself!</span>")
			if(500 to INFINITY)
				if(prob(15))
					handle_shit()
				else if(prob(30))
					to_chat(src, "<span class='graytextboldbigger'>OH [uppertext(god_text())] I HAVE TO SHIT!</span>")

	if(bladder >= 100)//Your bladder is smaller than your colon
		switch(bladder)
			if(100 to 250)
				if(prob(5))
					to_chat(src, "<span class='graytextsmaller'>I need to use the bathroom.</span>")
			if(250 to 400)
				if(prob(5))
					to_chat(src, "<span class='graytextboldnotoutlined'>I really need to use the bathroom!</span>")
			if(400 to 500)
				if(prob(2))
					handle_piss()
				else if(prob(10))
					to_chat(src, "<span class='graytextbold'>I'm about to piss myself!</span>")
			if(500 to INFINITY)
				if(prob(15))
					handle_piss()
				else if(prob(30))
					to_chat(src, "<span class='graytextboldbigger'>OH[uppertext(god_text())] I HAVE TO PEE!</span>")


//Shitting
/mob/living/carbon/human/proc/handle_shit()
	var/message = null
	//var/mob/living/carbon/human/H = usr
	if (src.bowels >= 30)

		//Poo in the loo.
		var/obj/structure/toilet/T = locate() in src.loc
		var/mob/living/M = locate() in src.loc
		var/obj/item/weapon/reagent_containers/glass/G = locate() in src.loc
		if(species && species.has_organ["stomach"])
			var/datum/organ/internal/stomach/L = internal_organs_by_name["stomach"]
			if(!L)
				src.drip(20)
				setHalLoss(15)
			if(L)
				if(L.is_broken())
					L.take_damage(rand(2,3))
					src.drip(10)
					setHalLoss(5)
				else if(L.is_bruised())
					L.take_damage(rand(1,3))
					src.drip(5)
					setHalLoss(2)

		if(species && species.has_organ["guts"])
			var/datum/organ/internal/guts/L = internal_organs_by_name["guts"]
			if(!L)
				src.drip(20)
				setHalLoss(15)
			if(L)
				if(L.is_broken())
					L.take_damage(rand(2,3))
					src.drip(10)
					setHalLoss(5)
				else if(L.is_bruised())
					L.take_damage(rand(1,3))
					src.drip(5)
					setHalLoss(2)

		if(T && T.open)
			message = "<span class='looksatbold'>⠀[src]</span> <span class='looksat'>defecates into the [T].</span>"

		else if(w_uniform)
			message = "<span class='looksatbold'>⠀⠀[src]</span> <span class='looksat'>shits their pants.</span>"
			reagents.add_reagent("poo", 10)
			adjust_hygiene(-25)
			add_event("embarassment", /datum/happiness_event/hygiene/shit)


		//Poo on the face.
		else if(M != src && M.lying)//Can only shit on them if they're lying down.
			message = "<span class='looksatbold'>⠀[src]</span> <span class='looksat'>shits right on</span> <span class='looksatbold'>[M]'s</span> <span class='looksat'>face!</span>"
			M.reagents.add_reagent("poo", 10)

		else if(G && !G.reagents.total_volume != G.reagents.maximum_volume)
			G.reagents.add_reagent("poo", 10)
			G.update_icon()
			message = "<span class='looksatbold'>⠀[src]</span> <span class='looksat'>defecates into the [G].</span>"

		//Poo on the floor.
		else
			message = "<span class='looksatbold'>⠀[src]</span> <span class='looksat'>[pick("shits", "craps", "poops")].</span>"
			var/turf/location = src.loc
			//var/obj/effect/decal/cleanable/poo/D = new/obj/effect/decal/cleanable/poo(location)
			//if(src.reagents)//No need to spawn the snack poo and the decal.
			//	src.reagents.trans_to(D, rand(1,5))


			if(goldXoomed)
				var/typeCoin = pick("/gold", "/silver", "")
				var/amount = rand(1, 20)
				var/path = text2path("/obj/item/weapon/spacecash[typeCoin]/c[amount]")
				new path(location)
			else
				var/obj/item/weapon/reagent_containers/food/snacks/poo/V = new/obj/item/weapon/reagent_containers/food/snacks/poo(location)
				if(src.reagents)
					src.reagents.trans_to(V, rand(1,5))

		playsound(src.loc, 'sound/effects/poo2.ogg', 60, 1)
		src.bowels -= rand(80,120)

	else
		to_chat(src, "<span class='graytextsmaller'>⠀⠀I don't need to.</span>")
		return

	visible_message("[message]")

//Peeing
/mob/living/carbon/human/proc/handle_piss()
	var/message = null
	if (src.bladder < 30)
		to_chat(src, "<span class='graytextsmaller'>⠀⠀I don't need to.</span>")
		return

	var/obj/structure/urinal/U = locate() in src.loc
	var/obj/structure/toilet/T = locate() in src.loc
	var/obj/structure/sink/S = locate() in src.loc
	var/obj/item/weapon/reagent_containers/glass/G = locate() in src.loc
	if(U || S || T)//In the urinal or sink.
		message = "<span class='looksatbold'>⠀[src]</span> <span class='looksat'>urinates into the [U ? U : T ? T : S ? S : "something"].</span>"
		src.reagents.remove_any(rand(1,8))
		src.bladder -= rand(300,400)
	else if(w_uniform)
		src.loc:add_fluid(src.loc, 3, "urine")
		message = "<span class='looksatbold'>⠀[src]</span> <span class='looksat'>pissed their pants.</span>"
		adjust_hygiene(-10)
		add_event("embarassment2", /datum/happiness_event/hygiene/pee)
		src.bladder -= rand(200,300)
	else if(G && !G.reagents.total_volume != G.reagents.maximum_volume)
		G.reagents.add_reagent("urine", 10)
		G.update_icon()
		src.bladder -= rand(200,300)
		message = "<span class='looksatbold'>⠀[src]</span> <span class='looksat'>pisses on the [G].</span>"
	else
		src.loc:add_fluid(src.loc, 5, "urine")
		message = "<span class='looksatbold'>⠀[src]</span> <span class='looksat'>pisses on the [src.loc:name].</span>"
		src.bladder -= rand(300,400)
	visible_message("[message]")

/obj/effect/decal/cleanable/cum
	name = "cream"
	desc = "It's pie cream from a cream pie. Or not..."
	density = 0
	layer = 2
	icon = 'honk/icons/effects/cum.dmi'
	blood_DNA = list()
	anchored = 1
	cleanable = 1
	random_icon_states = list("cum1", "cum3", "cum4", "cum5", "cum6", "cum7", "cum8", "cum9", "cum10", "cum11", "cum12")


/obj/effect/decal/cleanable/cum/New()
	..()
	icon_state = pick(random_icon_states)
	for(var/obj/effect/decal/cleanable/cum/jizz in src.loc)
		if(jizz != src)
			qdel(jizz)
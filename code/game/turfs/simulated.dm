/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/metal_sound = FALSE

/turf/simulated/New()
	..()
	levelupdate()

/turf/simulated/proc/AddTracks(var/typepath,var/bloodDNA,var/comingdir,var/goingdir,var/bloodcolor="#A10808")
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodcolor)

/turf/simulated/Entered(atom/A, atom/OL)
	if (istype(A,/mob/living/carbon))
		var/mob/living/carbon/M = A
		if(M.lying)
			return ..()

		if(istype(A,/mob/living/carbon/alien))
			playsound(src, pick('minialien_walk.ogg'), 75, 0)


		if(istype(M, /mob/living/carbon/human)) //human footsteps
			var/footstepsound
			var/mob/living/carbon/human/H = M
			//Shoe sounds
			if 		(istype(src, /turf/simulated/floor/plating/dirt))
				footstepsound = "dirtfootsteps"
				for(var/atom/movable/AA in H.loc.contents)
					if(istype(AA,/obj/train))
						footstepsound = "lifewebfootsteps"
			else 	if(istype(src, /turf/simulated/floor/beach/water))
				footstepsound = "footsteps_water"
			else	if(istype(src, /turf/simulated/floor/exoplanet/water/shallow))
				footstepsound = "footsteps_water"
			else	if(istype(src, /turf/simulated/floor/deepwater))
				footstepsound = "swimwater"
			else	if(istype(src, /turf/simulated/floor/lifeweb/stone))
				footstepsound = "stonesound"
			else	if(istype(src, /turf/simulated/floor/lifeweb/wood))
				footstepsound = "footsteps_wood"
			else 	if(istype(src, /turf/simulated/floor/wood))
				footstepsound = "footsteps_wood"
			else 	if(istype(src, /turf/simulated/floor/carpet))
				footstepsound = "footsteps_carpet"
			else	if(istype(src, /turf/simulated/floor/plating/snow))
				footstepsound = "footsteps_snow"
			else	if(istype(src, /turf/simulated/floor/os13/carpet2))
				footstepsound = "footsteps_carpet"
			else	if(istype(src, /turf/simulated/floor/plating/dirt_path))
				footstepsound = "dirtfootsteps"
			else	if(istype(src, /turf/simulated/floor/plating/dirt2))
				footstepsound = "dirtfootsteps"
			else	if(istype(src, /turf/simulated/floor/lifeweb))
				footstepsound = "lifewebfootsteps"
			else
				footstepsound = "lifewebfootsteps"
			if(src.liquid)
				footstepsound = "footsteps_water"
				switch(src.liquid.depth)
					if(0 to 45)
						footstepsound = "footsteps_water"
					if(45 to 9999)
						footstepsound = "slosh"

			for(var/obj/structure/stool/bed/weeds/W in H.loc.contents)
				footstepsound = "dirtfootsteps"

			if(istype(H.shoes, /obj/item/clothing/shoes/lw/clown_shoes))
				footstepsound = "clownstep"

			if(istype(H.shoes, /obj/item/clothing/shoes/lw/soulbreaker))
				footstepsound = "erikafootsteps"

			if(metal_sound)
				footstepsound = "metalzao"
			// LISTA DE ICONS QUE FAZEM SOM DE METAL
			var/list/ICONESMETAL = list("alien","plating","shuttle3","shuttle4")
			if(src.icon_state in ICONESMETAL)
				footstepsound = "metalzao"
				metal_sound = TRUE

			if(istype(H.shoes, /obj/item/clothing/shoes) && !H.throwing)//This is probably the worst possible way to handle walking sfx.
				if(H.m_intent == "run")
					if(H.footstep >= 1)//Every two steps.
						H.footstep = 0
						if(istype(H.shoes, /obj/item/clothing/shoes/lw/jester_court) || istype(H.shoes, /obj/item/clothing/shoes/lw/jester_shoes))
							H.visible_message("<span class='passivebold'>[H.name]</span><span class='passive'> shakes the bells!</span>")
							if(prob(50))
								footstepsound = "jesterbig"
							else
								footstepsound = "jestermedium"
						playsound(src, footstepsound, 80, 1)
					else
						H.footstep++
				else
					if(H.footstep >= 6)
						H.footstep = 0
						if(istype(H.shoes, /obj/item/clothing/shoes/lw/jester_court || /obj/item/clothing/shoes/lw/jester_shoes))
							footstepsound = "jestersmall"
						playsound(src, footstepsound, 80, 1)
					else
						H.footstep++

			if(!H.shoes && !H.throwing)
				if(H.m_intent == "run")
					if(H.footstep >= 1)//Every two steps.
						H.footstep = 0
						if(metal_sound)
							playsound(src, pick('step_baremetal1.ogg','step_baremetal2.ogg','step_baremetal3.ogg','step_baremetal4.ogg'), 75, 0)
						else
							if(istype(H?.species, /datum/species/human/alien))
								playsound(src, pick('alien_step1.ogg','alien_step2.ogg', 'alien_step3.ogg', 'alien_step4.ogg'), 75, 0)
							else
								playsound(src, pick('barestep1.ogg','barestep2.ogg'), 75, 0)
					else
						H.footstep++
				else
					if(H.footstep >= 6)
						H.footstep = 0
						if(metal_sound)
							playsound(src, pick('step_baremetal1.ogg','step_baremetal2.ogg','step_baremetal3.ogg','step_baremetal4.ogg'), 75, 0)
						else
							if(istype(H?.species, /datum/species/human/alien))
								playsound(src, pick('alien_step1.ogg','alien_step2.ogg', 'alien_step3.ogg', 'alien_step4.ogg'), 75, 0)
							else
								playsound(src, pick('barestep1.ogg','barestep2.ogg'), 75, 0)
					else
						H.footstep++

			// Tracking blood
			var/list/bloodDNA = null
			var/bloodcolor=""
			if(H.shoes)
				var/obj/item/clothing/shoes/S = H.shoes
				if(S.track_blood && S.blood_DNA)
					bloodDNA = S.blood_DNA
					bloodcolor=S.blood_color
					S.track_blood--
			else
				if(H.track_blood && H.feet_blood_DNA)
					bloodDNA = H.feet_blood_DNA
					bloodcolor=H.feet_blood_color
					H.track_blood--

			if (bloodDNA)
				src.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,H.dir,0,bloodcolor) // Coming
				var/turf/simulated/from = get_step(H,reverse_direction(H.dir))
				if(istype(from) && from)
					from.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,0,H.dir,bloodcolor) // Going

				bloodDNA = null

			if(H.wear_suit)
				var/obj/item/clothing/suit/armor/vest/K = H.wear_suit
				if(istype(K))
					K.handle_movement(src, H.m_intent)

		switch (src.wet)
			if(1)
				if(!M.slip(4, 2, null, (NO_SLIP_WHEN_WALKING|STEP)))
					M.inertia_dir = 0
				return

			if(2) //lube                //can cause infinite loops - needs work
				M.slip(0, 7, null, (STEP|SLIDE|GALOSHES_DONT_HELP))
				M.Weaken(10)
			if(3) // Ice
				if(istype(M, /mob/living/carbon/human)) // Added check since monkeys don't have shoes
					if ((M.m_intent == "run") && !(istype(M:shoes, /obj/item/clothing/shoes) && M:shoes.flags&NOSLIP) && prob(30))
						M.stop_pulling()
						step(M, M.dir)
						M << "\blue You slipped on the icy floor!"
						playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
						M.Stun(4)
						M.Weaken(3)
					else
						M.inertia_dir = 0
						return

	..()

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(M))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			if(!B.blood_DNA)
				B.blood_DNA = list()
			if(!B.blood_DNA[M.dna.unique_enzymes])
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
				B.virus2 = virus_copylist(M.virus2)
			return 1 //we bloodied the floor
		blood_splatter(src,M.get_blood(M.vessel),1)
		return 1 //we bloodied the floor
	return 0


// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M as mob)
	if(istype(M, /mob/living/carbon/monkey))

		var/obj/effect/decal/cleanable/blood/this = PoolOrNew(/obj/effect/decal/cleanable/blood, src)
		this.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
		this.basecolor = "#A10808"
		this.update_icon()

	else if(istype(M,/mob/living/carbon/human))

		var/obj/effect/decal/cleanable/blood/this = PoolOrNew(/obj/effect/decal/cleanable/blood, src)
		var/mob/living/carbon/human/H = M

		//Species-specific blood.
		if(H.species)
			this.basecolor = H.species.blood_color
		else
			this.basecolor = "#A10808"
		this.update_icon()

		this.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type

	else if( istype(M, /mob/living/carbon/alien ))
		var/obj/effect/decal/cleanable/blood/xeno/this = new /obj/effect/decal/cleanable/blood/xeno(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"

	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/effect/decal/cleanable/blood/oil(src)

/turf/simulated/proc/gets_dug()
	return

/turf/simulated/proc/GetDrilled()
	return
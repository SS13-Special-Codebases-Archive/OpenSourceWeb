
/mob/living/carbon/human/proc/handle_vice()
	if(vice)
		if(viceneed < 1000)
			spawn(10)
				viceneed += rand(1,2)
				clear_event("vice")

	if(viceneed > 1000)
		viceneed = 1000

	if(viceneed >= 1000)
		switch(vice)
			if("Smoker")
				add_event("vice", /datum/happiness_event/vice/smoke)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need a smoke. +</span><br>")
			if("Pothead")
				add_event("vice", /datum/happiness_event/vice/weed)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need a hit. +</span><br>")
			if("Pyromaniac")
				add_event("vice", /datum/happiness_event/vice/pyromaniac)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need to see the world burn. +</span><br>")
			if("Kleptomaniac")
				add_event("vice", /datum/happiness_event/vice/klepto)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need to steal from someone. +</span><br>")
			if("Photographer")
				add_event("vice", /datum/happiness_event/vice/photo)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need to take a picture of someone. +</span><br>")
			if("Addict (Kisses)")
				add_event("vice", /datum/happiness_event/vice/kiss)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need a kiss. +</span><br>")
			if("Necrophile")
				if(src.age > 17)
					add_event("vice", /datum/happiness_event/vice/necro)
					if(sleeping) return

					if(prob(1))
						to_chat(src, "<br><span class='graytextbold'>⠀+ I need someone more rotten than me. +</span><br>")
			if("Sexoholic")
				if(src.age > 17)
					add_event("vice", /datum/happiness_event/vice/sexo)
					if(sleeping) return

					if(prob(1))
						to_chat(src, "<br><span class='graytextbold'>⠀+ I need to sate my desires. +</span><br>")
			
			if("Voyeur")
				if(src.age > 17)
					add_event("vice", /datum/happiness_event/vice/voyeur)
					if(sleeping) return

					if(prob(1))
						to_chat(src, "<br><span class='graytextbold'>⠀+ I need to watch someone do it. +</span><br>")

			if("Alcoholic")
				add_event("vice", /datum/happiness_event/vice/alco)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need a drink. +</span><br>")
			if("Addict (Buffout)")
				add_event("vice", /datum/happiness_event/vice/buff)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need to take buffout. +</span><br>")
			if("Addict (Mentats)")
				add_event("vice", /datum/happiness_event/vice/ment)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need to take mentats. +</span><br>")
			if("Addict (Heroin)")
				add_event("vice", /datum/happiness_event/vice/heroin)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need a hit. +</span><br>")
			if("Addict (Stimulants)")
				add_event("vice", /datum/happiness_event/vice/stimulants)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need to be alive. +</span><br>")
			if("Masochist")
				add_event("vice", /datum/happiness_event/vice/maso)
				if(sleeping) return

				if(prob(1))
					to_chat(src, "<br><span class='graytextbold'>⠀+ I need to feel pain! +</span><br>")

/mob/living/carbon/human/proc/handle_reflect()
	if(can_reflect == FALSE)
		return
	if(reflectneed < 750)
		spawn(10)
			reflectneed += rand(1,2)
			clear_event("reflect")
			src.verbs -= /mob/living/carbon/human/proc/reflectexperience

	if(reflectneed > 750)
		reflectneed = 750
		src.verbs += /mob/living/carbon/human/proc/reflectexperience
		spawn(80)
			src.updatePig()

	if(reflectneed >= 750)
		add_event("reflect", /datum/happiness_event/reflect)
		src.verbs += /mob/living/carbon/human/proc/reflectexperience
		if(sleeping) return
		if(prob(1))
			to_chat(src, "<br><span class='graytextbold'>⠀+ I need to reflect my experience. +</span><br>")
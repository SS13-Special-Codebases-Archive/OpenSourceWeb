/mob/living/carbon/human/verb/asktostop()
	set name = ".asktostop"
	emote("stop")

/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null, var/cooldown = 0.5)
	var/param = null

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's  unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	//var/m_type = 1

	for (var/obj/item/weapon/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	if(src.stat == 2.0 && (act != "deathgasp"))
		return

	if(istype(src?.species, /datum/species/human/alien))
		playsound(src.loc, 'alien_seeks.ogg', 100, 0)
		return

	if(emote_cooldown > 0)
		return

	var/list/listening = list()
	var/list/listening_obj = list()
	var/turf/T = get_turf(src)
	var/list/hear = hear(7, T)
	var/list/hearturfs = list()

	for(var/I in hear)
		if(istype(I, /mob/))
			var/mob/M = I
			listening += M
			hearturfs += M.locs[1]
			for(var/obj/O in M.contents)
				listening_obj |= O
		else if(istype(I, /obj/))
			var/obj/O = I
			hearturfs += O.locs[1]
			listening_obj |= O

	switch(act)

		if ("blink")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>blinks.</span>"
			m_type = 1

		if ("praise")
			if(religion == "Heresy")
				return //didnt load yet
			if(religion == "Thanati")
				message = "<span class='examinebold'>[src]</span> <span class='examine'>calls for Tzchernobog!</span>"
				call_sound_emote("praise")
				for(var/mob/living/carbon/human/H in view(7, src))
					if(H.religion == "Gray Church")
						src.seen_me_doing_heresy.Add(H)
				m_type = 2
			else if(religion == "Allah")
				message = "<span class='examinebold'>[src]</span> <span class='examine'>calls for Allah!</span>"
				call_sound_emote("praise")
				m_type = 2
			else if(religion == "ConsCult")
				message = "<span class='examinebold'>[src]</span> <span class='examine'>nods sagely.</span>"
				m_type = 1
			else if(religion == "Old Ways")
				message = "<span class='examinebold'>[src]</span> <span class='examine'>throw \his hands up in a sacred salute!</span>"
				m_type = 1
			else
				if(src.religion_is_legal())
					for(var/mob/living/carbon/human/H in view(1,src.loc))
						if(!H.religion_is_legal() || H.stat != DEAD)
							continue
						src.visible_message("<span class='examinebold'>[src]</span> <span class='examine'>crosses [H]!</span>")
						m_type = 1
						H.time_since_death = 0
						break
				if(gender == MALE)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>crosses himself!</span>"
					m_type = 1
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>crosses herself!</span>"
					m_type = 1


		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>bows to</span> <span class='examinebold'>[param]</span><span class='examine'>.</span>"
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>bows.</span>"
			m_type = 1

		if ("custom")
			var/input = sanitize(input("Choose an emote to display.") as text|null)
			if (!input)
				return
			var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
			if (input2 == "Visible")
				m_type = 1
			else if (input2 == "Hearable")
				if (src.miming)
					return
				m_type = 2
			else
				alert("Unable to use this emote, must be either hearable or visible.")
				return
			return custom_emote(m_type, message)

		if ("me")
			if(silent)
				return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "\red You cannot send IC messages (muted)."
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			return custom_emote(m_type, message)

		if ("salute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<span class='examinebold>[src]</span> <span class='examine'>salutes to</span> <span class='examinebold'>[param]</span><span class='examine'>.</span>"
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>salutes.</span>"
			m_type = 1

		if ("clap")
			if (!src.restrained())
				message = "<span class='examinebold'>[src]</span> <span class='examine'>claps.</span>"
				m_type = 2
				call_sound_emote("clap")
				if(miming)
					m_type = 1


		if ("drool")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>drools.</span>"
			m_type = 1

		if ("eyebrow")
			message = "<span class='examinebold'>[src]</span> <span class='examne'>raises an eyebrow.</span>"
			m_type = 1

		if ("chuckle")
			if(miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>appears to chuckle.</span>"
				m_type = 1
			else
				if (!muzzled)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>chuckles.</span>"
					m_type = 2
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a noise.</span>"
					m_type = 2

		if ("cough")
			if(miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>appears to cough!</span>"
				m_type = 1
			else
				if (!muzzled)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>coughs!</span>"
					m_type = 2
					call_sound_emote("cough")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a strong noise.</span>"
					m_type = 2

		if ("frown")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>frowns.</span>"
			m_type = 1

		if ("nod")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>nods.</span>"
			m_type = 1
			if(length(my_skills.prepare_learn))
				for(var/t in my_skills.prepare_learn)
					var/list/TC = my_skills.prepare_learn[t]
					src.learn_skill(TC[1], TC[2], TC[3])
					my_skills.prepare_learn.Remove(t)

		if ("blush")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>blushes.</span>"
			m_type = 1

		if ("wave")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>waves.</span>"
			m_type = 1

		if ("gasp")
			if(miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>appears to be gasping!</span>"
				m_type = 1
			else
				if (!muzzled)
					message = "<span class='examinebold'><small>[src]</small></span> <span class='examine'><small>gasps!</small></span>"
					m_type = 2
					call_sound_emote("gasp")
				else
					message = "<span class='examinebold'><small>[src]</small></span> <span class='examine'><small>makes a weak noise.</small></span>"
					m_type = 2

		if ("1shotbreath")
			if(miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>appears to be gasping!</span>"
				m_type = 1
			else
				if (!muzzled)
					message = "<span class='examinebold'><small>[src]</small></span> <span class='examine'><small>makes a weak noise.</small></span>"
					m_type = 2
					call_sound_emote("1shotbreath")
				else
					message = "<span class='examinebold'><small>[src]</small></span> <span class='examine'><small>makes a weak noise.</small></span>"
					m_type = 2

		if ("coughwounded")
			if(miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>appears to cough!</span>"
				m_type = 1
			else
				if (!muzzled)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>coughs blood!</span>"
					m_type = 2
					call_sound_emote("coughwounded")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a strong noise.</span>"
					m_type = 2

		if ("giggle")
			if(miming)
				message = "<span class='examinebold'><small>[src]</small></span> <span class='examine'><small>giggles silently!</small></span>"
				m_type = 1
			else
				if (!muzzled)
					message = "<span class='examinebold'><small>[src]</small></span> <span class='examine'>giggles.</span>"
					m_type = 2
					call_sound_emote("giggle")
				else
					message = "<span class='examinebold'><small>[src]</small></span> <span class='examine'><small>makes a noise.</small></span>"
					m_type = 2

		if ("glare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>glares at</span> <span class='examinebold'>[param]</span><span class='examine'>.</span>"
			else
				message = "<span class='examinebold'>[src]</span> <span class='examine'>glares.</span>"

		if ("stare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<span class='examinebold'><smaller>[src]</smaller></span> <span class='examine'><smaller>stares at</smaller></span> <span class='examinebold'><smaller>[param]</smaller></span><span class='examine'><smaller>.</smaller></span>"
			else
				message = "<span class='examinebold'><smaller>[src]</smaller></span> <span class='examine'><smaller>stares.</smaller></span>"

		if ("look")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if (!M)
				param = null

			if (param)
				message = "<span class='looksatbold'>[src]</span> <span class='looksat'>looks at</span> <span class='looksatbold'>[param]</span><span class='looksat'>.</span>"
			else
				message = "<span class='looksatbold'>[src]</span> <span class='looksat'>looks.</span>"
			m_type = 1

		if ("grin")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>grins.</span>"
			m_type = 1

		if ("krak")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>cracks knuckles.</span>"
			call_sound_emote("krak")
			m_type = 2

		if ("whistle")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>whistles.</span>"
			call_sound_emote("whistle")
			m_type = 2

		if ("finger")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>snaps.</span>"
			call_sound_emote("finger")
			m_type = 2

		if ("cry")
			if(miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>cries.</span>"
				m_type = 1
			else
				if (!muzzled)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>cries.</span>"
					call_sound_emote("cry")
					m_type = 2
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a weak noise. \He frowns.</span>"
					m_type = 2

		if ("sigh")
			if(miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>sighs.</span>"
				m_type = 1
			else
				if (!muzzled)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>sighs.</span>"
					m_type = 2
					call_sound_emote("sigh")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a weak noise.</span>"
					m_type = 2

		if ("laugh")
			if(miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>acts out a laugh.</span>"
				m_type = 1
			else
				if (!muzzled)
					if (stat)
						return
					message = "<span class='examinebold'>[src]</span> <span class='examine'>laughs.</span>"
					m_type = 2
					call_sound_emote("laugh")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a noise.</span>"
					m_type = 2

		if ("clearthroat")
			if (!muzzled)
				if (stat)
					return
				message = "<span class='examinebold'>[src]</span> <span class='examine'>clears \his throat.</span>"
				m_type = 2
				call_sound_emote("clearthroat")
			else
				message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a noise.</span>"
				m_type = 2

		if ("mumble")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>mumbles!</span>"
			m_type = 2
			if(miming)
				m_type = 1

		if ("grumble")
			if(miming)
				message = "<B>[src]</B> grumbles!"
				m_type = 1
			if (!muzzled)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>grumbles!</span>"
				m_type = 2
			else
				message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a noise.</span>"
				m_type = 2

		if ("groan")
			if(miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>appears to groan!</span>"
				m_type = 1
			else
				if (!muzzled)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>groans!</span>"
					m_type = 2
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a loud noise.</span>"
					m_type = 2

		if ("moan")
			if(miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>appears to moan!</span>"
				m_type = 1
			else
				message = "<span class='examinebold'>[src]</span> <span class='examine'>moans!</span>"
				m_type = 2

		if ("point")
			if (!src.restrained())
				var/mob/M = null
				if (param)
					for (var/atom/A as mob|obj|turf|area in view(null, null))
						if (param == A.name)
							M = A
							break

				if (!M)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>points.</span>"
				else
					M.point()

				if (M)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>points to</span> <span class='examinebold'>[M]</span><span class='examine'>.</span>"
				else
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "<span class='examinebold'>[src]</span> <span class='examine'>raises a hand.</span>"
			m_type = 1

		if("shake")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>shakes \his head.</span>"
			m_type = 1

		if ("shrug")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>shrugs.</span>"
			m_type = 1

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<span class='examinebold'>[src]</span> <span class='examine'>raises [t1] finger\s.</span>"
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<span class='examinebold'>[src]</span> <span class='examine'>raises [t1] finger\s.</span>"
			m_type = 1

		if ("smile")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>smiles.</span>"
			m_type = 1

		if ("shiver")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>shivers.</span>"
			m_type = 2
			if(miming)
				m_type = 1

		if ("pale")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>goes pale for a second.</span>"
			m_type = 1

		if ("tremble")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>trembles in fear!</span>"
			m_type = 1

		if ("sneeze")
			if (miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>sneezes.</span>"
				call_sound_emote("sneeze")
				m_type = 2
			else
				if (!muzzled)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>sneezes.</span>"
					m_type = 2
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a strange noise.</span>"
					m_type = 2

		if ("sniff")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>sniffs.</span>"
			m_type = 2
			if(miming)
				m_type = 1

		if ("snore")
			if (miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>sleeps soundly.</span>"
				m_type = 1
			else
				if (!muzzled)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>snores.</span>"
					m_type = 2
					call_sound_emote("snore")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a noise.</span>"
					m_type = 2

		if ("whimper")
			if (miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>appears hurt.</span>"
				m_type = 1
			else
				if (!muzzled)
					message = "<span class='examinebold'>[src]</span> <span class='examine'>whimpers.</span>"
					m_type = 2
					call_sound_emote("whimper")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a weak noise.</span>"
					m_type = 2

		if ("hem")
			if (!muzzled)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>hems.</span>"
				m_type = 2
				call_sound_emote("hem")

		if ("slap")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>slaps his own face.</span>"
			m_type = 1

		if ("wink")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>winks.</span>"
			m_type = 1

		if ("licklips")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>licks \his lips.</span>"
			m_type = 1

		if ("licklip")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>licks \his lips.</span>"
			m_type = 1

		if ("yawn")
			if (!muzzled)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>yawns.</span>"
				m_type = 2
				call_sound_emote("yawn")
				if(miming)
					m_type = 1

		if("hug")
			m_type = 1
			if (!src.restrained())
				src.hug()

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<span class='examinebold'>[src]</span> <span class='examine'>shakes hands with</span> <span class='examinebold>'[M]</span><span class='examine'>.</span>"
					else
						message = "<span class='examinebold'>[src]</span> <span class='examine'>holds out \his hand to</span> <span class='examinebold'>[M]</span><span class='examine'>.</span>"

		if ("scream")
			if (miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>acts out a scream!</span>"
				m_type = 1
			else
				if (!muzzled)//NO MORE SCREAMING FROM DEAD AND UNCONCIOUS PEOPLE PLEASE!
					if (stat)
						return
					message = "<span class='examinebold'>[src]</span> <span class='examine'>screams!</span>"
					m_type = 2
					call_sound_emote("scream")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a very loud noise.</span>"
					m_type = 2

		if ("torturescream")
			if (miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>acts out a scream!</span>"
				m_type = 1
			else
				if (!muzzled)//NO MORE SCREAMING FROM DEAD AND UNCONCIOUS PEOPLE PLEASE!
					if (stat)
						return
					message = "<span class='examinebold'>[src]</span> <span class='examine'>screams in FEAR!</span>"
					m_type = 2
					call_sound_emote("torturescream")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a very loud noise.</span>"
					m_type = 2

		if ("stop")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>asks to stop!</span>"
			m_type = 2
			call_sound_emote("stop")
			sound2()

		if ("burp")
			message = "<span class='examinebold'>[src]</span> <span class='examine'>burps.</span>"
			m_type = 2
			call_sound_emote("burp")
			sound2()

		if ("fallscream")
			if (miming)
				message = "<B>[src]</B> acts out a scream!"
				m_type = 1
			else
				if (!muzzled)
					if (stat)
						return
					message = "<span class='examinebold'>[src]</span> <span class='examine'>screams on the way down!</span>"
					m_type = 2
					sound2()
					call_sound_emote("fallscream")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a very loud noise.</span>"
					m_type = 2

		if ("agonyscream")
			if (miming)
				message = "<B>[src]</B> acts out a scream!"
				m_type = 1
			else
				if (!muzzled)
					if (stat)
						return
					message = "<span class='examinebold'>[src]</span> <span class='examine'>screams painfully!</span>"
					m_type = 2
					sound2()
					call_sound_emote("agonyscream")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a very loud noise.</span>"
					m_type = 2

		if ("agonypain")
			if (miming)
				message = "<B>[src]</B> acts out a scream!"
				m_type = 1
			else
				if (!muzzled)
					if (stat)
						return
					message = "<span class='examinebold'>[src]</span> <span class='examine'>moans.</span> <span class='examinebold'>\n<small>[src]</span> <span class='examine'>screams in pain.</small>"
					m_type = 2
					sound2()
					call_sound_emote("agonypain")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a very loud noise.</span>"
					m_type = 2

		if ("moandeath")
			if (miming)
				message = "<B>[src]</B> acts out a scream!"
				m_type = 1
			else
				if (!muzzled)
					if (stat)
						return
					message = "<span class='examinebold'>[src]</span> <span class='examine'><small>moans in pain.</small></span>"
					m_type = 2
					sound2()
					call_sound_emote("moandeath")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a very loud noise.</span>"
					m_type = 2

		if ("agonymoan")
			if (miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>acts out a scream!</span>"
				m_type = 1
			else
				if (!muzzled)
					if (stat)
						return
					message = "<span class='examinebold'>[src]</span> <span class='examine'>moans.\n<span class='examinebold'>[src]</span> <span class='examine'><small>moans in pain.</small></span>"
					m_type = 2
					sound2()
					call_sound_emote("agonymoan")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a very loud noise.</span>"
					m_type = 2

		if ("agonydeath")
			if (miming)
				message = "<span class='examinebold'>[src]</span> <span class='examine'>acts out a scream!</span>"
				m_type = 1
			else
				if (!muzzled)
					if (stat)
						return
					message = "<span class='examinebold'>[src]</span> <span class='examine'>moans.<span>\n<span class='examinebold'><small>[src]</small></span> <span class='examine'><small>screams in pain.</small></span>"
					m_type = 2
					sound2()
					call_sound_emote("agonydeath")
				else
					message = "<span class='examinebold'>[src]</span> <span class='examine'>makes a very loud noise.</span>"
					m_type = 2

//SHITTY EMOTES BEGIN

		if("fart")
			if(world.time-lastFart >= 600)
				if (src.nutrition >= 190)
					call_sound_emote("fart")
					m_type = 2

		if(("poo") || ("poop") || ("shit") || ("crap"))
			handle_shit()

		if(("pee") || ("urinate") || ("piss"))
			handle_piss()

		if(("vomit") || ("puke") || ("throwup"))
			if(ismonster(src))
				return
			if(!src.reagents || src.nutrition <= 80)
				message = "<span class='pukebold'>[src]</span> <span class='pukes'>gags as if trying to throw up but nothing comes out.</span>"
				to_chat(usr, "<span class='pukes'>You gag as you want to throw up, but there's nothing in your stomach!</span>")
			else
				var/obj/effect/decal/cleanable/vomit/V = new/obj/effect/decal/cleanable/vomit(src.loc)
				if(src.reagents)
					src.reagents.trans_to(V, 10)
				message = "<span class='pukebold'>[src]</span> <span class='pukes'>[pick("vomits", "throws up")]!</span>"
				src.CU()
				call_sound_emote("puke")
				src.nutrition -= rand(10,25)
				src.hygiene = -400
				if(src.dizziness)
					src.dizziness -= rand(2,8)
				if(src.drowsyness)
					src.drowsyness -= rand(2,8)
				if(src.stuttering)
					src.stuttering -= rand(2,8)
				if(src.confused)
					src.confused -= rand(2,8)
			m_type = 1

		if("masturbate") // god
			var/list/nonolist = list("strokes their dick.", "masturbates.")
			var/list/femnonolist = list("fingers their pussy.","pleasures herself.")
			src.adjustStaminaLoss(2)

			if(ismonster(src))
				return
			if(isChild(src))
				return
			if(src.mutilated_genitals)
				return to_chat(src, "<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> I can't.</span>")
			if(src.wear_suit)
				return to_chat(src, "<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> I have clothes on.</span>")
			if(src.has_penis())
				if(src.erpcooldown == 0)
					if(src.potenzia > 0)
						message = "<span class='examinebold'>[src]</span> <span class='examine'>[pick(nonolist)]</span>"
						src.lust += 12
						if (src.lust >= src.resistenza)
							src.fakecum()
							src.lust = 0
						else
							src.moan()
						call_sound_emote("masturbate")
				else
					to_chat(src, "It's not erect...")
			else
				message = "<span class='examinebold'>[src]</span> <span class='examine'>[pick(femnonolist)]</span>"
				src.lust += 12
				if (src.lust >= src.resistenza)
					src.cum(src, null)
					src.lust = 0
				else
					src.moan()

//SHITTY EMOTES END

		if("z_roar")
			message = "<font color='red'><B>[src]</B> roars!</font>"
			m_type = 1
			call_sound_emote("z_roar")
		if("z_shout")
			message = "<font color='red'><B>[src]</B> shouts!</font>"
			m_type = 1
			call_sound_emote("z_shout")
		if("z_mutter")
			message = "<font color='red'><B>[src]</B> mutters!</font>"
			m_type = 1
			call_sound_emote("z_mutter")
		if ("help")
			src << "blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough,\ncry, custom, deathgasp, drool, eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(none)/mob, glare-(none)/mob,\ngrin, laugh, elaugh, look-(none)/mob, moan, mumble, nod, pale, point-atom, raise, salute, shake, shiver, shrug,\nsigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, tremble, twitch, vomit, twitch_s, whimper,\nwink, yawn. For custom emotes use '*emote.'"

		else
			message = "<span class='mebold'>[src]</span> <span class='mebasic'>[sanitize(act)]</span>"
			cooldown = 0


	for(var/obj/O in listening_obj)
		spawn(0)
			if(O) //It's possible that it could be deleted in the meantime.
				if(act == "praise" && src.religion == "Thanati")
					O.hear_talk(src, "Tzchernobog is cute!")
					return
				O.hear_talk(src, message)


	if (message)
		message = sanitize_uni(message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			for (var/mob/O in get_mobs_in_view(world.view,src))
				O.show_message(message, m_type)
		else if (m_type & 2)
			for (var/mob/O in (hearers(src.loc, null) | get_mobs_in_view(world.view,src)))
				O.show_message(message, m_type)

		emote_cooldown += cooldown


/mob/living/carbon/human/proc/call_sound_emote(var/E)
	sound2()
	switch(E)
		if("scream")
			if(ismonster(src))
				return
			if (src.gender == "male" && !isChild())
				if(src.religion == "Thanati" && istype(src.wear_suit, /obj/item/clothing/suit/storage/thanati/thanati))
					playsound(src.loc, pick('thpain1.ogg', 'thpain2.ogg','thpain3.ogg'), 100, 0)
					return
				else
					if(src.voicetype == "hobo")
						playsound(src.loc, pick('sound/voice/hobopain1.ogg', 'sound/voice/hobopain2.ogg', 'sound/voice/hobopain3.ogg','sound/voice/hobopain4.ogg'), 90, 0)
						return
					else
						playsound(src.loc, pick('sound/lfwbsounds/fear_scream1.ogg', 'sound/lfwbsounds/fear_scream2.ogg'), 90, 0)
						return
			if(isChild())
				playsound(src.loc, "sound/voice/fear_child.ogg", 90, 0)
				return
			else
				playsound(src.loc, pick('sound/lfwbsounds/fear_woman1.ogg', 'sound/lfwbsounds/fear_woman2.ogg', 'sound/lfwbsounds/fear_woman3.ogg'), 90, 0)

		if("torturescream")
			if(ismonster(src)) return
			if(src.gender == "male" && !isChild())
				playsound(src.loc, pick('sound/voice/torture/male_torture_scream1.ogg', 'sound/voice/torture/male_torture_scream2.ogg', 'sound/voice/torture/male_torture_scream3.ogg', 'sound/voice/torture/male_torture_scream4.ogg'), 90, 0)
			else if(src.gender == "female" && !isChild())
				playsound(src.loc, "sound/voice/torture/female_torture_scream1.ogg", 90, 0)
			else if(isChild())
				playsound(src.loc, pick('sound/voice/torture/kid_torture_scream1.ogg', 'sound/voice/torture/kid_torture_scream2.ogg'), 90, 0)
		if("stop")
			playsound(src.loc, 'emostop.ogg', 70, 0)
			return

		if("burp")
			playsound(src.loc, 'burp.ogg', 70, 1)
			return

		if("puke")
			playsound(src.loc, 'vomit.ogg', 70, 0)
			return
		if("masturbate")
			var/jackoff = pick(flist("honk/sound/new/ACTIONS/PENIS/HANDJOB/"))
			var/packoff = pick(flist("honk/sound/new/ACTIONS/VAGINA/TOUCH/"))
			if(src.has_penis())
				playsound(src.loc, ("honk/sound/new/ACTIONS/PENIS/HANDJOB/[jackoff]"), 90, 1, -5)
			else
				playsound(src.loc, ("honk/sound/new/ACTIONS/VAGINA/TOUCH/[packoff]"), 90, 1, -5)



		if("clearthroat")
			if (src.gender == MALE)
				playsound(src.loc, 'throatclear_male.ogg', 100, 0)
			else
				playsound(src.loc, pick('throatclear_female.ogg'), 100, 0)
			return

		if("agonyscream")
			if(ismonster(src))
				return
			if(src.religion == "Thanati" && istype(src.wear_suit, /obj/item/clothing/suit/storage/thanati/thanati))
				playsound(src.loc, pick('thpain1.ogg', 'thpain2.ogg','thpain3.ogg'), 100, 0)
				return
			else
				if (src.gender == "male" && !isChild())
					playsound(src.loc, pick('sound/voice/pain/agony/male/agony_male1.ogg', 'sound/voice/pain/agony/male/agony_male2.ogg', 'sound/voice/pain/agony/male/agony_male3.ogg', 'sound/voice/pain/agony/male/agony_male4.ogg','sound/voice/pain/agony/male/agony_male5.ogg','sound/voice/pain/agony/male/agony_male6.ogg','sound/voice/pain/agony/male/agony_male7.ogg','sound/voice/pain/agony/male/agony_male8.ogg','sound/voice/pain/agony/male/agony_male9.ogg','sound/voice/pain/agony/male/agony_male10.ogg','sound/voice/pain/agony/male/agony_male11.ogg','sound/voice/pain/agony/male/agony_male12.ogg','sound/voice/pain/agony/male/agony_male13.ogg'), 80, 1)
					return
				if(isChild())
					playsound(src.loc, pick('sound/voice/child_pain1.ogg', 'sound/voice/child_pain2.ogg'), 90, 1)
					return
				else
					playsound(src.loc, pick('sound/voice/pain/agony/female/woman_pain1.ogg', 'sound/voice/pain/agony/female/woman_pain2.ogg', 'sound/voice/pain/agony/female/woman_pain3.ogg', 'sound/voice/pain/agony/female/woman_pain4.ogg', 'sound/voice/pain/agony/female/woman_pain5.ogg'), 80, 1)
					return

		if("agonydeath")
			if(ismonster(src))
				return
			if(src.religion == "Thanati" && istype(src.wear_suit, /obj/item/clothing/suit/storage/thanati/thanati))
				playsound(src.loc, pick('thanatideath1.ogg', 'thanatideath2.ogg','thanatideath3.ogg'), 100, 1)
				return
			else
				if (src.gender == "male" && !isChild())
					playsound(src.loc, pick('sound/voice/pain/agony/male/death_male1.ogg', 'sound/voice/pain/agony/male/death_male2.ogg','sound/voice/pain/agony/male/death_male3.ogg'), 80, 1)
					return
				if(isChild())
					playsound(src.loc, pick('sound/voice/pain/agony/male/death_male1.ogg', 'sound/voice/pain/agony/male/death_male1.ogg', 'sound/voice/pain/agony/male/death_male1.ogg'), 80, 1)
					return
				else
					playsound(src.loc, pick('sound/voice/pain/agony/female/death_female1.ogg', 'sound/voice/pain/agony/female/death_female2.ogg', 'sound/voice/pain/agony/female/death_female3.ogg'), 80, 1)
					return

		if("agonymoan")
			if(ismonster(src))
				return
			if (src.gender == "male" && !isChild())
				playsound(src.loc, pick('sound/voice/pain/agony/male/male_moan_1.ogg', 'sound/voice/pain/agony/male/male_moan_2.ogg','sound/voice/pain/agony/male/male_moan_3.ogg', 'sound/voice/pain/agony/male/male_moan_4.ogg', 'sound/voice/pain/agony/male/male_moan_5.ogg'), 80, 1)
				return
			if(isChild())
				playsound(src.loc, pick('sound/voice/pain/agony/male/child_moan1.ogg'), 80, 1)
				return
			else
				playsound(src.loc, pick('sound/voice/pain/agony/female/female_moan_wounded.ogg', 'sound/voice/pain/agony/female/female_moan_wounded2.ogg', 'sound/voice/pain/agony/female/female_moan_wounded3.ogg', 'sound/voice/pain/agony/female/female_moan_wounded4.ogg', 'sound/voice/pain/agony/female/female_moan_wounded5.ogg', 'sound/voice/pain/agony/female/female_moan_wounded6.ogg', 'sound/voice/pain/agony/female/female_moan_wounded7.ogg', 'sound/voice/pain/agony/female/female_moan_wounded8.ogg'), 80, 1)
				return

		if("cry")
			if (src.gender == "male" && !isChild())
				playsound(src.loc, pick('sound/voice/cry_man01.ogg', 'sound/voice/cry_man02.ogg','sound/voice/cry_man03.ogg','sound/voice/cry_man04.ogg'), 90, 0)
				return
			else if(src.gender == "female" && !isChild())
				playsound(src.loc, pick('sound/voice/cry_woman01.ogg', 'sound/voice/cry_woman02.ogg','sound/voice/cry_woman03.ogg'), 90, 0)
				return
			else if(src.isChild())
				playsound(src.loc, pick('sound/voice/child_cry.ogg', 'sound/voice/kob030_cryingchild.ogg'), 90, 0)
				return

		if("agonypain")
			if(ismonster(src))
				return
			if (src.gender == "male" && !isChild())
				playsound(src.loc, pick('sound/effects/man_pain1.ogg', 'sound/effects/man_pain2.ogg', 'sound/effects/man_pain3.ogg'), 90, 1)
				return
			if(isChild())
				playsound(src.loc, pick('sound/voice/child_pain1.ogg', 'sound/voice/child_pain2.ogg'), 90, 1)
				return
			else
				playsound(src.loc, pick('sound/voice/pain/agony/female/woman_pain1.ogg', 'sound/voice/pain/agony/female/woman_pain2.ogg', 'sound/voice/pain/agony/female/woman_pain3.ogg', 'sound/voice/pain/agony/female/woman_pain4.ogg', 'sound/voice/pain/agony/female/woman_pain5.ogg'), 90, 1)
				return

		if("moandeath")
			if(ismonster(src))
				return
			if (src.gender == "male" && !isChild())
				playsound(src.loc, pick('sound/voice/pain/agony/both/painb.ogg', 'sound/voice/pain/agony/both/painb2.ogg','sound/voice/pain/agony/both/painb3.ogg', 'sound/voice/pain/agony/both/painb4.ogg', 'sound/voice/pain/agony/both/painb5.ogg', 'sound/voice/pain/agony/both/painb6.ogg', 'sound/voice/pain/agony/both/painb7.ogg'), 90, 1)
				return
			if(isChild())
				playsound(src.loc, pick('sound/voice/pain/agony/both/painb.ogg', 'sound/voice/pain/agony/both/painb2.ogg','sound/voice/pain/agony/both/painb3.ogg', 'sound/voice/pain/agony/both/painb4.ogg', 'sound/voice/pain/agony/both/painb5.ogg', 'sound/voice/pain/agony/both/painb6.ogg', 'sound/voice/pain/agony/both/painb7.ogg'), 90, 1)
				return
			else
				playsound(src.loc, pick('sound/voice/pain/agony/both/painb.ogg', 'sound/voice/pain/agony/both/painb2.ogg','sound/voice/pain/agony/both/painb3.ogg', 'sound/voice/pain/agony/both/painb4.ogg', 'sound/voice/pain/agony/both/painb5.ogg', 'sound/voice/pain/agony/both/painb6.ogg', 'sound/voice/pain/agony/both/painb7.ogg'), 90, 1)
				return

		if("praise")
			if (src.religion == "Thanati")
				sound2()
				var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h2")

				if(isturf(loc))
					var/turf/T = loc
					for(var/obj/effect/decal/cleanable/thanati/C/center in T)
						if(!thanatiGlobal.isKnower(src))
							if(prob(20))
								to_chat(src, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>I remember now!</span>")
								to_chat(src, "<span class='baronboldoutlined'> Tzchernobog's Wish:</span> <span class='baron'> [thanatiGlobal.objective.name].</span>")
								src.mind.store_memory("\n<font face='Hando' color = #000000>My objective is: [thanatiGlobal.objective.name]</font>")
								thanatiGlobal.addKnower(src)

				if(src?.mind?.lord_hears_you != 2)
					if(prob(15))
						to_chat(src, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>The Lord hears you!</span>")
						src.mind.lord_hears_you += 1
						src.my_stats.st += 1
						spawn(30 SECONDS)
							src.my_stats.st -= 1
							src.mind.lord_hears_you -= 1

				for(var/mob/M in view(src, world.view))
					M << speech_bubble
				playsound(src.loc, pick('Cultiste message 1.ogg','Cultiste message 2.ogg','Cultiste message 3.ogg','Cultiste message 4.ogg','Cultiste message 5.ogg','Cultiste message 6.ogg','Cultiste message 7.ogg','Cultiste message 8.ogg','Cultiste message 9.ogg'), 100, 1)
				spawn(30) del(speech_bubble)
				return
			else if (src.religion == "Allah")
				sound2()
				var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h2")

				if(src?.mind?.lord_hears_you != 2)
					if(prob(15))
						to_chat(src, "<span class='dreamershitbutitsactuallypassivebutitactuallyisbigandbold'>Allah hears you!</span>")
						src.mind.lord_hears_you += 1
						src.my_stats.st += 1
						spawn(30 SECONDS)
							src.my_stats.st -= 1
							src.mind.lord_hears_you -= 1

				for(var/mob/M in view(src, world.view))
					M << speech_bubble
				if(src.job == "Eunuch")
					playsound(src.loc, pick('sound/voice/alah_grib.ogg'), 100, 1)
				else
					playsound(src.loc, pick('sound/voice/Alah.ogg'), 100, 1)
				spawn(30) del(speech_bubble)
				return
			else
				return

		if("fallscream")
			if(ismonster(src))
				return
			if(src.gender == "male")
				playsound(src.loc, pick('sound/voice/falling_down_scream.ogg', 'sound/voice/falling_down_scream2.ogg', 'sound/voice/falling_down_scream3.ogg'), 90, 0, -1)
				return
			else
				playsound(src.loc, pick('sound/voice/fem_falling.ogg'), 90, 0, -1)


		if("laugh")
			if (src.gender == "male" && !isChild())
				if(src.my_stats.it <= 5)
					playsound(src.loc, pick('sound/voice/smeshinka.ogg', 'sound/voice/smeshinka2.ogg'), 90, 0, -1)
				else
					if(src.gender == "male" && isChild())
						playsound(src.loc, pick('sound/voice/malelaugh/boy_laugh1.ogg','sound/voice/malelaugh/boy_laugh2.ogg','sound/voice/malelaugh/boy_laugh3.ogg'), 90, 0, -1)
					else if(src.gender == "male" && !isChild())
						if(src.religion == "Thanati" && istype(src.wear_suit, /obj/item/clothing/suit/storage/thanati/thanati))
							playsound(src.loc, pick('sound/voice/thanati/Cultiste rire 1.ogg','sound/voice/thanati/Cultiste rire 2.ogg','sound/voice/thanati/Cultiste rire 3.ogg','sound/voice/thanati/Cultiste rire 4.ogg','sound/voice/thanati/Cultiste rire 5.ogg','sound/voice/thanati/Cultiste rire 6.ogg'), 90, 0)
							return
						if(job == "Revisor")
							playsound(src.loc, pick('sound/voice/Revisor1.ogg','sound/voice/Revisor2.ogg'), 80, 0)
							return
						if(job == "Tiamat")
							playsound(src.loc, pick('sound/voice/malelaugh/stronglaugh1.ogg','sound/voice/malelaugh/stronglaugh2.ogg','sound/voice/malelaugh/stronglaugh3.ogg'), 90, 0)
							return
						if(src.voicetype == "strong")
							playsound(src.loc, pick('sound/voice/malelaugh/harris_laugh_01.ogg', 'sound/voice/malelaugh/harris_laugh_02.ogg','sound/voice/malelaugh/harris_laugh_03.ogg', 'sound/voice/malelaugh/harris_laugh_04.ogg','sound/voice/malelaugh/harris_laugh_05.ogg', 'sound/voice/malelaugh/harris_laugh_10.ogg','sound/voice/malelaugh/harris_laugh_07.ogg', 'sound/voice/malelaugh/harris_laugh_08.ogg','sound/voice/malelaugh/harris_laugh_01.ogg', 'sound/voice/malelaugh/harris_laugh_11.ogg','sound/voice/malelaugh/harris_laugh_01.ogg', 'sound/voice/malelaugh/harris_laugh_12.ogg','sound/voice/malelaugh/harris_laugh_01.ogg', 'sound/voice/malelaugh/harris_laugh_14.ogg'), 90, 0)
							return
						if(src.voicetype == "strong2")
							playsound(src.loc, pick('sound/voice/malelaugh/Cynical_Laugh.ogg', 'sound/voice/malelaugh/Cynical_Laugh2.ogg','sound/voice/malelaugh/Cynical_Laugh3.ogg', 'sound/voice/malelaugh/Cynical_Laugh4.ogg','sound/voice/malelaugh/Cynical_Laugh5.ogg', 'sound/voice/malelaugh/Cynical_Laugh6.ogg'), 90, 0)
							return
						if(src.voicetype == "sketchy")
							playsound(src.loc, pick('sound/voice/malelaugh/01laugh1.ogg', 'sound/voice/malelaugh/01laugh2.ogg','sound/voice/malelaugh/01laugh3.ogg','sound/voice/malelaugh/01laugh5.ogg','sound/voice/malelaugh/01laugh6.ogg','sound/voice/malelaugh/01laugh7.ogg','sound/voice/malelaugh/01laugh8.ogg'), 90, 0)
							return
						if(src.voicetype == "noble")
							playsound(src.loc, pick('sound/voice/malelaugh/leg_laugh1.ogg','sound/voice/malelaugh/leg_laugh2.ogg','sound/voice/malelaugh/leg_laugh3.ogg','sound/voice/malelaugh/leg_laugh4.ogg','sound/voice/malelaugh/leg_laugh5.ogg','sound/voice/malelaugh/leg_laugh6.ogg','sound/voice/malelaugh/leg_laugh7.ogg','sound/voice/malelaugh/leg_laugh8.ogg','sound/voice/malelaugh/leg_laugh9.ogg'), 90, 0)
							return
						if(src.voicetype == "hobo")
							playsound(src.loc, pick('sound/voice/malelaugh/bum_laugh1.ogg','sound/voice/malelaugh/bum_laugh2.ogg'), 90, 0)
							return
						if(src.voicetype == "midget")
							playsound(src.loc, pick('midgetlaugh.ogg','midgetlaugh2.ogg','midgetlaugh3.ogg','midgetlaugh4.ogg','midgetlaugh5.ogg','midgetlaugh6.ogg','midgetlaugh7.ogg'), 90, 0)
							return
						else
							playsound(src.loc, pick('sound/voice/malelaugh/leg_laugh1.ogg','sound/voice/malelaugh/leg_laugh2.ogg','sound/voice/malelaugh/leg_laugh3.ogg','sound/voice/malelaugh/leg_laugh4.ogg','sound/voice/malelaugh/leg_laugh5.ogg','sound/voice/malelaugh/leg_laugh6.ogg','sound/voice/malelaugh/leg_laugh7.ogg','sound/voice/malelaugh/leg_laugh8.ogg','sound/voice/malelaugh/leg_laugh9.ogg'), 90, 0)
							return
			else
				if(src.voicetype == "hobo")
					playsound(src.loc, pick('sound/voice/oldbum_female_laugh1.ogg', 'sound/voice/oldbum_female_laugh2.ogg'), 90, 0)
				else
					if(isChild() && src.gender == "female")
						playsound(src.loc, 'sound/voice/girl_laugh1.ogg', 90, 0)
					else if(isChild() && src.gender == "male")
						playsound(src.loc, pick('sound/voice/boy_laugh1.ogg', 'sound/voice/boy_laugh2.ogg', 'sound/voice/boy_laugh3.ogg'), 90, 0)
					else
						if(src.religion == "Thanati" && istype(src.wear_suit, /obj/item/clothing/suit/storage/thanati/thanati))
							playsound(src.loc, pick('sound/voice/thanati/Cultiste rire 1.ogg','sound/voice/thanati/Cultiste rire 2.ogg','sound/voice/thanati/Cultiste rire 3.ogg','sound/voice/thanati/Cultiste rire 4.ogg','sound/voice/thanati/Cultiste rire 5.ogg','sound/voice/thanati/Cultiste rire 6.ogg'), 90, 0)
							return
						playsound(src.loc, pick('sound/voice/laugh_female1.ogg', 'sound/voice/laugh_female2.ogg','sound/voice/laugh_female3.ogg'), 90, 0)

		if("gasp")
			if(ismonster(src))
				return
			if (src.gender == "male")
				playsound(src.loc, pick('sound/voice/gasp_male1.ogg', 'sound/voice/gasp_male2.ogg', 'sound/voice/gasp_male3.ogg', 'sound/voice/gasp_male4.ogg','sound/voice/gasp_male5.ogg','sound/voice/gasp_male6.ogg','sound/voice/gasp_male7.ogg'), 80, 0)
			else
				playsound(src.loc, pick('sound/voice/gasp_female1.ogg', 'sound/voice/gasp_female2.ogg', 'sound/voice/gasp_female3.ogg', 'sound/voice/gasp_female4.ogg','sound/voice/gasp_female5.ogg','sound/voice/gasp_female6.ogg','sound/voice/gasp_female7.ogg'), 80, 0)

		if("1shotbreath")
			playsound(src.loc, pick('sound/webbers/1shot_breathing_02.ogg', 'sound/webbers/1shot_breathing_08.ogg', 'sound/webbers/1shot_breathing_09.ogg'), 100, 1)

		if("coughwounded")
			if(gender == MALE)
				playsound(src.loc, pick('sound/webbers/woundedcough1.ogg', 'sound/webbers/woundedcough2.ogg', 'sound/webbers/woundedcough3.ogg', 'sound/webbers/woundedcough4.ogg'), 100, 1)
			if(gender == FEMALE)
				playsound(src.loc, pick('sound/webbers/cough_female.ogg', 'sound/webbers/cough_female2.ogg'), 100, 1)

		if("fart")
			playsound(playsound(src.loc, pick('fart.ogg','fart2.ogg'), 90, 0))

		if("elaugh")
			playsound(src.loc, 'sound/voice/elaugh.ogg', 90, 0)

		if("clap")
			if(src.gloves)
				playsound(src.loc, 'sound/voice/clapping_gloves.ogg', 90, 0)
			else
				playsound(src.loc, 'sound/voice/clapping.ogg', 90, 0)

		if("krak")
			playsound(src.loc, pick('sound/voice/krak1.ogg','sound/voice/krak2.ogg'), 90, 0)

		if("yawn")
			if(ismonster(src))
				return
			if (src.gender == "male")
				playsound(src.loc, pick('sound/voice/emotes/yawn/yawn01_man.ogg','sound/voice/emotes/yawn/yawn02_man.ogg'), 90, 0)
			else
				playsound(src.loc, pick('sound/voice/emotes/yawn/yawn01_woman.ogg','sound/voice/emotes/yawn/yawn02_woman.ogg','sound/voice/emotes/yawn/yawn03_woman.ogg'), 90, 0)

		if("whimper")
			if(src.gender == "male")
				playsound(src.loc, pick('sound/voice/emotes/whimper/whimper_male.ogg','sound/voice/emotes/whimper/whimper_male2.ogg','sound/voice/emotes/whimper/whimper_male3.ogg'), 90, 0)
			else
				playsound(src.loc, pick('sound/voice/emotes/whimper/whimper_female.ogg','sound/voice/emotes/whimper/whimper_female2.ogg','sound/voice/emotes/whimper/whimper_female3.ogg'), 90, 0)

		if("hem")
			if(src.gender == "male")
				playsound(src.loc, 'sound/voice/Huh.ogg', 90, 0)
			else
				playsound(src.loc, 'sound/voice/huh_female1.ogg', 90, 0)

		if("sneeze")
			if(src.gender == "male")
				playsound(src.loc, pick('sound/voice/emotes/sneeze/sneezem1.ogg', 'sound/voice/emotes/sneeze/sneezem2.ogg'), 90, 0)
			else
				playsound(src.loc, pick('sound/voice/emotes/sneeze/sneezef1.ogg','sound/voice/emotes/sneeze/sneezef2.ogg'), 90, 0)

		if("finger")
			playsound(src.loc, 'sound/voice/finger.ogg', 90, 0)

		if("whistle")
			playsound(src.loc, pick('sound/voice/whistle1.ogg','sound/voice/whistle2.ogg'), 90, 0)

		if("giggle")
			if(src.gender == "male")
				playsound(src.loc, 'sound/voice/emotes/giggle/male_giggle.ogg', 90, 0)
			else
				playsound(src.loc, pick('sound/voice/emotes/giggle/giggle02_woman.ogg','sound/voice/emotes/giggle/giggle03_woman.ogg'), 90, 0)

		if("snore")
			if(ismonster(src))
				return
			playsound(src.loc, pick('sound/voice/emotes/snores/snore1.ogg','sound/voice/emotes/snores/snore2.ogg','sound/voice/emotes/snores/snore3.ogg','sound/voice/emotes/snores/snore4.ogg','sound/voice/emotes/snores/snore5.ogg','sound/voice/emotes/snores/snore6.ogg','sound/voice/emotes/snores/snore7.ogg'), 90, 0)

		if("sneeze")
			if(ismonster(src))
				return
			if(src.gender == "male")
				playsound(src.loc, pick('sound/voice/sneezem1.ogg','sound/voice/sneezem2.ogg'), 90, 0)
			else
				playsound(src.loc, pick('sound/voice/sneezef1.ogg','sound/voice/sneezef2.ogg'), 90, 0)

		if("sigh")
			if(src.gender == "male")
				playsound(src.loc, 'sound/voice/emotes/sigh/sigh_male.ogg', 90, 0)
			else
				playsound(src.loc, pick('sound/voice/emotes/sigh/sigh_female.ogg','sound/voice/emotes/sigh/sigh02_woman.ogg'), 90, 0)

		if("cough")
			if(ismonster(src))
				return
			if(src.gender == "male")
				if(age > 65)
					playsound(src.loc, 'sound/voice/emotes/cough/cough_oldman.ogg', 90, 0)
				else
					if(isChild())
						playsound(src.loc, pick('sound/voice/emotes/cough/Kid_Cough1.ogg', 'sound/voice/emotes/cough/Kid_Cough2.ogg'), 90, 0)
					playsound(src.loc, pick('sound/voice/emotes/cough/cough_01.ogg','sound/voice/emotes/cough/cough_02.ogg','sound/voice/emotes/cough/cough_03.ogg','sound/voice/emotes/cough/cough_05.ogg','sound/voice/emotes/cough/cough01_man.ogg','sound/voice/emotes/cough/cough02_man.ogg','sound/voice/emotes/cough/cough03_man.ogg','sound/voice/emotes/cough/cough04_man.ogg'), 90, 0)
			else
				playsound(src.loc, pick('sound/voice/emotes/cough/cough_female.ogg','sound/voice/emotes/cough/cough_female2.ogg','sound/voice/emotes/cough/cough01_woman.ogg','sound/voice/emotes/cough/cough02_woman.ogg','sound/voice/emotes/cough/cough03_woman.ogg','sound/voice/emotes/cough/cough04_woman.ogg','sound/voice/emotes/cough/cough05_woman.ogg','sound/voice/emotes/cough/cough06_woman.ogg','sound/voice/emotes/cough/cough07_woman.ogg'), 90, 0)

		if("z_roar")
			if(isChild())
				playsound(src.loc, pick('sound/voice/zombie_child.ogg','sound/voice/zombie_child2.ogg','sound/voice/zombie_child3.ogg'), 90, 0)
			else if(src.gender == "male" && !isChild())
				playsound(src.loc, pick('sound/voice/zombie_idle1.ogg', 'sound/voice/zombie_idle2.ogg','sound/voice/zombie_idle3.ogg', 'sound/voice/zombie_idle4.ogg','sound/voice/zombie_idle5.ogg','sound/voice/zombie_idle6.ogg','sound/voice/zombie_idle7.ogg'), 90, 0)
			else
				playsound(src.loc, pick('sound/voice/zombie_female1.ogg', 'sound/voice/zombie_female2.ogg','sound/voice/zombie_female3.ogg', 'sound/voice/zombie_female4.ogg','sound/voice/zombie_female5.ogg'), 90, 0)

		if("z_shout")
			if(isChild())
				playsound(src.loc, pick('sound/voice/zombie_child.ogg','sound/voice/zombie_child2.ogg','sound/voice/zombie_child3.ogg'), 90, 0)
			else if(src.gender == "male" && !isChild())
				playsound(src.loc, pick('sound/voice/zombie_idle1.ogg', 'sound/voice/zombie_idle2.ogg','sound/voice/zombie_idle3.ogg', 'sound/voice/zombie_idle4.ogg','sound/voice/zombie_idle5.ogg','sound/voice/zombie_idle6.ogg','sound/voice/zombie_idle7.ogg'), 90, 0)
			else
				playsound(src.loc, pick('sound/voice/zombie_female1.ogg', 'sound/voice/zombie_female2.ogg','sound/voice/zombie_female3.ogg', 'sound/voice/zombie_female4.ogg','sound/voice/zombie_female5.ogg'), 90, 0)


		if("z_mutter")
			if(isChild())
				playsound(src.loc, pick('sound/voice/zombie_child.ogg','sound/voice/zombie_child2.ogg','sound/voice/zombie_child3.ogg'), 90, 0)
			else if(src.gender == "male" && !isChild())
				playsound(src.loc, pick('sound/voice/zombie_idle1.ogg', 'sound/voice/zombie_idle2.ogg','sound/voice/zombie_idle3.ogg', 'sound/voice/zombie_idle4.ogg','sound/voice/zombie_idle5.ogg','sound/voice/zombie_idle6.ogg','sound/voice/zombie_idle7.ogg'), 90, 0)
			else
				playsound(src.loc, pick('sound/voice/zombie_female1.ogg', 'sound/voice/zombie_female2.ogg','sound/voice/zombie_female3.ogg', 'sound/voice/zombie_female4.ogg','sound/voice/zombie_female5.ogg'), 90, 0)


/*
/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  sanitize(input(usr, "This is [src]. \He is...", "Pose", null)  as text)
*/
/mob/living/carbon/human/verb/praiselord()
	set name = "Praise the Lord"
	set desc = "Praise the lord!"
	set category = "IC"

	emote("praise")

/mob/living/carbon/human/proc/getWords()
	set category = "IC"
	if(src.religion == "Thanati")
		to_chat(src, "<span class='baron'>Your corrupt word: [src.mind.thanati_corrupt], [src.mind.thanati_word_random] (The Circle of [src.mind.thanati_type]).</span>\n")

/mob/living/carbon/human/proc/praisethelord()
	set category = "IC"
	if(src.religion == "Thanati")
		emote("praise")

/mob/living/carbon/human/proc/getBrothers()
	if(src.religion == "Thanati")
		var/brothers_message = "Your brothers and sisters in faith:<br>"
		for(var/mob/living/carbon/human/H in mob_list)
			if(H.religion == "Thanati")
				brothers_message += "<b> [H.real_name]</b> ([H?.mind?.thanati_type] Circle)<br>"
		to_chat(src, brothers_message)

/mob/living/carbon/human/verb/praiselord_hotkey()//For the hotkeys.
	set name = ".praiselord"
	praiselord()

/mob/living/carbon/human/verb/Dance()
	if(dancing)
		dancing = 0
		return
	if(isChild() || isMidget())
		pixel_y = -4
	else
		pixel_y = initial(pixel_y)
	dancing = 1
	var/oldpixely = pixel_y
	while(dancing)
		var/pixely = rand(5, 6)
		animate(src, pixel_y = pixely, time = 0.5)
		sleep(1)
		animate(src, pixel_y = oldpixely, time = 0.7)
		sleep(2)
		animate(src, pixel_y = 2, time = 0.2)
		sleep(1)
		animate(src, pixel_y = oldpixely, time = 0.2)
		if(resting || lying)
			dancing = 0
/*
/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Update Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	src << browse(HTML, "window=flavor_changes;size=430x300")
*/
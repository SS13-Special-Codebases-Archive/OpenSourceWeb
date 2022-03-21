/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M as mob)
	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return
	if(M.amulet)
		if(istype(M.amulet, /obj/item/clothing/head/amulet/breaker))
			return

	var/datum/organ/external/temp = M:organs_by_name["r_hand"]
	if (M.hand)
		temp = M:organs_by_name["l_hand"]
	if(temp && !temp.is_usable())
		to_chat(M, "\red You can't use your [temp.display_name].")
		return

	if(M.stunned)
		return


	..()

	if((M != src) && check_shields(0, M.name))
		visible_message("<span class='hitbold'>[M]</span> <span class='hit'>attempted to touch</span> <span class='hitbold'>[src]</span><span class='hit'>!</span> ")
		return 0


	if(!M.gloves || !istype(M.gloves,/obj/item/clothing/gloves))
		if(istype(M,/mob/living/carbon))
//			log_debug("No gloves, [M] is truing to infect [src]")
			M.spread_disease_to(src, "Contact")


	switch(M.a_intent)
		if("help")
			if(!death_door)
				help_shake_act(M)
				return 1
//			if(M.health < -75)	return 0

			if((M.head && (M.head.flags & HEADCOVERSMOUTH)) || (M.wear_mask && (M.wear_mask.flags & MASKCOVERSMOUTH)))
				to_chat(usr, "<span class='passivebold'>Remove your mask!</span>")
				return 0
			if((head && (head.flags & HEADCOVERSMOUTH)) || (wear_mask && (wear_mask.flags & MASKCOVERSMOUTH)))
				to_chat(usr, "<span class='passivebold'>Remove their mask!</span>")
				return 0

			var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human()
			O.source = M
			O.target = src
			O.s_loc = M.loc
			O.t_loc = loc
			O.place = "CPR"
			requests += O
			spawn(0)
				O.process()
			return 1

		if("grab")
			if(M.z != src.z)
				return FALSE
			if(anchored)
				return 0
			if(w_uniform)
				w_uniform.add_fingerprint(M)

			if(lifeweb_locked)
				return 0

			if(M.lifeweb_locked)
				return 0
			var/list/valid_objects = list()
			if(istype(src,/mob/living/carbon/human))
				valid_objects = src.get_visible_implants(1)
			else
				for(var/obj/item/weapon/W in embedded)
					if(W.w_class >= 0)
						valid_objects += W

			if(lying || resting || !grabdodge(src, M))

				var/datum/organ/external/affecting = get_organ(M.zone_sel.selecting)
				if(affecting.status & ORGAN_DESTROYED)
					to_chat(usr, "I can't grab a missing limb!")
					return
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 75, 1, -1)
				visible_message("<span class='hitbold'>[M]</span> <span class='hit'>has grabbed</span> <span class='hitbold'>[src]'s</span> <span class='hit'>[affecting.display_name]!</span>")
				if (affecting.status & ORGAN_BROKEN)
					to_chat(usr, "<span class='combatbold'>I feel the loose bones on the [affecting.display_name].</span>")
				switch(M.zone_sel.selecting)
					if(BP_L_LEG)
						var/obj/item/weapon/grab/wrench/W = new /obj/item/weapon/grab/wrench(M, src)
						M.put_in_active_hand(W)
						grabbed_by += W
						W.synch()
						LAssailant = M
						return
					if(BP_R_LEG)
						var/obj/item/weapon/grab/wrench/W = new /obj/item/weapon/grab/wrench(M, src)
						M.put_in_active_hand(W)
						grabbed_by += W
						W.synch()
						LAssailant = M
						return
					if(BP_L_HAND)
						var/obj/item/weapon/grab/wrench/W = new /obj/item/weapon/grab/wrench(M, src)
						M.put_in_active_hand(W)
						grabbed_by += W
						W.synch()
						LAssailant = M
						return
					if(BP_R_HAND)
						var/obj/item/weapon/grab/wrench/W = new /obj/item/weapon/grab/wrench(M, src)
						M.put_in_active_hand(W)
						grabbed_by += W
						W.synch()
						LAssailant = M
						return
					if(BP_HEAD)
						if(is_it_high(M))
							to_chat(M, "<span class='combatbold'>[pick(nao_consigoen)] You can't reach that high.</span>")
							return
						var/obj/item/weapon/grab/wrench/W = new /obj/item/weapon/grab/wrench(M, src)
						M.put_in_active_hand(W)
						grabbed_by += W
						W.synch()
						LAssailant = M
						return
					if("face")
						if(is_it_high(M))
							to_chat(M, "<span class='combatbold'>[pick(nao_consigoen)] You can't reach that high.</span>")
							return
						var/obj/item/weapon/grab/wrench/W = new /obj/item/weapon/grab/wrench(M, src)
						M.put_in_active_hand(W)
						grabbed_by += W
						W.synch()
						LAssailant = M
						return
					if("mouth")
						if(is_it_high(M))
							to_chat(M, "<span class='combatbold'>[pick(nao_consigoen)] You can't reach that high.</span>")
							return
						var/obj/item/weapon/grab/wrench/W = new /obj/item/weapon/grab/wrench(M, src)
						M.put_in_active_hand(W)
						grabbed_by += W
						W.synch()
						LAssailant = M
						return
					if(BP_R_FOOT)
						var/obj/item/weapon/grab/wrench/W = new /obj/item/weapon/grab/wrench(M, src)
						M.put_in_active_hand(W)
						grabbed_by += W
						W.synch()
						LAssailant = M
						return
					if(BP_L_FOOT)
						var/obj/item/weapon/grab/wrench/W = new /obj/item/weapon/grab/wrench(M, src)
						M.put_in_active_hand(W)
						grabbed_by += W
						W.synch()
						LAssailant = M
						return
					if(BP_L_ARM)
						var/obj/item/weapon/grab/wrench/W = new /obj/item/weapon/grab/wrench(M, src)
						M.put_in_active_hand(W)
						grabbed_by += W
						W.synch()
						LAssailant = M
						return
					if(BP_R_ARM)
						var/obj/item/weapon/grab/wrench/W = new /obj/item/weapon/grab/wrench(M, src)
						M.put_in_active_hand(W)
						grabbed_by += W
						W.synch()
						LAssailant = M
						return

				if(affecting.dissected || affecting.open >= 3)
					src.organ_storage.orient2hud(M)
					src.organ_storage.show_to(M)
					return

				if(M.zone_sel.selecting == BP_CHEST && valid_objects.len)
					var/obj/item/weapon/grab/stucked/W = new /obj/item/weapon/grab/stucked(M, src)
					M.put_in_active_hand(W)
					grabbed_by += W
					W.synch()
					LAssailant = M
					return
				var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)
				if(buckled)
					to_chat(M, "<span class='combat'>You cannot grab</span> <span class='combatbold'>[src]>/span><span class='combat'>, \he is buckled in!</span>")
				if(!G)	//the grab will delete itself in New if affecting is anchored
					return
				M.put_in_active_hand(G)
				grabbed_by += G
				G.synch()
				LAssailant = M

				return 1

			else
				var/datum/organ/external/affecting = get_organ(M.zone_sel.selecting)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("<span class='hitbold'>[M]</span> <span class='hit'>tries to grab</span> <span class='hitbold'>[src]'s</span> <span class='hit'>[affecting.display_name] but misses!</span>")
				M.combatfail(12, 40)

		if("hurt")
			var/mob/living/carbon/human/P = src //quem ta recebendo a porrada
			var/datum/unarmed_attack/attack = M?.species?.unarmed //como alguem ta te atacando
			var/datum/organ/external/affecting = get_organ(get_zone_with_miss_chance_new(M.zone_sel.selecting, src)) //qual orgao vai acertar
			var/damageType = "PUNCH" //para armadura
			var/punchType = ""
			var/damage = rand(0, 4)
			var/dmgTXT = ""

			if(!P.can_hit(M)) //nao da pra acertar
				return

			M.adjustStaminaLoss(rand(2,3))//ja ta balangando o braço, gasta stamina

			if(affecting?.status && affecting?.status & ORGAN_DESTROYED) //nao da pra bater em limb que nao existe
				to_chat(M, "<span class='combatbold'>[pick(nao_consigoen)] Their limb is destroyed.</span>")
				visible_message("<span class='hitbold'>[M]</span><span class='hit'> misses trying to attack </span><span class='hitbold'>[src]'s</span><span class='hit'> [affecting] with the fist!</span>")
				playsound(loc, attack.miss_sound, 25, 1)
				return

			if(is_it_high(M)) // ta muito alto
				visible_message("<span class='hitbold'>[M]</span><span class='hit'> misses trying to attack </span><span class='hitbold'>[src]'s</span><span class='hit'> [affecting] with the fist!</span>")
				to_chat(M, "<span class='combatbold'>[pick(nao_consigoen)] too high.</span>")
				playsound(loc, attack.miss_sound, 25, 1)
				return

			if(attempt_dodge(src, M) && canmove && !stat && c_intent == "dodge") // nao da pra desviar deitado
				visible_message("<span class='hitbold'>[M]</span><span class='hit'> misses trying to attack </span><span class='hitbold'>[src]'s</span><span class='hit'> [affecting] with the fist!</span>")
				do_dodge()
				return

			if(attempt_parry(src, M, strToDamageModifier(M.my_stats.st, src.my_stats.ht)) && src.c_intent == "parry" && !src.sleeping && src.stat == 0) // parry de soco
				visible_message("<span class='hitbold'>[M]</span><span class='hit'> misses trying to attack </span><span class='hitbold'>[src]'s</span><span class='hit'> [affecting] with the fist!</span>")
				do_parry(src, M)
				return

			if(M.combat_mode && prob(1) && !prob(M.my_skills.GET_SKILL(SKILL_MELEE)+3*10))
				visible_message("<span class='hitbold'>[M.name]</span> <span class='hit'>loses their balance trying to punch [src]!</span> ")
				M.resting = 1
				playsound(loc, attack.miss_sound, 25, 1)

			if(!M.combat_mode && prob(1))
				visible_message("<span class='hitbold'>[M.name]</span> <span class='hit'>loses their balance trying to punch [src]!</span> ")
				to_chat(M, "WHAT HAVE I DONE WRONG?!")
				M.rotate_plane()
				M.resting = 1
				playsound(loc, attack.miss_sound, 25, 1)

			if(HULK in M.mutations) //missplace do caralho mas onde possso botar?
				damage += 25

			if(M.gloves)
				if(istype(M?.gloves,/obj/item/clothing/gloves/combat/gauntlet))
					damageType = "GAUNTLET"

			if(M.combat_mode && prob(M.my_skills.GET_SKILL(SKILL_MELEE)+3*10))
				punchType = "skillful" // adroitly/skillfuly/adeptly
			else
				if(prob(60))
					punchType = "clumsy" //clumsily/embarassedly/awkwardly/ungainly
					damage = damage/2
				else
					punchType = "none"
					damage = damage/1.2

			var/armor_block = run_armor_check(affecting.name, "melee", null, damageType)

			if(M.zone_sel.selecting != affecting.name)
				dmgTXT += "<span class='hitbold'>[M] aims for the [get_organ(M.zone_sel.selecting)], but punches [punchType == "clumsy" ? pick("clumsily", "embarassedly", "skillfuly", "ungainly") : punchType == "skillful" ? pick("adroitly", "skillfuly","adeptly") : ""] [src]'s [affecting.display_name] with the [damageType == "GAUNTLET" ? "armoured" : ""] fist! "
			else
				dmgTXT += "<span class='hitbold'>[M] [pick(attack.attack_verb)]es [punchType == "clumsy" ? pick("clumsily", "embarassedly", "skillfuly", "ungainly") : punchType == "skillful" ? pick("adroitly", "skillfuly","adeptly") : ""] [src]'s [affecting.display_name] [damageType == "GAUNTLET" ? "with their armoured fist" : ""]. "


			if(armor_block == ARMOR_BLOCKED)
				dmgTXT += "<span class='hit'>A mediocre hit! Armor stops the damage.</span> "
				M.visible_message(dmgTXT)
				var/datum/organ/external/TT = M:organs_by_name["r_hand"]
				if (M.hand)
					TT = M:organs_by_name["l_hand"]
				TT.take_damage(6)
				playsound(loc, attack.attack_sound, 100, 1, -1)
				return

			if(armor_block == ARMOR_SOFTEN)
				if(!istype(M?.gloves,/obj/item/clothing/gloves/combat/gauntlet))
					dmgTXT += "<span class='hit'>Armor softens the damage.</span> "
					var/datum/organ/external/TT = M:organs_by_name["r_hand"]
					if (M.hand)
						TT = M:organs_by_name["l_hand"]
					TT.take_damage(2)


			if(prob(5+(my_skills.GET_SKILL(SKILL_MELEE)*2)))
				dmgTXT += "<span class='crithit'>CRITICAL HIT!</span> "
				damage += rand(10,20)
				if(affecting.name == "head")
					if(prob(80))
						src.CU()
				if(damage >= 15)
					if(affecting.name == "r_leg" || affecting.name == "l_leg" || affecting.name == "r_foot" || affecting.name == "l_foot")
						if(prob(80))
							apply_effect(10, WEAKEN, armor_block)
					if(affecting.name == "vitals")
						if(prob(50-src.my_stats.ht))
							src.vomit()
				if(!src.resting && !src.lying)
					if(prob(70) && src.head)
						var/obj/item/HAT = src.head
						if(!istype(HAT, /obj/item/clothing/head/helmet))
							src.drop_from_inventory(HAT)

			var/weakenProb = null
			var/stunProb = null

			if(!src.combat_mode)
				weakenProb += 10
				stunProb += 20
			if(src.combat_mode)
				weakenProb -= 10
				stunProb += 20
			if(M in src?.hidden_mobs)
				weakenProb += 60
				stunProb += 60
			if(M.combat_mode)
				weakenProb += 5
				stunProb += 5

			if(!attack.sharp && !attack.edge)
				var/hitcheck = rand(0, 9)
				if(affecting.display_name == "mouth" ? prob(affecting.brute_dam) : prob(0)) //MUCH higher chance to knock out teeth if you aim for mouth
					var/datum/organ/external/mouth/MH = src.get_organ("mouth")
					if(MH.knock_out_teeth(get_dir(M, src), round(rand(28, 38) * ((hitcheck*2)/100))))
						dmgTXT += "<span class='hit'>Teeth were blown!</span> "
						if(prob(25))
							src.CU()

			if(affecting.name == "head" && prob(weakenProb - src.my_stats.ht + M.my_stats.st) && damage >= 7 || affecting.name == "face" && prob(weakenProb - src.my_stats.ht + M.my_stats.st) && damage >= 7)
				dmgTXT += "<span class='hitbold'>[src]</span> <span class='hit'>is weakened!</span> "
				apply_effect(rand(1,4), WEAKEN, armor_block)
				src.receive_damage()
				if(prob(65))
					src.CU()
			if(affecting.name == "vitals" && prob((70-(src.my_stats.ht*2)) + M.my_stats.st) && damage >= 23)
				apply_effect(rand(1,4), WEAKEN, armor_block)
				src.vomit()
				if(prob(65))
					src.CU()

			if(affecting.name == "head" && prob(weakenProb - src.my_stats.ht + M.my_stats.st/2) && damage >= 10 || affecting.name == "face" && prob(weakenProb - src.my_stats.ht + M.my_stats.st/2) && damage >= 10)
				var/rand1 = rand(1,2)
				if(rand1 == 1)
					apply_effect(13, PARALYZE, armor_block)
					dmgTXT += "<span class='hitbold'>[src]</span> <span class='hit'>has been knocked unconscious!</span> "
					src.ear_deaf = max(src.ear_deaf,6)
					src.receive_damage()
				if(rand1 == 2)
					apply_effect(6, STUN, armor_block)
					dmgTXT += "<span class='hitbold'>[src]</span> <span class='hit'>has been stunned down!</span> "
					src.ear_deaf = max(src.ear_deaf,6)
					src.receive_damage()

			damage += strToDamageModifier(M.my_stats.st, src.my_stats.ht)
			playsound(loc, attack.attack_sound, 100, 1)
			apply_damage(damage, BRUTE, affecting, armor_block, sharp=attack.sharp, edge=attack.edge)
			update_canmove()

			if(src.gender == MALE && M.gender == FEMALE || src.gender == FEMALE && M.gender == MALE)
				if(src.vice == "Masochist")
					src.viceneed = 0

			if(istype(loc, /turf/simulated) && affecting.brute_dam > 50 || istype(loc, /turf/simulated) && damage >= 23 && !(armor_block == ARMOR_SOFTEN))
				var/turf/simulated/T = loc
				T.add_blood(src)
				M.bloody_hands(src)
				if(affecting.brute_dam > 70)
					M.bloody_body(src)

			if(M.raged)
				M.adjustStaminaLoss(rand(12, 15))

			if(check_event("want_punch"))
				var/datum/happiness_event/want_punch/mood = events["want_punch"]
				if(mood.pidor == src && prob(50))
					clear_event("want_punch")


			if(M.my_stats.st >= src.my_stats.ht+7 && !attack.sharp && !src.lying)
				var/diferenca = M.my_stats.st - src.my_stats.ht+7
				var/turf/target = get_turf(src.loc)
				var/range = src.throw_range
				var/throw_dir = get_dir(M, src)
				for(var/i = 1; i < range; i++)
					var/turf/new_turf = get_step(target, throw_dir)
					target = new_turf
					if(new_turf.density)
						break
				if(prob(90) && src.head)
					var/obj/item/HAT = src.head
					if(!istype(HAT, /obj/item/clothing/head/helmet))
						src.drop_from_inventory(HAT)
				src.throw_at(target, rand(diferenca,diferenca+1), src.throw_speed)
				sleep(4)
				Weaken(4)

			visible_message(dmgTXT)
			update_transform()
			if(armor_block != ARMOR_SOFTEN)
				attack.special_act(src)


		if("disarm")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Disarmed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been disarmed by [M.name] ([M.ckey])</font>")
			if(iszombie(src))
				return
			log_attack("[M.name] ([M.ckey]) disarmed [src.name] ([src.ckey])")
			M.adjustStaminaLoss(rand(3,5))//No more spamming disarm without consequences.

			if(istype(M?.species, /datum/species/human/alien) && ishuman(src))
				var/obj/item/I = null
				I = get_active_hand()
				if(I && !prob(M.my_skills.GET_SKILL(SKILL_MELEE)))
					src.drop_from_inventory(I)
					throw_at(get_edge_target_turf(I, pick(alldirs)), rand(1,3), throw_speed)//Throw that sheesh away
					playsound(loc, pick('sound/weapons/bladeparry1.ogg', 'sound/weapons/bladeparry2.ogg', 'sound/weapons/bladeparry3.ogg', 'sound/weapons/bladeparry4.ogg'), 25, 1)


			if(w_uniform)
				w_uniform.add_fingerprint(M)
			//var/datum/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))

			if (istype(r_hand,/obj/item/weapon/gun) || istype(l_hand,/obj/item/weapon/gun))
				var/obj/item/weapon/gun/W = null
				var/chance = 0

				if (istype(l_hand,/obj/item/weapon/gun))
					W = l_hand
					chance = hand ? 40 : 20

				if (istype(r_hand,/obj/item/weapon/gun))
					W = r_hand
					chance = !hand ? 40 : 20

				if (prob(chance))
					visible_message("<span class='crithit'>CRITICAL FAIL!</span> <span class='hitbold'>[src]'s</span> <span class='hit'>[W] goes off during struggle!</span> ")
					M.combatfail(25, 40)
					var/list/turfs = list()
					for(var/turf/T in view())
						turfs += T
					var/turf/target = pick(turfs)
					return W.afterattack(target,src)

			//var/randn = rand(1, 100)
			//if (randn <= 25)
			//if(affecting.name == "chest")
			var/push_or_disarm = "disarm"
			if(M.zone_sel.selecting == "chest")
				push_or_disarm = "push"
				for(var/obj/item/weapon/grab/G in usr.grabbed_by)
					if (G.state >= 2) return
				if(skillcheck(M.my_skills.GET_SKILL(SKILL_MELEE), 35, null, M) && statcheck(M.my_stats.st, 9, null, M) && statcheck(M.my_stats.dx, 8, null, M))
					//apply_effect(4, WEAKEN, run_armor_check(affecting, "melee"))
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					var/edgeTurf = get_edge_target_turf(src, M.dir)
					src.throw_at(edgeTurf, rand(1,2), 2, src)
					M.adjustStaminaLoss(rand(1,2))
					src.adjustStaminaLoss(rand(2,3))
					visible_message("<span class='hitbold'>[M]</span> <span class='hit'>has pushed</span> <span class='hitbold'>[src]!</span> ")
					return

			var/talked = 0	// BubbleWrap

			//if(randn <= 60)
			//if(affecting.name != "chest")
			if(M.zone_sel.selecting != "chest")
				push_or_disarm = "disarm"
				if(skillcheck(M.my_skills.GET_SKILL(SKILL_MELEE), 70, null, M) && statcheck(M.my_stats.dx, rand(7,10), null, M))
					//BubbleWrap: Disarming breaks a pull
					if(pulling)
						visible_message("<span class='hitbold'>[M]</span> <span class='hit'>has broken</span> <span class='hitbold'>[src]'s</span> <span class='hit'>grip on</span> <span class='hitbold'>[pulling]</span><span class='hit'>!</span> ")
						talked = 1
						stop_pulling()

					//BubbleWrap: Disarming also breaks a grab - this will also stop someone being choked, won't it?
					if(istype(l_hand, /obj/item/weapon/grab))
						var/obj/item/weapon/grab/lgrab = l_hand
						if(lgrab.affecting)
							visible_message("<span class='hitbold'>[M]</span> <span class='hit'>has broken</span> <span class='hitbold'>[src]'s</span> <span class='hit'>grip on</span> <span class='hitbold'>[lgrab.affecting]</span><span class='hit'>!</span> ")
							talked = 1
						spawn(1)
							qdel(lgrab)
					if(istype(r_hand, /obj/item/weapon/grab))
						var/obj/item/weapon/grab/rgrab = r_hand
						if(rgrab.affecting)
							visible_message("<span class='hitbold'>[M]</span> <span class='hit'>has broken</span> <span class='hitbold'>[src]'s</span> <span class='hit>'grip on</span> <span class='hitbold'>[rgrab.affecting]</span><span class='hit'>!</span>")
							talked = 1
						spawn(1)
							qdel(rgrab)
					//End BubbleWrap

					if(!talked)	//BubbleWrap
						drop_item()
						visible_message("<span class='hitbold'>[M]</span> <span class='hit'>has disarmed</span> <span class='hitbold'>[src]</span><span class='hit'>!</span>")
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 80, 0, -1)
					return


			playsound(loc, 'sound/weapons/punchmiss.ogg', 60, 0, -1)
			visible_message("<span class='hitbold'>[M]</span> <span class='hit'>attempted to [push_or_disarm]</span> <span class='hitbold'>[src]</span><span class='hit'>!</span>")
			M.combatfail(12, 40)
	return

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return

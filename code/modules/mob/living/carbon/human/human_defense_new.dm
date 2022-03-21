/obj/item
	var/arterychance = 0
	var/statDependent = TRUE
	var/ignoreArmor = FALSE

/obj/item/weapon/melee/energy/sword
	statDependent = FALSE

/mob/living/carbon/human/proc/attacked_by(var/obj/item/I, var/mob/living/carbon/human/attacker, var/def_zone)
	var/mob/living/carbon/human/victim = src //QUEM TOMA O SOCO SO QUE E RUIM DEMAIS FICAR USANDO SRC
	//ATTACKER E OBVIO O QUE É NE???

	//CHECKS PRA VER SE UM ATAQUE VAI IR OU NAO
	if(!I || !attacker) // ESSA PROC É PRA ITEM APENAS ENTAO SE NAO TIVER ITEM NAO TEM MOTIVO PRA CONTINUAR
		return

	if(istype(attacker.amulet, /obj/item/clothing/head/amulet/breaker)) // SOULBREAKER COLAR
		return

	if(attacker.stunned)
		return
	if(attacker.consyte)
		return

	if(attacker.lifeweb_locked) //O CARA QUE ATACA TA LOCKADO ENTAO ELE NAO DEVIA CONSEGURI ATACAR NEM SEI COMO ELE TA COM UM ITEM NA MAO???
		return

	var/miss_chance_mod = null //chance de errar
	var/specialty_mod = specialty_check(attacker, I)

	switch(attacker.my_skills.GET_SKILL(SKILL_MELEE))
		if(1)
			miss_chance_mod = 20
		if(2)
			miss_chance_mod = 15
		if(3)
			miss_chance_mod = 10
		if(4)
			miss_chance_mod = 0
		if(5)
			miss_chance_mod = -10
		if(6)
			miss_chance_mod = -15
		if(7)
			miss_chance_mod = -20
		if(8)
			miss_chance_mod = -25
		if(9)
			miss_chance_mod = -30
		if(10)
			miss_chance_mod = -40
	miss_chance_mod += I.accuracyImprovement
	miss_chance_mod += specialty_mod
	var/target_zone = def_zone? check_zone(def_zone) : get_zone_with_miss_chance_new(attacker.zone_sel.selecting, src, miss_chance_mod)
	var/datum/organ/external/affecting = get_organ(target_zone)
	var/dmgTXT = null //Texto do dano
	var/hit_area = affecting.display_name

	if(!affecting)
		return


	if(victim == attacker)
		target_zone = attacker.zone_sel.selecting


	if(!target_zone)
		playsound(loc, I.swing_sound, 100, 1, -1)
		visible_message("<span class='hitbold'>[attacker]</span> <span class='hit'>tries to attack</span> <span class='hitbold'>[src.name]'s</span> <span class='hitbold'>[affecting.display_name] with \the [I], but misses!</span> ")
		return


	if(is_it_high(attacker))  // ta muito alto nao da pra acertar!!
		playsound(loc, I.swing_sound, 100, 1, -1)
		visible_message("<span class='hitbold'>[attacker]</span> <span class='hit'>tries to reach</span> <span class='hitbold'>[src]'s</span> <span class='hit'>[affecting.display_name] with the <span class='hitbold'>[I]</span>, but [affecting.display_name] is too high!</span> ")
		return

	if(attempt_dodge(victim, attacker) && victim.c_intent == "dodge" && victim.canmove && !victim.lying && victim.stat == 0)
		playsound(loc, I.swing_sound, 100, 1, -1)
		visible_message("<span class='hitbold'>[attacker]</span> <span class='hit'>tries to [I.attack_verb.len ? pick(I.attack_verb) : "attack"]</span> <span class='hitbold'>[src]'s</span> <span class='hit'>[target_zone] with his [capitalize(I.name)], but [src] dodges the attack!</span>")
		victim.do_dodge()
		return


	if(attempt_parry(victim, attacker, I.force) && victim.c_intent == "parry" && !victim.sleeping && victim.stat == 0)
		playsound(loc, I.swing_sound, 100, 1, -1)
		visible_message("<span class='hitbold'>[attacker]</span> <span class='hit'>tries to [I.attack_verb.len ? pick(I.attack_verb) : "attack"]</span> <span class='hitbold'>[src]'s</span> <span class='hit'>[affecting.display_name] with his [capitalize(I.name)], but [src] parries the attack!</span> ")
		do_parry(victim, attacker)
		return


	if(affecting.status & ORGAN_DESTROYED)
		playsound(loc, I.swing_sound, 100, 1, -1)
		visible_message("<span class='hitbold'>[attacker]</span> <span class='hit'>tries to [pick(I.attack_verb)]</span> <span class='hitbold'>[src]'s</span> <span class='hit'>[affecting.display_name] with [capitalize(I.name)], but the limb is <span class='combatbold'>DESTROYED</span>!</span> ")
		return


	if(I.attack_verb.len)
		dmgTXT += "<span class='hitbold'>[attacker]</span> <span class='hit'>[pick(I.attack_verb)]</span> <span class='hitbold'>[src]'s</span> <span class='hit'>[affecting.display_name] with [capitalize(I.name)].</span> "

	else
		dmgTXT += "<span class='hitbold'>[attacker]</span> <span class='hit'>attacks</span> <span class='hitbold'>[src]'s</span> <span class='hit'>[affecting.display_name] with [capitalize(I.name)].</span> "


	if(I.swing_sound)
		playsound(src, I.swing_sound, 100, 1, -1)


	var/weaponsharp = is_sharp(I)
	var/weaponedge = has_edge(I)

	if(!I.force)
		return


	var/armor = run_armor_check(affecting.name, "melee", I)
	var/enddamage = I.force

	enddamage = I.statDependent ? I.getNewWeaponForce(attacker.my_stats.st, victim.my_stats.ht) : I.force

	if(armor == ARMOR_BLOCKED)
		dmgTXT += "<span class='hit'>A mediocre hit! Armor stops the damage.</span> "
		attacker.visible_message(dmgTXT)
		I.damageItem("MEDIUM")
		I.damageSharp("MEDIUM")
		return

	if(armor == ARMOR_SOFTEN)
		dmgTXT += "<span class='hit'>Armor softens the damage.</span> "
		I.damageItem("SOFT")
		I.damageSharp("SOFT")
		var/armadura = getarmor(def_zone, "melee")
		enddamage = max(0, enddamage - armadura) // podia ter usado /= mas isso e estranho
		if(enddamage == 0)
			dmgTXT += "<span class='hit'>No damage has been dealt.</span> "

	if((!has_edge(I) && is_sharp(I)) && !(affecting.status & ORGAN_DESTROYED) && affecting.canBeRemoved && (enddamage >= affecting.delimb_min_damage) && armor != ARMOR_SOFTEN && prob(25))
		if(victim.shouldIStun(enddamage))
			victim.Weaken(15)
			if(prob(15))
				victim.Paralyse(rand(5, 8))
		affecting.droplimb()

	if(istype(I, /obj/item/weapon/whip)) //le nojeira coding
		apply_damage(1.5, BRUTE, affecting, armor, sharp=weaponsharp, edge=weaponedge, used_weapon=I)
		victim.viceneed = 0
		var/turf/T = get_step(victim.loc, victim.dir)
		for(var/obj/structure/lifeweb/statue/S in T)
			if(istype(S, /obj/structure/lifeweb/statue/comatic) || istype(S, /obj/structure/lifeweb/statue/wcross))
				if(victim?.religion == "Gray Church")
					if(victim?.w_uniform == null && victim?.wear_suit == null)
						victim?.add_event("godsmiles", /datum/happiness_event/whipchurch)
						if(victim?.check_event("epitemia"))
							var/datum/happiness_event/epitemia/mood = victim.events["epitemia"]
							if(mood?.epitemia_type == WHIP_SELF)
								victim?.free_sins()

	apply_damage(enddamage, I.damtype, affecting, armor, sharp=weaponsharp, edge=weaponedge, used_weapon = I)

	if(I.poisoned.len)
		for(var/list/L in I.poisoned)
			reagents.add_reagent(L[1], L[2])
		I.poisoned = list()
	if(I.isBlunts() && config.bones_can_break && !(affecting.status & ORGAN_BROKEN) && (enddamage >= affecting.min_broken_damage || affecting.brute_dam >= affecting.min_broken_damage))
		affecting.fracture()

		if(victim.shouldIStun(enddamage))
			victim.mob_rest()

		dmgTXT += "<span class='combatbold'>A bone was fractured!</span> "


	if(I.sharp && armor != ARMOR_SOFTEN || I.edge && armor != ARMOR_SOFTEN)
		if(prob(affecting.artery_prob / 2))
			if(affecting.sever_artery())
				if(victim.shouldIStun(enddamage))
					if(prob(80))
						victim.Paralyse(12)
				if(affecting.artery_name == "carotid artery")
					dmgTXT +="<span class='combatbold'>The carotid artery has been dissected!</span>"
				else
					dmgTXT +="<span class='combatbold'>An artery has been torn!</span>"
		if(prob(35))
			if(affecting.hasVocal && !affecting.VocalTorn)
				if(affecting.artery_name == "carotid artery")
					dmgTXT +="<span class='combatbold'>Vocal chords were torn!</span>"
					affecting.VocalTorn = TRUE

	if(I.sharp && armor != ARMOR_SOFTEN && affecting.has_finger && prob(rand(10,18)+enddamage))
		affecting.ripout_fingers(get_dir(attacker, src), round(rand(28, 38) * ((I.force*1.5)/100)))

	if(I.isBlunts())
		var/hitcheck = rand(0, 9)
		if(enddamage != 0)
			if(affecting.display_name == "mouth" ? prob(enddamage) : prob(0)) //MUCH higher chance to knock out teeth if you aim for mouth
				var/datum/organ/external/mouth/MM = src.get_organ("mouth")
				if(MM.knock_out_teeth(get_dir(attacker, src), round(rand(28, 38) * ((hitcheck*2)/100))))
					src.visible_message("<span class='crithit'>[src]'s teeth sail off in an arc!</span>", \
					"<span class='crithit'>[src]'s teeth sail off in an arc!</span>")
					src.receive_damage()
			if(affecting.display_name == "mouth" ? prob(35) : affecting.display_name == "head" ? prob(50) : affecting.display_name == "face" ? prob(40) : prob(0))
				if(!src.resting && !src.lying)
					if(prob(90) && src.head)
						var/obj/item/HAT = src.head
						if(!istype(HAT, /obj/item/clothing/head/helmet))
							src.drop_from_inventory(HAT)
				if(prob(35)-(src.my_stats.ht+src.my_stats.st))
					src.CU()
					src.Stun(rand(1,3))
					src.visible_message("<span class='crithit'>[src] is stunned by the blow!</span>")
			if(affecting.name == "r_leg" || affecting.name == "l_leg" || affecting.name == "r_foot" || affecting.name == "l_foot")
				if(prob(25-(src.my_stats.ht+src.my_stats.st)))
					src.Stun(rand(1,3))
					if(prob(80))
						src.Weaken(4)

	if(istype(affecting, /datum/organ/external/vitals) && I.sharp)
		var/datum/organ/external/vitals/V = affecting
		var/modifier = 0
		if(I.penetrating)
			modifier = rand(25,40)
		if(prob(8+modifier))
			dmgTXT += "<span class='combatbold'>An internal organ was damaged!</span> "
			var/datum/organ/internal/damagedOrgan = pick(V.internal_organs)
			src?.emote("agonydeath")
			damagedOrgan.take_damage(rand(10,20))
			src.Stun(rand(1,3))
			if(prob(60-src.my_stats.ht))
				src.vomit()


	if(istype(affecting, /datum/organ/external/head) && I.isBlunts())
		var/datum/organ/external/head/E = affecting
		var/probSkull = E.brute_dam / 11
		if(!E.brained && E.brute_dam > rand(80, 90))
			if(prob(probSkull))
				E.breakskull()
				E.disfigure()

				my_stats.it -= rand(3,5)
				dmgTXT += "<span class='combatbold'>The skull breaks with a sickening cracking sound!</span> "
				if(!iszombie(src) && !ismonster(src))
					for(var/mob/living/carbon/human/HHH in range(src,9))
						if(!HHH.terriblethings)
							HHH.add_event("terriblething", /datum/happiness_event/disgust/terriblethings)
						if(HHH.vice == "Sensitivity")
							if(prob(80))
								HHH.vomit()
								if(prob(80))
									HHH.emote(pick("scream","cry"))
									HHH.stat = 1
				if(prob(55))

					for(var/mob/O in viewers(src, null))
						if(O == src)
							continue
						O.show_message(text("<span class='hitbold'[name]</span> <span class='hit'>starts having a seizure!</span>"), 1)
					Paralyse(10)
					Jitter(1000)
	var/bloody = 1
	var/damagemod = I.force * 2
	var/truemod
	if(I.sharp)
		if(I.sharpness <= 10)
			truemod = I.force / 4
		if(I.sharpness <= 40)
			truemod = I.force / 3
		if(I.sharpness <= 60)
			truemod = I.force / 2
		else
			truemod = 0
		damagemod = (I.force * 2)-(truemod*2)
	if(((I.damtype == BRUTE) || (I.damtype == HALLOSS)) && prob(25 + (damagemod)))
		I.add_blood(src)	//Make the weapon bloody, not the person.
		attacker.update_inv_r_hand()
		attacker.update_inv_l_hand()
//		if(user.hand)	user.update_inv_l_hand()	//updates the attacker's overlay for the (now bloodied) weapon
//		else			user.update_inv_r_hand()	//removed because weapons don't have on-mob blood overlays

	if (I.force && I.hitsound)//We want to make sure the hit actually goes through before we play any sounds.
		playsound(src, I.hitsound, 100, 1, -1)
		I.damageItem("SOFT")
		I.damageSharp("SOFT")

	var/weakenProb = 0
	var/srcStatsHT = src.my_stats.ht
	if(!src.combat_mode)
		weakenProb += 30
	if(src.combat_mode)
		weakenProb -= 35
	if(armor == ARMOR_SOFTEN)
		weakenProb -= 60
	if(attacker in src?.hidden_mobs)
		weakenProb += 60

		if(hit_area == "head")
			if(wear_mask)
				wear_mask.add_blood(src)
				update_inv_wear_mask(0)
			if(head)
				head.add_blood(src)
				update_inv_head(0)
			if(glasses && prob(33))
				glasses.add_blood(src)
				update_inv_glasses(0)
		else
			bloody_body(src)

		if(hit_area == "head" || hit_area == "mouth" || hit_area == "face")//Harder to score a stun but if you do it lasts a bit longer
			if(prob(I.force + affecting.brute_dam + affecting.burn_dam)-80 || prob(weakenProb-srcStatsHT*4))
				var/randa = rand(1,2)
				if(enddamage != 0)
					if(randa == 1)
						apply_effect(13, PARALYZE, armor)
						dmgTXT += "<span class='combatbold'>[src] has been knocked unconscious!</span> "
						src.ear_deaf = max(src.ear_deaf,6)
						if(src != attacker && I.damtype == BRUTE)
							ticker.mode.remove_revolutionary(mind)
					if(randa == 2)
						apply_effect(13, WEAKEN, armor)
						dmgTXT += "<span class='hitbold'>[src] has been weakened!</span> "
						src.ear_deaf = max(src.ear_deaf,6)
						if(src != attacker && I.damtype == BRUTE)
							ticker.mode.remove_revolutionary(mind)
			if(bloody)//Apply blood
				if(wear_mask)
					wear_mask.add_blood(src)
					update_inv_wear_mask(0)
				if(head)
					head.add_blood(src)
					update_inv_head(0)
				if(glasses && prob(33))
					glasses.add_blood(src)
					update_inv_glasses(0)

			if("chest")//Easier to score a stun but lasts less time
				if(prob((I.force - 10)) || prob(weakenProb-srcStatsHT*8))
					if(enddamage == 0)
						apply_effect(6, WEAKEN, armor)
						dmgTXT += "<span class='hitbold'>[src] has been knocked down! </span> "
				if(bloody)
					bloody_body(src)
	attacker.visible_message(dmgTXT)

	var/Iforce = I.force
	if(Iforce > 10 || Iforce >= 5 && prob(33))
		forcesay("-")	//forcesay checks stat already
	if(src.gender == MALE && attacker.gender == FEMALE || src.gender == FEMALE && attacker.gender == MALE)
		if(src.vice == "Masochist")
			src.viceneed = 0
	if(attacker.my_stats.st >= my_stats.ht+4 && !lying && !I.sharp && !I.edge)
		var/turf/target = get_turf(src.loc)
		var/range = src.throw_range
		var/throw_dir = get_dir(attacker, src)
		for(var/i = 1; i < range; i++)
			var/turf/new_turf = get_step(target, throw_dir)
			target = new_turf
			if(new_turf.density)
				break
		src.throw_at(target, rand(2,4), src.throw_speed)
		sleep(4)
		Weaken(4)
	update_transform()
	update_canmove()
	if (I.damtype == BRUTE && !I.is_robot_module())
		var/damage = I.force
		if (armor)
			damage /= armor+1

		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_chance = weaponedge? (damage/I.w_class)/2 : damage/(I.w_class*3)
		var/embed_threshold = weaponedge? 10*I.w_class : 20*I.w_class

		//Sharp objects will always embed if they do enough damage.
		if((weaponedge && damage > (10*I.w_class)) || (damage > embed_threshold && prob(embed_chance)))
			if(prob(2))
				affecting.embed(I)

		if(victim?.isVampire && I.silver)
			if(armor == ARMOR_SOFTEN)
				return
			else
				victim.Weaken(4)
				victim.apply_damage(damage*1.5, BRUTE, affecting)
				flash_pain()
				victim.rotate_plane(1)
				if(prob(40))
					victim.vessel.remove_reagent("blood",25)
				if(prob(50))
					victim.emote("SCREECHES in pain!")
					playsound(victim.loc, pick('sound/effects/vamphit1.ogg', 'sound/effects/vamphit2.ogg', 'sound/effects/vamphit3.ogg'), 75, 0, -1)
					if(!victim.ExposedFang)
						playsound(victim.loc, ('sound/effects/fangs1.ogg'), 50, 0, -1)
						victim.visible_message("<span class='combatbold'>[victim]</span> <span class='combat'>exposes fangs!</span>")
						victim.ExposedFang = TRUE
						victim.update_body()
	return 1

/mob/living/carbon/human/proc/shouldIStun(var/force = 0)
	var/chance = 100

	for(var/x = 0; x < my_stats.ht; x++)
		chance -= rand(9, 11)

	chance += force / 2

	if(combat_mode)
		chance -= rand(25, 35)

	chance = max(chance, 5)
	chance = min(chance, 90)
	if(prob(abs(chance)))
		return 1
	return

/mob/living/carbon/human/proc/specialty_check(var/mob/living/carbon/human/attacker, var/obj/item/I)
	if(istype(I, /obj/item/weapon))
		var/obj/item/weapon/W = I
		var/specialty_mod = null
		switch(W.weaponteaching)
			if("SWORD")
				if(attacker.my_skills.GET_SKILL(SKILL_SWORD))
					switch(attacker.my_skills.GET_SKILL(SKILL_SWORD))
						if(1)
							specialty_mod = -10
						if(2)
							specialty_mod = -20
						if(3)
							specialty_mod = -30
						if(4)
							specialty_mod = -40
						if(5)
							specialty_mod = -50
			if("POLEARM")
				if(attacker.my_skills.GET_SKILL(SKILL_STAFF))
					switch(attacker.my_skills.GET_SKILL(SKILL_STAFF))
						if(1)
							specialty_mod = -10
						if(2)
							specialty_mod = -20
						if(3)
							specialty_mod = -30
						if(4)
							specialty_mod = -40
						if(5)
							specialty_mod = -50
			if("AXE")
				if(attacker.my_skills.GET_SKILL(SKILL_SWING))
					switch(attacker.my_skills.GET_SKILL(SKILL_SWING))
						if(1)
							specialty_mod = -10
						if(2)
							specialty_mod = -20
						if(3)
							specialty_mod = -30
						if(4)
							specialty_mod = -40
						if(5)
							specialty_mod = -50
			if("CLUB")
				if(attacker.my_skills.GET_SKILL(SKILL_SWING))
					switch(attacker.my_skills.GET_SKILL(SKILL_SWING))
						if(1)
							specialty_mod = -10
						if(2)
							specialty_mod = -20
						if(3)
							specialty_mod = -30
						if(4)
							specialty_mod = -40
						if(5)
							specialty_mod = -50
			if("SPEAR")
				if(attacker.my_skills.GET_SKILL(SKILL_STAFF))
					switch(attacker.my_skills.GET_SKILL(SKILL_STAFF))
						if(1)
							specialty_mod = -10
						if(2)
							specialty_mod = -20
						if(3)
							specialty_mod = -30
						if(4)
							specialty_mod = -40
						if(5)
							specialty_mod = -50
			if("KNIFE")
				if(attacker.my_skills.GET_SKILL(SKILL_KNIFE))
					switch(attacker.my_skills.GET_SKILL(SKILL_KNIFE))
						if(1)
							specialty_mod = -10
						if(2)
							specialty_mod = -20
						if(3)
							specialty_mod = -30
						if(4)
							specialty_mod = -40
						if(5)
							specialty_mod = -50
		return specialty_mod
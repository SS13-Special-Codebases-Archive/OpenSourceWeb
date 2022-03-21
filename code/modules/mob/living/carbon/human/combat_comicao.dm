/mob/living/proc/attempt_dodge(mob/living/carbon/human/C=src, mob/living/attacker)
	if(!ishuman(C)) return 0
	if(attacker in src?.hidden_mobs) return 0
	if(C == attacker) return 0
	if(C.toggle_resisting) return 0
	if(!C.combat_mode) return 0
	if(C.c_intent != "dodge") return 0
	if(C.stat != 0) return 0
	if(!C.canmove) return 0
	if(C.lying) return 0

	var/modifier = 0
	if(C.meanwhile_combat_intent == "defend")
		modifier += 3

	if(iszombie(C))
		modifier -= 10

	if(C.grabbed_by.len)
		for(var/x = 1; x <= C.grabbed_by.len; x++)
			if(C.grabbed_by[x])
				modifier -= 5
				break;

	if(ishuman(src))
		var/mob/living/carbon/human/enemy = attacker
		if(enemy?.isChild())
			modifier += 1
		if(FAT in enemy.mutations)
			modifier -= 3
	switch(stamina_loss)
		if(0 to 29)
			modifier += 0
		if(30 to 49)
			modifier -= 1
		if(50 to INFINITY)
			modifier -= 3

	if(c_intent == "dodge" && !lying)
		var/dx_dodge = clamp(C.my_stats.dx, 0 , 13)
		var/list/roll_result = roll3d6(C, dx_dodge, modifier, FALSE, TRUE)
		switch(roll_result[GP_RESULT])
			if(GP_CRITSUCCESS)
				return 1
			if(GP_SUCCESS)
				return 1
			if(GP_FAILED)
				return 0
			if(GP_CRITFAIL)
				C.adjustStaminaLoss(rand(5,10))
				return 0
	return 0


/mob/living/proc/do_dodge()
	var/lol = pick(cardinal)//get a direction.
	if(ishuman(src))
		if(meanwhile_combat_intent == "defend")
			adjustStaminaLoss(2)
		var/mob/living/carbon/human/H = src
		var/dexteridade = H.my_stats.dx-9
		adjustStaminaLoss(6-dexteridade)
	else
		adjustStaminaLoss(6)//add some stamina loss
	playsound(loc, 'sound/weapons/punchmiss.ogg', 100, 1)//play a sound
	step(src,lol)//move them
	visible_message("<span class='hitbold'>[src]</span><span class='hit'> dodges out of the way!</span>")
	shake_camera(src, 1, 1)


/mob/living/proc/attempt_parry(mob/living/carbon/human/C=src, mob/living/attacker, var/damage=0)
	if(attacker in src?.hidden_mobs) return 0
	if(C == attacker) return 0
	if(C.c_intent != "parry") return 0
	if(C.stat != 0) return 0

	var/obj/item/I
	var/modifier

	if(C.combat_mode)
		modifier += 5
	else
		modifier -= 90

	if(iszombie(C))
		modifier -= 90

	if(lying)
		modifier -= 5

	if(get_active_hand())
		I = get_active_hand()
		if(!I) return
		if(C.meanwhile_combat_intent == "defend")
			modifier += 20
		modifier += C.specialty_check(C, I)
		if(c_intent == "parry" && !lying)
			if(stamina_loss < 50 && prob(3+(C.my_skills.GET_SKILL(SKILL_MELEE)*5)+modifier+I.parry_chance))
				return	1
			else if(stamina_loss >= 50 && prob(1+(C.my_skills.GET_SKILL(SKILL_MELEE)*3)+modifier+I.parry_chance))
				return	1
			else if(stamina_loss >= 25 && prob(1+(C.my_skills.GET_SKILL(SKILL_MELEE)*2)+modifier+I.parry_chance))
				return	1
	else
		if(c_intent == "parry")
			var/parry_chance_mod = 0
			parry_chance_mod += modifier
			if(C.meanwhile_combat_intent == "defend")
				parry_chance_mod += 20
			var/hp = 1
			if(istype(C.gloves, /obj/item/clothing/gloves/combat/gauntlet/steel))
				parry_chance_mod += 20
				hp = 0
			if(stamina_loss < 50 && prob(10+(C.my_skills.GET_SKILL(SKILL_MELEE)*5)+parry_chance_mod))
				if(damage > 0 && hp)
					var/MAO = pick("l_hand", "r_hand")
					var/datum/organ/external/E = C.organs_by_name[MAO]
					E.take_damage(damage/3)
				return	1
			else if(stamina_loss >= 50 && prob(1+(C.my_skills.GET_SKILL(SKILL_MELEE)*3)+parry_chance_mod))
				if(damage > 0 && hp)
					var/MAO = pick("l_hand", "r_hand")
					var/datum/organ/external/E = C.organs_by_name[MAO]
					E.take_damage(damage/3)
				return	1
			else if(stamina_loss >= 25 && prob(1+(C.my_skills.GET_SKILL(SKILL_MELEE)*2)+parry_chance_mod))
				if(damage > 0 && hp)
					var/MAO = pick("l_hand", "r_hand")
					var/datum/organ/external/E = C.organs_by_name[MAO]
					E.take_damage(damage/3)
				return	1
	return 0

/mob/living/proc/do_parry(mob/living/carbon/human/user=src, mob/living/attacker)
	var/obj/item/I
	I = get_active_hand()
	if(I)
		if(!I) return
		if(meanwhile_combat_intent == "defend")
			adjustStaminaLoss(2)
		var/sound/parries = sound(pick('sound/weapons/bladeparry1.ogg', 'sound/weapons/bladeparry2.ogg', 'sound/weapons/bladeparry3.ogg', 'sound/weapons/bladeparry4.ogg'), volume = 100)

		if(istype(I, /obj/item/weapon/claymore))
			I.durability -= rand(1,8)
			if(I.sharp)
				I.sharpness -= rand(1,5)
				if(istype(I, /obj/item/weapon/claymore/spear))
					I.durability -= rand(10,30)
					if(prob(50-(I.durability/2)))
						I.durability -= rand(1,5)
			playsound(I, parries, 200, 1)
		else if(istype(I, /obj/item/weapon/melee/energy/sword))
			playsound(I, pick('sound/weapons/energyparry.ogg','sound/weapons/energyparrylas.ogg'), 100, 1)
		else
			playsound(I, 'sound/lfwbcombatuse/parry.ogg', 100)

		visible_message("<span class='hitbold'>[src]</span><span class='hit'> parries the attack with his [I]!</span>")
		shake_camera(user, 1, 1)

		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			var/dexteridade = H.my_stats.dx-9
			adjustStaminaLoss(10-dexteridade)
		else
			adjustStaminaLoss(10)//add some stamina loss

		if(ishuman(attacker))
			var/mob/living/carbon/human/atacante = attacker
			var/melee_user = user.my_skills.GET_SKILL(SKILL_MELEE)
			var/melee_attacker = atacante.my_skills.GET_SKILL(SKILL_MELEE)

			health -= 0.5
			if((melee_attacker-melee_user) > 0 && prob(melee_attacker*10))
				user.visible_message("<span class='hit'>\The [I]</span> <span class='hit'>flies out of</span> <span class='hitbold'>\the [user]'s</span> <span class='hit'>hand!</span> ")
				user.drop_from_inventory(I)
				throw_at(get_edge_target_turf(I, pick(alldirs)), rand(1,3), throw_speed)//Throw that sheesh away
				shake_camera(user, 2, 2)
	else
		if(ishuman(src))
			if(meanwhile_combat_intent == "defend")
				adjustStaminaLoss(2)
			var/mob/living/carbon/human/H = src
			var/dexteridade = H.my_stats.dx-9
			adjustStaminaLoss(10-dexteridade)
		else
			adjustStaminaLoss(10)//add some stamina loss
		var/sound/block = sound(pick('sound/weapons/soft_fist1.ogg', 'sound/weapons/soft_fist2.ogg', 'sound/weapons/soft_fist3.ogg'), volume = 100)
		visible_message("<span class='hitbold'>[src]</span><span class='hit'> parries the attack with his bare fists!</span>")
		playsound(src, block, 200, 1)
		shake_camera(user, 1, 1)
		shake_camera(src, 1, 1)

/proc/get_zone_with_miss_chance_new(zone, var/mob/target, var/miss_chance_mod = 0)
	zone = check_zone(zone)

	var/miss_chance = 10 + miss_chance_mod
	switch(zone)
		if("head")
			miss_chance = 15
		if("throat")
			miss_chance = 45
		if("face")
			miss_chance = 15
		if("l_leg")
			miss_chance = 15
		if("r_leg")
			miss_chance = 15
		if("l_arm")
			miss_chance = 15
		if("r_arm")
			miss_chance = 15
		if("l_hand")
			miss_chance = 20
		if("r_hand")
			miss_chance = 20
		if("l_foot")
			miss_chance = 20
		if("r_foot")
			miss_chance = 20
		if("groin")
			miss_chance = 14
		if("vitals")
			miss_chance = 9
		if("chest")
			miss_chance = 7
		if("mouth")
			miss_chance = 20
	miss_chance = max(miss_chance + miss_chance_mod, 0)
	if(prob(miss_chance))
		if(prob(50))
			return null
		else
			var/t = rand(1, 15)
			switch(t)
				if(1)	return "head"
				if(2)	return "l_arm"
				if(3)	return "r_arm"
				if(4) 	return "chest"
				if(5) 	return "l_foot"
				if(6)	return "r_foot"
				if(7)	return "l_hand"
				if(8)	return "r_hand"
				if(9)	return "l_leg"
				if(10)	return "r_leg"
				if(11)	return "vitals"
				if(12)	return "groin"
				if(13)	return "throat"
				if(14)	return "face"
				if(15)	return "mouth"

	return zone

/mob/living/proc/grabdodge(mob/living/carbon/human/C=src, mob/living/attacker)
	if(attacker in src?.hidden_mobs)
		return 0

	var/modifier = 45
	if(C.meanwhile_combat_intent == "defend")
		modifier += 15

	if(C.combat_mode)
		modifier -= 20
	else
		modifier += 20

	if(attacker.combat_mode)
		modifier += 20
	else
		modifier -= 20

	if(C.grabbed_by.len)
		if(C.grabbed_by[1])
			modifier -= 85

	if(!lying)
		if(ishuman(attacker))
			var/mob/living/carbon/human/enemy = attacker

			var/diff = (enemy.my_skills.GET_SKILL(SKILL_MELEE) + enemy.my_stats.dx) - (C.my_skills.GET_SKILL(SKILL_MELEE) + C.my_stats.dx)

			if(diff < 0)
				var/parsedDiff = diff * -1
				for(var/x = 0; x < parsedDiff; x++)
					modifier += rand(5, 8)
			if(diff > 0)
				for(var/x = 0; x < diff; x++)
					modifier -= rand(5, 8)

			if(enemy.isChild())
				modifier += 15
			if(FAT in enemy.mutations)
				modifier -= 15

		if(!modifier || modifier < 0)
			modifier = 5
		if(prob(modifier))
			return 1
	return 0


/mob/living/carbon/human/proc/is_vulnerable()
	if(!combat_mode)
		return 1
	return 0

/mob/living/carbon/human/proc/miss_chance_last_src(var/mob/living/carbon/human/H = src)
	var/modifierLast = 0
	if(src.lying)
		modifierLast -= 100
	if(src.buckled)
		modifierLast -= 20
	if(!src.combat_mode)
		modifierLast -= 5
	if(FAT in src.mutations)
		modifierLast -= 15
	if(src.isChild())
		modifierLast += 10
	if(iszombie(src))
		modifierLast -= 15
	return modifierLast

/mob/living/carbon/human/proc/miss_chance_last_attacker(var/mob/living/carbon/human/H = src)
	var/modifierLast = 0
	if(!src.combat_mode)
		modifierLast += 15

	if(src.grabbed_by.len)
		for(var/x = 1; x <= src.grabbed_by.len; x++)
			if(src.grabbed_by[x])
				modifierLast += 15
				break;


	return modifierLast

/mob/living/carbon/human/proc/miss_chance_check_melee(var/mob/living/carbon/human/attacker)
	var/miss_chance_mod = 0
	switch(attacker.my_skills.GET_SKILL(SKILL_MELEE))
		if(0)
			miss_chance_mod = 30
		if(1)
			miss_chance_mod = 29
		if(2)
			miss_chance_mod = 28
		if(3)
			miss_chance_mod = 25
		if(4)
			miss_chance_mod = 24
		if(5)
			miss_chance_mod = 23
		if(6)
			miss_chance_mod = 15
		if(7)
			miss_chance_mod = 12
		if(8)
			miss_chance_mod = 10
		if(9)
			miss_chance_mod = 6
		if(10)
			miss_chance_mod = 0
		if(11)
			miss_chance_mod = -6
		if(12)
			miss_chance_mod = -10
		if(13)
			miss_chance_mod = -15
		if(14)
			miss_chance_mod = -20
		if(15)
			miss_chance_mod = -25
		if(16)
			miss_chance_mod = -30
		if(17)
			miss_chance_mod = -35
		if(18)
			miss_chance_mod = -40
		if(19)
			miss_chance_mod = -45
		if(20)
			miss_chance_mod = -50
	return miss_chance_mod

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
//DEFINES ESTAO EM _defines.dm
/*------------------------- GURPS ROLLS E MATH -----------------------
| Sistema de GURPS fudido de teste que usa as regras do GURPS
*-------------------------------------------------------------------*/

/mob/living/proc/Roll3d6display(var/gurps, var/rollamount)
	if(src?.client?.DisplayingRolls)
		var/FailureText = ""
		var/crit = ""
		switch(gurps)
			if(GP_FAILED)
				FailureText = "Failure!"
			if(GP_CRITFAIL)
				FailureText = "Critical Failure!"
				crit = "☠️"
			if(GP_SUCCESS)
				FailureText = "Success!"
			if(GP_CRITSUCCESS)
				FailureText = "Critical Success!"
				crit = "💡"
		to_chat(src, "<i><span class='jogtowalk'>[crit]🎲[rollamount] [FailureText]</span></i>")

//VERBO DE DEBUG LEMBRA DE COMENTAR ISSO QUANDO TER PARTY
/*
/mob/living/carbon/human/verb/Roll3d6()
	var/dice = roll3d6(src.my_stats.st, src.my_stats.dx, src.my_skills.melee) // USA UMA VAR PRA PEGAR A CHANCE DO ROLL
	var/rolled = dice[GP_RESULT]
	var/margin = dice[GP_MARGIN]
	var/roll = dice[GP_DICE]
	to_chat(src, "<span class='jogtowalk'>Rolled 3d6 [src.my_stats.st]ST [src.my_stats.dx]DX [src.my_skills.melee]MELEE</span>")
	switch(rolled) // SWITCH PRA AÇÃO DE CADA ROLL, USA || CASO NÃO TENHA DIFERENÇA
		if(GP_SUCCESS)
			to_chat(src, "<font color='green'>Success</font>") //sucesso - mae de vini engravidada
		if(GP_FAILED)
			to_chat(src, "<font color='red'>Fail</font>") // falha - mae de vini tomou pilula
		if(GP_CRITFAIL)
			to_chat(src, "<font color='red'>Critical Fail</font>") // falha critica - vini nasceu (deformado)
		if(GP_CRITSUCCESS)
			to_chat(src, "<font color='green'>Critical Success</font>") // sucesso critico - vini morreu (abortado)
	to_chat(src, "MARGIN :[margin]")
	to_chat(src, "DICE :[roll]")
*/

proc/human_roll_mods(var/mob/living/carbon/human/H)
	var/BaseMath = 0
	if(H.handcuffed)
		BaseMath -= rand(0,2)
	if(H.legcuffed)
		BaseMath -= rand(0,2)
	if(H.combat_mode)
		BaseMath += rand(0,2)
	if(H.stunned)
		BaseMath -= rand(4,2)
	if(H.weight_state)
		switch(H.weight_state)
			if(WEIGHT_LIGHT)
				BaseMath -= rand(-0.5,0)
			if(WEIGHT_MEDIUM)
				BaseMath -= rand(-1,0)
			if(WEIGHT_HEAVY)
				BaseMath -= rand(-1.5,0)
	switch(H.nutrition)
		if(400 to 550)
			BaseMath += rand(0,1)
		if(220 to 275)
			BaseMath += rand(-0.5,0)
		if(150 to 220)
			BaseMath += rand(-1,0)
		if(100 to 150)
			BaseMath += rand(-1.5,-1)
		if(1 to 100)
			BaseMath += rand(-2.5,-1.5)
		if(-INFINITY to 1)
			BaseMath += rand(-4, -3)
	switch(H.hidratacao)
		if(THIRST_LEVEL_THIRSTY to THIRST_LEVEL_MEDIUM)
			BaseMath += rand(-0.5,0)
		if(150 to THIRST_LEVEL_THIRSTY)
			BaseMath += rand(-1,0)
		if(150 to THIRST_LEVEL_DEHYDRATED)
			BaseMath += rand(-1.5,-1)
		if(THIRST_LEVEL_DEHYDRATED to -INFINITY)
			BaseMath += rand(-2.5,-1.5)
	switch(H.happiness)
		if(MOOD_LEVEL_HAPPY1 to INFINITY)
			BaseMath += rand(0,1)
		if(MOOD_LEVEL_SAD2 to MOOD_LEVEL_SAD1)
			BaseMath += rand(-0.5,0)
		if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
			BaseMath += rand(-1,0)
		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			BaseMath += rand(-1.5,-1)
		if(-5000000 to MOOD_LEVEL_SAD4)
			BaseMath += rand(-2.5,-1.5)

	return BaseMath

proc/roll3d6(var/mob/living/carbon/human/H, var/skill, var/mod, var/hide_roll = FALSE, var/using_stat = FALSE)
	if(!H)
		throw EXCEPTION("roll3d6 called without human!")
		return

	var/BaseMath = 0
	if(!using_stat) //hack. But I didn't want to copy the proc for a slight change.
		var/datum/skill/S = get_skill_data(skill,H.my_skills)
		var/skill_value = get_skill_value(skill,H.my_skills)
		var/using_base = FALSE
		if(!S.spec)
			if(!S.base_stat == SKILL_NONE)
				if(skill_value < (H.my_stats.get_stat(S.base_stat) + S.base_mod))
					skill_value = clamp(H.my_stats.get_stat(S.base_stat), 1, 20)
					skill_value += S.base_mod
					using_base = TRUE
		else
			if(!S.base_stat == SKILL_NONE)
				if(S.combat_skill && skill_value > 0)
					skill_value = clamp(get_skill_value(S.base_stat,H.my_skills),1,20)
					if(skill_value < 0)
						skill_value += S.base_mod
				else if(skill_value < (get_skill_value(S.base_stat,H.my_skills) + S.base_mod))
					skill_value = clamp(get_skill_value(S.base_stat,H.my_skills),1,20)
					skill_value += S.base_mod
					using_base = TRUE

		if(S.multiply && using_base)
			skill_value = skill_value * 2
		BaseMath += skill_value
	else
		BaseMath += skill

	BaseMath += human_roll_mods(H)
	if(mod)
		BaseMath += mod

	BaseMath = clamp(BaseMath,3,18)

	var/result
	var/CritSuccAmount = 4
	var/CritFailAmount = 18
	var/dice = roll("3d6")
	if(BaseMath <= 15)
		CritFailAmount = 17
	if(BaseMath >= 15)
		CritSuccAmount = 5
		if(BaseMath >= 16)
			CritSuccAmount= 6

	if(dice >= CritFailAmount)
		result = GP_CRITFAIL
	else if(dice <= CritSuccAmount)
		result = GP_CRITSUCCESS
	else
		if(dice <= BaseMath)
			result = GP_SUCCESS
		else
			result = GP_FAILED

	if(dice - 10 >= BaseMath)
		result = GP_CRITFAIL

	if(!using_stat)
		switch(result)
			if(GP_CRITFAIL)
				H.learn_skill(skill, null, -2)
			if(GP_FAILED)
				H.learn_skill(skill, null, -1)
			if(GP_SUCCESS)
				H.learn_skill(skill, null, -3)
			if(GP_CRITSUCCESS)
				H.learn_skill(skill, null, -2)

	var/margin = round(BaseMath - dice)
	if(H && !hide_roll)
		H.Roll3d6display(result, dice)
	var/return_list[3]
	return_list[GP_RESULT] = result
	return_list[GP_MARGIN] = margin
	return_list[GP_DICE] = dice

	return return_list
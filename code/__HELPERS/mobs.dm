proc/random_hair_style(gender = MALE, species = "Human")
	var/h_style = "Bald"

	var/list/valid_hairstyles = list()
	for(var/hairstyle in hair_styles_list)
		var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue
		valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)

	return h_style

proc/random_facial_hair_style(gender = MALE, species = "Human")
	var/f_style = "Shaved"

	var/list/valid_facialhairstyles = list()
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue

		valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

	if(valid_facialhairstyles.len)
		f_style = pick(valid_facialhairstyles)

		return f_style

proc/random_detail_style(gender = MALE, species = "Human")
	var/f_style = "None"

	var/list/valid_facialhairstyles = list()
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue

		valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

	if(valid_facialhairstyles.len)
		f_style = pick(valid_facialhairstyles)

		return f_style

proc/random_name(gender, species = "Human", dwarven_name = 0)
	if(!dwarven_name)
		if(gender==FEMALE)	return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else				return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	else
		if(gender==FEMALE)	return capitalize(pick(first_names_dwarven_female)) + " " + capitalize(pick(last_names_dwarven))
		else				return capitalize(pick(first_names_dwarven_male)) + " " + capitalize(pick(last_names_dwarven))


proc/random_skin_tone()
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")		. = -10
		if("afroamerican")	. = -115
		if("african")		. = -165
		if("latino")		. = -55
		if("albino")		. = 34
		else				. = rand(-185,34)
	return min(max( .+rand(-25, 25), -185),34)

proc/skintone2racedescription(tone)
	switch (tone)
		if(30 to INFINITY)		return "albino"
		if(20 to 30)			return "pale"
		if(5 to 15)				return "light skinned"
		if(-10 to 5)			return "white"
		if(-25 to -10)			return "tan"
		if(-45 to -25)			return "darker skinned"
		if(-65 to -45)			return "brown"
		if(-INFINITY to -65)	return "black"
		else					return "unknown"

proc/age2agedescription(age)
	switch(age)
		if(0 to 1)			return "infant"
		if(1 to 3)			return "toddler"
		if(3 to 13)			return "child"
		if(13 to 19)		return "teenager"
		if(19 to 30)		return "young adult"
		if(30 to 45)		return "adult"
		if(45 to 60)		return "middle-aged"
		if(60 to 70)		return "aging"
		if(70 to INFINITY)	return "elderly"
		else				return "unknown"
/*
proc/generate_backstory(age)

	var/lifedream1 = pick(lifedream)
	var/hobby1 = pick(hobby)
	var/hobby2 = pick(hobby)
	var/hobby3 = pick(hobby)
	var/birthplace1 = pick(birthplace)

	if(hobby1 == (hobby2 || hobby3))
		hobby1 = pick(hobby)
	if(hobby2 == (hobby3 || hobby1))
		hobby2 = pick(hobby)
	if(hobby3 == (hobby2 || hobby1))
		hobby3 = pick(hobby)

	if(src.client && src.mind)
		src << "\blue <br><br><b>Good morning [src.name]!</b><br>You are a crew member on a  [vessel_name], born and raised in [birthplace1]. Your favorite hobbies were always [hobby1], [hobby2] and [hobby3], while your lifelong dream is [lifedream1].<br>"
		src.mind.store_memory("You are a crew member on D2K5 Space Observatory Beta 242, born and raised in [birthplace1]. Your favorite hobbies are [hobby1], [hobby2] and [hobby3], while your lifelong dream is [lifedream1].")
*/


proc/add_logs(mob/user, mob/target, what_done, var/admin=1, var/object=null, var/addition=null)
	if(user && ismob(user))
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has [what_done] [target ? "[target.name][(ismob(target) && target.ckey) ? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
	if(target && ismob(target))
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [what_done] by [user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
	if(admin)
		log_attack("<font color='red'>[user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"] [what_done] [target ? "[target.name][(ismob(target) && target.ckey)? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")


proc/ageAndGender2Desc(age, gender)//Used for the radio
	if(gender == FEMALE)
		switch(age)
			if(0 to 15)			return "Girl"
			if(15 to 25)		return "Young Woman"
			if(25 to 60)		return "Woman"
			if(60 to INFINITY)	return "Old Woman"
			else				return "Unknown"
	else
		switch(age)
			if(0 to 15)			return "Boy"
			if(15 to 25)		return "Young Man"
			if(25 to 60)		return "Man"
			if(60 to INFINITY)	return "Old Man"
			else				return "Unknown"
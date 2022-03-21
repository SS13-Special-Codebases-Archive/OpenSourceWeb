/mob/living/proc/getarmortype(var/def_zone)
	return 0

/mob/living/proc/checktype(var/def_zone)
	return 0

/mob/living/proc/getarmorer(var/def_zone)
	return 0

/mob/living/proc/checkarmorer(var/def_zone)
	return 0

/mob/living/carbon/human/getarmortype(var/def_zone)
	if(def_zone)
		if(isorgan(def_zone))
			return checktype(def_zone)
		var/datum/organ/external/affecting = get_organ(ran_zone(def_zone))
		return checktype(affecting)

/mob/living/carbon/human/checktype(var/datum/organ/external/def_zone)
	var/protection = 0
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, l_hand, r_hand, amulet, shoes, wrist_l, wrist_r, gloves)
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone?.body_part)
				if(C.armor_type)
					protection = max(protection, C.armor_type)
	return protection

/mob/living/carbon/human/getarmorer(var/def_zone)
	if(def_zone)
		if(isorgan(def_zone))
			return checkarmorer(def_zone)
		var/datum/organ/external/affecting = get_organ(ran_zone(def_zone))
		return checkarmorer(affecting)

/mob/living/carbon/human/checkarmorer(var/datum/organ/external/def_zone)
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, l_hand, r_hand, amulet, shoes, wrist_l, wrist_r, gloves)
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone?.body_part)
				return C



/mob/living/proc/run_armor_check(var/def_zone = null, var/attack_flag = "melee", var/obj/W = null, var/tipoDeDano = null)
	if(!ishuman(src))
		return 0

	var/armadura = getarmor(def_zone, attack_flag)
	var/armaduraTipo = getarmortype(def_zone)
	var/obj/item/clothing/armor = getarmorer(def_zone)
	var/absorb = 0
	var/sound/SFX = null

	//que isso pra que usar {} isso aqui é javascript agora é??/
	if(W) //se tem arma no processo ele rola esse daqui, tipoDeDano é inutil e fodase
		if(armadura && armaduraTipo) // se tem armor onde o negao acerto
			if(armaduraTipo == ARMOR_LEATHER)
				if(W.sharp && !W.edge || W.sharp && W.edge) // tem fio, W.sharp e W.edge e uma aberração mas ainda tem mto no code
					absorb = ARMOR_BLOCKED
					SFX = sound('sound/armornew/slash_light.ogg', 'sound/armornew/slash_light2.ogg', 'sound/armornew/slash_light3.ogg', 'sound/armornew/slash_light4.ogg', volume = 100)

				if(!W.sharp && W.edge)
					if(prob(max(W.force-armadura, rand(10, 35))))
						absorb = ARMOR_FUDEU
					else
						absorb = ARMOR_SOFTEN
						SFX = sound('sound/armornew/stab_light.ogg', 'sound/armornew/stab_light2.ogg', 'sound/armornew/stab_light3.ogg', volume = 100)


				if(!W.sharp && !W.edge)
					absorb = ARMOR_SOFTEN
					SFX = sound('sound/armornew/blunt_light.ogg', 'sound/armornew/blunt_light2.ogg', 'sound/armornew/blunt_light3.ogg', volume = 100)

			if(armaduraTipo == ARMOR_FODIDA)
				if(W.sharp && !W.edge || W.sharp && W.edge) // tem fio, W.sharp e W.edge e uma aberração mas ainda tem mto no code
					absorb = ARMOR_SOFTEN
					SFX = sound('sound/armornew/slash_light.ogg', 'sound/armornew/slash_light2.ogg', 'sound/armornew/slash_light3.ogg', 'sound/armornew/slash_light4.ogg', volume = 100)

				if(!W.sharp && W.edge)
					if(prob(max(W.force-armadura, rand(10, 35))))
						absorb = ARMOR_FUDEU
					else
						absorb = ARMOR_SOFTEN
						SFX = sound('sound/armornew/stab_light.ogg', 'sound/armornew/stab_light2.ogg', 'sound/armornew/stab_light3.ogg', volume = 100)


				if(!W.sharp && !W.edge)
					absorb = ARMOR_SOFTEN
					SFX = sound('sound/armornew/blunt_light.ogg', 'sound/armornew/blunt_light2.ogg', 'sound/armornew/blunt_light3.ogg', volume = 100)
			if(armaduraTipo == ARMOR_CHAINMAIL)
				if(W.sharp && !W.edge || W.sharp && W.edge) // tem fio, W.sharp e W.edge e uma aberração mas ainda tem mto no code
					absorb = ARMOR_BLOCKED
					SFX = sound('sound/armornew/slash_light.ogg', 'sound/armornew/slash_light2.ogg', 'sound/armornew/slash_light3.ogg', 'sound/armornew/slash_light4.ogg', volume = 100)

				if(!W.sharp && W.edge)
					if(prob(W.force-armadura))
						absorb = ARMOR_SOFTEN
						SFX = sound('sound/armornew/stab_light.ogg', 'sound/armornew/stab_light2.ogg', 'sound/armornew/stab_light3.ogg', volume = 100)
					else
						absorb = ARMOR_FUDEU
						SFX = sound('sound/armornew/spearthroughmail.ogg', 'sound/armornew/spearthroughmail2.ogg', 'sound/armornew/spearthroughmail3.ogg', 'sound/armornew/spearthroughmail4.ogg', volume = 100)
				if(!W.sharp && !W.edge)
					absorb = ARMOR_SOFTEN
					SFX = sound('sound/armornew/blunt_light.ogg', 'sound/armornew/blunt_light2.ogg', 'sound/armornew/blunt_light3.ogg', volume = 100)
			if(armaduraTipo == ARMOR_METAL)
				if(W.sharp && !W.edge || W.sharp && W.edge) // tem fio, W.sharp e W.edge e uma aberração mas ainda tem mto no code
					absorb = ARMOR_BLOCKED
					SFX = sound('sound/armornew/slash_heavy.ogg', 'sound/armornew/slash_heavy2.ogg', 'sound/armornew/slash_heavy3.ogg', 'sound/armornew/slash_heavy4.ogg', volume = 100)

				if(!W.sharp && W.edge)
					absorb = ARMOR_BLOCKED
					SFX = sound('sound/armornew/stab_heavy1.ogg', 'sound/armornew/stab_heavy2.ogg', 'sound/armornew/stab_heavy3.ogg', volume = 100)
				if(!W.sharp && !W.edge)
					absorb = ARMOR_SOFTEN
					SFX = sound('sound/armornew/blunt_heavy.ogg', 'sound/armornew/blunt_heavy2.ogg', 'sound/armornew/blunt_heavy3.ogg', volume = 100)
	else if(tipoDeDano == "PUNCH")
		if(armaduraTipo == ARMOR_ROUPA)
			absorb = ARMOR_SOFTEN
			SFX = sound('sound/armornew/soft_fist1.ogg', 'sound/armornew/soft_fist2.ogg', 'sound/armornew/soft_fist3.ogg', volume = 100)
		if(armaduraTipo == ARMOR_LEATHER || armaduraTipo == ARMOR_FODIDA)
			absorb = ARMOR_BLOCKED
			SFX = sound('sound/armornew/hard_fist.ogg', 'sound/armornew/hard_fist2.ogg', 'sound/armornew/hard_fist3.ogg', volume = 100)
		if(armaduraTipo > ARMOR_LEATHER)
			absorb = ARMOR_BLOCKED
			SFX = sound('sound/armornew/blunt_light.ogg', 'sound/armornew/blunt_light2.ogg', 'sound/armornew/blunt_light3.ogg', volume = 100)
	else if(tipoDeDano == "GAUNTLET")
		if(armaduraTipo == ARMOR_ROUPA)
			absorb = ARMOR_FUDEU
			SFX = sound('sound/armornew/hard_fist.ogg', 'sound/armornew/hard_fist2.ogg', 'sound/armornew/hard_fist3.ogg', volume = 100)
		if(armaduraTipo == ARMOR_LEATHER || armaduraTipo == ARMOR_FODIDA)
			absorb = ARMOR_SOFTEN
			SFX = sound('sound/armornew/hard_fist.ogg', 'sound/armornew/hard_fist2.ogg', 'sound/armornew/hard_fist3.ogg', volume = 100)
		if(armaduraTipo > ARMOR_LEATHER)
			absorb = ARMOR_SOFTEN
			SFX = sound('sound/armornew/blunt_heavy.ogg', 'sound/armornew/blunt_heavy2.ogg', 'sound/armornew/blunt_heavy3.ogg', volume = 100)
	else if(!W && !tipoDeDano) //suporte para armor antiga, provavelmente tem q configurar ja que os argumentos mudaram
		if(prob(armadura))
			absorb += ARMOR_SOFTEN
		if(prob(armadura))
			absorb += ARMOR_SOFTEN
		if(absorb >= ARMOR_BLOCKED)
			playsound(src, "sound/weapons/armorblockheavy[rand(1,3)].ogg", 50, 1, 1)
		if(absorb == ARMOR_SOFTEN)
			playsound(src, "sound/weapons/armorblock[rand(1,4)].ogg", 50, 1, 1)

	playsound(src, SFX, 200, 1)

	if(absorb >= ARMOR_BLOCKED)
		armor?.durability -= rand(2,3)
		armor?.updatee()
		return ARMOR_BLOCKED
	if(absorb == ARMOR_SOFTEN)
		armor?.durability -= rand(2,3)
		armor?.updatee()
		return ARMOR_SOFTEN

	return ARMOR_FUDEU


/obj/item/clothing/var/initial_armor = null //Shit code. But GOD PLEASE MAKE IT WORK!

/proc/percentage(var/number, var/percentage)
	return  number * percentage / 100;

/obj/item/clothing/proc/updatee()
	if(initial_armor == null)
		initial_armor = armor["melee"]
	if(armor_type == ARMOR_METAL)
		if(durability > 91)
			armor["melee"] = initial_armor
			armor_type = initial(armor_type)
		if(durability < 91)
			armor["melee"] = initial_armor
			armor["melee"] -= percentage(initial_armor, 10)
			armor_type = initial(armor_type)
		if(durability < 71)
			armor["melee"] = initial_armor
			armor["melee"] -= percentage(initial_armor, 25)
			armor_type = ARMOR_CHAINMAIL
		if(durability < 51)
			armor["melee"] = initial_armor
			armor["melee"] -= percentage(initial_armor, 45)
			armor_type = ARMOR_LEATHER
		if(durability < 41)
			armor["melee"] = initial_armor
			armor["melee"] -= percentage(initial_armor, 75)
			armor_type = ARMOR_FODIDA
	else
		if(durability > 91)
			armor["melee"] = initial_armor
			armor_type = initial(armor_type)
		if(durability < 91)
			armor["melee"] = initial_armor
			armor["melee"] -= percentage(initial_armor, 10)
			armor_type = initial(armor_type)
		if(durability < 71)
			armor["melee"] = initial_armor
			armor["melee"] -= percentage(initial_armor, 25)
		if(durability < 51)
			armor["melee"] = initial_armor
			armor["melee"] -= percentage(initial_armor, 45)
		if(durability < 41)
			armor["melee"] = initial_armor
			armor["melee"] -= percentage(initial_armor, 75)
			armor_type = ARMOR_FODIDA
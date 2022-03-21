/datum/organ/external/head
	name = "head"
	icon_name = "head"
	display_name = "head"
	display_namebr = "cabeça"
	max_damage = 160
	min_broken_damage = 110
	body_part = HEAD
	canBeRemoved = 1
	delimb_min_damage = 130
	vital = 1
	encased = "skull"
	iconsdamage = "head"
	head_icon_needed = 1
	mask_color = "#ffffff"
	var/headwrenched = 0
	var/brained = 0
	var/list/ears = list()
	var/nose = null

/datum/organ/external/head/get_icon(var/icon/race_icon, var/icon/deform_icon)
	if (!owner)
	 return ..()
	var/g = "m"
	var/fat = ""
	if(FAT in owner.mutations)
		fat = "fat"
	var/contrario = null
	if(headwrenched)
		contrario = "wrench"
	if(owner.gender == FEMALE)	g = "f"
	if (status & ORGAN_MUTATED)
		. = new /icon(deform_icon, "[icon_name]_[g][fat]")
	if(headwrenched)
		. = new /icon(race_icon, "[icon_name]_[g][contrario]")
	else
		. = new /icon(race_icon, "[icon_name]_[g][fat]")

/datum/organ/external/head/proc/sag()
	owner?.emote("agonydeath")
	owner.visible_message("<span class='hitbold'>[owner.name]</span> <span class='hit'>sags on ground! \He wont regain his consciousness soon.</span>")
	owner.Weaken(1)
	owner.ear_deaf = max(owner.ear_deaf,6)
	owner.CU()
	spawn(30)
		if(owner?.client)
			owner?.client?.chatOutput?.load()
			to_chat(owner, "WHO AM I?")
			sleep(5)
			to_chat(owner, "WHERE AM I?")
		owner.sleeping += rand(8,18)
		if(brute_dam >= 80)
			owner.Jitter(10)
			owner.sleeping += rand(8,18)



/datum/organ/external/head/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list(), armor, specialAttack)
	..(brute, burn, sharp, edge, used_weapon, forbidden_limbs)
	var/datum/organ/external/face/F = locate() in owner.organs
	if(brute > 20 && !sharp && !edge)
		if(prob(30) && owner.head)
			var/obj/item/HAT = owner.head
			if(!istype(HAT, /obj/item/clothing/head/helmet))
				owner.drop_from_inventory(HAT)
	if(brute > 60 && !sharp && !edge)
		if(!ismonster(owner) && (!istype(owner.head, /obj/item/clothing/head/helmet) || brute / owner.my_stats.ht >= 5))
			if(prob(70-(owner.my_stats.ht*1.5)) && prob(80) || istype(used_weapon, /obj/item/weapon/melee/classic_baton) && prob(60-(owner.my_stats.ht*2)))
				sag()

	if (!F.disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")
	if(!brained)
		if(brute_dam > 90)
			if(prob(15-owner.my_stats.ht))
				breakskull()
	else
		var/datum/organ/internal/I = owner.internal_organs_by_name["brain"]
		if(I)
			I.take_damage(brute)
	owner.UpdateDamageIcon(1)

/datum/organ/external/head/rejuvenate()
	..()
	owner.unexpose_brain()

/datum/organ/external/head/proc/disfigure(var/type = "brute")
	var/datum/organ/external/face/F = locate() in owner.organs
	if (F.disfigured)
		return
	F.disfigured = 1

/datum/organ/external/head/proc/breakskull()
	if(brained)
		return
	owner.expose_brain()
	if(prob(90))
		owner.death(1)
	playsound(owner, pick('sound/effects/gore/blast.ogg','sound/effects/gore/blast2.ogg','sound/effects/gore/blast3.ogg','sound/effects/gore/blast4.ogg'), 130, 0, -1)

/datum/organ/external/head/proc/wrenchedhead()
	headwrenched = 1
	owner.QUEMLIGA = TRUE
	owner.update_body()
	owner.update_inv_glasses()
	owner.update_hair()
	owner.update_vision_cone()
	owner.UpdateDamageIcon()

/datum/organ/external/head/proc/unwrenchedhead()
	headwrenched = 0
	owner.QUEMLIGA = FALSE
	owner.update_body()
	owner.update_inv_glasses()
	owner.update_hair()
	owner.update_inv_head()
	owner.update_vision_cone()
	owner.UpdateDamageIcon()
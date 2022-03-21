//This is an uguu head restoration surgery TOTALLY not yoinked from chinsky's limb reattacher

/datum/surgery_step/limb_reattach
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/suture = 100,			\
	/obj/item/clothing/mask/cigarette = 75,	\
	/obj/item/weapon/flame/lighter = 50,	\
	/obj/item/weapon/weldingtool = 25
	)

	difficulty = 2
	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (!affected)
			return 0
		if(!(affected.status & ORGAN_DESTROYED))
			return 0
		if (affected.parent)
			if (affected.parent.status & ORGAN_DESTROYED)
				return 0
		var/obj/item/I = user.get_inactive_hand()
		if(!(istype(I, /obj/item/weapon/organ)))
			return 0
		var/obj/item/weapon/organ/L = I
		return affected.body_part == L.body_part

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts stitching [target]'s [affected.display_name] back together with [tool].", \
		"You start stitching [target]'s [affected.display_name] back together using \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/I = user.get_inactive_hand()
		if(!(istype(I, /obj/item/weapon/organ)))
			return 0
		var/obj/item/weapon/organ/L = I
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='passive'>[user] sews back the [target]'s [affected.display_name] with \he [tool].</span>",	\
		"<span class='passive'>You sews back the [target]'s [affected.display_name] using \the [tool].</span>")
		affected.brute_dam = 0
		affected.status = ORGAN_BROKEN | ORGAN_BLEEDING | ORGAN_CUT_AWAY
		affected.open = 1
		affected.amputated = 0
		affected.destspawn = 0
		for(var/datum/wound/W in affected.wounds)
			affected.wounds -= W
		affected.createwound(CUT, 1)
		affected.update_damages()
		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()
		if(istype(L, /obj/item/weapon/organ/head))
			var/obj/item/weapon/organ/head/B = L
			if (B.brainmob.mind)
				B.brainmob.mind.transfer_to(target)
		qdel(L)
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (affected.parent)
			affected = affected.parent
		user.visible_message("<span class='combat'>[user]'s hand slips, leaving a small wound on [target]'s [affected.display_name] with \the [tool]!</span>", \
		"<span class='combat'>Your hand slips, leaving a small wound on [target]'s [affected.display_name] with \the [tool]!</span>")
		target.apply_damage(3, BRUTE, affected)
		..()

/datum/surgery_step/vessels
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/retractor = 100,	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 20
	)

	difficulty = 2
	min_duration = 40
	max_duration = 60

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (!affected)
			return 0
		if (target_zone == "eyes" || target_zone == "mouth" || target_zone == "chest" || target_zone == "groin")
			return 0
		if(affected.status & ORGAN_DESTROYED)
			return 0
		if (affected.parent)
			if (affected.parent.status & ORGAN_DESTROYED)
				return 0
		return affected.open >= 1 && (affected.status & ORGAN_CUT_AWAY)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts connecting the damaged vessels in [target]'s [affected.display_name] with \the [tool].", \
		"You connecting the damaged vessels in [target]'s [affected.display_name] with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='passive'>[user] connected the damaged vessels in [target]'s [affected.display_name] with \the [tool].</span>",	\
		"<span class='passive'>You connected the damaged vessels in [target]'s [affected.display_name] with \the [tool].</span>")
		affected.status &= ~ORGAN_CUT_AWAY
		..()


	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='combat'>[user]'s hand slips, tearing blood vessals and causing massive bleeding in [target]'s [affected.display_name] with \the [tool]!</span>",	\
		"<span class='combat'>Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.display_name] with \the [tool]!</span>",)
		if(!(affected.status & ORGAN_BLEEDING))
			affected.status |= ORGAN_BLEEDING
		affected.createwound(CUT, 10)
		..()


/datum/surgery_step/penis_reattach
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/suture = 100,			\
	/obj/item/clothing/mask/cigarette = 75,	\
	/obj/item/weapon/flame/lighter = 50,	\
	/obj/item/weapon/weldingtool = 25
	)

	difficulty = 2
	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (!affected)
			return 0
		if(affected.status & ORGAN_DESTROYED)
			return 0
		if (affected.parent)
			if (affected.parent.status & ORGAN_DESTROYED)
				return 0
		if(target.has_penis())
			return 0
		var/obj/item/I = user.get_inactive_hand()
		if(!(istype(I, /obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis)))
			return 0
		return target_zone ==  "groin"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts stitching [target]'s penis back together with [tool].", \
		"You start stitching [target]'s penis back together using \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/I = user.get_inactive_hand()
		if(!(istype(I, /obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis)))
			return 0
		user.visible_message("<span class='passive'>[user] sews back the [target]'s penis with \he [tool].</span>",	\
		"<span class='passive'>You sews back the [target]'s penis using \the [tool].</span>")
		var/obj/item/weapon/reagent_containers/food/snacks/organ/internal/penis/P = I
		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()
		target.potenzia = P.potenzia
		target.mutilated_genitals = 0
		qdel(P)
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (affected.parent)
			affected = affected.parent
		user.visible_message("<span class='combat'>[user]'s hand slips, leaving a small wound on [target]'s [affected.display_name] with \the [tool]!</span>", \
		"<span class='combat'>Your hand slips, leaving a small wound on [target]'s [affected.display_name] with \the [tool]!</span>")
		target.apply_damage(3, BRUTE, affected)
		..()




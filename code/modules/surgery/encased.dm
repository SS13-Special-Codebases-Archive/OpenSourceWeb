//Procedures in this file: Generic ribcage opening steps, Removing alien embryo, Fixing internal organs.
//////////////////////////////////////////////////////////////////
//				GENERIC	RIBCAGE SURGERY							//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/open_encased/
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		if (target_zone != "chest")
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (affected == null)
			return 0
		if (affected.status & ORGAN_DESTROYED)
			return 0
		if (affected.status & ORGAN_ROBOT)
			return 0
		return 1


/datum/surgery_step/open_encased/saw
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/circular_saw = 100, \
	/obj/item/weapon/hatchet = 75
	)

	min_duration = 50
	max_duration = 70

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return ..() && affected.open >= 1 && !(affected.status & ORGAN_BROKEN)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		user.visible_message("[user] begins to cut through [target]'s [affected.encased] with \the [tool].", \
		"You begin to cut through [target]'s [affected.encased] with \the [tool].")
		target.custom_pain("Something hurts horribly in your [affected.display_name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		user.visible_message("<span class='passive'>[user] has cut [target]'s [affected.encased] open with \the [tool].</span>",		\
		"<span class='passive'>You have cut [target]'s [affected.encased] open with \the [tool].</span>")
		affected.fracture()
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		user.visible_message("<span class='combat'>[user]'s hand slips, cracking [target]'s [affected.encased] with \the [tool]!</span>" , \
		"<span class='combat'>Your hand slips, cracking [target]'s [affected.encased] with \the [tool]!</span>" )

		affected.createwound(CUT, 20)
		affected.fracture()
		..()

/datum/surgery_step/open_encased/speculum
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/speculum = 100
	)

	min_duration = 1
	max_duration = 1

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return ..() && affected.open == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "[user] starts to force open the [affected.encased] in [target]'s [affected.display_name] with \the [tool]."
		var/self_msg = "You start to force open the [affected.encased] in [target]'s [affected.display_name] with \the [tool]."
		user.visible_message(msg, self_msg)
		target.custom_pain("Something hurts horribly in your [affected.display_name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='passive'>[user] forces open [target]'s [affected.encased] with \the [tool].</span>"
		var/self_msg = "<span class='passive'>You force open [target]'s [affected.encased] with \the [tool].</span>"
		user.visible_message(msg, self_msg)

		affected.open = 2
		user.drop_item()
		tool.loc = target
		affected.implants += tool
		target.update_surgery(1)
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='combat'>[user]'s hand slips, cracking [target]'s [affected.encased]!</span>"
		var/self_msg = "<span class='combat'>Your hand slips, cracking [target]'s  [affected.encased]!</span>"
		user.visible_message(msg, self_msg)

		affected.createwound(BRUISE, 5)
		..()
		//affected.fracture()

/datum/surgery_step/open_encased/cutopen
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/scalpel = 100
	)

	min_duration = 1
	max_duration = 1

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if(affected.open != 2)
			return 0
		if(!(affected.status & ORGAN_BROKEN))
			to_chat(usr, "<span class='passive'>There are [affected.encased] in the way!")
			return 0
		return ..()

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "[user] starts to force open the [affected.encased] in [target]'s [affected.display_name] with \the [tool]."
		var/self_msg = "You start to force open the [affected.encased] in [target]'s [affected.display_name] with \the [tool]."
		user.visible_message(msg, self_msg)
		target.custom_pain("Something hurts horribly in your [affected.display_name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='passive'>[user] forces open [target]'s [affected.encased] with \the [tool].</span>"
		var/self_msg = "<span class='passive'>You force open [target]'s [affected.encased] with \the [tool].</span>"
		user.visible_message(msg, self_msg)

		affected.open = 3
		target.update_surgery(1)
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='combat'>[user]'s hand slips, cracking [target]'s [affected.encased]!</span>"
		var/self_msg = "<span class='combat'>Your hand slips, cracking [target]'s  [affected.encased]!</span>"
		user.visible_message(msg, self_msg)

		affected.createwound(BRUISE, 20)
		..()
		//affected.fracture()

/datum/surgery_step/open_encased/close
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/suture = 100
	)

	min_duration = 20
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return ..() && affected.open == 3

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "[user] starts sewing [target]'s [affected.encased] back into place with \the [tool]."
		var/self_msg = "You start sewing [target]'s [affected.encased] back into place with \the [tool]."
		user.visible_message(msg, self_msg)
		target.custom_pain("Something hurts horribly in your [affected.display_name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='passive'>[user] sews [target]'s [affected.encased] back into place with \the [tool].</span>"
		var/self_msg = "<span class='passive'>You sews [target]'s [affected.encased] back into place with \the [tool].</span>"
		user.visible_message(msg, self_msg)
		affected.open = 2
		target.update_surgery(1)
		if (user.s_active)
			user.s_active.close(user)
		if (target.s_active)
			target.s_active.close(target)
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='combat'>[user]'s hand slips, bending [target]'s [affected.encased] the wrong way!</span>"
		var/self_msg = "<span class='combat'>Your hand slips, bending [target]'s [affected.encased] the wrong way!</span>"
		user.visible_message(msg, self_msg)

		affected.createwound(BRUISE, 5)
		..()

		/*if (prob(40)) //TODO: ORGAN REMOVAL UPDATE.
			user.visible_message("<span class='combat'> A rib pierces the lung!")
			target.rupture_lung()*/
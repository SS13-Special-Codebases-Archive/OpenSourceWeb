//Procedures in this file: Facial reconstruction surgery
//////////////////////////////////////////////////////////////////
//						FACE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/face
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/bonesetter = 100,	\
	/obj/item/weapon/wrench = 75
	)

	difficulty = 1
	min_duration = 20
	max_duration = 40
	priority = 1

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		if(target_zone != "face")
			return 0
		var/datum/organ/external/face/F = target.get_organ(target_zone)
		if (!F)
			return 0
		if (F.status & ORGAN_DESTROYED)
			return 0
		return F.disfigured

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is beginning to set the bones in [target]'s [affected.display_name] in place with \the [tool]." , \
		"You are beginning to set the bones in [target]'s [affected.display_name] in place with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='passive'>[user] sets the bone in [target]'s [affected.display_name] in place with \the [tool].</span>", \
		"<span class='passive'>You set the bones in [target]'s [affected.display_name] in place with \the [tool].</span>")
		var/datum/organ/external/face/F = affected
		F.disfigured = 0
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='combat'>[user]'s hand slips, damaging the [target]'s [affected.display_name] with \the [tool]!</span>" , \
		"<span class='combat'>Your hand slips, damaging the [target]'s [affected.display_name] with \the [tool]!</span>")
		affected.createwound(BRUISE, 5)
		..()

//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/generic/
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (target_zone == "eyes")	//there are specific steps for eye surgery
			return 0
		if (!hasorgans(target))
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (affected == null)
			return 0
		if (affected.status & ORGAN_DESTROYED)
			return 0
		if (target_zone == "head" && target.species && (target.species.flags & IS_SYNTHETIC))
			return 1
		if (affected.status & ORGAN_ROBOT)
			return 0
		return 1

/datum/surgery_step/generic/cut_open
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/scalpel = 100,		\
	/obj/item/weapon/kitchenknife = 75,	\
	/obj/item/weapon/shard = 50, 		\
	)

	min_duration = 60
	max_duration = 80

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/datum/organ/external/affected = target.get_organ(target_zone)
			return affected.open == 0 && target_zone != "mouth"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts the incision on [target]'s [affected.display_name] with \the [tool].", \
		"You start the incision on [target]'s [affected.display_name] with \the [tool].")
		target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.display_name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='passive'>[user] has made an incision on [target]'s [affected.display_name] with \the [tool].</span>", \
		"<span class='passive'>You have made an incision on [target]'s [affected.display_name] with \the [tool].</span>",)
		affected.open = 1

		if(istype(target) && !(target.species.flags & NO_BLOOD))
			affected.status |= ORGAN_BLEEDING

		affected.createwound(CUT, 1)
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='combat'>[user]'s hand slips, slicing open [target]'s [affected.display_name] in the wrong place with \the [tool]!</span>", \
		"<span class='combat'>Your hand slips, slicing open [target]'s [affected.display_name] in the wrong place with \the [tool]!</span>")
		affected.createwound(CUT, 10)
		..()

/datum/surgery_step/generic/cauterize
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/suture = 100
	)

	min_duration = 70
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/datum/organ/external/affected = target.get_organ(target_zone)
			return affected.open == 1 && target_zone != "mouth"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is beginning to sewing the incision on [target]'s [affected.display_name] with \the [tool]." , \
		"You are beginning to sewing the incision on [target]'s [affected.display_name] with \the [tool].")
		target.custom_pain("Your [affected.display_name] is being burned!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='passive'>[user] sews the incision on [target]'s [affected.display_name] with \the [tool].</span>", \
		"<span class='passive'>You sews the incision on [target]'s [affected.display_name] with \the [tool].</span>")
		affected.open = 0
		affected.status &= ~ORGAN_BLEEDING
		target.update_surgery(1)
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='combat'>[user]'s hand slips, leaving a small bruise on [target]'s [affected.display_name] with \the [tool]!</span>", \
		"<span class='combat'>Your hand slips, leaving a small bruise on [target]'s [affected.display_name] with \the [tool]!</span>")
		target.apply_damage(3, BRUTE, affected)
		..()

/datum/surgery_step/generic/cut_limb
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/circular_saw = 100, \
	/obj/item/weapon/hatchet = 75
	)

	difficulty = 1
	min_duration = 110
	max_duration = 160

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (target_zone == "eyes")	//there are specific steps for eye surgery
			return 0
		if (!hasorgans(target))
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (affected == null)
			return 0
		if (affected.status & ORGAN_DESTROYED)
			return 0
		if(target_zone == "groin")
			if(!(target.has_penis()))
				return 0
		return target_zone != "chest" && target_zone != "head"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is beginning to cut off [target]'s [affected.display_name] with \the [tool]." , \
		"You are beginning to cut off [target]'s [affected.display_name] with \the [tool].")
		target.custom_pain("Your [affected.display_name] is being ripped apart!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='passive'>[user] cuts off [target]'s [affected.display_name] with \the [tool].</span>", \
		"<span class='passive'>You cut off [target]'s [affected.display_name] with \the [tool].</span>")
		if(target_zone == "groin")
			return
		affected.droplimb(1,0)
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='combat'>[user]'s hand slips, sawwing through the bone in [target]'s [affected.display_name] with \the [tool]!</span>", \
		"<span class='combat'>Your hand slips, sawwing through the bone in [target]'s [affected.display_name] with \the [tool]!</span>")
		affected.createwound(CUT, 30)
		affected.fracture()
		..()

/datum/surgery_step/teeth
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/surgicaldrill = 100,	\
	/obj/item/weapon/pen = 75,	\
	/obj/item/stack/rods = 50
	)

	difficulty = 1
	min_duration = 60
	max_duration = 80

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (target_zone != "mouth")
			return 0
		if (!hasorgans(target))
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (affected == null)
			return 0
		if (affected.status & ORGAN_DESTROYED)
			return 0
		var/obj/item/I = user.get_inactive_hand()
		if(!(istype(I, /obj/item/stack/teeth/human/golden)))
			return 0
		if(!istype(affected, /datum/organ/external/mouth))
			return 0
		var/datum/organ/external/mouth/U = affected
		return (U.get_teeth() < U.max_teeth)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is beginning to install new teeth into [target]'s [affected.display_name] with \the [tool]." , \
		"You are beginning to install new teeth into [target]'s [affected.display_name] with \the [tool].")
		target.custom_pain("Your [affected.display_name] is being ripped apart!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		var/datum/organ/external/mouth/U = locate() in target.organs
		var/obj/item/I = user.get_inactive_hand()
		if(!(istype(I, /obj/item/stack/teeth/human/golden)))
			return
		var/obj/item/stack/teeth/human/golden/T = I
		var/amt = (U.max_teeth) - (U.get_teeth())
		var/obj/item/stack/teeth/human/golden/T2 = new /obj/item/stack/teeth/human/golden(U)
		T2.amount = min(amt, T.amount)
		U.teeth_list += T2
		if(!(T.use(amt)))
			qdel(T)
		user.visible_message("<span class='passive'>[user] installs new teeth into [target]'s [affected.display_name] with \the [tool].</span>", \
		"<span class='passive'>You install new teeth into [target]'s [affected.display_name] with \the [tool].</span>")
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='combat'>[user]'s hand slips, drilliing through the bone in [target]'s [affected.display_name] with \the [tool]!</span>", \
		"<span class='combat'>Your hand slips, drilliing through the bone in [target]'s [affected.display_name] with \the [tool]!</span>")
		affected.createwound(CUT, 10)
		affected.fracture()
		..()

/datum/surgery_step/generic/disinfection
	can_infect = 0
	allowed_tools = list(
	/obj/item/weapon/surgery_tool/disinfectant = 100
	)

	difficulty = -1
	min_duration = 20
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		..()
		var/datum/organ/external/affected = target.get_organ(target_zone)
		var/obj/item/weapon/surgery_tool/disinfectant/S = tool
		if(!S.uses)
			to_chat(user, "<span class='combat'>[S.name] is empty!")
			return 0
		return affected.open >= 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is disinfecting [target]'s [affected.display_name] with \the [tool]." , \
		"You are disinfecting [target]'s [affected.display_name] with \the [tool].")
		target.custom_pain("Your [affected.display_name] is being ripped apart!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		var/obj/item/weapon/surgery_tool/disinfectant/S = tool
		S.uses -= 1
		affected.germ_level = 0
		affected.disinfect()
		user.visible_message("<span class='passive'>[user] disinfected [target]'s [affected.display_name] with \the [tool].</span>", \
		"<span class='passive'>You disinfected [target]'s [affected.display_name] with \the [tool].</span>")
		..()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/weapon/surgery_tool/disinfectant/S = tool
		S.uses -= 1
		user.visible_message("<span class='combat'>[user]'s hand slips, spraying [target]'s skin with \the [tool]!</span>", \
		"<span class='combat'>Your hand slips, spraying [target]'s skin with \the [tool]!</span>")
		..()

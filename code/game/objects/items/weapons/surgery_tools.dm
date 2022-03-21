/* Surgery Tools
 * Contains:
 *		Retractor
 *		Hemostat
 *		Cautery
 *		Surgical Drill
 *		Scalpel
 *		Circular Saw
 */

/obj/item/weapon/surgery_tool
	name = "surgery tools"
	icon = 'icons/obj/surgery.dmi'
	var/operation_sound
	var/operation_sound_fail


/*
 * Retractor
 */

/obj/item/weapon/surgery_tool/retractor
	name = "forceps"
	desc = "Retracts stuff."
	icon_state = "retractor"
	m_amt = 10000
	g_amt = 5000
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 2.0
	origin_tech = "materials=1;biotech=1"

/*
 * Hemostat
 */
/obj/item/weapon/surgery_tool/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon_state = "hemostat"
	m_amt = 5000
	g_amt = 2500
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 2.0
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("attacked", "pinched")

/*
 * Hemostat
 */

/*
 * Cautery
 */
/obj/item/weapon/surgery_tool/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon_state = "cautery"
	m_amt = 5000
	g_amt = 2500
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 2.0
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("burnt")


/*
 * Surgical Drill
 */
/obj/item/weapon/surgery_tool/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	m_amt = 15000
	g_amt = 10000
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 21.0
	w_class = 2.0
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("drilled")

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is pressing the [src.name] to \his temple and activating it! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is pressing [src.name] to \his chest and activating it! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS)

/*
 * Scalpel
 */
/obj/item/weapon/surgery_tool/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon_state = "scalpel"
	item_state = "scalpel"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 15.0
	w_class = 2.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	m_amt = 10000
	g_amt = 5000
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("attacked", "slashed", "sliced", "torn", "ripped", "diced", "cut")
	sharp = 1
	edge = 1

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>")
		return (BRUTELOSS)

/*
 * Researchable Scalpels
 */

/obj/item/weapon/surgery_tool/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	damtype = "fire"

/obj/item/weapon/surgery_tool/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	icon_state = "scalpel_laser2_on"
	damtype = "fire"
	force = 12.0

/obj/item/weapon/surgery_tool/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	damtype = "fire"
	force = 15.0

/obj/item/weapon/surgery_tool/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager_on"
	force = 7.5


/*
 * Circular Saw
 */
/obj/item/weapon/surgery_tool/circular_saw
	name = "bone saw"
	desc = "For heavy duty cutting."
	icon_state = "saw"
	//hitsound = 'sound/weapons/circsawhit.ogg'
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 20.0
	w_class = 2.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	m_amt = 20000
	g_amt = 10000
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = 1
	edge = 1


//misc, formerly from code/defines/weapons.dm
/obj/item/weapon/surgery_tool/bonegel
	name = "bone gel"
	icon_state = "bone-gel"
	force = 0
	w_class = 2.0
	throwforce = 1.0

/obj/item/weapon/surgery_tool/FixOVein
	name = "FixOVein"
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = "materials=1;biotech=3"
	w_class = 2.0
	var/usage_amount = 10

/obj/item/weapon/surgery_tool/bonesetter
	name = "bone setter"
	icon_state = "bone setter"
	force = 10.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	w_class = 2.0
	attack_verb = list("attacked", "hit", "bludgeoned")
	operation_sound = 'sound/lfwbsounds/bones.ogg'
	operation_sound_fail = 'sound/lfwbsounds/bone_crack.ogg'

/obj/item/weapon/surgery_tool/speculum
	name = "speculum"
	desc = "Retracts stuff."
	icon_state = "speculum"
	m_amt = 10000
	g_amt = 5000
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 2.0
	origin_tech = "materials=1;biotech=1"

/obj/item/weapon/surgery_tool/suture
	name = "suture"
	icon_state = "needle"
	desc = "Used to stitch up arteries and wounds."
	m_amt = 10000
	g_amt = 5000
	slot_flags = SLOT_EARS
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 2.0
	origin_tech = "materials=1;biotech=1"
	operation_sound = 'sound/lfwbsounds/suture.ogg'
	var/amount = 12
	swing_sound = null

/obj/item/weapon/surgery_tool/suture/examine()
	..()
	to_chat(usr, "<span class='passive'>[amount] uses left.</span>")

/obj/item/weapon/surgery_tool/suture/proc/amountcheck()
	if(amount <= 0)
		qdel(src)

/obj/item/weapon/surgery_tool/suture/attack(mob/living/carbon/human/H as mob, mob/living/userr, var/target_zone)//All of this is snowflake because surgery is broken.
	..()
	if(!ishuman(H))
		return ..()
	if(!ishuman(userr))
		return ..()
	var/mob/living/carbon/human/user = userr
	var/datum/organ/external/affected = H.get_organ(user.zone_sel.selecting)
	if(!affected)
		return ..()

	var/canDoIt = 0
	var/list/roll_result = roll3d6(user, SKILL_MEDIC, null)
	switch(roll_result[GP_RESULT])
		if(GP_CRITSUCCESS)
			canDoIt = 1
		if(GP_SUCCESS)
			canDoIt = 1

	if((affected.status & ORGAN_ARTERY))//Fix arteries first,
		user.visible_message("<span class='bname'>[user]</span> begins to suture [H]'s arteries.")
		playsound(src, 'sound/lfwbsounds/suture.ogg', 70, 1)
		H.emote("agonyscream",1,null,0)
		if(do_after(user, 50) && canDoIt)
			user.visible_message("<span class='bname'>[user]</span> has patched the [affected.artery_name] in [H]'s [affected.display_name] with \the [src.name].")
			affected.status &= ~ORGAN_ARTERY
			amount -= 1
			amountcheck()
			H.UpdateArteryIcon()


	if((affected.get_lost_fingers_number() > 0 && affected.has_finger)  && skillcheck(user.my_skills.GET_SKILL(SKILL_SURG), 4, 0, user))
		var/list/lost_fingers = affected.get_lost_fingers_text()
		for(var/obj/item/weapon/organ/finger/F in view(1))
			if(lost_fingers.Find(F.name) || lost_fingers.Find("ALL FINGERS MISSING!"))
				user.visible_message("<span class='bname'>[user]</span> begins to suture \a [F.name] onto [H]'s [affected.display_name].")
				H.emote("agonypain",1,null,0)
				playsound(src, 'sound/lfwbsounds/suture.ogg', 70, 1)
				if(do_after(user, 50) && canDoIt)
					affected.fingers.Add(F)
					F.loc = affected
					user.visible_message("<span class='bname'>[user]</span> sutures \the [F.name] onto [H]'s [affected.display_name].")
					amount -= 1
					amountcheck()


	else if((affected.hasVocal && affected.VocalTorn) && skillcheck(user.my_skills.GET_SKILL(SKILL_SURG), 4, 0, user))
		user.visible_message("<span class='bname'>[user]</span> begins to suture [H]'s vocal chords.")
		playsound(src, 'sound/lfwbsounds/suture.ogg', 70, 1)
		H.emote("agonymoan",1,null,0)
		if(do_after(user, 50) && canDoIt)
			user.visible_message("<span class='bname'>[user]</span> has patched the vocal chords in [H]'s [affected.display_name] with \the [src.name].</span>")
			affected.VocalTorn = FALSE
			amount -= 1
			amountcheck()

	if((affected.status & ORGAN_TENDON) && skillcheck(user.my_skills.GET_SKILL(SKILL_SURG), 4, 0, user))
		user.visible_message("<span class='bname'>[user]</span> begins to suture [H]'s tendons.")
		playsound(src, 'sound/lfwbsounds/suture.ogg', 70, 1)
		H.emote("agonymoan",1,null,0)
		if(do_after(user, 50) && canDoIt)
			user.visible_message("<span class='bname'>[user]</span> has patched the [affected.artery_name] in [H]'s [affected.display_name] with \the [src.name].</span>")
			affected.status &= ~ORGAN_TENDON
			amount -= 1
			amountcheck()

	else//Then fix wounds if they do it again.
		for(var/datum/wound/W in affected.wounds)
			if(W.damage)
				user.visible_message("<span class='bname'>[user]</span> begins to suture up [H]'s wounds.")
				playsound(src, 'sound/lfwbsounds/suture.ogg', 40, 1)
				H.custom_pain("<span class='combatbold'>[pick("OH [uppertext(H.god_text())]!","WHAT A PAIN!")] My [affected.display_name]!</span>",rand(50, 65))
				H.emote("agonyscream",1,null,0)
				var/mayHeal = 0
				var/list/roll_resulto = roll3d6(user, SKILL_MEDIC, 2)
				switch(roll_resulto[GP_RESULT])
					if(GP_CRITSUCCESS)
						mayHeal = 1
					if(GP_SUCCESS)
						mayHeal = 1
				if(do_after(user, 30))
					if(mayHeal)
						// Close it up to a point that it can be bandaged and heal naturally!
						W.heal_damage(rand(5,20)+rand(20,30))
						if(W.damage >= W.autoheal_cutoff)
							user.visible_message("<span class='bname'>[user]</span> partially closes a wound on [H]'s [affected.display_name] with \the [src.name].</span>")
							amount -= 1
							amountcheck()
						else
							user.visible_message("<span class='bname'>[user]</span> closes a wound on [H]'s [affected.display_name] with \the [src.name].</span>")
							amount -= 1
							amountcheck()
							if(!W.damage)
								affected.wounds -= W
								qdel(W)
							else if(W.damage <= 10)
								W.clamped = 1
						H.emote("agonymoan",1,null,0)
			else
				to_chat(user, "There are no wounds to patch up.")
				..()
			break

		affected.update_damages()
		//else
		//	user.doing_something = FALSE

/obj/item/weapon/surgery_tool/disinfectant
	name = "disinfectant"
	icon_state = "disinfectant"
	var/uses = 4

/obj/item/weapon/surgery_tool/disinfectant/examine()
	..()
	if(uses)
		to_chat(usr, "<span class='passive'>It has [uses] uses left.</span>")
	else
		to_chat(usr, "<span class='combat'>It's empty!</span>")
	return

/obj/item/weapon/desfibrilador
	name = "desfibrilador"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "defib"
	item_state = "cradle"
	var/obj/item/weapon/cell/crap/leet/CELL = null
	var/delay = 0// 10 SECONDS

/obj/item/weapon/desfibrilador/New()
	..()
	CELL = new /obj/item/weapon/cell/crap/leet

/obj/item/weapon/desfibrilador/MouseDrop(var/obj/over_object)
	var/mob/user = usr
	switch(over_object.name)
		if("r_hand")
			if(CELL)
				CELL.loc = get_turf(src.loc)
				user.put_in_hands(CELL)
				user.visible_message("<span class='combatbold'>[user.name]</span> <span class='combat'>removes the cell from the [src].</span>")
				playsound(src, 'sound/lfwbcombatuse/energy_unload.ogg', 25, 0)
				CELL = null
			else
				to_chat(usr, "<span class='combat'><i>It has no cell!</i></span>")
		if("l_hand")
			if(CELL)
				CELL.loc = get_turf(src.loc)
				user.put_in_hands(CELL)
				user.visible_message("<span class='combatbold'>[user.name]</span> <span class='combat'>removes the cell from the [src].</span>")
				playsound(src, 'sound/lfwbcombatuse/energy_unload.ogg', 25, 0)
				CELL = null
			else
				to_chat(usr, "<span class='combat'><i>It has no cell!</i></span>")

/obj/item/weapon/desfibrilador/attackby(var/obj/item/A, var/mob/user)
	if(istype(A, /obj/item/weapon/cell/crap) && !CELL)
		user.drop_item(sound = 0)
		CELL = A
		CELL.loc = src
		user.visible_message("<span class='combatbold'>[user.name]</span> <span class='combat'>reloads [src]!</span>")
		playsound(src, 'sound/lfwbcombatuse/energy_reload.ogg', 25, 0)
		var/obj/item/weapon/cell/crap/C = A			//I didn't know how to do it without hardcoded type
		C.updateicon()
		update_icon()
	else
		return ..()

/obj/item/weapon/desfibrilador/attack(mob/living/carbon/human/H as mob, mob/living/carbon/human/user, var/target_zone)
	if(delay || CELL.charge < 300)
		playsound(src, 'sound/webbers/defib/failed.ogg', 100)
		return
	playsound(src, 'sound/webbers/defib/charge.ogg', 100)
	if(do_after(user, 30))
		playsound(src, 'sound/webbers/defib/Defib.ogg', 100)
		H.electrocute_act(30, src, 1, 0, 1)
		user.visible_message("<span class='combatbold'>[user]</span><span class='combat'> defibrillates [H]!</span>")
		var/datum/organ/internal/heart/HE = locate() in H.internal_organs
		if(prob(95))
			if(HE)
				HE.stopped_working = FALSE
				H.death_door = 0
				H.sleeping = 5
				H.emote("agonymoan",1,null,0)
				if(HE.damage < HE.min_bruised_damage)
					HE.damage -= 1
		if(prob(45))
			if(HE && H.stat == 2)
				if(H.pulse == PULSE_NONE && !HE.stopped_working && HE.damage < HE.min_bruised_damage)
					H.pulse = PULSE_SLOW
					H.stat = 1
		delay = 1
		CELL.charge -= 300
		spawn(5 SECONDS)
			playsound(src, 'sound/webbers/defib/success.ogg', 100)
			fakesay("READY FOR USE.")
			delay = 0

/obj/item/weapon/bloodinjector
	name = "Blood injector"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "nanoblood"
	var/obj/item/blood_catridge/catridge

/obj/item/weapon/bloodinjector/New()
	..()
	catridge = new /obj/item/blood_catridge(src)

/obj/item/weapon/bloodinjector/attack(mob/living/carbon/human/H as mob, mob/living/user, var/target_zone)
	if(ishuman(H))
		if(!catridge || !catridge.uses)
			to_chat(user, "<span class='combat'>\The [src.name] is empty!</span>")
			return 0
		user.visible_message("<span class='passive'>\The [user] is trying to inject blood into [H] using the [src.name].</span>", \
		"<span class='passive'>You trying to inject blood into [H] using the [src.name].</span>")
		if(do_after(user, 30))
			if(ishuman(user))
				var/mob/living/carbon/human/U = user
				if(skillcheck(U.my_skills.GET_SKILL(SKILL_SURG), 30, 0, U) || prob(45))
					H.vessel.add_reagent("blood",400)
					user.visible_message("<span class='passive'>\The [user] injects blood into [H] using the [src.name].</span>", \
					"<span class='passive'>You inject blood into [H] using the [src.name].</span>")
					catridge.uses -= 1
					return

				else
					user.visible_message("<span class='combat'>\The [user] failed to inject blood into [H]!</span>", \
					"<span class='combat'>You fail to inject blood into [H]!</span>")
					catridge.uses -= 1
					return

			else
				if(prob(45))
					H.vessel.add_reagent("blood",400)
					user.visible_message("<span class='passive'>\The [user] injects blood into [H] using the [src.name].</span>", \
					"<span class='passive'>You inject blood into [H] using the [src.name].</span>")
					catridge.uses -= 1
					return
				else
					user.visible_message("<span class='combat'>\The [user] failed to inject blood into [H]!</span>", \
					"<span class='combat'>You fail to inject blood into [H]!</span>")
					catridge.uses -= 1
					return

		else
			user.visible_message("<span class='combat'>\The [user] failed to inject blood into [H]!</span>", \
			"<span class='combat'>You fail to inject blood into [H]!</span>")
			catridge.uses -= 1
			return

	else
		..()

/obj/item/weapon/bloodinjector/RightClick(mob/user)
	if(catridge)
		catridge.loc = get_turf(src.loc)
		user.put_in_hands(catridge)
		catridge = null
		user.visible_message("<span clas='passive'>[user.name] unloads [src].</span>")

/obj/item/weapon/bloodinjector/attackby(var/obj/item/A, var/mob/user)
	if(istype(A, /obj/item/blood_catridge/) && !catridge)
		user.drop_item(sound = 0)
		catridge = A
		catridge.loc = src
		user.visible_message("<span class='passive'>[user.name] reloads [src].</span>")

/obj/item/weapon/bloodinjector/examine()
	..()
	if(catridge)
		to_chat(usr, "<span class='passive'>It has [catridge.uses] uses left.</span>")
	return

/obj/item/blood_catridge
	name = "Blood catridge"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cartridge"
	var/uses = 4

/obj/item/weapon/scissors
	name = "Scissors"
	icon = 'icons/obj/items.dmi'
	icon_state = "scissors"
	var/time_shave = 5 SECONDS
	var/shave_sound = 'sound/items/scissors.ogg'

/obj/item/weapon/scissors/attack(mob/living/carbon/human/H as mob, mob/living/carbon/human/user, var/target_zone)
	if(!target_zone)
		target_zone = user.zone_sel.selecting
	if(istype(H) && user.a_intent == "help" && (target_zone == "face" || target_zone == "head"))
		if((target_zone == "face" && H.f_style != "Shaved") || (H.h_style != "Bald" && target_zone == "head"))
			user.visible_message("<span class='combat'>[user.name] starts to shave [H.name].</span>")
			playsound(user, shave_sound, 100, 2)
			if(do_after(user, time_shave))
				if(target_zone == "face")
					H.f_style = "Shaved"
				else
					H.h_style = "Bald"
					if(H.check_event("epitemia"))
						var/datum/happiness_event/epitemia/mood = H.events["epitemia"]
						if(mood?.epitemia_type == SHAVE_HAIR)
							H.free_sins()
				H.update_hair()
				return
			else
				return
		else
			return

	..()

/obj/item/weapon/scissors/hairclipper
	name = "Hairclipper"
	icon_state = "hairclipper"
	time_shave = 3 SECONDS
	shave_sound = 'sound/items/haircut.ogg'
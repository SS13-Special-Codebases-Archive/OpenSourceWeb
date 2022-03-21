//a gente usa datum de orgao por enquanto
//entao por enquanto fica essa merda escrota de item aqui
obj/item/weapon/organ
	icon = 'icons/mob/human_races/r_human.dmi'
	var/body_part

obj/item/weapon/organ/New(loc, mob/living/carbon/human/H)
	..(loc)
	if(!istype(H))
		return
	if(H.dna)
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA[H.dna.unique_enzymes] = H.dna.b_type

	//Forming icon for the limb

	//Setting base icon for this mob's race
	var/icon/base
	if(H.species && H.species.icobase)
		base = icon('icons/mob/human_races/human_severed.dmi')
	else
		base = icon('icons/mob/human_races/r_human.dmi')

	if(base)
		//Changing limb's skin tone to match owner
		if(!H.species || H.species.flags & HAS_SKIN_TONE)
			if (H.s_tone >= 0)
				base.Blend(rgb(H.s_tone, H.s_tone, H.s_tone), ICON_ADD)
			else
				base.Blend(rgb(-H.s_tone,  -H.s_tone,  -H.s_tone), ICON_SUBTRACT)

//	if(base)
		//Changing limb's skin color to match owner
//		if(!H.species || H.species.flags & HAS_SKIN_COLOR)
//			base.Blend(rgb(H.r_skin, H.g_skin, H.b_skin), ICON_ADD)

	icon = base
	dir = 2
	if(istype(src, /obj/item/weapon/organ/head))
		return
	else
		src.transform = turn(src.transform, pick(90, 180, 360, 0))

/obj/item/weapon/bone
	name = "bone"
	desc = "To pick with you."
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "bone"
	drop_sound = 'bone_drop.ogg'
	force = 21
	layer = 3.1

/obj/item/weapon/skull
	name = "skull"
	desc = "How poetic."
	icon = 'icons/mob/human_races/human_severed.dmi'
	icon_state = "skull"
	drop_sound = 'bone_drop.ogg'
	layer = 3.1
	
/obj/item/weapon/skull/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(W.sharp)
		if(do_after(user, 20))
			new/obj/item/weapon/reagent_containers/glass/skull(src.loc)
			qdel(src)


/obj/item/weapon/organ/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(W.sharp)
		if(do_after(user, 20))
			new/obj/item/weapon/bone(src.loc)
			new/obj/item/weapon/reagent_containers/food/snacks/meat(src.loc)
			qdel(src)

/obj/item/weapon/organ/head/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(W.sharp)
		if(do_after(user, 20))
			new/obj/item/weapon/skull(user.loc)
			new/obj/item/weapon/reagent_containers/food/snacks/meat(user.loc)
			new/obj/item/weapon/organ/eye(user.loc)
			new/obj/item/weapon/organ/eye(user.loc)
			new/obj/item/weapon/reagent_containers/food/snacks/organ/brain(user.loc)
			new/obj/item/weapon/organ/jaw(user.loc)
			qdel(src)

/obj/item/weapon/organ/eye
	name = "eye"
	desc = "an eye"
	icon_state = "eye"
	force = 10
	layer = 3.1
	item_worth = 1
	body_part = EYES
	icon = 'surgery.dmi'

obj/item/weapon/organ/l_arm
	name = "severed left arm"
	icon = 'human_severed.dmi'
	icon_state = "left_arm"
	item_state = "limb"
	force = 20
	body_part = ARM_LEFT

obj/item/weapon/organ/l_foot
	name = "severed left foot"
	icon = 'human_severed.dmi'
	icon_state = "left_foot"
	item_state = "limb"
	body_part = FOOT_LEFT

obj/item/weapon/organ/l_hand
	name = "severed left hand"
	icon = 'human_severed.dmi'
	icon_state = "left_hand"
	item_state = "limb"
	body_part =	HAND_LEFT

obj/item/weapon/organ/l_leg
	name = "severed left leg"
	icon = 'human_severed.dmi'
	icon_state = "left_leg_nofoot"
	item_state = "limb"
	force = 20
	body_part =	LEG_LEFT

obj/item/weapon/organ/r_arm
	name = "severed right arm"
	icon = 'human_severed.dmi'
	icon_state = "right_arm"
	item_state = "limb"
	force = 20
	body_part = ARM_RIGHT

obj/item/weapon/organ/r_foot
	name = "severed right foot"
	icon = 'human_severed.dmi'
	icon_state = "right_foot"
	item_state = "limb"
	body_part = FOOT_RIGHT

obj/item/weapon/organ/r_hand
	name = "severed right hand"
	icon = 'human_severed.dmi'
	icon_state = "right_hand"
	item_state = "limb"
	body_part = HAND_RIGHT

obj/item/weapon/organ/r_leg
	name = "severed right leg"
	icon = 'human_severed.dmi'
	icon_state = "right_leg_nofoot"
	item_state = "limb"
	force = 20
	body_part = LEG_RIGHT

obj/item/weapon/organ/head
	name = "severed head"
	icon_state = "head_m"
	item_state = "head"
	var/mob/living/carbon/brain/brainmob
	var/brain_op_stage = 0
	body_part = HEAD

/obj/item/weapon/organ/head/posi
	name = "robotic head"

obj/item/weapon/organ/head/New(loc, mob/living/carbon/human/H)
	if(istype(H))
		src.icon_state = H.gender == MALE? "head_m" : "head_f"
	..()
	//Add (facial) hair.
	if(H.f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[H.f_style]
		if(facial_hair_style)
			var/icon/facial = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial.Blend(rgb(H.r_facial, H.g_facial, H.b_facial), ICON_ADD)

			overlays.Add(facial) // icon.Blend(facial, ICON_OVERLAY)

	if(H.h_style && !(H.head && (H.head.flags & BLOCKHEADHAIR)))
		var/datum/sprite_accessory/hair_style = hair_styles_list[H.h_style]
		if(hair_style)
			var/icon/hair = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				hair.Blend(rgb(H.r_hair, H.g_hair, H.b_hair), ICON_ADD)

			overlays.Add(hair) //icon.Blend(hair, ICON_OVERLAY)

	var/icon/eyes_s = new/icon("icon" = 'icons/mob/human_face.dmi', "icon_state" = H.species ? H.species.eyes : "eyes_s")

	eyes_s.Blend(rgb(H.r_eyes, H.g_eyes, H.b_eyes), ICON_ADD)

	overlays.Add(eyes_s)

	spawn(5)
	if(brainmob && brainmob.client)
		brainmob.client.screen.len = null //clear the hud

	//if(ishuman(H))
	//	if(H.gender == FEMALE)
	//		H.icon_state = "head_f"
	//	H.overlays += H.generate_head_icon()

	dir = 2

	name = "[H.real_name]'s head"

	H.regenerate_icons()

	brainmob.stat = 2
	brainmob.death()

obj/item/weapon/organ/head/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->head
	H.ghostize(1)
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna.Clone()
	if(H.mind)
		H.mind.transfer_to(brainmob)
	brainmob.container = src

obj/item/weapon/organ/head/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/surgery_tool/scalpel))
		switch(brain_op_stage)
			if(0)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] is beginning to have \his head cut open with [W] by [user].", 1)
				brainmob << "\red [user] begins to cut open your head with [W]!"
				user << "\red You cut [brainmob]'s head open with [W]!"

				brain_op_stage = 1

			if(2)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] is having \his connections to the brain delicately severed with [W] by [user].", 1)
				brainmob << "\red [user] begins to cut open your head with [W]!"
				user << "\red You cut [brainmob]'s head open with [W]!"

				brain_op_stage = 3.0
			else
				..()
	else if(istype(W,/obj/item/weapon/surgery_tool/circular_saw))
		switch(brain_op_stage)
			if(1)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] has \his head sawed open with [W] by [user].", 1)
				brainmob << "\red [user] begins to saw open your head with [W]!"
				user << "\red You saw [brainmob]'s head open with [W]!"

				brain_op_stage = 2
			if(3)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] has \his spine's connection to the brain severed with [W] by [user].", 1)
				brainmob << "\red [user] severs your brain's connection to the spine with [W]!"
				user << "\red You sever [brainmob]'s brain's connection to the spine with [W]!"

				user.attack_log += "\[[time_stamp()]\]<font color='red'> Debrained [brainmob.name] ([brainmob.ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)])</font>"
				brainmob.attack_log += "\[[time_stamp()]\]<font color='orange'> Debrained by [user.name] ([user.ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)])</font>"
				msg_admin_attack("[user] ([user.ckey]) debrained [brainmob] ([brainmob.ckey]) (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

				//TODO: ORGAN REMOVAL UPDATE.
				if(istype(src,/obj/item/weapon/organ/head/posi))
					var/obj/item/device/mmi/posibrain/B = new(loc)
					B.transfer_identity(brainmob)
				else
					var/obj/item/weapon/reagent_containers/food/snacks/organ/brain/B = new(loc)
					B.transfer_identity(brainmob)

				brain_op_stage = 4.0
			else
				..()
	else
		..()

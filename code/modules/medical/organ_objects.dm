//objetos de orgao
//por enquanto a gente ainda usa os datums pra processar as merda de verdade entao fica tudo solto aqui mesmo uma bosta
/obj/item/weapon/reagent_containers/food/snacks/organ
	name = "severed organ"
	desc = "It looks like it probably just plopped out."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"

	health = 100                              // Process() ticks before death.
	w_class = 2
	var/max_health = 100
	var/escritura = ""
	var/fresh = 3                             // Squirts of blood left in it.
	var/dead_icon                             // Icon used when the organ dies.
	var/robotic                               // Is the limb prosthetic?
	var/organ_tag                             // What slot does it go in?
	var/connected = FALSE
	var/organ_type = /datum/organ/internal    // Used to spawn the relevant organ data when produced via a machine or spawn().
	var/datum/organ/internal/organ_data =  /datum/organ/internal      // Stores info when removed.
	var/prosthetic_name = "prosthetic organ"  // Flavour string for robotic organ.
	var/prosthetic_icon                       // Icon for robotic organ.
	var/mob/living/carbon/human/owner = null
	var/toxic = TRUE
	item_worth = 40
	bitesize = 4
	var/bumorgan = FALSE
	organ = 1

/obj/item/weapon/reagent_containers/food/snacks/organ/attack_self(mob/user as mob)
	return

/obj/item/weapon/reagent_containers/food/snacks/organ/New()
	..()
	reagents.add_reagent("nutriment", 5)
	if(toxic && !(ticker?.eof?.id == "organs"))
		reagents.add_reagent("????", 1)
	if(istype(loc, /obj/item/weapon/storage/touchable/organ))
		var/obj/item/weapon/storage/touchable/organ/O = loc
		owner = O.owner
		connected = TRUE
	organ_data = new organ_data
	create_reagents(5)
	if(!robotic)
		processing_objects += src
	spawn(1)
		update()

/obj/item/weapon/reagent_containers/food/snacks/organ/On_Consume()
	..()
	if(ishuman(usr) && (ticker.eof.id == "organs"))
		var/mob/living/carbon/human/H = usr
		H.add_event("goodfood", /datum/happiness_event/nutrition/goodfood)

/obj/item/weapon/reagent_containers/food/snacks/organ/Del()
	if(!robotic) processing_objects -= src
	..()

/obj/item/weapon/reagent_containers/food/snacks/organ/process()

	if(robotic)
		processing_objects -= src
		return

	// Don't process if we're in a freezer, an MMI or a stasis bag. //TODO: ambient temperature?
	if(istype(loc,/obj/item/device/mmi) || istype(loc,/obj/item/bodybag/cryobag) || istype(loc,/obj/structure/closet/crate/freezer) || istype(loc,/obj/item/weapon/storage/touchable/organ))
		return

	if(owner)
		return

	if(fresh && prob(40))
		fresh--
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
		blood_splatter(src,B,1)

	health -= rand(1,3)
	if(health <= 0)
		die()

/obj/item/weapon/reagent_containers/food/snacks/organ/proc/die()
	health = 0
	processing_objects -= src
	if(organ_data)
		organ_data.damage = organ_data.min_broken_damage
	update_icon()

/obj/item/weapon/reagent_containers/food/snacks/organ/update_icon()
	if(health <= 0 && dead_icon)
		icon_state = dead_icon
	else
		icon_state = initial(icon_state)
	//TODO: Grey out the icon state.
	//TODO: Inject an organ with peridaxon to make it alive again.

/obj/item/weapon/reagent_containers/food/snacks/organ/proc/roboticize()

	robotic = (organ_data && organ_data.robotic) ? organ_data.robotic : 1

	if(prosthetic_name)
		name = prosthetic_name

	if(prosthetic_icon)
		icon_state = prosthetic_icon
	else
		//TODO: convert to greyscale.

/obj/item/weapon/reagent_containers/food/snacks/organ/proc/update()

	if(!organ_data)
		organ_data = new /datum/organ/internal()

	if(robotic)
		organ_data.robotic = robotic

	if(organ_data.robotic >= 2)
		roboticize()

// Brain is defined in brain_item.dm.
/obj/item/weapon/reagent_containers/food/snacks/organ/heart
	name = "heart"
	icon_state = "heart-on"
	prosthetic_name = "circulatory pump"
	prosthetic_icon = "heart-prosthetic"
	organ_tag = "heart"
	fresh = 6 // Juicy.
	dead_icon = "heart-off"
	organ_data = /datum/organ/internal/heart
	var/datum/antagonist/dreamer/dream
	item_worth = 60

/obj/item/weapon/reagent_containers/food/snacks/organ/heart/examine()
	..()
	if(is_dreamer(usr))
		var/mob/living/carbon/human/H = usr
		var/dreamkey1 = H.mind.antag_datums.key1
		var/dreamkey2 = H.mind.antag_datums.key2
		var/dreamkey3 = H.mind.antag_datums.key3
		var/dreamkey4 = H.mind.antag_datums.key4
		if(escritura)
			to_chat(H, "<B> There's something special CUT on this HEART: \"THE KEY [escritura == dreamkey1 ? "ONE" : escritura == dreamkey2 ? "TWO" : escritura == dreamkey3 ? "THREE" : escritura == dreamkey4 ? "FOUR" : "UNKNOWN"] É: [escritura]. Add it to the other keys to exit INRI.\"")
		else
			to_chat(H, "<B> There is NOTHING on this heart. Should be? Following the TRUTH - not here. I need to keep LOOKING. Keep FOLLOWING my heart.</B>")
		if(!(escritura in H.seenwonders) && escritura != "")
			H.seenwonders.Add(escritura)
			H << 'sound/lfwbsounds/newheart.ogg'
		if(H.seenwonders.len >= 4)
			H.mind.antag_datums.agony(H)

/obj/item/weapon/reagent_containers/food/snacks/organ/proc/bumorgans()
	if(!istype(src, /obj/item/weapon/reagent_containers/food/snacks/organ/eyes) || !istype(src, /obj/item/weapon/organ/jaw))
		icon = 'severed_bum.dmi'
		bumorgan = TRUE
		item_worth = 1

/obj/item/weapon/reagent_containers/food/snacks/organ/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	prosthetic_name = "gas exchange system"
	prosthetic_icon = "lungs-prosthetic"
	organ_tag = "lungs"
	organ_data = /datum/organ/internal/lungs

/obj/item/weapon/reagent_containers/food/snacks/organ/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	prosthetic_name = "prosthetic kidneys"
	prosthetic_icon = "kidneys-prosthetic"
	organ_tag = "kidneys"
	organ_data = /datum/organ/internal/kidney

/obj/item/weapon/reagent_containers/food/snacks/organ/stomach
	name = "stomach"
	icon_state = "stomach"
	gender = PLURAL
	prosthetic_name = "prosthetic stomach"
	prosthetic_icon = "stomach-prosthetic"
	organ_tag = "stomach"
	organ_data = /datum/organ/internal/stomach

/obj/item/weapon/reagent_containers/food/snacks/organ/guts
	name = "guts"
	icon_state = "guts"
	gender = PLURAL
	prosthetic_name = "prosthetic guts"
	prosthetic_icon = "guts-prosthetic"
	organ_tag = "guts"
	organ_data = /datum/organ/internal/guts

/obj/item/weapon/organ/jaw
	name = "jaw"
	icon_state = "jaw"
	gender = PLURAL
	item_worth = 0
	body_part = MOUTH
	icon = 'surgery.dmi'

/obj/item/weapon/reagent_containers/food/snacks/organ/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	prosthetic_name = "visual prosthesis"
	prosthetic_icon = "eyes-prosthetic"
	organ_tag = "eyes"
	organ_data = /datum/organ/internal/eyes
	item_worth = 0
	toxic = FALSE
	var/eye_colour

/obj/item/weapon/reagent_containers/food/snacks/organ/liver
	name = "liver"
	icon_state = "liver"
	prosthetic_name = "toxin d_filter"
	prosthetic_icon = "liver-prosthetic"
	organ_tag = "liver"
	organ_data = /datum/organ/internal/liver

/obj/item/weapon/reagent_containers/food/snacks/organ/appendix
	name = "appendix"
	icon_state = "appendix"
	organ_tag = "appendix"
	organ_data = /datum/organ/internal/appendix

//These are here so they can be printed out via the fabricator.
/obj/item/weapon/reagent_containers/food/snacks/organ/heart/prosthetic
	name = "circulatory pump"
	icon_state = "heart-prosthetic"
	organ_data = /datum/organ/internal/heart/robotic

/obj/item/weapon/reagent_containers/food/snacks/organ/lungs/prosthetic
	name = "gas exchange system"
	icon_state = "lungs-prosthetic"
	organ_data = /datum/organ/internal/lungs/robotic

/obj/item/weapon/reagent_containers/food/snacks/organ/kidneys/prosthetic
	name = "prosthetic kidneys"
	icon_state = "kidneys-prosthetic"
	organ_data = /datum/organ/internal/lungs/robotic

/obj/item/weapon/reagent_containers/food/snacks/organ/eyes/prosthetic
	name = "visual prosthesis"
	icon_state = "eyes-prosthetic"
	organ_data = /datum/organ/internal/lungs/robotic

/obj/item/weapon/reagent_containers/food/snacks/organ/liver/prosthetic
	name = "toxin d_filter"
	icon_state = "liver-prosthetic"
	organ_data = /datum/organ/internal/lungs/robotic

/obj/item/weapon/reagent_containers/food/snacks/organ/brain/prosthetic
	organ_data = /datum/organ/internal/brain

/obj/item/weapon/reagent_containers/food/snacks/organ/appendix
	name = "appendix"

/obj/item/weapon/reagent_containers/food/snacks/organ/examine()
	..()
	if(src.organ_data.damage == 0)
		to_chat(usr, "<span class='passive'>it's in perfect state.</span>")
	else
		to_chat(usr, "<span class='combat'>it's damaged!</span>")
	if(src.bumorgan)
		to_chat(usr, "<span class='combat'>This organ has seen better nights.</span>")

/obj/item/weapon/reagent_containers/food/snacks/organ/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	..()
	if(istype(W, /obj/item/weapon/surgery_tool/suture))
		var/obj/item/weapon/surgery_tool/suture/S = W
		if(!connected && istype(src.loc, /obj/item/weapon/storage/touchable/organ))
			var/obj/item/weapon/storage/touchable/organ/O = src.loc
			var/mob/living/carbon/human/H = O.owner
			user.visible_message("<span class='passive'>[user] begins sewing [src.name] inside [H.name].</span>")
			if(do_after(user, 20))
				var/list/roll_result = roll3d6(user, SKILL_SURG, -2, FALSE)
				switch(roll_result[GP_RESULT])
					if(GP_SUCCESS, GP_CRITSUCCESS)
						user.visible_message("<span class='passive'>[user] sewing [src.name] inside [H.name].</span>")
						connected = TRUE
						coisa(src, owner, 1)
						playsound(src, 'sound/lfwbsounds/suture.ogg', 70, 1)
					if(GP_FAILED, GP_CRITFAIL)
						user.visible_message("<span class='combat'>[user] damaging the [src]</span>")
						var/damage_organs = rand(1,3)
						health -= damage_organs
						src.organ_data.damage += damage_organs
				S.amount -= 1
				S.amountcheck()
			return

		if(organ_data.damage || health != max_health)
			user.visible_message("<span class='passive'>[user] begins to repair [src]</span>")
			if(do_after(user, 20))
				var/list/roll_result = roll3d6(user, SKILL_SURG, -2, FALSE)
				switch(roll_result[GP_RESULT])
					if(GP_SUCCESS, GP_CRITSUCCESS)
						user.visible_message("<span class='passive'>[user] repaired the [src]</span>")
						health = max_health
						src.organ_data.damage = 0
						playsound(src, 'sound/lfwbsounds/suture.ogg', 70, 1)
					if(GP_FAILED, GP_CRITFAIL)
						user.visible_message("<span class='combat'>[user] damaging the [src]</span>")
						var/damage_organs = rand(1,3)
						health -= damage_organs
						src.organ_data.damage += damage_organs
				S.amount -= 1
				S.amountcheck()
			return

	if(istype(W, /obj/item/weapon/surgery_tool/scalpel) && connected)
		if(do_after(user, 20))
			var/list/roll_result = roll3d6(user, SKILL_SURG, -2, FALSE)
			switch(roll_result[GP_RESULT])
				if(GP_SUCCESS, GP_CRITSUCCESS)
					connected = FALSE
					user.visible_message("<span class='passive'>[user] unconnects [owner.name]'s [src.name]!</span>")
					coisa(src, owner, 0)
					if(organ_data.vital)
						owner.death()
				if(GP_FAILED, GP_CRITFAIL)
					user.visible_message("<span class='combat'>[user] damaging [owner.name]'s [src.name]!</span>")
					var/damage_organs = rand(1,3)
					health -= damage_organs
					organ_data.damage += damage_organs

		return
	if(istype(W, /obj/item/weapon/surgery_tool/retractor) && istype(src.loc, /obj/item/weapon/storage/touchable/organ))
		var/obj/item/weapon/storage/touchable/organ/S = src.loc
		if(connected)
			to_chat(user, "<span class='combat'>You need to unconnect organ before removing it!</span>")
			return
		else
			var/turf/T = locate(owner.x+1,owner.y,owner.z)
			if(istype(T, /turf/simulated/wall))
				return
			for(var/atom/A in T)
				if(istype(A, /obj/machinery/))
					return
			S.remove_from_storage(src, T)
			return

/obj/item/weapon/organ/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	if(W.sharp)
		if(statcheck(user.my_stats.st, 9, 0))
			if(do_after(user, 20))
				new/obj/item/weapon/bone(src.loc)
				new/obj/item/weapon/reagent_containers/food/snacks/meat(src.loc)
				qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/organ/proc/removed(var/mob/living/target,var/mob/living/user)

	if(!target || !user)
		return

	if(organ_data.vital)
		user.attack_log += "\[[time_stamp()]\]<font color='red'> removed a vital organ ([src]) from [target.name] ([target.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
		target.attack_log += "\[[time_stamp()]\]<font color='orange'> had a vital organ ([src]) removed by [user.name] ([user.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
		msg_admin_attack("[user.name] ([user.ckey]) removed a vital organ ([src]) from [target.name] ([target.ckey]) (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		target.death()

/obj/item/weapon/reagent_containers/food/snacks/organ/appendix/removed(var/mob/living/target,var/mob/living/user)

	..()

	var/inflamed = 0
	for(var/datum/disease/appendicitis/appendicitis in target.viruses)
		inflamed = 1
		appendicitis.cure()
		target.resistances += appendicitis

	if(inflamed)
		icon_state = "appendixinflamed"
		name = "inflamed appendix"

/obj/item/weapon/reagent_containers/food/snacks/organ/eyes/removed(var/mob/living/target,var/mob/living/user)

	if(!eye_colour)
		eye_colour = list(0,0,0)

	..() //Make sure target is set so we can steal their eye colour for later.
	var/mob/living/carbon/human/H = target
	if(istype(H))
		eye_colour = list(
			H.r_eyes ? H.r_eyes : 0,
			H.g_eyes ? H.g_eyes : 0,
			H.b_eyes ? H.b_eyes : 0
			)

		// Leave bloody red pits behind!
		H.r_eyes = 128
		H.g_eyes = 0
		H.b_eyes = 0
		H.update_body()

/obj/item/weapon/reagent_containers/food/snacks/organ/proc/replaced(var/mob/living/target)
	return

/obj/item/weapon/reagent_containers/food/snacks/organ/eyes/replaced(var/mob/living/target)

	// Apply our eye colour to the target.
	var/mob/living/carbon/human/H = target
	if(istype(H) && eye_colour)
		H.r_eyes = eye_colour[1]
		H.g_eyes = eye_colour[2]
		H.b_eyes = eye_colour[3]
		H.update_body()

/obj/item/weapon/reagent_containers/food/snacks/organ/proc/bitten(mob/user)

	if(robotic)
		return

	to_chat(user, "\blue You take an bite out of \the [src].")
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
	blood_splatter(src,B,1)


	user.drop_from_inventory(src)
	var/obj/item/weapon/reagent_containers/food/snacks/organ/O = new(get_turf(src))
	O.name = name
	O.icon_state = dead_icon ? dead_icon : icon_state

	// Pass over the blood.
	reagents.trans_to(O, reagents.total_volume)

	if(fingerprints) O.fingerprints = fingerprints.Copy()
	if(fingerprintshidden) O.fingerprintshidden = fingerprintshidden.Copy()
	if(fingerprintslast) O.fingerprintslast = fingerprintslast

	user.put_in_active_hand(O)
	qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/organ/on_exit_storage(obj/item/weapon/storage/S as obj, var/new_location)
	if(ismob(new_location) && istype(S, /obj/item/weapon/storage/touchable/organ))
		var/mob/M = new_location
		var/datum/organ/internal/heart/Heart = src.owner.internal_organs_by_name[pick("heart")]
		if(Heart && Heart.escritura)
			if(istype(src, /obj/item/weapon/reagent_containers/food/snacks/organ/heart))
				src.escritura = Heart.escritura
		if(connected)
			coisa(src, src.owner, 0)
			src.organ_data.damage += 60
			health -= 60
			connected = FALSE
		var/damage_organ = rand(30, 40)
		src.organ_data.damage += damage_organ
		health -= damage_organ
		src.removed(src.owner, M)
		M.visible_message("[M] exhumes [src.owner]!")
		playsound(M.loc, pick('sound/lfwbsounds/itm_ingredient_heart_01.ogg', 'sound/lfwbsounds/itm_ingredient_heart_02.ogg'), 100)
		processing_objects.Add(src)
		return 1
	else if(istype(S, /obj/item/weapon/storage/touchable/organ))
		var/datum/organ/internal/heart/Heart = src.owner.internal_organs_by_name[pick("heart")]
		if(Heart && Heart.escritura)
			if(istype(src, /obj/item/weapon/reagent_containers/food/snacks/organ/heart))
				src.escritura = Heart.escritura
		if(connected)
			coisa(src, src.owner, 0)
			connected = FALSE
		processing_objects.Add(src)
		return 1

	return
/* Kitchen tools
 * Contains:
 *		Utensils
 *		Spoons
 *		Forks
 *		Knives
 *		Kitchen knives
 *		Butcher's cleaver
 *		Rolling Pins
 *		Trays
 */

/obj/item/weapon/kitchen
	icon = 'icons/obj/kitchen.dmi'

/*
 * Utensils
 */
/obj/item/weapon/kitchen/utensil
	force = 8.0
	w_class = 1.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	flags = FPRINT | TABLEPASS | CONDUCT
	origin_tech = "materials=1"
	attack_verb = list("attacked", "poked")
	weaponteaching = "KNIFE"

/obj/item/weapon/kitchen/utensil/New()
	if (prob(60))
		src.pixel_y = rand(0, 4)
	return

/*
 * Spoons
 */
/obj/item/weapon/kitchen/utensil/spoon
	name = "spoon"
	desc = "SPOON!"
	icon_state = "spoon"
	item_state = "spoon"
	item_worth = 5
	attack_verb = list("attacked", "poked")

/obj/item/weapon/kitchen/utensil/pspoon
	name = "plastic spoon"
	desc = "Super dull action!"
	icon_state = "pspoon"
	attack_verb = list("attacked", "poked")

/*
 * Forks
 */
/obj/item/weapon/kitchen/utensil/fork
	name = "fork"
	desc = "Pointy."
	icon_state = "fork"
	item_state = "fork"
	item_worth = 5

/obj/item/weapon/kitchen/utensil/fork/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return ..()

	if(user.zone_sel.selecting != "eyes" && user.zone_sel.selecting != "head")
		return ..()

	if (src.icon_state == "forkloaded") //This is a poor way of handling it, but a proper rewrite of the fork to allow for a more varied foodening can happen when I'm in the mood. --NEO
		if(M.wear_mask && M.wear_mask.flags & MASKCOVERSMOUTH)
			if(M == user)
				for(var/mob/O in viewers(M, null))
					O.show_message(text("\red [] tried to eat a delicious forkful of omelette through the mask! How stupid!", user), 1)
			else
				for(var/mob/O in viewers(M, null))
					O.show_message(text("\red [] tried to feed [] a delicious forkful of omelette through the mask!", user, M), 1)
		return

		if(M == user)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\blue [] eats a delicious forkful of omelette!", user), 1)
				M.reagents.add_reagent("nutriment", 2)
		else
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\blue [] feeds [] a delicious forkful of omelette!", user, M), 1)
				M.reagents.add_reagent("nutriment", 2)
		src.icon_state = "fork"
		return
	else
		if((CLUMSY in user.mutations) && prob(50))
			M = user
		return eyestab(M,user)

/obj/item/weapon/kitchen/utensil/pfork
	name = "plastic fork"
	desc = "Yay, no washing up to do."
	icon_state = "pfork"

/obj/item/weapon/kitchen/utensil/pfork/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return ..()

	if(user.zone_sel.selecting != "eyes" && user.zone_sel.selecting != "head")
		return ..()

	if (src.icon_state == "forkloaded") //This is a poor way of handling it, but a proper rewrite of the fork to allow for a more varied foodening can happen when I'm in the mood. --NEO
		if(M.wear_mask && M.wear_mask.flags & MASKCOVERSMOUTH)
			if(M == user)
				for(var/mob/O in viewers(M, null))
					O.show_message(text("\red [] tried to eat a delicious forkful of omelette through the mask! How stupid!", user), 1)
			else
				for(var/mob/O in viewers(M, null))
					O.show_message(text("\red [] tried to feed [] a delicious forkful of omelette through the mask!", user, M), 1)
			return

		if(M == user)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\blue [] eats a delicious forkful of omelette!", user), 1)
				M.reagents.add_reagent("nutriment", 2)
		else
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\blue [] feeds [] a delicious forkful of omelette!", user, M), 1)
				M.reagents.add_reagent("nutriment", 2)
		src.icon_state = "fork"
		return
	else
		if((CLUMSY in user.mutations) && prob(50))
			M = user
		return eyestab(M,user)

/*
 * Knives
 */
/obj/item/weapon/kitchen/utensil/knife
	name = "knife"
	desc = "Can cut through any food."
	icon_state = "knife"
	item_state = "knife"
	blood_suffix = "b"
	force = 13
	throwforce = 15.0
	sharp = 1
	throw_speed = 4
	throw_range = 8
	force_wielded = 18.0
	force_unwielded = 13.0
	edge = 0
	drop_sound = 'knife_drop.ogg'
	drawsound = 'knife_equip.ogg'
	item_worth = 5
	hitsound= "slash"
	speciality = SKILL_KNIFE
	var/atk_mode = SLASH

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>")
		return (BRUTELOSS)

/obj/item/weapon/kitchen/utensil/knife/switchblade
	blooded_icon = FALSE
	blood_suffix = "b"
	name = "switch blade"
	desc = "Can cut through any throat."
	icon_state = "switchblade0"
	item_state = "knifer0"
	drawsound = null
	edge = 1
	sharp = 0
	var/open = FALSE

/obj/item/weapon/kitchen/utensil/knife/switchblade/attack_self(mob/user)
	if(open == FALSE)
		open = TRUE
		icon_state = "switchblade1"
		item_state = "knifer1"
		hitsound= "stab"
		edge = 1
		force = 14
		sharp = 0
		playsound(src.loc, 'sound/webbers/switchblade.ogg', 50, 1)
		return
	if(open == TRUE)
		open = FALSE
		icon_state = "switchblade0"
		item_state = "knifer0"
		hitsound = null
		edge = 0
		sharp = 0
		force = 0
		playsound(src.loc, 'sound/webbers/switchblade.ogg', 50, 1)
		return

/obj/item/weapon/kitchen/utensil/knife/attack_self(mob/user)
	..()
	if(atk_mode == SLASH)
		atk_mode = STAB
		to_chat(user, "You will now stab.")
		edge = 1
		sharp = 0
		attack_verb = list("stabs")
		hitsound = "stab"
		return

	else if(atk_mode == STAB)
		atk_mode = SLASH
		to_chat(user, "You will now slash.")
		edge = 0
		sharp = 1
		attack_verb = list("hits", "clubs")
		hitsound = initial(hitsound)
		return


/obj/item/weapon/kitchen/utensil/knife/flaying
	name = "flaying knife"
	desc = "used to flay skin."
	icon_state = "skinning"

/obj/item/weapon/kitchen/utensil/knife/flaying/attack(mob/living/carbon/human/H as mob, mob/user as mob)
	if (depotenzia(H, user))
		return

	if(ishuman(H) && user.zone_sel.selecting != "groin")
		var/datum/organ/external/affecting = H.get_organ(ran_zone(user.zone_sel.selecting))

		if(!affecting.skin)
			to_chat(user, "<span class='notice'>[H] doesn't have any skin left!</span>")
			return
		if(affecting.skin)
			H.visible_message("<span class='danger'>[user] starts to flay [H]'s skin with [src]!</span>")
			H.custom_pain("[pick("OH [uppertext(H.god_text())] MY SKIN!!", "OH [uppertext(H.god_text())] WHY!")]", 100)
			H.emote("agonyscream")
			if(do_after(user, 66))
				H.visible_message("<span class='danger'>[user] flays [H]'s skin with [src]!</span>")
				H.custom_pain("[pick("OH IT HURTS SO MUCH!!", "WHAT HAVE I DONE!")]", 100)
				H.apply_damage(rand(5, 10), BRUTE, affecting)
				H.emote("agonyscream")
				affecting.skin = 0
				if(H.stat == DEAD)
					return
				if(H.buckled && istype(H.buckled, /obj/structure/stool/bed/chair/comfy/torture))
					H.client.ChromieWinorLoose(H.client, -1)



/obj/item/var/silver = FALSE

/obj/item/weapon/kitchen/utensil/knife/combat
	name = "hunter knife"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "combat"
	item_state = "dagger"
	force = 19
	throwforce = 12
	sharp = 1
	edge = 1
	drawsound = "unsheath"
	drop_sound = 'sound/effects/drop_sword.ogg'
	penetrating = TRUE
	item_worth = 7
	hitsound= "blade"
	sheathiconknife = "combat_sh2"
	equip_sound = "sheath"

/obj/item/weapon/kitchen/utensil/knife/cutelo
	name = "cutelo"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cleaver"
	item_state = "cleaver"
	force = 19
	throwforce = 12
	sharp = 1
	edge = 0
	drawsound = "unsheath"
	drop_sound = 'sound/effects/drop_sword.ogg'
	penetrating = TRUE
	item_worth = 5
	hitsound= "slash"

/obj/item/weapon/kitchen/utensil/knife/cutelo/attack_self(mob/user)
	return

/obj/item/weapon/kitchen/utensil/knife/combatrue
	name = "combat knife"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "combat"
	item_state = "dagger"
	force = 14
	throwforce = 12
	drawsound = "unsheath"
	drop_sound = 'sound/effects/drop_sword.ogg'
	item_worth = 7
	hitsound= "blade"
	sheathiconknife = "combat_sh1"
	penetrating = TRUE
	equip_sound = "sheath"

/obj/item/weapon/kitchen/utensil/knife/dagger
	name = "iron dagger"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dagger"
	item_state = "dagger"
	force = 19
	throwforce = 16
	sharp = 1
	edge = 0
	penetrating = TRUE
	drop_sound = 'knife_drop.ogg'
	drawsound = 'dagger_draw.ogg'
	item_worth = 7
	hitsound= "stab"
	sheathicondagger = "dagger_sheath1"
	equip_sound = "sheath"

/obj/item/weapon/kitchen/utensil/knife/dagger/silver
	name = "silver dagger"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "silverdagger"
	item_state = "dagger"
	force = 15
	throwforce = 16
	drop_sound = 'knife_drop.ogg'
	drawsound = 'dagger_draw.ogg'
	item_worth = 14
	hitsound= "blade"

/obj/item/weapon/kitchen/utensil/knife/dagger/copper
	name = "copper dagger"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "copperdagger"
	item_state = "dagger"
	force = 10
	throwforce = 15
	drop_sound = 'knife_drop.ogg'
	drawsound = 'dagger_draw.ogg'
	item_worth = 5
	hitsound= "stab"

/obj/item/weapon/kitchen/utensil/knife/dagger/wood_stake
	name = "wooden stake"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "wstake"
	item_state = "wstake"
	force = 15
	throwforce = 10
	drop_sound = 'wooden_drop.ogg'
	hitsound= "stab"
	sharp = 0
	edge = 1

/obj/item/weapon/kitchen/utensil/knife/dagger/adamantium
	name = "adamantium dagger"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "adagger"
	item_state = "dagger"
	force = 35
	throwforce = 36
	drop_sound = 'knife_drop.ogg'
	drawsound = 'dagger_draw.ogg'
	item_worth = 224
	hitsound= "blade"

/obj/item/weapon/kitchen/utensil/knife/dagger/adamantium/throwing
	name = "adamantium dagger"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "athrowing"
	item_state = "dagger"
	force = 35
	throwforce = 45
	drop_sound = 'knife_drop.ogg'
	drawsound = 'dagger_draw.ogg'
	item_worth = 224
	hitsound= "blade"

/obj/item/weapon/kitchen/utensil/knife/dagger/silver
	name = "silver dagger"
	icon_state = "silverdagger"
	silver = TRUE

/obj/item/weapon/kitchen/utensil/pknife
	name = "plastic knife"
	desc = "The bluntest of blades."
	icon_state = "pknife"
	force = 13.0
	throwforce = 10.0
	drop_sound = 'knife_drop.ogg'
	drawsound = 'knife_equip.ogg'
	speciality = SKILL_KNIFE

/obj/item/weapon/kitchen/utensil/pknife/attack(target as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		user << "\red You somehow managed to cut yourself with the [src]."
		user.take_organ_damage(20)
		return
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/*
 * Kitchen knives
 */
/obj/item/weapon/kitchenknife
	name = "kitchen knife"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife"
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	flags = FPRINT | TABLEPASS | CONDUCT
	sharp = 1
	edge = 1
	force = 18.0
	w_class = 3.0
	throwforce = 6.0
	throw_speed = 3
	throw_range = 6
	m_amt = 12000
	origin_tech = "materials=1"
	attack_verb = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
	drop_sound = 'knife_drop.ogg'
	drawsound = 'knife_equip.ogg'
	item_worth = 5
	hitsound= "blade"

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>")
		return (BRUTELOSS)

/obj/item/weapon/kitchenknife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"

/obj/item/weapon/kitchenknife/tanning
	name = "tanning knife"
	desc = "An old tanning knife."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"

/*
 * Bucher's cleaver
 */
/obj/item/weapon/butch
	name = "butcher's cleaver"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "butch"
	desc = "A huge thing used for chopping and chopping up meat. This includes clowns and clown-by-products."
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 22.0
	w_class = 2.0
	throwforce = 8.0
	throw_speed = 3
	throw_range = 6
	m_amt = 12000
	origin_tech = "materials=1"
	attack_verb = list("cleaved", "slashed", "sliced", "torn", "ripped", "diced", "cut")
	sharp = 1
	edge = 1

/obj/item/weapon/butch/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/*
 * Rolling Pins
 */

/obj/item/weapon/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	force = 12.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 7
	w_class = 3.0
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked") //I think the rollingpin attackby will end up ignoring this anyway.

/*/obj/item/weapon/kitchen/rollingpin/attack(mob/living/M as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		user << "\red The [src] slips out of your hand and hits your head."
		user.take_organ_damage(10)
		user.Paralyse(2)
		return

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) used the [src.name] to attack [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	var/t = user:zone_sel.selecting
	if (t == "head")
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.stat < 2 && H.health < 50 && prob(90))
				// ******* Check
				if (istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80))
					H << "\red The helmet protects you from being hit hard in the head!"
					return
				var/time = rand(2, 6)
				if (prob(75))
					H.Paralyse(time)
				else
					H.Stun(time)
				if(H.stat != 2)	H.stat = 1
				user.visible_message("\red <B>[H] has been knocked unconscious!</B>", "\red <B>You knock [H] unconscious!</B>")
				return
			else
				H.visible_message("\red [user] tried to knock [H] unconscious!", "\red [user] tried to knock you unconscious!")
				H.eye_blurry += 3
	return ..()*/ // :catpog:

/*
 * Trays - Agouri
 */
/obj/item/weapon/tray
	name = "tray"
	icon = 'icons/obj/food.dmi'
	icon_state = "tray"
	item_state = "tray"
	desc = "A metal tray to lay food on."
	throwforce = 12.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = FPRINT | TABLEPASS | CONDUCT
	m_amt = 3000
	/* // NOPE
	var/food_total= 0
	var/burger_amt = 0
	var/cheese_amt = 0
	var/fries_amt = 0
	var/classyalcdrink_amt = 0
	var/alcdrink_amt = 0
	var/bottle_amt = 0
	var/soda_amt = 0
	var/carton_amt = 0
	var/pie_amt = 0
	var/meatbreadslice_amt = 0
	var/salad_amt = 0
	var/miscfood_amt = 0
	*/
	var/list/carrying = list() // List of things on the tray. - Doohl
	var/max_carry = 10 // w_class = 1 -- takes up 1
					   // w_class = 2 -- takes up 3
					   // w_class = 3 -- takes up 5

/obj/item/weapon/tray/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	..()
	// Drop all the things. All of them.
	overlays.Cut()
	for(var/obj/item/I in carrying)
		I.loc = M.loc
		carrying.Remove(I)
		if(isturf(I.loc))
			spawn()
				for(var/i = 1, i <= rand(1,2), i++)
					if(I)
						step(I, pick(NORTH,SOUTH,EAST,WEST))
						sleep(rand(2,4))


	if((CLUMSY in user.mutations) && prob(50))              //What if he's a clown?
		M << "\red You accidentally slam yourself with the [src]!"
		M.Weaken(1)
		user.take_organ_damage(2)
		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			return
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1) //sound playin'
			return //it always returns, but I feel like adding an extra return just for safety's sakes. EDIT; Oh well I won't :3

	var/mob/living/carbon/human/H = M      ///////////////////////////////////// /Let's have this ready for later.


	if(!(user.zone_sel.selecting == ("eyes" || "head"))) //////////////hitting anything else other than the eyes
		if(prob(33))
			src.add_blood(H)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))
				location.add_blood(H)     ///Plik plik, the sound of blood

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")
		msg_admin_attack("[user.name] ([user.ckey]) used the [src.name] to attack [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		if(prob(15))
			M.Weaken(3)
			M.take_organ_damage(3)
		else
			M.take_organ_damage(5)
		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red <B>[] slams [] with the tray!</B>", user, M), 1)
			return
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1)  //we applied the damage, we played the sound, we showed the appropriate messages. Time to return and stop the proc
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red <B>[] slams [] with the tray!</B>", user, M), 1)
			return




	if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
		M << "\red You get slammed in the face with the tray, against your mask!"
		if(prob(33))
			src.add_blood(H)
			if (H.wear_mask)
				H.wear_mask.add_blood(H)
			if (H.head)
				H.head.add_blood(H)
			if (H.glasses && prob(33))
				H.glasses.add_blood(H)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))     //Addin' blood! At least on the floor and item :v
				location.add_blood(H)

		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red <B>[] slams [] with the tray!</B>", user, M), 1)
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1)  //sound playin'
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red <B>[] slams [] with the tray!</B>", user, M), 1)
		if(prob(10))
			M.Stun(rand(1,3))
			M.take_organ_damage(5)
			return
		else
			M.take_organ_damage(7)
			return

	else //No eye or head protection, tough luck!
		M << "\red You get slammed in the face with the tray!"
		if(prob(33))
			src.add_blood(M)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))
				location.add_blood(H)

		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red <B>[] slams [] in the face with the tray!</B>", user, M), 1)
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1)  //sound playin' again
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red <B>[] slams [] in the face with the tray!</B>", user, M), 1)
		if(prob(30))
			M.Stun(rand(2,4))
			M.take_organ_damage(5)
			return
		else
			M.take_organ_damage(10)
			if(prob(30))
				M.Weaken(4)
				return
			return

/obj/item/weapon/tray/var/cooldown = 0	//shield bash cooldown. based on world.time

/obj/item/weapon/tray/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/kitchen/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/*
===============~~~~~================================~~~~~====================
=																			=
=  Code for trays carrying things. By Doohl for Doohl erryday Doohl Doohl~  =
=																			=
===============~~~~~================================~~~~~====================
*/
/obj/item/weapon/tray/proc/calc_carry()
	// calculate the weight of the items on the tray
	var/val = 0 // value to return

	for(var/obj/item/I in carrying)
		if(I.w_class == 1.0)
			val ++
		else if(I.w_class == 2.0)
			val += 3
		else
			val += 5

	return val

/obj/item/weapon/tray/pickup(mob/user)

	if(!isturf(loc))
		return

	for(var/obj/item/I in loc)
		if( I != src && !I.anchored && !istype(I, /obj/item/clothing/under) && !istype(I, /obj/item/clothing/suit) && !istype(I, /obj/item/projectile) )
			var/add = 0
			if(I.w_class == 1.0)
				add = 1
			else if(I.w_class == 2.0)
				add = 3
			else
				add = 5
			if(calc_carry() + add >= max_carry)
				break

			I.loc = src
			carrying.Add(I)
			overlays += image("icon" = I.icon, "icon_state" = I.icon_state, "layer" = 30 + I.layer)

/obj/item/weapon/tray/dropped(mob/user)

	var/mob/living/M
	for(M in src.loc) //to handle hand switching
		return

	var/foundtable = 0
	for(var/obj/structure/table/T in loc)
		foundtable = 1
		break

	overlays.Cut()

	for(var/obj/item/I in carrying)
		I.loc = loc
		carrying.Remove(I)
		if(!foundtable && isturf(loc))
			// if no table, presume that the person just shittily dropped the tray on the ground and made a mess everywhere!
			spawn()
				for(var/i = 1, i <= rand(1,2), i++)
					if(I)
						step(I, pick(NORTH,SOUTH,EAST,WEST))
						sleep(rand(2,4))





/////////////////////////////////////////////////////////////////////////////////////////
//Enough with the violent stuff, here's what happens if you try putting food on it
/////////////////////////////////////////////////////////////////////////////////////////////



/*/obj/item/weapon/tray/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/utensil/fork))
		if (W.icon_state == "forkloaded")
			user << "\red You already have omelette on your fork."
			return
		W.icon = 'icons/obj/kitchen.dmi'
		W.icon_state = "forkloaded"
		viewers(3,user) << "[user] takes a piece of omelette with his fork!"
		reagents.remove_reagent("nutriment", 1)
		if (reagents.total_volume <= 0)
			qdel(src)*/


/*			if (prob(33))
						var/turf/location = H.loc
						if (istype(location, /turf/simulated))
							location.add_blood(H)
					if (H.wear_mask)
						H.wear_mask.add_blood(H)
					if (H.head)
						H.head.add_blood(H)
					if (H.glasses && prob(33))
						H.glasses.add_blood(H)
					if (istype(user, /mob/living/carbon/human))
						var/mob/living/carbon/human/user2 = user
						if (user2.gloves)
							user2.gloves.add_blood(H)
						else
							user2.add_blood(H)
						if (prob(15))
							if (user2.wear_suit)
								user2.wear_suit.add_blood(H)
							else if (user2.w_uniform)
								user2.w_uniform.add_blood(H)*/
/obj/item/clothing
	name = "clothing"
	var/list/species_restricted = null //Only these species can wear this kit.
	var/fatmaywear = 1
	var/poop_covering = 0
	var/can_be_worn_by_child = 0 //Snowflake shit for kids.
	var/child_exclusive = 0
	drop_sound = 'drop_clothing.ogg'
	item_worth = 5
	var/armor_type = ARMOR_ROUPA

//BS12: Species-restricted clothing check.
/obj/item/clothing/mob_can_equip(M as mob, slot)

	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(!fatmaywear)
			if(FAT in H.mutations)
				return 0

		if(species_restricted)

			var/wearable = null
			var/exclusive = null

			if("exclude" in species_restricted)
				exclusive = 1

			if(H.species)
				if(istype(H.species, /datum/species/xenos))		//A little dirty, but...
					M << "\red How do you imagine wearing [src]?"
					return 0
				if(exclusive)
					if(!(H.species.name in species_restricted))
						wearable = 1
				else
					if(H.species.name in species_restricted)
						wearable = 1

				if(!wearable && (slot != 15 && slot != 16)) //Pockets.
					M << "\red Your species cannot wear [src]."
					return 0

	return ..()

//Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	w_class = 1.0
	throwforce = 2
	slot_flags = SLOT_EARS
	var/happiness = 0

/obj/item/clothing/ears/attack_hand(mob/user as mob)
	if (!user) return

	if (src.loc != user || !istype(user,/mob/living/carbon/human))
		..()
		return

	var/mob/living/carbon/human/H = user
	if(H.l_ear != src && H.r_ear != src)
		..()
		return

	if(!canremove)
		return

	var/obj/item/clothing/ears/O
	if(slot_flags & SLOT_TWOEARS )
		O = (H.l_ear == src ? H.r_ear : H.l_ear)
		user.u_equip(O)
		if(!istype(src,/obj/item/clothing/ears/offear))
			qdel(O)
			O = src
	else
		O = src

	user.u_equip(src)

	if (O)
		user.put_in_hands(O)
		O.add_fingerprint(user)

	if(istype(src,/obj/item/clothing/ears/offear))
		qdel(src)

/obj/item/clothing/ears/offear
	name = "Other ear"
	w_class = 5.0
	icon = 'icons/mob/screen1_Midnight.dmi'
	icon_state = "block"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

	New(var/obj/O)
		name = O.name
		desc = O.desc
		icon = O.icon
		icon_state = O.icon_state
		dir = O.dir

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earring
	name = "ear ring"
	desc = "An earring."
	icon = 'icons/life/earring.dmi'
	icon_state = ""
	slot_flags = SLOT_EARS

/obj/item/clothing/ears/earring/equipped(mob/M, var/slot)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(slot == slot_r_ear)
		H.add_event("sheekos", /datum/happiness_event/misc/sheekos)
	else
		H.clear_event("sheekos")

/obj/item/clothing/ears/earring/dropped(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	H.clear_event("sheekos")

/obj/item/clothing/ears/earring/gold
	name = "ear ring"
	desc = "A luxurious golden earring"
	icon = 'icons/life/earring.dmi'
	icon_state = "gold_earring"
	item_worth = 72
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earring/silver
	name = "ear ring"
	desc = "A luxurious silver earring"
	icon = 'icons/life/earring.dmi'
	icon_state = "silver_earring"
	item_worth = 52
	slot_flags = SLOT_EARS | SLOT_TWOEARS
	silver = TRUE

/obj/item/clothing/ears/earring/copper
	name = "ear ring"
	desc = "A copper earring"
	icon = 'icons/life/earring.dmi'
	icon_state = "copper_earring"
	item_worth = 28
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earring/bone
	name = "ear ring"
	desc = "An earring made of bone"
	icon = 'icons/life/earring.dmi'
	icon_state = "bone_earring"
	item_worth = 22
	slot_flags = SLOT_EARS | SLOT_TWOEARS

//Glasses
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = 2.0
	flags = GLASSESCOVERSEYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/invisa_view = 0

/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/


//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = 2.0
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.50
	var/wired = 0
	var/obj/item/weapon/cell/cell = 0
	var/clipped = 0
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	species_restricted = list("exclude","Unathi","Tajaran")
	fatmaywear = 1
	var/blocks_firing = FALSE //If the gloves are too big to fit into a trigger guard.

/obj/item/clothing/gloves/examine()
	set src in usr
	..()
	return

/obj/item/clothing/gloves/emp_act(severity)
	if(cell)
		cell.charge -= 1000 / severity
		if (cell.charge < 0)
			cell.charge = 0
		if(cell.reliability != 100 && prob(50/severity))
			cell.reliability -= 10 / severity
	..()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return 0 // return 1 to cancel attack_hand()

//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD


//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK

/obj/item/clothing/mask/proc/d_filter_air(datum/gas_mixture/air)
	return

//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	var/chained = 0
	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET
	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	species_restricted = list("exclude","Unathi","Tajaran")
	fatmaywear = 1

//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	flags = FPRINT | TABLEPASS
	allowed = list(/obj/item/weapon/tank/emergency_oxygen)
	armor = list(melee = 5, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	siemens_coefficient = 0.9

//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|GROIN
	permeability_coefficient = 0.90
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_ICLOTHING
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	var/has_sensor = 1//For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/obj/item/clothing/tie/hastie = null
	var/obj/item/medal/medal_attached = null
	var/image/medal_overlay = null
	var/displays_id = 1
	var/sleeves = 2

/obj/item/clothing/under/MiddleClick(mob/living/carbon/human/user as mob)
	user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
	if(sleeves > 0)
		to_chat(user, "<span class='passive'>You begin to rip [src] sleeve.</span>")
		if(do_after(user,30))
			user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>rips a sleeve from</span> <span class='passive'>[src]</span><span class='passive'>!</span>")
			sleeves -= 1
			var/obj/item/clothing/mask/sleeve/S = new(user.loc)
			S.colorize(src)
			user.put_in_hands(S)
			playsound(src.loc, 'sound/misc/cloth_rip.ogg', 80, 1)
	else
		to_chat(user, "<span class='passivebold'>There's no sleeves for me to rip!</span>")

/obj/item/clothing/under/RightClick(mob/living/carbon/human/user as mob)
	if(medal_attached)
		unequip_medal(user)

/obj/item/clothing/under/attackby(obj/item/I, mob/user)
	if(!hastie && istype(I, /obj/item/clothing/tie))
		user.drop_item()
		hastie = I
		I.loc = src
		user << "<span class='notice'>You attach [I] to [src].</span>"

		if (istype(hastie,/obj/item/clothing/tie/holster))
			verbs += /obj/item/clothing/under/proc/holster

		if (istype(hastie,/obj/item/clothing/tie/storage))
			verbs += /obj/item/clothing/under/proc/storage

		if(istype(loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform()

		return
	else if(!medal_attached && istype(I, /obj/item/medal))
		user.transfer_equiped_item_to(I, src)
		medal_attached = I
		medal_overlay()
		if(istype(loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform()
	..()

/obj/item/clothing/under/proc/attachTie(obj/item/I, mob/user)
	if(istype(I, /obj/item/clothing/tie))
		if(hastie)
			if(user)
				user << "<span class='warning'>[src] already has an accessory.</span>"
			return
		else
			if(user)
				user.drop_item()
			hastie = I
			I.loc = src
			if(user)
				user << "<span class='notice'>You attach [I] to [src].</span>"
			I.transform *= 0.5	//halve the size so it doesn't overpower the under
			I.pixel_x += 8
			I.pixel_y -= 8
			I.layer = FLOAT_LAYER
			overlays += I


			if(istype(loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = loc
				H.update_inv_w_uniform()

			return

/obj/item/clothing/under/proc/unequip_medal(var/mob/living/carbon/human/user)
	if(!istype(user) || user.stat ||!medal_attached)
		return
	var/a_hand = user.get_active_hand()
	var/o_hand = user.get_other_hand()
	if(a_hand && o_hand)
		to_chat(user, "<span class='combat'>My hands are full!</span>")
	else if(a_hand)
		user.put_in_inactive_hand(medal_attached)
	else
		user.put_in_active_hand(medal_attached)

	overlays.Remove(medal_overlay)
	medal_attached = null
	user.update_inv_w_uniform()
	return

/obj/item/clothing/under/proc/medal_overlay()
	if(medal_attached)
		medal_overlay = image('icons/obj/clothing/amulets.dmi', src, "medal_overlay")
		overlays += medal_overlay
		return

/obj/item/clothing/under/examine()
	set src in view()
	..()
	switch(src.sensor_mode)
		if(0)
			usr << "Its sensors appear to be disabled."
		if(1)
			usr << "Its binary life sensors appear to be enabled."
		if(2)
			usr << "Its vital tracker appears to be enabled."
		if(3)
			usr << "Its vital tracker and tracking beacon appear to be enabled."
	if(hastie)
		usr << "\A [hastie] is clipped to it."

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	var/mob/M = usr
	if (istype(M, /mob/dead/)) return
	if (usr.stat) return
	if(src.has_sensor >= 2)
		usr << "The controls are locked."
		return 0
	if(src.has_sensor <= 0)
		usr << "This suit does not have any sensors."
		return 0
	src.sensor_mode += 1
	if(src.sensor_mode > 3)
		src.sensor_mode = 0
	switch(src.sensor_mode)
		if(0)
			usr << "You disable your suit's remote sensing equipment."
		if(1)
			usr << "Your suit will now report whether you are live or dead."
		if(2)
			usr << "Your suit will now report your vital lifesigns."
		if(3)
			usr << "Your suit will now report your vital lifesigns as well as your coordinate position."
	..()

/obj/item/clothing/under/verb/removetie()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if(hastie)
		if (istype(hastie,/obj/item/clothing/tie/holster))
			verbs -= /obj/item/clothing/under/proc/holster

		if (istype(hastie,/obj/item/clothing/tie/storage))
			verbs -= /obj/item/clothing/under/proc/storage
			var/obj/item/clothing/tie/storage/W = hastie
			if (W.hold)
				W.hold.close(usr)

		usr.put_in_hands(hastie)
		hastie = null

		if(istype(loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform()

/obj/item/clothing/under/rank/New()
	sensor_mode = pick(0,1,2,3)
	..()

/obj/item/clothing/under/proc/holster()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if (!hastie || !istype(hastie,/obj/item/clothing/tie/holster))
		usr << "\red You need a holster for that!"
		return
	var/obj/item/clothing/tie/holster/H = hastie

	if(!H.holstered)
		if(!istype(usr.get_active_hand(), /obj/item/weapon/gun))
			usr << "\blue You need your gun equiped to holster it."
			return
		var/obj/item/weapon/gun/W = usr.get_active_hand()
		if (!W.isHandgun())
			usr << "\red This gun won't fit in \the [H]!"
			return
		H.holstered = usr.get_active_hand()
		usr.drop_item()
		H.holstered.loc = src
		usr.visible_message("\blue \The [usr] holsters \the [H.holstered].", "You holster \the [H.holstered].")
	else
		if(istype(usr.get_active_hand(),/obj) && istype(usr.get_inactive_hand(),/obj))
			usr << "\red You need an empty hand to draw the gun!"
		else
			if(usr.a_intent == "hurt")
				usr.visible_message("\red \The [usr] draws \the [H.holstered], ready to shoot!", \
				"\red You draw \the [H.holstered], ready to shoot!")
			else
				usr.visible_message("\blue \The [usr] draws \the [H.holstered], pointing it at the ground.", \
				"\blue You draw \the [H.holstered], pointing it at the ground.")
			usr.put_in_hands(H.holstered)
			H.holstered = null

/obj/item/clothing/under/proc/storage()
	set name = "Look in storage"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if (!hastie || !istype(hastie,/obj/item/clothing/tie/storage))
		usr << "\red You need something to store items in for that!"
		return
	var/obj/item/clothing/tie/storage/W = hastie

	if (!istype(W.hold))
		return

	W.hold.loc = usr
	W.hold.attack_hand(usr)

/obj/item/proc/negates_gravity()
	return 0

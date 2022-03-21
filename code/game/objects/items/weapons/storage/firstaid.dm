/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 *		Dice Pack (in a pill bottle)
 */

/*
 * First Aid Kits
 */
/obj/item/weapon/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	item_state = "medpack"
	throw_speed = 2
	throw_range = 8
	var/empty = 0


/obj/item/weapon/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

/obj/item/weapon/storage/firstaid/fire/New()
	..()
	if(empty) return
	icon_state = pick("ointment","firefirstaid")
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/salicyclic(src)
	new /obj/item/weapon/reagent_containers/pill/salicyclic(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen(src)
	new /obj/item/device/healthanalyzer(src)
	return

/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"

	New()
		..()
		if (empty) return
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/device/healthanalyzer(src)
		new /obj/item/weapon/reagent_containers/hypospray/medipen( src )
		return

/obj/item/weapon/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amoutn of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

	New()
		..()
		if (empty) return

		icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		new /obj/item/device/healthanalyzer( src )
		return

/obj/item/weapon/storage/firstaid/o2
	name = "oxygen deprivation treatment kit"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

/obj/item/weapon/storage/firstaid/o2/New()
	..()
	if(empty) return
	new /obj/item/weapon/reagent_containers/pill/salbutamol(src)
	new /obj/item/weapon/reagent_containers/pill/salbutamol(src)
	new /obj/item/weapon/reagent_containers/pill/salbutamol(src)
	new /obj/item/weapon/reagent_containers/pill/salbutamol(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen(src)
	new /obj/item/device/healthanalyzer(src)
	return

/obj/item/weapon/storage/firstaid/adv
	name = "first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "firstaid"
	item_state = "medpack"

/obj/item/weapon/storage/firstaid/adv/New()
	..()
	//if (empty) return
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/weapon/surgery_tool/suture(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/morphine(src)
	return
/*
 * Pill Bottles
 */
/obj/item/weapon/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = 2.0
	can_hold = list("/obj/item/weapon/reagent_containers/pill","/obj/item/weapon/dice","/obj/item/weapon/paper")
	allow_quick_gather = 1
	use_to_pickup = 1
	storage_slots = 14

/obj/item/weapon/storage/pill_bottle/MouseDrop(obj/over_object as obj) //Quick pillbottle fix. -Agouri

	if (ishuman(usr) || ismonkey(usr)) //Can monkeys even place items in the pocket slots? Leaving this in just in case~
		var/mob/M = usr
		if (!( istype(over_object, /obj/screen) ))
			return ..()
		if ((!( M.restrained() ) && !( M.stat ) /*&& M.pocket == src*/))
			switch(over_object.name)
				if("r_hand")
					M.u_equip(src)
					M.put_in_r_hand(src)
				if("l_hand")
					M.u_equip(src)
					M.put_in_l_hand(src)
			src.add_fingerprint(usr)
			return
		if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
			if (usr.s_active)
				usr.s_active.close(usr)
			src.show_to(usr)
			return
	return

/obj/item/weapon/storage/box/silver_sulf
	name = "box of silver sulfadiazine patches"
	desc = "Contains patches used to treat burns."

/obj/item/weapon/storage/box/silver_sulf/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)

/obj/item/weapon/storage/pill_bottle/charcoal
	name = "bottle of charcoal pills"
	desc = "Contains pills used to counter toxins."

/obj/item/weapon/storage/pill_bottle/charcoal/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/charcoal(src)
	new /obj/item/weapon/reagent_containers/pill/charcoal(src)
	new /obj/item/weapon/reagent_containers/pill/charcoal(src)
	new /obj/item/weapon/reagent_containers/pill/charcoal(src)
	new /obj/item/weapon/reagent_containers/pill/charcoal(src)
	new /obj/item/weapon/reagent_containers/pill/charcoal(src)
	new /obj/item/weapon/reagent_containers/pill/charcoal(src)

/obj/item/weapon/storage/pill_bottle/epinephrine
	name = "bottle of epinephrine pills"
	desc = "Contains pills used to stabilize patients."

/obj/item/weapon/storage/pill_bottle/epinephrine/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/epinephrine(src)
	new /obj/item/weapon/reagent_containers/pill/epinephrine(src)
	new /obj/item/weapon/reagent_containers/pill/epinephrine(src)
	new /obj/item/weapon/reagent_containers/pill/epinephrine(src)
	new /obj/item/weapon/reagent_containers/pill/epinephrine(src)
	new /obj/item/weapon/reagent_containers/pill/epinephrine(src)
	new /obj/item/weapon/reagent_containers/pill/epinephrine(src)

/obj/item/weapon/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."

	New()
		..()
		new /obj/item/weapon/dice( src )
		new /obj/item/weapon/dice/d20( src )


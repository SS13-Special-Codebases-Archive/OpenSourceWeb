/obj/item/weapon/arrow

	name = "bolt"
	desc = "It's got a tip for you - get the point?"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "ironbolt"
	item_state = "flute"
	flags =  FPRINT | TABLEPASS
	throwforce = 8
	w_class = 2.0
	sharp = 1
	edge = 0

/obj/item/weapon/arrow/proc/removed() //Helper for metal rods falling apart.
	return

/obj/item/weapon/spike
	name = "alloy spike"
	desc = "It's about a foot of weird silver metal with a wicked point."
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 2
	icon = 'icons/obj/weapons.dmi'
	icon_state = "metal-rod"
	item_state = "bolt"

/obj/item/weapon/arrow/quill

	name = "vox quill"
	desc = "A wickedly barbed quill from some bizarre animal."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "quill"
	item_state = "quill"
	throwforce = 5

/obj/item/weapon/arrow/rod

	name = "metal rod"
	desc = "Don't cry for me, Orithena."
	icon_state = "metal-rod"

/obj/item/weapon/arrow/rod/removed(mob/user)
	if(throwforce == 15) // The rod has been superheated - we don't want it to be useable when removed from the bow.
		user  << "[src] shatters into a scattering of overstressed metal shards as it leaves the crossbow."
		var/obj/item/weapon/shard/shrapnel/S = new()
		S.loc = get_turf(src)
		src.Destroy()

/obj/item/weapon/crossbow

	name = "crossbow"
	desc = "A 2557AD twist on an old classic. Pick up that can."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "crossbow0"
	item_state = "crossbow"
	drop_sound = 'crossbow_sheath.ogg'
	drawsound = 'crossbow_unsheath.ogg'
	w_class = 5.0
	flags =  FPRINT | TABLEPASS | CONDUCT |  USEDELAY
	slot_flags = SLOT_BACK

	w_class = 3.0

	var/tension = 0                       // Current draw on the bow.
	var/max_tension = 5                   // Highest possible tension.
	var/release_speed = 5                 // Speed per unit of tension.
	var/mob/living/current_user = null    // Used to see if the person drawing the bow started drawing it.
	var/obj/item/weapon/arrow = null      // Nocked arrow.
	var/obj/item/weapon/cell/cell = null  // Used for firing special projectiles like rods.
	can_be_smelted_to = /obj/item/weapon/ore/refined/lw/ironlw

/obj/item/weapon/crossbow/attackby(obj/item/W as obj, mob/user as mob)
	if(!arrow)
		if (istype(W,/obj/item/weapon/arrow))
			user.drop_item()
			arrow = W
			arrow.loc = src
			user.visible_message("[user] slides [arrow] into [src].","You slide [arrow] into [src].")
			icon_state = "crossbow1"
			playsound(src.loc, 'bow_draw.ogg', 40, 0)
			return
	else
		..()

/obj/item/weapon/crossbow/attack_self(mob/living/user as mob)
	if(tension)
		if(arrow)
			user.visible_message("[user] relaxes the tension on [src]'s string and removes [arrow].","You relax the tension on [src]'s string and remove [arrow].")
			var/obj/item/weapon/arrow/A = arrow
			A.loc = get_turf(src)
			A.removed(user)
			arrow = null
		else
			user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		icon_state = "crossbow0"
	else
		draw(user)

/obj/item/weapon/crossbow/proc/draw(var/mob/user as mob)

	if(!arrow)
		user << "You don't have anything nocked to [src]."
		return

	if(user.restrained())
		return

	current_user = user

	user.visible_message("[user] begins to draw back the string of [src].","You begin to draw back the string of [src].")
	playsound(src.loc, 'bow_string.ogg', 40, 0)
	if(do_after(user, 40))
		tension = max_tension
		icon_state = "crossbow1"
	//spawn(12) increase_tension(user)

/obj/item/weapon/crossbow/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)

	if (istype(target, /obj/item/weapon/storage/backpack ))
		src.dropped()
		return

	else if (target.loc == user.loc)
		return

	else if (locate (/obj/structure/table, src.loc))
		return

	else if(target == user)
		return

	if(!tension)
		user << "You haven't drawn back the bolt!"
		return 0

	if (!arrow)
		user << "You have no arrow nocked to [src]!"
		return 0
	else
		spawn(0) Fire(target,user,params)

/obj/item/weapon/crossbow/proc/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)

	add_fingerprint(user)

	var/turf/curloc = get_turf(user)
	var/turf/targloc = get_turf(target)
	if (!istype(targloc) || !istype(curloc))
		return

	user.visible_message("<span class='danger'>[user] releases [src] and sends [arrow] streaking toward [target]!</span>","<span class='danger'>You release [src] and send [arrow] streaking toward [target]!</span>")
	playsound(src.loc, 'crossbow_fire.ogg', 40, 0)

	var/obj/item/weapon/arrow/A = arrow
	A.loc = get_turf(user)
	A.throw_at(target,10,tension*release_speed)
	arrow = null
	tension = 0
	icon_state = "crossbow0"

/*
/obj/item/weapon/crossbow/dropped(mob/user)
	if(arrow)
		var/obj/item/weapon/arrow/A = arrow
		A.loc = get_turf(src)
		A.removed(user)
		arrow = null
		tension = 0
		icon_state = "crossbow"
*/
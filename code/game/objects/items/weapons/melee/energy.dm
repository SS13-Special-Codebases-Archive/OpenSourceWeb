/obj/item/weapon/melee/energy
	var/active = 0
	flags = FPRINT | TABLEPASS | NOBLOODY

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>", \
							"\red <b>[user] is falling on the [src.name]! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	force = 40.0
	throwforce = 25.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = FPRINT | CONDUCT | NOSHIELD | TABLEPASS | NOBLOODY
	origin_tech = "combat=3"
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] swings the [src.name] towards /his head! It looks like \he's trying to commit suicide.</b>"
		return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/melee/energy/sword
	color
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD | NOBLOODY
	origin_tech = "magnets=3;syndicate=4"
	attack_verb = list("slices", "cuts", "slashes")
	swing_sound = 'sound/weapons/energyswing.ogg'
	hitsound = null
	parry_chance = 15
	//sharp = 1
	//edge = 1
	var/hacked = 0

/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"



/obj/item/weapon/melee/energy/sword/attackby(obj/item/weapon/W, mob/living/user)
	..()
/*	if(istype(W, /obj/item/weapon/melee/energy/sword))
		if(W == src)
			user << "<span class='notice'>You try to attach the end of the energy sword to... itself. You're not very smart, are you?</span>"
			if(ishuman(user))
				user.adjustBrainLoss(10)
		else
			user << "<span class='notice'>You attach the ends of the two energy swords, making a single double-bladed weapon! You're cool.</span>"
			var/obj/item/weapon/twohanded/dualsaber/newSaber = new /obj/item/weapon/twohanded/dualsaber(user.loc)
			if(src.hacked) // That's right, we'll only check the "original" esword.
				newSaber.hacked = 1
				newSaber.item_color = "rainbow"
			user.u_equip(W)
			user.u_equip(src)
			qdel(W)
			qdel(src)
			user.put_in_hands(newSaber)*/
	if(istype(W, /obj/item/device/multitool))
		if(hacked == 0)
			hacked = 1
			item_color = "rainbow"
			user << "<span class='warning'>RNBW_ENGAGE</span>"
			if(active)
				icon_state = "swordrainbow"
				// Updating overlays, copied from welder code.
				// I tried calling attack_self twice, which looked cool, except it somehow didn't update the overlays!!
				if(user.r_hand == src)
					user.update_inv_r_hand(0)
				else if(user.l_hand == src)
					user.update_inv_l_hand(0)

	else			user << "<span class='warning'>It's already fabulous!</span>"



/obj/item/weapon/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	force = 70.0//Normal attacks deal very high damage.
	throwforce = 1//Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
//	sharp = 1
	edge = 1
	w_class = 4.0//So you can't hide it in your pocket or some such.
	flags = FPRINT | TABLEPASS | NOSHIELD | NOBLOODY
	attack_verb = list("attacked", "slashed", "sliced", "torn", "ripped", "diced", "cut")
	var/datum/effect/effect/system/spark_spread/spark_system


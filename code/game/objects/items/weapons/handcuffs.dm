/obj/item/weapon/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	item_state = "handcuff"
	item_worth = 5
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	m_amt = 500
	origin_tech = "materials=1"
	var/dispenser = 0
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes
	pickupsound = 'sound/effects/chainpick.ogg'
	dropsound = 'sound/effects/chaindrop.ogg'

/obj/item/weapon/handcuffs/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(!istype(C))
		return

	if(istype(src, /obj/item/weapon/handcuffs/cyborg) && isrobot(user))
		if(!C.handcuffed)
			var/turf/p_loc = user.loc
			var/turf/p_loc_m = C.loc
			playsound(src.loc, 'sound/effects/chainpick.ogg', 50, 0, -2)
			for(var/mob/O in viewers(user, null))
				O.show_message("<span class='combatbold'>[user] is trying to put handcuffs on [C]!</span>", 1)
			spawn(20)
				if(!C)	return
				if(p_loc == user.loc && p_loc_m == C.loc)
					C.handcuffed = new /obj/item/weapon/handcuffs(C)
					C.update_inv_handcuffed()
	else
		if ((CLUMSY in usr.mutations) && prob(5))
			to_chat(usr, "<span class='combatbold'> Uh ... how do those things work?!</span>")
			if (istype(C, /mob/living/carbon/human))
				if(!C.handcuffed)
					var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
					O.source = user
					O.target = user
					O.item = user.get_active_hand()
					O.s_loc = user.loc
					O.t_loc = user.loc
					O.place = "handcuff"
					C.requests += O
					spawn( 0 )
						O.process()
				return
			return
		if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
			to_chat(usr, "<span class='combatbold'>[pick(nao_consigoen)] I don't have the dexterity to do this!</span>")
			return
		if (istype(C, /mob/living/carbon/human))
			if(!C.handcuffed)

				C.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been handcuffed (attempt) by [user.name] ([user.ckey])</font>")
				user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to handcuff [C.name] ([C.ckey])</font>")
				log_attack("[user.name] ([user.ckey]) Attempted to handcuff [C.name] ([C.ckey])")

				var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
				O.source = user
				O.target = C
				O.item = user.get_active_hand()
				O.s_loc = user.loc
				O.t_loc = C.loc
				O.place = "handcuff"
				C.requests += O
				spawn( 0 )
					if(istype(src, /obj/item/weapon/handcuffs/fiber))
						playsound(src.loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
					else
						playsound(src.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
					O.process()
			return
		else
			if(!C.handcuffed)
				var/obj/effect/equip_e/monkey/O = new /obj/effect/equip_e/monkey(  )
				O.source = user
				O.target = C
				O.item = user.get_active_hand()
				O.s_loc = user.loc
				O.t_loc = C.loc
				O.place = "handcuff"
				C.requests += O
				spawn( 0 )
					if(istype(src, /obj/item/weapon/handcuffs/fiber))
						playsound(src.loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
					else
						playsound(src.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
					O.process()
			return
	return

/obj/item/weapon/handcuffs/fiber
	name = "fibers"
	icon_state = "fibers"
	item_state = "rope"
	breakouttime = 450

/obj/item/weapon/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_white"
	breakouttime = 300 //Deciseconds = 30s

/obj/item/weapon/handcuffs/cable/red
	color = "#DD0000"

/obj/item/weapon/handcuffs/cable/yellow
	color = "#DDDD00"

/obj/item/weapon/handcuffs/cable/blue
	color = "#0000DD"

/obj/item/weapon/handcuffs/cable/green
	color = "#00DD00"

/obj/item/weapon/handcuffs/cable/pink
	color = "#DD00DD"

/obj/item/weapon/handcuffs/cable/orange
	color = "#DD8800"

/obj/item/weapon/handcuffs/cable/cyan
	color = "#00DDDD"

/obj/item/weapon/handcuffs/cable/white
	color = "#FFFFFF"

/obj/item/weapon/handcuffs/cyborg
	dispenser = 1
//////////////////////////////////////
// SUIT STORAGE UNIT /////////////////
//////////////////////////////////////


/obj/machinery/suit_storage_unit
	name = "Suit Storage Unit"
	desc = "An industrial U-Stor-It Storage unit designed to accomodate all kinds of space suits. \
	Its on-board equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. \
	There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "SSU"
	anchored = 1
	density = 1
	var/mob/living/carbon/human/OCCUPANT = null
	var/obj/item/clothing/suit/space/SUIT = null
	var/SUIT_TYPE = null
	var/obj/item/clothing/head/helmet/space/HELMET = null
	var/HELMET_TYPE = null
	var/obj/item/clothing/mask/MASK = null  //All the stuff that's gonna be stored insiiiiiiiiiiiiiiiiiiide, nyoro~n
	var/MASK_TYPE = null
	var/obj/item/STORAGE = null  //One-slot storage slot for anything... food not recommended
	var/STORAGE_TYPE = null
	//Erro's idea on standarising SSUs whle keeping creation of other SSU types easy:
	//Make a child SSU, name it something then set the TYPE vars to your desired suit output. New() should take it from there by itself.

	var/isopen = 0
	var/islocked = 0
	var/isUV = 0
	var/ispowered = 1 //starts powered
	var/isbroken = 0
	var/issuperUV = 0
	var/panelopen = 0
	var/safetieson = 1
	var/cycletime_left = 0


/obj/machinery/suit_storage_unit/proc/open_closet()
	flick("ssuitopening", src)
	isopen = 1
	spawn(21)
		src.dispense_helmet(usr)
		src.dispense_suit(usr)
		src.dispense_mask(usr)
		src.eject_storage(usr)
		icon_state = "ssuitopen"

//The units themselves/////////////////

/obj/machinery/suit_storage_unit/standard_unit
	SUIT_TYPE = /obj/item/clothing/suit/space
	HELMET_TYPE = /obj/item/clothing/head/helmet/space
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/engineering_unit
	SUIT_TYPE = /obj/item/clothing/suit/space
	HELMET_TYPE = /obj/item/clothing/head/helmet/space
	MASK_TYPE = /obj/item/clothing/mask/breath
	STORAGE_TYPE = /obj/item/clothing/shoes/magboots

/obj/machinery/suit_storage_unit/ce_unit
	SUIT_TYPE = /obj/item/clothing/suit/space/rig/elite
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/rig/elite
	MASK_TYPE = /obj/item/clothing/mask/breath
	STORAGE_TYPE = /obj/item/clothing/shoes/magboots

/obj/machinery/suit_storage_unit/mining_unit
	SUIT_TYPE = /obj/item/clothing/suit/space
	HELMET_TYPE = /obj/item/clothing/head/helmet/space
	MASK_TYPE = /obj/item/clothing/mask/breath
	STORAGE_TYPE = /obj/item/clothing/shoes/magboots

/obj/machinery/suit_storage_unit/syndicate_unit
	SUIT_TYPE = /obj/item/clothing/head/helmet/space/rig/syndi
	HELMET_TYPE = /obj/item/clothing/suit/space/rig/syndi
	MASK_TYPE = /obj/item/clothing/mask/gas/syndicate
	STORAGE_TYPE = /obj/item/clothing/shoes/magboots

/obj/machinery/suit_storage_unit/soulbreaker_unit
	SUIT_TYPE = /obj/item/clothing/suit/armor/vest/security/soulbreaker
	HELMET_TYPE = /obj/item/clothing/head/helmet/soulbreaker
	STORAGE_TYPE = /obj/item/clothing/gloves/combat/soulbreaker
	MASK_TYPE = /obj/item/clothing/shoes/lw/soulbreaker

/obj/machinery/suit_storage_unit/space_unit
	SUIT_TYPE = /obj/item/clothing/suit/space
	HELMET_TYPE = /obj/item/clothing/head/helmet/space

/obj/machinery/suit_storage_unit/tribunal_unit
	icon = 'icons/obj/suitstorage_trib.dmi'
	SUIT_TYPE = /obj/item/clothing/suit/storage/vest/flakjacket
	HELMET_TYPE = /obj/item/clothing/head/helmet/lw/ordinator
	MASK_TYPE = /obj/item/clothing/mask/breath
	STORAGE_TYPE = /obj/item/weapon/tank/emergency_oxygen

/obj/machinery/suit_storage_unit/medical_unit
	SUIT_TYPE = /obj/item/clothing/suit/space/rig/medical
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/rig/medical
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/atmos_unit
	SUIT_TYPE = /obj/item/clothing/suit/space/rig/atmos
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/rig/atmos
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/cap_unit
	SUIT_TYPE = /obj/item/clothing/suit/armor/captain
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/capspace
	MASK_TYPE = /obj/item/clothing/mask/gas
	STORAGE_TYPE = /obj/item/weapon/tank/jetpack/oxygen

/obj/machinery/suit_storage_unit/security_unit
	SUIT_TYPE = /obj/item/clothing/suit/space/rig/security
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/rig/security
	MASK_TYPE = /obj/item/clothing/mask/breath
	STORAGE_TYPE = /obj/item/clothing/shoes/magboots

/obj/machinery/suit_storage_unit/New()
	src.update_icon()
	if(SUIT_TYPE)
		SUIT = new SUIT_TYPE(src)
	if(HELMET_TYPE)
		HELMET = new HELMET_TYPE(src)
	if(MASK_TYPE)
		MASK = new MASK_TYPE(src)
	if(STORAGE_TYPE)
		STORAGE = new STORAGE_TYPE(src)

/obj/machinery/suit_storage_unit/update_icon() //overlays yaaaay - Jordie
	overlays = list()
	if(!isopen)
		overlays += "close"
	if(isUV)
		overlays += "uv"
	if(issuperUV && isUV)
		overlays += "super"
	if(isopen)
		overlays += "open"
		if(SUIT)
			overlays += "suit"
		if(HELMET)
			overlays += "helm"
		if(STORAGE)
			overlays += "storage"
		if(isbroken)
			overlays += "broken"
	return


/obj/machinery/suit_storage_unit/power_change()
	if( powered() )
		src.ispowered = 1
		stat &= ~NOPOWER
		src.update_icon()
	else
		spawn(rand(0, 15))
			src.ispowered = 0
			stat |= NOPOWER
			src.islocked = 0
			src.isopen = 1
			src.dump_everything()
			src.update_icon()


/obj/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(50))
				src.dump_everything() //So suits dont survive all the time
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				src.dump_everything()
				qdel(src)
			return
		else
			return
	return


/obj/machinery/suit_storage_unit/attack_hand(mob/user as mob)
	if(isopen) return
	open_closet(user)

/obj/machinery/suit_storage_unit/Topic(href, href_list) //I fucking HATE this proc
	if(..())
		return
	if(usr == src.OCCUPANT) //No unlocking yourself out!
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))
		usr.set_machine(src)
		if (href_list["toggleUV"])
			src.toggleUV(usr)
		if (href_list["togglesafeties"])
			src.togglesafeties(usr)
		if (href_list["dispense_helmet"])
			src.dispense_helmet(usr)
		if (href_list["dispense_suit"])
			src.dispense_suit(usr)
		if (href_list["dispense_mask"])
			src.dispense_mask(usr)
		if (href_list["eject_storage"])
			src.eject_storage(usr)
		if (href_list["toggle_open"])
			src.toggle_open(usr)
		if (href_list["toggle_lock"])
			src.toggle_lock(usr)
		if (href_list["start_UV"])
			src.start_UV(usr)
		if (href_list["eject_guy"])
			src.eject_occupant(usr)
		src.updateUsrDialog()
		src.update_icon()
	/*if (href_list["refresh"])
		src.updateUsrDialog()*/
	src.add_fingerprint(usr)
	return


/obj/machinery/suit_storage_unit/proc/toggleUV(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!src.panelopen)
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow))
				protected = 1

	if(!protected)
		playsound(src.loc, "sparks", 75, 1, -1)
		user << "<font color='red'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</font>"
		return*/
	else  //welp, the guy is protected, we can continue
		if(src.issuperUV)
			user << "You slide the dial back towards \"185nm\"."
			src.issuperUV = 0
		else
			user << "You crank the dial all the way up to \"15nm\"."
			src.issuperUV = 1
		return


/obj/machinery/suit_storage_unit/proc/togglesafeties(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!src.panelopen) //Needed check due to bugs
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow) )
				protected = 1

	if(!protected)
		playsound(src.loc, "sparks", 75, 1, -1)
		user << "<font color='red'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</font>"
		return*/
	else
		user << "You push the button. The coloured LED next to it changes."
		src.safetieson = !src.safetieson


/obj/machinery/suit_storage_unit/proc/dispense_helmet(mob/user as mob)
	if(!src.HELMET)
		return //Do I even need this sanity check? Nyoro~n
	else
		src.HELMET.loc = src.loc
		src.HELMET = null
		return


/obj/machinery/suit_storage_unit/proc/dispense_suit(mob/user as mob)
	if(!src.SUIT)
		return
	else
		src.SUIT.loc = src.loc
		src.SUIT = null
		return


/obj/machinery/suit_storage_unit/proc/dispense_mask(mob/user as mob)
	if(!src.MASK)
		return
	else
		src.MASK.loc = src.loc
		src.MASK = null
		return


/obj/machinery/suit_storage_unit/proc/eject_storage()
	eject(STORAGE)
	STORAGE = null

/obj/machinery/suit_storage_unit/proc/eject(atom/movable/ITEM)
	ITEM.loc = src.loc

/obj/machinery/suit_storage_unit/proc/dump_everything()
	for(var/obj/item/ITEM in src)
		eject(ITEM)
	SUIT = null
	HELMET = null
	MASK = null
	STORAGE = null
	if(OCCUPANT)
		eject_occupant(OCCUPANT)
	return

/obj/machinery/suit_storage_unit/proc/toggle_open(mob/user as mob)
	if(islocked || isUV)
		user << "<font color='red'>Unable to open unit.</font>"
		return
	if(OCCUPANT)
		eject_occupant(user)
		return  // eject_occupant opens the door, so we need to return
	src.isopen = !src.isopen
	return


/obj/machinery/suit_storage_unit/proc/toggle_lock(mob/user as mob)
	if(OCCUPANT && safetieson)
		user << "<font color='red'>The Unit's safety protocols disallow locking when a biological form is detected inside its compartments.</font>"
		return
	if(isopen)
		return
	src.islocked = !src.islocked
	return


/obj/machinery/suit_storage_unit/proc/start_UV(mob/user as mob)
	if(isUV || isopen) //I'm bored of all these sanity checks
		return
	if(OCCUPANT && safetieson)
		user << "<font color='red'><B>WARNING:</B> Biological entity detected in the confines of the Unit's storage. Cannot initiate cycle.</font>"
		return
	if(!src.HELMET && !src.MASK && !src.SUIT && !src.STORAGE && !src.OCCUPANT ) //shit's empty yo
		user << "<font color='red'>Unit storage bays empty. Nothing to disinfect -- Aborting.</font>"
		return
	user << "You start the Unit's cauterisation cycle."
	src.cycletime_left = 20
	src.isUV = 1
	if(src.OCCUPANT && !src.islocked)
		src.islocked = 1 //Let's lock it for good measure
	src.update_icon()
	src.updateUsrDialog()

	var/i //our counter
	spawn(0)
		for(i=0,i<4,++i)
			sleep(50)
			if(src.OCCUPANT)
				var/burndamage = rand(6,10)
				if(src.issuperUV)
					burndamage = rand(28,35)
				if(iscarbon(OCCUPANT))
					OCCUPANT.take_organ_damage(0,burndamage)
					OCCUPANT.emote("scream")
				else
					OCCUPANT.take_organ_damage(burndamage)
			if(i==3) //End of the cycle
				if(!src.issuperUV)
					for(var/obj/item/ITEM in src)
						ITEM.clean_blood()
					if(istype(STORAGE, /obj/item/weapon/reagent_containers/food))
						qdel(STORAGE)
				else //It was supercycling, destroy everything
					src.HELMET = null
					src.SUIT = null
					src.MASK = null
					qdel(STORAGE)
					visible_message("<font color='red'>With a loud whining noise, the Suit Storage Unit's door grinds open. Puffs of ashen smoke come out of its chamber.</font>", 3)
					src.isbroken = 1
					src.isopen = 1
					src.islocked = 0
					src.eject_occupant(OCCUPANT) //Mixing up these two lines causes bug. DO NOT DO IT.
				src.isUV = 0 //Cycle ends
		src.update_icon()
		src.updateUsrDialog()
		return


/obj/machinery/suit_storage_unit/proc/cycletimeleft()
	if(src.cycletime_left >= 1)
		src.cycletime_left--
	return src.cycletime_left


/obj/machinery/suit_storage_unit/proc/eject_occupant(mob/user as mob)
	if(islocked)
		return

	if(!OCCUPANT)
		return

	if(OCCUPANT.client)
		if(user != OCCUPANT)
			OCCUPANT << "<font color='blue'>The machine kicks you out!</font>"
		if(user.loc != src.loc)
			OCCUPANT << "<font color='blue'>You leave the not-so-cozy confines of the SSU.</font>"

		OCCUPANT.client.eye = src.OCCUPANT.client.mob
		OCCUPANT.client.perspective = MOB_PERSPECTIVE
	OCCUPANT.loc = src.loc
	OCCUPANT = null
	if(!isopen)
		isopen = 1
	update_icon()
	return


/obj/machinery/suit_storage_unit/verb/get_out()
	set name = "Eject Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.eject_occupant(usr)
	add_fingerprint(usr)
	src.updateUsrDialog()
	src.update_icon()
	return


/obj/machinery/suit_storage_unit/verb/move_inside()
	set name = "Hide in Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	if (!isopen)
		usr << "<font color='red'>The unit's doors are shut.</font>"
		return
	if (!ispowered || isbroken)
		usr << "<font color='red'>The unit is not operational.</font>"
		return
	if (OCCUPANT || HELMET || SUIT)
		usr << "<font color='red'>It's too cluttered inside for you to fit in!</font>"
		return
	visible_message("[usr] starts squeezing into the suit storage unit!", 3)
	if(do_after(usr, 10))
		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.loc = src
//		usr.metabslow = 1
		src.OCCUPANT = usr
		src.isopen = 0 //Close the thing after the guy gets inside
		src.update_icon()

//		for(var/obj/O in src)
//			qdel(O)

		src.add_fingerprint(usr)
		src.updateUsrDialog()
		return
	else
		src.OCCUPANT = null //Testing this as a backup sanity test
	return


/obj/machinery/suit_storage_unit/attackby(obj/item/I as obj, mob/user as mob)
	if(!src.ispowered)
		return
	if(istype(I, /obj/item/weapon/screwdriver))
		src.panelopen = !src.panelopen
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		user << text("<font color='blue'>You [] the unit's maintenance panel.</font>",(src.panelopen ? "open up" : "close") )
		src.updateUsrDialog()
		return
	if ( istype(I, /obj/item/weapon/grab) )
		var/obj/item/weapon/grab/G = I
		if( !(ismob(G.affecting)) )
			return
		if (!src.isopen)
			usr << "<font color='red'>The unit's doors are shut.</font>"
			return
		if (!src.ispowered || src.isbroken)
			usr << "<font color='red'>The unit is not operational.</font>"
			return
		if (OCCUPANT || HELMET || SUIT) //Unit needs to be absolutely empty
			user << "<font color='red'>The unit's storage area is too cluttered.</font>"
			return
		visible_message("[user] starts putting [G.affecting.name] into the Suit Storage Unit.", 3)
		if(do_after(user, 20))
			if(!G || !G.affecting) return //derpcheck
			var/mob/M = G.affecting
			if (M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
			src.OCCUPANT = M
			src.isopen = 0 //close ittt

			//for(var/obj/O in src)
			//	O.loc = src.loc
			src.add_fingerprint(user)
			qdel(G)
			src.updateUsrDialog()
			src.update_icon()
			return
		return
	if(isopen && !isbroken)
		if( istype(I,/obj/item/clothing/suit/space) )
			var/obj/item/clothing/suit/space/S = I
			if(SUIT)
				user << "<font color='blue'>The unit already contains a suit.</font>"
				return
			user << "You load the [S.name] into the storage compartment."
			user.drop_item()
			S.loc = src
			SUIT = S
			update_icon()
			updateUsrDialog()
			return
		if( istype(I,/obj/item/clothing/head/helmet) )
			var/obj/item/clothing/head/helmet/H = I
			if(HELMET)
				user << "<font color='blue'>The unit already contains a helmet.</font>"
				return
			user << "You load the [H.name] into the storage compartment."
			user.drop_item()
			H.loc = src
			HELMET = H
			update_icon()
			updateUsrDialog()
			return
		if( istype(I,/obj/item/clothing/mask) )
			var/obj/item/clothing/mask/M = I
			if(MASK)
				user << "<font color='blue'>The unit already contains a mask.</font>"
				return
			user << "You load the [M.name] into the storage compartment."
			user.drop_item()
			M.loc = src
			MASK = M
			update_icon()
			updateUsrDialog()
			return
		if( istype(I,/obj/item) )
			var/obj/item/ITEM = I
			if(STORAGE)
				user << "<font color='blue'>The auxiliary storage compartment is full.</font>"
				return
			if(!user.drop_item())
				user << "<span class='notice'>\The [ITEM] is stuck to your hand, you cannot put it in the Suit Storage Unit!</span>"
				return
			user << "You load the [ITEM.name] into the auxiliary storage compartment."
			ITEM.loc = src
			STORAGE = ITEM
	src.update_icon()
	src.updateUsrDialog()
	return


/obj/machinery/suit_storage_unit/attack_ai(mob/user as mob)
	return src.attack_hand(user)


/obj/machinery/suit_storage_unit/attack_paw(mob/user as mob)
	user << "<font color='blue'>The console controls are far too complicated for your tiny brain!</font>"
	return


//////////////////////////////REMINDER: Make it lock once you place some fucker inside.
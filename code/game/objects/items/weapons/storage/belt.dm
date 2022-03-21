/obj/item/weapon/storage/belt
	name = "leather belt"
	desc = "A leather belt with extra wide pouches that can hold a variety of items."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "leatherbelt"
	item_state = "leather"
	storage_slots = 7
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined")

/obj/item/weapon/storage/belt/proc/can_use()
	if(!ismob(loc)) return 0
	var/mob/M = loc
	if(src in M.get_equipped_items())
		return 1
	else
		return 0


/obj/item/weapon/storage/belt/MouseDrop(obj/over_object as obj, src_location, over_location)
	var/mob/M = usr
	if(!istype(over_object, /obj/screen))
		return ..()
	playsound(src.loc, "rustle", 50, 1, -5)
	if (!M.restrained() && !M.stat && can_use())
		switch(over_object.name)
			if("r_hand")
				M.u_equip(src)
				M.put_in_r_hand(src)
			if("l_hand")
				M.u_equip(src)
				M.put_in_l_hand(src)
		src.add_fingerprint(usr)
		return



/obj/item/weapon/storage/belt/utility
	name = "tool-belt" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "Can hold various tools."
	icon_state = "utilitybelt"
	item_state = "utility"
	can_hold = list(
		"/obj/item/weapon/crowbar",
		"/obj/item/weapon/screwdriver",
		"/obj/item/weapon/weldingtool",
		"/obj/item/weapon/wirecutters",
		"/obj/item/weapon/wrench",
		"/obj/item/device/multitool",
		"/obj/item/device/flashlight",
		"/obj/item/stack/cable_coil",
		"/obj/item/device/t_scanner",
		"/obj/item/device/analyzer",
		"/obj/item/taperoll/engineering")


/obj/item/weapon/storage/belt/utility/full/New()
	..()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))


/obj/item/weapon/storage/belt/utility/atmostech/New()
	..()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/device/t_scanner(src)



/obj/item/weapon/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medicalbelt"
	item_state = "medical"
	can_hold = list(
		"/obj/item/device/healthanalyzer",
		"/obj/item/weapon/dnainjector",
		"/obj/item/weapon/reagent_containers/dropper",
		"/obj/item/weapon/reagent_containers/glass/beaker",
		"/obj/item/weapon/reagent_containers/glass/bottle",
		"/obj/item/weapon/reagent_containers/pill",
		"/obj/item/weapon/reagent_containers/syringe",
		"/obj/item/weapon/reagent_containers/glass/dispenser",
		"/obj/item/weapon/flame/lighter/zippo",
		"/obj/item/weapon/storage/fancy/cigarettes",
		"/obj/item/weapon/storage/pill_bottle",
		"/obj/item/stack/medical",
		"/obj/item/device/flashlight/pen",
		"/obj/item/clothing/mask/surgical",
		"/obj/item/clothing/gloves/latex",
	        "/obj/item/weapon/reagent_containers/hypospray"
	)


/obj/item/weapon/storage/belt/security
	name = "security belt"
	desc = "Can hold security gear like handcuffs and flashes."
	icon_state = "securitybelt"
	item_state = "security"//Could likely use a better one.
	storage_slots = 7
	max_w_class = 3
	max_combined_w_class = 21
	can_hold = list(
		"/obj/item/weapon/grenade/flashbang",
		"/obj/item/weapon/reagent_containers/spray/pepper",
		"/obj/item/weapon/handcuffs",
		"/obj/item/device/flash",
		"/obj/item/clothing/glasses",
		"/obj/item/ammo_casing/shotgun",
		"/obj/item/ammo_magazine",
		"/obj/item/weapon/reagent_containers/food/snacks/donut/normal",
		"/obj/item/weapon/reagent_containers/food/snacks/donut/jelly",
		"/obj/item/weapon/melee/baton",
		"/obj/item/weapon/flame/lighter/zippo",
		"/obj/item/weapon/cigpacket",
		"/obj/item/clothing/glasses/hud/security",
		"/obj/item/device/flashlight",
		"/obj/item/device/pda",
		"/obj/item/device/radio/headset",
		"/obj/item/weapon/melee",
		"/obj/item/taperoll/police",
		"/obj/item/weapon/gun/energy/taser",
		"/obj/item/weapon/cell/crap",
		"/obj/item/weapon/gun/energy/gun",
		"/obj/item/weapon/gun/energy/taser",
		"/obj/item/weapon/gun/energy/laser",
		"/obj/item/weapon/gun/energy/stunrevolver",
		"/obj/item/weapon/gun/energy/ionrifle"
		)


/obj/item/weapon/storage/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "championbelt"
	item_state = "champion"
	storage_slots = 1
	can_hold = list(
		"/obj/item/clothing/mask/luchador"
		)

/obj/item/weapon/storage/belt/inflatable
	name = "inflatable duck"
	desc = "No bother to sink or swim when you can just float!"
	icon_state = "inflatable"
	item_state = "inflatable"

/obj/item/weapon/storage/belt/security/tactical
	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "swatbelt"
	item_state = "swatbelt"
	var/obj/item/weapon/gun/holstered = null
	storage_slots = 9
	max_w_class = 3
	max_combined_w_class = 21
	can_hold = list(
		"/obj/item/weapon/grenade/flashbang",
		"/obj/item/weapon/reagent_containers/spray/pepper",
		"/obj/item/weapon/handcuffs",
		"/obj/item/device/flash",
		"/obj/item/clothing/glasses",
		"/obj/item/ammo_casing/shotgun",
		"/obj/item/ammo_magazine",
		"/obj/item/weapon/reagent_containers/food/snacks/donut/normal",
		"/obj/item/weapon/reagent_containers/food/snacks/donut/jelly",
		"/obj/item/weapon/melee/baton",
		"/obj/item/weapon/gun/energy/taser",
		"/obj/item/weapon/flame/lighter/zippo",
		"/obj/item/weapon/cigpacket",
		"/obj/item/clothing/glasses/hud/security",
		"/obj/item/device/flashlight",
		"/obj/item/device/pda",
		"/obj/item/device/radio/headset",
		"/obj/item/weapon/melee",
		"/obj/item/taperoll/police",
		"/obj/item/weapon/gun/energy/taser"
		)


/obj/item/weapon/storage/belt/security/tactical/verb/holster()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if(!holstered)
		if(!istype(usr.get_active_hand(), /obj/item/weapon/gun))
			usr << "\blue You need your gun equiped to holster it."
			return
		var/obj/item/weapon/gun/W = usr.get_active_hand()
		if (!W.isHandgun())
			usr << "\red This gun won't fit in \the belt!"
			return
		holstered = usr.get_active_hand()
		usr.drop_item()
		holstered.loc = src
		usr.visible_message("\blue \The [usr] holsters \the [holstered].", "You holster \the [holstered].")
	else
		if(istype(usr.get_active_hand(),/obj) && istype(usr.get_inactive_hand(),/obj))
			usr << "\red You need an empty hand to draw the gun!"
		else
			if(usr.a_intent == "hurt")
				usr.visible_message("\red \The [usr] draws \the [holstered], ready to shoot!", \
				"\red You draw \the [holstered], ready to shoot!")
			else
				usr.visible_message("\blue \The [usr] draws \the [holstered], pointing it at the ground.", \
				"\blue You draw \the [holstered], pointing it at the ground.")
			usr.put_in_hands(holstered)
		holstered = null

/obj/item/weapon/storage/belt/military
	name = "military belt"
	desc = "A syndicate combat belt designed to hold a large variety of weapons and gadgets. Property of the Gorlex Marauders."
	icon_state = "militarybelt"
	item_state = "military"
	storage_slots = 7

/obj/item/weapon/storage/belt/military/snake
	name = "sneak belt"
	desc = "An old combat belt designed to hold a large variety of weapons and gadgets."
	icon_state = "securitybelt"
	item_state = "security"
	storage_slots = 7
	max_w_class = 5.0

/obj/item/weapon/storage/belt/janitor
	name = "janibelt"
	desc = "A purple leather belt designed to hold most janitorial supplies."
	icon_state = "janibelt"
	item_state = "janibelt"
	storage_slots = 6
	max_w_class = 4 // Set to this so the  light replacer can fit.
	can_hold = list(
		"/obj/item/weapon/grenade/chem_grenade/cleaner",
		"/obj/item/device/lightreplacer",
		"/obj/item/device/flashlight",
		"/obj/item/weapon/reagent_containers/spray",
		"/obj/item/weapon/soap",
		"/obj/item/weapon/holosign_creator"
		)
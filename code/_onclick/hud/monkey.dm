/datum/hud/proc/monkey_hud(var/ui_style='icons/mob/screen1_old.dmi')

	src.adding = list()
	src.other = list()

	var/obj/screen/using
	var/obj/screen/inventory/inv_box
	var/icon/blocked = icon('icons/mob/screen1.dmi',"blocked")

//Intents Panel Beginning

	using = new /obj/screen()
	using.name = "help"
	using.icon_state = "help_m"
	using.screen_loc = ui_iarrowleft
	using.layer = 21
	adding += using

	using = new /obj/screen()
	using.name = "grab"
	using.icon_state = "grab_m"
	using.screen_loc = ui_iarrowleft
	using.layer = 21
	adding += using


	using = new /obj/screen()
	using.name = "disarm"
	using.icon_state = "disarm_m"
	using.screen_loc = ui_iarrowright
	using.layer = 21
	adding += using

	using = new /obj/screen()
	using.name = "harm"
	using.icon_state = "harm_m"
	using.screen_loc = ui_iarrowright
	using.layer = 21
	adding += using

//Intents Panel End

	using = new /obj/screen() //Right hud bar
	using.dir = SOUTH
	using.screen_loc = "EAST+1,SOUTH to EAST+1,NORTH"
	using.layer = 18
	adding += using

	using = new /obj/screen() //Lower hud bar
	using.dir = EAST
	using.screen_loc = "WEST,SOUTH-1 to EAST,SOUTH-1"
	using.layer = 18
	adding += using

	using = new /obj/screen() //Corner Button
	using.dir = NORTHWEST
	using.screen_loc = "EAST+1,SOUTH-1"
	using.layer = 18
	adding += using

	using = new /obj/screen()
	using.name = "act_intent"
	using.dir = SOUTHWEST
	using.icon_state = mymob.a_intent
	using.screen_loc = ui_acti
	using.layer = 20
	adding += using
	src.action_intent = using

	using = new /obj/screen()
	using.name = "mov_intent"
	using.dir = SOUTHWEST
	using.icon = ui_style
	using.icon_state = (mymob.m_intent == "run" ? "running" : "walking")
	using.screen_loc = ui_movi
	using.layer = 20
	src.adding += using
	move_intent = using

	using = new /obj/screen()
	using.name = "resist"
	using.icon = ui_style
	using.icon_state = "act_resist"
	using.screen_loc = ui_resist
	using.layer = 19
	src.adding += using
	src.hotkeybuttons += using

	using = new /obj/screen()
	using.name = "drop"
	using.icon = ui_style
	using.icon_state = "act_drop"
	using.screen_loc = ui_dropbutton
	using.layer = 19
	src.adding += using

	inv_box = new /obj/screen/inventory()
	inv_box.name = "r_hand"
	inv_box.dir = WEST
	inv_box.icon = ui_style
	inv_box.icon_state = "hand_inactive"
	if(mymob && !mymob.hand)	//This being 0 or null means the right hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = ui_rhand
	inv_box.slot_id = slot_r_hand
	inv_box.layer = 19
	src.r_hand_hud_object = inv_box
	src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "l_hand"
	inv_box.dir = EAST
	inv_box.icon = ui_style
	inv_box.icon_state = "hand_inactive"
	if(mymob && mymob.hand)	//This being 1 means the left hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = ui_lhand
	inv_box.slot_id = slot_l_hand
	inv_box.layer = 19
	src.l_hand_hud_object = inv_box
	src.adding += inv_box

	using = new /obj/screen/inventory()
	using.name = "hand"
	using.dir = NORTH
	using.icon = ui_style
	using.icon_state = "hand"
	using.screen_loc = ui_swaphand
	using.layer = 19
	src.swaphands_hud_object = using
	src.adding += using

//Blocked Inventory Beginning

	using = new /obj/screen()
	using.name = "i_clothing"
	using.dir = SOUTH
	using.icon = ui_style
	using.icon_state = "center"
	using.screen_loc = ui_iclothing
	using.layer = 19
	using.overlays += blocked
	src.adding += using

	using = new /obj/screen()
	using.name = "o_clothing"
	using.dir = SOUTH
	using.icon = ui_style
	using.icon_state = "equip"
	using.screen_loc = ui_oclothing
	using.layer = 19
	using.overlays += blocked
	src.adding += using

	using = new /obj/screen()
	using.name = "id"
	using.icon = ui_style
	using.dir = SOUTHWEST
	using.icon_state = "equip"
	using.screen_loc = ui_id
	using.layer = 19
	using.overlays += blocked
	adding += using

	using = new /obj/screen()
	using.name = "storage1"
	using.icon = ui_style
	using.icon_state = "pocket"
	using.screen_loc = ui_storage1
	using.layer = 19
	using.overlays += blocked
	adding += using

	using = new /obj/screen()
	using.name = "storage2"
	using.icon = ui_style
	using.icon_state = "pocket"
	using.screen_loc = ui_storage2
	using.layer = 19
	using.overlays += blocked
	adding += using

	using = new /obj/screen()
	using.name = "other"
	using.icon = ui_style
	using.icon_state = "other"
	using.screen_loc = ui_shoes
	using.layer = 20
	adding += using

	using = new /obj/screen()
	using.name = "gloves"
	using.icon = ui_style
	using.icon_state = "gloves"
	using.screen_loc = ui_gloves
	using.layer = 19
	using.overlays += blocked
	other += using

	using = new /obj/screen()
	using.name = "eyes"
	using.icon = ui_style
	using.icon_state = "glasses"
	using.screen_loc = ui_glasses
	using.layer = 19
	using.overlays += blocked
	other += using

	using = new /obj/screen()
	using.name = "l_ear"
	using.icon = ui_style
	using.icon_state = "ears"
	using.screen_loc = ui_l_ear
	using.layer = 19
	using.overlays += blocked
	other += using

	using = new /obj/screen()
	using.name = "head"
	using.icon = ui_style
	using.icon_state = "hair"
	using.screen_loc = ui_head
	using.layer = 19
	using.overlays += blocked
	adding += using

	using = new /obj/screen()
	using.name = "shoes"
	using.icon = ui_style
	using.icon_state = "shoes"
	using.screen_loc = ui_shoes
	using.layer = 19
	using.overlays += blocked
	other += using

	using = new /obj/screen()
	using.name = "belt"
	using.icon = ui_style
	using.icon_state = "belt"
	using.screen_loc = ui_belt
	using.layer = 19
	using.overlays += blocked
	adding += using

//Blocked Inventory End

	inv_box = new /obj/screen/inventory()
	inv_box.name = "mask"
	inv_box.dir = NORTH
	inv_box.icon = ui_style
	inv_box.icon_state = "equip"
	inv_box.screen_loc = ui_mask
	inv_box.slot_id = slot_wear_mask
	inv_box.layer = 19
	src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "back"
	inv_box.dir = NORTHEAST
	inv_box.icon = ui_style
	inv_box.icon_state = "equip"
	inv_box.screen_loc = ui_back
	inv_box.slot_id = slot_back
	inv_box.layer = 19
	src.adding += inv_box

	mymob.throw_icon = new /obj/screen()
	mymob.throw_icon.icon = ui_style
	mymob.throw_icon.icon_state = "act_throw_off"
	mymob.throw_icon.name = "throw"
	mymob.throw_icon.screen_loc = ui_drop_throw

	mymob.oxygen = new /obj/screen()
	mymob.oxygen.icon = ui_style
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = ui_oxygen

	mymob.pressure = new /obj/screen()
	mymob.pressure.icon = ui_style
	mymob.pressure.icon_state = "pressure0"
	mymob.pressure.name = "pressure"
	mymob.pressure.screen_loc = ui_pressure

	mymob.toxin = new /obj/screen()
	mymob.toxin.icon = ui_style
	mymob.toxin.icon_state = "tox0"
	mymob.toxin.name = "toxin"
	mymob.toxin.screen_loc = ui_toxin

	mymob.internals = new /obj/screen()
	mymob.internals.icon = ui_style
	mymob.internals.icon_state = "internal0"
	mymob.internals.name = "internal"
	mymob.internals.screen_loc = ui_internal

	mymob.fire = new /obj/screen()
	mymob.fire.icon = ui_style
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = ui_fire

	mymob.bodytemp = new /obj/screen()
	mymob.bodytemp.icon = ui_style
	mymob.bodytemp.icon_state = "temp1"
	mymob.bodytemp.name = "body temperature"
	mymob.bodytemp.screen_loc = ui_temp

	mymob.healths = new /obj/screen()
	mymob.healths.icon = ui_style
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_health

	mymob.pullin = new /obj/screen()
	mymob.pullin.icon = ui_style
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = ui_pull

	mymob.blind = new /obj/screen()
	mymob.blind.icon = 'icons/mob/screen1_full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.layer = 0

	mymob.flash = new /obj/screen()
	mymob.flash.icon = ui_style
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.layer = 17

	mymob.zone_sel = new /obj/screen/zone_sel()
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.overlays.Cut()
	mymob.zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]")
/*
	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /obj/screen/gun/mode(null)
	if (mymob.client)
		if (mymob.client.gun_mode) // If in aim mode, correct the sprite
			mymob.gun_setting_icon.dir = 2
	for(var/obj/item/weapon/gun/G in mymob) // If targeting someone, display other buttons
		if (G.target)
			mymob.item_use_icon = new /obj/screen/gun/item(null)
			if (mymob.client.target_can_click)
				mymob.item_use_icon.dir = 1
			src.adding += mymob.item_use_icon
			mymob.gun_move_icon = new /obj/screen/gun/move(null)
			if (mymob.client.target_can_move)
				mymob.gun_move_icon.dir = 1
				mymob.gun_run_icon = new /obj/screen/gun/run(null)
				if (mymob.client.target_can_run)
					mymob.gun_run_icon.dir = 1
				src.adding += mymob.gun_run_icon
			src.adding += mymob.gun_move_icon
*/
	mymob.client.screen = null

	mymob.client.screen += list( mymob.throw_icon, mymob.zone_sel, mymob.oxygen, mymob.pressure, mymob.toxin, mymob.bodytemp, mymob.internals, mymob.fire, mymob.healths, mymob.pullin, mymob.blind, mymob.flash) //mymob.gun_setting_icon, mymob.rest, mymob.sleep, mymob.mach )
	mymob.client.screen += src.adding + src.other

	return

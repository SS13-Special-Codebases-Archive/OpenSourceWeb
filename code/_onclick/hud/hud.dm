/mob/proc/add_filter_effects()
	return

/*
	The global hud:
	Uses the same visual objects for all players.
*/


/datum/hud/proc/add_inventory_overlay() //THIS SHIT IS UNHOLY! DON'T FUCK WITH IT UNLESS YOU KNOW WHAT YOU'RE DOING!
	if(!mymob)
		return
	if(!ishuman(mymob))
		return
	for(var/obj/screen/inventory/S in all_inv)
		S.overlays.Cut()//Clear all overlays.
	var/mob/living/carbon/human/H = mymob
	for(var/gear_slot in H.species.hud.gear)
		var/list/hud_data = H.species.hud.gear[gear_slot]
		switch(hud_data["slot"])
			if(slot_shoes)
				if(H.shoes)
					for(var/obj/screen/S in all_inv)
						if(S.name == "shoes")
							S.overlays += "hud_fill"
							if(H.shoes.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_l_ear)
				if(H.l_ear)
					for(var/obj/screen/S in all_inv)
						if(S.name == "l_ear")
							S.overlays += "hud_fill"
							if(H.l_ear.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_r_ear)
				if(H.r_ear)
					for(var/obj/screen/S in all_inv)
						if(S.name == "r_ear")
							S.overlays += "hud_fill"
							if(H.r_ear.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_gloves)
				if(H.gloves)
					for(var/obj/screen/S in all_inv)
						if(S.name == "gloves")
							S.overlays += "hud_fill"
							if(H.gloves.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_glasses)
				if(H.glasses)
					for(var/obj/screen/S in all_inv)
						if(S.name == "eyes")
							S.overlays += "hud_fill"
							if(H.glasses.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_s_store)
				if(H.s_store)
					for(var/obj/screen/S in all_inv)
						if(S.name == "belt2")
							S.overlays += "hud_fill"
							if(H.s_store.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_belt)
				if(H.belt)
					for(var/obj/screen/S in all_inv)
						if(S.name == "belt")
							S.overlays += "hud_fill"
							if(H.belt.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_head)
				if(H.head)
					for(var/obj/screen/S in all_inv)
						if(S.name == "head")
							S.overlays += "hud_fill"
							if(H.head.durability <= 80)
								S.overlays += "damagedfill"

			if(slot_w_uniform)
				if(H.w_uniform)
					for(var/obj/screen/S in all_inv)
						if(S.name == "i_clothing")
							S.overlays += "hud_fill"
							if(H.w_uniform.durability <= 80)
								S.overlays += "damagedfill"

			if(slot_wear_id)
				if(H.wear_id)
					for(var/obj/screen/S in all_inv)
						if(S.name == "id")
							S.overlays += "hud_fill"
							if(H.wear_id.durability <= 80)
								S.overlays += "damagedfill"

			if(slot_back)
				if(H.back)
					for(var/obj/screen/S in all_inv)
						if(S.name == "back")
							S.overlays += "hud_fill"
							if(H.back.durability <= 80)
								S.overlays += "damagedfill"

			if(slot_wear_suit)
				if(H.wear_suit)
					for(var/obj/screen/S in all_inv)
						if(S.name == "o_clothing")
							S.overlays += "hud_fill"
							if(H.wear_suit.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_wear_mask)
				if(H.wear_mask)
					for(var/obj/screen/S in all_inv)
						if(S.name == "mask")
							S.overlays += "hud_fill"
							if(H.wear_mask.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_s_store)
				if(H.s_store)
					for(var/obj/screen/S in all_inv)
						if(S.name == "suit storage")
							S.overlays += "hud_fill"
							if(H.s_store.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_wrist_r)
				if(H.wrist_r)
					for(var/obj/screen/S in all_inv)
						if(S.name == "wrist_r")
							S.overlays += "hud_fill"
							if(H.wrist_r.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_wrist_l)
				if(H.wrist_l)
					for(var/obj/screen/S in all_inv)
						if(S.name == "wrist_l")
							S.overlays += "hud_fill"
							if(H.wrist_l.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_amulet)
				if(H.amulet)
					for(var/obj/screen/S in all_inv)
						if(S.name == "amulet")
							S.overlays += "hud_fill"
							if(H.amulet.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_back2)
				if(H.back2)
					for(var/obj/screen/S in all_inv)
						if(S.name == "back2")
							S.overlays += "hud_fill"
							if(H.back2.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_l_store)
				if(H.l_store)
					for(var/obj/screen/S in all_inv)
						if(S.name == "storage1")
							S.overlays += "hud_fill"
							if(H.l_store.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_r_store)
				if(H.r_store)
					for(var/obj/screen/S in all_inv)
						if(S.name == "storage2")
							S.overlays += "hud_fill"
							if(H.r_store.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_l_hand)
				if(H.l_hand)
					for(var/obj/screen/S in all_inv)
						if(S.name == "l_hand")
							if(H.l_hand.durability <= 80)
								S.overlays += "damagedfill"
			if(slot_r_hand)
				if(H.r_hand)
					for(var/obj/screen/S in all_inv)
						if(S.name == "r_hand")
							if(H.r_hand.durability <= 80)
								S.overlays += "damagedfill"





var/datum/global_hud/global_hud = new()

/datum/hud/var/obj/screen/grab_intent
/datum/hud/var/obj/screen/hurt_intent
/datum/hud/var/obj/screen/disarm_intent
/datum/hud/var/obj/screen/help_intent

/datum/global_hud
	var/obj/screen/druggy
	var/obj/screen/blurry
	var/obj/screen/blind
	var/list/vimpaired
	var/list/darkMask
	//Mask d_filters
	var/obj/screen/g_dither = null
	var/obj/screen/r_dither = null
	var/obj/screen/gray_dither = null
	var/obj/screen/lp_dither = null


/datum/global_hud/New()
	//420erryday psychedellic colours screen overlay for when you are high
	druggy = new /obj/screen()
	druggy.screen_loc = "WEST,SOUTH to EAST,NORTH"
	druggy.icon_state = "druggy"
	druggy.layer = 17
	druggy.alpha = 255
	druggy.blend_mode = 4
	druggy.mouse_opacity = 0

	//that white blurry effect you get when you eyes are damaged
	blurry = new /obj/screen()
	blurry.screen_loc = "WEST,SOUTH to EAST,NORTH"
	blurry.icon_state = "blurry"
	blurry.layer = 17
	blurry.mouse_opacity = 0

	blind = new /obj/screen()
	blind.screen_loc = "WEST,SOUTH to EAST,NORTH"
	blind.icon = 'icons/mob/screen1.dmi'
	blind.icon_state = "blackanimate"
	blind.layer = 17
	blind.mouse_opacity = 0


	//Green d_filter for the gasmask
	g_dither = new /obj/screen()
	g_dither.screen_loc = "WEST,SOUTH to EAST,NORTH"
	g_dither.name = "gasmask"
	g_dither.icon_state = "dither12g"
	g_dither.layer = 17
	g_dither.mouse_opacity = 0

	//Red d_filter for the thermal glasses
	r_dither = new /obj/screen()
	r_dither.screen_loc = "WEST,SOUTH to EAST,NORTH"
	r_dither.name = "thermal glasses"
	r_dither.icon_state = "ditherred"
	r_dither.layer = 17
	r_dither.mouse_opacity = 0

	//Gray d_filter for the sunglasses
	gray_dither = new /obj/screen()
	gray_dither.screen_loc = "WEST,SOUTH to EAST,NORTH"
	gray_dither.name = "sunglasses"
	gray_dither.icon_state = "dark32"
	gray_dither.layer = 17
	gray_dither.mouse_opacity = 0

	//Yellow d_filter for the mesons
	lp_dither = new /obj/screen()
	lp_dither.screen_loc = "WEST,SOUTH to EAST,NORTH"
	lp_dither.name = "mesons"
	lp_dither.icon_state = "ditherlimepulse"
	lp_dither.layer = 17
	lp_dither.mouse_opacity = 0


	var/obj/screen/O
	var/i
	//that nasty looking dither you  get when you're short-sighted
	vimpaired = newlist(/obj/screen,/obj/screen,/obj/screen,/obj/screen)
	O = vimpaired[1]
	O.screen_loc = "1,1 to 5,15"
	O = vimpaired[2]
	O.screen_loc = "5,1 to 10,5"
	O = vimpaired[3]
	O.screen_loc = "6,11 to 10,15"
	O = vimpaired[4]
	O.screen_loc = "11,1 to 15,15"

	//welding mask overlay black/dither
	darkMask = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = darkMask[1]
	O.screen_loc = "3,3 to 5,13"
	O = darkMask[2]
	O.screen_loc = "5,3 to 10,5"
	O = darkMask[3]
	O.screen_loc = "6,11 to 10,13"
	O = darkMask[4]
	O.screen_loc = "11,3 to 13,13"
	O = darkMask[5]
	O.screen_loc = "1,1 to 15,2"
	O = darkMask[6]
	O.screen_loc = "1,3 to 2,15"
	O = darkMask[7]
	O.screen_loc = "14,3 to 15,15"
	O = darkMask[8]
	O.screen_loc = "3,14 to 13,15"

	for(i = 1, i <= 4, i++)
		O = vimpaired[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

		O = darkMask[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

	for(i = 5, i <= 8, i++)
		O = darkMask[i]
		O.icon_state = "black"
		O.layer = 17
		O.mouse_opacity = 0

/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/datum/hud
	var/mob/mymob

	var/hud_shown = 1			//Used for the HUD toggle (F12)
	var/inventory_shown = 1		//the inventory
	var/show_intent_icons = 0
	var/hotkey_ui_hidden = 0	//This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/obj/screen/lingchemdisplay
	var/obj/screen/blobpwrdisplay
	var/obj/screen/blobhealthdisplay
	var/obj/screen/r_hand_hud_object
	var/obj/screen/l_hand_hud_object
	var/obj/screen/swaphands_hud_object
	var/obj/screen/action_intent
	var/obj/screen/move_intent
	var/obj/screen/att_intent
	var/obj/screen/rest_hud_object
	var/list/all_inv = list() //All inventory.

	var/list/adding
	var/list/other = list()
	var/list/obj/screen/hotkeybuttons

	var/list/obj/screen/item_action/item_action_list = list()	//Used for the item action ui buttons.


datum/hud/New(mob/owner)
	mymob = owner
	instantiate()
	..()


/datum/hud/proc/hidden_inventory_update()
	if(!mymob) return
	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob

		if(mymob.client && mymob.client.prefs.UI_type == "Retro")
			if(inventory_shown && hud_shown)
				if(H.shoes)		H.shoes.screen_loc = "SOUTH,4"
				if(H.gloves)	H.gloves.screen_loc = "SOUTH,5"
				if(H.l_ear)		H.l_ear.screen_loc = "SOUTH,6"
				if(H.r_ear)		H.r_ear.screen_loc = "SOUTH,6"
				if(H.glasses)	H.glasses.screen_loc = "SOUTH,7"
				if(H.wrist_r)	H.wrist_r.screen_loc = "SOUTH,8"
				if(H.wrist_l)	H.wrist_l.screen_loc = "SOUTH,9"
				if(H.amulet)	H.amulet.screen_loc = "SOUTH, 10"
				if(H.back2)		H.back2.screen_loc = "SOUTH, 11"
				if(H.w_uniform)	H.w_uniform.screen_loc = "SOUTH-1,2"
				if(H.wear_suit)	H.wear_suit.screen_loc = "SOUTH,2"
				if(H.wear_mask)	H.wear_mask.screen_loc = "SOUTH+1,1"
				if(H.head)		H.head.screen_loc = "SOUTH+1,2"
				if(H.belt)		H.belt.screen_loc = "3, 0"
				if(H.s_store)	H.s_store.screen_loc = "3, 0"
				if(H.wear_id)	H.wear_id.screen_loc = "SOUTH-1,1"
			else
				if(H.shoes)		H.shoes.screen_loc = null
				if(H.gloves)	H.gloves.screen_loc = null
				if(H.l_ear)		H.l_ear.screen_loc = null
				if(H.r_ear)		H.r_ear.screen_loc = null
				if(H.glasses)	H.glasses.screen_loc = null
				if(H.wrist_r)	H.wrist_r.screen_loc = null
				if(H.wrist_l)	H.wrist_l.screen_loc = null
				if(H.amulet)	H.amulet.screen_loc = null
				if(H.back2)		H.back2.screen_loc = null
		else
			if(inventory_shown && hud_shown)
				if(H.shoes)		H.shoes.screen_loc = ui_shoes
				if(H.gloves)	H.gloves.screen_loc = ui_gloves
				if(H.l_ear)		H.l_ear.screen_loc = ui_l_ear
				if(H.r_ear)		H.r_ear.screen_loc = ui_r_ear
				if(H.glasses)	H.glasses.screen_loc = ui_glasses
				if(H.wrist_r)	H.wrist_r.screen_loc = ui_wrist_r
				if(H.wrist_l)	H.wrist_l.screen_loc = ui_wrist_l
				if(H.amulet)	H.amulet.screen_loc = ui_amulet
				if(H.back2)		H.back2.screen_loc = ui_back2
			else
				if(H.shoes)		H.shoes.screen_loc = null
				if(H.gloves)	H.gloves.screen_loc = null
				if(H.l_ear)		H.l_ear.screen_loc = null
				if(H.r_ear)		H.r_ear.screen_loc = null
				if(H.glasses)	H.glasses.screen_loc = null
				if(H.wrist_r)	H.wrist_r.screen_loc = null
				if(H.wrist_l)	H.wrist_l.screen_loc = null
				if(H.amulet)	H.amulet.screen_loc = null
				if(H.back2)		H.back2.screen_loc = null

/datum/hud/proc/persistant_inventory_update()
	if(!mymob)
		return

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		if(mymob.client && mymob.client.prefs.UI_type == "Retro")
			if(hud_shown)
				if(H.wear_id)	H.wear_id.screen_loc = "SOUTH-1,1"
				if(H.belt)		H.belt.screen_loc = "3, 0"
				if(H.s_store)	H.s_store.screen_loc = "3, 0"
				if(H.back)		H.back.screen_loc = "SOUTH+1,3"
				if(H.l_store)	H.l_store.screen_loc = "SOUTH-1,4"
				if(H.r_store)	H.r_store.screen_loc = "SOUTH-1,5"
			else
				if(H.s_store)	H.s_store.screen_loc = null
				if(H.wear_id)	H.wear_id.screen_loc = null
				if(H.belt)		H.belt.screen_loc = null
				if(H.back)		H.back.screen_loc = null
				if(H.l_store)	H.l_store.screen_loc = null
				if(H.r_store)	H.r_store.screen_loc = null
		else
			if(hud_shown)
				if(H.wear_id)	H.wear_id.screen_loc = ui_id
				if(H.belt)		H.belt.screen_loc = ui_belt
				if(H.s_store)	H.s_store.screen_loc = ui_sstore1
				if(H.back)		H.back.screen_loc = ui_back
				if(H.l_store)	H.l_store.screen_loc = ui_storage1
				if(H.r_store)	H.r_store.screen_loc = ui_storage2
				if(H.w_uniform)	H.w_uniform.screen_loc = ui_iclothing
				if(H.wear_suit)	H.wear_suit.screen_loc = ui_oclothing
				if(H.wear_mask)	H.wear_mask.screen_loc = ui_mask
				if(H.head)		H.head.screen_loc = ui_head
			else
				if(H.wear_id)	H.wear_id.screen_loc = null
				if(H.belt)		H.belt.screen_loc = null
				if(H.s_store)	H.s_store.screen_loc = null
				if(H.back)		H.back.screen_loc = null
				if(H.l_store)	H.l_store.screen_loc = null
				if(H.r_store)	H.r_store.screen_loc = null
				if(H.w_uniform)	H.w_uniform.screen_loc = null
				if(H.wear_suit)	H.wear_suit.screen_loc = null
				if(H.wear_mask)	H.wear_mask.screen_loc = null
				if(H.head)		H.head.screen_loc = null

/datum/hud/Destroy()
	. = ..()
	lingchemdisplay = null
	r_hand_hud_object = null
	l_hand_hud_object = null
	action_intent = null
	move_intent = null
	adding = null
	other = null
	hotkeybuttons = null
//	item_action_list = null // ?
	mymob = null


/datum/hud/proc/instantiate()
	if(!ismob(mymob)) return 0
	if(!mymob.client) return 0
	var/ui_style = ui_style2icon(mymob.client.prefs.UI_style)
	var/ui_color = mymob.client.prefs.UI_style_color
	var/ui_alpha = mymob.client.prefs.UI_style_alpha
	var/ui_type = mymob.client.prefs.UI_type
	var/mob/living/carbon/C = mymob
	if(ishuman(mymob) && !istype(C.species, /datum/species/human/alien))
		if(ui_type == "Luna")
			human_hud_luna(ui_style, ui_color, ui_alpha) // Pass the player the UI style chosen in preferences
		if(ui_type == "Retro")
			human_hud_tg(ui_style, ui_color, ui_alpha)
		else
			human_hud_luna(ui_style, ui_color, ui_alpha)
	else if(ishuman(mymob))
		if(istype(C.species, /datum/species/human/alien))
			alien_hud()
	else if(ismonkey(mymob))
		monkey_hud(ui_style)
	else if(isbrain(mymob))
		brain_hud(ui_style)
	else if(islarva(mymob))
		larva_hud()
	else if(isalien(mymob))
		alien_hud()
	else if(isAI(mymob))
		ai_hud()
	else if(isrobot(mymob))
		robot_hud()
	else if(isobserver(mymob))
		ghost_hud()

/datum/hud/proc/get_slot_loc(var/slot)
	if(mymob.client && mymob.client.prefs.UI_type == "Retro")
		switch(slot)
			if("mask") return "SOUTH+1,1"
			if("oclothing") return "SOUTH,2"
			if("iclothing") return "SOUTH-1,2"

			if("sstore1") return "SOUTH-1,3"
			if("id") return "SOUTH-1,1"
			if("belt") return "3, 0"
			if("belt2") return "3, 0"
			if("back") return "SOUTH+1,3"

			if("rhand") return "SOUTH,1"
			if("lhand") return "SOUTH,3"

			if("storage1") return "SOUTH-1,4"
			if("storage2") return "SOUTH-1,5"

			if("shoes") return "SOUTH,4"
			if("head") return "SOUTH+1,2"
			if("gloves") return "SOUTH,5"
			if("r_ear") return "SOUTH,6"
			if("l_ear") return "SOUTH,7"
			if("glasses") return "SOUTH,8"
			if("wrist_r") return "SOUTH,10"
			if("wrist_l") return "SOUTH,9"
			if("amulet") return "SOUTH, 11"
			if("back2") return "SOUTH, 12"

			if("acti") return "SOUTH-1,10"

	else
		switch(slot)
			if("mask") return ui_mask
			if("oclothing") return ui_oclothing
			if("iclothing") return ui_iclothing

			if("sstore1") return ui_sstore1
			if("id") return ui_id
			if("belt") return ui_belt
			if("back") return ui_back

			if("rhand") return ui_rhand
			if("lhand") return ui_lhand

			if("storage1") return ui_storage1
			if("storage2") return ui_storage2

			if("shoes") return ui_shoes
			if("head") return ui_head
			if("gloves") return ui_gloves
			if("r_ear") return ui_r_ear
			if("l_ear") return ui_l_ear
			if("glasses") return ui_glasses
			if("wrist_r") return ui_wrist_r
			if("wrist_l") return ui_wrist_l
			if("amulet") return ui_amulet
			if("back2") return ui_back2

			if("acti") return ui_acti

/mob/living/carbon/human/proc/get_slot_loc(var/slot)
	if(src.client && src.client.prefs.UI_type == "Luna")
		switch(slot)
			if("mask") return ui_mask
			if("oclothing") return ui_oclothing
			if("iclothing") return ui_iclothing

			if("sstore1") return ui_sstore1
			if("id") return ui_id
			if("belt") return ui_belt
			if("back") return ui_back

			if("rhand") return ui_rhand
			if("lhand") return ui_lhand

			if("storage1") return ui_storage1
			if("storage2") return ui_storage2

			if("shoes") return ui_shoes
			if("head") return ui_head
			if("gloves") return ui_gloves
			if("r_ear") return ui_r_ear
			if("l_ear") return ui_l_ear
			if("glasses") return ui_glasses

			if("acti") return ui_acti
	else
		switch(slot)
			if("mask") return "SOUTH+1,1"
			if("oclothing") return "SOUTH,2"
			if("iclothing") return "SOUTH-1,2"

			if("sstore1") return "SOUTH-1,3"
			if("id") return "SOUTH-1,1"
			if("belt") return "3,0"
			if("belt2") return "3,0"
			if("back") return "SOUTH+1,3"

			if("rhand") return "SOUTH,1"
			if("lhand") return "SOUTH,3"

			if("storage1") return "SOUTH-1,4"
			if("storage2") return "SOUTH-1,5"

			if("shoes") return "SOUTH,4"
			if("head") return "SOUTH+1,2"
			if("gloves") return "SOUTH,5"
			if("r_ear") return "SOUTH,6"
			if("l_ear") return "SOUTH,7"
			if("glasses") return "SOUTH,8"
			if("wrist_r") return "SOUTH,10"
			if("wrist_l") return "SOUTH,9"
			if("amulet") return "SOUTH, 11"
			if("back2") return "SOUTH, 12"

			if("acti") return "SOUTH-1,10"



//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12(var/full = 0 as null)
	set name = "F12"
	set hidden = 1
	return

	/*
	if(hud_used)
		if(ishuman(src))
			if(!client) return
			if(client.view != world.view)
				return
			if(hud_used.hud_shown)
				hud_used.hud_shown = 0
				if(src.hud_used.adding)
					src.client.screen -= src.hud_used.adding
				if(src.hud_used.other)
					src.client.screen -= src.hud_used.other
				if(src.hud_used.hotkeybuttons)
					src.client.screen -= src.hud_used.hotkeybuttons
				if(src.hud_used.item_action_list)
					src.client.screen -= src.hud_used.item_action_list

				//Due to some poor coding some things need special treatment:
				//These ones are a part of 'adding', 'other' or 'hotkeybuttons' but we want them to stay
				if(!full)
					src.client.screen += src.hud_used.l_hand_hud_object	//we want the hands to be visible
					src.client.screen += src.hud_used.r_hand_hud_object	//we want the hands to be visible
					src.client.screen += src.hud_used.action_intent		//we want the intent swticher visible
					src.hud_used.action_intent.screen_loc = ui_acti_alt	//move this to the alternative position, where zone_select usually is.
				else
					src.client.screen -= src.healths
					src.client.screen -= src.internals
					src.client.screen -= src.gun_setting_icon

				//These ones are not a part of 'adding', 'other' or 'hotkeybuttons' but we want them gone.
				src.client.screen -= src.zone_sel	//zone_sel is a mob variable for some reason.

			else
				hud_used.hud_shown = 1
				if(src.hud_used.adding)
					src.client.screen += src.hud_used.adding
				if(src.hud_used.other && src.hud_used.inventory_shown)
					src.client.screen += src.hud_used.other
				if(src.hud_used.hotkeybuttons && !src.hud_used.hotkey_ui_hidden)
					src.client.screen += src.hud_used.hotkeybuttons
				if(src.healths)
					src.client.screen |= src.healths
				if(src.internals)
					src.client.screen |= src.internals
				if(src.gun_setting_icon)
					src.client.screen |= src.gun_setting_icon

				src.hud_used.action_intent.screen_loc = ui_acti //Restore intent selection to the original position
				src.client.screen += src.zone_sel				//This one is a special snowflake

			hud_used.hidden_inventory_update()
			hud_used.persistant_inventory_update()
			update_action_buttons()
		else
			usr << "\red Inventory hiding is currently only supported for human mobs, sorry."
	else
		usr << "\red This mob type does not use a HUD."
*/
/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/obj/screen
	name = ""
	icon = 'icons/mob/screen1.dmi'
	layer = 20.0
	plane = 30
	unacidable = 1
	var/obj/master = null	//A reference to the object in the slot. Grabs or items, generally.
	var/gun_click_time = -100 //I'm lazy.
	var/globalscreen = FALSE
	appearance_flags = NO_CLIENT_COLOR

/obj/screen/examine()
	return

/obj/screen/jump_act()
	return
/obj/screen/bite_act()
	return


/obj/screen/text
	icon = null
	icon_state = null
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480


/obj/screen/a_intent
	name = "a_intent"
	var/intent = "help"

/obj/screen/a_intent/update_icon()
	icon_state = "[intent]"

/obj/screen/a_intent/Click(location, control, params)
	var/list/P = params2list(params)
	var/icon_x = text2num(P["icon-x"])
	var/icon_y = text2num(P["icon-y"])
	intent = "disarm"
	if(icon_x <= world.icon_size/2)
		if(icon_y <= world.icon_size/2)
			intent = "help"
		else
			intent = "hurt"
	else if(icon_y <= world.icon_size/2)
		intent = "grab"
	update_icon()
	usr.a_intent = intent


/**************************NAO MECHA***************************
*************************************************************


/obj/screen/combat_popup
	name = "combat_intents"
	var/c_intent = "feint"

/obj/screen/combat_popup/update_icon()
	icon_state = "[c_intent]"

/obj/screen/combat_popup/Click(location, control, params)
	var/list/P = params2list(params)
	var/icon_x = text2num(P["icon-x"])
	var/icon_y = text2num(P["icon-y"])
	world << "ANUS"
	switch(icon_x)
		if(33 to 62)
			switch(icon_y)
				if(55 to 64)
					c_intent = "weak"
					world << "CU"





	update_icon()
	usr.combat_intent = c_intent
*/





/**************************NAO MECHA***************************
*************************************************************/

/obj/screen/inventory
	var/slot_id	//The indentifier for the slot. It has nothing to do with ID cards.


/obj/screen/close
	name = "close"

/obj/screen/close/Click()
	if(master)
		if(istype(master, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = master
			S.close(usr)
		/*else if(istype(master, /mob/living/carbon/human/))
			var/mob/living/carbon/human/S = master
			S.close(usr)*/
		else if(istype(master,/obj/item/clothing/suit/storage))
			var/obj/item/clothing/suit/storage/S = master
			S.close(usr)

	return 1


/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/Click()
	if(!usr || !owner)
		return 1
	if(usr.next_move >= world.time)
		return
	usr.next_move = world.time + 6

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return 1

	if(!(owner in usr))
		return 1

	owner.ui_action_click()
	return 1

//This is the proc used to update all the action buttons. It just returns for all mob types except humans.
/mob/proc/update_action_buttons()
	return


/obj/screen/grab
	name = "grab"

/obj/screen/grab/Click()
	var/obj/item/weapon/grab/G = master
	G.s_click(src)
	return 1

/obj/screen/grab/attack_hand()
	return

/obj/screen/grab/attackby()
	return


/obj/screen/storage
	name = "storage"

/obj/screen/storage/Click()
	if(world.time <= usr.next_move)
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return 1
	if(master)
		var/obj/item/I = usr.get_active_hand()
		if(I)
			/*if(istype(master, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = master
				if(!H.can_be_inserted(I))
					return 0
				H.handle_item_insertion(I)
				usr.next_move = world.time+2
				return 1*/

			if(istype(master, /obj/item/weapon/storage/forge))
				var/obj/item/weapon/storage/forge/F = master
				if(F.on || F.tocomplete)
					return

			master.attackby(I, usr)
			usr.next_move = world.time+2
	return 1

/obj/screen/gun
	name = "gun"
	icon = 'icons/mob/screen1.dmi'
	master = null
	dir = 2

	move
		name = "Allow Walking"
		icon_state = "no_walk0"
		screen_loc = ui_gun2

	run
		name = "Allow Running"
		icon_state = "no_run0"
		screen_loc = ui_gun3

	item
		name = "Allow Item Use"
		icon_state = "no_item0"
		screen_loc = ui_gun1

	mode
		name = "Toggle Gun Mode"
		icon_state = "gun0"
		screen_loc = ui_gun_select
		//dir = 1

/obj/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	var/selecting = "chest"

/obj/screen/zone_sel/New()
	..()
	selecting = selecting

/obj/screen/zone_sel/Click(location, control,params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/old_selecting = selecting //We're only going to update_icon() if there's been a change

	if(PL["right"])
		selecting = pick("r_foot","l_foot","r_leg","l_leg","groin","r_hand","l_hand","vitals","throat","chest","r_arm","l_arm","mouth","face","right eye","left eye","head")
		if (old_selecting != selecting)
			update_icon()
		return

	switch(icon_y)
		if (1 to 7) //Feet
			switch(icon_x)
				if (1 to 16)
					selecting = "r_foot"
				if (17 to 32)
					selecting = "l_foot"
				else
					return TRUE
		if (8 to 19) //Legs
			switch(icon_x)
				if (1 to 16)
					selecting = "r_leg"
				if (17 to 32)
					selecting = "l_leg"
				else
					return TRUE
		if (19 to 23) //Legs and groin
			switch(icon_x)
				if (1 to 12)
					selecting = "r_leg"
				if (12 to 22)
					selecting = "groin"
				if (22 to 32)
					selecting = "l_leg"
				else
					return TRUE
		if (23 to 25) //Hands and groin
			switch(icon_x)
				if (2 to 11)
					selecting = "r_hand"
				if (12 to 22)
					if (icon_y in 23 to 23)
						selecting = "groin"
					if (icon_y in 24 to 25)
						selecting = "vitals"
				if (23 to 31)
					selecting = "l_hand"
				else
					return TRUE
		if (26 to 32) //Hands and chest
			switch(icon_x)
				if (2 to 11)
					selecting = "r_hand"
				if (12 to 22)
					selecting = "vitals"
				if (23 to 31)
					selecting = "l_hand"
				else
					return TRUE
		if (45 to 46)
			switch(icon_x)
				if (14 to 19)
					selecting = "throat"
		if (33 to 45) //Chest and arms to shoulders
			switch(icon_x)
				if (4 to 10)
					selecting = "r_arm"
				if (11 to 22)
					selecting = "chest"
				if (23 to 29)
					selecting = "l_arm"
				else
					return TRUE
		if (46 to 64) //Head, but we need to check for eye or mouth
			if (icon_x in 11 to 22)
				selecting = "face"
				switch(icon_y)
					if (44 to 48)
						if (icon_x in 13 to 20)
							selecting = "throat"
					if (49 to 51)
						if (icon_x in 13 to 20)
							selecting = "mouth"
					if (53 to 55)
						if (icon_x in 14 to 15)
							selecting = "right eye"
						if (icon_x in 18 to 19)
							selecting = "left eye"
					if (56 to 61)
						if (icon_x in 11 to 22)
							selecting = "head"



	if (old_selecting != selecting)
		update_icon()

	selecting = selecting
	return TRUE

/obj/screen/zone_sel/New()
	..()
	update_icon()

/obj/screen/zone_sel/update_icon()
	overlays.Cut()
	overlays += image('icons/life/zone_sel.dmi', "[selecting]")

/obj/screen/Click(location, control, params)
	if(!usr)	return 1
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/list/modifiers = params2list(params)
	if(modifiers["middle"])
		switch(name)
			if("cutebuttons")
				var/mob/living/carbon/human/H = usr
				switch(icon_y)
					if(17 to 32)
						switch(icon_x)
							if(1 to 18)
								if(H?.client?.DisplayingRolls)
									H?.client?.DisplayingRolls = FALSE
									to_chat(H, "<span class='jogtowalk'>You're no longer displaying rolls.</span>")
								else
									H?.client?.DisplayingRolls = TRUE
									to_chat(H, "<span class='jogtowalk'>You're now displaying rolls.</span>")
								return
	if(modifiers["right"])
		switch(name)
			if("eyefix")
				usr.mouse_fixeye()

			if("resist")
				var/mob/living/carbon/human/HHH = usr
				if(HHH.toggle_resisting)
					src.icon_state = "act_resist"
					HHH.toggle_resisting = FALSE
				else
					src.icon_state = "act_resist2"
					HHH.toggle_resisting = TRUE
			if("cutebuttons")
				var/mob/living/carbon/human/H = usr
				switch(icon_y)
					if(17 to 32)
						switch(icon_x)
							if(1 to 18)
								H.check_skills_rmb()
			if("stamina")
				if(isliving(usr))
					var/mob/living/carbon/human/H = usr
					H.spendWP()
			if("health")
				if(isliving(usr))
					var/mob/living/L = usr
					if(!L.exam_wounds)
						to_chat(L, "<span class='jogtowalk'>I am now examining others with greater detail.</span>")
						L.exam_wounds = TRUE
					else
						to_chat(L, "<span class='jogtowalk'>I am no longer examining others with greater detail.</span>")
						L.exam_wounds = FALSE

		return 1

	switch(name)
		if("toggle")
			if(usr.hud_used.inventory_shown)
				usr.hud_used.inventory_shown = 0
				usr.client.screen -= usr.hud_used.other
			else
				usr.hud_used.inventory_shown = 1
				usr.client.screen += usr.hud_used.other

			usr.hud_used.hidden_inventory_update()

		if("equip")
			if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
				return 1
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				H.quick_equip()
		if("cutebuttons")
			var/mob/living/carbon/human/H = usr
			switch(icon_y)
				if(17 to 32)
					switch(icon_x)
						if(1 to 18)
							H.check_skills()
						if(18 to 30)
							H.check_family()
				if(3 to 17)
					switch(icon_x)
						if(4 to 18)
							H.memory()
						if(19 to 32)
							H.client.helpmenu()
		if("awake")
			var/mob/living/carbon/human/H = usr
			switch(icon_y)
				if(1 to 11)
					switch(icon_x)
						if(1 to 32)
							H.teach_others()
				if(12 to 21)
					switch(icon_x)
						if(1 to 32)
							H.toggle_eye()
				if(22 to 32)
					switch(icon_x)
						if(1 to 32)
							H.mob_sleep()
							H.handle_regular_hud_updates()
		if("combat intents")
			var/mob/living/carbon/human/H = usr
			if(!H.combat_popup.screen_loc)
				if(H.client.prefs.UI_type != "Luna")
					H.combat_popup.screen_loc = "13,1"
				else
					H.combat_popup.screen_loc = "-2,2"
				H.combat_popup.layer = 222
			else
				H.combat_popup.screen_loc = null


		if("combat popup")
			var/mob/living/carbon/human/H = usr
			if(isliving(usr))
				switch(icon_x)
					if(33 to 62)
						switch(icon_y)
							if(55 to 64)
								to_chat(H, "<span class='combatmodes'>⠀Weak: You will deal as little damage as possible to an enemy target. Perhaps it is good to suppress someone.</i></span>")
								H.combat_intent = "weak"
								H.combat_popup.screen_loc = null
								H.combat_intents.icon_state = "min_st"
							if(48 to 54)
								to_chat(H, "<span class='combatmodes'>⠀Aimed: You will more precisely damage your enemy in exchange for stamina and strength. Good at hitting targets with few weaknesses.</i></span>")
								H.combat_intent = "aimed"
								H.combat_popup.screen_loc = null
								H.combat_intents.icon_state = "aimed"
							if(40 to 47)

								H.combat_intent = "fury"
								H.combat_popup.screen_loc = null
								H.combat_intents.icon_state = "fury"
							if(33 to 40)
								to_chat(H, "<span class='combatmodes'>⠀Strong: You will deal as much damage as possible to an enemy target in exchange for stamina. Great to finish off someone.</i></span>")
								H.combat_intent = "strong"
								H.combat_popup.screen_loc = null
								H.combat_intents.icon_state = "max_st"
							if(25 to 31)
								to_chat(H, "<span class='combatmodes'>⠀Defend: You will more easily dodge or parry an enemy attack in exchange for stamina. Great to defend yourself!</i></span>")
								H.combat_intent = "defend"
								H.combat_popup.screen_loc = null
								H.combat_intents.icon_state = "defend"
							if(18 to 24)
								to_chat(H, "⠀<span class='combatbold'>[pick(nao_consigoen)]! You don't know how to use this..</span>")
								H.combat_intent = "guard"
								H.combat_popup.screen_loc = null
								H.combat_intents.icon_state = "guard"
							if(9 to 17)
								to_chat(H, "⠀<span class='combatbold'>[pick(nao_consigoen)]! You don't know how to use this..</span>")
								H.combat_intent = "dual"
								H.combat_popup.screen_loc = null
								H.combat_intents.icon_state = "dual"
							if(1 to 9)
								to_chat(H, "⠀<span class='combatbold'>[pick(nao_consigoen)]! You don't know how to use this..</span>")
								H.combat_intent = "feint"
								H.combat_popup.screen_loc = null
								H.combat_intents.icon_state = "feint"
		if("resist")
			if(isliving(usr))
				var/mob/living/L = usr
				L.resist()

		if("combat mode")
			if(isliving(usr))
				var/mob/living/carbon/human/H = usr
				H.toggle_combat_mode()
		if("sprint")
			if(isliving(usr))
				var/mob/living/carbon/human/H = usr
				H.togglesprint()
		if("stamina")
			if(isliving(usr))
				var/mob/living/carbon/human/H = usr
				H.spendWP()
		if("dodge parry")
			var/mob/living/carbon/human/H = usr
			if(isliving(usr))
				switch(icon_x)
					if(1 to 32)
						switch(icon_y)
							if(17 to 32)
								H.c_intent = "dodge"
								H.dodge_parry.icon_state = "dodge1"
							else
								H.c_intent = "parry"
								H.dodge_parry.icon_state = "dodge0"


		if("health")
			if(ishuman(usr))
				var/mob/living/carbon/human/X = usr
				X.exam_self()
		if("mood")
			if(ishuman(usr))
				var/mob/living/carbon/C = usr
				C.print_happiness(C)

		if("surrender")
			if(ishuman(usr))
				switch(alert("Do you wish to surrender?", "Surrender", "Yes", "No"))
					if("Yes")
						var/mob/living/carbon/human/H = usr
						H.surrender()
					if("No")
						return


		if("actions1")
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				switch(icon_x)
					if(1 to 32)
						switch(icon_y)
							if(23 to 32)
								if(H.middle_click_intent == "kick")
									H.actions1.icon_state = "actions"
									H.middle_click_intent = null
									return
								H.middle_click_intent = "kick"
								H.actions1.icon_state = "actionskick"
							if(16 to 22)
								if(H.middle_click_intent == "steal")
									H.actions1.icon_state = "actions"
									H.middle_click_intent = null
									return
								H.middle_click_intent = "steal"
								H.actions1.icon_state = "actionssteal"
							if(9 to 15)
								if(H.middle_click_intent == "jump")
									H.actions1.icon_state = "actions"
									H.middle_click_intent = null
									return
								H.middle_click_intent = "jump"
								H.actions1.icon_state = "actionsjump"
							if(1 to 9)
								if(H.middle_click_intent == "bite")
									H.actions1.icon_state = "actions"
									H.middle_click_intent = null
									return
								H.middle_click_intent = "bite"
								H.actions1.icon_state = "actionsbite"
		if("moreactions")
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				switch(icon_x)
					if(1 to 32)
						switch(icon_y)
							if(23 to 32)
								H.do_wield()
								return
							if(16 to 22)
								H.lookup()
								return
							if(9 to 15)
								H.hidee()
								return
							if(0 to 8)
								H.glind()
								return
		if("mov_intent")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(C.legcuffed)
					to_chat(C, "<span class='notice'>You are legcuffed! You cannot run until you get [C.legcuffed] removed!</span>")
					C.m_intent = "walk"	//Just incase
					C.hud_used.move_intent.icon_state = "walking"
					return 1
				switch(usr.m_intent)
					if("run")
						usr.m_intent = "walk"
						usr.hud_used.move_intent.icon_state = "walking"
						to_chat(usr, "<span class='baron'><i>⠀Mode: slow steps. Bonus to defense and aim.</i></span>")
					if("walk")
						usr.m_intent = "run"
						usr.hud_used.move_intent.icon_state = "running"
//				if(istype(usr,/mob/living/carbon/alien/humanoid))
//					usr.update_icons()

		if("att_intent")
			if(istype(usr,/mob/living/carbon))
				switch(usr.att_intent)
					if("slash")
						usr.att_intent = "stab"
					if("stab")
						usr.att_intent = "slash"
				usr.hud_used.att_intent.icon_state = usr.att_intent

		if("eyefix")
			if(modifiers["middle"])
				var/mob/living/carbon/human/HHH = usr
				HHH.check_for_traps()
			else
				var/mob/living/carbon/human/HHH = usr
				if(HHH.special == "weirdgait")
					to_chat(HHH, "<span class='combat'>[pick(nao_consigoen)] I'm stuck!</span>")
					return
				usr.fixeye()
				if(usr.facing_dir)
					usr.eye_fix.icon_state = "fixed_e1"
				else
					usr.follow_mouse = FALSE
					usr.eye_fix.icon_state = "fixed_e0"

		if("walk")
			usr.m_intent = "walk"
		if("face")
			usr.m_intent = "face"
		if("run")
			usr.m_intent = "run"
		if("Reset Machine")
			usr.unset_machine()
		if("internal")
			if(ishuman(usr))
				var/mob/living/carbon/human/C = usr
				if(!C.stat)
					if(!istype(C.wear_mask, /obj/item/clothing/mask/breath) && !istype(C.wear_mask, /obj/item/clothing/mask/gas))
						if(C.resting && C?:loc?:liquid?:depth >= 85)
							to_chat(C, "I can't hold my breath!!")
							return
						if(!C.resting && C?:loc?:liquid?:depth >= 205)
							to_chat(C, "I can't hold my breath!!")
							return
						if(C.holding_breath)
							C.holding_breath = FALSE
							to_chat(C, "You're no longer trying to hold your breath.")
							C.internals.icon_state = "internal01"
						else
							C.holding_breath = TRUE
							to_chat(C, "You're now trying to hold your breath.")
							C.internals.icon_state = "internal00"
							spawn(350)
								if(C.holding_breath)
									C.holding_breath = FALSE
									to_chat(C, "You're no longer trying to hold your breath.")
									C.internals.icon_state = "internal01"
					else
						if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
							if(C.internal)
								C.internal = null
								C << "<span class='notice'>No longer running on internals.</span>"
								if(C.internals)
									C.internals.icon_state = "internal0"
							else
								if(!istype(C.wear_mask, /obj/item/clothing/mask))
									C << "<span class='notice'>You are not wearing a mask.</span>"
									return 1
								else
									var/list/nicename = null
									var/list/tankcheck = null
									var/breathes = "oxygen"    //default, we'll check later
									var/list/contents = list()

									if(ishuman(C))
										var/mob/living/carbon/human/H = C
										breathes = H.species.breath_type
										nicename = list ("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
										tankcheck = list (H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)

									else

										nicename = list("Right Hand", "Left Hand", "Back")
										tankcheck = list(C.r_hand, C.l_hand, C.back)

									for(var/i=1, i<tankcheck.len+1, ++i)
										if(istype(tankcheck[i], /obj/item/weapon/tank))
											var/obj/item/weapon/tank/t = tankcheck[i]
											if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
												contents.Add(t.air_contents.total_moles)	//Someone messed with the tank and put unknown gasses
												continue					//in it, so we're going to believe the tank is what it says it is
											switch(breathes)
																				//These tanks we're sure of their contents
												if("nitrogen") 							//So we're a bit more picky about them.

													if(t.air_contents.gas["nitrogen"] && !t.air_contents.gas["oxygen"])
														contents.Add(t.air_contents.gas["nitrogen"])
													else
														contents.Add(0)

												if ("oxygen")
													if(t.air_contents.gas["oxygen"] && !t.air_contents.gas["plasma"])
														contents.Add(t.air_contents.gas["oxygen"])
													else
														contents.Add(0)

												// No races breath this, but never know about downstream servers.
												if ("carbon dioxide")
													if(t.air_contents.gas["carbon_dioxide"] && !t.air_contents.gas["plasma"])
														contents.Add(t.air_contents.gas["carbon_dioxide"])
													else
														contents.Add(0)


										else
											//no tank so we set contents to 0
											contents.Add(0)

									//Alright now we know the contents of the tanks so we have to pick the best one.

									var/best = 0
									var/bestcontents = 0
									for(var/i=1, i <  contents.len + 1 , ++i)
										if(!contents[i])
											continue
										if(contents[i] > bestcontents)
											best = i
											bestcontents = contents[i]


									//We've determined the best container now we set it as our internals

									if(best)
										C << "<span class='notice'>You are now running on internals from [tankcheck[best]] on your [nicename[best]].</span>"
										C.internal = tankcheck[best]


									if(C.internal)
										if(C.internals)
											C.internals.icon_state = "internal1"
									else
										C << "<span class='notice'>You don't have a[breathes=="oxygen" ? "n oxygen" : addtext(" ",breathes)] tank.</span>"

		//INTERNALS SS13 DESABILITADO
/*		if("internal")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
					if(C.internal)
						C.internal = null
						C << "<span class='notice'>No longer running on internals.</span>"
						if(C.internals)
							C.internals.icon_state = "internal0"
					else
						if(!istype(C.wear_mask, /obj/item/clothing/mask))
							C << "<span class='notice'>You are not wearing a mask.</span>"
							return 1
						else
							var/list/nicename = null
							var/list/tankcheck = null
							var/breathes = "oxygen"    //default, we'll check later
							var/list/contents = list()

							if(ishuman(C))
								var/mob/living/carbon/human/H = C
								breathes = H.species.breath_type
								nicename = list ("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
								tankcheck = list (H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)

							else

								nicename = list("Right Hand", "Left Hand", "Back")
								tankcheck = list(C.r_hand, C.l_hand, C.back)

							for(var/i=1, i<tankcheck.len+1, ++i)
								if(istype(tankcheck[i], /obj/item/weapon/tank))
									var/obj/item/weapon/tank/t = tankcheck[i]
									if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
										contents.Add(t.air_contents.total_moles)	//Someone messed with the tank and put unknown gasses
										continue					//in it, so we're going to believe the tank is what it says it is
									switch(breathes)
																		//These tanks we're sure of their contents
										if("nitrogen") 							//So we're a bit more picky about them.

											if(t.air_contents.gas["nitrogen"] && !t.air_contents.gas["oxygen"])
												contents.Add(t.air_contents.gas["nitrogen"])
											else
												contents.Add(0)

										if ("oxygen")
											if(t.air_contents.gas["oxygen"] && !t.air_contents.gas["plasma"])
												contents.Add(t.air_contents.gas["oxygen"])
											else
												contents.Add(0)

										// No races breath this, but never know about downstream servers.
										if ("carbon dioxide")
											if(t.air_contents.gas["carbon_dioxide"] && !t.air_contents.gas["plasma"])
												contents.Add(t.air_contents.gas["carbon_dioxide"])
											else
												contents.Add(0)


								else
									//no tank so we set contents to 0
									contents.Add(0)

							//Alright now we know the contents of the tanks so we have to pick the best one.

							var/best = 0
							var/bestcontents = 0
							for(var/i=1, i <  contents.len + 1 , ++i)
								if(!contents[i])
									continue
								if(contents[i] > bestcontents)
									best = i
									bestcontents = contents[i]


							//We've determined the best container now we set it as our internals

							if(best)
								C << "<span class='notice'>You are now running on internals from [tankcheck[best]] on your [nicename[best]].</span>"
								C.internal = tankcheck[best]


							if(C.internal)
								if(C.internals)
									C.internals.icon_state = "internal1"
							else
								C << "<span class='notice'>You don't have a[breathes=="oxygen" ? "n oxygen" : addtext(" ",breathes)] tank.</span>"
*/
		if("act_intent")
			usr.a_intent_change("right")
		if("help")
			usr.a_intent = "help"
			usr.hud_used.action_intent.icon_state = "help"
		if("harm")
			usr.a_intent = "hurt"
			usr.hud_used.action_intent.icon_state = "hurt"
		if("grab")
			usr.a_intent = "grab"
			usr.hud_used.action_intent.icon_state = "grab"
		if("disarm")
			usr.a_intent = "disarm"
			usr.hud_used.action_intent.icon_state = "disarm"
		if("pull")
			usr.stop_pulling()
		if("rest")
			if(isliving(usr))
				usr:mob_rest()
		if("throw")
			if(!usr.stat && isturf(usr.loc) && !usr.restrained())
				usr:toggle_throw_mode()
		if("drop")
			usr.drop_item_v()
		if("module")
			if(issilicon(usr))
				if(usr:module)
					return 1
				usr:pick_module()

		if("radio")
			if(issilicon(usr))
				usr:radio_menu()
		if("panel")
			if(issilicon(usr))
				usr:installed_modules()

		if("store")
			if(issilicon(usr))
				usr:uneq_active()

		if("module1")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(1)

		if("module2")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(2)

		if("module3")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(3)

/*		if("Allow Walking")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetMove()
			gun_click_time = world.time

		if("Disallow Walking")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetMove()
			gun_click_time = world.time

		if("Allow Running")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetRun()
			gun_click_time = world.time

		if("Disallow Running")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetRun()
			gun_click_time = world.time

		if("Allow Item Use")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetClick()
			gun_click_time = world.time


		if("Disallow Item Use")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetClick()
			gun_click_time = world.time

		if("Toggle Gun Mode")
			usr.client.ToggleGunMode()*/

		else
			return 0
	return 1

/obj/screen/inventory/Click(location, control, params)
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(world.time <= usr.next_move)
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return 1
	switch(name)
		if("r_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("r")
				usr.next_move = world.time+2
		if("l_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("l")
				usr.next_move = world.time+2
		if("swap")
			usr:swap_hand()
		if("hand")
			usr:swap_hand()
		else
			var/list/modifiers = params2list(params)
			if(modifiers["middle"] && ishuman(usr))
				var/mob/living/carbon/human/H = usr
				if(name == "belt")
					H?.belt?.screen_loc = null
					H?.s_store?.screen_loc = ui_belt
					if(H.client && H.client.prefs.UI_type == "Retro")
						H?.belt?.screen_loc = null
						H?.s_store?.screen_loc = "3,0"
					for(var/obj/screen/inventory/I in H?.hud_used?.all_inv)
						if(I?.name == "belt")
							I?.screen_loc = null
						else if(I?.name == "belt2")
							I?.screen_loc  = ui_belt
							if(H.client && H.client.prefs.UI_type == "Retro")
								I?.screen_loc  = "3,0"
				if(name == "belt2")
					H?.s_store?.screen_loc = null
					H?.belt?.screen_loc = ui_belt
					if(H.client && H.client.prefs.UI_type == "Retro")
						H?.s_store?.screen_loc = null
						H?.belt?.screen_loc = "3,0"
					for(var/obj/screen/inventory/I in H?.hud_used?.all_inv)
						if(I?.name == "belt2")
							I?.screen_loc = null
						else if(I?.name == "belt")
							I?.screen_loc  = ui_belt
							if(H.client && H.client.prefs.UI_type == "Retro")
								I?.screen_loc  = "3,0"
				return 1
			else
				if(usr.attack_ui(slot_id))
					usr.update_inv_l_hand(0)
					usr.update_inv_r_hand(0)
					usr.next_move = world.time+6

/obj/screen/fov
	icon = 'icons/mob/hide.dmi'
	icon_state = "combat"
	name = " "
	screen_loc = "1,1"
	mouse_opacity = 0
	layer = 18
	plane = 30

/obj/screen/fov_mask
	icon = 'icons/mob/hide.dmi'
	icon_state = "behind3"
	name = " "
	screen_loc = "1,1"
	mouse_opacity = 0
	layer = 18
	plane = HIDDEN_SHIT_PLANE

/obj/screen/fov_mask_two
	icon = 'icons/mob/hide.dmi'
	icon_state = "combat_mask"
	name = " "
	screen_loc = "1,1"
	mouse_opacity = 0
	layer = 18
	plane = HIDDEN_SHIT_PLANE
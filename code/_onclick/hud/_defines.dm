/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

//Upper left action buttons, displayed when you pick up an item that has this enabled.
#define ui_action_slot1 "1:6,14:26"
#define ui_action_slot2 "2:8,14:26"
#define ui_action_slot3 "3:10,14:26"
#define ui_action_slot4 "4:12,14:26"
#define ui_action_slot5 "5:14,14:26"

//Lower left, persistant menu
#define ui_inventory "SOUTH,4"

#define ui_entire_screen "WEST,SOUTH to EAST,NORTH"

//Lower center, persistant menu
#define ui_sstore1 "-1,7"
#define ui_id "0,7"
#define ui_belt "-1,7"
#define ui_back "-2,12"
#define ui_rhand "-2,11"
#define ui_lhand "0,11"
#define ui_swaphand2 "8:16,2:5"
#define ui_storage1 "-2,8"
#define ui_storage2 "0,8"

#define ui_alien_head "4:12,1:5"	//aliens
#define ui_alien_oclothing "5:14,1:5"	//aliens
/*
#define ui_inv1 "6:16,1:5"			//borgs
#define ui_inv2 "7:16,1:5"			//borgs
#define ui_inv3 "8:16,1:5"			//borgs
#define ui_borg_store "9:16,1:5"	//borgs
*/
#define ui_monkey_mask "SOUTH+1,1"	//monkey
#define ui_monkey_back "SOUTH+1,3"	//monkey

//Lower right, persistant menu
#define ui_swaphand "-1,10"
#define ui_dropbutton "0,5"
#define ui_drop_throw "0,5"
#define ui_pull "-1,2"
#define ui_actions1 "0,6"
#define ui_moreactions "-2,6"
#define ui_resist "16,1"
#define ui_acti "-1,6"
#define ui_movi "EAST+1,SOUTH+7"
#define ui_zonesel "16,14"
#define ui_acti_alt "14:28,1:5" //alternative intent switcher for when the interface is hidden (F12)

#define ui_borg_pull "EAST,SOUTH-1"
#define ui_borg_module "13:26,2:7"
#define ui_borg_panel "14:28,2:7"

//Gun buttons
#define ui_gun1 "9, SOUTH"
#define ui_gun2 "10, SOUTH"
#define ui_gun3 "11, SOUTH"
#define ui_gun_select "10, SOUTH-1"

//Upper-middle right (damage indicators)
#define ui_toxin "EAST+1, NORTH-13"
#define ui_awake "EAST+1, NORTH-13"
#define ui_fire "EAST+1, NORTH-8"
#define ui_oxygen "EAST+1, NORTH-5"
#define ui_pressure "EAST+1, NORTH-6"

#define ui_alien_toxin "14:28,13:25"
#define ui_alien_fire "14:28,12:25"
#define ui_alien_oxygen "14:28,11:25"

//Middle right (status indicators)
#define ui_nutrition "EAST+1, NORTH-5"
#define ui_temp "EAST+1, NORTH-10"
#define ui_health "EAST+1, NORTH-11"
#define ui_internal "EAST+1, NORTH-2"
									//borgs
#define ui_borg_health "EAST+1, NORTH-11" //borgs have the health display where humans have the pressure damage indicator.
#define ui_alien_health "EAST+1, NORTH-11" //aliens have the health display where humans have the pressure damage indicator.

//Pop-up inventory
#define ui_shoes "-2,7"

#define ui_iclothing "-1,8"
#define ui_oclothing "-1,11"
#define ui_gloves "-1,9"

#define ui_glasses "0,13"
#define ui_amulet "-1,12"
#define ui_wrist_r "0,9"
#define ui_back2 "0,12"
#define ui_wrist_l "-2,9"
#define ui_mask "-1,13"
#define ui_l_ear "-2,13"
#define ui_r_ear "-2,13"
#define ui_surrender "16,11"

#define ui_head "-1,14"

//Attack intent
#define ui_att_int "SOUTH-1,9"

//#define ui_swapbutton "6:-16,1:5" //Unused

//#define ui_headset "SOUTH,8"
#define ui_hstore1 "5,5"
#define ui_sleep "EAST+1, NORTH-13"
#define ui_rest "16, 6"


#define ui_iarrowleft "SOUTH-1,11"
#define ui_iarrowright "SOUTH-1,13"



/***********************************************************************************
************************************************************************************
************************************************************************************
**********************			TG'S HUD DEFINES			  **********************
************************************************************************************
************************************************************************************
************************************************************************************/


//Upper left action buttons, displayed when you pick up an item that has this enabled.
#define ui_tg_action_slot1 "1:6,14:26"
#define ui_tg_action_slot2 "2:8,14:26"
#define ui_tg_action_slot3 "3:10,14:26"
#define ui_tg_action_slot4 "4:12,14:26"
#define ui_tg_action_slot5 "5:14,14:26"

//Lower left, persistant menu
#define ui_tg_inventory "1:6,1:5"

//Lower center, persistant menu
#define ui_tg_sstore1 "3:10,1:5"
#define ui_tg_id "4:12,1:5"
#define ui_tg_belt "5:14,1:5"
#define ui_tg_back "6:14,1:5"
#define ui_tg_rhand "7:16,1:5"
#define ui_tg_lhand "8:16,1:5"
#define ui_tg_equip "7:16,2:5"
#define ui_tg_swaphand1 "7:16,2:5"
#define ui_tg_swaphand2 "8:16,2:5"
#define ui_tg_storage1 "9:18,1:5"
#define ui_tg_storage2 "10:20,1:5"

#define ui_tg_alien_head "4:12,1:5"	//aliens
#define ui_tg_alien_oclothing "5:14,1:5"	//aliens

#define ui_tg_inv1 "6:16,1:5"			//borgs
#define ui_tg_inv2 "7:16,1:5"			//borgs
#define ui_tg_inv3 "8:16,1:5"			//borgs
#define ui_tg_borg_store "9:16,1:5"	//borgs

#define ui_tg_monkey_mask "5:14,1:5"	//monkey
#define ui_tg_monkey_back "6:14,1:5"	//monkey

//Lower right, persistant menu
#define ui_tg_dropbutton "11:22,1:5"
#define ui_tg_drop_throw "14:28,2:7"
#define ui_tg_pull_resist "13:26,2:7"
#define ui_tg_acti "13:26,1:5"
#define ui_tg_movi "12:24,1:5"
#define ui_tg_zonesel "14:28,1:5"
#define ui_tg_acti_alt "14:28,1:5" //alternative intent switcher for when the interface is hidden (F12)

#define ui_tg_borg_pull "12:24,2:7"
#define ui_tg_borg_module "13:26,2:7"
#define ui_tg_borg_panel "14:28,2:7"

//Gun buttons
#define ui_tg_gun1 "13:26,3:7"
#define ui_tg_gun2 "14:28, 4:7"
#define ui_tg_gun3 "13:26,4:7"
#define ui_tg_gun_select "14:28,3:7"

//Upper-middle right (damage indicators)
#define ui_tg_toxin "14:28,13:27"
#define ui_tg_fire "14:28,12:25"
#define ui_tg_oxygen "14:28,11:23"
#define ui_tg_pressure "14:28,10:21"

#define ui_tg_alien_toxin "14:28,13:25"
#define ui_tg_alien_fire "14:28,12:25"
#define ui_tg_alien_oxygen "14:28,11:25"

//Middle right (status indicators)
#define ui_tg_nutrition "14:28,5:11"
#define ui_tg_temp "14:28,6:13"
#define ui_tg_health "14:28,7:15"
#define ui_tg_internal "14:28,8:17"
									//borgs
#define ui_tg_borg_health "14:28,6:13" //borgs have the health display where humans have the pressure damage indicator.
#define ui_tg_alien_health "14:28,6:13" //aliens have the health display where humans have the pressure damage indicator.

//Pop-up inventory
#define ui_tg_shoes "2:8,1:5"

#define ui_tg_iclothing "1:6,2:7"
#define ui_tg_oclothing "2:8,2:7"
#define ui_tg_gloves "3:10,2:7"

#define ui_tg_glasses "1:6,3:9"
#define ui_tg_mask "2:8,3:9"
#define ui_tg_l_ear "3:10,3:9"
#define ui_tg_r_ear "3:10,4:11"

#define ui_tg_head "2:8,4:11"

//Intent small buttons
#define ui_tg_help_small "12:8,1:1"
#define ui_tg_disarm_small "12:15,1:18"
#define ui_tg_grab_small "12:32,1:18"
#define ui_tg_harm_small "12:39,1:1"

//#define ui_swapbutton "6:-16,1:5" //Unused

//#define ui_headset "SOUTH,8"
#define ui_tg_hand "6:14,1:5"
#define ui_tg_hstore1 "5,5"
//#define ui_resist "EAST+1,SOUTH-1"
#define ui_tg_sleep "EAST+1, NORTH-13"
#define ui_tg_rest "EAST+1, NORTH-14"


#define ui_tg_iarrowleft "SOUTH-1,11"
#define ui_tg_iarrowright "SOUTH-1,13"

#define ui_stamina "16,3"
#define ui_eye_fix	"-1, 5"
#define ui_cutebuttons "16,9"
#define ui_combat_mode "-2, 1"
#define ui_sprint "0, 1"
#define ui_combat_intents "-1,1"
#define ui_dodge_parry "-2, 5"
#define ui_mood "EAST+1, NORTH-3"
#define ui_combat_popup "-2, 1"
#define I_DODGE		"dodge"
#define I_PARRY		"parry"
#define LEGAL_RELIGION	"Gray Church"
#define ILLEGAL_RELIGION	"Thanati"
/mob
	density = 1
	layer = 4.0
	animate_movement = 2
//	flags = NOREACT
	var/datum/mind/mind

	var/stat = 0 //Whether a mob is alive or dead. TODO: Move this to living - Nodrak

	//Not in use yet
	var/obj/effect/organstructure/organStructure = null
	var/obj/screen/flash = null
	var/obj/screen/blind = null
	var/obj/screen/hands = null
	var/obj/screen/pullin = null
	var/obj/screen/rest = null
	var/obj/screen/internals = null
	var/obj/screen/oxygen = null
	var/obj/screen/i_select = null
	var/obj/screen/m_select = null
	var/obj/screen/toxin = null
	var/obj/screen/fire = null
	var/obj/screen/bodytemp = null
	var/obj/screen/healths = null
	var/obj/screen/throw_icon = null
	var/obj/screen/awake = null
	var/obj/screen/nutrition_icon = null
	var/obj/screen/pressure = null
	var/obj/screen/damageoverlay = null
	var/obj/screen/pain = null
	var/obj/screen/moodscreen = null
	var/obj/screen/gun/item/item_use_icon = null
	var/obj/screen/gun/move/gun_move_icon = null
	var/obj/screen/gun/run/gun_run_icon = null
	var/obj/screen/gun/mode/gun_setting_icon = null
	var/obj/screen/fullscreen_overeffect = null
	var/obj/screen/film_grain2 = null
	var/obj/screen/stamina_ui = null
	var/obj/screen/eye_fix	= null
	var/obj/screen/cutebuttons = null
	var/obj/screen/combat_mode_icon = null
	var/obj/screen/dodge_parry = null
	var/obj/screen/mood_icon = null
	var/obj/screen/combat_popup = null
	var/obj/screen/actions1 = null
	var/obj/screen/surrender = null
	var/obj/screen/moreactions = null
	var/obj/screen/readycd = null
	var/obj/screen/sprint_icon = null
	var/obj/screen/background = null
	var/obj/screen/fov
	var/obj/screen/fov_mask
	var/obj/screen/fov_mask_two
	var/obj/screen/text/atm/hovertext = null
	var/obj/screen/combat_intents = null
	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	var/obj/screen/zone_sel/zone_sel = null
	var/zoomed = FALSE
	var/lookingup = FALSE
	var/hasalpha = 0
	var/use_me = 1 //Allows all mobs to use the me verb by default, will have to manually specify they cannot
	var/damageoverlaytemp = 0
	var/computer_id = null
	var/lastattacker = null
	var/lastattacked = null
	var/attack_log = list( )
	var/already_placed = 0.0
	var/obj/machinery/machine = null
	var/other_mobs = null
	var/memory = ""
	var/sdisabilities = 0	//Carbon
	var/disabilities = 0	//Carbon
	var/atom/movable/pulling = null
	var/next_move = null
	var/monkeyizing = null	//Carbon
	var/other = 0.0
	var/hand = null
	var/eye_blind = null	//Carbon
	var/eye_blurry = null	//Carbon
	var/ear_deaf = null		//Carbon
	var/ear_damage = null	//Carbon
	var/stuttering = null	//Carbon
	var/last_said = null	//Living, usado para o Dreamer, por enquanto
	var/facing_dir	=null
	var/slurring = null		//Carbon
	var/real_name = null
	var/flavor_text = ""
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/blinded = null
	var/bhunger = 0			//Carbon
	var/ajourn = 0
	var/druggy = 0			//Carbon
	var/confused = 0		//Carbon
	var/antitoxs = null
	var/eye_stat = null//Living, potentially Carbon
	var/plasma = null
	var/sleeping = 0		//Carbon
	var/resting = 0			//Carbon
	var/lying = 0
	var/lying_prev = 0
	var/doing_something = 0
	var/canmove = 1
	var/voicetype = "normal"//VOICE TIPES = old,noble,strong,retarded,normal,sketchy
	var/lastpuke = 0
	var/unacidable = 0
	var/small = 0
	var/list/pinned = list()            // List of things pinning this creature to walls (see living_defense.dm)
	var/list/embedded = list()          // Embedded items, since simple mobs don't have organs.
	var/list/languages = list()         // For speaking/listening.
	var/list/habilities = list()         // For species-derived or admin-given powers.
	var/list/speak_emote = list("says") // Verbs used when speaking. Defaults to 'say' if speak_emote is null.
	var/emote_type = 1		// Define emote default type, 1 for seen emotes, 2 for heard emotes
	var/tentaclesexposed = FALSE // chang shit
	//CHURCH SHIT
	var/ischurchmeeting = FALSE
	var/name_archive //For admin things like possession

	var/timeofdeath = 0//Living
	var/cpr_time = 1//Carbon


	var/bodytemperature = 310.055	//98.7 F
	var/old_x = 0
	var/old_y = 0
	var/drowsyness = 0.0//Carbon

	var/dizziness = 0//Carbon
	var/is_dizzy = 0
	var/is_jittery = 0
	var/jitteriness = 0//Carbon
	var/charges = 0
	var/nutrition = 400//Carbon
	var/hidratacao = THIRST_LEVEL_FILLED

	var/paralysis = 0
	var/stunned = 0
	var/weakened = 0
	var/losebreath = 0//Carbon
	var/intent = null//Living
	var/middle_click_intent = null
	var/shakecamera = 0
	var/shakecameraslight = 0
	var/a_intent = "help"//Living
	var/c_intent = "dodge"
	var/combat_mode = 0
	var/m_intent = "run"//Living
	var/att_intent = "slash"
	var/lastKnownIP = null
	var/obj/structure/stool/bed/buckled = null//Living
	var/obj/item/l_hand = null//Living
	var/obj/item/r_hand = null//Living
	var/obj/item/weapon/back = null//Human/Monkey
	var/obj/item/weapon/tank/internal = null//Human/Monkey
	var/obj/item/weapon/storage/s_active = null//Carbon
	var/obj/item/clothing/mask/wear_mask = null//Carbon
	var/moving_delay = 0

	var/obj/screen/storage/boxes = null
	var/obj/screen/storage/closer = null

	var/seer = 0 //for cult//Carbon, probably Human

	var/datum/hud/hud_used = null

	var/list/grabbed_by = list(  )
	var/list/requests = list(  )

	var/list/mapobjs = list()

	var/in_throw_mode = 0

	var/coughedtime = null

	var/music_lastplayed = "null"

	var/job = null//Living

	var/const/blindness = 1//Carbon
	var/const/deafness = 2//Carbon
	var/const/muteness = 4//Carbon


	var/datum/dna/dna = null//Carbon
	var/radiation = 0//Carbon

	var/list/mutations = list() //Carbon -- Doohl
	//see: setup.dm for list of mutations

	var/voice_name = "unidentifiable voice"

	var/faction = "neutral" //Used for checking whether hostile simple animals will attack you, possibly more stuff later
	var/captured = 0 //Functionally, should give the same effect as being buckled into a chair when true.
	var/doing_after = FALSE //if the mob is currently doing a do_after

//Generic list for proc holders. Only way I can see to enable certain verbs/procs. Should be modified if needed.
	var/proc_holder_list[] = list()//Right now unused.
	//Also unlike the spell list, this would only store the object in contents, not an object in itself.

	/* Add this line to whatever stat module you need in order to use the proc holder list.
	Unlike the object spell system, it's also possible to attach verb procs from these objects to right-click menus.
	This requires creating a verb for the object proc holder.

	if (proc_holder_list.len)//Generic list for proc_holder objects.
		for(var/obj/effect/proc_holder/P in proc_holder_list)
			statpanel("[P.panel]","",P)
	*/

//The last mob/living/carbon to push/drag/grab this mob (mostly used by slimes friend recognition)
	var/mob/living/carbon/LAssailant = null

//Wizard mode, but can be used in other modes thanks to the brand new "Give Spell" badmin button
	var/obj/effect/proc_holder/spell/list/spell_list = list()

//Changlings, but can be used in other modes
//	var/obj/effect/proc_holder/changpower/list/power_list = list()

//List of active diseases

	var/list/viruses = list() // replaces var/datum/disease/virus

//Monkey/infected mode
	var/list/resistances = list()
	var/datum/disease/virus = null

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	var/update_icon = 1 //Set to 1 to trigger update_icons() at the next life() call

	var/status_flags = CANSTUN|CANWEAKEN|CANPARALYSE|CANPUSH	//bitflags defining which status effects can be inflicted (replaces canweaken, canstun, etc)

	var/area/lastarea = null

	var/digitalcamo = 0 // Can they be tracked by the AI?

	var/list/radar_blips = list() // list of screen objects, radar blips
	var/radar_open = 0 	// nonzero is radar is open


	var/obj/control_object //Used by admins to possess objects. All mobs should have this var

	//Whether or not mobs can understand other mobtypes. These stay in /mob so that ghosts can hear everything.
	var/universal_speak = 0 // Set to 1 to enable the mob to speak to everyone -- TLE
	var/universal_understand = 0 // Set to 1 to enable the mob to understand everyone, not necessarily speak
	var/robot_talk_understand = 0
	var/alien_talk_understand = 0

	var/has_limbs = 1 //Whether this mob have any limbs he can move with
	var/can_stand = 1 //Whether this mob have ability to stand
	var/scrambling = 0

	var/immune_to_ssd = 0

	var/turf/listed_turf = null  //the current turf being examined in the stat panel

	var/list/active_genes=list()

	var/reports_amount = 0

	var/old_key
	var/old_job
	var/list/ArtemiSHITO = list()
	virtual_mob = null
	var/looking_up = FALSE
	var/pain_dropped = FALSE
	var/altista = FALSE
	var/follow_mouse = FALSE // Makes the humans direction turn towards the mouse
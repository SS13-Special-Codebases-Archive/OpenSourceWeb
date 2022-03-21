//PESO NOPM CIMENTO


/mob/living/carbon/human
	//Hair colour and style
	var/r_hair = 0
	var/g_hair = 0
	var/b_hair = 0
	var/h_style = "Bald"

	//Facial hair colour and style
	var/r_facial = 0
	var/g_facial = 0
	var/b_facial = 0
	var/f_style = "Shaved"
	var/body_hair

	var/r_detail
	var/g_detail
	var/b_detail
	var/d_style = "None"

	//Eye colour
	var/r_eyes = 0
	var/g_eyes = 0
	var/bandit = FALSE
	var/b_eyes = 0

	var/goldXoomed = 0
	var/neckXommed = 0
	var/datum/oldways/old_ways = new()
	var/religion = LEGAL_RELIGION

	//THANATI VARS
	var/raged = 0
	var/jinxed = 0
	var/dicked = 0
	var/pulledThanati = 0
	var/mrlonely = 0
	var/falsetarget = 0
	//THANATI VARS

	var/s_tone = 0	//Skin tone

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup

	var/age = 30		//Player's age (pure fluff)
	var/b_type = "A+"	//Player's bloodtype

	var/underwear = 0	//Which underwear the player wants
	var/backbag = "Nothing"//Which backpack type the player has chosen. Nothing, Satchel or Backpack.

	//Equipment slots
	var/obj/item/wear_suit = null
	var/obj/item/w_uniform = null
	var/obj/item/shoes = null
	var/obj/item/belt = null
	var/obj/item/gloves = null
	var/obj/item/glasses = null
	var/obj/item/head = null
	var/obj/item/l_ear = null
	var/obj/item/r_ear = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null
	var/obj/item/wrist_r = null
	var/obj/item/wrist_l = null
	var/obj/item/amulet = null
	var/obj/item/back2 = null
	var/combat_music = 'sound/music/ravenheart_combat1.ogg'

	//DONATE QUE O STIMUSZ PEDIU PRA TER MUSICA PERSONALIZADA E TREMER
	var/sound/combat_musicoverlay = NULL
	var/fakeDREAMER = 0
	var/icon/stand_icon = null
	var/icon/lying_icon = null
	var/vice
	var/voice = ""	//Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()
	var/speech_problem_flag = 0

	var/miming = null //Toggle for the mime's abilities.
	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/failed_last_breath = 0 //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.
	var/emote_cooldown = 0
	var/xylophone = 0 //For the spoooooooky xylophone cooldown

	var/last_dam = -1	//Used for determining if we need to process all organs or just some or even none.
	var/list/bad_external_organs = list()// organs we check until they are good.

	var/mob/remoteview_target = null
	var/hand_blood_color

	var/list/flavor_texts = list()

	var/image/zombieimage = null
	var/tdome_team = 0
//////////////////////
///CONSYTE CONTENT!///
//////////////////////
	var/consyte = FALSE
	var/consyte_voice = null
//////////////////////
	var/lastFart = 0 // Toxic fart cooldown.
	var/lastElaugh = 0

	var/decaylevel = 0 // For rotting bodies

	///////////////////////////////////////
	var/list/donationsUsed = list()
	///////////////////////////////////////

	var/footstep = 1
	var/isrev = FALSE
	var/migclass = null
	var/alreadyhasrobe = FALSE
	var/moreactionintent = null
	var/riding = FALSE // if riding a horse
	var/mob/living/simple_animal/riding_mob = null
	var/zodiac = "Aranea"
	var/viceneed = 0
	var/jumping = FALSE
	var/sprinting = FALSE
	var/siegesoldier = FALSE
	var/special = ""
	var/lifeweb_locked = FALSE
	var/stealth = 0 // PARA CAMUFLAGEM
	var/brothelstealth = 0 // PARA CAMUFLAGEM
	var/seen_key = null
	var/seen_heart_key = ""
	//var/jewish
	var/favorite_beverage = "Water"
	var/pregnant = 0
	var/informed_inquisitor = 0
	var/tiredness = 0
	var/excomunicated = 0
	var/tryingtosleep = FALSE
	var/lastDir = NULL
	var/death_door = 0
	var/coldbreath = FALSE //dumb snowflake bullshit for coldbreath don't worry about it g
	//roubei do is12 to nem aiiiiiii
	var/tmp/next_blood_squirt = 0
	var/ArtemisCrew = 0
	var/vampirebit = FALSE
	var/piggybacking = FALSE
	var/piggybacked = FALSE
	var/mob/living/buckled_mob
	var/turf/clinged_turf
	var/isLeaning = 0
	var/list/perks = list()
	var/reflectneed = 0
	var/height = null
	var/province = "Wanderer"
	var/terriblethings = FALSE
	var/resisting_disgust = FALSE
	var/willpower_active = FALSE
	//DISGUISE VOICE
	var/disguise_number = 1
	var/disguising_voice = FALSE
	var/logout_time = 0
//////////////////////////////////
//////////SISTEMA DE PESO/////////
//////////////////////////////////
	var/maxweight = 100
	var/carryingweight = 0
	var/weight_state = WEIGHT_NONE
	// INCARN
	var/incarn_registered = FALSE
	var/time_since_death = 0
	var/new_keyed
	var/bot = 0
	// TOGGLE DE RESIST, MUITO IMPORTANTE!
	var/toggle_resisting = FALSE
	// IDADE
	var/year_born = 3021
	var/month_born = "Ljutish"
	var/day_born = 1
	var/acrobat = FALSE
	//SEXO CAMISINHA!
	var/obj/item/condom/ConDom = null
	//TODAS AS PESSOAS COM QUEM TRANSOU
	var/list/HadSex = list()
	var/Lifewebbed = FALSE
	//SISTEMA HOLD BREATH
	var/holding_breath = FALSE
	var/list/StingerSeen = list()
	var/list/AreasEntered = list()
	var/ishunting = 0
	var/absorbedP = 0
	var/global/atom/movable/smelly_vis = null
	virtual_mob = /mob/observer/virtual/mob
	var/dancing = 0
	var/obj/item/malabares = null
	var/obj/item/beingaimedby = null
	var/list/saved_migclasses //prevents reroll on disconnect.
	var/list/seen_me_doing_heresy = list()
	var/assignment = null //Used for displaying runtime job name. Like rings.
	var/disgust_level = 0
	var/can_reflect = TRUE
	var/eye_closed = FALSE
	var/right_eye_fucked = FALSE // better to code like this
	var/left_eye_fucked = FALSE //better to code like this
/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/datum/sprite_accessory

	var/icon			// the icon file the accessory is located in
	var/icon_state		// the icon_state of the accessory
	var/preview_state	// a custom preview state for whatever reason

	var/name			// the preview name of the accessory

	// Determines if the accessory will be skipped or included in random hair generations
	var/gender = NEUTER

	// Restrict some styles to specific species
	var/list/species_allowed = list("Human", "Child","Midget", "Femboy", "Zombie", "Zombie Child")

	// Whether or not the accessory can be affected by colouration
	var/do_colouration = 1


/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair

	icon = 'icons/mob/Human_face.dmi'	  // default icon for all hairs

	bald
		name = "Bald"
		icon_state = "bald"
		gender = MALE
		species_allowed = list("Human","Unathi")

	short
		name = "Short Hair"	  // try to capatilize the names please~
		icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you
		gender = MALE

	cut
		name = "Cut Hair"
		icon_state = "hair_c"
		gender = MALE

	long
		name = "Shoulder-length Hair"
		icon_state = "hair_b"

	longalt
		name = "Shoulder-length Hair Alt"
		icon_state = "hair_longfringe"

	/*longish
		name = "Longer Hair"
		icon_state = "hair_b2"*/

	longer
		name = "Long Hair"
		icon_state = "hair_vlong"

	Tress
		name = "Tress Hair"
		icon_state = "Tress"

	longeralt
		name = "Long Hair Alt"
		icon_state = "hair_vlongfringe"

	longest
		name = "Very Long Hair"
		icon_state = "hair_longest"

	halfbang
		name = "Half-banged Hair"
		icon_state = "hair_halfbang"

	ponytail1
		name = "Ponytail 1"
		icon_state = "hair_ponytail"

	ponytail2
		name = "Ponytail 2"
		icon_state = "hair_pa"
		gender = FEMALE

	ponytail3
		name = "Ponytail 3"
		icon_state = "hair_ponytail3"

	sideponytail
		name = "Side Ponytail"
		icon_state = "hair_stail"
		gender = FEMALE

	side
		name = "Side Hair"
		icon_state = "Side"
		gender = FEMALE

	wild
		name = "Wild Hair"
		icon_state = "Wild"
		gender = FEMALE

	hana
		name = "Hana Hair"
		icon_state = "Hana"
		gender = FEMALE

	tame
		name = "Tame Hair"
		icon_state = "Tame"
		gender = FEMALE

	drifter
		name = "Drifter Hair"
		icon_state = "Drifter"
		gender = FEMALE

	long_emo
		name = "Long Emo"
		icon_state = "hair_longemo"
		gender = FEMALE

	parted
		name = "Parted"
		icon_state = "hair_parted"

	pompadour
		name = "Pompadour"
		icon_state = "hair_pompadour"
		gender = MALE
		species_allowed = list("Human","Unathi")

	quiff
		name = "Quiff"
		icon_state = "hair_quiff"
		gender = MALE
	tommy
		name = "Thomas Shelby LTDA"
		icon_state = "shelby"
		gender = MALE
	john
		name = "John Shelby"
		icon_state = "john"
		gender = MALE

	bedhead
		name = "Bedhead"
		icon_state = "hair_bedhead"

	bedhead2
		name = "Bedhead 2"
		icon_state = "hair_bedheadv2"

	forelock
		name = "Forelock"
		icon_state = "forelock"

	bedhead3
		name = "Bedhead 3"
		icon_state = "hair_bedheadv3"

	beehive
		name = "Beehive"
		icon_state = "hair_beehive"
		gender = FEMALE
		species_allowed = list("Human","Unathi")

	bobcurl
		name = "Bobcurl"
		icon_state = "hair_bobcurl"
		gender = FEMALE
		species_allowed = list("Human","Unathi")

	bob
		name = "Bob"
		icon_state = "hair_bobcut"
		gender = FEMALE
		species_allowed = list("Human","Unathi")

	bowl
		name = "Bowl"
		icon_state = "hair_bowlcut"
		gender = MALE

	buzz
		name = "Buzzcut"
		icon_state = "hair_buzzcut"
		gender = MALE
		species_allowed = list("Human","Unathi")

	crew
		name = "Crewcut"
		icon_state = "hair_crewcut"
		gender = MALE

	combover
		name = "Combover"
		icon_state = "hair_combover"
		gender = MALE

	devillock
		name = "Devil Lock"
		icon_state = "hair_devilock"

	dreadlocks
		name = "Dreadlocks"
		icon_state = "hair_dreads"

	curls
		name = "Curls"
		icon_state = "hair_curls"

	afro
		name = "Afro"
		icon_state = "hair_afro"

	afro2
		name = "Afro 2"
		icon_state = "hair_afro2"

	afro_large
		name = "Big Afro"
		icon_state = "hair_bigafro"
		gender = MALE

	sargeant
		name = "Flat Top"
		icon_state = "hair_sargeant"
		gender = MALE

	emo
		name = "Emo"
		icon_state = "hair_emo"

	emof
		name = "Emo Female"
		icon_state = "hair_emof"

	emof
		name = "Hair Long 2"
		icon_state = "long2"

	fag
		name = "Flow Hair"
		icon_state = "hair_f"

	feather
		name = "Feather"
		icon_state = "hair_feather"

	hitop
		name = "Hitop"
		icon_state = "hair_hitop"
		gender = MALE

	mohawk
		name = "Mohawk"
		icon_state = "hair_d"
		species_allowed = list("Human","Unathi")

	gelled
		name = "Gelled Back"
		icon_state = "hair_gelled"
		gender = FEMALE

	gentle
		name = "Gentle"
		icon_state = "hair_gentle"
		gender = FEMALE

	spiky
		name = "Spiky"
		icon_state = "hair_spikey"
		species_allowed = list("Human","Unathi")
	kusangi
		name = "Kusanagi Hair"
		icon_state = "hair_kusanagi"

	kagami
		name = "Pigtails"
		icon_state = "hair_kagami"
		gender = FEMALE

	himecut
		name = "Hime Cut"
		icon_state = "hair_himecut"
		gender = FEMALE

	braid
		name = "Floorlength Braid"
		icon_state = "hair_braid"
		gender = FEMALE

	braid2
		name = "Long Braid"
		icon_state = "hair_hbraid"
		gender = FEMALE

	odango
		name = "Odango"
		icon_state = "hair_odango"
		gender = FEMALE

	ombre
		name = "Ombre"
		icon_state = "hair_ombre"
		gender = FEMALE

	updo
		name = "Updo"
		icon_state = "hair_updo"
		gender = FEMALE

	skinhead
		name = "Skinhead"
		icon_state = "hair_skinhead"

	cia
		name = "Cia"
		icon_state = "hair_cia"
		gender = MALE

	eighties
		name = "80's"
		icon_state = "eighties"
		gender = MALE

	toriyama
		name = "Toriyama"
		icon_state = "hair_toriyama"
		gender = MALE

	mulder
		name = "Mulder"
		icon_state = "hair_mulder"
		gender = MALE

	dread
		name = "dread"
		icon_state = "hair_c1"
		gender = MALE

	goku
		name = "Goku"
		icon_state = "goku"
		gender = MALE

	big_afro
		name = "Big Afro"
		icon_state = "afro"
		gender = MALE

	bedhead5
		name = "Bedhead 5"
		icon_state = "Bedhead3"
		gender = MALE

	natural_hair
		name = "Natural hair"
		icon_state = "naturalhair"
		gender = MALE

	mulder
		name = "Mulder"
		icon_state = "hair_mulder"
		gender = MALE

	smart
		name = "Smart"
		icon_state = "hair_smart"
		gender = MALE

	wake
		name = "Wake"
		icon_state = "hair_wake"

	balding
		name = "Balding Hair"
		icon_state = "hair_e"
		gender = MALE // turnoff!

	bald
		name = "Bald"
		icon_state = "bald"

	_80s
		name = "Eighties"
		icon_state = "hair_80s"

	ponytail
		name = "Ponytail"
		icon_state = "hair_ponytaile"

	egirl
		name = "Egirl"
		icon_state = "hair_egirl"

	egirl
		name = "Egirl"
		icon_state = "hair_egirl"

	natural
		name = "Natural"
		icon_state = "natural"

	wicked
		name = "Wicked"
		icon_state = "female_wicked"
		gender = FEMALE

	fdyke
		name = "Female Dyke"
		icon_state = "female_dyke"
		gender = FEMALE

	feather
		name = "Feather"
		icon_state = "hair_feather"
		gender = FEMALE

	punk
		name = "Punk"
		icon_state = "hair_punk"
		gender = MALE

	twin
		name = "Ox Horns"
		icon_state = "hair_edge"
		gender = FEMALE

	ponytails
		name = "Ponytails"
		icon_state = "hair_ponytail2"
		gender = FEMALE

	messy
		name = "Messy"
		icon_state = "hair_d"
		gender = FEMALE

	randy
		name = "Randy Sandy"
		icon_state = "Randy"
		gender = MALE

	baldspot
		name = "Bald Spot"
		icon_state = "Bald_Spot"
		gender = MALE

/*	Honry
		name = "Honry"
		icon_state = "honry"
		gender = FEMALE*/

	fling
		name = "Fling"
		icon_state = "Fling"
		gender = FEMALE

	bedhead4
		name = "Bedhead 4"
		icon_state = "hair_bedhead"
		gender = MALE

	longbob
		name = "Long Bob"
		icon_state = "Long_Bob"

	rwaroma
		name = "Cute"
		icon_state = "hair_cute"

	uwu
		name = "Aroma"
		icon_state = "hair_uwu"

	noble
		name = "Noble"
		icon_state = "hair_noble"

	gora
		name = "Gora"
		icon_state = "hair_gora"



	icp_screen_pink
		name = "pink IPC screen"
		icon_state = "ipc_pink"
		species_allowed = list("Machine")

	icp_screen_red
		name = "red IPC screen"
		icon_state = "ipc_red"
		species_allowed = list("Machine")

	icp_screen_green
		name = "green IPC screen"
		icon_state = "ipc_green"
		species_allowed = list("Machine")

	icp_screen_blue
		name = "blue IPC screen"
		icon_state = "ipc_blue"
		species_allowed = list("Machine")

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair

	icon = 'icons/mob/Human_face.dmi'
	gender = MALE // barf (unless you're a dorf, dorfs dig chix /w beards :P)

	shaved
		name = "Shaved"
		icon_state = "bald"
		gender = NEUTER
		species_allowed = list("Human","Unathi","Tajaran","Skrell","Vox","Machine","Zombie","Midget")

	watson
		name = "Watson Mustache"
		icon_state = "facial_watson"

	hogan
		name = "Hulk Hogan Mustache"
		icon_state = "facial_hogan" //-Neek

	vandyke
		name = "Van Dyke Mustache"
		icon_state = "facial_vandyke"

	chaplin
		name = "Square Mustache"
		icon_state = "facial_chaplin"

	selleck
		name = "Selleck Mustache"
		icon_state = "facial_selleck"

	neckbeard
		name = "Neckbeard"
		icon_state = "facial_neckbeard"

	fullbeard
		name = "Full Beard"
		icon_state = "facial_fullbeard"

	manly
		name = "Manly Beard"
		icon_state = "facial_manly"

	tired
		name = "Tired Beard"
		icon_state = "facial_tired"

	devil
		name = "Devil Beard"
		icon_state = "facial_devil"

	Bum
		name = "Bum Beard"
		icon_state = "facial_gb"

	tsar
		name = "Tsar Beard"
		icon_state = "Tsar"

	Shchechki
		name = "Shchechki Beard"
		icon_state = "Shchechki"

	longbeard
		name = "Long Beard"
		icon_state = "facial_longbeard"

	vlongbeard
		name = "Very Long Beard"
		icon_state = "facial_wise"

	elvis
		name = "Elvis Sideburns"
		icon_state = "facial_elvis"
		species_allowed = list("Human","Unathi")

	abe
		name = "Abraham Lincoln Beard"
		icon_state = "facial_abe"

	chinstrap
		name = "Chinstrap"
		icon_state = "facial_chin"

	hip
		name = "Hipster Beard"
		icon_state = "facial_hip"

	gt
		name = "Goatee"
		icon_state = "facial_gt"

	jensen
		name = "Adam Jensen Beard"
		icon_state = "facial_jensen"

	dwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Alien Style Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/hair
	una_spines_long
		name = "Long Unathi Spines"
		icon_state = "soghun_longspines"
		species_allowed = list("Unathi")
		do_colouration = 0

	una_spines_short
		name = "Short Unathi Spines"
		icon_state = "soghun_shortspines"
		species_allowed = list("Unathi")
		do_colouration = 0

	una_frills_long
		name = "Long Unathi Frills"
		icon_state = "soghun_longfrills"
		species_allowed = list("Unathi")
		do_colouration = 0

	una_frills_short
		name = "Short Unathi Frills"
		icon_state = "soghun_shortfrills"
		species_allowed = list("Unathi")
		do_colouration = 0

	una_horns
		name = "Unathi Horns"
		icon_state = "soghun_horns"
		species_allowed = list("Unathi")
		do_colouration = 0

	skr_tentacle_m
		name = "Skrell Male Tentacles"
		icon_state = "skrell_hair_m"
		species_allowed = list("Skrell")
		gender = MALE
		do_colouration = 0

	skr_tentacle_f
		name = "Skrell Female Tentacles"
		icon_state = "skrell_hair_f"
		species_allowed = list("Skrell")
		gender = FEMALE
		do_colouration = 0

	skr_gold_m
		name = "Gold plated Skrell Male Tentacles"
		icon_state = "skrell_goldhair_m"
		species_allowed = list("Skrell")
		gender = MALE
		do_colouration = 0

	skr_gold_f
		name = "Gold chained Skrell Female Tentacles"
		icon_state = "skrell_goldhair_f"
		species_allowed = list("Skrell")
		gender = FEMALE
		do_colouration = 0

	skr_clothtentacle_m
		name = "Cloth draped Skrell Male Tentacles"
		icon_state = "skrell_clothhair_m"
		species_allowed = list("Skrell")
		gender = MALE
		do_colouration = 0

	skr_clothtentacle_f
		name = "Cloth draped Skrell Female Tentacles"
		icon_state = "skrell_clothhair_f"
		species_allowed = list("Skrell")
		gender = FEMALE
		do_colouration = 0

	taj_ears
		name = "Tajaran Ears"
		icon_state = "ears_plain"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_clean
		name = "Tajara Clean"
		icon_state = "hair_clean"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_bangs
		name = "Tajara Bangs"
		icon_state = "hair_bangs"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_braid
		name = "Tajara Braid"
		icon_state = "hair_tbraid"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_shaggy
		name = "Tajara Shaggy"
		icon_state = "hair_shaggy"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_mohawk
		name = "Tajaran Mohawk"
		icon_state = "hair_mohawk"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_plait
		name = "Tajara Plait"
		icon_state = "hair_plait"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_straight
		name = "Tajara Straight"
		icon_state = "hair_straight"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_long
		name = "Tajara Long"
		icon_state = "hair_long"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_rattail
		name = "Tajara Rat Tail"
		icon_state = "hair_rattail"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_spiky
		name = "Tajara Spiky"
		icon_state = "hair_tajspiky"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_messy
		name = "Tajara Messy"
		icon_state = "hair_messy"
		species_allowed = list("Tajaran")
		do_colouration = 0

	vox_quills_short
		name = "Short Vox Quills"
		icon_state = "vox_shortquills"
		species_allowed = list("Vox")

/datum/sprite_accessory/facial_hair

	taj_sideburns
		name = "Tajara Sideburns"
		icon_state = "facial_mutton"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_mutton
		name = "Tajara Mutton"
		icon_state = "facial_mutton"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_pencilstache
		name = "Tajara Pencilstache"
		icon_state = "facial_pencilstache"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_moustache
		name = "Tajara Moustache"
		icon_state = "facial_moustache"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_goatee
		name = "Tajara Goatee"
		icon_state = "facial_goatee"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_smallstache
		name = "Tajara Smallsatche"
		icon_state = "facial_smallstache"
		species_allowed = list("Tajaran")
		do_colouration = 0

/datum/sprite_accessory/facial_detail
	icon = 'icons/mob/Human_face.dmi'

	species_allowed = list("Human", "Child", "Femboy", "Midget", "Zombie", "Zombie Child")

	burnface_r
		name = "Right side burnt"
		icon_state = "burnface_right"
		do_colouration = 0
		gender = MALE
	burnface_l
		name = "Left side burnt"
		icon_state = "burnface_left"
		do_colouration = 0
		gender = MALE

	fburnface_r
		name = "Right side burnt"
		icon_state = "fburnface_right"
		do_colouration = 0
		gender = FEMALE
	fburnface_l
		name = "Left side burnt"
		icon_state = "fburnfaceleft"
		do_colouration = 0
		gender = FEMALE

	eyeshade
		name = "Eye shade"
		icon_state = "eyeshade"
		do_colouration = 1

	scar
		name = "face scar"
		icon_state = "scar1"
		do_colouration = 1

	scar2
		name = "face scar 2"
		icon_state = "scar2"
		do_colouration = 1

	blush
		name = "face blush"
		icon_state = "blush"
		do_colouration = 1

	eyeshadow
		name = "eye shadow"
		icon_state = "eyeshadow"
		do_colouration = 1

	eyebrows
		name = "eye brows"
		icon_state = "eyebrows"
		do_colouration = 1

	heterochromia
		name = "heterochromia"
		icon_state = "heterochromia"
		do_colouration = 1
		gender = MALE

	fheterochromia
		name = "female heterochromia"
		icon_state = "fheterochromia"
		do_colouration = 1
		gender = FEMALE

	lipstick
		name = "lipstick"
		icon_state = "lipstick"
		do_colouration = 1
		gender = MALE

	flipstick
		name = "lipstick"
		icon_state = "flipstick"
		do_colouration = 1
		gender = FEMALE

	warpaint
		name = "warpaint"
		icon_state = "warpaint"
		do_colouration = 1


	greatbrows
		name = "greatbrows"
		icon_state = "greatbrows"
		do_colouration = 1

	warpaint2
		name = "warpaint 2"
		icon_state = "warpaint2"
		do_colouration = 1

	warpaint3
		name = "warpaint 3"
		icon_state = "warpaint3"
		do_colouration = 1

	none
		name = "none"
		icon_state = "none"
		do_colouration = 0

//skin styles - WIP
//going to have to re-integrate this with surgery
//let the icon_state hold an icon preview for now
/datum/sprite_accessory/skin
	icon = 'icons/mob/human_races/r_human.dmi'

	human
		name = "Default human skin"
		icon_state = "default"
		species_allowed = list("Human")

	human_tatt01
		name = "Tatt01 human skin"
		icon_state = "tatt1"
		species_allowed = list("Human")

	tajaran
		name = "Default tajaran skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_tajaran.dmi'
		species_allowed = list("Tajaran")

	unathi
		name = "Default Unathi skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_lizard.dmi'
		species_allowed = list("Unathi")

	skrell
		name = "Default skrell skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_skrell.dmi'
		species_allowed = list("Skrell")
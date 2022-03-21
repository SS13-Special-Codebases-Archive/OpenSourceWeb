var/list/clients = list()							//list of all clients
var/list/admins = list()							//list of all clients whom are admins
var/list/directory = list()							//list of all ckeys with associated client

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

var/global/list/player_list = list()				//List of all mobs **with clients attached**. Excludes /mob/new_player
var/global/list/mob_list = list()					//List of all mobs, including clientless
var/global/list/living_mob_list = list()			//List of all alive mobs, including clientless. Excludes /mob/new_player
var/global/list/dead_mob_list = list()				//List of all dead mobs, including clientless. Excludes /mob/new_player
var/global/list/gink_last_names = list("Yang","Chi","Chang","Zhao","Huang","Tong","Liao","Qin","Qing","Ming","Wei","Jin","Xia","Yuan","Tang","Sui")

var/global/list/cable_list = list()					//Index for all cables, so that powernets don't have to look through the entire world all the time
var/global/list/chemical_reactions_list				//list of all /datum/chemical_reaction datums. Used during chemical reactions
var/global/list/chemical_reagents_list				//list of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
var/global/list/landmarks_list = list()				//list of all landmarks created
var/global/list/lumosoviks_list = list()				//list of all lumosoviks created
var/global/list/dirt_gen_list = list()				//list of all lumosoviks created
var/global/list/surgery_steps = list()				//list of all surgery steps  |BS12
var/global/list/side_effects = list()				//list of all medical sideeffects types by thier names |BS12
var/global/list/mechas_list = list()				//list of all mechs. Used by hostile mobs target tracking.
var/global/list/vending_list = list()				//LWVEND LIST
//Languages/species/whitelist.
var/global/list/all_species[0]
var/global/list/all_languages[0]
var/global/list/language_keys[0]					//table of say codes for all languages
var/global/list/whitelisted_species = list("Human")
var/global/list/in_character_filter = list()
// Posters
var/global/list/datum/poster/poster_designs = typesof(/datum/poster) - /datum/poster

//Preferences stuff
	//Hairstyles
var/global/list/hair_styles_list = list()			//stores /datum/sprite_accessory/hair indexed by name
var/global/list/hair_styles_male_list = list()
var/global/list/hair_styles_female_list = list()
var/global/list/facial_hair_styles_list = list()	//stores /datum/sprite_accessory/facial_hair indexed by name
var/global/list/facial_hair_styles_male_list = list()
var/global/list/facial_hair_styles_female_list = list()
var/global/list/facial_details_list     = list()
var/global/list/facial_details_male_list     = list()
var/global/list/facial_details_female_list     = list()

var/global/list/skin_styles_female_list = list()		//unused
	//Underwear
var/global/list/underwear_m = list("None") //Curse whoever made male/female underwear diffrent colours
var/global/list/underwear_f = list("None")
var/global/list/vices = list("Kleptomaniac","Photographer","Addict (Kisses)","Smoker", "Sexoholic", "Necrophile", "Alcoholic","Masochist","Pyromaniac","Sensitivity", "Pothead", "Addict (Heroin)", "Addict (Buffout)","Addict (Mentats)","Addict (Stimulants)","Voyeur", "Disability (No Right Eye)", "Disability (No Left Eye)")
	//Backpacks
var/global/list/backbaglist = list("Nothing")

var/global/list/table_recipes = list()

var/global/list/lightflickersounds = list('light_flicker101.ogg','light_flicker102.ogg','light_flicker103.ogg','light_flicker104.ogg','light_flicker105.ogg','light_flicker106.ogg','light_flicker107.ogg','light_flicker108.ogg','light_flicker109.ogg',
'light_flicker110.ogg','light_flicker111.ogg','light_flicker112.ogg','light_flicker113.ogg','light_flicker114.ogg','light_flicker115.ogg','light_flicker116.ogg','light_flicker117.ogg','light_flicker118.ogg','light_flicker119.ogg','light_flicker120.ogg',
'light_flicker121.ogg','light_flicker122.ogg','light_flicker123.ogg','light_flicker124.ogg')
//////////////////////////
/////Initial Building/////
//////////////////////////

/hook/startup/proc/makeDatumRefLists()
	var/list/paths

	//Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	hair_styles_male_list += H.name
			if(FEMALE)	hair_styles_female_list += H.name
			else
				hair_styles_male_list += H.name
				hair_styles_female_list += H.name

	//Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	facial_hair_styles_male_list += H.name
			if(FEMALE)	facial_hair_styles_female_list += H.name
			else
				facial_hair_styles_male_list += H.name
				facial_hair_styles_female_list += H.name


	paths = typesof(/datum/sprite_accessory/facial_detail) - /datum/sprite_accessory/facial_detail
	for(var/path in paths)
		var/datum/sprite_accessory/facial_detail/H = new path()
		facial_details_list[H.name] = H
		switch(H.gender)
			if(MALE)	facial_hair_styles_male_list += H.name
			if(FEMALE)	facial_hair_styles_female_list += H.name
			else
				facial_hair_styles_male_list += H.name
				facial_hair_styles_female_list += H.name



	//Surgery Steps - Initialize all /datum/surgery_step into a list
	paths = typesof(/datum/surgery_step)-/datum/surgery_step
	for(var/T in paths)
		var/datum/surgery_step/S = new T
		surgery_steps += S
	sort_surgeries()

	//Medical side effects. List all effects by their names
	paths = typesof(/datum/medical_effect)-/datum/medical_effect
	for(var/T in paths)
		var/datum/medical_effect/M = new T
		side_effects[M.name] = T


	//Languages and species.
	paths = typesof(/datum/language)-/datum/language
	for(var/T in paths)
		var/datum/language/L = new T
		all_languages[L.name] = L

	for (var/language_name in all_languages)
		var/datum/language/L = all_languages[language_name]
		language_keys[":[lowertext(L.key)]"] = L
		language_keys[".[lowertext(L.key)]"] = L
		language_keys["#[lowertext(L.key)]"] = L

	var/rkey = 0
	paths = typesof(/datum/species)-/datum/species
	for(var/T in paths)
		rkey++
		var/datum/species/S = new T
		S.race_key = rkey //Used in mob icon caching.
		all_species[S.name] = S

		if(S.flags & IS_WHITELISTED)
			whitelisted_species += S.name

	return 1

/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in chemical_reactions_list)
		. += "chemical_reactions_list\[\"[reaction]\"\] = \"[chemical_reactions_list[reaction]]\"\n"
		if(islist(chemical_reactions_list[reaction]))
			var/list/L = chemical_reactions_list[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	world << .
*/
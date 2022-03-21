/datum/species/human/alien
	name = "Alien"
	name_plural = "Aliens"

	default_language = "Hivemind"
	language = "Hivemind"
	unarmed_type = /datum/unarmed_attack/claws/strong
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong
//	hud_type = /datum/hud_data/alien

	has_fine_manipulation = 0
	insulated = 1

	brute_mod = 0.5 // Hardened carapace.
	burn_mod = 2    // Weak to fire.

	warning_low_pressure = 50
	hazard_low_pressure = -1

	eyes = null

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	flags = NO_BREATHE | NO_SCAN | NO_SLIP | NO_POISON | NO_PAIN

	minheightm = 210
	maxheightm = 250
	minheightf = 211
	maxheightf = 260

	icobase = 'icons/mob/human_races/r_alien.dmi'
	deform = 'icons/mob/human_races/r_alien.dmi'

	reagent_tag = IS_XENOS

	blood_color = "#552f9c"
	flesh_color = "#282846"
	gibbed_anim = "gibbed-a"


	breath_type = null
	poison_type = null

/datum/species/human/alien/handle_post_spawn(var/mob/living/carbon/human/H)
	H.density = 1
	H.verbs += /mob/living/carbon/human/proc/plantWeeds
	H.verbs += /mob/living/carbon/human/proc/plantEgg
	if(H.client)
		H.hud_used.instantiate()
		H.overlay_fullscreen("ghost", /obj/screen/fullscreen/screamer_overlay, 3)
	var/datum/organ/internal/brain = H.internal_organs_by_name["brain"]
	if(brain)
		brain.min_broken_damage = 90
		brain.min_bruised_damage = 30
	H?.my_stats.st = rand(12,13)
	H?.my_stats.ht = rand(19,21)
	H?.my_skills.CHANGE_SKILL(SKILL_MELEE, rand(8,9))
	H?.my_skills.CHANGE_SKILL(SKILL_CLIMB, rand(9,10))
	H.overlays_standing[3]	= null
	H.nutrition = 600
	H.special = null
	H.vice = null
	H.viceneed = 0
	H.add_perk(/datum/perk/ref/slippery)
	H.add_perk(/datum/perk/ref/jumper)
	H.name = "Alien"
	H.real_name = "Alien"
	H.can_reflect = FALSE
	H.religion = "None"
	H.mind.alien = new()
	H.mind.alien.last_egg = world.time
	H.status_flags &= ~CANSTUN
	H.status_flags &= ~CANWEAKEN
	H.status_flags &= ~CANPARALYSE
	H.mutilate_genitals()
	H.verbs += /mob/living/carbon/human/proc/plantWeeds
	H.verbs += /mob/living/carbon/human/proc/plantEgg


/datum/alien
	var/last_spit = 0
	var/last_egg = 0
	var/last_weed = 0

/mob/living/carbon/human/proc/plantWeeds()
	if(!mind?.alien)	return
	if(istype(src?.species, /datum/species/human/alien))
		if(world.time > (mind.alien.last_weed + WEED_DELAY))
			new /obj/structure/stool/bed/weeds/node(loc)
			src.visible_message("<span class='hitbold'>[src.name]</span> <span class='hit'>plants</span> <span class='hit'>gooey mass!</span> ")
			playsound(src.loc, pick('alien_creep.ogg', 'alien_creep2.ogg'), 50, 1)
			mind.alien.last_weed = world.time + WEED_DELAY

/mob/living/carbon/human/proc/plantEgg()
	if(!mind?.alien)	return
	if(world.time > (mind.alien.last_egg + EGG_DELAY))
		return
	if(locate(/obj/effect/alien/egg) in get_turf(src))
		to_chat(src, "<span class = 'combat'>There's already an egg here.</span>")
		return
	if(!locate(/obj/structure/stool/bed/weeds) in get_turf(src))
		to_chat(src, "<span class = 'combat'>There must be weeds here.</span>")
		return
	mind.alien.last_egg = world.time + EGG_DELAY
	src.visible_message("<span class='hitbold'>[src.name]</span> <span class='hit'>lays</span> <span class='hit'>a strange egg!</span> ")
	new /obj/effect/alien/egg(loc)
	playsound(src.loc, pick('alien_creep.ogg', 'alien_creep2.ogg'), 50, 1)
	return

/mob/living/carbon/human/examine()
	if(istype(src?.species, /datum/species/human/alien))
		if(src.stat != DEAD)
			to_chat(usr, "<span class='combat'>OH [uppertext(god_text())]!</span>")
			usr << sound(pick('alien_examine1.ogg','alien_examine2.ogg','alien_examine3.ogg','alien_examine4.ogg','alien_examine5.ogg'), repeat = 0, wait = 0, volume = usr?.client?.prefs?.ambi_volume, channel = 23)
	..()
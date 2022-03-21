/mob/living/carbon/alien

	name = "???"
	desc = "What IS this?"
	icon = 'icons/mob/alien.dmi'
	icon_state = "lfwb_larva"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	melee_damage_lower = 1
	melee_damage_upper = 3
	attacktext = ""
	attack_sound = null
	friendly = ""
	wall_smash = 0
	health = 100
	maxHealth = 100
	density = 0

	var/dead_icon = "lfwb_larva2"
	var/amount_grown = 0
	var/max_grown = 10
	var/time_of_birth
	var/language
	var/evolve_time = 120

/mob/living/carbon/alien/New()

	time_of_birth = world.time

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src

	real_name = name
	regenerate_icons()

	if(language)
		add_language(language)

	gender = NEUTER

	..()

/mob/living/carbon/alien/u_equip(obj/item/W as obj)
	return

/mob/living/carbon/alien/restrained()
	return 0

/mob/living/carbon/alien/show_inv(mob/user as mob)
	return //Consider adding cuffs and hats to this, for the sake of fun.

/mob/living/carbon/alien/can_use_vents()
	return

/mob/living/carbon/alien/say()
	return
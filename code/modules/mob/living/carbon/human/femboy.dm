/datum/species/human/femboy //fetishweb
	name = "Femboy"
	name_plural = "Femboys"
	total_health = 80
	icobase = 'icons/mob/human_races/ff_human.dmi'


/datum/species/human/femboy/handle_post_spawn(var/mob/living/carbon/human/H)
	H.mutations.Cut()
	if(H.f_style)
		H.f_style = "Shaved"
	H.gender = FEMALE //sssh
	to_chat(H, "<span class='erpbold'><big>I am secretly a man!</big></span>")
	return ..()


/mob/living/carbon/human/proc/isFemboy()//Used to tell if someone is scum (a Femboy).
	if(species && species.name == "Femboy")
		return 1
	else
		return 0

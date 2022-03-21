/mob/living/puppeteer
	icon = 'icons/monsters/critter.dmi'
	icon_state = "puppeteer"
	name = "Puppeteer"

/mob/living/puppeteer/death()
	.=..()
	for(var/mob/living/carbon/human/skinless/S in mob_list)
		S.death()
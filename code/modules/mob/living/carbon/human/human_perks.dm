/datum/perk/
	var/name = "Perk"
	var/description = "Description"
	var/reflectmessage = "Nothing!"

/datum/perk/proc/pick_perk(var/list/current_perks)
	var/perks
	if(length(current_perks))
		perks = pick(subtypesof(/datum/perk/) - current_perks)
	else
		perks = pick(subtypesof(/datum/perk/))
	if (perks)
		var/perk = new perks
		return perk
	else
		warning("erro na perk de alguem ai")

/datum/perk/proc/pick_perk_ref(var/list/current_perks)
	var/perks
	if(length(current_perks))
		perks = pick(subtypesof(/datum/perk/ref) - current_perks)
	else
		perks = pick(subtypesof(/datum/perk/ref))
	if (perks)
		var/perk = new perks
		return perk
	else
		warning("erro na perk de alguem ai")

/mob/living/carbon/human/proc/add_perk(var/datum/perk/perkpath)
	var/datum/perk/perkpaths = new perkpath(src.perks)
	src.perks.Add(perkpaths)

/mob/living/carbon/human/proc/check_perk(var/datum/perk/perkpath)
	for(var/datum/perk/P in src.perks)
		if(istype(P, perkpath))
			return 1
	return 0

/datum/perk/illiterate
	name = "Illiterate"
	description = "I'm proudly illiterate."

/datum/perk/ref/teaching
	name = "Teaching"
	description = "Teaching is for me."
	reflectmessage = "I learned how to teach."

/datum/perk/docker
	name = "Docker"
	description = "I can carry heavy weights."

/datum/perk/likeart
	name = "Likeart"
	description = "I like art."

/datum/perk/morestamina
	name = "Morestamina"
	description = "I have more stamina than other people."

/datum/perk/lessstamina
	name = "Lessstamina"
	description = "I have less stamina than other people."

/datum/perk/screamerimmunity
	name = "Screamerimmunity"
	description = "I am immune to screamer infections."

/datum/perk/ref/value
	name = "Value"
	description = "I know the value of things."
	reflectmessage = "I now know how to estimate a item's value."

/datum/perk/pathfinder
	name = "Pathfinder"
	description = "I'm good at navigation."

/datum/perk/singer
	name = "Singer"
	description = "I'm a good singer."

/datum/perk/heroiceffort
	name = "HeroicEffort"
	description = "I can perform heroic efforts."

/datum/perk/ref/strongback
	name = "Strongback"
	description = "I have a strong back."
	reflectmessage = "I now have a strong back."

/datum/perk/ref/disarm
	name = "Disarm"
	description = "I love to disarm."
	reflectmessage = "I love to disarm."

/datum/perk/ref/slippery
	name = "Slippery"
	description = "I'm slippery."
	reflectmessage = "I am now slippery, it's easier to escape from grabs."

/datum/perk/ref/jumper
	name = "Jumper"
	description = "I'm such a jumper."
	reflectmessage = "I'm such a jumper, I can now jump 5 tiles away!"

/datum/perk/interrogate
	name = "Interrogate"
	description = "They notice my questions."

/datum/perk/sexaddict
	name = "Sexaddict"
	description = "I am obsessed with sex."

/datum/perk/ref/cavetravel
	name = "cavetravel"
	description = "I know how to travel the caves fast."
	reflectmessage = "I know how to travel the caves fast."

/datum/perk/ref/traptard
	name = "traptard"
	description = "Traps only catch retards."
	reflectmessage = "Traps only catch retards!"

/datum/perk/ref/warlock
	name = "warlock"
	description = "I am safe from padlas."
	reflectmessage = "The warlock was watching you, he won't harm you anymore."

/datum/perk/ref/silent
	name = "silent"
	description = "I am silent."
	reflectmessage = "I am silent, nobody can hear my footsteps."

/datum/perk/ancitech
	name = "ancitech"
	description = "I know about ancient technologies."

/datum/perk/shoemaking
	name = "shoemaking"
	description = "I know how to make shoes."

/datum/perk/chemical
	name = "chemical"
	description = "I know how to mix chemicals."

/datum/perk/bees
	name = "bees"
	description = "I know bees."

/datum/perk/bee_queen
	name = "bee_queen"
	description = "I know that bees loves me."

/datum/perk/gemcutting
	name = "gemcutting"
	description = "I know gems."

/mob/living/carbon/human/proc/reflectexperience()
	set name = "ReflectExperience"
	if(reflectneed < 700)
		return
	if(stat == DEAD)
		to_chat(src, "<span class='combat'>I am dead!</span>")
		return
	if(stat != 1 && reflectneed >= 740)
		to_chat(src, "<span class='combat'>I need to find a bed.</span>")
		return
	if(!buckled)
		to_chat(src, "<span class='combat'>[pick(nao_consigoen)] I need to sleep on a bed.</span>")
		return
	if(stat == 1 && reflectneed >= 740 && istype(buckled, /obj/structure/stool/bed))
		src.gainWP(1,1)
		src.reflectneed = 0
		if(src.species.name == "Child" && prob(10))
			to_chat(src, "Exposure to the Lifeweb's radiation has caused you to age faster.")
			src.set_species("Human")
		else if(prob(10))
			add_random_stat()
			return
		else
			var/list/ablePerks = list()
			for(var/F in subtypesof(/datum/perk/ref))
				var/datum/perk/habilidade = F
				if(habilidade in src.perks) continue
				ablePerks.Add(habilidade)
			var/perkPath = pick(ablePerks)
			if(!perkPath)
				add_random_stat()
				return
			var/datum/perk/P = new perkPath

			to_chat(src, "<span class='malfunction'><b>[P.reflectmessage]</b></span>")
			src.perks.Add(P)
		return

/mob/living/carbon/human/proc/add_random_stat()
	var/random_stat = pick(STAT_ST, STAT_DX, STAT_HT, STAT_PR, STAT_IN, STAT_IM)
	switch(random_stat)
		if(STAT_ST)
			to_chat(src, "<span class='malfunction'><b>As time went on, you got stronger.</b></span>")
			my_stats.initst += 1
			my_stats.st += 1
		if(STAT_DX)
			to_chat(src, "<span class='malfunction'><b>You've become more agile over time.</b></span>")
			my_stats.initdx += 1
			my_stats.dx += 1
		if(STAT_HT)
			to_chat(src, "<span class='malfunction'><b>As time goes by, you've grown tougher.</b></span>")
			my_stats.initht += 1
			my_stats.ht += 1
		if(STAT_PR)
			to_chat(src, "<span class='malfunction'><b>Over time you have become more attentive.</b></span>")
			my_stats.initpr += 1
			my_stats.pr += 1
		if(STAT_IN)
			to_chat(src, "<span class='malfunction'><b>You've gotten smarter over time.</b></span>")
			my_stats.initit += 1
			my_stats.it += 1
		if(STAT_IM)
			to_chat(src, "<span class='malfunction'><b>Over time, your immune system has improved.</b></span>")
			my_stats.initim += 1
			my_stats.im += 1
/mob/living/simple_animal/grue
	name = "grue"
	icon = 'icons/mob/mob.dmi'
	icon_state = "grue"
	icon_dead = "grue"
	icon_living = "grue"
	density = 0
	layer = 3
	canmove = 0
	anchored = 1
	appearance_flags = NO_CLIENT_COLOR
	invisibility = INVISIBILITY_OBSERVER

/mob/living/simple_animal/grue/Crossed(mob/M)
	var/turf/T = get_turf(src)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(H.stat != CONSCIOUS)
		return
	if(H?.isVampire)
		return
	if(H?.mind.changeling)
		return
	if(iszombie(H))
		return
	if(T.luminosity)
		return
	var/datum/organ/internal/heart/HE = locate() in H.internal_organs
	if(HE)
		H << 'grue_kill.ogg'
		H.emote("cough")
		to_chat(H, "<h2><span class='bname'>You have been eaten by a grue!</span></h2>")
		HE.heart_attack()
		gruevictims += 1
	else
		return


/mob/living/simple_animal/grue/Life()
	var/turf/T = get_turf(src)
	if(T.luminosity)
		Die()
	var/list/walkableTurfs = list()
	for(var/dir in cardinal)
		var/turf/simulated/TT = get_step(src, dir)
		if(TT.luminosity) continue
		walkableTurfs.Add(TT)
	if(walkableTurfs.len)
		step(src, pick(walkableTurfs))

/mob/living/simple_animal/grue/Die()
	living_mob_list -= src
	dead_mob_list += src
	stat = DEAD
	density = 0
	playsound(src.loc, pick('grue1.ogg','grue2.ogg','grue3.ogg','grue4.ogg'), 100, 0)
	qdel(src)
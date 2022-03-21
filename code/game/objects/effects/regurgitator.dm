/obj/effect/regurgitator
	name = "Regurgitador"
	desc = "I Better stay away from that thing."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/mob/critter.dmi'
	icon_state = "regugriator"
	var/triggerproc = "catchperson" //name of the proc thats called when the mine is triggered
	var/catched
	var/mob/living/buckled_mob

/obj/effect/regurgitator/New()
	icon_state = "regugriator"

/obj/effect/regurgitator/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
		buckled_mob = null
		catched = 0
	return

/obj/effect/regurgitator/Crossed(mob/living/carbon/human/M as mob|obj)
	if(ismonster(M))
		return
	if(ishuman(M))
		catchperson(M)

/obj/effect/regurgitator/proc/buckle_mob()
	if(!buckled_mob)
		for(var/mob/living/carbon/V in src.loc)
			if(V.buckled != src) //if mob not dead or captured
				V.buckled = src
				V.loc = src.loc
				V.update_canmove()
				src.buckled_mob = V
				break //only capture one mob at a time.

/obj/effect/regurgitator/proc/catchperson(var/mob/AM)
	var/mob/living/carbon/human/H = AM
	playsound(H.loc, pick('reg_eat1.ogg','reg_eat2.ogg'), 40, 0, -1)
	catched = H
	src.buckle_mob(H)
	if(prob(70))
		H.emote("scream")
	if(H.special == "weirdregurgi")
		H.add_event("came", /datum/happiness_event/regurgipleasure)
	spawn(100)
		if(!isturf(AM.loc)){
			return
		}

		var/regurg = 0
		for(var/obj/effect/regurgitator/R in AM.loc.contents){
			regurg = 1
		}
		if(catched && regurg)
			if(prob(35))
				var/chosenOrgan = "l_leg"
				var/chosenOrgan2 = "r_leg"
				H.apply_damage(150	, BRUTE, chosenOrgan)
				H.apply_damage(150	, BRUTE, chosenOrgan2)
				H.buckled.manual_unbuckle(H)
				src.unbuckle()
				H.buckled = initial(H.buckled)
				playsound(H.loc, 'sound/weapons/bite.ogg', 100, 1)
			else
				playsound(H.loc, pick('reg_eat1.ogg','reg_eat2.ogg'), 60, 0, -1)
				H.buckled = initial(H.buckled)
				src.unbuckle()
				if(H.stat != DEAD && H.client)
					H.client.ChromieWinorLoose(H.client, -1)
				if(prob(70))
					H.emote("scream")
				H.death()
				qdel(H)
				qdel(AM)

/obj/effect/regurgitator/proc/manual_unbuckle(mob/living/carbon/human/user as mob)
	if(buckled_mob)
		if(do_after(user, 10))
			if(prob(15))
				if(buckled_mob.buckled == src)
					if(buckled_mob != user)
						buckled_mob.visible_message(\
							"<span class='notice'>[user.name] frees [buckled_mob.name] from the regurgitator.</span>",\
							"<span class='notice'>[user.name] frees you from the regurgitator.</span>",\
							"<span class='warning'>You hear shredding and ripping.</span>")
					else
						buckled_mob.visible_message(\
							"<span class='notice'>[buckled_mob.name] struggles free of the regurgitator.</span>",\
							"<span class='notice'>You release yourself from the regurgitator.</span>",\
							"<span class='warning'>You hear shredding and ripping.</span>")
				unbuckle()
				buckled_mob.buckled = initial(buckled_mob.buckled)
			else
				user.visible_message(\
					"<span class='notice'>[buckled_mob.name] fails to escape.</span>",\
					"<span class='notice'>You fail to help [buckled_mob.name] escape.</span>",\
					"<span class='warning'>You hear shredding and ripping.</span>")
				if(prob(70))
					buckled_mob.emote("scream")
	return

/obj/effect/regurgitator/attack_hand(mob/user as mob)
	manual_unbuckle(user)
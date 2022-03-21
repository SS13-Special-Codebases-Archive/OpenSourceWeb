/obj/structure/stool/bed/chair/pillory
	name = "pillory"
	icon = 'icons/obj/pillory.dmi'
	icon_state = "pillory_a"
	desc = ""
	density = 0
	flammable = 0
	anchored = 1

/obj/structure/stool/bed/chair/cross
	name = "cross"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "ecross"
	desc = ""
	density = 0
	anchored = 1

/obj/structure/stool/bed/chair/cross/proc/LifewebChecks(mob/living/carbon/human/M as mob, mob/user as mob)
	if (!ticker)
		return

	if(M.species.name == "Skeleton")
		return
	if(istype(M.species, /datum/species/human/alien))
		return

	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	for(var/obj/O in M.contents)
		if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/organ))
			continue

		else if(istype(O, /obj/item/weapon/storage/touchable/organ))
			continue
		else
			to_chat(user, "The victim needs to be fully naked.")
			return

	if (M.isChild())
		to_chat(user, "How dumb am i?")
		return

	if (M == usr)
		to_chat(user, "I feel stupid.")
		return

	return 1


/obj/structure/stool/bed/chair/cross/manual_unbuckle(mob/user as mob)
	return


/obj/structure/stool/bed/chair/cross/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		var/mob/living/carbon/human/H = G.affecting
		if(istype(H.species, /datum/species/human/alien))
			return
		H.forceMove(src.loc)
		buckle_mob(H, G.assailant)
	..()

/obj/structure/stool/bed/chair/cross/buckle_mob(mob/living/carbon/human/M as mob, mob/user as mob)
	if(LifewebChecks(M, user))
		M.visible_message("<B>[M.name]</B> is locked on the [src]!")
		playsound(src.loc, pick('lw_sacrificed1.ogg','lw_sacrificed2.ogg','lw_sacrificed3.ogg','lw_sacrificed4.ogg'), 100, 0, -1)
	else
		return

	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	buckled_mob = M
	M.update_canmove()

	src.add_fingerprint(user)

	M.lifeweb_locked = TRUE
	M.add_lifewebchain()

	M.update_icons()
	M.update_body()

/////////////////////
///BAILE DA GAIOLA///
/////////////////////

/obj/structure/stool/bed/chair/cage
	name = "cage"
	icon = 'icons/obj/miscobjs.dmi'
	icon_state = "cage_open"
	desc = ""
	density = 0
	pixel_y = 0
	anchored = 1

	var/open = 0
	var/locked = 0

	layer = 5
	plane = 10

/obj/effect/cagebehind
	name = "cage"
	icon = 'icons/obj/miscobjs.dmi'
	icon_state = "cage_behind"
	desc = ""
	density = 0
	anchored = 1
	mouse_opacity = FALSE
	layer = 2

/obj/structure/stool/bed/chair/cage/New()
	..()
	underlays += /obj/effect/cagebehind
	updatestate()

/obj/structure/stool/bed/chair/cage/examine(mob/user)
	..()
	if(locked)
		to_chat(user, "It appears locked")
		return

/obj/structure/stool/bed/chair/cage/proc/updatestate()
	if(!open)
		icon_state="cage_closed"
		density = 1
		layer = 5
		plane = 10
		return
	icon_state="cage_open"
	density = 0
	layer = 4
	plane = 0
	return

/obj/structure/stool/bed/chair/cage/attack_hand(mob/user)
	if(!ishuman(user))
		return
	if(open)
		if(!closeact())
			return
		open = 0
		density = 1
		layer = 5
		plane = 10
		updatestate()
		return

	if(!openact())
		return
	open = 1
	density = 0
	layer = 4
	plane = 0
	updatestate()

/obj/structure/stool/bed/chair/cage/proc/openact()
	if(locked)
		return

	if(!buckled_mob)
		return 1
	if(!ishuman(buckled_mob))
		return
	var/mob/living/carbon/human/H = buckled_mob
	H.anchored = null
	H.buckled = null
	buckled_mob = null
	unbuckle()
	H.update_canmove()
	H.update_icons()
	H.update_body()
	return 1

/obj/structure/stool/bed/chair/cage/proc/closeact()
	var/list/tobebuckled = list()
	for(var/mob/living/carbon/human/H in loc.contents)
		tobebuckled += H

	if(!tobebuckled.len)
		return 1

	if(tobebuckled.len > 1)
		return
	if(!ishuman(tobebuckled[1]))
		return

	var/mob/living/carbon/human/victim = tobebuckled[1]
	playsound(loc, 'cage_close.ogg', 85, 0, -1)
	buckled_mob = victim
	victim.buckled = src
	victim.loc = src.loc
	victim.dir = src.dir
	density = 1

	victim.update_canmove()
	src.add_fingerprint(victim)
	victim.update_icons()
	victim.update_body()
	return 1

/obj/structure/stool/bed/chair/cage/RightClick(mob/user)
	..()

	if(open)
		return
	var/turf/allowedTurf = get_step(src, dir)
	if(user.loc == allowedTurf)
		playsound(loc, 'sound/effects/wboltswitch.ogg', 100, 1)
		if(locked)
			locked = 0
			return
		locked = 1
		return

/mob/living/carbon/human/resist()
	..()
	if(istype(loc, /obj/structure/pit))
		var/obj/structure/pit/P = loc
		src.loc = P.loc
		//put a sound in here

	if(istype(anchored, /obj/structure/stool/bed/chair/cage))
		var/obj/structure/stool/bed/chair/cage/C = anchored

		var/amounttomove = rand(-2, 2)
		var/amounttomovehuman = rand(-2, 2)

		C.pixel_x = amounttomove
		C.pixel_y = amounttomovehuman

		pixel_x = amounttomovehuman
		pixel_y = amounttomove
		playsound(loc, pick(list('sound/cage/bars_blade.ogg', 'sound/cage/bars_blade2.ogg')), 15, 1)
		spawn(1)
			C.pixel_x = 0
			C.pixel_y = 0

			pixel_x = 0
			pixel_y = 0

		if(my_stats.st >= 15 || istype(species, /datum/species/human/alien))
			if(prob(10))
				to_chat("<span class='combatbold'>[name] breaks out of the cage!</span>")
				C.locked = 0
				C.open = 1
				C.openact()
				C.updatestate()
				playsound(loc, 'sound/cage/bars_hit.ogg', 100, 1)

//PODERIA TER FEITO TUDO AQUILO LA AQUI EMBAIXO? PODERIA
//MAS NAO DEU VONTADE KKKKKKKKKKKKKKKKKKKKK
/obj/structure/stool/bed/chair/cage/manual_unbuckle(mob/user as mob)
	return

/obj/structure/stool/bed/chair/cage/buckle_mob(mob/living/carbon/human/M as mob, mob/user as mob)
	return
